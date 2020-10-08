package com.project.crm.session;

import java.io.*;
import java.util.*;
import com.project.main.db.CONResultSet;
import java.util.Vector;
import com.project.crm.master.irigasi.*;
import com.project.crm.transaction.IrigasiTransaction;
import com.project.crm.transaction.DbIrigasiTransaction;
import com.project.fms.master.*;
import com.project.crm.report.RptIrigasiPeriod;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.DbGl;
import java.sql.ResultSet;

/**
 *
 * @author Tu Roy
 */
public class SessIrigasiTransaction {

    /**
     * @Author  Roy Andika     
     * @param   periodId
     * @Desc    untuk mendapatkan list report pendapatan air limbah bulanan
     * @return
     */
    public static Vector ListReportIrigasiTransaction(long periodId) {

        CONResultSet dbrs = null;

        try {
            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + " as transId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER] + " as nomorTransaksi," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " as irigasiId," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_RATE] + " as irigasiRate," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_PPN_PERCENT] + " as irigasiPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbIrigasi.DB_IRIGASI + " mast ON tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID] +
                    " = mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();

                rptIrigasiPeriod.setCustId(rs.getLong("custId"));
                rptIrigasiPeriod.setCustName(rs.getString("custName"));

                rptIrigasiPeriod.setTransId(rs.getLong("transId"));
                rptIrigasiPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptIrigasiPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptIrigasiPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptIrigasiPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptIrigasiPeriod.setNomorTransaksi(rs.getString("nomorTransaksi"));
                rptIrigasiPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptIrigasiPeriod.setIrigasiId(rs.getLong("irigasiId"));
                rptIrigasiPeriod.setIrigasiRate(rs.getDouble("irigasiRate"));
                rptIrigasiPeriod.setIrigasiPpnPercent(rs.getDouble("irigasiPpnPercent"));

                rptIrigasiPeriod.setPeriodId(rs.getLong("periodId"));
                rptIrigasiPeriod.setPeriodName(rs.getString("PeriodName"));


                result.add(rptIrigasiPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static RptIrigasiPeriod ListReportIrigasiTransaction(long periodeId, long customerId) {
        CONResultSet dbrs = null;
        RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();

        try {
            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + " as transId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER] + " as nomorTransaksi," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_NOMOR_FP] + " as nomorFp," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " as irigasiId," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_RATE] + " as irigasiRate," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_PPN_PERCENT] + " as irigasiPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbIrigasi.DB_IRIGASI + " mast ON tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID] +
                    " = mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodeId +
                    " AND cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + customerId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                rptIrigasiPeriod.setCustId(rs.getLong("custId"));
                rptIrigasiPeriod.setCustName(rs.getString("custName"));
                rptIrigasiPeriod.setIrigasiId(rs.getLong("irigasiId"));
                rptIrigasiPeriod.setIrigasiRate(rs.getDouble("irigasiRate"));
                rptIrigasiPeriod.setIrigasiPpnPercent(rs.getDouble("irigasiPpnPercent"));
                rptIrigasiPeriod.setNomorTransaksi(rs.getString("nomorTransaksi"));
                rptIrigasiPeriod.setNomorFP(rs.getString("nomorFp"));
                rptIrigasiPeriod.setPostedStatus(rs.getInt("postedStatus"));
                rptIrigasiPeriod.setPeriodId(rs.getLong("periodId"));
                rptIrigasiPeriod.setPeriodName(rs.getString("PeriodName"));
                rptIrigasiPeriod.setTransId(rs.getLong("transId"));
                rptIrigasiPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptIrigasiPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptIrigasiPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptIrigasiPeriod.setTransHarga(rs.getDouble("transHarga"));
            }

            return rptIrigasiPeriod;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static Vector ListReportIrigasiTransactionUpdateFP(long periodId, long saranaId, int status) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + " as transId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER] + " as transNumber," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_NOMOR_FP] + " as nomorFP," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " as irigasiId," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_RATE] + " as irigasiRate," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_PPN_PERCENT] + " as irigasiPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbIrigasi.DB_IRIGASI + " mast ON tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID] +
                    " = mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;
            if (saranaId != 0) {
                sql = sql + " and tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] + "=" + saranaId;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector result = new Vector();

            while (rs.next()) {

                RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();

                rptIrigasiPeriod.setCustId(rs.getLong("custId"));
                rptIrigasiPeriod.setCustName(rs.getString("custName"));

                rptIrigasiPeriod.setTransId(rs.getLong("transId"));
                rptIrigasiPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptIrigasiPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptIrigasiPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptIrigasiPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptIrigasiPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptIrigasiPeriod.setIrigasiId(rs.getLong("irigasiId"));
                rptIrigasiPeriod.setIrigasiRate(rs.getDouble("irigasiRate"));
                // rptIrigasiPeriod.setIrigasiPercent(rs.getDouble("irigasiPercent"));
                // rptIrigasiPeriod.setIrigasiEfective(rs.getDate("irigasiEfective"));
                rptIrigasiPeriod.setIrigasiPpnPercent(rs.getDouble("irigasiPpnPercent"));

                rptIrigasiPeriod.setPeriodId(rs.getLong("periodId"));
                rptIrigasiPeriod.setPeriodName(rs.getString("PeriodName"));

                rptIrigasiPeriod.setNomorTransaksi(rs.getString("transNumber"));
                rptIrigasiPeriod.setNomorFP(rs.getString("nomorFP"));

                result.add(rptIrigasiPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static Vector ListReportIrigasiTransactionPosting(long periodId, int status) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_TYPE] + " as custType," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + " as transId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER] + " as transNumber," +
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_NOMOR_FP] + " as nomorFP," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " as irigasiId," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_RATE] + " as irigasiRate," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_PPN_PERCENT] + " as irigasiPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbIrigasi.DB_IRIGASI + " mast ON tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID] +
                    " = mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId +
                    " and tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS] + "=" + status;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector result = new Vector();

            while (rs.next()) {

                RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();

                rptIrigasiPeriod.setCustId(rs.getLong("custId"));
                rptIrigasiPeriod.setCustName(rs.getString("custName"));
                rptIrigasiPeriod.setCustType(rs.getInt("custType"));

                rptIrigasiPeriod.setTransId(rs.getLong("transId"));
                rptIrigasiPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptIrigasiPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptIrigasiPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptIrigasiPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptIrigasiPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptIrigasiPeriod.setIrigasiId(rs.getLong("irigasiId"));
                rptIrigasiPeriod.setIrigasiRate(rs.getDouble("irigasiRate"));
                rptIrigasiPeriod.setIrigasiPpnPercent(rs.getDouble("irigasiPpnPercent"));

                rptIrigasiPeriod.setPeriodId(rs.getLong("periodId"));
                rptIrigasiPeriod.setPeriodName(rs.getString("PeriodName"));

                rptIrigasiPeriod.setNomorTransaksi(rs.getString("transNumber"));
                rptIrigasiPeriod.setNomorFP(rs.getString("nomorFP"));

                result.add(rptIrigasiPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static boolean postingIrigasiTransaction(long transaksiOID, int status, long periodId, Date postingDate, long userId) {
        try {
            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
            if(transaksiOID != 0) irigasiTransaction = DbIrigasiTransaction.fetchExc(transaksiOID); else return false;
            irigasiTransaction.setPostStatus(status);

            // update status transaksi      		 
            boolean ok = DbIrigasiTransaction.postJournal(irigasiTransaction, periodId, postingDate, userId);

            if (ok) {
                DbIrigasiTransaction.updateExc(irigasiTransaction);

                // proses pencarian journal  
                String where = "(" + DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + irigasiTransaction.getInvoiceNumber() + "' or " +
                        DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + irigasiTransaction.getInvoiceNumber() + "')";
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging	
                SessReceivable.prosesInsertAgingInvoice(irigasiTransaction, gl);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println("[Exception] on postingIrigasiTransaction " + e.toString());
        }
        return false;
    }

    public static void UpdateFPIrigasiTransaksi(long transaksiOID, String nomorFP) {
        try {
            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
            irigasiTransaction = DbIrigasiTransaction.fetchExc(transaksiOID);
            irigasiTransaction.setNomorFp(nomorFP);
            DbIrigasiTransaction.updateExc(irigasiTransaction);
        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
    }

    public static Vector listDenda(long periodId, long saranaId, int status) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DUE_DATE] +
                    ", it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER] +
                    ", it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_HARGA] +
                    ", it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_DENDA] +
                    ", it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_STATUS_PEMBAYARAN] +
                    ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME] +
                    " FROM " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION + " it" + 
                    " INNER JOIN " + DbCustomer.DB_CUSTOMER + " cus" +
                    " ON " + " it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];

            String where = " WHERE " + " it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = " + periodId;
            
            if (saranaId != 0) {
                sql = sql + " AND it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] + " = " + saranaId;
            }
            
            sql += where;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();
                
                rptIrigasiPeriod.setJatuhTempo(rs.getDate("it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DUE_DATE]));
                rptIrigasiPeriod.setNomorTransaksi(rs.getString("it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER]));
                rptIrigasiPeriod.setTransHarga(rs.getDouble("it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_HARGA]));
                rptIrigasiPeriod.setTotalDenda(rs.getDouble("it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_DENDA]));
                rptIrigasiPeriod.setStatusPembayaran(DbIrigasiTransaction.Posted_sts_key[rs.getInt("it." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_STATUS_PEMBAYARAN])]);
                rptIrigasiPeriod.setCurrencyCode("Rp");
                rptIrigasiPeriod.setCustName(rs.getString("cus." + DbCustomer.colNames[DbCustomer.COL_NAME]));

                result.add(rptIrigasiPeriod);
            }

            return result;

        } catch (Exception e) {
            System.out.println("Error when listDenda(#,#,#) " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static void postingIrigasiTransaksiDenda(long transaksiOID, int status) {
        try {
            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
            irigasiTransaction = DbIrigasiTransaction.fetchExc(transaksiOID);
            irigasiTransaction.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbIrigasiTransaction.postJournalDenda(irigasiTransaction);
            
            if (ok) {
                DbIrigasiTransaction.updateExc(irigasiTransaction);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + irigasiTransaction.getInvoiceNumber() + "D')";
                
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(irigasiTransaction, gl);
                
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
    }
    
    public static boolean postIrigasiTransaksiDenda(long transaksiOID, int status) {
        try {
            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
            irigasiTransaction = DbIrigasiTransaction.fetchExc(transaksiOID);
            irigasiTransaction.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbIrigasiTransaction.postJournalDenda(irigasiTransaction);
            
            if(ok == false){
                return false;
            }
            
            if (ok) {
                DbIrigasiTransaction.updateExc(irigasiTransaction);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + irigasiTransaction.getInvoiceNumber() + "D')";
                
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(irigasiTransaction, gl);
                
                return true;
                
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
        return false;
    }
    
}
