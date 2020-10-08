/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.I_Project;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class SessNeracaSaldo {

    public static double getAmount(long coaId, long periodeId) {

        try {

            Coa coa = new Coa();
            int level = 0;
            try {
                coa = DbCoa.fetchExc(coaId);
                level = coa.getLevel();
            } catch (Exception e) {
            }

            Periode per = new Periode();
            try {
                per = DbPeriode.fetchExc(periodeId);
            } catch (Exception e) {
            }

            Date dt = per.getEndDate();
            Date startDate = (Date) dt.clone();
            startDate.setDate(1);
            startDate.setMonth(0);

            boolean isDebet = false;

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                isDebet = true;
            }

            String sql = "";

            if (isDebet) {
                sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")";
            } else {
                sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")";
            }

            sql = sql + " from " + DbGlDetail.DB_GL_DETAIL + " gd " +
                    " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "= gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                    " where " +
                    " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId + " and " +
                    " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED + " and ";

            switch (level) {
                case 1:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] + "=" + coaId;
                    break;
                case 2:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] + "=" + coaId;
                    break;
                case 3:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] + "=" + coaId;
                    break;
                case 4:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] + "=" + coaId;
                    break;
                case 5:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] + "=" + coaId;
                    break;
                case 6:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] + "=" + coaId;
                    break;
                case 7:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] + "=" + coaId;
                    break;
            }

            System.out.println("Sql Neraca Saldo : "+sql);

            CONResultSet crs = null;
            
            double result = 0;
            
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
                
                return result;
                
            } catch (Exception e) {
                System.out.println("[exception] "+e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            
        } catch (Exception e) {}

        return 0;

    }
    
    
    public static double getDebet(long coaId, long periodeId) {

        try {

            Coa coa = new Coa();
            int level = 0;
            try {
                coa = DbCoa.fetchExc(coaId);
                level = coa.getLevel();
            } catch (Exception e) {
            }

            Periode per = new Periode();
            try {
                per = DbPeriode.fetchExc(periodeId);
            } catch (Exception e) {
            }

            Date dt = per.getEndDate();
            Date startDate = (Date) dt.clone();
            startDate.setDate(1);
            startDate.setMonth(0);

            String sql = "";
            
            sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ") ";

            sql = sql + " from " + DbGlDetail.DB_GL_DETAIL + " gd " +
                    " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "= gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                    " where " +
                    " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId + " and " +
                    " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED + " and ";

            switch (level) {
                case 1:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] + "=" + coaId;
                    break;
                case 2:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] + "=" + coaId;
                    break;
                case 3:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] + "=" + coaId;
                    break;
                case 4:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] + "=" + coaId;
                    break;
                case 5:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] + "=" + coaId;
                    break;
                case 6:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] + "=" + coaId;
                    break;
                case 7:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] + "=" + coaId;
                    break;
            }

            System.out.println("SQL DEBET : "+sql);

            CONResultSet crs = null;
            
            double result = 0;
            
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
                
                return result;
                
            } catch (Exception e) {
                System.out.println("[exception] "+e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            
        }catch (Exception e){
            System.out.println("[exception] "+e.toString());
        }

        return 0;

    }
    
    public static double getCredit(long coaId, long periodeId) {

        try {

            Coa coa = new Coa();
            int level = 0;
            try {
                coa = DbCoa.fetchExc(coaId);
                level = coa.getLevel();
            } catch (Exception e) {
            }

            Periode per = new Periode();
            try {
                per = DbPeriode.fetchExc(periodeId);
            } catch (Exception e) {
            }

            Date dt = per.getEndDate();
            Date startDate = (Date) dt.clone();
            startDate.setDate(1);
            startDate.setMonth(0);
           
            String sql = "";
            
            sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ") ";

            sql = sql + " from " + DbGlDetail.DB_GL_DETAIL + " gd " +
                    " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "= gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                    " where " +
                    " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId + " and " +
                    " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED + " and ";

            switch (level) {
                case 1:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] + "=" + coaId;
                    break;
                case 2:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] + "=" + coaId;
                    break;
                case 3:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] + "=" + coaId;
                    break;
                case 4:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] + "=" + coaId;
                    break;
                case 5:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] + "=" + coaId;
                    break;
                case 6:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] + "=" + coaId;
                    break;
                case 7:
                    sql = sql + " gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] + "=" + coaId;
                    break;
            }

            System.out.println("SQL CREDIT : "+sql);

            CONResultSet crs = null;
            
            double result = 0;
            
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
                
                return result;
                
            } catch (Exception e) {
                System.out.println("[exception] "+e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            
        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        }

        return 0;

    }
    
}
