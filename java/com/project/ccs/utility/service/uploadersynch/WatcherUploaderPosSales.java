/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.utility.service.uploadersynch;

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

/**
 *
 * @author Roy
 */
public class WatcherUploaderPosSales implements Runnable {

    int i = 0;

    public WatcherUploaderPosSales() {}

    public void run() {
        System.out.println(".:: [WatcherMasterSynch] started ....................");
        ServiceManagerPosSales objServiceManagerMasterSynch = ServiceManagerPosSales.getSingleObject();

        while (objServiceManagerMasterSynch.running) {
            try { 
                process();
                long SYNCH_MASTER_INTERVAL_1 = Long.parseLong(DbSystemProperty.getValueByName("SYNCH_MASTER_INTERVAL_1"));
                int sleepTime = (int) (SYNCH_MASTER_INTERVAL_1 * 60 * 1000);
                System.out.println(".:: [WatcherMasterSynch] finished, service will sleep for " + SYNCH_MASTER_INTERVAL_1 + " minutes\r");
                Thread.sleep(sleepTime);
            } catch (Exception e) {
                System.out.println("\t[WatcherMasterSynch] interrupted with message : " + e);
            }
        }
    }

    public void process() {

        System.out.println("\r     -> [WatcherMasterSynch] process @ run updated with 5 item loops " + new Date().toLocaleString());
        //int SYNCH_MASTER_1 = 1;
        String SYNCH_URL_1 = DbSystemProperty.getValueByName("SYNCH_UPLOAD_URL_1");
        System.out.println("\r     -> Sync to URL : " + SYNCH_URL_1);

        // Watcher machine MasterSynch 1
        try {

            //boolean stop = false;
            //while (!stop) {
                System.out.println("\rget 100 datas to process --------------");
                String sql = "select * from pos_sales where sts_upload = 0 order by date ";

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
                        long logId = rs.getLong("sales_id");
                        String query = rs.getString("query_string");
                        /*Date dt = new Date();//rs.getDate("date");
                        String tableName = rs.getString("table_name");
                        int syncStatus = rs.getInt("sync_status");
                        long periodId = rs.getLong("periode_id");*/
                        cnt = cnt + 1;                        
                        synchViaURLAccess(logId, query,SYNCH_URL_1);
                    }

                    /*if (cnt == 0) {
                        stop = true;
                        System.out.println("---> no data to synch");
                    }*/

                    rs.close();

                } catch (Exception e) {
                    System.out.println(e);
                } finally {
                    CONResultSet.close(dbrs);
                }
            //}
        } catch (Exception e) {
            System.out.println(e.toString());
        }

    }

    public void synchViaURLAccess(long logId, String query, String SYNCH_URL_1) {
        try {
            String urlParameters = "sqlval=" + query;
            URL url = new URL(SYNCH_URL_1);
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

            if (tempx != null && tempx.size() > 0) {
                line = ((String) tempx.get(tempx.size() - 1)).trim();
            }

            System.out.println("line : "+line);
            
            if (line != null && line.length() > 0) {
                try {
                    int linex = Integer.parseInt(line);
                    //sukses - set period_id status 10 - satu nol, kalau gagal - 11, satu satu
                    //sync_status tambahkan 1 didepan
                    if (linex == 1) {
                        String sql = "update pos_sales set sts_upload = 1 where sales_id=" + logId;
                        CONHandler.execUpdate(sql);
                        System.out.println("---> respon success - update logs status = 1 where sts_upload=" + logId);
                    } //error
                    else {   
                        String sql = "update pos_sales set sts_upload = 2 where sales_id=" + logId;
                        CONHandler.execUpdate(sql);                        
                        System.out.println("---> respon not success - , log_id=" + logId);
                    }
                } catch (Exception ex) {
                    String sql = "update pos_sales set sts_upload = 2 where sales_id=" + logId;
                    CONHandler.execUpdate(sql);  
                    System.out.println("---> respon not success - , log_id=" + logId);
                }
            } 
            writer.close();
            reader.close();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
