/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.ccs.posmaster.DbItemCategory; 
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbPriceType;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.VendorItem;
import com.project.ccs.postransaction.promotion.DbPromotion;
import com.project.ccs.postransaction.promotion.DbPromotionItem;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.general.DbLocation;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.DateCalc;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class SessReportOutlet {
    
    public static double getTotalOmsetSales(Date startDate, Date endDate, long locationId){
       
        double totalOmset=0;
        
        String sql = "select sum((psd.qty * psd.selling_price)- psd.discount_amount) as totSales from pos_sales_detail psd inner join pos_sales s on psd.sales_id=s.sales_id" +
                " where s.location_id= " + locationId + " and (type =0 or type=1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                
           
        
        CONResultSet crs = null;
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                totalOmset = rs.getDouble(1);
               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return totalOmset;
        
    }
    public static double getTotalRetur(Date startDate, Date endDate, long locationId){
       
        double totalOmset=0;
        
        String sql = "select sum((psd.qty * psd.selling_price)- psd.discount_amount) as totSales from pos_sales_detail psd inner join pos_sales s on psd.sales_id=s.sales_id" +
                " where s.location_id= " + locationId + " and (type =2 or type=3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                
           
        
        CONResultSet crs = null;
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                totalOmset = rs.getDouble(1);
               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return totalOmset;
        
    }
    
    public static double getTotalCreditPayment(Date startDate, Date endDate, long locationId){
       
        double totalOmset=0;
        
        String sql = "select sum(psd.amount * psd.rate) as tot from pos_credit_payment psd inner join pos_sales s on psd.sales_id=s.sales_id" +
                " where s.location_id= " + locationId + " and psd.type <> 4 and to_days(psd.pay_datetime) between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                
           
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                totalOmset = rs.getDouble(1);
               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return totalOmset;
        
    }
    
     public static double getTotalBG(Date startDate, Date endDate, long locationId){
       
        double totalOmset=0;
        
        String sql = "select sum(psd.amount * psd.rate) as tot from pos_credit_payment psd inner join pos_sales s on psd.sales_id=s.sales_id" +
                " where s.location_id= " + locationId + " and psd.type = 4 and to_days(psd.pay_datetime) between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                
           
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                totalOmset = rs.getDouble(1);
               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return totalOmset;
        
    }
    
    
     public static double getKreditBlmLunas(Date startDate, Date endDate, long locationId){
       
        double totalOmset=0;
        
        String sql = "select sum((psd.qty * psd.selling_price)- psd.discount_amount) as totSales from pos_sales_detail psd inner join pos_sales s on psd.sales_id=s.sales_id" +
                " where s.location_id= " + locationId + " and type =1  and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                
           
        
        CONResultSet crs = null;
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                totalOmset = rs.getDouble(1);
               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return totalOmset;
        
    }
     
     

}
