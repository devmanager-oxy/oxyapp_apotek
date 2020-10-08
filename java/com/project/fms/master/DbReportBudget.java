/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;
import java.io.*;
import java.sql.ResultSet;
import java.util.*;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.util.*;
/**
 *
 * @author Roy
 */
public class DbReportBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {
    
    public static final String DB_REPORT_BUDGET = "report_budget";
    
    public static final int COL_REPORT_BUDGET_ID = 0;    
    public static final int COL_EMPLOYEE_ID = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_FULL_NAME = 3;
    public static final int COL_DATE = 4;
    public static final int COL_PKP = 5;
    public static final int COL_CREATE_DATE = 6;
    public static final int COL_VENDOR_ID = 7;
    public static final int COL_NON_PKP = 8;
    public static final int COL_IGNORED = 9;
    public static final int COL_DATE_END = 10;
    
    public static final int COL_NON = 11;
    public static final int COL_KONSINYASI = 12;
    public static final int COL_KOMISI = 13;
    
    public static final String[] colNames = {
        "report_budget_id",
        "employee_id",
        "user_id",
        "full_name",
        "date",
        "pkp",
        "create_date",
        "vendor_id",
        "non_pkp",
        "ignored",
        "date_end",
        "non",
        "konsinyasi",
        "komisi"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_INT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public DbReportBudget() {
    }

    public DbReportBudget(int i) throws CONException {
        super(new DbReportBudget());
    }

    public DbReportBudget(String sOid) throws CONException {
        super(new DbReportBudget(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbReportBudget(long lOid) throws CONException {
        super(new DbReportBudget(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_REPORT_BUDGET;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbReportBudget().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ReportBudget reportBudget = fetchExc(ent.getOID());
        ent = (Entity) reportBudget;
        return reportBudget.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ReportBudget) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ReportBudget) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ReportBudget fetchExc(long oid) throws CONException {
        try {
            ReportBudget reportBudget = new ReportBudget();
            DbReportBudget dbReportBudget = new DbReportBudget(oid);
            reportBudget.setOID(oid);

            reportBudget.setEmployeeId(dbReportBudget.getlong(COL_EMPLOYEE_ID));
            reportBudget.setUserId(dbReportBudget.getlong(COL_USER_ID));
            reportBudget.setFullName(dbReportBudget.getString(COL_FULL_NAME)); 
            reportBudget.setDate(dbReportBudget.getDate(COL_DATE));
            reportBudget.setDateEnd(dbReportBudget.getDate(COL_DATE_END));
            reportBudget.setPkp(dbReportBudget.getInt(COL_PKP));
            reportBudget.setCreateDate(dbReportBudget.getDate(COL_CREATE_DATE));
            reportBudget.setVendorId(dbReportBudget.getlong(COL_VENDOR_ID));
            reportBudget.setNonPkp(dbReportBudget.getInt(COL_NON_PKP));
            reportBudget.setIgnore(dbReportBudget.getInt(COL_IGNORED));
            
            reportBudget.setNon(dbReportBudget.getInt(COL_NON));
            reportBudget.setKonsinyasi(dbReportBudget.getInt(COL_KONSINYASI));
            reportBudget.setKomisi(dbReportBudget.getInt(COL_KOMISI));
            
            return reportBudget;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudget(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ReportBudget reportBudget) throws CONException {
        try {
            DbReportBudget dbReportBudget = new DbReportBudget(0);

            dbReportBudget.setLong(COL_EMPLOYEE_ID, reportBudget.getEmployeeId());
            dbReportBudget.setLong(COL_USER_ID, reportBudget.getUserId());            
            dbReportBudget.setString(COL_FULL_NAME, reportBudget.getFullName());            
            dbReportBudget.setDate(COL_DATE, reportBudget.getDate());
            dbReportBudget.setDate(COL_DATE_END, reportBudget.getDateEnd());
            dbReportBudget.setInt(COL_PKP, reportBudget.getPkp());
            dbReportBudget.setDate(COL_CREATE_DATE, reportBudget.getCreateDate());
            dbReportBudget.setLong(COL_VENDOR_ID, reportBudget.getVendorId());
            dbReportBudget.setInt(COL_NON_PKP, reportBudget.getNonPkp());
            dbReportBudget.setInt(COL_IGNORED, reportBudget.getIgnore());
            
            dbReportBudget.setInt(COL_NON, reportBudget.getNon());
            dbReportBudget.setInt(COL_KONSINYASI, reportBudget.getKonsinyasi());
            dbReportBudget.setInt(COL_KOMISI, reportBudget.getKomisi());
            
            dbReportBudget.insert();
            reportBudget.setOID(dbReportBudget.getlong(COL_REPORT_BUDGET_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudget(0), CONException.UNKNOWN);
        }
        return reportBudget.getOID();
    }

    public static long updateExc(ReportBudget reportBudget) throws CONException {
        try {
            if (reportBudget.getOID() != 0) {
                DbReportBudget dbReportBudget = new DbReportBudget(reportBudget.getOID());

                dbReportBudget.setLong(COL_EMPLOYEE_ID, reportBudget.getEmployeeId());
                dbReportBudget.setLong(COL_USER_ID, reportBudget.getUserId());            
                dbReportBudget.setString(COL_FULL_NAME, reportBudget.getFullName());            
                dbReportBudget.setDate(COL_DATE, reportBudget.getDate());
                dbReportBudget.setDate(COL_DATE_END, reportBudget.getDateEnd());
                dbReportBudget.setInt(COL_PKP, reportBudget.getPkp());
                dbReportBudget.setDate(COL_CREATE_DATE, reportBudget.getCreateDate());
                dbReportBudget.setLong(COL_VENDOR_ID, reportBudget.getVendorId());
                dbReportBudget.setInt(COL_NON_PKP, reportBudget.getNonPkp());
                dbReportBudget.setInt(COL_IGNORED, reportBudget.getIgnore());
                dbReportBudget.setInt(COL_NON, reportBudget.getNon());
                dbReportBudget.setInt(COL_KONSINYASI, reportBudget.getKonsinyasi());
                dbReportBudget.setInt(COL_KOMISI, reportBudget.getKomisi());
                dbReportBudget.update();
                return reportBudget.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudget(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReportBudget dbReportBudget = new DbReportBudget(oid);
            dbReportBudget.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudget(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_REPORT_BUDGET;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReportBudget reportBudget = new ReportBudget();
                resultToObject(rs, reportBudget);
                lists.add(reportBudget);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, ReportBudget reportBudget) {
        try {
            reportBudget.setOID(rs.getLong(DbReportBudget.colNames[DbReportBudget.COL_REPORT_BUDGET_ID]));            
            reportBudget.setEmployeeId(rs.getLong(DbReportBudget.colNames[DbReportBudget.COL_EMPLOYEE_ID]));
            reportBudget.setUserId(rs.getLong(DbReportBudget.colNames[DbReportBudget.COL_USER_ID]));            
            reportBudget.setFullName(rs.getString(DbReportBudget.colNames[DbReportBudget.COL_FULL_NAME]));
            reportBudget.setDate(rs.getDate(DbReportBudget.colNames[DbReportBudget.COL_DATE]));
            reportBudget.setDateEnd(rs.getDate(DbReportBudget.colNames[DbReportBudget.COL_DATE_END]));
            reportBudget.setPkp(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_PKP]));
            reportBudget.setCreateDate(rs.getDate(DbReportBudget.colNames[DbReportBudget.COL_CREATE_DATE]));            
            reportBudget.setVendorId(rs.getLong(DbReportBudget.colNames[DbReportBudget.COL_VENDOR_ID]));              
            reportBudget.setNonPkp(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_NON_PKP]));
            reportBudget.setIgnore(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_IGNORED]));
            reportBudget.setNon(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_NON]));
            reportBudget.setKonsinyasi(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_KONSINYASI]));
            reportBudget.setKomisi(rs.getInt(DbReportBudget.colNames[DbReportBudget.COL_KOMISI]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long reportBudgetId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_REPORT_BUDGET + " WHERE " +
                    DbReportBudget.colNames[DbReportBudget.COL_REPORT_BUDGET_ID] + " = " + reportBudgetId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbReportBudget.colNames[DbReportBudget.COL_REPORT_BUDGET_ID] + ") FROM " + DB_REPORT_BUDGET;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    ReportBudget reportBudget = (ReportBudget) list.get(ls);
                    if (oid == reportBudget.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }
    
    public static Vector getHistoryReport(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp){
        Vector result = new Vector();
        CONResultSet dbrs = null;
        try{ 
            String sql = "select rb.report_budget_id as oid,rb.full_name as full_name,create_date as date,count(*) as total from report_budget rb inner join report_budget_detail rbd on rb.report_budget_id = rbd.report_budget_id ";            
                    
            String where = " rb.pkp = "+pkp+" and  rb.non_pkp="+nonPkp+" and rb.vendor_id = " + suplierId;
          
            if (ignore == 0) {
                if(where != null && where.length() > 0){
                    where = where + " and "; 
                }         
                where = where + " to_days(rb.date) = to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(rb.date_end) =  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }
                
            if(where != null && where.length() > 0){ where = " where "+where ; }
            
            sql = sql + where + " group by rb.report_budget_id order by create_date";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                ReportBudget rb = new ReportBudget();
                rb.setOID(rs.getLong("oid"));
                rb.setFullName(rs.getString("full_name"));
                rb.setCreateDate(rs.getDate("date"))        ;
                rb.setIgnore(rs.getInt("total"));
                result.add(rb);
            }
            rs.close();
            
        }catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return result;
    }
    
     public static Vector getHistoryReport(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int non,int konsinyasi,int komisi){
        Vector result = new Vector();
        CONResultSet dbrs = null;
        try{ 
            String sql = "select rb.report_budget_id as oid,rb.full_name as full_name,create_date as date,count(*) as total from report_budget rb inner join report_budget_detail rbd on rb.report_budget_id = rbd.report_budget_id ";            
                    
            String where = " rb.pkp = "+pkp+" and  rb.non_pkp="+nonPkp+" and rb.vendor_id = " + suplierId+" and rb.non = "+non+" and rb.konsinyasi = "+konsinyasi+" and komisi ="+komisi+" ";
          
            if (ignore == 0) {
                if(where != null && where.length() > 0){
                    where = where + " and "; 
                }         
                where = where + " to_days(rb.date) = to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(rb.date_end) =  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }
                
            if(where != null && where.length() > 0){ where = " where "+where ; }
            
            sql = sql + where + " group by rb.report_budget_id order by create_date";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                ReportBudget rb = new ReportBudget();
                rb.setOID(rs.getLong("oid"));
                rb.setFullName(rs.getString("full_name"));
                rb.setCreateDate(rs.getDate("date"))        ;
                rb.setIgnore(rs.getInt("total"));
                result.add(rb);
            }
            rs.close();
            
        }catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return result;
    }
    
    public static Hashtable listNumber(long reportBudgetId){
        Hashtable result = new Hashtable();
        CONResultSet dbrs = null;
        
        try{
            String sql = "select rd.vendor_id as vendorId,v.name,rd.sequence as seq from report_budget_detail rd inner join vendor v on rd.vendor_id = v.vendor_id where rd.report_budget_id = "+reportBudgetId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                long vendorId = rs.getLong("vendorId");
                int seq = rs.getInt("seq");
                result.put(""+vendorId, ""+seq);
            }
            rs.close();
        }catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return result;
    }
    
}

