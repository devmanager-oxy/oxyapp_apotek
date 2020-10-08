/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.Vector;
import java.util.Date;
/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.JSPFormater;
/**
 *
 * @author Roy
 */
public class DbBudgetRequestDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BUDGET_REQUEST_DETAIL = "budget_request_detail";
    
    public static final int COL_BUDGET_REQUEST_DETAIL_ID = 0;   
    public static final int COL_BUDGET_REQUEST_ID = 1;   
    public static final int COL_DATE = 2;   
    public static final int COL_COA_ID = 3;   
    public static final int COL_MEMO = 4;   
    public static final int COL_REQUEST = 5; 
    public static final int COL_SEGMENT1_ID = 6;
    public static final int COL_SEGMENT2_ID = 7;
    public static final int COL_SEGMENT3_ID = 8;
    public static final int COL_SEGMENT4_ID = 9;
    public static final int COL_SEGMENT5_ID = 10;
    public static final int COL_SEGMENT6_ID = 11;
    public static final int COL_SEGMENT7_ID = 12;
    public static final int COL_SEGMENT8_ID = 13;
    public static final int COL_SEGMENT9_ID = 14;
    public static final int COL_SEGMENT10_ID = 15;
    public static final int COL_SEGMENT11_ID = 16;
    public static final int COL_SEGMENT12_ID = 17;
    public static final int COL_SEGMENT13_ID = 18;
    public static final int COL_SEGMENT14_ID = 19;
    public static final int COL_SEGMENT15_ID = 20;
    public static final int COL_UNIQ_KEY_ID = 21;
    public static final int COL_STATUS = 22;
    
    public static final String[] colNames = {
        "budget_request_detail_id",
        "budget_request_id",
        "date",
        "coa_id",
        "memo",
        "request",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id",
        "segment6_id",
        "segment7_id",
        "segment8_id",
        "segment9_id",
        "segment10_id",
        "segment11_id",
        "segment12_id",
        "segment13_id",
        "segment14_id",
        "segment15_id",
        "uniq_key_id",
        "status"
    };
    
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,        
        TYPE_STRING,        
        TYPE_FLOAT,
        
        //segment
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };

    public DbBudgetRequestDetail() {
    }

    public DbBudgetRequestDetail(int i) throws CONException {
        super(new DbBudgetRequestDetail());
    }

    public DbBudgetRequestDetail(String sOid) throws CONException {
        super(new DbBudgetRequestDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBudgetRequestDetail(long lOid) throws CONException {
        super(new DbBudgetRequestDetail(0));
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
        return DB_BUDGET_REQUEST_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBudgetRequestDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BudgetRequestDetail budgetRequestDetail = fetchExc(ent.getOID());
        ent = (Entity) budgetRequestDetail;
        return budgetRequestDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BudgetRequestDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BudgetRequestDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BudgetRequestDetail fetchExc(long oid) throws CONException {
        try {
            BudgetRequestDetail budgetRequestDetail = new BudgetRequestDetail();
            DbBudgetRequestDetail pstBudgetRequestDetail = new DbBudgetRequestDetail(oid);
            budgetRequestDetail.setOID(oid);
            budgetRequestDetail.setBudgetRequestId(pstBudgetRequestDetail.getlong(COL_BUDGET_REQUEST_ID));
            budgetRequestDetail.setDate(pstBudgetRequestDetail.getDate(COL_DATE));
            budgetRequestDetail.setCoaId(pstBudgetRequestDetail.getlong(COL_COA_ID));
            budgetRequestDetail.setMemo(pstBudgetRequestDetail.getString(COL_MEMO));
            budgetRequestDetail.setRequest(pstBudgetRequestDetail.getdouble(COL_REQUEST));
            
            budgetRequestDetail.setSegment1Id(pstBudgetRequestDetail.getlong(COL_SEGMENT1_ID));
            budgetRequestDetail.setSegment2Id(pstBudgetRequestDetail.getlong(COL_SEGMENT2_ID));
            budgetRequestDetail.setSegment3Id(pstBudgetRequestDetail.getlong(COL_SEGMENT3_ID));
            budgetRequestDetail.setSegment4Id(pstBudgetRequestDetail.getlong(COL_SEGMENT4_ID));
            budgetRequestDetail.setSegment5Id(pstBudgetRequestDetail.getlong(COL_SEGMENT5_ID));
            budgetRequestDetail.setSegment6Id(pstBudgetRequestDetail.getlong(COL_SEGMENT6_ID));
            budgetRequestDetail.setSegment7Id(pstBudgetRequestDetail.getlong(COL_SEGMENT7_ID));
            budgetRequestDetail.setSegment8Id(pstBudgetRequestDetail.getlong(COL_SEGMENT8_ID));
            budgetRequestDetail.setSegment9Id(pstBudgetRequestDetail.getlong(COL_SEGMENT9_ID));
            budgetRequestDetail.setSegment10Id(pstBudgetRequestDetail.getlong(COL_SEGMENT10_ID));
            budgetRequestDetail.setSegment11Id(pstBudgetRequestDetail.getlong(COL_SEGMENT11_ID));
            budgetRequestDetail.setSegment12Id(pstBudgetRequestDetail.getlong(COL_SEGMENT12_ID));
            budgetRequestDetail.setSegment13Id(pstBudgetRequestDetail.getlong(COL_SEGMENT13_ID));
            budgetRequestDetail.setSegment14Id(pstBudgetRequestDetail.getlong(COL_SEGMENT14_ID));
            budgetRequestDetail.setSegment15Id(pstBudgetRequestDetail.getlong(COL_SEGMENT15_ID));
            budgetRequestDetail.setUniqKeyId(pstBudgetRequestDetail.getlong(COL_UNIQ_KEY_ID));            
            budgetRequestDetail.setStatus(pstBudgetRequestDetail.getInt(COL_STATUS));
            
            return budgetRequestDetail;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequestDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BudgetRequestDetail budgetRequestDetail) throws CONException {
        try {
            DbBudgetRequestDetail pstBudgetRequestDetail = new DbBudgetRequestDetail(0);
        
            pstBudgetRequestDetail.setLong(COL_BUDGET_REQUEST_ID, budgetRequestDetail.getBudgetRequestId());
            pstBudgetRequestDetail.setDate(COL_DATE, budgetRequestDetail.getDate());
            pstBudgetRequestDetail.setLong(COL_COA_ID, budgetRequestDetail.getCoaId());
            pstBudgetRequestDetail.setString(COL_MEMO, budgetRequestDetail.getMemo());     
            pstBudgetRequestDetail.setDouble(COL_REQUEST, budgetRequestDetail.getRequest());  

            pstBudgetRequestDetail.setLong(COL_SEGMENT1_ID, budgetRequestDetail.getSegment1Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT2_ID, budgetRequestDetail.getSegment2Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT3_ID, budgetRequestDetail.getSegment3Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT4_ID, budgetRequestDetail.getSegment4Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT5_ID, budgetRequestDetail.getSegment5Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT6_ID, budgetRequestDetail.getSegment6Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT7_ID, budgetRequestDetail.getSegment7Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT8_ID, budgetRequestDetail.getSegment8Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT9_ID, budgetRequestDetail.getSegment9Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT10_ID, budgetRequestDetail.getSegment10Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT11_ID, budgetRequestDetail.getSegment11Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT12_ID, budgetRequestDetail.getSegment12Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT13_ID, budgetRequestDetail.getSegment13Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT14_ID, budgetRequestDetail.getSegment14Id());
            pstBudgetRequestDetail.setLong(COL_SEGMENT15_ID, budgetRequestDetail.getSegment15Id());
            pstBudgetRequestDetail.setLong(COL_UNIQ_KEY_ID, budgetRequestDetail.getUniqKeyId());
            pstBudgetRequestDetail.setInt(COL_STATUS, budgetRequestDetail.getStatus());

            pstBudgetRequestDetail.insert();
            budgetRequestDetail.setOID(pstBudgetRequestDetail.getlong(COL_BUDGET_REQUEST_DETAIL_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequestDetail(0), CONException.UNKNOWN);
        }
        return budgetRequestDetail.getOID();
    }

    public static long updateExc(BudgetRequestDetail budgetRequestDetail) throws CONException {
        try {
            if (budgetRequestDetail.getOID() != 0) {
                DbBudgetRequestDetail pstBudgetRequestDetail = new DbBudgetRequestDetail(budgetRequestDetail.getOID());
                pstBudgetRequestDetail.setLong(COL_BUDGET_REQUEST_ID, budgetRequestDetail.getBudgetRequestId());
                pstBudgetRequestDetail.setDate(COL_DATE, budgetRequestDetail.getDate());
                pstBudgetRequestDetail.setLong(COL_COA_ID, budgetRequestDetail.getCoaId());
                pstBudgetRequestDetail.setString(COL_MEMO, budgetRequestDetail.getMemo());     
                pstBudgetRequestDetail.setDouble(COL_REQUEST, budgetRequestDetail.getRequest());  
                pstBudgetRequestDetail.setLong(COL_SEGMENT1_ID, budgetRequestDetail.getSegment1Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT2_ID, budgetRequestDetail.getSegment2Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT3_ID, budgetRequestDetail.getSegment3Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT4_ID, budgetRequestDetail.getSegment4Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT5_ID, budgetRequestDetail.getSegment5Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT6_ID, budgetRequestDetail.getSegment6Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT7_ID, budgetRequestDetail.getSegment7Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT8_ID, budgetRequestDetail.getSegment8Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT9_ID, budgetRequestDetail.getSegment9Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT10_ID, budgetRequestDetail.getSegment10Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT11_ID, budgetRequestDetail.getSegment11Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT12_ID, budgetRequestDetail.getSegment12Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT13_ID, budgetRequestDetail.getSegment13Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT14_ID, budgetRequestDetail.getSegment14Id());
                pstBudgetRequestDetail.setLong(COL_SEGMENT15_ID, budgetRequestDetail.getSegment15Id());
                pstBudgetRequestDetail.setLong(COL_UNIQ_KEY_ID, budgetRequestDetail.getUniqKeyId());
                pstBudgetRequestDetail.setInt(COL_STATUS, budgetRequestDetail.getStatus());
                pstBudgetRequestDetail.update();
                return budgetRequestDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequestDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBudgetRequestDetail pstBudgetRequestDetail = new DbBudgetRequestDetail(oid);
            pstBudgetRequestDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequestDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BUDGET_REQUEST_DETAIL;
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
                BudgetRequestDetail budgetRequestDetail = new BudgetRequestDetail();
                resultToObject(rs, budgetRequestDetail);
                lists.add(budgetRequestDetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, BudgetRequestDetail budgetRequestDetail) {
        try {            
            Date tm = CONHandler.convertDate(rs.getDate(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_DATE]), rs.getTime(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_DATE]));
            budgetRequestDetail.setDate(tm);
            budgetRequestDetail.setOID(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_DETAIL_ID]));  
            budgetRequestDetail.setBudgetRequestId(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID]));                         
            budgetRequestDetail.setCoaId(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_COA_ID]));
            budgetRequestDetail.setMemo(rs.getString(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_MEMO]));
            budgetRequestDetail.setRequest(rs.getDouble(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_REQUEST]));
            budgetRequestDetail.setSegment1Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT1_ID]));
            budgetRequestDetail.setSegment2Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT2_ID]));
            budgetRequestDetail.setSegment3Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT3_ID]));
            budgetRequestDetail.setSegment4Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT4_ID]));
            budgetRequestDetail.setSegment5Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT5_ID]));
            budgetRequestDetail.setSegment6Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT6_ID]));
            budgetRequestDetail.setSegment7Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT7_ID]));
            budgetRequestDetail.setSegment8Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT8_ID]));
            budgetRequestDetail.setSegment9Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT9_ID]));
            budgetRequestDetail.setSegment10Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT10_ID]));
            budgetRequestDetail.setSegment11Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT11_ID]));
            budgetRequestDetail.setSegment12Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT12_ID]));
            budgetRequestDetail.setSegment13Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT13_ID]));
            budgetRequestDetail.setSegment14Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT14_ID]));
            budgetRequestDetail.setSegment15Id(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_SEGMENT15_ID]));
            budgetRequestDetail.setUniqKeyId(rs.getLong(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_UNIQ_KEY_ID]));
            budgetRequestDetail.setStatus(rs.getInt(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_STATUS]));
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static boolean checkOID(long budgetRequestDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BUDGET_REQUEST_DETAIL + " WHERE " +
                    DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_DETAIL_ID] + " = " + budgetRequestDetailId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_DETAIL_ID] + ") FROM " + DB_BUDGET_REQUEST_DETAIL;
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
                    BudgetRequestDetail budgetRequestDetail = (BudgetRequestDetail) list.get(ls);
                    if (oid == budgetRequestDetail.getOID()) {
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
    
    public static double getSum(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_REQUEST] + ") FROM " + DB_BUDGET_REQUEST_DETAIL;
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
    
    public static double getBudgetUsed(long budgetRequestDetailId,Date transDate,long segment1Id,long coaId) {
        CONResultSet dbrs = null;
        int year = transDate.getYear()+1900;
        try {
            String sql = "select sum(brd."+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_REQUEST]+") as total from "+DbBudgetRequest.DB_BUDGET_REQUEST+" br inner join "+DbBudgetRequestDetail.DB_BUDGET_REQUEST_DETAIL+" brd on br."+DbBudgetRequest.colNames[DbBudgetRequest.COL_BUDGET_REQUEST_ID]+" = brd."+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID]+" where br."+DbBudgetRequest.colNames[DbBudgetRequest.COL_STATUS]+" != 3 ";

            sql = sql+ " and br."+DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID]+" = "+segment1Id+" and year(br."+DbBudgetRequest.colNames[DbBudgetRequest.COL_TRANS_DATE]+") = "+year+" and brd."+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_COA_ID]+" = "+coaId;
            
            if(budgetRequestDetailId !=0){
                sql = sql + " and brd."+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_DETAIL_ID]+" != "+budgetRequestDetailId;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double total = 0;
            while (rs.next()) {
                total = rs.getDouble("total");
            }

            rs.close();
            return total;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static synchronized boolean getOpenBudgetRequest(Date transDate,long coaId,long segment1Id,double request,long budgetRequestDetailId){
        try{
            double budget = DbCoaBudget.getBudgetYTD(transDate.getYear() + 1900, coaId, segment1Id);
            double budgetUsed = getBudgetUsed(budgetRequestDetailId,transDate,segment1Id,coaId);
            double available = budget - budgetUsed;
            
            if(request <= available ){
                return true;
            }
            
        }catch(Exception e){}
        
        return true;
    }

    public static void updateCheckedDetail(long budgetDetailOID){
        CONResultSet dbrs = null;
        try {
            String sql="update " + DbBudgetRequestDetail.DB_BUDGET_REQUEST_DETAIL + " set "
                    + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_STATUS] + "='1'"
                    + " where " + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_DETAIL_ID]
                    + "=" + budgetDetailOID;

            CONHandler.execUpdate(sql);
            System.out.println("Exception => updateCheckedDetail =>" + sql);
        }catch(Exception ex){
            System.out.println("Exception => updateCheckedDetail =>" + ex.getMessage().toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static double getTerpakai(long coaId, long periodeId, long segment1Id, long budgetReqId, Date detailDate) {
        CONResultSet dbrs = null;
        CONResultSet dbrs1 = null;

        try {
            Periode p = DbPeriode.fetchExc(periodeId);
            String period = JSPFormater.formatDate(p.getStartDate(), "yyyy").toString();

            String sqlGL ="SELECT coa.saldo_normal, SUM(gd.debet-gd.credit) AS tot FROM gl INNER JOIN gl_detail gd ON gl.gl_id=gd.gl_id INNER JOIN coa ON gd.coa_id=coa.coa_id"
                    + " WHERE gl.posted_status='1' AND gd.coa_id='"+ coaId +"' AND gd.segment1_id='"+ segment1Id +"' AND YEAR(gl.trans_date)='"+ period +"' group by coa.coa_id";
            
            dbrs = CONHandler.execQueryResult(sqlGL);
            ResultSet rs = dbrs.getResultSet();

            double total = 0;
            double totalGl = 0;
            while (rs.next()) {
                totalGl = rs.getDouble("tot");
                if (rs.getString("saldo_normal").equals("Credit")){
                    totalGl = rs.getDouble("tot") * -1;
                }
            }
            rs.close();

            String sqlBudget ="SELECT SUM(brd.request) AS tot FROM budget_request br INNER JOIN budget_request_detail brd ON br.budget_request_id=brd.budget_request_id "
                    + " WHERE br.status not in ('3','4') AND brd.coa_id='"+ coaId +"' AND br.segment1_id='"+ segment1Id +"' AND YEAR(br.trans_date)='"+ period +"' and brd.date < '"+ JSPFormater.formatDate(detailDate, "yyyy-MM-dd HH:mm:ss") +"'";
            System.out.println("sqlBudget : " + sqlBudget);
            
            dbrs1 = CONHandler.execQueryResult(sqlBudget);
            ResultSet rs1 = dbrs1.getResultSet();

            double totalBudget = 0;
            while (rs1.next()) {
                totalBudget = rs1.getDouble("tot");
            }

            total =  totalGl + totalBudget;



            return total;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }


    }
    
}
