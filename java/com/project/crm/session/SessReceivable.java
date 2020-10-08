package com.project.crm.session;

import com.project.fms.ar.*;
import com.project.crm.transaction.LimbahTransaction;
import com.project.crm.transaction.IrigasiTransaction;
import com.project.fms.transaction.Gl;
import com.project.crm.master.limbah.*;
import com.project.crm.master.irigasi.*;
import com.project.crm.report.RptListAR;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahBenefit;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahBenefit;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.transaction.DbIrigasiTransaction;
import com.project.crm.transaction.DbLimbahTransaction;
import com.project.crm.transaction.DbPembayaran;
import com.project.crm.transaction.Pembayaran;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.general.DbExchangeRate;
import com.project.general.ExchangeRate;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import java.sql.ResultSet;
import java.util.Vector;

public class SessReceivable {

    /**
     * proses insert aging dari limbah
     **/
    public static void prosesInsertAgingInvoice(LimbahTransaction limbahTransaction, Gl gl) {
        try {
            if (limbahTransaction.getOID() != 0) {
                ARInvoice aRInvoice = new ARInvoice();
                aRInvoice.setCustomerId(limbahTransaction.getCustomerId());
                aRInvoice.setDate(limbahTransaction.getTransactionDate());
                aRInvoice.setDueDate(limbahTransaction.getDueDate());
                aRInvoice.setInvoiceNumber(limbahTransaction.getInvoiceNumber());
                aRInvoice.setTransDate(limbahTransaction.getTransactionDate());
                aRInvoice.setProjectId(limbahTransaction.getOID());

                aRInvoice.setJournalCounter(gl.getJournalCounter());
                aRInvoice.setJournalNumber(gl.getJournalNumber());
                aRInvoice.setJournalPrefix(gl.getJournalPrefix());
                aRInvoice.setCurrencyId(gl.getCurrencyId());
                aRInvoice.setMemo(gl.getMemo());
                aRInvoice.setOperatorId(gl.getOperatorId());

                // proses perhitungan totalnya  
                double tot = limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu();
                double percent = limbahTransaction.getPercentageUsed();
                tot = tot * percent / 100;
                tot = tot * limbahTransaction.getHarga();

                Limbah limbah = DbLimbah.fetchExc(limbahTransaction.getMasterLimbahId());

                double ppnPercentValue = (tot * limbah.getPpnPercent()) / 100;
                aRInvoice.setVatAmount(ppnPercentValue);
                aRInvoice.setVatPercent(limbah.getPpnPercent());

                tot = tot + ppnPercentValue;
                aRInvoice.setTotal(tot);

                //aRInvoice.setMemo("Invoice for limbah trans. number: "+
                //limbahTransaction.getInvoiceNumber()+", date : "+JSPFormater.formatDate(limbahTransaction.getTransactionDate(),"dd-MMM-yyyy"));

                System.out.println("*** insert receivable limbah : " + limbahTransaction.getInvoiceNumber());
                long oid = DbARInvoice.insertExc(aRInvoice);
                System.out.println("*** status: " + oid);

                // proses insert ar invoice detail
                ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
                aRInvoiceDetail.setArInvoiceId(oid);
                aRInvoiceDetail.setPrice(tot);
                aRInvoiceDetail.setQty(1);
                aRInvoiceDetail.setTotalAmount(tot);
                aRInvoiceDetail.setDiscount(0);
                aRInvoiceDetail.setItemName(aRInvoice.getMemo());
                try {
                    DbARInvoiceDetail.insertExc(aRInvoiceDetail);
                } catch (Exception axc) {
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * proses insert aging dari irigasi
     **/
    public static void prosesInsertAgingInvoice(IrigasiTransaction irigasiTransaction, Gl gl) {
        try {
            if (irigasiTransaction.getOID() != 0) {
                ARInvoice aRInvoice = new ARInvoice();
                aRInvoice.setCustomerId(irigasiTransaction.getCustumerId());
                aRInvoice.setDate(irigasiTransaction.getTransactionDate());
                aRInvoice.setDueDate(irigasiTransaction.getDueDate());
                aRInvoice.setInvoiceNumber(irigasiTransaction.getInvoiceNumber());
                aRInvoice.setTransDate(irigasiTransaction.getTransactionDate());
                aRInvoice.setProjectId(irigasiTransaction.getOID());

                aRInvoice.setJournalCounter(gl.getJournalCounter());
                aRInvoice.setJournalNumber(gl.getJournalNumber());
                aRInvoice.setJournalPrefix(gl.getJournalPrefix());
                aRInvoice.setCurrencyId(gl.getCurrencyId());
                aRInvoice.setMemo(gl.getMemo());
                aRInvoice.setOperatorId(gl.getOperatorId());

                // proses perhitungan totalnya
                double tot = irigasiTransaction.getBulanIni() - irigasiTransaction.getBulanLalu();
                tot = tot * irigasiTransaction.getHarga();

                Irigasi irigasi = DbIrigasi.fetchExc(irigasiTransaction.getMasterIrigasiId());
                double ppnPercentValue = (tot * irigasi.getPpnPercent()) / 100;
                aRInvoice.setVatAmount(ppnPercentValue);
                aRInvoice.setVatPercent(irigasi.getPpnPercent());

                tot = tot + ppnPercentValue;
                aRInvoice.setTotal(tot);

                System.out.println("*** insert receivable irigasi : " + irigasiTransaction.getInvoiceNumber());
                long oid = DbARInvoice.insertExc(aRInvoice);
                System.out.println("*** status: " + oid);

                // proses insert ar invoice detail
                ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
                aRInvoiceDetail.setArInvoiceId(oid);
                aRInvoiceDetail.setPrice(tot);
                aRInvoiceDetail.setQty(1);
                aRInvoiceDetail.setTotalAmount(tot);
                aRInvoiceDetail.setDiscount(0);
                aRInvoiceDetail.setItemName(aRInvoice.getMemo());
                try {
                    DbARInvoiceDetail.insertExc(aRInvoiceDetail);
                } catch (Exception axc) {
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * proses insert aging dari limbah
     **/
    public static void prosesInsertAgingDenda(LimbahTransaction limbahTransaction, Gl gl) {
        try {
            if (limbahTransaction.getOID() != 0) {
                ARInvoice aRInvoice = new ARInvoice();
                aRInvoice.setCustomerId(limbahTransaction.getCustomerId());
                aRInvoice.setDate(limbahTransaction.getTransactionDate());
                aRInvoice.setDueDate(limbahTransaction.getDueDate());
                aRInvoice.setInvoiceNumber(limbahTransaction.getInvoiceNumber());
                aRInvoice.setTransDate(limbahTransaction.getTransactionDate());
                aRInvoice.setProjectId(limbahTransaction.getOID());

                aRInvoice.setJournalCounter(gl.getJournalCounter());
                aRInvoice.setJournalNumber(gl.getJournalNumber());
                aRInvoice.setJournalPrefix(gl.getJournalPrefix());
                aRInvoice.setCurrencyId(gl.getCurrencyId());
                aRInvoice.setMemo(gl.getMemo());
                aRInvoice.setOperatorId(gl.getOperatorId());

                // proses perhitungan totalnya  
                //double tot = limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu();
                double tot = limbahTransaction.getDendaDiakui();
                //double percent = limbahTransaction.getPercentageUsed();
                //tot = tot * percent / 100;
                //tot = tot * limbahTransaction.getHarga();

                //Limbah limbah = DbLimbah.fetchExc(limbahTransaction.getMasterLimbahId());

                //double ppnPercentValue = (tot * limbah.getPpnPercent()) / 100;
                aRInvoice.setVatAmount(0);
                aRInvoice.setVatPercent(0);

                //tot = tot + ppnPercentValue;
                aRInvoice.setTotal(tot);

                //aRInvoice.setMemo("Invoice for limbah trans. number: "+
                //limbahTransaction.getInvoiceNumber()+", date : "+JSPFormater.formatDate(limbahTransaction.getTransactionDate(),"dd-MMM-yyyy"));

                System.out.println("*** insert receivable denda : " + limbahTransaction.getInvoiceNumber());
                long oid = DbARInvoice.insertExc(aRInvoice);
                System.out.println("*** status: " + oid);

                // proses insert ar invoice detail
                ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
                aRInvoiceDetail.setArInvoiceId(oid);
                aRInvoiceDetail.setPrice(tot);
                aRInvoiceDetail.setQty(1);
                aRInvoiceDetail.setTotalAmount(tot);
                aRInvoiceDetail.setDiscount(0);
                aRInvoiceDetail.setItemName(aRInvoice.getMemo());
                try {
                    DbARInvoiceDetail.insertExc(aRInvoiceDetail);
                } catch (Exception axc) {
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * proses insert aging dari irigasi
     **/
    public static void prosesInsertAgingDenda(IrigasiTransaction irigasiTransaction, Gl gl) {
        try {
            if (irigasiTransaction.getOID() != 0) {
                ARInvoice aRInvoice = new ARInvoice();
                aRInvoice.setCustomerId(irigasiTransaction.getCustumerId());
                aRInvoice.setDate(irigasiTransaction.getTransactionDate());
                aRInvoice.setDueDate(irigasiTransaction.getDueDate());
                aRInvoice.setInvoiceNumber(irigasiTransaction.getInvoiceNumber());
                aRInvoice.setTransDate(irigasiTransaction.getTransactionDate());
                aRInvoice.setProjectId(irigasiTransaction.getOID());

                aRInvoice.setJournalCounter(gl.getJournalCounter());
                aRInvoice.setJournalNumber(gl.getJournalNumber());
                aRInvoice.setJournalPrefix(gl.getJournalPrefix());
                aRInvoice.setCurrencyId(gl.getCurrencyId());
                aRInvoice.setMemo(gl.getMemo());
                aRInvoice.setOperatorId(gl.getOperatorId());

                // proses perhitungan totalnya  
                //double tot = limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu();
                double tot = irigasiTransaction.getDendaDiakui();
                //double percent = limbahTransaction.getPercentageUsed();
                //tot = tot * percent / 100;
                //tot = tot * limbahTransaction.getHarga();

                //Limbah limbah = DbLimbah.fetchExc(limbahTransaction.getMasterLimbahId());

                //double ppnPercentValue = (tot * limbah.getPpnPercent()) / 100;
                aRInvoice.setVatAmount(0);
                aRInvoice.setVatPercent(0);

                //tot = tot + ppnPercentValue;
                aRInvoice.setTotal(tot);

                //aRInvoice.setMemo("Invoice for limbah trans. number: "+
                //limbahTransaction.getInvoiceNumber()+", date : "+JSPFormater.formatDate(limbahTransaction.getTransactionDate(),"dd-MMM-yyyy"));

                System.out.println("*** insert receivable denda : " + irigasiTransaction.getInvoiceNumber() + "D");
                long oid = DbARInvoice.insertExc(aRInvoice);
                System.out.println("*** status: " + oid);

                // proses insert ar invoice detail
                ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
                aRInvoiceDetail.setArInvoiceId(oid);
                aRInvoiceDetail.setPrice(tot);
                aRInvoiceDetail.setQty(1);
                aRInvoiceDetail.setTotalAmount(tot);
                aRInvoiceDetail.setDiscount(0);
                aRInvoiceDetail.setItemName(aRInvoice.getMemo());

                try {
                    DbARInvoiceDetail.insertExc(aRInvoiceDetail);
                } catch (Exception axc) {
                }

            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * proses insert aging dari denda sewa komin
     **/
    public static void prosesInsertAgingDenda(SewaTanahInvoice sewaTanahInvoice, Gl gl) {
        try {
            if (sewaTanahInvoice.getOID() != 0) {

                ARInvoice aRInvoice = new ARInvoice();
                aRInvoice.setCustomerId(sewaTanahInvoice.getSaranaId());
                aRInvoice.setDate(sewaTanahInvoice.getDendaApproveDate());
                //aRInvoice.setDueDate(sewaTanahInvoice.getDueDate());
                //aRInvoice.setInvoiceNumber(limbahTransaction.getInvoiceNumber());
                //aRInvoice.setTransDate(limbahTransaction.getTransactionDate());				
                //aRInvoice.setProjectId(limbahTransaction.getOID());

                aRInvoice.setJournalCounter(gl.getJournalCounter());
                aRInvoice.setJournalNumber(gl.getJournalNumber());
                aRInvoice.setJournalPrefix(gl.getJournalPrefix());
                aRInvoice.setCurrencyId(gl.getCurrencyId());
                aRInvoice.setMemo(gl.getMemo());
                aRInvoice.setOperatorId(gl.getOperatorId());

                // proses perhitungan totalnya  
                //double tot = limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu();
                double tot = sewaTanahInvoice.getDendaDiakui();
                //double percent = limbahTransaction.getPercentageUsed();
                //tot = tot * percent / 100;
                //tot = tot * limbahTransaction.getHarga();

                //Limbah limbah = DbLimbah.fetchExc(limbahTransaction.getMasterLimbahId());

                //double ppnPercentValue = (tot * limbah.getPpnPercent()) / 100;
                aRInvoice.setVatAmount(0);
                aRInvoice.setVatPercent(0);

                //tot = tot + ppnPercentValue;
                aRInvoice.setTotal(tot);

                //aRInvoice.setMemo("Invoice for limbah trans. number: "+
                //limbahTransaction.getInvoiceNumber()+", date : "+JSPFormater.formatDate(limbahTransaction.getTransactionDate(),"dd-MMM-yyyy"));

                System.out.println("*** insert receivable denda : " + sewaTanahInvoice.getNumber());
                long oid = DbARInvoice.insertExc(aRInvoice);
                System.out.println("*** status: " + oid);

                // proses insert ar invoice detail
                ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
                aRInvoiceDetail.setArInvoiceId(oid);
                aRInvoiceDetail.setPrice(tot);
                aRInvoiceDetail.setQty(1);
                aRInvoiceDetail.setTotalAmount(tot);
                aRInvoiceDetail.setDiscount(0);
                aRInvoiceDetail.setItemName(aRInvoice.getMemo());
                try {
                    DbARInvoiceDetail.insertExc(aRInvoiceDetail);
                } catch (Exception axc) {
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    
    /**
     * Method for return list of AR by selected period
     * by gwawan 20110811
     * @return List AR
     */
    public static Vector getListAR(int year, int month) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        
        try {
            /**
             * Example:
             * year  : 2011
             * month : 08
             * 
             * Saldo piutang
             * per 12 Aug 2011 : startDate 0000-00-00; endDate 2011-08-31
             * per 12 Aug 2010 : startDate 0000-00-00; endDate 2010-08-31
             * 
             * Umur piutang per Aug 2011
             * s/d 1 Tahun : startDate 2010-09-01; endDate 2011-08-31 
             * > 1 Tahun - 2 Tahun : startDate 2009-09-01; endDate 2010-08-31
             * > 2 Tahun - 3 Tahun : startDate 2008-09-01; endDate 2009-08-31
             * > 3 Tahun - 4 Tahun : startDate 2007-09-01; endDate 2008-08-31
             * > 4 Tahun : startDate 0000-00-00; endDate 2007-09-01
             */
            
            String sql = "select c.customer_id as id_sarana, c.name as sarana, l.nama as lot" +
                    " from crm_sewa_tanah st inner join customer c on st.customer_id = c.customer_id" +
                    " inner join crm_lot l on st.lot_id=l.lot_id" +
                    " where st.status = " + DbSewaTanah.STATUS_AKTIF;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long idSarana = 0;
            
            while(rs.next()) {
                RptListAR rptListAR = new RptListAR();
                idSarana = rs.getLong("id_sarana");
                rptListAR.setSarana(rs.getString("sarana"));
                rptListAR.setLot(rs.getString("lot"));
                rptListAR.setLastYear(getTotalAR(idSarana, "0000-00-00", String.valueOf(year-1)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setCurrent(getTotalAR(idSarana, "0000-00-00", String.valueOf(year)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setUntil1Year(getTotalAR(idSarana, String.valueOf(year-1)+"-"+String.valueOf(month+1)+"-01", String.valueOf(year)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setBetween1_2Year(getTotalAR(idSarana, String.valueOf(year-2)+"-"+String.valueOf(month+1)+"-01", String.valueOf(year-1)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setBetween2_3Year(getTotalAR(idSarana, String.valueOf(year-3)+"-"+String.valueOf(month+1)+"-01", String.valueOf(year-2)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setBetween3_4Year(getTotalAR(idSarana, String.valueOf(year-4)+"-"+String.valueOf(month+1)+"-01", String.valueOf(year-3)+"-"+String.valueOf(month)+"-31"));
                rptListAR.setMoreThan4Year(getTotalAR(idSarana, "0000-00-00", String.valueOf(year-4)+"-"+String.valueOf(month)+"-31"));
                
                list.add(rptListAR);
            }
            
        } catch(Exception e) {
        }
        return list;
    }
    
    /**
     * Method for return total AR
     * by gwawan 20110812
     * @return AR amount
     */
    public static double getTotalAR(long idSarana, String startDate, String endDate) {
        CONResultSet dbrs = null;
        ResultSet rs = null;
        double totalAr = 0;
        System.out.println("idSarana:"+idSarana+"; startDate:"+startDate+"; endDate:"+endDate);
        try {
            SewaTanahInvoice sti = new SewaTanahInvoice();
            SewaTanahBenefit stb = new SewaTanahBenefit();
            Pembayaran pay = new Pembayaran();
            
            double rate$ = 0;
            ExchangeRate rate = DbExchangeRate.getStandardRate();
            rate$ = rate.getValueUsd();
            
            Currency currency$ = DbCurrency.getCurrencyByCode(DbSystemProperty.getValueByName("CURRENCY_CODE_USD"));
            System.out.println("Currency "+currency$.getCurrencyCode()+" : "+currency$.getOID());

            double totalSti = 0;
            double totalStb = 0;
            double totalIrigasi = 0;
            double totalLimbah = 0;
            double totalPay = 0;
            
            String sql = "";
            String where = "";
            
            Periode period = new Periode();
            Vector vPeriod = DbPeriode.list(0, 0, "'"+startDate+"%' BETWEEN "+DbPeriode.colNames[DbPeriode.COL_START_DATE]+" AND "+DbPeriode.colNames[DbPeriode.COL_END_DATE], "");
            for(int i=0; i<vPeriod.size(); i++) {
                period = (Periode)vPeriod.get(i);
                System.out.println("oidPeriode >>> "+period.getOID());
            }
            
            //get komin dan assesment
            where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + "=" + idSarana
                    + " AND (" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] 
                    + " BETWEEN '" + startDate + "%' AND '" + endDate + "%')";
            Vector listSti = DbSewaTanahInvoice.list(0, 0, where, "");
            for (int n1 = 0; n1 < listSti.size(); n1++) {
                sti = (SewaTanahInvoice) listSti.get(n1);
                if(sti.getCurrencyId() == currency$.getOID()) {
                    totalSti += (sti.getJumlah() + sti.getPpn() + sti.getPph() + sti.getDendaDiakui()) * rate$;
                } else {
                    totalSti += sti.getJumlah() + sti.getPpn() + sti.getPph() + sti.getDendaDiakui();
                }
                
            }

            //get komper
            where = DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SARANA_ID] + "=" + idSarana
                    + " AND (" + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TANGGAL] 
                    + " BETWEEN '" + startDate + "%' AND '" + endDate + "%')";
            Vector listStb = DbSewaTanahBenefit.list(0, 0, where, "");
            for (int n1 = 0; n1 < listStb.size(); n1++) {
                stb = (SewaTanahBenefit) listStb.get(n1);
                if(stb.getCurrencyId() == currency$.getOID()) {
                    totalStb += (stb.getTotalKomper() + stb.getPpn() + stb.getPph() + stb.getDendaDiakui()) * rate$;
                } else {
                    totalStb += stb.getTotalKomper() + stb.getPpn() + stb.getPph() + stb.getDendaDiakui();
                }
            }

            //get irigasi
            sql = "select (total_harga + ppn + pph) as irigasi from crm_irigasi_transaction it inner join periode p on it.period_id = p.periode_id " +
                    "where it.customer_id="+idSarana+" and (p.start_date between '"+startDate+"' and '"+endDate+"') and (p.end_date between '"+startDate+"' and '"+endDate+"')";
            dbrs = CONHandler.execQueryResult(sql);
            rs = dbrs.getResultSet();
            while(rs.next()) {
                totalIrigasi += rs.getDouble("irigasi");
            }

            //get limbah
            sql = "select (total_harga + ppn + pph) as limbah from crm_limbah_transaction lt inner join periode p on lt.period_id = p.periode_id " +
                    "where lt.customer_id="+idSarana+" and (p.start_date between '"+startDate+"' and '"+endDate+"') and (p.end_date between '"+startDate+"' and '"+endDate+"')";
            dbrs = CONHandler.execQueryResult(sql);
            rs = dbrs.getResultSet();
            while(rs.next()) {
                totalLimbah += rs.getDouble("limbah");
            }

            //get payment
            where = DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID] + "=" + idSarana
                    + " AND (" + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] 
                    + " BETWEEN '" + startDate + "%' AND '" + endDate + "%')";
            Vector listPay = DbPembayaran.list(0, 0, where, "");
            for (int n1 = 0; n1 < listPay.size(); n1++) {
                pay = (Pembayaran) listPay.get(n1);
                totalPay += pay.getJumlah() * pay.getExchangeRate();
            }
            
            totalAr = totalSti + totalStb + totalIrigasi + totalLimbah - totalPay;
            
        } catch (Exception e) {
        }
        return totalAr;
    }
}
