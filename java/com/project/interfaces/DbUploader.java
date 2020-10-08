/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.interfaces;

import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.Sales;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;


/**
 *
 * @author Roy
 */
public class DbUploader {
    
    private static String dbUrl = CONHandlerInterface.getDbUrl();
    private static String dbName = CONHandlerInterface.getDbName();
    private static String dbUser = CONHandlerInterface.getDbUser();
    private static String dbPassword = CONHandlerInterface.getDbPassword();

    public static int Upload(String sql){       
        Connection conn = null;
        Statement stmt = null;
        int result = 0;
        try {
            Class.forName("com.mysql.jdbc.Driver");            
            conn = DriverManager.getConnection(dbUrl+dbName, dbUser, dbPassword);
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
            result = 1;
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
    
    public static Sales getSales(long oid){       
        Connection conn = null;
        Statement stmt = null;        
        Sales s = new Sales();
        try {
            Class.forName("com.mysql.jdbc.Driver");            
            conn = DriverManager.getConnection(dbUrl+dbName, dbUser, dbPassword);
            stmt = conn.createStatement();
            String sql = "select "+DbSales.colNames[DbSales.COL_NUMBER]+","+DbSales.colNames[DbSales.COL_TYPE]+" from "+DbSales.DB_SALES+" where "+DbSales.colNames[DbSales.COL_SALES_ID]+" = "+oid;            
            ResultSet rs = stmt.executeQuery(sql);            
            while(rs.next()){
                String number = rs.getString(DbSales.colNames[DbSales.COL_NUMBER]);
                int type = rs.getInt(DbSales.colNames[DbSales.COL_TYPE]);                
                s.setNumber(number);
                s.setType(type);
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
        return s;
    }
}
