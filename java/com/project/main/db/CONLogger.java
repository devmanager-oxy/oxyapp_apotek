package com.project.main.db;

import java.io.*;
import java.text.SimpleDateFormat;
import java.sql.*;
import java.util.Date;
import java.util.*;
import com.project.system.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.util.*;

public class CONLogger {

    public static int OUT_TARGET_STDIO = 0;
    public static int OUT_TARGET_FILE = 1;
    public static int OUT_TARGET_RDBMS = 2;
    static final int CRITICAL_ERROR = 1;
    static final int ERROR = 2;
    static final int WARNING = 3;
    static final int INFO = 4;
    static final int TRACE = 5;
    public static String LOGS_STRING_DELIMETER = "^";
    private static final String KEY_DBLAYER_LOG = "dblayer_log";
    private static final String KEY_LEVEL_LOG = "loglevel";
    private static final String DATE_LOG_FORMAT = "dd.MM.yyyyy hh:mm:ss";
    private static CONLogger logger = null;
    private OutputStream stream;
    private PrintStream print;
    private int outputTarget = OUT_TARGET_FILE;
    String logfile;
    int loglevel;
    
    public CONLogger() {
    }

    public static void insertLogs(String queryInsert) {
        try {
            Company comp = DbCompany.getCompany();
            queryInsert = queryInsert.replace("'", "\\'");

            String sql = "insert into logs (log_id, query_string, company_id) values (" + OIDGenerator.generateOID() + ", '" + queryInsert + "'," + comp.getOID() + ")";
            CONHandler.execUpdate(sql);

        } catch (Exception e) {}
    }

    public static void insertLogs(String queryInsert, String tableName) {

        try {

            if (notInExceptionTable(tableName)) {

                Company comp = DbCompany.getCompany();

                Periode periode = DbPeriode.getOpenPeriod();
                Date dt = periode.getStartDate();
                dt.setDate(dt.getDate() + 5);
                
                switch (CONHandler.CONSVR_TYPE) {                
                    case CONHandler.CONSVR_MYSQL:
                        queryInsert = queryInsert.replace("'", "\\'");
                    break;

                    case CONHandler.CONSVR_POSTGRESQL:
                        queryInsert = queryInsert.replace("'", "\"");
                    break;

                    case CONHandler.CONSVR_SYBASE:
                        queryInsert = queryInsert.replace("'", "\\'");
                    break;

                    case CONHandler.CONSVR_ORACLE:
                        queryInsert = queryInsert.replace("'", "\\'");
                    break;

                    case CONHandler.CONSVR_MSSQL:
                        queryInsert = queryInsert.replace("'", "\\'");
                    break;

                    default:
                        queryInsert = queryInsert.replace("'", "\'");
                    break;
                }
                
                long log_id = OIDGenerator.generateOID();

                String sql = "insert into logs (log_id, query_string, company_id, table_name, period_middle_date)" +
                        " values (" + log_id + ", '" + queryInsert + "'," + comp.getOID() + ",'" +
                        tableName + "','" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')";

                CONHandler.execUpdate(sql);

                Vector Vloc = new Vector();
                Location loc = new Location();
                Vloc = DbLocation.listAll();
                for (int i = 0; i < Vloc.size(); i++) {
                    loc = (Location) Vloc.get(i);
                    sql = "insert into log_status (log_status_id, log_id, company_id, location_id, date)" +
                            " values (" + OIDGenerator.generateOID() + "," + log_id + "," + comp.getOID() + "," +
                            loc.getOID() + ",'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')";
                    CONHandler.execUpdate(sql);
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
    public static void insertLogsConsolidation(String queryInsert, String tableName){
        try {
            if (groupConsolidationTable(tableName)) {
                queryInsert = queryInsert.replace("'", "\\'");
                long log_id = OIDGenerator.generateOID();
                String sql = "insert into log_grp (log_grp_id, date, table_name,query_string,sync_status)" +
                        " values (" + log_id + ",'"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd hh:mm:ss")+"','" +tableName +"','"+
                        queryInsert + "'," + 0 + ")";
                CONHandler.execUpdate(sql);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean notInExceptionTable(String tableName) {

        String exceptTable = DbSystemProperty.getValueByName("NON_SYNCHRONIZED_TABLES");
        StringTokenizer strTok = new StringTokenizer(exceptTable, ",");

        Vector temp = new Vector();

        while (strTok.hasMoreTokens()) {
            temp.add((String) strTok.nextToken().trim());
        }

        if (temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                String s = (String) temp.get(i);
                if (s.equalsIgnoreCase(tableName)) {
                    return false;
                }
            }
        }

        return true;

    }
    
    public static boolean groupConsolidationTable(String tableName) {

        String consTable = DbSystemProperty.getValueByName("GROUP_CONSOLIDATION_TABLES");
        StringTokenizer strTok = new StringTokenizer(consTable, ",");

        Vector temp = new Vector();

        while (strTok.hasMoreTokens()) {
            temp.add((String) strTok.nextToken().trim());
        }

        if (temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                String s = (String) temp.get(i);
                if (s.equalsIgnoreCase(tableName)) {
                    return true;
                }
            }
        }

        return false;

    }

    public static void updateStatus(long oid, int status) {
        try {
            String sql = "update logs set status=" + status + " where log_id=" + oid;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static Vector getNotSynchronizedData() {
        String sql = "SELECT log_id, date, query_string, periode_id, company_id FROM logs where sync_status=0";
        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector();
                temp.add("" + rs.getLong(1));
                temp.add("" + rs.getDate(2));
                temp.add("" + rs.getString(3));
                temp.add("" + rs.getLong(4));
                temp.add("" + rs.getLong(5));

                result.add(temp);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public String replaceString(String s) {

        String result = "";
        if (s != null && s.length() > 0) {

            for (int i = 0; i < s.length(); i++) {
                String x = "" + s.charAt(i);                
                if (x.equals("'") || x.equals("\"")) {
                    result = result + LOGS_STRING_DELIMETER;                
                } else {
                    result = result + x;
                }
            }
        }
        return result;

    }

    public static String reverseToQuery(String s) {

        String result = "";
        if (s != null && s.length() > 0) {

            for (int i = 0; i < s.length(); i++) {
                String x = "" + s.charAt(i);                
                if (x.equals(LOGS_STRING_DELIMETER)) {
                    result = result + "\'";                
                } else {
                    result = result + x;
                }
            }
        }

        return result;

    }

    public CONLogger(String s) {
        logfile = null;
        loglevel = 0;
        try {
            CONConfigReader xmlconfigreader = new CONConfigReader(CONHandler.CONFIG_FILE);
            logfile = xmlconfigreader.getConfigValue(KEY_DBLAYER_LOG);
            logfile = logfile.substring(0, logfile.lastIndexOf(47)) + "/" + s;
            SimpleDateFormat simpledateformat = new SimpleDateFormat(".MM.yyyyy");
            String s1 = simpledateformat.format(new Date());
            logfile += s1;
            String s2 = xmlconfigreader.getConfigValue(KEY_LEVEL_LOG);
            loglevel = (new Integer(s2)).intValue();
            stream = new FileOutputStream(logfile, true);
        } catch (Exception _ex) {
        }
        print = new PrintStream(stream);
    }

    public void close() {
        if (print != null) {
            print.close();
        }
    }

    public void critical_error(Exception exception) {
        if (loglevel < 1) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s = simpledateformat.format(new Date());
            print.println(s + " CRITICAL_ERROR STACK TRACE");
            exception.printStackTrace(print);
            print.println('\0');
            return;
        }
    }

    public void critical_error(String s) {
        if (loglevel < 1) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s1 = simpledateformat.format(new Date());
            print.println(s1 + " CRITICAL_ERROR " + s);
            return;
        }
    }

    public void error(String s) {
        if (loglevel < 2) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s1 = simpledateformat.format(new Date());
            print.println(s1 + " ERROR " + s);
            return;
        }
    }

    public static CONLogger getLogger() {
        if (logger == null) {
            logger = new CONLogger();
        }
        return logger;
    }

    public void info(String s) {
        if (loglevel < 4) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s1 = simpledateformat.format(new Date());
            print.println(s1 + " INFO " + s);
            return;
        }
    }

    public static void main(String[] args) {        
        String s = null;
        try {
            CONConfigReader xmlconfigreader = new CONConfigReader(CONHandler.CONFIG_FILE);
            s = xmlconfigreader.getConfigValue(KEY_DBLAYER_LOG);
        } catch (Exception _ex) {
        }    
    }

    public void trace(String s) {
        if (loglevel < 5) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s1 = simpledateformat.format(new Date());
            print.println(s1 + " TRACE " + s + "\n");
            return;
        }
    }

    public void warning(String s) {
        if (loglevel < 3) {
            return;
        } else {
            SimpleDateFormat simpledateformat = new SimpleDateFormat(DATE_LOG_FORMAT);
            String s1 = simpledateformat.format(new Date());
            print.println(s1 + " WARNING " + s);
            return;
        }
    }
}
