/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.utility.service.salessynch;

import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.admin.*;
import com.project.general.DbLogUpload;
import com.project.interfaces.DbUploader;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy
 */
public class WatcherUploaderTransaction implements Runnable {

    int i = 0;

    public WatcherUploaderTransaction() {
    }

    public void run() {
        System.out.println(".:: [Watcher Upload] started ....................");
        ServiceManagerTransaction objServiceManagerTransaction = ServiceManagerTransaction.getSingleObject();
        while (objServiceManagerTransaction.running) {
            try {
                process();
                long SYNCH_UPLOAD_INTERVAL= Long.parseLong(DbSystemProperty.getValueByName("SYNCH_UPLOAD_INTERVAL"));
                int sleepTime = (int) (SYNCH_UPLOAD_INTERVAL * 60 * 1000);
                System.out.println(".:: [Watcher Upload] finished, service will sleep for " + SYNCH_UPLOAD_INTERVAL + " minutes\r");
                Thread.sleep(sleepTime);
            } catch (Exception e) {
                System.out.println("\t[Watcher Upload] interrupted with message : " + e);
            }
        }
    }

    public void process() {
        int range = 0;
        try {
            range = Integer.parseInt(DbSystemProperty.getValueByName("RANGE_MENIT_DOWNLOAD"));
            range = range * -1;
        } catch (Exception e) {
        }

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        System.out.println(new Date());
        cal.add(Calendar.MINUTE, range);

        try {
            String sql = "select * from " + DbLogUpload.DB_LOG_UPLOAD + " where " + DbLogUpload.colNames[DbLogUpload.COL_STATUS] + " in (0,-1) and " + DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE] + " <= '" + JSPFormater.formatDate(cal.getTime(), "yyyy-MM-dd HH:mm:ss") + "' order by "+DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE];
            System.out.println("sql -> "+sql);
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
                while (rs.next()) {
                    try{
                        long logId = rs.getLong(DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID]);
                        String queryInsert = rs.getString(DbLogUpload.colNames[DbLogUpload.COL_QUERY_STRING]);
                        int x = DbUploader.Upload(queryInsert);                      
                        if(x==1){
                            DbLogUpload.updateSatusLog(logId);
                        }else{
                            DbLogUpload.updateSatusLogSecondProcess(logId);
                        }
                    }catch(Exception e){}
                }

                rs.close();

            } catch (Exception e) {
                System.out.println(e);
            } finally {
                CONResultSet.close(dbrs);
            }
        
        } catch (Exception e) {
            System.out.println(e.toString());
        }

    }
}
