package com.project.crm.session;

import java.io.*;
import java.util.*;
import com.project.main.db.CONResultSet;
import java.util.Vector;
import com.project.crm.master.limbah.*;
import com.project.fms.master.*;
import com.project.crm.transaction.LimbahTransaction;
import com.project.crm.transaction.DbLimbahTransaction;
import com.project.crm.report.RptLimbahPeriod;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.DbGl;
import java.sql.ResultSet;

/**
 *
 * @author Tu Roy
 */
public class SessLimbahTransaction {

    /**
     * @Author  Roy Andika     
     * @param   periodId
     * @Desc    untuk mendapatkan list report pendapatan air limbah bulanan
     * @return
     */
    public static Vector ListReportLimbahTransaction(long periodId) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " as transId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED] + " as transPercentage," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " as limId," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_RATE] + " as limRate," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PERCENTAGE_USED] + " as limPercent," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PPN_PERCENT] + " as limPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER] + " as numberTrans," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NOMOR_FP] + " as nomorFp" +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbLimbahTransaction.DB_LIMBAH_TRASACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLimbah.DB_LIMBAH + " mast ON tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID] +
                    " = mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptLimbahPeriod rptLimbahPeriod = new RptLimbahPeriod();

                rptLimbahPeriod.setCustId(rs.getLong("custId"));
                rptLimbahPeriod.setCustName(rs.getString("custName"));

                rptLimbahPeriod.setTransId(rs.getLong("transId"));
                rptLimbahPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptLimbahPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptLimbahPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptLimbahPeriod.setTransPercentage(rs.getDouble("transPercentage"));
                rptLimbahPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptLimbahPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptLimbahPeriod.setLimId(rs.getLong("limId"));
                rptLimbahPeriod.setLimRate(rs.getDouble("limRate"));
                rptLimbahPeriod.setLimPercent(rs.getDouble("limPercent"));
                rptLimbahPeriod.setLimPpnPercent(rs.getDouble("limPpnPercent"));

                rptLimbahPeriod.setPeriodId(rs.getLong("periodId"));
                rptLimbahPeriod.setPeriodName(rs.getString("PeriodName"));

                rptLimbahPeriod.setNomorTransaksi(rs.getString("numberTrans"));
                rptLimbahPeriod.setNomorFP(rs.getString("nomorFp"));

                result.add(rptLimbahPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static RptLimbahPeriod ListReportLimbahTransaction(long periodeId, long customerId) {
        CONResultSet dbrs = null;
        RptLimbahPeriod rptLimbahPeriod = new RptLimbahPeriod();

        try {
            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " as transId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED] + " as transPercentage," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " as limId," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_RATE] + " as limRate," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PERCENTAGE_USED] + " as limPercent," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PPN_PERCENT] + " as limPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER] + " as numberTrans," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NOMOR_FP] + " as nomorFp" +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbLimbahTransaction.DB_LIMBAH_TRASACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLimbah.DB_LIMBAH + " mast ON tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID] +
                    " = mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE " + " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodeId +
                    " AND cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + customerId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                rptLimbahPeriod.setCustId(rs.getLong("custId"));
                rptLimbahPeriod.setCustName(rs.getString("custName"));
                rptLimbahPeriod.setLimId(rs.getLong("limId"));
                rptLimbahPeriod.setLimRate(rs.getDouble("limRate"));
                rptLimbahPeriod.setLimPercent(rs.getDouble("limPercent"));
                rptLimbahPeriod.setLimPpnPercent(rs.getDouble("limPpnPercent"));
                rptLimbahPeriod.setNomorTransaksi(rs.getString("numberTrans"));
                rptLimbahPeriod.setNomorFP(rs.getString("nomorFp"));
                rptLimbahPeriod.setPostedStatus(rs.getInt("postedStatus"));
                rptLimbahPeriod.setPeriodId(rs.getLong("periodId"));
                rptLimbahPeriod.setPeriodName(rs.getString("PeriodName"));
                rptLimbahPeriod.setTransId(rs.getLong("transId"));
                rptLimbahPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptLimbahPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptLimbahPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptLimbahPeriod.setTransPercentage(rs.getDouble("transPercentage"));
                rptLimbahPeriod.setTransHarga(rs.getDouble("transHarga"));
            }
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return rptLimbahPeriod;
    }

    public static Vector ListReportLimbahTransactionUpdateFP(long periodId, long saranaId, int status) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " as transId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED] + " as transPercentage," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " as limId," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_RATE] + " as limRate," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PERCENTAGE_USED] + " as limPercent," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PPN_PERCENT] + " as limPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER] + " as numberTrans," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NOMOR_FP] + " as nomorFp" +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbLimbahTransaction.DB_LIMBAH_TRASACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLimbah.DB_LIMBAH + " mast ON tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID] +
                    " = mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;

            if (saranaId != 0) {
                sql = sql + " and tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] + "=" + saranaId;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptLimbahPeriod rptLimbahPeriod = new RptLimbahPeriod();

                rptLimbahPeriod.setCustId(rs.getLong("custId"));
                rptLimbahPeriod.setCustName(rs.getString("custName"));

                rptLimbahPeriod.setTransId(rs.getLong("transId"));
                rptLimbahPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptLimbahPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptLimbahPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptLimbahPeriod.setTransPercentage(rs.getDouble("transPercentage"));
                rptLimbahPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptLimbahPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptLimbahPeriod.setLimId(rs.getLong("limId"));
                rptLimbahPeriod.setLimRate(rs.getDouble("limRate"));
                rptLimbahPeriod.setLimPercent(rs.getDouble("limPercent"));
                //rptLimbahPeriod.setLimEfective(rs.getDate("limEfective"));                
                rptLimbahPeriod.setLimPpnPercent(rs.getDouble("limPpnPercent"));

                rptLimbahPeriod.setPeriodId(rs.getLong("periodId"));
                rptLimbahPeriod.setPeriodName(rs.getString("PeriodName"));

                rptLimbahPeriod.setNomorTransaksi(rs.getString("numberTrans"));
                rptLimbahPeriod.setNomorFP(rs.getString("nomorFp"));

                result.add(rptLimbahPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static Vector ListReportLimbahTransactionPosting(long periodId, int status) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_TYPE] + " as custType," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " as transId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED] + " as transPercentage," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_HARGA] + " as transHarga," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS] + " as postedStatus," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " as limId," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_RATE] + " as limRate," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PERCENTAGE_USED] + " as limPercent," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_PPN_PERCENT] + " as limPpnPercent," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER] + " as numberTrans," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NOMOR_FP] + " as nomorFp" +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbLimbahTransaction.DB_LIMBAH_TRASACTION + " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLimbah.DB_LIMBAH + " mast ON tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID] +
                    " = mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId +
                    " and " + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS] + "=" + status;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptLimbahPeriod rptLimbahPeriod = new RptLimbahPeriod();

                rptLimbahPeriod.setCustId(rs.getLong("custId"));
                rptLimbahPeriod.setCustName(rs.getString("custName"));
                rptLimbahPeriod.setCustType(rs.getInt("custType"));

                rptLimbahPeriod.setTransId(rs.getLong("transId"));
                rptLimbahPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptLimbahPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptLimbahPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                rptLimbahPeriod.setTransPercentage(rs.getDouble("transPercentage"));
                rptLimbahPeriod.setTransHarga(rs.getDouble("transHarga"));
                rptLimbahPeriod.setPostedStatus(rs.getInt("postedStatus"));

                rptLimbahPeriod.setLimId(rs.getLong("limId"));
                rptLimbahPeriod.setLimRate(rs.getDouble("limRate"));
                rptLimbahPeriod.setLimPercent(rs.getDouble("limPercent"));
                //rptLimbahPeriod.setLimEfective(rs.getDate("limEfective"));                
                rptLimbahPeriod.setLimPpnPercent(rs.getDouble("limPpnPercent"));

                rptLimbahPeriod.setPeriodId(rs.getLong("periodId"));
                rptLimbahPeriod.setPeriodName(rs.getString("PeriodName"));

                rptLimbahPeriod.setNomorTransaksi(rs.getString("numberTrans"));
                rptLimbahPeriod.setNomorFP(rs.getString("nomorFp"));

                result.add(rptLimbahPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static boolean postingLimbahTransaction(long transaksiOID, int status, long periodId, Date postingDate, long userId) {
        try {
            LimbahTransaction limbahTransaction = new LimbahTransaction();
            if (transaksiOID != 0) {
                limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);
            } else {
                return false;
            }
            limbahTransaction.setPostedStatus(status);

            // update status transaksi
            boolean ok = DbLimbahTransaction.postJournal(limbahTransaction, periodId, postingDate, userId);

            if (ok) {
                DbLimbahTransaction.updateExc(limbahTransaction);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "')";
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging	
                SessReceivable.prosesInsertAgingInvoice(limbahTransaction, gl);

                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println("[Exception] on postingLimbahTransaction " + e.toString());
        }

        return false;
    }

    public static void postingLimbahTransaksiDenda(long transaksiOID, int status) {
        try {
            LimbahTransaction limbahTransaction = new LimbahTransaction();
            limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);
            limbahTransaction.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbLimbahTransaction.postJournalDenda(limbahTransaction);

            if (ok) {
                DbLimbahTransaction.updateExc(limbahTransaction);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "D')";

                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(limbahTransaction, gl);
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }

    }

    public static boolean postLimbahTransaksiDenda(long transaksiOID, int status) {
        try {
            LimbahTransaction limbahTransaction = new LimbahTransaction();
            limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);
            limbahTransaction.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbLimbahTransaction.postJournalDenda(limbahTransaction);

            if (ok == false) {
                return false;
            }

            if (ok) {

                DbLimbahTransaction.updateExc(limbahTransaction);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "D')";

                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(limbahTransaction, gl);
                return true;
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
        return false;
    }

    public static void updateFPLimbahTransaksi(long transaksiOID, String nomorFP) {
        try {
            LimbahTransaction limbahTransaction = new LimbahTransaction();
            limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);
            limbahTransaction.setNomorFp(nomorFP);
            DbLimbahTransaction.updateExc(limbahTransaction);
        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
    }

    public static Vector journalVoucherDebet(long periodId) {
        CONResultSet dbrs = null;
        try {
            String sql = "";
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector journalVoucherKredit(long periodId) {
        CONResultSet dbrs = null;
        try {
            String sql = "";
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector listDenda(long periodId, long saranaId, int status) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DUE_DATE] +
                    ", lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER] +
                    ", lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_HARGA] +
                    ", lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_DENDA] +
                    ", lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_STATUS_PEMBAYARAN] +
                    ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME] +
                    " FROM " + DbLimbahTransaction.DB_LIMBAH_TRASACTION + " lt" +
                    " INNER JOIN " + DbCustomer.DB_CUSTOMER + " cus" +
                    " ON " + " lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];

            String where = " WHERE " + " lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = " + periodId;

            if (saranaId != 0) {
                sql = sql + " AND lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] + " = " + saranaId;
            }

            sql += where;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                RptLimbahPeriod rptLimbahPeriod = new RptLimbahPeriod();

                rptLimbahPeriod.setJatuhTempo(rs.getDate("lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DUE_DATE]));
                rptLimbahPeriod.setNomorTransaksi(rs.getString("lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER]));
                rptLimbahPeriod.setTransHarga(rs.getDouble("lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_HARGA]));
                rptLimbahPeriod.setTotalDenda(rs.getDouble("lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_DENDA]));
                rptLimbahPeriod.setStatusPembayaran(DbLimbahTransaction.Posted_sts_key[rs.getInt("lt." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_STATUS_PEMBAYARAN])]);
                rptLimbahPeriod.setCurrencyCode("Rp");
                rptLimbahPeriod.setCustName(rs.getString("cus." + DbCustomer.colNames[DbCustomer.COL_NAME]));

                result.add(rptLimbahPeriod);
            }

            return result;

        } catch (Exception e) {
            System.out.println("Error when listDenda(#,#,#) " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
}
