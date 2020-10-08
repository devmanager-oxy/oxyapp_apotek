/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.postransaction.sales.DbCreditPayment;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class SessCreditPayment {

    public static Vector listCreditPayment(long locationId, int ignore, Date start, Date end) {

        CONResultSet crs = null;

        try {

            String sql = "select loc." + DbLocation.colNames[DbLocation.COL_NAME] + " locName," +
                    "loc." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " locId," +
                    "ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " salesId," +
                    "ps." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " cstId," +
                    "ps." + DbSales.colNames[DbSales.COL_NUMBER] + " salesNum," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + " cpId," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " cpDate," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] + " cpAmount," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " cpStatus " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbCreditPayment.DB_CREDIT_PAYMENT + " pc on ps." +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = pc." + DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " loc on ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = loc." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " where " +
                    " ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_CREDIT + " and pc." + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " = 0 ";

            if (locationId != 0) {
                sql = sql + " and ps." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;
            }

            if (ignore != 1) {
                sql = sql + " and pc." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " BETWEEN '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "' ";
            }
            
            sql = sql + " order by ps."+DbSales.colNames[DbSales.COL_CUSTOMER_ID];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            Vector result = new Vector();

            while (rs.next()) {

                ReportCreditPayment rcp = new ReportCreditPayment();
                rcp.setLocName(rs.getString("locName"));
                rcp.setLocId(rs.getLong("locId"));
                rcp.setCstId(rs.getLong("cstId"));
                rcp.setSalesId(rs.getLong("salesId"));
                rcp.setSalesNumb(rs.getString("salesNum"));
                rcp.setCpId(rs.getLong("cpId"));
                rcp.setCpDate(rs.getDate("cpDate"));
                rcp.setCpAmount(rs.getDouble("cpAmount"));
                rcp.setCpStatus(rs.getInt("cpStatus"));
                result.add(rcp);
            }
            return result;
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }
    
    
    public static Vector listCrdPayment(long customerId, int paid) {

        CONResultSet crs = null;

        try {

            //String sql = "select ";
            
            //select ps.sales_id,ps.number,ps.customer_id,pcp.amount, ps.posted_status from pos_sales ps left join pos_credit_payment pcp on ps.sales_id = pcp.sales_id where pcp.posted_status = 0 and ps.type = 1 and to_days(ps.date) >= to_days('2013-01-01') order by customer_id;
            
            String sql = "select loc." + DbLocation.colNames[DbLocation.COL_NAME] + " locName," +
                    "loc." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " locId," +
                    "ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " salesId," +
                    "ps." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " cstId," +
                    "ps." + DbSales.colNames[DbSales.COL_NUMBER] + " salesNum," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + " cpId," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " cpDate," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] + " cpAmount," +
                    "pc." + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " cpStatus " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbCreditPayment.DB_CREDIT_PAYMENT + " pc on ps." +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = pc." + DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " loc on ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = loc." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " where " +
                    " ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_CREDIT + " and pc." + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " = 0 ";

            if (customerId != 0) {
                sql = sql + " and ps." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " = " + customerId;
            }
            
            sql = sql + " order by ps."+DbSales.colNames[DbSales.COL_CUSTOMER_ID];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            Vector result = new Vector();

            while (rs.next()) {

                ReportCreditPayment rcp = new ReportCreditPayment();
                rcp.setLocName(rs.getString("locName"));
                rcp.setLocId(rs.getLong("locId"));
                rcp.setCstId(rs.getLong("cstId"));
                rcp.setSalesId(rs.getLong("salesId"));
                rcp.setSalesNumb(rs.getString("salesNum"));
                rcp.setCpId(rs.getLong("cpId"));
                rcp.setCpDate(rs.getDate("cpDate"));
                rcp.setCpAmount(rs.getDouble("cpAmount"));
                rcp.setCpStatus(rs.getInt("cpStatus"));
                result.add(rcp);
            }
            return result;
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }
    
    //ED
    public static int isFeeByCompany(long salesId){
        
        String sql = "select count(pp."+DbPayment.colNames[DbPayment.COL_PAYMENT_ID]+")" +
                " from "+DbPayment.DB_PAYMENT+" pp "+
                " inner join "+DbMerchant.DB_MERCHANT+" m "+
                " on pp."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = "+
                " m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]+
                " where pp."+DbPayment.colNames[DbPayment.COL_SALES_ID]+"="+salesId+
                " and (pp."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+"="+DbPayment.PAY_TYPE_CREDIT_CARD+
                " or pp."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+"="+DbPayment.PAY_TYPE_DEBIT_CARD+")"+
                " and m.payment_by = "+DbMerchant.PAYMENT_BY_COMPANY;
        
        int cnt = 0;
        
        CONResultSet crs = null;
        try{
           crs = CONHandler.execQueryResult(sql);
           ResultSet rs = crs.getResultSet();
           while(rs.next()){
                cnt = rs.getInt(1);
           }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return cnt;
    }
    
    
    
}
