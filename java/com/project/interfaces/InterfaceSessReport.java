/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.interfaces;

import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import com.project.fms.master.*;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class InterfaceSessReport {

    public static Hashtable getInventorySales(int grpType, String wheres, Date invStartDate, Date invEndDate, String whereGroup, String grp) {
        
        Connection conn = null;
        Statement stmt = null;
        Hashtable result = new Hashtable();

        try {

            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();

            String sql1 = "select g.item_group_id as item_group_id,sum(sales) as total_sales,sum(cogs) as total_cogs from ( ";
            String grp1 = "item_group_id";
            String sql2 = "item_group_id";
            if (grpType == 0) {
                sql1 = "select g.item_group_id as item_group_id,sum(sales) as total_sales,sum(cogs) as total_cogs from ( ";
                grp1 = "item_group_id";
                sql2 = " ) y inner join pos_item_group g on y.item_group_id = g.item_group_id group by g.item_group_id ";
            } else {
                sql1 = "";
                grp1 = "item_master_id";
                sql2 = "";
            }
            
            String sqlStartDate = "";
            if(invStartDate != null){
                sqlStartDate = " and to_days(s.date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
            }else{
                sqlStartDate = " and to_days(s.date) < to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
            }

            String sql = sql1 + " select item_master_id,item_group_id,sum(sales) as sales,sum(cogs) as cogs from ( " +
                    " select 0 as type,m.item_master_id as item_master_id,m.item_group_id as item_group_id,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sales,sum(sd.qty*sd.cogs) as cogs from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in(0,1) " + wheres +" "+ sqlStartDate+" " + whereGroup + " group by " + grp + " union " +
                    " select 1 as type,m.item_master_id as item_master_id,m.item_group_id as item_group_id,sum((sd.qty*sd.selling_price)-sd.discount_amount)*-1 as sales,sum(sd.qty*sd.cogs)*-1 as cogs from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in(2,3) " + wheres +" "+ sqlStartDate+" " + whereGroup + " group by " + grp +
                    " ) as x group by " + grp1 + " " + sql2;

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                try{
                    long idx = 0;    
                    double totSales = 0;
                    double totCogs = 0;
                
                    if (grpType == 1) {
                        idx = rs.getLong("item_master_id");
                        totSales = rs.getDouble("sales");    
                        totCogs = rs.getDouble("cogs");    
                    }else{
                        idx = rs.getLong("item_group_id");    
                        totSales = rs.getDouble("total_sales");    
                        totCogs = rs.getDouble("total_cogs");    
                    }
                    Vector tmp = new Vector();
                    tmp.add(String.valueOf(totSales));
                    tmp.add(String.valueOf(totCogs));
                    result.put(String.valueOf(idx), tmp);
                }catch(Exception e){}
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) {
                    conn.close();
                }
            } catch (SQLException se) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return result;
    }
    
    public static Hashtable getInventorySalesQty(int grpType, String wheres, Date invStartDate, Date invEndDate, String whereGroup, String grp) {
        
        Connection conn = null;
        Statement stmt = null;
        Hashtable result = new Hashtable();

        try {

            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();

            String sql1 = "select g.item_group_id as item_group_id,sum(sales) as total_sales,sum(cogs) as total_cogs from ( ";
            String grp1 = "item_group_id";
            String sql2 = "item_group_id";
            if (grpType == 0) {
                sql1 = "select g.item_group_id as item_group_id,sum(sales) as total_sales,sum(cogs) as total_cogs from ( ";
                grp1 = "item_group_id";
                sql2 = " ) y inner join pos_item_group g on y.item_group_id = g.item_group_id group by g.item_group_id ";
            } else {
                sql1 = "";
                grp1 = "item_master_id";
                sql2 = "";
            }
            
            String sqlStartDate = "";
            if(invStartDate != null){
                sqlStartDate = " and to_days(s.date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
            }else{
                sqlStartDate = " and to_days(s.date) < to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
            }

            String sql = sql1 + " select item_master_id,item_group_id,sum(sales) as sales,sum(cogs) as cogs from ( " +
                    " select 0 as type,m.item_master_id as item_master_id,m.item_group_id as item_group_id,sum(sd.qty) as sales,0 as cogs from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in(0,1) " + wheres +" "+ sqlStartDate+" " + whereGroup + " group by " + grp + " union " +
                    " select 1 as type,m.item_master_id as item_master_id,m.item_group_id as item_group_id,sum(sd.qty)*-1 as sales,0 as cogs from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in(2,3) " + wheres +" "+ sqlStartDate+" " + whereGroup + " group by " + grp +
                    " ) as x group by " + grp1 + " " + sql2;

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                try{
                    long idx = 0;    
                    double totSales = 0;
                    double totCogs = 0;
                
                    if (grpType == 1) {
                        idx = rs.getLong("item_master_id");
                        totSales = rs.getDouble("sales");    
                        totCogs = rs.getDouble("cogs");    
                    }else{
                        idx = rs.getLong("item_group_id");    
                        totSales = rs.getDouble("total_sales");    
                        totCogs = rs.getDouble("total_cogs");    
                    }
                    Vector tmp = new Vector();
                    tmp.add(String.valueOf(totSales));
                    tmp.add(String.valueOf(totCogs));
                    result.put(String.valueOf(idx), tmp);
                }catch(Exception e){}
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) {
                    conn.close();
                }
            } catch (SQLException se) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return result;
    }
}
