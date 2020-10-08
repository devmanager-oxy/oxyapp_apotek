package com.project.crm.session;

import java.util.Vector;
import java.util.Date;
import java.sql.ResultSet;
import com.project.main.db.*;
import com.project.general.DbCustomer;
import com.project.general.Customer;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.crm.transaction.*;
import com.project.I_Project;
import com.project.crm.master.DbLot;
import com.project.crm.master.limbah.*;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahBp;
import com.project.crm.sewa.SewaTanahBp;
import com.project.general.SystemDocCode;
import com.project.general.DbSystemDocCode;
import com.project.general.SystemDocNumber;
import com.project.general.DbSystemDocNumber;
import com.project.system.DbSystemProperty;
import com.project.util.YearMonth;
import com.project.util.JSPFormater;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class SessLimbahMonth {

    public static Vector getListLimbah(Periode periode) {
        Vector list = new Vector();

        Vector listiri = DbLimbahTransaction.list(0, 0, DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + "=" + periode.getOID(), "");

        for (int k = 0; k < listiri.size(); k++) {
            LimbahTransaction limbahTransaction = (LimbahTransaction) listiri.get(k);

            LimbahMonth limbahMonth = new LimbahMonth();
            Customer customer = new Customer();
            try {
                customer = DbCustomer.fetchExc(limbahTransaction.getCustomerId());
            } catch (Exception e) {
            }

            limbahMonth.setCustomerOid(customer.getOID());
            limbahMonth.setCustomerName(customer.getName());
            limbahMonth.setBulanIni(limbahTransaction.getBulanIni());
            limbahMonth.setBulanLalu(limbahTransaction.getBulanLalu());
            limbahMonth.setKeterangan(limbahTransaction.getKeterangan());
            limbahMonth.setPersentaseUsed(limbahTransaction.getPercentageUsed());

            double realPakai = 0;
            try {
                double pakai = limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu();
                realPakai = (pakai * limbahTransaction.getPercentageUsed()) / 100;
            } catch (Exception e) {
            }
            limbahMonth.setPemakaian(realPakai);

            list.add(limbahMonth);
        }

        return list;
    }

    public static Vector listLimbahMonth(Periode periode) {
        if (periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN) || periode.getStatus().equals(I_Project.STATUS_PERIOD_PRE_CLOSED) ) {
            return listLimbahMonthRuningPeriode(periode);
        } else {
            return getListLimbah(periode);
        }
    }

    public static Vector listLimbahMonthRuningPeriode(Periode periode) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            // step 1
            //String sql = "SELECT customer_id, name FROM `"+DbCustomer.DB_CUSTOMER+"` where limbah_flag = 1 order by name,type";
            String sql = "SELECT c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] +
                    ", c." + DbCustomer.colNames[DbCustomer.COL_NAME] +
                    ", c." + DbCustomer.colNames[DbCustomer.COL_TYPE] +
                    ", lot." + DbLot.colNames[DbLot.COL_NAMA] +
                    " FROM " + DbCustomer.DB_CUSTOMER + " c INNER JOIN " + DbSewaTanah.DB_CRM_SEWA_TANAH + " st " +
                    " ON c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = st." + DbSewaTanah.colNames[DbSewaTanah.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLot.DB_LOT + " lot ON st." + DbSewaTanah.colNames[DbSewaTanah.COL_LOT_ID] +
                    " = lot." + DbLot.colNames[DbLot.COL_LOT_ID] +
                    " WHERE  st." + DbSewaTanah.colNames[DbSewaTanah.COL_STATUS] + " = " + DbSewaTanah.STATUS_AKTIF +
                    " ORDER BY c." + DbCustomer.colNames[DbCustomer.COL_NAME] +
                    ", c." + DbCustomer.colNames[DbCustomer.COL_TYPE];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Periode prevPeriode = getPreviousPeriod(periode);

            while (rs.next()) {
                LimbahMonth limbahMonth = new LimbahMonth();
                limbahMonth.setCustomerOid(rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]));
                limbahMonth.setCustomerName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME]) + " - " + rs.getString(DbLot.colNames[DbLot.COL_NAMA]));
                limbahMonth.setPeriodeOid(periode.getOID());

                LimbahTransaction prevLimbahTransaction = getLimbahTransaction(limbahMonth.getCustomerOid(), prevPeriode);
                LimbahTransaction limbahTransaction = getLimbahTransaction(limbahMonth.getCustomerOid(), periode);
                if(prevLimbahTransaction.getBulanIni() != 0) limbahMonth.setBulanLalu(prevLimbahTransaction.getBulanIni());
                else limbahMonth.setBulanLalu(limbahTransaction.getBulanLalu());
                
                Limbah limbah = getLimbahRunning(periode.getOID(), rs.getInt(DbCustomer.colNames[DbCustomer.COL_TYPE]));
                
                if (limbahTransaction.getOID() != 0) {
                    limbahMonth.setPersentaseUsed(limbahTransaction.getPercentageUsed());
                    limbahMonth.setKeterangan(limbahTransaction.getKeterangan());
                    limbahMonth.setLimbahOid(limbahTransaction.getOID());
                    limbahMonth.setBulanIni(limbahTransaction.getBulanIni());

                    double realPakai = 0;
                    try {
                        double pakai = limbahMonth.getBulanIni() - limbahMonth.getBulanLalu();
                        realPakai = (pakai * limbahMonth.getPersentaseUsed()) / 100;
                    } catch (Exception e) {
                    }
                    limbahMonth.setPemakaian(realPakai);
                } else {
                    limbahMonth.setPersentaseUsed(limbah.getPercentageUsed());
                    limbahMonth.setLimbahOid(0);
                    limbahMonth.setBulanIni(0);
                    limbahMonth.setPemakaian(0);
                }
                list.add(limbahMonth);
            }

            rs.close();
            return list;
        } catch (Exception e) {
            return new Vector();
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    // proses pencarian data previous periode
    public static Periode getPreviousPeriod(Periode currentPeriod) {
        try {
            Date xDate = currentPeriod.getStartDate();
            Calendar startDate = new GregorianCalendar(xDate.getYear(), xDate.getMonth(), xDate.getDate(), 0, 0, 0);
            startDate.add(Calendar.MONTH, -1);
            
            int day = startDate.get(Calendar.DATE);
            int month = startDate.get(Calendar.MONTH)+1;
            int year = startDate.get(Calendar.YEAR)+1900;
            
            String where = DbPeriode.colNames[DbPeriode.COL_START_DATE]+"='"+year+"-"+(month<10?"0"+month:""+month)+"-"+(day<10?"0"+day:""+day)+"'";
            Vector list = DbPeriode.list(0, 0, where, "");

            Periode periode = new Periode();
            if (list.size() > 0) {
                periode = (Periode) list.get(0);
            }

            return periode;
        } catch (Exception e) {
            return new Periode();
        }
    }

    public static LimbahTransaction getLimbahTransaction(long customerOID, Periode periode) {
        LimbahTransaction limbahTransaction = new LimbahTransaction();

        String where = "period_id=" + periode.getOID() + " and customer_id=" + customerOID;
        Vector list = DbLimbahTransaction.list(0, 0, where, "");

        if (list.size() > 0) {
            limbahTransaction = (LimbahTransaction) list.get(0);
        }

        return limbahTransaction;
    }

    public static Limbah getLimbahRunning(long periodeOid, int priceType) {
        Limbah limbah = new Limbah();
        Vector list = DbLimbah.list(0, 0, "periode_id=" + periodeOid + " AND price_type=" + priceType, "");
        if (list.size() > 0) {
            limbah = (Limbah) list.get(0);
        }
        return limbah;
    }

    public static long insertLimbahTransaction(Vector list) {
        long currencyRp = 0;
        try {
            currencyRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
            currencyRp = 0;
        }

        long hasil = 0;

        if (list.size() > 0) {

            for (int j = 0; j < list.size(); j++) {

                LimbahMonth limbahMonth = (LimbahMonth) list.get(j);

                LimbahTransaction objLimbahTransaction = new LimbahTransaction();
                objLimbahTransaction.setOID(limbahMonth.getLimbahOid());
                objLimbahTransaction.setCustomerId(limbahMonth.getCustomerOid());
                objLimbahTransaction.setBulanIni(limbahMonth.getBulanIni());
                objLimbahTransaction.setBulanLalu(limbahMonth.getBulanLalu());
                objLimbahTransaction.setPeriodId(limbahMonth.getPeriodeOid());
                objLimbahTransaction.setKeterangan(limbahMonth.getKeterangan());
                
                Customer customer = new Customer();
                try {
                    customer = DbCustomer.fetchExc(objLimbahTransaction.getCustomerId());
                } catch(Exception e) {
                }

                Limbah limbah = getLimbahRunning(objLimbahTransaction.getPeriodId(), customer.getType());
                objLimbahTransaction.setMasterLimbahId(limbah.getOID());
                objLimbahTransaction.setHarga(limbah.getRate());
                objLimbahTransaction.setPercentageUsed(limbah.getPercentageUsed());
                objLimbahTransaction.setPostedStatus(0);

                Customer sarana = new Customer();
                try {
                    sarana = DbCustomer.fetchExc(objLimbahTransaction.getCustomerId());
                } catch (Exception e) {

                }

                try {
                    if (limbahMonth.getLimbahOid() != 0) {
                        try {

                            LimbahTransaction limbahTransaction = DbLimbahTransaction.fetchExc(limbahMonth.getLimbahOid());
                            objLimbahTransaction.setInvoiceNumber(limbahTransaction.getInvoiceNumber());
                            objLimbahTransaction.setInvoiceNumberCounter(limbahTransaction.getInvoiceNumberCounter());
                            objLimbahTransaction.setTransactionDate(limbahTransaction.getTransactionDate());
                            objLimbahTransaction.setNomorFp(limbahTransaction.getNomorFp());
                            objLimbahTransaction.setTotalHarga((objLimbahTransaction.getBulanIni() - objLimbahTransaction.getBulanLalu()) * objLimbahTransaction.getHarga() * objLimbahTransaction.getPercentageUsed() / 100);
                            objLimbahTransaction.setPpn(0.1 * objLimbahTransaction.getTotalHarga());
                            objLimbahTransaction.setPpnPercent(10);

                        

                            hasil = DbLimbahTransaction.updateExc(objLimbahTransaction);

                            String whereBpLimbah = DbSewaTanahBp.colNames[DbSewaTanahBp.COL_REFNUMBER] + "='" + limbahTransaction.getInvoiceNumber() + "'";
                            Vector listSwTnhBp = DbSewaTanahBp.list(0, 0, whereBpLimbah, null);

                            Limbah mstLimbah = new Limbah();

                            try {
                                mstLimbah = DbLimbah.fetchExc(objLimbahTransaction.getMasterLimbahId());
                            } catch (Exception e) {
                            }

                            double pemakaian = ((objLimbahTransaction.getBulanIni() - objLimbahTransaction.getBulanLalu()) * objLimbahTransaction.getPercentageUsed()) / 100;
                            double jumlah = pemakaian * objLimbahTransaction.getHarga();
                            double ppn = mstLimbah.getPpnPercent() * jumlah / 100;
                            double totPendapatan = jumlah + ppn;

                            if (listSwTnhBp != null && listSwTnhBp.size() > 0) {

                                SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                try {
                                    sewaTanahBp = (SewaTanahBp) listSwTnhBp.get(0);
                                } catch (Exception e) {
                                }

                                sewaTanahBp.setTanggal(objLimbahTransaction.getTransactionDate());
                                sewaTanahBp.setKeterangan(objLimbahTransaction.getKeterangan());
                                sewaTanahBp.setRefnumber(objLimbahTransaction.getInvoiceNumber());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(totPendapatan);
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setMataUangId(currencyRp);
                                sewaTanahBp.setSewaTanahId(0);
                                sewaTanahBp.setSewaTanahInvId(0);

                                sewaTanahBp.setCustomerId(objLimbahTransaction.getCustomerId());
                                sewaTanahBp.setLimbahTransactionId(hasil);
                                sewaTanahBp.setIrigasiTransactionId(0);

                                try {
                                    long oidSwTanah = DbSewaTanahBp.updateExc(sewaTanahBp);
                                } catch (Exception e) {
                                }

                            } else {

                                SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                sewaTanahBp.setTanggal(objLimbahTransaction.getTransactionDate());
                                sewaTanahBp.setKeterangan(objLimbahTransaction.getKeterangan());
                                sewaTanahBp.setRefnumber(objLimbahTransaction.getInvoiceNumber());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(totPendapatan);
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setMataUangId(currencyRp);
                                sewaTanahBp.setSewaTanahId(0);
                                sewaTanahBp.setSewaTanahInvId(0);
                                sewaTanahBp.setCustomerId(objLimbahTransaction.getCustomerId());
                                sewaTanahBp.setLimbahTransactionId(hasil);
                                sewaTanahBp.setIrigasiTransactionId(0);

                                try {
                                    long oidSwTanah = DbSewaTanahBp.insertExc(sewaTanahBp);
                                } catch (Exception e) {
                                }

                            }


                        } catch (Exception ex) {

                            System.out.println(ex.toString());

                        }

                    } else {
                        int counter = DbSystemDocNumber.getNextCounter(objLimbahTransaction.getPeriodId(), DbSystemDocCode.TYPE_DOCUMENT_LIMBAH);
                        String docPrefix = DbSystemDocNumber.getNumberPrefix(objLimbahTransaction.getPeriodId(), DbSystemDocCode.TYPE_DOCUMENT_LIMBAH);
                        String docNumber = DbSystemDocNumber.getNextNumber(counter, objLimbahTransaction.getPeriodId(), DbSystemDocCode.TYPE_DOCUMENT_LIMBAH);
                        Date today = new Date();
                        
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setPrefixNumber(docPrefix);
                        systemDocNumber.setDocNumber(docNumber);
                        systemDocNumber.setDate(today);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_LIMBAH]);
                        systemDocNumber.setYear(objLimbahTransaction.getTransactionDate().getYear() + 1900);
                        
                        // proses insert Doc Number
                        DbSystemDocNumber.insertExc(systemDocNumber);

                        int days = 1;
                        days = sarana.getDefDueDateDay();
                        
                        objLimbahTransaction.setInvoiceNumberCounter(counter);
                        objLimbahTransaction.setInvoiceNumber(docNumber);
                        objLimbahTransaction.setTransactionDate(today);
                        
                        Date dueDate = new Date();
                        dueDate.setDate(objLimbahTransaction.getTransactionDate().getDate());
                        dueDate.setMonth(objLimbahTransaction.getTransactionDate().getMonth());
                        dueDate.setYear(objLimbahTransaction.getTransactionDate().getYear());
                        objLimbahTransaction.setDueDate(dueDate);
                        objLimbahTransaction.getDueDate().setDate(objLimbahTransaction.getDueDate().getDate() + days);
                        
                        objLimbahTransaction.setTotalHarga((objLimbahTransaction.getBulanIni() - objLimbahTransaction.getBulanLalu()) * objLimbahTransaction.getHarga() * objLimbahTransaction.getPercentageUsed() / 100);
                        objLimbahTransaction.setPpn(0.1 * objLimbahTransaction.getTotalHarga());
                        objLimbahTransaction.setPpnPercent(10);

                      

                        hasil = DbLimbahTransaction.insertExc(objLimbahTransaction);

                        if (hasil != 0) {

                            SewaTanahBp sewaTanahBp = new SewaTanahBp();
                            Limbah mstLimbah = new Limbah();

                            try {
                                mstLimbah = DbLimbah.fetchExc(objLimbahTransaction.getMasterLimbahId());
                            } catch (Exception e) {
                            }

                            double pemakaian = ((objLimbahTransaction.getBulanIni() - objLimbahTransaction.getBulanLalu()) * objLimbahTransaction.getPpnPercent()) / 100;
                            double jumlah = pemakaian * objLimbahTransaction.getHarga();
                            double ppn = mstLimbah.getPpnPercent() * jumlah / 100;
                            double totPendapatan = jumlah + ppn;

                            sewaTanahBp.setTanggal(objLimbahTransaction.getTransactionDate());
                            sewaTanahBp.setKeterangan(objLimbahTransaction.getKeterangan());
                            sewaTanahBp.setRefnumber(objLimbahTransaction.getInvoiceNumber());
                            sewaTanahBp.setMem("-");
                            sewaTanahBp.setDebet(totPendapatan);
                            sewaTanahBp.setCredit(0);
                            sewaTanahBp.setMataUangId(currencyRp);
                            sewaTanahBp.setSewaTanahId(0);
                            sewaTanahBp.setSewaTanahInvId(0);
                            sewaTanahBp.setCustomerId(objLimbahTransaction.getCustomerId());
                            sewaTanahBp.setLimbahTransactionId(hasil);
                            sewaTanahBp.setIrigasiTransactionId(0);

                            long oidStb = DbSewaTanahBp.insertExc(sewaTanahBp);
                        }
                    }

                } catch (Exception e) {
                    System.out.println("ERR >>> : " + e.toString());
                }
            }
        }
        return hasil;
    }
}
