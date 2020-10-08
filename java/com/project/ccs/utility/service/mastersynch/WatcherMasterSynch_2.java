package com.project.ccs.utility.service.mastersynch;

import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.admin.*;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

public class WatcherMasterSynch_2 implements Runnable {

    int i = 0;
    
    public WatcherMasterSynch_2() {
    }
    
    public void run() {        
        System.out.println(".:: [WatcherMasterSynch] started 2 ....................");
        
        ServiceManagerMasterSynch_2 objServiceManagerMasterSynch = ServiceManagerMasterSynch_2.getSingleObject();//new ServiceManagerMasterSynch_2();        
        
        while (objServiceManagerMasterSynch.running) {            
            try {
                // proses download data from machine MasterSynch                
                process();   // sleeping time for next process
                long SYNCH_MASTER_INTERVAL_2 = Long.parseLong(DbSystemProperty.getValueByName("SYNCH_MASTER_INTERVAL_2"));                
                int sleepTime = (int) (SYNCH_MASTER_INTERVAL_2 * 60 * 2000);
                System.out.println(".:: [WatcherMasterSynch] finished, service will sleep for "+SYNCH_MASTER_INTERVAL_2+" minutes\r");                
                Thread.sleep(sleepTime);                
            } catch (Exception e) {
                System.out.println("\t[WatcherMasterSynch] 2 interrupted with message : " + e);
            }
        }        
    }

    public void process() {        
        
        System.out.println("\r     -> [WatcherMasterSynch] process @ run " + new Date().toLocaleString());
        
        int SYNCH_MASTER_2 = 2;
        String SYNCH_URL_2 = DbSystemProperty.getValueByName("SYNCH_URL_2"); 
        
        System.out.println("\r     -> Sync to URL : "+SYNCH_URL_2);

        // Watcher machine MasterSynch 2
        try {   
            
            boolean stop = false;
            
            while(!stop){
                
                System.out.println("\rget 100 datas to process --------------");
                
                String sql = "select * from logs where sync_status<>2 and sync_status<>12 and sync_status<>123 and sync_status<>23 order by date ";
                
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_ORACLE:
                        break;
                    case CONHandler.CONSVR_MYSQL:
                        sql = sql + " limit 0,100";
                        break;
                    case CONHandler.CONSVR_POSTGRESQL:
                        sql = sql + " limit 0 offset 100";
                        break;
                    case CONHandler.CONSVR_MSSQL:
                        ;
                        break;
                    case CONHandler.CONSVR_SYBASE:
                        break;
                    default:
                        sql = sql + " limit 0,100";
                        break;
                }
                
                CONResultSet dbrs = null;
                try {
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    int cnt = 0;
                    while (rs.next()) {
                        long logId = rs.getLong("log_id");
                        String query = rs.getString("query_string");
                        Date dt = new Date();//rs.getDate("date");
                        String tableName = rs.getString("table_name");
                        int syncStatus = rs.getInt("sync_status");
                        long periodId = rs.getLong("periode_id");
                        cnt = cnt + 1;
                        System.out.println("executing : result i => "+cnt);
                        synchViaURLAccess(logId, query, dt, tableName, syncStatus, periodId, SYNCH_MASTER_2, SYNCH_URL_2);                        
                    }
                    
                    if(cnt==0){
                        stop = true;
                        System.out.println("---> process 2 stoped no data to synch");
                    }
                    
                    rs.close();                    
                            
                } catch (Exception e) {
                    System.out.println(e);
                } finally {
                    CONResultSet.close(dbrs);
                }
                
            }
            
            
        } catch (Exception e) {
            System.out.println(e.toString());
        }     
        
    }
    
    public void synchViaURLAccess(long logId, String query, Date dt, String tableName, int syncStatus, long periodId, int SYNCH_MASTER_2, String SYNCH_URL_2){
        try{
                
                query = query.replace("''", "YY");
                query = query.replace("'", "XX");
                
                //System.out.println("query : "+query);
                
                String urlParameters = "logid="+logId+"&tblname="+tableName+"&qr="+URLEncoder.encode(query, "UTF-8");
                
                URL url = new URL(SYNCH_URL_2);
                URLConnection conn = url.openConnection();
                conn.setDoOutput(true);
                OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
                writer.write(urlParameters);
                writer.flush();                
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String line = "";
                
                Vector tempx = new Vector();
                while ((line = reader.readLine()) != null) {
                    tempx.add(line);
                }
                
                if(tempx!=null && tempx.size()>0){
                    line = ((String)tempx.get(tempx.size()-2)).trim();
                }
                
                //System.out.println("line xx : "+line);
                //System.out.println("tempx : "+tempx);
                
                String strSyncStatus = getSyncStatus(syncStatus);
                
                if(line!=null && line.length()>0){
                    try{
                        int linex = Integer.parseInt(line);
                        //sukses - set period_id status 20 - satu nol, kalau gagal - 21, satu satu
                        //sync_status tambahkan 2 didepan
                        if(linex==0){                            
                            String sql = "update logs set periode_id=20"+((periodId==0) ? "" : ""+periodId)+", sync_status="+strSyncStatus+" where log_id="+logId;
                            CONHandler.execUpdate(sql);
                            System.out.println("---> respon success - update logs status = "+strSyncStatus+" and period = 20, log_id = "+logId);
                        }
                        //error
                        else{
                            String sql = "update logs set periode_id=21"+((periodId==0) ? "" : ""+periodId)+", sync_status="+strSyncStatus+" where log_id="+logId;
                            CONHandler.execUpdate(sql);
                            System.out.println("---> respon not success - update logs status = "+strSyncStatus+" and period = 21, log_id = "+logId);
                        }
                    }
                    catch(Exception ex){
                        String sql = "update logs set periode_id=21"+((periodId==0) ? "" : ""+periodId)+", sync_status="+strSyncStatus+" where log_id="+logId;
                        CONHandler.execUpdate(sql);
                        System.out.println("---> respon not success - update logs status = "+strSyncStatus+" and period = 21, log_id = "+logId);
                    }
                    
                }
                else{
                    String sql = "update logs set periode_id=21"+((periodId==0) ? "" : ""+periodId)+", sync_status="+strSyncStatus+" where log_id="+logId;
                    CONHandler.execUpdate(sql);
                    System.out.println("---> respon not success - update logs status = "+strSyncStatus+" and period = 21, log_id = "+logId);
                }
                
                writer.close();
                reader.close();     
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
    }
    
    public static String getSyncStatus(int syncStatus){
        
        String strSyncStatus = "";
        
        if(syncStatus==0){
            strSyncStatus = "2";
        }
        else{
            
            String strx = ""+syncStatus;
            
            Vector vctStr = new Vector();            
            for(int x=0;x<strx.length();x++){
                vctStr.add(strx.charAt(x));
            }

            Vector result = new Vector();
            result.add("2");
            
            for(int x=0;x<vctStr.size();x++){
                
                int a = Integer.parseInt((String)vctStr.get(x));
                
                boolean found = false;
                
                for(int z=0; z<result.size(); z++){
                    int b = Integer.parseInt((String)result.get(z));
                    //jika ada yg lebih besar pasang depannya
                    if(a<b){
                        result.add(z, ""+a);
                        found = true;
                        break;
                    }                    
                }
                
                //jika tidak ada yg lebih kecil pasang diakhir
                if(!found){
                    result.add(""+a);
                }
            }
            
            for(int i=0; i<result.size(); i++){
                strSyncStatus = strSyncStatus + (String)vctStr.get(i);                
            }
        }
        
        return strSyncStatus;
    }
    
    
    
}
