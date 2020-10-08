package com.project.crm.session;

import java.io.*;
import java.sql.*;
import java.util.*; 

import com.project.main.db.CONResultSet;
import java.util.Vector;
import com.project.crm.master.limbah.*;
import com.project.crm.transaction.DbLimbahTransaction;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.crm.report.RptIrigasiPeriod;
import com.project.crm.report.RptPemakaianIrigasiPeriod;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;

public class SessLimbahPemakaian {
	
    public static Vector ListReportLimbahTransaction(long periodId) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as custId," +
                    "cust." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as custName," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " as transId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " as transPeriodId," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI] + " as transBulanIni," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU] + " as transBulanLalu," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED] + " as persentase," +
                    "tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_KETERANGAN] + " as keterangan," +
                    "mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " as iriId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " + 
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbLimbahTransaction.DB_LIMBAH_TRASACTION+ " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbLimbah.DB_LIMBAH + " mast ON tran." + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID] +
                    " = mast." + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector result = new Vector();
            while (rs.next()) {

                //RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();
                RptPemakaianIrigasiPeriod rptPemakaianIrigasiPeriod = new RptPemakaianIrigasiPeriod();


                rptPemakaianIrigasiPeriod.setCustId(rs.getLong("custId"));
                rptPemakaianIrigasiPeriod.setCustName(rs.getString("custName"));
                
                rptPemakaianIrigasiPeriod.setTransId(rs.getLong("transId"));
                rptPemakaianIrigasiPeriod.setTransPeriodId(rs.getLong("transPeriodId"));
                rptPemakaianIrigasiPeriod.setTransBulanIni(rs.getDouble("transBulanIni"));
                rptPemakaianIrigasiPeriod.setTransBulanLalu(rs.getDouble("transBulanLalu"));
                                
                rptPemakaianIrigasiPeriod.setIriId(rs.getLong("iriId"));
                
                rptPemakaianIrigasiPeriod.setPeriodId(rs.getLong("periodId"));
                rptPemakaianIrigasiPeriod.setPeriodName(rs.getString("PeriodName"));
                rptPemakaianIrigasiPeriod.setKeterangan(rs.getString("keterangan"));
                rptPemakaianIrigasiPeriod.setPersentase(rs.getDouble("persentase"));
                
                result.add(rptPemakaianIrigasiPeriod);
            }

            return result;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }	
}
