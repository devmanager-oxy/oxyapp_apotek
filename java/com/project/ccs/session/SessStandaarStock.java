/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;


import com.project.ccs.postransaction.stock.DbStock;

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
public class SessStandaarStock {

  public static double getStockByStatus(long locationId, long oidItemMaster, String status){
        double result=0;
        String sql="";
        CONResultSet crs = null;
        try{
           sql ="select sum(qty * in_out) from pos_stock where status='" + status +
                "' and location_id=" + locationId + " and item_master_id=" + oidItemMaster ;
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     result = rs.getDouble(1);
               }
           } catch(Exception ex){
               
           }
        }catch(Exception ex){
            
        }
        return result;
    }   
    
    
}
