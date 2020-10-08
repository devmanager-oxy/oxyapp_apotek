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
import com.project.general.DbCustomer;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Hashtable;


/**
 *
 * @author Roy
 */
public class InterfaceMember {

    public static Hashtable getPenjualan(long oidPublic,String wheres,Date srcStartDate,Date srcEndDate){
        
        Connection conn = null;
        Statement stmt = null;
        Hashtable result = new Hashtable();
        try{
            
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();
            
            String sql = "select customer_id as customer_id,sum(penjualan) as penjualan from ("+
                    "       select ps.customer_id as customer_id,sum((psd.qty * psd.selling_price)- psd.discount_amount) as penjualan from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            " where ps.type in (0,1) and ps.customer_id != "+oidPublic+" " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' group by ps.customer_id union " +                            
                            " select ps.customer_id as customer_id,sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as penjualan from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            " where ps.type in (2,3) and ps.customer_id != "+oidPublic+" " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' group by ps.customer_id ) as x group by customer_id";
                            
           ResultSet rs = stmt.executeQuery(sql);

           while (rs.next()) {
                long customerId = rs.getLong("customer_id");
                double penjualan = rs.getDouble("penjualan");
                result.put(String.valueOf(customerId),String.valueOf(penjualan));
           }                 
            
        }catch (SQLException se) {
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
    
    public static Hashtable getPenjualanByLocation(long oidPublic,String wheres,Date srcStartDate,Date srcEndDate){
        
        Connection conn = null;
        Statement stmt = null;
        Hashtable result = new Hashtable();
        try{
            
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();
            
            String sql =    " select location_id,sum(penjualan) as penjualan from ( "+
                            " select ps.location_id as location_id,sum((psd.qty * psd.selling_price)- psd.discount_amount) as penjualan from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            " inner join customer c on ps.customer_id = c.customer_id " +
                            " where ps.type in (0,1) and ps.customer_id != " + oidPublic + " " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and c.type in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ") group by ps.location_id union " +
                            
                            " select ps.location_id as location_id,sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as penjualan from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            " inner join customer c on ps.customer_id = c.customer_id " +
                            " where ps.type in (2,3) and ps.customer_id != " + oidPublic + " " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and c.type in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ") group by ps.location_id ) as x group by location_id ";
                            
           ResultSet rs = stmt.executeQuery(sql);

           while (rs.next()) {
                long locationId = rs.getLong("location_id");
                double penjualan = rs.getDouble("penjualan");
                result.put(String.valueOf(locationId),String.valueOf(penjualan));
           }                 
            
        }catch (SQLException se) {
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
