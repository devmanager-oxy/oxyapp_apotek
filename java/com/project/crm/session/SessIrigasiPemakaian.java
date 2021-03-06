/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.session;

import java.io.*;
import java.sql.*;
import java.util.*; 

import com.project.main.db.CONResultSet;
import java.util.Vector;
import com.project.crm.master.irigasi.*;
import com.project.crm.transaction.DbIrigasiTransaction;
import com.project.fms.master.DbPeriode; 
import com.project.crm.report.RptPemakaianIrigasiPeriod;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;

/**
 *
 * @author Tu Roy
 */
public class SessIrigasiPemakaian {

    /**
     * @Author  putu adnyana
     * @param   periodId
     * @Desc    untuk mendapatkan list report pemakaian air irigasi bulanan
     * @return  report
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
                    "tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_KETERANGAN] + " as keterangan," +
                    "mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " as iriId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " as periodId," +
                    "per." + DbPeriode.colNames[DbPeriode.COL_NAME] + " as periodName " +
                    " FROM " + DbCustomer.DB_CUSTOMER + " cust INNER JOIN " + DbIrigasiTransaction.DB_IRIGASI_TRANSACTION+ " tran ON " +
                    " cust." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] +
                    " INNER JOIN " + DbIrigasi.DB_IRIGASI + " mast ON tran." + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID] +
                    " = mast." + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " INNER JOIN " + DbPeriode.DB_PERIODE + " per ON tran." +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + " = per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " WHERE " +
                    " per." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;
  
            System.out.println(sql);
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
