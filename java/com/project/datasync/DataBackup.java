/*
 * DataBackup.java
 *
 * Created on March 20, 2008, 5:41 PM
 */

package com.project.datasync;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
//import com.project.fms.master.*;
//import com.project.fms.transaction.*;
import com.project.util.*;
import com.project.system.*;
import com.project.util.encript.*;

/**
 *
 * @author  Valued Customer
 */
public class DataBackup {
    
    public static void generateBackupFile(){
        
    }
    
    /** Creates a new instance of TestSavingFile */
    public DataBackup() {
    }
    
    public static String createFileEncripted(Date startDate, Date endDate){
        
        boolean result = true;
        
        System.out.println("\n---START BACKUP ---- \n");
        
        String target = DbSystemProperty.getValueByName("DWLD_TARGET");
        
        if(target==null || target.length()<1){
            return "Backup process failed";            
        }
        
        //System.out.println("Encript data to :: "+target);
        String fileName = target+"\\Finance-backup-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt";
        
        PrintStream MyOutput = null;
        try {
               MyOutput = new PrintStream(new FileOutputStream(target+"\\Finance-backup-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt"));           
        }
        catch (IOException e)        
        {
              System.out.println(e.toString());  
              System.out.println("OOps");        
              //MyOutput = new PrintStream(new FileOutputStream(target+"\\finance-backup-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt"));           
        }
        
        String sql = "select * from logs where to_days(date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
        System.out.println("sql : "+sql);
        
        CONResultSet crs = null;
        Vector temp = new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                String str = rs.getString("query_string");
                temp.add(str);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        //System.out.println("temp : "+temp);

        if(temp!=null && temp.size()>0){
           
           System.out.println("--Total data : "+temp.size()); 
            
           for (int i=0; i<temp.size(); i++) {

               String encChr = TextEncriptor.getEncriptType();

               String query  = (String)temp.get(i);

               System.out.println("---------- process line : "+i);

               //0 - oid
               if(query==null || query.length()==0){
                    MyOutput.print(TextLibrary.strNull+"|");                       
               }
               else{
                    MyOutput.print(TextEncriptor.encriptText(encChr, ""+query)+"|"+encChr);                       
               }

               MyOutput.println("");    

               MyOutput.flush();

           }
           
           MyOutput.close();
        }
        
        
        try{
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            bh.setStartDate(startDate);
            bh.setEndDate(endDate);
            bh.setNote("Backup data");
            bh.setType(DbBackupHistory.TYPE_BACKUP); 
            
            DbBackupHistory.insertExc(bh);
        }
        catch(Exception e){
        }
      
        System.out.println("\nend backup ---- \n");
        
        return fileName;
        
        
    }
    
    public static String createFileEncriptedRetail(String namePrefix, long location_id){//, long oidPeriode, Date startDate, Date endDate){
        
        boolean result = true;
        
        System.out.println("\n---START BACKUP ---- \n");
        
        String target = DbSystemProperty.getValueByName("DWLD_TARGET");
        
        if(target==null || target.length()<1){
            return "Backup process failed";            
        }
        
        //System.out.println("Encript data to :: "+target);
        //String fileName = target+"\\Finance-Backup-"+namePrefix+"-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt";
        String fileName = target+"\\d_"+location_id + ".txt"; // "+JSPFormater.formatDate(new Date(), "ddMMMyy")+".txt";
        
        
        PrintStream MyOutput = null;
        try {
               MyOutput = new PrintStream(new FileOutputStream(fileName));           
        }
        catch (IOException e)        
        {
              System.out.println(e.toString());  
              System.out.println("OOps");        
              //MyOutput = new PrintStream(new FileOutputStream(target+"\\finance-backup-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt"));           
        }
        String sql="";
        if(location_id!=0){
            sql = "select * from logs lg inner join log_status lgs on lg.log_id= lgs.log_id where lgs.status=0 and location_id=" + location_id;//periode_id="+oidPeriode;
        }else{
            sql = "select * from logs where sync_status=0";//periode_id="+oidPeriode;
        }
            
        
        
        System.out.println("sql : "+sql);
        
        CONResultSet crs = null;
        Vector temp = new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	Vector xx = new Vector();
                
                String table = rs.getString("table_name");                
                String str = rs.getString("query_string");    
                long oid = rs.getLong("log_id");    
                
                xx.add(table);	            
                xx.add(str);
                xx.add(""+oid);
                	
                temp.add(xx);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        //System.out.println("temp : "+temp);

        if(temp!=null && temp.size()>0){
           
           System.out.println("--Total data : "+temp.size()); 
            
           for (int i=0; i<temp.size(); i++) {
           		
           	   Vector xTemp = (Vector)temp.get(i);  	   	

               String encChr = TextEncriptor.getEncriptType();

			   String table  = (String)xTemp.get(0);	
               String query  = (String)xTemp.get(1);

               System.out.println("---------- process line : "+i);

               //0 - oid
               if(query==null || query.length()==0){
                    MyOutput.print(TextLibrary.strNull+"|");                       
               }
               else{
                    //MyOutput.print(TextEncriptor.encriptText(encChr, ""+table)+"(*)"+TextEncriptor.encriptText(encChr, ""+query)+"|"+encChr);                       
                   MyOutput.print(TextEncriptor.encriptText(encChr, ""+query) + "|" + encChr);                       
               }

               MyOutput.println("");    

               MyOutput.flush();
               
               //update status
               try{
               		long oid = Long.parseLong((String)xTemp.get(2));
               		CONHandler.execUpdate("update log_status set status=1 where location_id="+location_id);
               }
               catch(Exception e){
               
               }

           }
           
           MyOutput.close();
        }
        
        
        try{
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            bh.setStartDate(new Date());
            bh.setEndDate(new Date());
            bh.setNote("Backup data");
            bh.setType(DbBackupHistory.TYPE_BACKUP); 
            
            DbBackupHistory.insertExc(bh);
        }
        catch(Exception e){
        }
      
        System.out.println("\nend backup ---- \n");
        
        return fileName;
        
        
    }
    
    
    public static String createFileEncripted(String namePrefix){//, long oidPeriode, Date startDate, Date endDate){
        
        boolean result = true;
        
        System.out.println("\n---START BACKUP ---- \n");
        
        String target = DbSystemProperty.getValueByName("DWLD_TARGET");
        
        if(target==null || target.length()<1){
            return "Backup process failed";            
        }
        
        //System.out.println("Encript data to :: "+target);
        //String fileName = target+"\\Finance-Backup-"+namePrefix+"-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt";
        String fileName = target+"\\Finance-Backup-"+namePrefix+"-"+JSPFormater.formatDate(new Date(), "ddMMMyy")+".txt";
        
        PrintStream MyOutput = null;
        try {
               MyOutput = new PrintStream(new FileOutputStream(fileName));           
        }
        catch (IOException e)        
        {
              System.out.println(e.toString());  
              System.out.println("OOps");        
              //MyOutput = new PrintStream(new FileOutputStream(target+"\\finance-backup-"+JSPFormater.formatDate(startDate, "dd-MM-yy")+"-"+JSPFormater.formatDate(endDate, "dd-MM-yy")+".txt"));           
        }
        
        
        String sql = "select * from logs where sync_status=0";//periode_id="+oidPeriode;
        
        System.out.println("sql : "+sql);
        
        CONResultSet crs = null;
        Vector temp = new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	Vector xx = new Vector();
                
                String table = rs.getString("table_name");                
                String str = rs.getString("query_string");    
                long oid = rs.getLong("log_id");    
                
                xx.add(table);	            
                xx.add(str);
                xx.add(""+oid);
                	
                temp.add(xx);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        //System.out.println("temp : "+temp);

        if(temp!=null && temp.size()>0){
           
           System.out.println("--Total data : "+temp.size()); 
            
           for (int i=0; i<temp.size(); i++) {
           		
           	   Vector xTemp = (Vector)temp.get(i);  	   	

               String encChr = TextEncriptor.getEncriptType();

			   String table  = (String)xTemp.get(0);	
               String query  = (String)xTemp.get(1);

               System.out.println("---------- process line : "+i);

               //0 - oid
               if(query==null || query.length()==0){
                    MyOutput.print(TextLibrary.strNull+"|");                       
               }
               else{
                    MyOutput.print(TextEncriptor.encriptText(encChr, ""+table)+"(*)"+TextEncriptor.encriptText(encChr, ""+query)+"|"+encChr);                       
               }

               MyOutput.println("");    

               MyOutput.flush();
               
               //update status
               try{
               		long oid = Long.parseLong((String)xTemp.get(2));
               		CONHandler.execUpdate("update logs set sync_status=1 where log_id="+oid);
               }
               catch(Exception e){
               
               }

           }
           
           MyOutput.close();
        }
        
        
        try{
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            bh.setStartDate(new Date());
            bh.setEndDate(new Date());
            bh.setNote("Backup data");
            bh.setType(DbBackupHistory.TYPE_BACKUP); 
            
            DbBackupHistory.insertExc(bh);
        }
        catch(Exception e){
        }
      
        System.out.println("\nend backup ---- \n");
        
        return fileName;
        
        
    }
    
    
}
