package com.project.crm.session;

import java.util.Date;
import java.util.Vector;
import java.sql.ResultSet;
import com.project.main.db.*;
import com.project.general.DbCustomer;
import com.project.general.Customer;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.crm.transaction.*;
import com.project.I_Project;
import com.project.crm.master.DbLot;
import com.project.crm.master.irigasi.*;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahBp;
import com.project.crm.sewa.SewaTanahBp;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;
import com.project.system.DbSystemProperty;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class SessIrigasiMonth {

    public static Vector getListIrigasi(Periode periode) {
        Vector list = new Vector();

        Vector listiri = DbIrigasiTransaction.list(0, 0, DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + "=" + periode.getOID(), "");

        for (int k = 0; k < listiri.size(); k++) {
            IrigasiTransaction irigasiTransaction = (IrigasiTransaction) listiri.get(k);

            IrigasiMonth irigasiMonth = new IrigasiMonth();
            Customer customer = new Customer();
            try {
                customer = DbCustomer.fetchExc(irigasiTransaction.getCustumerId());
            } catch (Exception e) {
            }

            irigasiMonth.setCustomerOid(customer.getOID());
            irigasiMonth.setCustomerName(customer.getName());
            irigasiMonth.setBulanIni(irigasiTransaction.getBulanIni());
            irigasiMonth.setBulanLalu(irigasiTransaction.getBulanLalu());
            irigasiMonth.setPemakaian(irigasiTransaction.getBulanIni() - irigasiTransaction.getBulanLalu());
            irigasiMonth.setKeterangan(irigasiTransaction.getKeterangan());

            list.add(irigasiMonth);
        }

        return list;
    }

    public static Vector listIrigasiMonth(Periode periode) {
        if (periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN) || periode.getStatus().equals(I_Project.STATUS_PERIOD_PRE_CLOSED)) {
            return listIrigasiMonthRuningPeriode(periode);
        } else {
            return getListIrigasi(periode);
        }
    }

    public static Vector listIrigasiMonthRuningPeriode(Periode periode) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            // step 1
            //String sql = "SELECT customer_id, name FROM " + DbCustomer.DB_CUSTOMER + " where irigasi_flag = 1 order by name,type";
            String sql = "SELECT c."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                                ", c."+DbCustomer.colNames[DbCustomer.COL_NAME]+
                                ", lot."+DbLot.colNames[DbLot.COL_NAMA]+
                                " FROM "+DbCustomer.DB_CUSTOMER+" c INNER JOIN "+DbSewaTanah.DB_CRM_SEWA_TANAH+" st "+
                                " ON c."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = st."+DbSewaTanah.colNames[DbSewaTanah.COL_CUSTOMER_ID]+
                                " INNER JOIN "+DbLot.DB_LOT+" lot ON st."+DbSewaTanah.colNames[DbSewaTanah.COL_LOT_ID]+
                                " = lot."+DbLot.colNames[DbLot.COL_LOT_ID]+
                                " WHERE st."+DbSewaTanah.colNames[DbSewaTanah.COL_STATUS]+" = "+DbSewaTanah.STATUS_AKTIF+
                                " ORDER BY c."+DbCustomer.colNames[DbCustomer.COL_NAME]+
                                ", c."+DbCustomer.colNames[DbCustomer.COL_TYPE];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Periode prevPeriode = getPreviousPeriod(periode);
            while (rs.next()) {
                IrigasiMonth irigasiMonth = new IrigasiMonth();
                irigasiMonth.setCustomerOid(rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]));
                irigasiMonth.setCustomerName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME])+" - "+rs.getString(DbLot.colNames[DbLot.COL_NAMA]));
                irigasiMonth.setPeriodeOid(periode.getOID());

                IrigasiTransaction prevIrigasiTransaction = getIrigasiTransaction(irigasiMonth.getCustomerOid(), prevPeriode);
                IrigasiTransaction irigasiTransaction = getIrigasiTransaction(irigasiMonth.getCustomerOid(), periode);
                if(prevIrigasiTransaction.getBulanIni() != 0) irigasiMonth.setBulanLalu(prevIrigasiTransaction.getBulanIni());
                else irigasiMonth.setBulanLalu(irigasiTransaction.getBulanLalu());

                if (irigasiTransaction.getOID() != 0) {
                    irigasiMonth.setIrigasiOid(irigasiTransaction.getOID());
                    irigasiMonth.setBulanIni(irigasiTransaction.getBulanIni());
                    irigasiMonth.setPemakaian(irigasiMonth.getBulanIni() - irigasiMonth.getBulanLalu());
                    irigasiMonth.setKeterangan(irigasiTransaction.getKeterangan());
                } else {
                    irigasiMonth.setIrigasiOid(0);
                    irigasiMonth.setBulanIni(0);
                    irigasiMonth.setPemakaian(0);
                }
                list.add(irigasiMonth);
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

    public static IrigasiTransaction getIrigasiTransaction(long customerOID, Periode periode) {
        IrigasiTransaction irigasiTransaction = new IrigasiTransaction();

        String where = "period_id=" + periode.getOID() + " and customer_id=" + customerOID;

        Vector list = DbIrigasiTransaction.list(0, 0, where, "");

        if (list.size() > 0) {
            irigasiTransaction = (IrigasiTransaction) list.get(0);
        }
        return irigasiTransaction;
    }

    public static Irigasi getIrigasiRunning(long periodeOid, int priceType) {
        Irigasi irigasi = new Irigasi();
        Vector list = DbIrigasi.list(0, 0, "periode_id=" + periodeOid + " AND price_type=" + priceType, "");
        if (list.size() > 0) {
            irigasi = (Irigasi) list.get(0);
        }
        return irigasi;
    }

    public static long insertIrigasiTransaction(Vector list) {

        long currencyRp = 0;

        try {
            currencyRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
            currencyRp = 0;
        }

        long hasil = 0;

        if (list.size() > 0) {

            for (int j = 0; j < list.size(); j++) {

                IrigasiMonth irigasiMonth = (IrigasiMonth) list.get(j);

                IrigasiTransaction irTransaction = new IrigasiTransaction();
                irTransaction.setOID(irigasiMonth.getIrigasiOid());
                irTransaction.setCustumerId(irigasiMonth.getCustomerOid());
                irTransaction.setBulanIni(irigasiMonth.getBulanIni());
                irTransaction.setBulanLalu(irigasiMonth.getBulanLalu());
                irTransaction.setPeriodId(irigasiMonth.getPeriodeOid());
                irTransaction.setKeterangan(irigasiMonth.getKeterangan());
                
                Customer customer = new Customer();
                try {
                    customer = DbCustomer.fetchExc(irigasiMonth.getCustomerOid());
                } catch(Exception e) {}

                Irigasi irigasi = getIrigasiRunning(irTransaction.getPeriodId(), customer.getType());
                irTransaction.setMasterIrigasiId(irigasi.getOID());
                irTransaction.setHarga(irigasi.getRate());
                irTransaction.setPostStatus(0);

                Customer sarana = new Customer();
                try {
                    sarana = DbCustomer.fetchExc(irTransaction.getCustumerId());
                } catch (Exception e) {

                }

                try {
                    if (irigasiMonth.getIrigasiOid() != 0) {
                        try {
                            IrigasiTransaction irigasiTransaction = DbIrigasiTransaction.fetchExc(irigasiMonth.getIrigasiOid());
                            irTransaction.setInvoiceNumber(irigasiTransaction.getInvoiceNumber());
                            irTransaction.setInvoiceNumberCounter(irigasiTransaction.getInvoiceNumberCounter());
                            irTransaction.setTransactionDate(irigasiTransaction.getTransactionDate());
                            irTransaction.setNomorFp(irigasiTransaction.getNomorFp());

                            irTransaction.setTotalHarga((irTransaction.getBulanIni() - irTransaction.getBulanLalu()) * irTransaction.getHarga());
                            irTransaction.setPpn(0.1 * irTransaction.getTotalHarga());
                            irTransaction.setPpnPercent(10);


                            hasil = DbIrigasiTransaction.updateExc(irTransaction);

                            if (hasil != 0) {

                                String whereBpLimbah = DbSewaTanahBp.colNames[DbSewaTanahBp.COL_REFNUMBER] + "='" + irigasiTransaction.getInvoiceNumber() + "'";
                                Vector listSwTnhBp = DbSewaTanahBp.list(0, 0, whereBpLimbah, null);

                                Irigasi mstIrigasi = new Irigasi();

                                try {
                                    mstIrigasi = DbIrigasi.fetchExc(irTransaction.getMasterIrigasiId());
                                } catch (Exception e) {
                                }

                                double pemakaian = irTransaction.getBulanIni() - irTransaction.getBulanLalu();
                                double jumlah = pemakaian * irTransaction.getHarga();
                                double ppn = mstIrigasi.getPpnPercent() * jumlah / 100;
                                double totPendapatan = jumlah + ppn;

                                if (listSwTnhBp != null && listSwTnhBp.size() > 0) {

                                    SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                    try {
                                        sewaTanahBp = (SewaTanahBp) listSwTnhBp.get(0);
                                    } catch (Exception e) {
                                    }

                                    sewaTanahBp.setTanggal(irTransaction.getTransactionDate());
                                    sewaTanahBp.setKeterangan(irTransaction.getKeterangan());
                                    sewaTanahBp.setRefnumber(irTransaction.getInvoiceNumber());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setDebet(totPendapatan);
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setMataUangId(currencyRp);
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);
                                    sewaTanahBp.setCustomerId(irTransaction.getCustumerId());
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setIrigasiTransactionId(hasil);
                                    
                                    try {
                                        long oidSwTanah = DbSewaTanahBp.updateExc(sewaTanahBp);
                                    } catch (Exception e) {}

                                } else {
                                    SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                    sewaTanahBp.setTanggal(irTransaction.getTransactionDate());
                                    sewaTanahBp.setKeterangan(irTransaction.getKeterangan());
                                    sewaTanahBp.setRefnumber(irTransaction.getInvoiceNumber());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setDebet(totPendapatan);
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setMataUangId(currencyRp);
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);
                                    
                                    sewaTanahBp.setCustomerId(irTransaction.getCustumerId());
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setIrigasiTransactionId(hasil);

                                    long oidStb = DbSewaTanahBp.insertExc(sewaTanahBp);
                                }
                            }
                        } catch (Exception ex) {
                        }
                    } else {
                        int counter = DbSystemDocNumber.getNextCounter(irigasiMonth.getPeriodeOid(), DbSystemDocCode.TYPE_DOCUMENT_IRIGASI);
                        String docPrefix = DbSystemDocNumber.getNumberPrefix(irigasiMonth.getPeriodeOid(), DbSystemDocCode.TYPE_DOCUMENT_IRIGASI);
                        String docNumber = DbSystemDocNumber.getNextNumber(counter, irigasiMonth.getPeriodeOid(), DbSystemDocCode.TYPE_DOCUMENT_IRIGASI);
                        Date today = new Date();
                        
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setDate(today);
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setPrefixNumber(docPrefix);
                        systemDocNumber.setDocNumber(docNumber);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_IRIGASI]);
                        systemDocNumber.setYear(irTransaction.getTransactionDate().getYear() + 1900);
                        
                        // proses insert Doc Number
                        DbSystemDocNumber.insertExc(systemDocNumber);

                        int days = 1;
                        days = customer.getDefDueDateDay();
                        
                        irTransaction.setTransactionDate(today);
                        irTransaction.setInvoiceNumber(docNumber);
                        irTransaction.setInvoiceNumberCounter(counter);

                        Date dueDate = new Date();
                        dueDate.setDate(irTransaction.getTransactionDate().getDate());
                        dueDate.setMonth(irTransaction.getTransactionDate().getMonth());
                        dueDate.setYear(irTransaction.getTransactionDate().getYear());
                        irTransaction.setDueDate(dueDate);
                        irTransaction.getDueDate().setDate(irTransaction.getDueDate().getDate() + days);

                        irTransaction.setTotalHarga((irTransaction.getBulanIni() - irTransaction.getBulanLalu()) * irTransaction.getHarga());
                        irTransaction.setPpn(0.1 * irTransaction.getTotalHarga());
                        irTransaction.setPpnPercent(10);

                      

                        hasil = DbIrigasiTransaction.insertExc(irTransaction);

                        if (hasil != 0) {

                            SewaTanahBp sewaTanahBp = new SewaTanahBp();
                            Irigasi mstIrigasi = new Irigasi();

                            try {
                                mstIrigasi = DbIrigasi.fetchExc(irTransaction.getMasterIrigasiId());
                            } catch (Exception e) {
                            }

                            double pemakaian = irTransaction.getBulanIni() - irTransaction.getBulanLalu();
                            double jumlah = pemakaian * irTransaction.getHarga();
                            double ppn = mstIrigasi.getPpnPercent() * jumlah / 100;
                            double totPendapatan = jumlah + ppn;

                            sewaTanahBp.setTanggal(irTransaction.getTransactionDate());
                            sewaTanahBp.setKeterangan(irTransaction.getKeterangan());
                            sewaTanahBp.setRefnumber(irTransaction.getInvoiceNumber());
                            sewaTanahBp.setMem(irTransaction.getKeterangan());
                            sewaTanahBp.setDebet(totPendapatan);
                            sewaTanahBp.setCredit(0);
                            sewaTanahBp.setMataUangId(currencyRp);
                            sewaTanahBp.setSewaTanahId(0);
                            sewaTanahBp.setSewaTanahInvId(0);
                            sewaTanahBp.setCustomerId(irTransaction.getCustumerId());
                            sewaTanahBp.setLimbahTransactionId(0);
                            sewaTanahBp.setIrigasiTransactionId(hasil);

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

    public static String formatNumber(int counter) {
        String strNumber = "IRI";
        if (counter < 10) {
            strNumber = strNumber + "-" + "0000" + counter;
        } else if (counter < 100) {
            strNumber = strNumber + "-" + "000" + counter;
        } else if (counter < 1000) {
            strNumber = strNumber + "-" + "00" + counter;
        } else if (counter < 10000) {
            strNumber = strNumber + "-" + "0" + counter;
        } else {
            strNumber = strNumber + "-" + counter;
        }
        return strNumber;
    }

    public static void updateIrigasiTransaction(int status, long oidIrigasiTransaksi) {
        if (oidIrigasiTransaksi != 0) {
            try {
                IrigasiTransaction irigasiTransaction = DbIrigasiTransaction.fetchExc(oidIrigasiTransaksi);
                irigasiTransaction.setPostStatus(status);

                DbIrigasiTransaction.updateExc(irigasiTransaction);
            } catch (Exception e) {
                System.out.println("updateIrigasiTransaction >> : " + e.toString());
            }
        }
    }
}
