/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.admin.DbUser;
import com.project.admin.User;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author 
 */
public class SessServiceLevel {    
    
    public static Vector getServiceLevel(long vendorId, long locationId, Date startDate, Date endDate){
        CONResultSet dbrs = null;
        Vector vlist = new Vector();
        try{
            String sqlGabung="";
            String sql1 ="(select sum(ri.qty) as totalpo, 0 as totalincoming from pos_purchase_item ri inner join pos_purchase r on ri.purchase_id=r.purchase_id where to_days(r.purch_date) >= to_days('"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+ "') and to_days(r.purch_date) <= to_days('" + JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"') "; 
            
                if(locationId!=0){
                    sql1=sql1 + " and r.location_id="+locationId;
                            
                }
                if(vendorId!=0){
                    sql1=sql1 + " and r.vendor_id="+vendorId ;
                }
            sql1=sql1+ " group by r.vendor_id ) ";
           
            
            String sql2=" (select 0 as totalpo, sum(ri.qty) as totalincoming from pos_receive_item ri inner join pos_receive r on ri.receive_id=r.receive_id inner join pos_purchase pr on r.purchase_id=pr.purchase_id where r.type_ap=0 and r.purchase_id <> 0 and to_days(pr.purch_date) >= to_days('"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+ "') and to_days(pr.purch_date) <= to_days('" + JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"') ";
            if(locationId!=0){
                    sql2=sql2 + " and r.location_id="+locationId;
                            
                }
                if(vendorId!=0){
                    sql2=sql2 + " and r.vendor_id="+vendorId;
                }
            sql2=sql2+ " group by r.vendor_id ) ";
            
            
            sqlGabung = sqlGabung + " select sum(totalpo) as totPO, sum(totalincoming) as totIn from (" + sql1 + " union " + sql2 + ") as tabel ";
            
            dbrs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = dbrs.getResultSet();
            
           
            while (rs.next()){
                              
                vlist.add(rs.getDouble("totPO"));
                vlist.add(rs.getDouble("totIn"));
                
               
            }
            rs.close();
            return vlist;
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return new Vector();
    }
    
    
    
     public static int getcountServiceLevel(long vendorId, long locationId, Date startDate, Date endDate){
        CONResultSet dbrs = null;
        int total=0;
        try{
            
            String sql1 ="select count(*) as tot from ((select v.vendor_id as vendorId, v.name as namavendor, v.address as alamatvendor, sum(ri.qty) as totalpo, 0 as totalincoming from pos_purchase_item ri inner join pos_purchase r on ri.purchase_id=r.purchase_id inner join vendor v on r.vendor_id=v.vendor_id where to_days(r.purch_date) >= to_days('"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+ "') and to_days(r.purch_date) <= to_days('" + JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"') "; 
            
                if(locationId!=0){
                    sql1=sql1 + " and r.location_id="+locationId;
                            
                }
                if(vendorId!=0){
                    sql1=sql1 + " and r.vendor_id="+vendorId ;
                }
            sql1=sql1+ " group by v.vendor_id )) as tabel ";
           
            
            dbrs = CONHandler.execQueryResult(sql1);
            ResultSet rs = dbrs.getResultSet();
                  
            while (rs.next()){
                total=rs.getInt("tot");
               
                return total;
            }
            rs.close();
            return total;
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return total;
    }
   
    
    
    
    
    
   
    
    
    
    
    
}
