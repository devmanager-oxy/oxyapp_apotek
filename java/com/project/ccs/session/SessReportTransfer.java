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
public class SessReportTransfer {    
    
    public static Vector getSumaryTransfer(int start, int recordToGet, int srcIgnore, long srclocFromId, long srclocToId, String srcStatus, String srcTransferNumber,Date srcStartDate,Date srcEndDate){
        CONResultSet dbrs = null;
        Vector vlist = new Vector();
        try{
            String sql ="select t.transfer_id, t.number,t.date,t.from_location_id, t.to_location_id, t.status, u.login_id, sum(ti.amount) as total, t.note from pos_transfer t inner join pos_transfer_item ti on t.transfer_id=ti.transfer_id inner join sysuser u on t.user_id=u.user_id ";
            
            if(srclocFromId != 0){
                sql= sql + " t.from_location_id="+srclocFromId;
            }
            
            if(srclocToId != 0){
                sql= sql + " and t.to_location_id="+srclocToId;
            }
            
            if(srcStatus.length()>0){
                sql= sql + " and t.status='"+srcStatus +"'";
            }
            
            if(srcTransferNumber.length()>0){
                sql= sql + " and t.number='"+srcTransferNumber +"'";
            }
            
            if(srcIgnore==0){
                sql= sql + " and (to_days(t.date)>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days(t.date)<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')) ";
            }
            
            sql = sql + " group by t.transfer_id ";
            sql = sql + " limit "+start+"," + recordToGet;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
           
            while (rs.next()) {
                 Vector list = new Vector();
                list.add(rs.getLong("transfer_id"));
                list.add(rs.getString("number"));
                list.add(rs.getString("date"));
                list.add(rs.getLong("from_location_id"));
                list.add(rs.getLong("to_location_id"));
                list.add(rs.getString("status"));
                list.add(rs.getString("login_id"));
                list.add(rs.getDouble("total"));
                list.add(rs.getString("note"));
                vlist.add(list);
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
    
    
    
     public static int getcountTransfer(int srcIgnore, long srclocFromId, long srclocToId, String srcStatus, String srcTransferNumber,Date srcStartDate,Date srcEndDate){
        CONResultSet dbrs = null;
        int tot = 0;
        try{
            String sql ="select count(*) as tot from ((select t.transfer_id from pos_transfer t inner join pos_transfer_item ti on t.transfer_id=ti.transfer_id inner join sysuser u on t.user_id=u.user_id ";
            
            if(srclocFromId != 0){
                sql= sql + " t.from_location_id="+srclocFromId;
            }
            
            if(srclocToId != 0){
                sql= sql + " and t.to_location_id="+srclocToId;
            }
            
            if(srcStatus.length()>0){
                sql= sql + " and t.status='"+srcStatus +"'";
            }
            
            if(srcTransferNumber.length()>0){
                sql= sql + " and t.number='"+srcTransferNumber +"'";
            }
            
            if(srcIgnore==0){
                sql= sql + " and (to_days(t.date)>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days(t.date)<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')) ";
            }
            
            sql = sql + " group by t.transfer_id )) as tabel ";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
           
            while (rs.next()){
                tot=rs.getInt("tot");
            }
            rs.close();
            return tot;
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return tot;
    }
   
    
    
    
    
    
   
    
    
    
    
    
}
