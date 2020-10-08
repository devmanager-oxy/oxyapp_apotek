
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.transaction.*;
import com.project.fms.activity.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.master.BudgetRequest;
import com.project.fms.master.BudgetRequestDetail;
import com.project.fms.master.DbBudgetRequest;

public class DbPettycashPaymentDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PETTYCASH_PAYMENT_DETAIL = "pettycash_payment_detail";
    public static final int COL_PETTYCASH_PAYMENT_ID = 0;
    public static final int COL_PETTYCASH_PAYMENT_DETAIL_ID = 1;
    public static final int COL_COA_ID = 2;
    public static final int COL_AMOUNT = 3;
    public static final int COL_MEMO = 4;
    public static final int COL_DEPARTMENT_ID = 5;
    public static final int COL_TYPE = 6;
    public static final int COL_SEGMENT1_ID = 7;
    public static final int COL_SEGMENT2_ID = 8;
    public static final int COL_SEGMENT3_ID = 9;
    public static final int COL_SEGMENT4_ID = 10;
    public static final int COL_SEGMENT5_ID = 11;
    public static final int COL_SEGMENT6_ID = 12;
    public static final int COL_SEGMENT7_ID = 13;
    public static final int COL_SEGMENT8_ID = 14;
    public static final int COL_SEGMENT9_ID = 15;
    public static final int COL_SEGMENT10_ID = 16;
    public static final int COL_SEGMENT11_ID = 17;
    public static final int COL_SEGMENT12_ID = 18;
    public static final int COL_SEGMENT13_ID = 19;
    public static final int COL_SEGMENT14_ID = 20;
    public static final int COL_SEGMENT15_ID = 21;
    public static final int COL_MODULE_ID = 22;
    public static final int COL_CREDIT_AMOUNT = 23;
    
    public static final String[] colNames = {
        "pettycash_payment_id",
        "pettycash_payment_detail_id",
        "coa_id",
        "amount",
        "memo",
        "department_id",
        "type",
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
        "module_id",
        "credit_amount"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
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
        TYPE_FLOAT
    };

    public DbPettycashPaymentDetail() {
    }

    public DbPettycashPaymentDetail(int i) throws CONException {
        super(new DbPettycashPaymentDetail());
    }

    public DbPettycashPaymentDetail(String sOid) throws CONException {
        super(new DbPettycashPaymentDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPettycashPaymentDetail(long lOid) throws CONException {
        super(new DbPettycashPaymentDetail(0));
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
        return DB_PETTYCASH_PAYMENT_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPettycashPaymentDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PettycashPaymentDetail pettycashpaymentdetail = fetchExc(ent.getOID());
        ent = (Entity) pettycashpaymentdetail;
        return pettycashpaymentdetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PettycashPaymentDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PettycashPaymentDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PettycashPaymentDetail fetchExc(long oid) throws CONException {
        try {
            PettycashPaymentDetail pettycashpaymentdetail = new PettycashPaymentDetail();
            DbPettycashPaymentDetail pstPettycashPaymentDetail = new DbPettycashPaymentDetail(oid);
            pettycashpaymentdetail.setOID(oid);

            pettycashpaymentdetail.setPettycashPaymentId(pstPettycashPaymentDetail.getlong(COL_PETTYCASH_PAYMENT_ID));
            pettycashpaymentdetail.setCoaId(pstPettycashPaymentDetail.getlong(COL_COA_ID));
            pettycashpaymentdetail.setAmount(pstPettycashPaymentDetail.getdouble(COL_AMOUNT));
            pettycashpaymentdetail.setMemo(pstPettycashPaymentDetail.getString(COL_MEMO));

            pettycashpaymentdetail.setDepartmentId(pstPettycashPaymentDetail.getlong(COL_DEPARTMENT_ID));
            pettycashpaymentdetail.setType(pstPettycashPaymentDetail.getInt(COL_TYPE));

            pettycashpaymentdetail.setSegment1Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT1_ID));
            pettycashpaymentdetail.setSegment2Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT2_ID));
            pettycashpaymentdetail.setSegment3Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT3_ID));
            pettycashpaymentdetail.setSegment4Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT4_ID));
            pettycashpaymentdetail.setSegment5Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT5_ID));
            pettycashpaymentdetail.setSegment6Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT6_ID));
            pettycashpaymentdetail.setSegment7Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT7_ID));
            pettycashpaymentdetail.setSegment8Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT8_ID));
            pettycashpaymentdetail.setSegment9Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT9_ID));
            pettycashpaymentdetail.setSegment10Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT10_ID));
            pettycashpaymentdetail.setSegment11Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT11_ID));
            pettycashpaymentdetail.setSegment12Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT12_ID));
            pettycashpaymentdetail.setSegment13Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT13_ID));
            pettycashpaymentdetail.setSegment14Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT14_ID));
            pettycashpaymentdetail.setSegment15Id(pstPettycashPaymentDetail.getlong(COL_SEGMENT15_ID));

            pettycashpaymentdetail.setModuleId(pstPettycashPaymentDetail.getlong(COL_MODULE_ID));
            pettycashpaymentdetail.setCreditAmount(pstPettycashPaymentDetail.getdouble(COL_CREDIT_AMOUNT));

            return pettycashpaymentdetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPaymentDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PettycashPaymentDetail pettycashpaymentdetail) throws CONException {
        try {
            DbPettycashPaymentDetail pstPettycashPaymentDetail = new DbPettycashPaymentDetail(0);

            pstPettycashPaymentDetail.setLong(COL_PETTYCASH_PAYMENT_ID, pettycashpaymentdetail.getPettycashPaymentId());
            pstPettycashPaymentDetail.setLong(COL_COA_ID, pettycashpaymentdetail.getCoaId());
            pstPettycashPaymentDetail.setDouble(COL_AMOUNT, pettycashpaymentdetail.getAmount());
            pstPettycashPaymentDetail.setString(COL_MEMO, pettycashpaymentdetail.getMemo());

            pstPettycashPaymentDetail.setLong(COL_DEPARTMENT_ID, pettycashpaymentdetail.getDepartmentId());
            pstPettycashPaymentDetail.setInt(COL_TYPE, pettycashpaymentdetail.getType());

            pstPettycashPaymentDetail.setLong(COL_SEGMENT1_ID, pettycashpaymentdetail.getSegment1Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT2_ID, pettycashpaymentdetail.getSegment2Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT3_ID, pettycashpaymentdetail.getSegment3Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT4_ID, pettycashpaymentdetail.getSegment4Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT5_ID, pettycashpaymentdetail.getSegment5Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT6_ID, pettycashpaymentdetail.getSegment6Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT7_ID, pettycashpaymentdetail.getSegment7Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT8_ID, pettycashpaymentdetail.getSegment8Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT9_ID, pettycashpaymentdetail.getSegment9Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT10_ID, pettycashpaymentdetail.getSegment10Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT11_ID, pettycashpaymentdetail.getSegment11Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT12_ID, pettycashpaymentdetail.getSegment12Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT13_ID, pettycashpaymentdetail.getSegment13Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT14_ID, pettycashpaymentdetail.getSegment14Id());
            pstPettycashPaymentDetail.setLong(COL_SEGMENT15_ID, pettycashpaymentdetail.getSegment15Id());

            pstPettycashPaymentDetail.setLong(COL_MODULE_ID, pettycashpaymentdetail.getModuleId());
            pstPettycashPaymentDetail.setDouble(COL_CREDIT_AMOUNT, pettycashpaymentdetail.getCreditAmount());

            pstPettycashPaymentDetail.insert();
            pettycashpaymentdetail.setOID(pstPettycashPaymentDetail.getlong(COL_PETTYCASH_PAYMENT_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPaymentDetail(0), CONException.UNKNOWN);
        }
        return pettycashpaymentdetail.getOID();
    }

    public static long updateExc(PettycashPaymentDetail pettycashpaymentdetail) throws CONException {
        try {
            if (pettycashpaymentdetail.getOID() != 0) {
                DbPettycashPaymentDetail pstPettycashPaymentDetail = new DbPettycashPaymentDetail(pettycashpaymentdetail.getOID());

                pstPettycashPaymentDetail.setLong(COL_PETTYCASH_PAYMENT_ID, pettycashpaymentdetail.getPettycashPaymentId());
                pstPettycashPaymentDetail.setLong(COL_COA_ID, pettycashpaymentdetail.getCoaId());
                pstPettycashPaymentDetail.setDouble(COL_AMOUNT, pettycashpaymentdetail.getAmount());
                pstPettycashPaymentDetail.setString(COL_MEMO, pettycashpaymentdetail.getMemo());

                pstPettycashPaymentDetail.setLong(COL_DEPARTMENT_ID, pettycashpaymentdetail.getDepartmentId());
                pstPettycashPaymentDetail.setInt(COL_TYPE, pettycashpaymentdetail.getType());

                pstPettycashPaymentDetail.setLong(COL_SEGMENT1_ID, pettycashpaymentdetail.getSegment1Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT2_ID, pettycashpaymentdetail.getSegment2Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT3_ID, pettycashpaymentdetail.getSegment3Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT4_ID, pettycashpaymentdetail.getSegment4Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT5_ID, pettycashpaymentdetail.getSegment5Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT6_ID, pettycashpaymentdetail.getSegment6Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT7_ID, pettycashpaymentdetail.getSegment7Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT8_ID, pettycashpaymentdetail.getSegment8Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT9_ID, pettycashpaymentdetail.getSegment9Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT10_ID, pettycashpaymentdetail.getSegment10Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT11_ID, pettycashpaymentdetail.getSegment11Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT12_ID, pettycashpaymentdetail.getSegment12Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT13_ID, pettycashpaymentdetail.getSegment13Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT14_ID, pettycashpaymentdetail.getSegment14Id());
                pstPettycashPaymentDetail.setLong(COL_SEGMENT15_ID, pettycashpaymentdetail.getSegment15Id());

                pstPettycashPaymentDetail.setLong(COL_MODULE_ID, pettycashpaymentdetail.getModuleId());
                pstPettycashPaymentDetail.setDouble(COL_CREDIT_AMOUNT, pettycashpaymentdetail.getCreditAmount());

                pstPettycashPaymentDetail.update();
                return pettycashpaymentdetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPaymentDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPettycashPaymentDetail pstPettycashPaymentDetail = new DbPettycashPaymentDetail(oid);
            pstPettycashPaymentDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPaymentDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PETTYCASH_PAYMENT_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PettycashPaymentDetail pettycashpaymentdetail = new PettycashPaymentDetail();
                resultToObject(rs, pettycashpaymentdetail);
                lists.add(pettycashpaymentdetail);
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

    private static void resultToObject(ResultSet rs, PettycashPaymentDetail pettycashpaymentdetail) {
        try {
            pettycashpaymentdetail.setOID(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_DETAIL_ID]));
            pettycashpaymentdetail.setPettycashPaymentId(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID]));
            pettycashpaymentdetail.setCoaId(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_COA_ID]));
            pettycashpaymentdetail.setAmount(rs.getDouble(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_AMOUNT]));
            pettycashpaymentdetail.setMemo(rs.getString(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_MEMO]));

            pettycashpaymentdetail.setDepartmentId(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_DEPARTMENT_ID]));
            pettycashpaymentdetail.setType(rs.getInt(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_TYPE]));

            pettycashpaymentdetail.setSegment1Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT1_ID]));
            pettycashpaymentdetail.setSegment2Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT2_ID]));
            pettycashpaymentdetail.setSegment3Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT3_ID]));
            pettycashpaymentdetail.setSegment4Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT4_ID]));
            pettycashpaymentdetail.setSegment5Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT5_ID]));
            pettycashpaymentdetail.setSegment6Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT6_ID]));
            pettycashpaymentdetail.setSegment7Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT7_ID]));
            pettycashpaymentdetail.setSegment8Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT8_ID]));
            pettycashpaymentdetail.setSegment9Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT9_ID]));
            pettycashpaymentdetail.setSegment10Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT10_ID]));
            pettycashpaymentdetail.setSegment11Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT11_ID]));
            pettycashpaymentdetail.setSegment12Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT12_ID]));
            pettycashpaymentdetail.setSegment13Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT13_ID]));
            pettycashpaymentdetail.setSegment14Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT14_ID]));
            pettycashpaymentdetail.setSegment15Id(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT15_ID]));

            pettycashpaymentdetail.setModuleId(rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_MODULE_ID]));
			pettycashpaymentdetail.setCreditAmount(rs.getDouble(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_CREDIT_AMOUNT]));


        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long pettycashPaymentDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PETTYCASH_PAYMENT_DETAIL + " WHERE " +
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + " = " + pettycashPaymentDetailId;

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
            String sql = "SELECT COUNT(" + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_DETAIL_ID] + ") FROM " + DB_PETTYCASH_PAYMENT_DETAIL;
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
                    PettycashPaymentDetail pettycashpaymentdetail = (PettycashPaymentDetail) list.get(ls);
                    if (oid == pettycashpaymentdetail.getOID()) {
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

    public static void saveAllDetail(PettycashPayment pettycashPayment, Vector listPettycashPaymentDetail) {
        if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
            for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {
                PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
                crd.setPettycashPaymentId(pettycashPayment.getOID());

                if (crd.getModuleId() != 0) {
                    try {
                        Module module = DbModule.fetchExc(crd.getModuleId());
                        crd.setSegment1Id(module.getSegment1Id());
                        crd.setSegment2Id(module.getSegment2Id());
                        crd.setSegment3Id(module.getSegment3Id());
                        crd.setSegment4Id(module.getSegment4Id());
                        crd.setSegment5Id(module.getSegment5Id());
                        crd.setSegment6Id(module.getSegment6Id());
                        crd.setSegment7Id(module.getSegment7Id());
                        crd.setSegment8Id(module.getSegment8Id());
                        crd.setSegment9Id(module.getSegment9Id());
                        crd.setSegment10Id(module.getSegment10Id());
                        crd.setSegment11Id(module.getSegment11Id());
                        crd.setSegment12Id(module.getSegment12Id());
                        crd.setSegment13Id(module.getSegment13Id());
                        crd.setSegment14Id(module.getSegment14Id());
                        crd.setSegment15Id(module.getSegment15Id());
                    } catch (Exception e) {

                    }
                }

                try {
                    if (crd.getOID() == 0) {
                        DbPettycashPaymentDetail.insertExc(crd);
                    } else {
                        DbPettycashPaymentDetail.updateExc(crd);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKK, pettycashPayment.getOID(), pettycashPayment.getAmount(), pettycashPayment.getOperatorId());            
            
        }

        DbPettycashPayment.getUpdateTotalAmount(pettycashPayment.getOID());

    }
    
    public static void saveAllDetailKasbon(PettycashPayment pettycashPayment, Vector listPettycashPaymentDetail) {
        if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
            for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {
                PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
                crd.setPettycashPaymentId(pettycashPayment.getOID());

                if (crd.getModuleId() != 0) {
                    try {
                        Module module = DbModule.fetchExc(crd.getModuleId());
                        crd.setSegment1Id(module.getSegment1Id());
                        crd.setSegment2Id(module.getSegment2Id());
                        crd.setSegment3Id(module.getSegment3Id());
                        crd.setSegment4Id(module.getSegment4Id());
                        crd.setSegment5Id(module.getSegment5Id());
                        crd.setSegment6Id(module.getSegment6Id());
                        crd.setSegment7Id(module.getSegment7Id());
                        crd.setSegment8Id(module.getSegment8Id());
                        crd.setSegment9Id(module.getSegment9Id());
                        crd.setSegment10Id(module.getSegment10Id());
                        crd.setSegment11Id(module.getSegment11Id());
                        crd.setSegment12Id(module.getSegment12Id());
                        crd.setSegment13Id(module.getSegment13Id());
                        crd.setSegment14Id(module.getSegment14Id());
                        crd.setSegment15Id(module.getSegment15Id());
                    } catch (Exception e) {

                    }
                }

                try {
                    if (crd.getOID() == 0) {
                        DbPettycashPaymentDetail.insertExc(crd);
                    } else {
                        DbPettycashPaymentDetail.updateExc(crd);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_KASBON, pettycashPayment.getOID(), pettycashPayment.getAmount(), pettycashPayment.getOperatorId());                        
        }
        DbPettycashPayment.getUpdateTotalAmount(pettycashPayment.getOID());
    }

    public static void saveAllDetailPelunasanTunai(PettycashPayment pettycashPayment, Vector listPettycashPaymentDetail) {
        if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
            for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {
                PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
                crd.setPettycashPaymentId(pettycashPayment.getOID());

                if (crd.getModuleId() != 0) {
                    try {
                        Module module = DbModule.fetchExc(crd.getModuleId());
                        crd.setSegment1Id(module.getSegment1Id());
                        crd.setSegment2Id(module.getSegment2Id());
                        crd.setSegment3Id(module.getSegment3Id());
                        crd.setSegment4Id(module.getSegment4Id());
                        crd.setSegment5Id(module.getSegment5Id());
                        crd.setSegment6Id(module.getSegment6Id());
                        crd.setSegment7Id(module.getSegment7Id());
                        crd.setSegment8Id(module.getSegment8Id());
                        crd.setSegment9Id(module.getSegment9Id());
                        crd.setSegment10Id(module.getSegment10Id());
                        crd.setSegment11Id(module.getSegment11Id());
                        crd.setSegment12Id(module.getSegment12Id());
                        crd.setSegment13Id(module.getSegment13Id());
                        crd.setSegment14Id(module.getSegment14Id());
                        crd.setSegment15Id(module.getSegment15Id());
                    } catch (Exception e) {

                    }
                }

                try {
                    DbPettycashPaymentDetail.insertExc(crd);
                } catch (Exception e) {

                }
            }
        }

        DbPettycashPayment.getUpdateTotalAmount(pettycashPayment.getOID());

    }

    public static Vector getActivityPredefined(long paymentOID) {
        Vector result = new Vector();
        ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
        CONResultSet crs = null;
        try {
            String sql = "SELECT c.*, pd.* FROM coa_activity_budget c inner join pettycash_payment_detail pd on pd.coa_id=c.coa_id " +
                    " where pd.pettycash_payment_id=" + paymentOID + " and c.activity_period_id = " + ap.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CoaActivityBudget cab = new CoaActivityBudget();
                PettycashPaymentDetail ppd = new PettycashPaymentDetail();
                DbCoaActivityBudget.resultToObject(rs, cab);
                DbPettycashPaymentDetail.resultToObject(rs, ppd);
                Vector v = new Vector();
                v.add(cab);
                v.add(ppd);
                result.add(v);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static void deleteAllDetail(long pettycashPaymentId){
            
            if(pettycashPaymentId != 0){                
                CONResultSet dbrs = null;                
                try{                    
                    String sql = "DELETE FROM "+DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL+" WHERE "+
                        DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID]+" = "+pettycashPaymentId;
                
                    CONHandler.execUpdate(sql);
                    
                }catch(Exception e){
                    System.out.println("[exception] "+e.toString());
                }finally{
                    CONResultSet.close(dbrs);
                }
            }
    }
    
    
    public static void saveAllDetailBudget(BudgetRequest budgetRequest,PettycashPayment pettycashPayment, Vector listBudgetRequestDetail,long userId) {
        if (listBudgetRequestDetail != null && listBudgetRequestDetail.size() > 0) {
            for (int i = 0; i < listBudgetRequestDetail.size(); i++) {
                BudgetRequestDetail brd = (BudgetRequestDetail)listBudgetRequestDetail.get(i);
                
                PettycashPaymentDetail crd = new PettycashPaymentDetail();                
                crd.setPettycashPaymentId(pettycashPayment.getOID());
                crd.setCoaId(brd.getCoaId());
                crd.setAmount(brd.getRequest());
                crd.setMemo(brd.getMemo());
                crd.setSegment1Id(budgetRequest.getSegment1Id());

                try {
                    boolean insert = getUniqDetail(crd);
                    if(insert){
                        DbPettycashPaymentDetail.insertExc(crd);                    
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
        DbPettycashPayment.getUpdateTotalAmount(pettycashPayment.getOID());
        DbBudgetRequest.updatePosted(userId,budgetRequest.getOID(),DbBudgetRequest.PAYMENT_TYPE_CASH,pettycashPayment.getOID());
        Vector listPPDetail = DbPettycashPaymentDetail.list(0, 0, "pettycash_payment_id=" + pettycashPayment.getOID(), "");
        DbPettycashPayment.postJournal(pettycashPayment, listPPDetail, userId);
        
    }
    
    public static boolean getUniqDetail(PettycashPaymentDetail crd){
        CONResultSet crs = null;
        try{
            String sql = "select "+DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_DETAIL_ID]+" from "+DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL+" where "+
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID]+" = "+crd.getPettycashPaymentId()+" and "+
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_COA_ID]+" = "+crd.getCoaId()+" and "+
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_AMOUNT]+" = "+crd.getAmount()+" and "+
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_MEMO]+" = '"+crd.getMemo()+"' and "+
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_SEGMENT1_ID]+" = "+crd.getSegment1Id();
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            long oid = 0;
            while(rs.next()){
                oid = rs.getLong(DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_DETAIL_ID]);
            }
            if(oid == 0){
                return true;
            }
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return false;
    }
    
    
    
}
