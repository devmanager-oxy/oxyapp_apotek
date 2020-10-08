/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.general.Customer;
import com.project.general.DbCustomer;

/**
 *
 * @author Roy
 */
public class SessGlobalDiskon {

    public static Customer getCustomer(long customerId){
        CONResultSet crs = null;
        Customer customer = new Customer();
        try{
            String sql = "select "+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+","+
                    DbCustomer.colNames[DbCustomer.COL_NAME]+" from "+DbCustomer.DB_CUSTOMER+" where "+
                    DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                customer.setOID(rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]));
                customer.setName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME]));
            }
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(crs);
        }
        return customer;
        
    }
    
    public static double getSubTotal(long salesId){
        double subTotal = 0;
        CONResultSet crs = null;
        try{
            String sql = "select sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_id = "+salesId+" group by s.sales_id";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                subTotal = rs.getDouble("sub_total");
            }
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(crs);
        }
        return subTotal;
        
    }
}
