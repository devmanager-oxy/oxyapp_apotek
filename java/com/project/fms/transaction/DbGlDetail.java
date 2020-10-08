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
import com.project.fms.activity.*;
import com.project.util.*;
import com.project.fms.master.*;
import com.project.*;
import com.project.payroll.*;
import com.project.fms.reportform.*;
import com.project.fms.session.SessReport;
import com.project.system.*;

public class DbGlDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_GL_DETAIL = "gl_detail";
    public static final int COL_GL_ID = 0;
    public static final int COL_GL_DETAIL_ID = 1;
    public static final int COL_COA_ID = 2;
    public static final int COL_DEBET = 3;
    public static final int COL_CREDIT = 4;
    public static final int COL_FOREIGN_CURRENCY_ID = 5;
    public static final int COL_FOREIGN_CURRENCY_AMOUNT = 6;
    public static final int COL_MEMO = 7;
    public static final int COL_BOOKED_RATE = 8;
    public static final int COL_DEPARTMENT_ID = 9;
    public static final int COL_SECTION_ID = 10;
    public static final int COL_SUB_SECTION_ID = 11;
    public static final int COL_JOB_ID = 12;
    public static final int COL_STATUS_TRANSACTION = 13;
    public static final int COL_CUSTOMER_ID = 14;
    public static final int COL_COA_LEVEL1_ID = 15;
    public static final int COL_COA_LEVEL2_ID = 16;
    public static final int COL_COA_LEVEL3_ID = 17;
    public static final int COL_COA_LEVEL4_ID = 18;
    public static final int COL_COA_LEVEL5_ID = 19;
    public static final int COL_COA_LEVEL6_ID = 20;
    public static final int COL_COA_LEVEL7_ID = 21;
    public static final int COL_DIRECTORATE_ID = 22;
    public static final int COL_DIVISION_ID = 23;
    public static final int COL_DEP_LEVEL1_ID = 24;
    public static final int COL_DEP_LEVEL2_ID = 25;
    public static final int COL_DEP_LEVEL3_ID = 26;
    public static final int COL_DEP_LEVEL4_ID = 27;
    public static final int COL_DEP_LEVEL5_ID = 28;
    public static final int COL_SEGMENT1_ID = 29;
    public static final int COL_SEGMENT2_ID = 30;
    public static final int COL_SEGMENT3_ID = 31;
    public static final int COL_SEGMENT4_ID = 32;
    public static final int COL_SEGMENT5_ID = 33;
    public static final int COL_SEGMENT6_ID = 34;
    public static final int COL_SEGMENT7_ID = 35;
    public static final int COL_SEGMENT8_ID = 36;
    public static final int COL_SEGMENT9_ID = 37;
    public static final int COL_SEGMENT10_ID = 38;
    public static final int COL_SEGMENT11_ID = 39;
    public static final int COL_SEGMENT12_ID = 40;
    public static final int COL_SEGMENT13_ID = 41;
    public static final int COL_SEGMENT14_ID = 42;
    public static final int COL_SEGMENT15_ID = 43;
    public static final int COL_MODULE_ID = 44;
    public static final int COL_DEP_LEVEL0_ID = 45;
    public static final String[] colNames = {
        "gl_id",
        "gl_detail_id",
        "coa_id",
        "debet",
        "credit",
        "foreign_currency_id",
        "foreign_currency_amount",
        "memo",
        "booked_rate",
        "department_id",
        "section_id",
        "sub_section_id",
        "job_id",
        "status_transaksi",
        "customer_id",
        "coa_level1_id",
        "coa_level2_id",
        "coa_level3_id",
        "coa_level4_id",
        "coa_level5_id",
        "coa_level6_id",
        "coa_level7_id",
        "directorate_id",
        "division_id",
        "dep_level1_id",
        "dep_level2_id",
        "dep_level3_id",
        "dep_level4_id",
        "dep_level5_id",
        //segment

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
        "dep_level0_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
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
        TYPE_LONG
    };

    public DbGlDetail() {
    }

    public DbGlDetail(int i) throws CONException {
        super(new DbGlDetail());
    }

    public DbGlDetail(String sOid) throws CONException {
        super(new DbGlDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGlDetail(long lOid) throws CONException {
        super(new DbGlDetail(0));
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
        return DB_GL_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGlDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GlDetail gldetail = fetchExc(ent.getOID());
        ent = (Entity) gldetail;
        return gldetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GlDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GlDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GlDetail fetchExc(long oid) throws CONException {
        try {
            GlDetail gldetail = new GlDetail();
            DbGlDetail pstGlDetail = new DbGlDetail(oid);
            gldetail.setOID(oid);

            gldetail.setGlId(pstGlDetail.getlong(COL_GL_ID));
            gldetail.setCoaId(pstGlDetail.getlong(COL_COA_ID));
            gldetail.setDebet(pstGlDetail.getdouble(COL_DEBET));
            gldetail.setCredit(pstGlDetail.getdouble(COL_CREDIT));
            gldetail.setForeignCurrencyId(pstGlDetail.getlong(COL_FOREIGN_CURRENCY_ID));
            gldetail.setForeignCurrencyAmount(pstGlDetail.getdouble(COL_FOREIGN_CURRENCY_AMOUNT));
            gldetail.setMemo(pstGlDetail.getString(COL_MEMO));
            gldetail.setBookedRate(pstGlDetail.getdouble(COL_BOOKED_RATE));

            gldetail.setDepartmentId(pstGlDetail.getlong(COL_DEPARTMENT_ID));
            gldetail.setSectionId(pstGlDetail.getlong(COL_SECTION_ID));
            gldetail.setSubSectionId(pstGlDetail.getlong(COL_SUB_SECTION_ID));
            gldetail.setJobId(pstGlDetail.getlong(COL_JOB_ID));
            gldetail.setStatusTransaction(pstGlDetail.getInt(COL_STATUS_TRANSACTION));
            gldetail.setCustomerId(pstGlDetail.getlong(COL_CUSTOMER_ID));

            gldetail.setCoaLevel1Id(pstGlDetail.getlong(COL_COA_LEVEL1_ID));
            gldetail.setCoaLevel2Id(pstGlDetail.getlong(COL_COA_LEVEL2_ID));
            gldetail.setCoaLevel3Id(pstGlDetail.getlong(COL_COA_LEVEL3_ID));
            gldetail.setCoaLevel4Id(pstGlDetail.getlong(COL_COA_LEVEL4_ID));
            gldetail.setCoaLevel5Id(pstGlDetail.getlong(COL_COA_LEVEL5_ID));
            gldetail.setCoaLevel6Id(pstGlDetail.getlong(COL_COA_LEVEL6_ID));
            gldetail.setCoaLevel7Id(pstGlDetail.getlong(COL_COA_LEVEL7_ID));

            gldetail.setDirectorateId(pstGlDetail.getlong(COL_DIRECTORATE_ID));
            gldetail.setDivisionId(pstGlDetail.getlong(COL_DIVISION_ID));

            gldetail.setDepLevel1Id(pstGlDetail.getlong(COL_DEP_LEVEL1_ID));
            gldetail.setDepLevel2Id(pstGlDetail.getlong(COL_DEP_LEVEL2_ID));
            gldetail.setDepLevel3Id(pstGlDetail.getlong(COL_DEP_LEVEL3_ID));
            gldetail.setDepLevel4Id(pstGlDetail.getlong(COL_DEP_LEVEL4_ID));
            gldetail.setDepLevel5Id(pstGlDetail.getlong(COL_DEP_LEVEL5_ID));

            gldetail.setSegment1Id(pstGlDetail.getlong(COL_SEGMENT1_ID));
            gldetail.setSegment2Id(pstGlDetail.getlong(COL_SEGMENT2_ID));
            gldetail.setSegment3Id(pstGlDetail.getlong(COL_SEGMENT3_ID));
            gldetail.setSegment4Id(pstGlDetail.getlong(COL_SEGMENT4_ID));
            gldetail.setSegment5Id(pstGlDetail.getlong(COL_SEGMENT5_ID));
            gldetail.setSegment6Id(pstGlDetail.getlong(COL_SEGMENT6_ID));
            gldetail.setSegment7Id(pstGlDetail.getlong(COL_SEGMENT7_ID));
            gldetail.setSegment8Id(pstGlDetail.getlong(COL_SEGMENT8_ID));
            gldetail.setSegment9Id(pstGlDetail.getlong(COL_SEGMENT9_ID));
            gldetail.setSegment10Id(pstGlDetail.getlong(COL_SEGMENT10_ID));
            gldetail.setSegment11Id(pstGlDetail.getlong(COL_SEGMENT11_ID));
            gldetail.setSegment12Id(pstGlDetail.getlong(COL_SEGMENT12_ID));
            gldetail.setSegment13Id(pstGlDetail.getlong(COL_SEGMENT13_ID));
            gldetail.setSegment14Id(pstGlDetail.getlong(COL_SEGMENT14_ID));
            gldetail.setSegment15Id(pstGlDetail.getlong(COL_SEGMENT15_ID));

            gldetail.setModuleId(pstGlDetail.getlong(COL_MODULE_ID));

            gldetail.setDepLevel0Id(pstGlDetail.getlong(COL_DEP_LEVEL0_ID));

            return gldetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GlDetail gldetail) throws CONException {
        try {
            DbGlDetail pstGlDetail = new DbGlDetail(0);

            pstGlDetail.setLong(COL_GL_ID, gldetail.getGlId());
            pstGlDetail.setLong(COL_COA_ID, gldetail.getCoaId());
            pstGlDetail.setDouble(COL_DEBET, gldetail.getDebet());
            pstGlDetail.setDouble(COL_CREDIT, gldetail.getCredit());
            pstGlDetail.setLong(COL_FOREIGN_CURRENCY_ID, gldetail.getForeignCurrencyId());
            pstGlDetail.setDouble(COL_FOREIGN_CURRENCY_AMOUNT, gldetail.getForeignCurrencyAmount());
            pstGlDetail.setString(COL_MEMO, gldetail.getMemo());
            pstGlDetail.setDouble(COL_BOOKED_RATE, gldetail.getBookedRate());

            pstGlDetail.setLong(COL_DEPARTMENT_ID, gldetail.getDepartmentId());
            pstGlDetail.setLong(COL_SECTION_ID, gldetail.getSectionId());
            pstGlDetail.setLong(COL_SUB_SECTION_ID, gldetail.getSubSectionId());
            pstGlDetail.setLong(COL_JOB_ID, gldetail.getJobId());

            pstGlDetail.setInt(COL_STATUS_TRANSACTION, gldetail.getStatusTransaction());
            pstGlDetail.setLong(COL_CUSTOMER_ID, gldetail.getCustomerId());

            pstGlDetail.setLong(COL_COA_LEVEL1_ID, gldetail.getCoaLevel1Id());
            pstGlDetail.setLong(COL_COA_LEVEL2_ID, gldetail.getCoaLevel2Id());
            pstGlDetail.setLong(COL_COA_LEVEL3_ID, gldetail.getCoaLevel3Id());
            pstGlDetail.setLong(COL_COA_LEVEL4_ID, gldetail.getCoaLevel4Id());
            pstGlDetail.setLong(COL_COA_LEVEL5_ID, gldetail.getCoaLevel5Id());
            pstGlDetail.setLong(COL_COA_LEVEL6_ID, gldetail.getCoaLevel6Id());
            pstGlDetail.setLong(COL_COA_LEVEL7_ID, gldetail.getCoaLevel7Id());

            pstGlDetail.setLong(COL_DIRECTORATE_ID, gldetail.getDirectorateId());
            pstGlDetail.setLong(COL_DIVISION_ID, gldetail.getDivisionId());

            pstGlDetail.setLong(COL_DEP_LEVEL1_ID, gldetail.getDepLevel1Id());
            pstGlDetail.setLong(COL_DEP_LEVEL2_ID, gldetail.getDepLevel2Id());
            pstGlDetail.setLong(COL_DEP_LEVEL3_ID, gldetail.getDepLevel3Id());
            pstGlDetail.setLong(COL_DEP_LEVEL4_ID, gldetail.getDepLevel4Id());
            pstGlDetail.setLong(COL_DEP_LEVEL5_ID, gldetail.getDepLevel5Id());

            pstGlDetail.setLong(COL_SEGMENT1_ID, gldetail.getSegment1Id());
            pstGlDetail.setLong(COL_SEGMENT2_ID, gldetail.getSegment2Id());
            pstGlDetail.setLong(COL_SEGMENT3_ID, gldetail.getSegment3Id());
            pstGlDetail.setLong(COL_SEGMENT4_ID, gldetail.getSegment4Id());
            pstGlDetail.setLong(COL_SEGMENT5_ID, gldetail.getSegment5Id());
            pstGlDetail.setLong(COL_SEGMENT6_ID, gldetail.getSegment6Id());
            pstGlDetail.setLong(COL_SEGMENT7_ID, gldetail.getSegment7Id());
            pstGlDetail.setLong(COL_SEGMENT8_ID, gldetail.getSegment8Id());
            pstGlDetail.setLong(COL_SEGMENT9_ID, gldetail.getSegment9Id());
            pstGlDetail.setLong(COL_SEGMENT10_ID, gldetail.getSegment10Id());
            pstGlDetail.setLong(COL_SEGMENT11_ID, gldetail.getSegment11Id());
            pstGlDetail.setLong(COL_SEGMENT12_ID, gldetail.getSegment12Id());
            pstGlDetail.setLong(COL_SEGMENT13_ID, gldetail.getSegment13Id());
            pstGlDetail.setLong(COL_SEGMENT14_ID, gldetail.getSegment14Id());
            pstGlDetail.setLong(COL_SEGMENT15_ID, gldetail.getSegment15Id());

            pstGlDetail.setLong(COL_MODULE_ID, gldetail.getModuleId());

            pstGlDetail.setLong(COL_DEP_LEVEL0_ID, gldetail.getDepLevel0Id());

            pstGlDetail.insert();
            gldetail.setOID(pstGlDetail.getlong(COL_GL_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail(0), CONException.UNKNOWN);
        }
        return gldetail.getOID();
    }

    public static long updateExc(GlDetail gldetail) throws CONException {
        try {
            if (gldetail.getOID() != 0) {
                DbGlDetail pstGlDetail = new DbGlDetail(gldetail.getOID());

                pstGlDetail.setLong(COL_GL_ID, gldetail.getGlId());
                pstGlDetail.setLong(COL_COA_ID, gldetail.getCoaId());
                pstGlDetail.setDouble(COL_DEBET, gldetail.getDebet());
                pstGlDetail.setDouble(COL_CREDIT, gldetail.getCredit());
                pstGlDetail.setLong(COL_FOREIGN_CURRENCY_ID, gldetail.getForeignCurrencyId());
                pstGlDetail.setDouble(COL_FOREIGN_CURRENCY_AMOUNT, gldetail.getForeignCurrencyAmount());
                pstGlDetail.setString(COL_MEMO, gldetail.getMemo());
                pstGlDetail.setDouble(COL_BOOKED_RATE, gldetail.getBookedRate());

                pstGlDetail.setLong(COL_DEPARTMENT_ID, gldetail.getDepartmentId());
                pstGlDetail.setLong(COL_SECTION_ID, gldetail.getSectionId());
                pstGlDetail.setLong(COL_SUB_SECTION_ID, gldetail.getSubSectionId());
                pstGlDetail.setLong(COL_JOB_ID, gldetail.getJobId());

                pstGlDetail.setInt(COL_STATUS_TRANSACTION, gldetail.getStatusTransaction());
                pstGlDetail.setLong(COL_CUSTOMER_ID, gldetail.getCustomerId());

                pstGlDetail.setLong(COL_COA_LEVEL1_ID, gldetail.getCoaLevel1Id());
                pstGlDetail.setLong(COL_COA_LEVEL2_ID, gldetail.getCoaLevel2Id());
                pstGlDetail.setLong(COL_COA_LEVEL3_ID, gldetail.getCoaLevel3Id());
                pstGlDetail.setLong(COL_COA_LEVEL4_ID, gldetail.getCoaLevel4Id());
                pstGlDetail.setLong(COL_COA_LEVEL5_ID, gldetail.getCoaLevel5Id());
                pstGlDetail.setLong(COL_COA_LEVEL6_ID, gldetail.getCoaLevel6Id());
                pstGlDetail.setLong(COL_COA_LEVEL7_ID, gldetail.getCoaLevel7Id());

                pstGlDetail.setLong(COL_DIRECTORATE_ID, gldetail.getDirectorateId());
                pstGlDetail.setLong(COL_DIVISION_ID, gldetail.getDivisionId());

                pstGlDetail.setLong(COL_DEP_LEVEL1_ID, gldetail.getDepLevel1Id());
                pstGlDetail.setLong(COL_DEP_LEVEL2_ID, gldetail.getDepLevel2Id());
                pstGlDetail.setLong(COL_DEP_LEVEL3_ID, gldetail.getDepLevel3Id());
                pstGlDetail.setLong(COL_DEP_LEVEL4_ID, gldetail.getDepLevel4Id());
                pstGlDetail.setLong(COL_DEP_LEVEL5_ID, gldetail.getDepLevel5Id());

                pstGlDetail.setLong(COL_SEGMENT1_ID, gldetail.getSegment1Id());
                pstGlDetail.setLong(COL_SEGMENT2_ID, gldetail.getSegment2Id());
                pstGlDetail.setLong(COL_SEGMENT3_ID, gldetail.getSegment3Id());
                pstGlDetail.setLong(COL_SEGMENT4_ID, gldetail.getSegment4Id());
                pstGlDetail.setLong(COL_SEGMENT5_ID, gldetail.getSegment5Id());
                pstGlDetail.setLong(COL_SEGMENT6_ID, gldetail.getSegment6Id());
                pstGlDetail.setLong(COL_SEGMENT7_ID, gldetail.getSegment7Id());
                pstGlDetail.setLong(COL_SEGMENT8_ID, gldetail.getSegment8Id());
                pstGlDetail.setLong(COL_SEGMENT9_ID, gldetail.getSegment9Id());
                pstGlDetail.setLong(COL_SEGMENT10_ID, gldetail.getSegment10Id());
                pstGlDetail.setLong(COL_SEGMENT11_ID, gldetail.getSegment11Id());
                pstGlDetail.setLong(COL_SEGMENT12_ID, gldetail.getSegment12Id());
                pstGlDetail.setLong(COL_SEGMENT13_ID, gldetail.getSegment13Id());
                pstGlDetail.setLong(COL_SEGMENT14_ID, gldetail.getSegment14Id());
                pstGlDetail.setLong(COL_SEGMENT15_ID, gldetail.getSegment15Id());

                pstGlDetail.setLong(COL_MODULE_ID, gldetail.getModuleId());

                pstGlDetail.setLong(COL_DEP_LEVEL0_ID, gldetail.getDepLevel0Id());

                pstGlDetail.update();
                return gldetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGlDetail pstGlDetail = new DbGlDetail(oid);
            pstGlDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL_DETAIL;
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
                GlDetail gldetail = new GlDetail();
                resultToObject(rs, gldetail);
                lists.add(gldetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, GlDetail gldetail) {
        try {
            gldetail.setOID(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]));
            gldetail.setGlId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_GL_ID]));
            gldetail.setCoaId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_ID]));
            gldetail.setDebet(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_DEBET]));
            gldetail.setCredit(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_CREDIT]));
            gldetail.setForeignCurrencyId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID]));
            gldetail.setForeignCurrencyAmount(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT]));
            gldetail.setMemo(rs.getString(DbGlDetail.colNames[DbGlDetail.COL_MEMO]));
            gldetail.setBookedRate(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE]));

            gldetail.setDepartmentId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID]));
            gldetail.setSectionId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID]));
            gldetail.setSubSectionId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID]));
            gldetail.setJobId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_JOB_ID]));

            gldetail.setStatusTransaction(rs.getInt(DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION]));
            gldetail.setCustomerId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_CUSTOMER_ID]));

            gldetail.setCoaLevel1Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID]));
            gldetail.setCoaLevel2Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID]));
            gldetail.setCoaLevel3Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID]));
            gldetail.setCoaLevel4Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID]));
            gldetail.setCoaLevel5Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID]));
            gldetail.setCoaLevel6Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID]));
            gldetail.setCoaLevel7Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID]));

            gldetail.setDirectorateId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID]));
            gldetail.setDivisionId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID]));

            gldetail.setDepLevel1Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID]));
            gldetail.setDepLevel2Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID]));
            gldetail.setDepLevel3Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID]));
            gldetail.setDepLevel4Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID]));
            gldetail.setDepLevel5Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID]));

            gldetail.setSegment1Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]));
            gldetail.setSegment2Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID]));
            gldetail.setSegment3Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID]));
            gldetail.setSegment4Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID]));
            gldetail.setSegment5Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID]));
            gldetail.setSegment6Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID]));
            gldetail.setSegment7Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID]));
            gldetail.setSegment8Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID]));
            gldetail.setSegment9Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID]));
            gldetail.setSegment10Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID]));
            gldetail.setSegment11Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID]));
            gldetail.setSegment12Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID]));
            gldetail.setSegment13Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID]));
            gldetail.setSegment14Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID]));
            gldetail.setSegment15Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID]));

            gldetail.setModuleId(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID]));

            gldetail.setDepLevel0Id(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long glDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL_DETAIL + " WHERE " +
                    DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glDetailId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID] + ") FROM " + DB_GL_DETAIL;
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
                    GlDetail gldetail = (GlDetail) list.get(ls);
                    if (oid == gldetail.getOID()) {
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

    public static void saveAllDetail2(Gl gl, Vector listGlDetail, Vector listGlDetail2) {
        boolean isActivityBase = false;
        deleteAllDetail(gl.getOID(), listGlDetail2);

        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail crd = (GlDetail) listGlDetail.get(i);
                crd.setGlId(gl.getOID());
                Coa coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(crd.getCoaId());

                    //kalau expense pada posisi debet - pengeluaran bertambah
                    if (crd.getDebet() > 0 && coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                        isActivityBase = true;
                    }
                } catch (Exception e) {
                }

                long departmentId = crd.getDepartmentId();

                if (departmentId != 0) {
                    try {
                        Department d = DbDepartment.fetchExc(departmentId);
                        switch (d.getLevel()) {
                            case DbDepartment.LEVEL_DIREKTORAT:
                                crd.setDirectorateId(departmentId);
                                break;

                            case DbDepartment.LEVEL_DIVISION:

                                crd.setDivisionId(departmentId);
                                crd.setDirectorateId(d.getRefId());

                                break;

                            case DbDepartment.LEVEL_DEPARTMENT:
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SECTION:

                                crd.setSectionId(departmentId);
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SUB_SECTION:

                                crd.setSubSectionId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_JOB:

                                crd.setJobId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSubSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            }
                    } catch (Exception e) {
                        System.out.println("[Exception] "+e.toString());
                    }
                }

                crd = DbGlDetail.setCoaLevel(crd);
                crd = DbGlDetail.setOrganizationLevel(crd);

                try {

                    long oid = 0;
                    double amount = 0;

                    if (crd.getOID() == 0) {

                        oid = DbGlDetail.insertExc(crd);

                        if (crd.getDebet() > 0) {

                            //kalau saldo normal debet, maka(+)
                            amount = crd.getDebet();

                            //saldo normal credit
                            if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                amount = amount * -1;

                            }

                        } else {
                            //kalau saldo normal debet maka (-)
                            amount = crd.getCredit() * -1;

                            //saldo normal credit, maka kembalikan ke positif
                            if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                amount = amount * -1;
                            }
                        }
                    } else {
                        GlDetail gdx = fetchExc(crd.getOID());
                        //Coa coax = DbCoa.fetchExc(gdx.getCoaId());
                        double amountx = 0;
                        oid = DbGlDetail.updateExc(crd);

                        if (oid != 0) {

                            if (gdx.getDebet() > 0) {
                                //ambil amount lama
                                amountx = gdx.getDebet();

                                //jika yang normal credit, 
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    //jika CREDIT, jika yang baru value debet
                                    //maka selisih = val lama - val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = amountx - crd.getDebet();
                                    } //jika credit
                                    else {
                                        amount = amountx + crd.getCredit();
                                    }

                                } //saldo normal debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val baru - val lama
                                    if (crd.getIsDebet() == 1) {
                                        amount = crd.getDebet() - amountx;
                                    } //jika credit
                                    //maka selisihnya = -1 *(lama+baru)
                                    else {
                                        amount = (amountx + crd.getCredit()) * -1;
                                    }
                                }
                            } else {

                                //jika amount lama di credit	                            	
                                amountx = gdx.getCredit();

                                //jika yang normal credit, 
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    //jika CREDIT, jika yang baru value debet
                                    //maka selisih = val lama - val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet()) * -1;
                                    } //jika credit, baru - lama
                                    else {
                                        amount = crd.getCredit() - amountx;
                                    }

                                } //saldo normat debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val lama + val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet());
                                    } //jika credit, lama - baru
                                    else {
                                        amount = amountx - crd.getCredit();
                                    }
                                }

                            }

                        }
                    }

                    if (oid != 0 && amount != 0 && crd.getModuleId() != 0) {
                        DbModuleBudget.updateBudgetUsed(crd.getModuleId(), crd.getCoaId(), amount);
                    }
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
            }
        }

        if (!isActivityBase) {
            try {
                gl = DbGl.fetchExc(gl.getOID());
                gl.setActivityStatus(I_Project.STATUS_POSTED);
                gl.setNotActivityBase(1);
                DbGl.updateExc(gl);
            } catch (Exception e) {
            }
        }
    }

    public static void saveAllDetail2(Gl gl, Vector listGlDetail) {
        boolean isActivityBase = false;

        if (listGlDetail != null && listGlDetail.size() > 0) {

            for (int i = 0; i < listGlDetail.size(); i++) {

                GlDetail crd = (GlDetail) listGlDetail.get(i);

                crd.setGlId(gl.getOID());

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(crd.getCoaId());

                    //kalau expense pada posisi debet - pengeluaran bertambah
                    if (crd.getDebet() > 0 && coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                        isActivityBase = true;
                    }
                } catch (Exception e) {
                }

                long departmentId = crd.getDepartmentId();

                if (departmentId != 0) {
                    try {
                        Department d = DbDepartment.fetchExc(departmentId);
                        switch (d.getLevel()) {
                            case DbDepartment.LEVEL_DIREKTORAT:
                                crd.setDirectorateId(departmentId);
                                break;

                            case DbDepartment.LEVEL_DIVISION:

                                crd.setDivisionId(departmentId);
                                crd.setDirectorateId(d.getRefId());

                                break;

                            case DbDepartment.LEVEL_DEPARTMENT:
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SECTION:

                                crd.setSectionId(departmentId);
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SUB_SECTION:

                                crd.setSubSectionId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_JOB:

                                crd.setJobId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSubSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            }
                    } catch (Exception e) {
                        System.out.println("[Exception] "+e.toString());
                    }
                }

                crd = DbGlDetail.setCoaLevel(crd);
                crd = DbGlDetail.setOrganizationLevel(crd);

                try {

                    long oid = 0;
                    double amount = 0;

                    if (crd.getOID() == 0) {

                        oid = DbGlDetail.insertExc(crd);

                        if (crd.getDebet() > 0) {

                            //kalau saldo normal debet, maka(+)
                            amount = crd.getDebet();

                            //saldo normal credit
                            if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                amount = amount * -1;

                            }
                        } else {
                            //kalau saldo normal debet maka (-)
                            amount = crd.getCredit() * -1;

                            //saldo normal credit, maka kembalikan ke positif
                            if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                amount = amount * -1;

                            }
                        }
                    } else {
                        GlDetail gdx = fetchExc(crd.getOID());
                        //Coa coax = DbCoa.fetchExc(gdx.getCoaId());
                        double amountx = 0;
                        oid = DbGlDetail.updateExc(crd);

                        if (oid != 0) {

                            if (gdx.getDebet() > 0) {
                                //ambil amount lama
                                amountx = gdx.getDebet();

                                //jika yang normal credit, 
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    //jika CREDIT, jika yang baru value debet
                                    //maka selisih = val lama - val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = amountx - crd.getDebet();
                                    } //jika credit
                                    else {
                                        amount = amountx + crd.getCredit();
                                    }

                                } //saldo normal debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val baru - val lama
                                    if (crd.getIsDebet() == 1) {
                                        amount = crd.getDebet() - amountx;
                                    } //jika credit
                                    //maka selisihnya = -1 *(lama+baru)
                                    else {
                                        amount = (amountx + crd.getCredit()) * -1;
                                    }
                                }
                            } else {

                                //jika amount lama di credit	                            	
                                amountx = gdx.getCredit();

                                //jika yang normal credit, 
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    //jika CREDIT, jika yang baru value debet
                                    //maka selisih = val lama - val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet()) * -1;
                                    } //jika credit, baru - lama
                                    else {
                                        amount = crd.getCredit() - amountx;
                                    }

                                } //saldo normat debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val lama + val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet());
                                    } //jika credit, lama - baru
                                    else {
                                        amount = amountx - crd.getCredit();
                                    }
                                }

                            }

                        }
                    }

                    if (oid != 0 && amount != 0 && crd.getModuleId() != 0) {
                        DbModuleBudget.updateBudgetUsed(crd.getModuleId(), crd.getCoaId(), amount);
                    }
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
            }
        }

        if (!isActivityBase) {
            try {
                gl = DbGl.fetchExc(gl.getOID());
                gl.setActivityStatus(I_Project.STATUS_POSTED);
                gl.setNotActivityBase(1);
                DbGl.updateExc(gl);
            } catch (Exception e) {
            }
        }
    }
    
    public static int getUnixData(long glId,GlDetail glDetail,long glDetailId){
        
        CONResultSet dbrs = null;
        try{
            String sql = "select count("+DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]+") from "+DbGlDetail.DB_GL_DETAIL+
                    " where "+DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+" = "+glId+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+glDetail.getSegment1Id()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID]+" = "+glDetail.getSegment2Id()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_COA_ID]+" = "+glDetail.getCoaId()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE]+" = "+glDetail.getBookedRate()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_DEBET]+" = "+glDetail.getDebet()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_CREDIT]+" = "+glDetail.getCredit()+" and "+
                    DbGlDetail.colNames[DbGlDetail.COL_MEMO]+" = '"+glDetail.getMemo()+"'";
            
            if(glDetailId != 0){
                sql = sql + " and "+DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]+" != "+glDetailId;
            }   
                    
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
        
        
    }

    public static void saveAllDetail(Gl gl, Vector listGlDetail) {
        deleteAllDetail(gl.getOID());

        boolean isActivityBase = false;

        if (listGlDetail != null && listGlDetail.size() > 0) {

            for (int i = 0; i < listGlDetail.size(); i++) {

                GlDetail crd = (GlDetail) listGlDetail.get(i);

                crd.setOID(0);
                crd.setGlId(gl.getOID());

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(crd.getCoaId());

                    //kalau expense pada posisi debet - pengeluaran bertambah
                    if (crd.getDebet() > 0 && coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                        isActivityBase = true;
                    }
                } catch (Exception e) {
                }

                long departmentId = crd.getDepartmentId();

                if (departmentId != 0) {
                    try {
                        Department d = DbDepartment.fetchExc(departmentId);
                        switch (d.getLevel()) {
                            case DbDepartment.LEVEL_DIREKTORAT:
                                crd.setDirectorateId(departmentId);
                                break;

                            case DbDepartment.LEVEL_DIVISION:

                                crd.setDivisionId(departmentId);
                                crd.setDirectorateId(d.getRefId());

                                break;

                            case DbDepartment.LEVEL_DEPARTMENT:
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SECTION:

                                crd.setSectionId(departmentId);
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_SUB_SECTION:

                                crd.setSubSectionId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            case DbDepartment.LEVEL_JOB:

                                crd.setJobId(departmentId);
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSubSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setSectionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDepartmentId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDivisionId(d.getRefId());
                                d = DbDepartment.fetchExc(d.getRefId());
                                crd.setDirectorateId(d.getRefId());

                                break;
                            }
                    } catch (Exception e) {
                        System.out.println("[Exception] "+e.toString());
                    }
                }

                crd = DbGlDetail.setCoaLevel(crd);
                crd = DbGlDetail.setOrganizationLevel(crd);

                try {
                    long oid = 0;
                    double amount = 0;

                    if (crd.getOID() == 0) {
                        
                        int totData = getUnixData(crd.getGlId(),crd,0);
                        
                        if(totData == 0){
                            oid = DbGlDetail.insertExc(crd);

                            if (crd.getDebet() > 0) {
                                //kalau saldo normal debet, maka(+)
                                amount = crd.getDebet();

                                //saldo normal credit
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                amount = amount * -1;

                                }
                            } else {
                                //kalau saldo normal debet maka (-)
                                amount = crd.getCredit() * -1;

                                //saldo normal credit, maka kembalikan ke positif
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    amount = amount * -1;

                                }
                            }
                        }
                    } else {

                        GlDetail gdx = fetchExc(crd.getOID());
                        //Coa coax = DbCoa.fetchExc(gdx.getCoaId());
                        double amountx = 0;

                        oid = DbGlDetail.updateExc(crd);

                        if (oid != 0) {
                            
                            int totData = getUnixData(crd.getGlId(),crd,oid);
                            if(totData == 0){
                                if (gdx.getDebet() > 0) {
                                    //ambil amount lama
                                    amountx = gdx.getDebet();

                                    //jika yang normal credit, 
                                    if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                        //jika CREDIT, jika yang baru value debet
                                        //maka selisih = val lama - val baru
                                        if (crd.getIsDebet() == 1) {
                                            amount = amountx - crd.getDebet();
                                        } //jika credit
                                        else {
                                            amount = amountx + crd.getCredit();
                                        }

                                    } //saldo normal debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val baru - val lama
                                    if (crd.getIsDebet() == 1) {
                                        amount = crd.getDebet() - amountx;
                                    } //jika credit
                                    //maka selisihnya = -1 *(lama+baru)
                                    else {
                                        amount = (amountx + crd.getCredit()) * -1;
                                    }
                                }
                            } else {

                                //jika amount lama di credit	                            	
                                amountx = gdx.getCredit();

                                //jika yang normal credit, 
                                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                                    //jika CREDIT, jika yang baru value debet
                                    //maka selisih = val lama - val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet()) * -1;
                                    } //jika credit, baru - lama
                                    else {
                                        amount = crd.getCredit() - amountx;
                                    }

                                } //saldo normat debet
                                else {
                                    //jika DEBET, jika yang baru value debet
                                    //maka selisih = val lama + val baru
                                    if (crd.getIsDebet() == 1) {
                                        amount = (amountx + crd.getDebet());
                                    } //jika credit, lama - baru
                                    else {
                                        amount = amountx - crd.getCredit();
                                    }
                                }

                            }
                        }

                        }
                    }

                    if (oid != 0 && amount != 0 && crd.getModuleId() != 0) {
                        DbModuleBudget.updateBudgetUsed(crd.getModuleId(), crd.getCoaId(), amount);
                    }
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
            }
        }

        if (!isActivityBase) {
            try {
                gl = DbGl.fetchExc(gl.getOID());
                gl.setActivityStatus(I_Project.STATUS_POSTED);
                gl.setNotActivityBase(1);
                DbGl.updateExc(gl);
            } catch (Exception e) {
            }
        }
    }

    // id divisi dari department
    public static long getDirectoratOid(long depAcuanOid) {
        try {
            if (depAcuanOid != 0) {
                Department departement = DbDepartment.fetchExc(depAcuanOid);
                if (departement.getLevel() == DbDepartment.LEVEL_DIREKTORAT) {
                    return departement.getOID();
                } else {
                    if (departement.getRefId() != 0) {
                        getDirectoratOid(departement.getRefId());
                    } else {
                        depAcuanOid = 0;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        }
        return 0;
    }

    // id divisi dari department
    public static long getDivisionOid(long depAcuanOid) {
        try {
            if (depAcuanOid != 0) {
                Department department = DbDepartment.fetchExc(depAcuanOid);
                if (department.getLevel() == DbDepartment.LEVEL_DIVISION) {
                    return department.getOID();
                } else {
                    if (department.getRefId() != 0) {
                        getDivisionOid(department.getRefId());
                    } else {
                        depAcuanOid = 0;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        }
        return 0;
    }

    public static Vector getActivityPredefined(long glOID) {
        Vector result = new Vector();
        ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
        CONResultSet crs = null;
        try {
            String sql = "SELECT c.*, pd.* FROM " + DbCoaActivityBudget.DB_COA_ACTIVITY_BUDGET + " c inner join " +
                    " " + DbGlDetail.DB_GL_DETAIL + " pd on pd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=c." + DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_ID] +
                    " where pd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                    " and c." + DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_ACTIVITY_PERIOD_ID] + " = " + ap.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CoaActivityBudget cab = new CoaActivityBudget();
                GlDetail ppd = new GlDetail();
                DbCoaActivityBudget.resultToObject(rs, cab);
                resultToObject(rs, ppd);
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

    public static Vector getGeneralLedger(Date startDate, Date endDate, long oidCoa) {

        String sql = " select g.*, gd.* from " + DbGl.DB_GL + " g " +
                " inner join " + DbGlDetail.DB_GL_DETAIL + " gd on " +
                " gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=g." + DbGl.colNames[DbGl.COL_GL_ID] +
                " where (to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")>=to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")<=to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')) and " +
                " coa_id = " + oidCoa + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ", g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);
                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static Vector getGeneralLedger(Date startDate, Date endDate, long oidCoa, String where) {

        String sql = " select g.*, gd.* from " + DbGl.DB_GL + " g " +
                " inner join " + DbGlDetail.DB_GL_DETAIL + " gd on " +
                " gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=g." + DbGl.colNames[DbGl.COL_GL_ID] +
                " where (to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")>=to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")<=to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')) and " +
                " coa_id = " + oidCoa + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
        
        if(where.length() > 0){
            sql = sql +" and "+where;
        }

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ", g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);
                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static Vector getGeneralLedger(Date startDate, Date endDate, long oidCoa, String where,int status) {

        String sql = " select g.*, gd.* from " + DbGl.DB_GL + " g " +
                " inner join " + DbGlDetail.DB_GL_DETAIL + " gd on " +
                " gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=g." + DbGl.colNames[DbGl.COL_GL_ID] +
                " where (to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")>=to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")<=to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')) and " +
                " coa_id = " + oidCoa;
        
        if(status !=0){
            if(status == 1){
                sql = sql +" and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
            }else{
                sql = sql +" and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.NOT_POSTED;
            }
        }
        
        if(where.length() > 0){
            sql = sql +" and "+where;
        }

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ", g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);
                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    
    public static Vector getGeneralLedger(Date date, long oidCoa) {

        String sql = " select g.*, gd.* from " + DbGl.DB_GL + " g " +
                " inner join " + DbGlDetail.DB_GL_DETAIL + " gd on " +
                " gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=g." + DbGl.colNames[DbGl.COL_GL_ID] +
                " where (to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")=to_days('" + JSPFormater.formatDate(date, "yyyy-MM-dd") + "')) and " +
                " coa_id = " + oidCoa;

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ", g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);
                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getGLOpeningBalance(Date selectedDate, Coa coa) {
        /**
         * 1. get opening balance from periode
         */
        //get closed period
        String where = DbPeriode.colNames[DbPeriode.COL_END_DATE] + " < '" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "'" +
                " AND " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_CLOSED + "'";
        String order = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC";
        Vector vPeriode = DbPeriode.list(0, 1, where, order);        
        double openingBalance = 0;
        
        Periode closedPeriode = new Periode();
        try{
            closedPeriode = (Periode) vPeriode.get(0);
        }catch(Exception e){}
        
        if (vPeriode != null && vPeriode.size() > 0) {

            //get opening balance period
            Calendar calendar = new GregorianCalendar(1900 + closedPeriode.getStartDate().getYear(), closedPeriode.getStartDate().getMonth(), closedPeriode.getStartDate().getDate());
            calendar.add(Calendar.MONTH, 1);
            if (closedPeriode.getType() == DbPeriode.TYPE_PERIOD13) {
                calendar.set(Calendar.DAY_OF_MONTH, 1);
            } //setup date = 1st if prev period is period13th
        
            Date obDate = calendar.getTime();
            where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(obDate, "yyyy-MM-dd") + "'";
            vPeriode = DbPeriode.list(0, 1, where, "");
            Periode obPeriode = (Periode) vPeriode.get(0);

            //get opening balance
            openingBalance = DbCoaOpeningBalanceLocation.getOpeningBalance(obPeriode, coa.getOID());
        
        }

        /**
         * 2. get opening balance from transaction
         */
        Periode selPeriod = DbPeriode.getPeriodByTransDate(selectedDate);
        
        if(selPeriod != null && selPeriod.getOID() > 0){
            
            /*Calendar calendar1 = new GregorianCalendar(1900 + selectedDate.getYear(), selectedDate.getMonth(), selectedDate.getDate());
            calendar1.add(Calendar.DAY_OF_MONTH, -1);
            Date endDate = calendar1.getTime(); //end date is one day before selected date

            String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where gd." + colNames[COL_COA_ID] + " = " + coa.getOID() +
                " and g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + JSPFormater.formatDate(selPeriod.getStartDate(), "yyyy-MM-dd 00:00:00") + "'" +
                " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd 23:59:59") + "'";*/
            
            String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where gd." + colNames[COL_COA_ID] + " = " + coa.getOID();
            
            
            if(closedPeriode.getOID() != 0){
                sql = sql + " and to_days("+DbGl.colNames[DbGl.COL_TRANS_DATE]+") > to_days("+JSPFormater.formatDate(closedPeriode.getEndDate(), "yyyy-MM-dd") +") ";
            }else{
                sql = sql + " and to_days("+DbGl.colNames[DbGl.COL_TRANS_DATE]+") >= to_days("+JSPFormater.formatDate(selPeriod.getStartDate(), "yyyy-MM-dd") +") ";
            }
            
            sql = sql + " and to_days("+DbGl.colNames[DbGl.COL_TRANS_DATE]+") <- to_days("+JSPFormater.formatDate(selPeriod.getEndDate(), "yyyy-MM-dd") +") ";
        
            double debet = 0;
            double credit = 0;
            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    debet = rs.getDouble(1);
                    credit = rs.getDouble(2);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

            /**
            * 3. sum opening balance
            */
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                openingBalance = openingBalance + (debet - credit);
            } else {
                openingBalance = openingBalance + (credit - debet);

            }
        }
        return openingBalance;

    }
    
    
    public static double getGLOpeningBalanceLocation(Date selectedDate, Coa coa, long segment1Id) {
        /**
         * 1. get opening balance from periode
         */
        
        //get closed period
        String where = DbPeriode.colNames[DbPeriode.COL_END_DATE] + " < '" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "'" +
                " AND " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_CLOSED + "'";
        String order = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC";
        Vector vPeriode = DbPeriode.list(0, 1, where, order);        
        double openingBalance = 0;
        
        Periode closedPeriode = new Periode();
        Periode openPeriode = new Periode();
        
        if (vPeriode != null && vPeriode.size() > 0) {
            try{
                closedPeriode = (Periode) vPeriode.get(0);
            }catch(Exception e){}
            
            where = " to_days("+DbPeriode.colNames[DbPeriode.COL_START_DATE] + ") > to_days('" + JSPFormater.formatDate(closedPeriode.getEndDate(), "yyyy-MM-dd") + "')";             
            vPeriode = DbPeriode.list(0, 1, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]);
            openPeriode = (Periode) vPeriode.get(0);

            //get opening balance
            openingBalance = DbCoaOpeningBalanceLocation.getOpeningBalance(openPeriode, coa.getOID(),segment1Id);
        
        }

        /**
         * 2. get opening balance from transaction
         */
        Periode selPeriod = DbPeriode.getPeriodByTransDate(selectedDate);
        
        if(selPeriod != null && selPeriod.getOID() > 0){
         
            String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where gd." + colNames[COL_COA_ID] + " = " + coa.getOID();            
            
            if(closedPeriode.getOID() != 0){
                sql = sql + " and to_days(g."+DbGl.colNames[DbGl.COL_TRANS_DATE]+") > to_days('"+JSPFormater.formatDate(closedPeriode.getEndDate(), "yyyy-MM-dd") +"') ";
            }
            
            sql = sql + " and to_days(g."+DbGl.colNames[DbGl.COL_TRANS_DATE]+") < to_days('"+JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") +"') ";
            
            if(segment1Id != 0){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+segment1Id;
            }
        
            double debet = 0;
            double credit = 0;
            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    debet = rs.getDouble(1);
                    credit = rs.getDouble(2);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

            /**
            * 3. sum opening balance
            */
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                openingBalance = openingBalance + (debet - credit);
            } else {
                openingBalance = openingBalance + (credit - debet);

            }
        }
        return openingBalance;

    }
    
    public static double getGLOpeningBalanceLocation(Date selectedDate, Coa coa, String whereMd){
        
        double openingBalance = 0;
         
        String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where gd." + colNames[COL_COA_ID] + " = " + coa.getOID();            
            
        sql = sql + " and to_days(g."+DbGl.colNames[DbGl.COL_TRANS_DATE]+") < to_days('"+JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") +"') ";
            
        if(whereMd != null && whereMd.length() > 0){
            sql = sql + " and "+whereMd;
        }
        
        double debet = 0;
        double credit = 0;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                debet = rs.getDouble(1);
                credit = rs.getDouble(2);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

            
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
            openingBalance = openingBalance + (debet - credit);
        } else {
            openingBalance = openingBalance + (credit - debet);
        }
        
        return openingBalance;

    }
    
    
      public static double getGLOpeningBalanceLocation(Date selectedDate, Coa coa, String whereMd2,String whereCrd,String wherePpd,String whereBd,String where,String wherex){
        
        double openingBalance = 0;
      
        String sql = "select sum(debet),sum(credit) from ( " + 
                        " select crd.cash_receive_detail_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,crd.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereCrd+
                        " union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        
                        " union select ppd.pettycash_payment_detail_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + wherePpd+
                        " union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        
                        " union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select bd.bank_deposit_detail_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd+
                        
                        " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select bd.bankpo_payment_detail_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd+
                        
                        " union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select bd.banknonpo_payment_detail_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd+
                        
                        " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + wherex + " ) as x " + whereMd2 + " order by trans_date";
        
        double debet = 0;
        double credit = 0;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                debet = rs.getDouble(1);
                credit = rs.getDouble(2);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
            
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
            openingBalance = openingBalance + (debet - credit);
        } else {
            openingBalance = openingBalance + (credit - debet);
        }
        
        return openingBalance;

    }
      
      
    public static double getGLOpeningBalanceLocation(Date selectedDate, Coa coa, String whereMd2,String whereCrd,String wherePpd,String whereBd,String where,String wherex,String posting){
        
        double openingBalance = 0;
      
        String sqlx = "";
        if (posting.equals("YES")) {
            sqlx =  " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                    " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd;
        } else {
            sqlx =  " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') and type = 1 " + where +
                    " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') and bd.type = 1 " + whereBd;
        }        
        
        String sql = "select sum(debet),sum(credit) from ( " + 
                        " select cr.cash_receive_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,crd.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereCrd+
                        " union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select pp.pettycash_payment_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + wherePpd+
                        " union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select b.bank_deposit_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd;
       
        sql = sql + sqlx;
                        
        sql = sql +" union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + where +
                        " union select b.banknonpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + whereBd+
                        " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') " + wherex + " ) as x " + whereMd2 + " order by trans_date";
                
        double debet = 0;
        double credit = 0;
        CONResultSet crs = null;        
        
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                debet = rs.getDouble(1);
                credit = rs.getDouble(2);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
            
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
            openingBalance = openingBalance + (debet - credit);
        } else {
            openingBalance = openingBalance + (credit - debet);
        }
        
        return openingBalance;

    }  
    
    
    
    public static double getGLOpeningBalanceLocation(Date selectedDate, Coa coa, String whereMd,int status,String whereMd2){
        
        double openingBalance = 0;        
        String sql = "";
         
        if (status == 0) {
            sql = "select sum(debet),sum(credit) from ( select cr.cash_receive_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,cr.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select pp.pettycash_payment_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select b.bank_deposit_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select b.banknonpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') ) as x " + whereMd2 + " order by trans_date ";
        } else {
            if (status == DbGl.POSTED) {
                sql = "select sum(gd.debet) as debet,sum(gd.credit) as credit from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 1 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') ";
                if (whereMd != null && whereMd.length() > 0){
                    sql = sql + whereMd;
                }
            } else {
                sql = "select sum(debet),sum(credit) from ( select cr.cash_receive_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,cr.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select pp.pettycash_payment_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "')  union select b.bank_deposit_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select b.banknonpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "') union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 0 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) < to_days('" + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") + "')  ) as x " + whereMd2 + " order by trans_date ";
            }
        }
         
             
        
            double debet = 0;
            double credit = 0;
            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    debet = rs.getDouble(1);
                    credit = rs.getDouble(2);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

            /**
            * 3. sum opening balance
            */
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                openingBalance = openingBalance + (debet - credit);
            } else {
                openingBalance = openingBalance + (credit - debet);

            }
        //}
        return openingBalance;

    }

    public static double getGeneralLedgerOpeningBalance(Date endDate, Coa coa) {

        //cari opening balance awal tahun
        double openingBalance = 0;//DbCoaOpeningBalance.getOpeningBalance(p,  coa.getOID());

        String sqlOpen = " select opening_balance from coa_opening_balance ob " +
                " inner join periode p on p.periode_id = ob.periode_id " +
                " where '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'" +
                " between p.start_date and p.end_date and ob.coa_id = " + coa.getOID();

        CONResultSet crsx = null;
        
        try {
            crsx = CONHandler.execQueryResult(sqlOpen);
            ResultSet rs = crsx.getResultSet();
            while (rs.next()) {
                openingBalance = rs.getDouble(1);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crsx);
        }

        //jika tanggal awal searching != dengan tanggal 1 lakukan penghitungan balance dari tanggal 1 sampe tanggal start
        if (endDate.getDate() != 1) {

            Date startDate = (Date) endDate.clone();
            startDate.setDate(1);

            boolean isDebetPosition = false;

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                isDebetPosition = true;
            }

            String sql = "";
            //debet - credit
            if (isDebetPosition) {
                //sql = "select (sum(gd."+DbGlDetail.colNames[DbGlDetail.COL_DEBET]+")-sum(gd."+DbGlDetail.colNames[DbGlDetail.COL_CREDIT]+")) from "+DbGlDetail.DB_GL_DETAIL+ " as gd ";

                sql = " select (sum(" + colNames[COL_DEBET] + ") - sum(" + colNames[COL_CREDIT] + ")) as amount from " + DB_GL_DETAIL + " gd " +
                        " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                        " where gd." + colNames[COL_COA_ID] + "=" + coa.getOID() +
                        " and " +
                        " (g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " < '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";


            } //credit - debet
            else {
                sql = " select (sum(" + colNames[COL_CREDIT] + ") - sum(" + colNames[COL_DEBET] + ")) as amount from " + DB_GL_DETAIL + " gd " +
                        " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                        " where gd." + colNames[COL_COA_ID] + "=" + coa.getOID() +
                        " and " +
                        " (g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " < '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            }

            double sisa = 0;
            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    sisa = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(crs);
            }

            openingBalance = openingBalance + sisa;
        }

        return openingBalance;
    }

    public static Vector getUnfinishTransaction(long coaId, Vector coas) {

        String sql = "select * from " + DB_GL_DETAIL + "  gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where status_transaksi=0";

        if (coaId != 0) {
            sql = sql + " and " + colNames[COL_COA_ID] + "=" + coaId;
        } else {
            String where = "";
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    where = where + colNames[COL_COA_ID] + "=" + coax.getOID() + " or ";
                }

                where = "(" + where.substring(0, where.length() - 3) + ")";
            }
            sql = sql + " and " + where;
        }

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);

                result.add(temp);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static Vector getSaldoTransaction(long customerId, long coaId, Vector coas) {

        String sql = "select " + colNames[COL_CUSTOMER_ID] + ", sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")" +
                " from " + DB_GL_DETAIL + " where status_transaksi=1 and " + colNames[COL_CUSTOMER_ID] + "!=0";

        if (customerId != 0) {
            sql = sql + " and " + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (coaId != 0) {
            sql = sql + " and " + colNames[COL_COA_ID] + "=" + coaId;
        } else {
            String where = "";
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    where = where + colNames[COL_COA_ID] + "=" + coax.getOID() + " or ";
                }

                where = "(" + where.substring(0, where.length() - 3) + ")";
            }
            sql = sql + " and " + where;
        }

        sql = sql + " group by " + colNames[COL_CUSTOMER_ID];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();

                gd.setCustomerId(rs.getLong(1));
                gd.setDebet(rs.getDouble(2));

                result.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static Vector getSaldoDeposit(long customerId, long coaId, Vector coas) {

        String sql = "select " + colNames[COL_CUSTOMER_ID] + ", sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " where status_transaksi=1 and " + colNames[COL_CUSTOMER_ID] + "!=0";

        if (customerId != 0) {
            sql = sql + " and " + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (coaId != 0) {
            sql = sql + " and " + colNames[COL_COA_ID] + "=" + coaId;
        } else {
            String where = "";
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    where = where + colNames[COL_COA_ID] + "=" + coax.getOID() + " or ";
                }

                where = "(" + where.substring(0, where.length() - 3) + ")";
            }
            sql = sql + " and " + where;
        }

        sql = sql + " group by " + colNames[COL_CUSTOMER_ID];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();

                gd.setCustomerId(rs.getLong(1));
                gd.setDebet(rs.getDouble(2));

                result.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static int procesInsertGlDetail(Vector vGlDetail) {
        try {
            if (vGlDetail != null && vGlDetail.size() > 0) {
                for (int i = 0; i < vGlDetail.size(); i++) {
                    GlDetail glDetail = new GlDetail();
                    glDetail = (GlDetail) vGlDetail.get(i);
                    
                    try {
                        DbGlDetail.insertExc(glDetail);
                    } catch (Exception e) {
                        System.out.println("[Exception] "+e.toString());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        }

        return 1;

    }

    // ---------------------------- NEW GENERATION REPORT -------------------------------------
    // ========================================================================================
    public static GlDetail setCoaLevel(GlDetail glDetail) {

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(glDetail.getCoaId());
        } catch (Exception e) {

        }

        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

        if (coaLabaLalu.getCode().equals(coa.getCode()) || coaLabaBerjalan.getCode().equals(coa.getCode())) {

            glDetail.setCoaLevel7Id(coa.getOID());
            glDetail.setCoaLevel6Id(coa.getOID());
            glDetail.setCoaLevel5Id(coa.getOID());
            glDetail.setCoaLevel4Id(coa.getOID());
            glDetail.setCoaLevel3Id(coa.getOID());
            glDetail.setCoaLevel2Id(coa.getOID());
            glDetail.setCoaLevel1Id(coa.getOID());

        } else {

            switch (coa.getLevel()) {
                case 1:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getOID());
                    glDetail.setCoaLevel4Id(coa.getOID());
                    glDetail.setCoaLevel3Id(coa.getOID());
                    glDetail.setCoaLevel2Id(coa.getOID());
                    glDetail.setCoaLevel1Id(coa.getOID());
                    break;
                case 2:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getOID());
                    glDetail.setCoaLevel4Id(coa.getOID());
                    glDetail.setCoaLevel3Id(coa.getOID());
                    glDetail.setCoaLevel2Id(coa.getOID());
                    glDetail.setCoaLevel1Id(coa.getAccRefId());
                    break;
                case 3:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getOID());
                    glDetail.setCoaLevel4Id(coa.getOID());
                    glDetail.setCoaLevel3Id(coa.getOID());
                    glDetail.setCoaLevel2Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 4:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getOID());
                    glDetail.setCoaLevel4Id(coa.getOID());
                    glDetail.setCoaLevel3Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 5:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getOID());
                    glDetail.setCoaLevel4Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 6:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getOID());
                    glDetail.setCoaLevel5Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel4Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 7:
                    glDetail.setCoaLevel7Id(coa.getOID());
                    glDetail.setCoaLevel6Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel5Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel4Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
            }

        }

        return glDetail;

    }

    public static GlDetail setOrganizationLevel(GlDetail glDetail) {
        Department dep = new Department();
        
        try {
            dep = DbDepartment.fetchExc(glDetail.getDepartmentId());
        } catch (Exception e) {
        }

        switch (dep.getLevel()) {
            case 0://direktorat
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getOID());
                glDetail.setDepLevel3Id(dep.getOID());
                glDetail.setDepLevel2Id(dep.getOID());
                glDetail.setDepLevel1Id(dep.getOID());
                glDetail.setDepLevel0Id(dep.getOID());
                break;
            case 1:
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getOID());
                glDetail.setDepLevel3Id(dep.getOID());
                glDetail.setDepLevel2Id(dep.getOID());
                glDetail.setDepLevel1Id(dep.getOID());
                glDetail.setDepLevel0Id(dep.getRefId());
                break;
            case 2:
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getOID());
                glDetail.setDepLevel3Id(dep.getOID());
                glDetail.setDepLevel2Id(dep.getOID());
                glDetail.setDepLevel1Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 3:
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getOID());
                glDetail.setDepLevel3Id(dep.getOID());
                glDetail.setDepLevel2Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 4:
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getOID());
                glDetail.setDepLevel3Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel2Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 5:
                glDetail.setDepLevel5Id(dep.getOID());
                glDetail.setDepLevel4Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel3Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel2Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
        }

        return glDetail;
    }

    public static double getRealisasiLastYear(long rptDetailId, Periode period, String whereSegment) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {

                Coa coaTahunLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));
                Coa coaTahunBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(rdc.getCoaId());
                    } catch (Exception e) {
                    }

                    //jika bukan laba
                    if (coa.getOID() != coaTahunLalu.getOID() && coa.getOID() != coaTahunBerjalan.getOID()) {
                        if (rdc.getIsMinus() == 1) {
                            //result = result - DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId());
                            result = result - getOpeningBalance(per, rdc.getCoaId(), whereSegment);
                            result = result - getAmountInPeriod(per.getOID(), rdc.getCoaId(), whereSegment);
                        } else {
                            //result = result + DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId());
                            result = result + getOpeningBalance(per, rdc.getCoaId(), whereSegment);
                            result = result + getAmountInPeriod(per.getOID(), rdc.getCoaId(), whereSegment);
                        }
                    } //laba tahun lalu
                    else if (coa.getOID() == coaTahunLalu.getOID()) {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), per, whereSegment);
                        } else {
                            result = result + DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), per, whereSegment);
                        }
                    } //laba berjalan
                    else {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), per, whereSegment);
                        } else {
                            result = result + DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), per, whereSegment);
                        }
                    }
                }
            }
        }

        return result;

    }

    public static double getRealisasiLastYear(long rptDetailId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {
                /*for(int i=0; i<temp.size(); i++){
                RptFormatDetailCoa rdc = (RptFormatDetailCoa)temp.get(i);	
                result = result + DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId()); 
                result = result + getAmountInPeriod(per.getOID(), rdc.getCoaId());
                } */

                Coa coaTahunLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));
                Coa coaTahunBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(rdc.getCoaId());
                    } catch (Exception e) {
                    }

                    //jika bukan laba
                    if (coa.getOID() != coaTahunLalu.getOID() && coa.getOID() != coaTahunBerjalan.getOID()) {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId());
                            result = result - getAmountInPeriod(per.getOID(), rdc.getCoaId());
                        } else {
                            result = result + DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId());
                            result = result + getAmountInPeriod(per.getOID(), rdc.getCoaId());
                        }
                    } //laba tahun lalu
                    else if (coa.getOID() == coaTahunLalu.getOID()) {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), per);
                        } else {
                            result = result + DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), per);
                        }
                    } //laba berjalan
                    else {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), per);
                        } else {
                            result = result + DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), per);
                        }
                    }

                }
            }
        }

        return result;

    }

    public static double getProfitLossRealisasiLastYear(long rptDetailId, Periode period, String whereMd) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                    if (rdc.getIsMinus() == 0) {
                        result = result + getAmountInPeriodYTD(per.getOID(), rdc, whereMd);
                    } else {
                        result = result - getAmountInPeriodYTD(per.getOID(), rdc, whereMd);
                    }
                }
            }
        }

        return result;

    }

    //profit loss YTD last year
    public static double getProfitLossRealisasiLastYear(long rptDetailId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                    if (rdc.getIsMinus() == 0) {
                        result = result + getAmountInPeriodYTD(per.getOID(), rdc);
                    } else {
                        result = result - getAmountInPeriodYTD(per.getOID(), rdc);
                    }
                }
            }
        }

        return result;

    }

    public static double getProfitLossRealisasiLastYearPeriod(long rptDetailId, Periode period, String whereSg) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                    if (rdc.getIsMinus() == 0) {
                        result = result + getAmountInPeriodMTD(per.getOID(), rdc, whereSg);
                    } else {
                        result = result - getAmountInPeriodMTD(per.getOID(), rdc, whereSg);
                    }
                }
            }
        }

        return result;

    }

    //profit loss MTD last year
    public static double getProfitLossRealisasiLastYearPeriod(long rptDetailId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode per = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            per = DbPeriode.getLastYearPeriod13(period);
        }

        if (per.getOID() != 0) {

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                    
                    if(rdc.getDepId() == 0){
                        double opening = 0;//DbCoaOpeningBalance.getOpeningBalance(per, rdc.getCoaId());
                        if (rdc.getIsMinus() == 1) {                        
                            result = result - getAmountInPeriodMTD(per.getOID(), rdc) + opening;
                        } else {                        
                            result = result + getAmountInPeriodMTD(per.getOID(), rdc) + opening;
                        }
                    }else{
                        Coa coa = new Coa();
                        try{
                            coa = DbCoa.fetchExc(rdc.getCoaId());
                        }catch(Exception e){}
                        double opening = 0;//getCoaOpeningBalance(per.getStartDate(), coa, rdc.getDepId());
                        if (rdc.getIsMinus() == 1) {                        
                            result = result - getAmountInPeriodMTD(per.getOID(), rdc) + opening;
                        } else {                        
                            result = result + getAmountInPeriodMTD(per.getOID(), rdc) + opening;
                        }
                    }
                    
                    /*if (rdc.getIsMinus() == 0) {
                        result = result + getAmountInPeriodMTD(per.getOID(), rdc);
                    } else {
                        result = result - getAmountInPeriodMTD(per.getOID(), rdc);
                    }*/
                }
            }
        }

        return result;

    }

    //pakai yang statusnya sudah posted saja
    public static double getAmountInPeriod(long periodId, long coaId, String whereSeg) {

        double result = 0;

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }
    
    
    public static double getAmountInPeriod(long periodId, long coaId, int level, String accountGroup) {

        double result = 0;

        //debet credit position
        boolean isDebet = false;
        if (accountGroup.equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                accountGroup.equals(I_Project.ACC_GROUP_EXPENSE) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
        

        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }
    
    public static double getAmountInPeriod(long periodId, long coaId, int level, String accountGroup,long segment1ID) {

        double result = 0;

        //debet credit position
        boolean isDebet = false;
        if (accountGroup.equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                accountGroup.equals(I_Project.ACC_GROUP_EXPENSE) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
        
        if(segment1ID != 0){
            sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+segment1ID;
        }

        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    //pakai yang statusnya sudah posted saja
    public static double getAmountInPeriod(long periodId, long coaId) {

        double result = 0;

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }
        
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static double getAmountInPeriodByLocation(long periodId, long coaId, long segment1Id){
        
        if(periodId == 0 || coaId == 0 || segment1Id == 0){
            return 0;
        }

        double result = 0;

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {}

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
            isDebet = true;        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        if (segment1Id != 0) {
            sql = sql + " and gd." + colNames[COL_SEGMENT1_ID] + "=" + segment1Id;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    //pakai yang statusnya sudah posted saja
    //untuk p&l tidak memakai metode opening, karena tidak ada opening per department
    public static double getAmountInPeriodYTD(long periodId, RptFormatDetailCoa rfd, String whereSeg) {

        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date dt = per.getEndDate();
        Date startDate = (Date) dt.clone();
        startDate.setDate(1);
        startDate.setMonth(0);

        String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' " +
                " and '" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "'";

        Vector periods = DbPeriode.list(0, 0, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " + whereSeg + " AND " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        //jika ada periodenya pakai periode
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }

        if (periods != null && periods.size() > 0) {
            sql = sql + " and (";
            for (int i = 0; i < periods.size(); i++) {
                Periode px = (Periode) periods.get(i);
                sql = sql + "g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + px.getOID() + " or ";
            }

            sql = sql.substring(0, sql.length() - 3) + ")";

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;

    }

    //pakai yang statusnya sudah posted saja
    //untuk p&l tidak memakai metode opening, karena tidak ada opening per department
    public static double getAmountInPeriodYTD(long periodId, RptFormatDetailCoa rfd) {
        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date dt = per.getEndDate();
        Date startDate = (Date) dt.clone();
        startDate.setDate(1);
        startDate.setMonth(0);

        String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' " +
                " and '" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "'";
        
        Vector periods = DbPeriode.list(0, 0, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        //jika ada periodenya pakai periode
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }


        if (periods != null && periods.size() > 0) {
            sql = sql + " and (";
            for (int i = 0; i < periods.size(); i++) {
                Periode px = (Periode) periods.get(i);
                sql = sql + "g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + px.getOID() + " or ";
            }

            sql = sql.substring(0, sql.length() - 3) + ")";

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {

            } finally {
                CONResultSet.close(crs);
            }
        }        

        return result;
    }

    public static double getAmountInPeriodYTDII(long periodId, RptFormatDetailCoa rfd) {
        Vector periodx = DbPeriode.list(0, 1, "", DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        Periode firstPeriode = new Periode();
        try {
            if (periodx != null && periodx.size() > 0) {
                firstPeriode = (Periode) periodx.get(0);
            }
        } catch (Exception e) {
        }

        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date startDate = new Date();
        startDate = firstPeriode.getStartDate();
        Date dt = per.getEndDate();

        String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' " +
                " and '" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "'";

        Vector periods = DbPeriode.list(0, 0, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        //jika ada periodenya pakai periode
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }

        if (periods != null && periods.size() > 0) {
            sql = sql + " and (";
            for (int i = 0; i < periods.size(); i++) {
                Periode px = (Periode) periods.get(i);
                sql = sql + "g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + px.getOID() + " or ";
            }

            sql = sql.substring(0, sql.length() - 3) + ")";

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {

            } finally {
                CONResultSet.close(crs);
            }

        }

        return result;

    }
    
    public static double getAmountAllPeriod(long periodId, RptFormatDetailCoa rfd) {

        Vector periodx = DbPeriode.list(0, 1, "", DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        Periode firstPeriode = new Periode();
        try {
            if (periodx != null && periodx.size() > 0) {
                firstPeriode = (Periode) periodx.get(0);
            }
        } catch (Exception e) {
        }

        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date startDate = new Date();
        startDate = firstPeriode.getStartDate();
        Date dt = per.getEndDate();
        
        Date endDt = (Date)dt.clone();
        endDt.setMonth(endDt.getMonth() -1);

        String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' " +
                " and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";

        Vector periods = DbPeriode.list(0, 0, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        //jika ada periodenya pakai periode
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }

        if (periods != null && periods.size() > 0) {
            sql = sql + " and (";
            for (int i = 0; i < periods.size(); i++) {
                Periode px = (Periode) periods.get(i);
                sql = sql + "g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + px.getOID() + " or ";
            }

            sql = sql.substring(0, sql.length() - 3) + ")";

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {

            } finally {
                CONResultSet.close(crs);
            }

        }

        return result;

    }

    //pakai yang statusnya sudah posted saja - MTD
    //untuk p&l tidak memakai metode opening, karena tidak ada opening per department
    public static double getAmountInPeriodMTD(long periodId, RptFormatDetailCoa rfd, String whereSg) {
        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        int levelDep = 0;
        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
            levelDep = dep.getLevel();
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date dt = per.getEndDate();
        Date startDate = (Date) dt.clone();
        startDate.setDate(1);
        startDate.setMonth(0);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " + whereSg + " and " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }


        //jika ada department lakukan dengan department
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;

            }
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        //}

        return result;

    }

    //pakai yang statusnya sudah posted saja - MTD
    //untuk p&l tidak memakai metode opening, karena tidak ada opening per department
    public static double getAmountInPeriodMTD(long periodId, RptFormatDetailCoa rfd) {
        double result = 0;
        long coaId = rfd.getCoaId();

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        Department dep = new Department();
        try {
            dep = DbDepartment.fetchExc(rfd.getDepId());
        } catch (Exception e) {
        }

        Periode per = new Periode();
        try {
            per = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }

        Date dt = per.getEndDate();
        Date startDate = (Date) dt.clone();
        startDate.setDate(1);
        startDate.setMonth(0);

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;
        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " where " +
                " g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        switch (level) {
            case 1:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        //jika ada department lakukan dengan department
        if (rfd.getDepId() != 0) {

            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;

            }
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getClosingBalance(long coaId, Periode period) {
        double result = DbCoaOpeningBalance.getOpeningBalance(period, coaId);
        result = result + getAmountInPeriod(period.getOID(), coaId);
        return result;
    }
    
    public static double getClosingBalance(long coaId, Periode period,long segment1Id) {
        double result = DbCoaOpeningBalanceLocation.getOpeningBalance(period, coaId,segment1Id);
        result = result + getAmountInPeriodByLocation(period.getOID(), coaId, segment1Id);
        return result;
    }

    public static double getRealisasiCurrentYear(long rptDetailId, Periode period, String whereSeg) {

        double result = 0;

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {

            Coa coaTahunLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));
            Coa coaTahunBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(rdc.getCoaId());
                } catch (Exception e) {
                }

                //jika bukan laba
                if (coa.getOID() != coaTahunLalu.getOID() && coa.getOID() != coaTahunBerjalan.getOID()) {
                    //jika bukan P&L
                    if (rdc.getDepId() == 0) {
                        if (rdc.getIsMinus() == 1) {
                            //result = result - DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                            result = result - getOpeningBalance(period, rdc.getCoaId(), whereSeg);
                            result = result - getAmountInPeriod(period.getOID(), rdc.getCoaId(), whereSeg);
                        } else {
                            //result = result + DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                            result = result + getOpeningBalance(period, rdc.getCoaId(), whereSeg);
                            result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId(), whereSeg);
                        }
                    } //jika P&L, jangan pakai metode opening,
                    //hitung saja manual karena tidak ada opening dengan department id
                    else {
                        if (rdc.getIsMinus() == 1) {
                            result = result - getAmountInPeriodYTD(period.getOID(), rdc, whereSeg);
                        } else {
                            result = result + getAmountInPeriodYTD(period.getOID(), rdc, whereSeg);
                        }
                    }

                } //laba tahun lalu
                else if (coa.getOID() == coaTahunLalu.getOID()) {
                    if (rdc.getIsMinus() == 1) {
                        result = result - DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), period, whereSeg);
                    } else {
                        result = result + DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), period, whereSeg);
                    }
                } //laba berjalan
                else {
                    if (rdc.getIsMinus() == 1) {
                        result = result - DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), period, whereSeg);
                    } else {
                        result = result + DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), period, whereSeg);
                    }
                }

            }
        }

        return result;

    }

    //ini untuk balance sheet
    public static double getRealisasiCurrentYear(long rptDetailId, Periode period) {

        double result = 0;

        //if(per.getOID()!=0){        	
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {

            Coa coaTahunLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));
            Coa coaTahunBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(rdc.getCoaId());
                } catch (Exception e) {
                }

                //jika bukan laba
                if (coa.getOID() != coaTahunLalu.getOID() && coa.getOID() != coaTahunBerjalan.getOID()) {
                    //jika bukan P&L
                    if (rdc.getDepId() == 0) {
                        if (rdc.getIsMinus() == 1) {
                            result = result - DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                            result = result - getAmountInPeriod(period.getOID(), rdc.getCoaId());
                        } else {
                            result = result + DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                            result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId());
                        }
                    } //jika P&L, jangan pakai metode opening,
                    //hitung saja manual karena tidak ada opening dengan department id
                    else {
                        if (rdc.getIsMinus() == 1) {
                            result = result - getAmountInPeriodYTD(period.getOID(), rdc);
                        } else {
                            result = result + getAmountInPeriodYTD(period.getOID(), rdc);
                        }
                    }

                } //laba tahun lalu
                else if (coa.getOID() == coaTahunLalu.getOID()) {
                    if (rdc.getIsMinus() == 1) {
                        result = result - DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), period);
                    } else {
                        result = result + DbGlDetail.getLastYearEarningCurrentYearByCoa(coa.getOID(), period);
                    }
                } //laba berjalan
                else {
                    if (rdc.getIsMinus() == 1) {
                        result = result - DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), period);
                    } else {
                        result = result + DbGlDetail.getCurrentYearEarningCurrentYearByCoa(coa.getOID(), period);
                    }
                }

            }
        }

        return result;

    }

    public static double getProfitLossRealisasiCurrentYear(long rptDetailId, Periode period, String whereMd) {

        double result = 0;

        //if(per.getOID()!=0){        	
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {


            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                if (rdc.getIsMinus() == 1) {
                    result = result - getAmountInPeriodYTD(period.getOID(), rdc, whereMd);
                } else {
                    result = result + getAmountInPeriodYTD(period.getOID(), rdc, whereMd);
                }


            }
        }

        return result;

    }

    //ini untuk P&L YTD
    public static double getProfitLossRealisasiCurrentYear(long rptDetailId, Periode period){

        double result = 0;
           	
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {

            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                if (rdc.getIsMinus() == 1) {
                    //if (rdc.getDepId() == 0) {
                        result = result - getAmountInPeriodYTD(period.getOID(), rdc);
                    //} else {
                    //    result = result - getAmountInPeriodYTDII(period.getOID(), rdc);
                    //}
                } else {
                    //if (rdc.getDepId() == 0) {
                        result = result + getAmountInPeriodYTD(period.getOID(), rdc);
                    //} else {
                    //    result = result + getAmountInPeriodYTDII(period.getOID(), rdc);
                    //}
                }
            }
        }

        return result;

    }

    //ini = dengan MTD
    public static double getProfitLossRealisasiCurrentPeriod(long rptDetailId, Periode period, String whereMd) {

        double result = 0;

        //if(per.getOID()!=0){        	
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {

            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);

                if (rdc.getIsMinus() == 1) {
                    result = result - getAmountInPeriodMTD(period.getOID(), rdc, whereMd);
                } else {
                    result = result + getAmountInPeriodMTD(period.getOID(), rdc, whereMd);
                }
            }

        }

        return result;

    }

    //ini = dengan MTD
    public static double getProfitLossRealisasiCurrentPeriod(long rptDetailId, Periode period) {

        double result = 0;

        //if(per.getOID()!=0){        	
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {

            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                
                if(rdc.getDepId() == 0){
                    double opening = 0;//DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                    if (rdc.getIsMinus() == 1) {                        
                        result = result - getAmountInPeriodMTD(period.getOID(), rdc) + opening;
                    } else {                        
                        result = result + getAmountInPeriodMTD(period.getOID(), rdc) + opening;
                    }
                }else{
                    Coa coa = new Coa();
                    try{
                        coa = DbCoa.fetchExc(rdc.getCoaId());
                    }catch(Exception e){}
                    double opening = 0;//getCoaOpeningBalance(period.getStartDate(), coa, rdc.getDepId());
                    if (rdc.getIsMinus() == 1) {                        
                        result = result - getAmountInPeriodMTD(period.getOID(), rdc) + opening;
                    } else {                        
                        result = result + getAmountInPeriodMTD(period.getOID(), rdc) + opening;
                    }
                }
                
            }
        }
        return result;
    }

    public static double getClosingCurrentEarning(long coaId, Periode period) {

        double result = DbCoaOpeningBalance.getOpeningBalance(period, coaId);
        result = result + getTotalIncomeInPeriod(period.getOID()) - getTotalExpenseInPeriod(period.getOID());

        return result;
    }
    
    public static double getClosingCurrentEarning(long coaId, Periode period, long segment1Id) {
        double result = DbCoaOpeningBalanceLocation.getOpeningBalance(period, coaId,segment1Id);        
        result = result + getTotalIncomeInPeriod(period.getOID(),segment1Id) - getTotalExpenseInPeriod(period.getOID(),segment1Id);
        return result;
    }

    //laba tahun berjalan
    public static double getCurrentYearEarningCurrentYear(long rptDetailId, Periode period) {

        double result = 0;

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                result = result + DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
            }
        }

        return result + getTotalIncomeInPeriod(period.getOID()) - getTotalExpenseInPeriod(period.getOID());

    }

    //by coa
    public static double getCurrentYearEarningCurrentYearByCoa(long coaId, Periode period, String whereSd) {

        double result = 0;
        result = result + getOpeningBalance(period, coaId, whereSd);
        return result + getTotalIncomeInPeriod(period.getOID(), whereSd) - getTotalExpenseInPeriod(period.getOID(), whereSd);

    }

    //by coa
    public static double getCurrentYearEarningCurrentYearByCoa(long coaId, Periode period) {

        double result = 0;

        result = result + DbCoaOpeningBalance.getOpeningBalance(period, coaId);

        return result + getTotalIncomeInPeriod(period.getOID()) - getTotalExpenseInPeriod(period.getOID());

    }

    //laba tahun lalu
    public static double getLastYearEarningCurrentYear(long rptDetailId, Periode period) {

        double result = 0;

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                result = result + DbCoaOpeningBalance.getOpeningBalance(period, rdc.getCoaId());
                result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId());
            }
        }

        return result;

    }

    public static double getLastYearEarningCurrentYearByCoa(long coaId, Periode period, String whereSeg) {

        double result = 0;
        result = result + getOpeningBalance(period, coaId, whereSeg);
        result = result + getAmountInPeriod(period.getOID(), coaId, whereSeg);

        return result;

    }

    //by coa
    public static double getLastYearEarningCurrentYearByCoa(long coaId, Periode period) {

        double result = 0;

        result = result + DbCoaOpeningBalance.getOpeningBalance(period, coaId);
        result = result + getAmountInPeriod(period.getOID(), coaId);

        return result;

    }

    //laba tahun berjalan tahun lalu, by rpt detail
    public static double getCurrentYearEarningLastYear(long rptDetailId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode lastYeartPeriod = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            lastYeartPeriod = DbPeriode.getLastYearPeriod13(period);
        }


        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                result = result + DbCoaOpeningBalance.getOpeningBalance(lastYeartPeriod, rdc.getCoaId());
            }
        }

        return result + getTotalIncomeInPeriod(lastYeartPeriod.getOID()) - getTotalExpenseInPeriod(lastYeartPeriod.getOID());

    }

    //laba tahun berjalan tahun lalu, by coa
    public static double getCurrentYearEarningLastYearByCoa(long coaId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode lastYeartPeriod = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            lastYeartPeriod = DbPeriode.getLastYearPeriod13(period);
        }

        result = result + DbCoaOpeningBalance.getOpeningBalance(lastYeartPeriod, coaId);
        return result + getTotalIncomeInPeriod(lastYeartPeriod.getOID()) - getTotalExpenseInPeriod(lastYeartPeriod.getOID());

    }

    //laba tahun lalu
    public static double getLastYearEarningLastYear(long rptDetailId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode lastYeartPeriod = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            lastYeartPeriod = DbPeriode.getLastYearPeriod13(period);
        }

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                result = result + DbCoaOpeningBalance.getOpeningBalance(lastYeartPeriod, rdc.getCoaId());
                result = result + getAmountInPeriod(lastYeartPeriod.getOID(), rdc.getCoaId());
            }
        }

        return result;

    }

    //laba tahun lalu by coa
    public static double getLastYearEarningLastYearByCoa(long coaId, Periode period) {

        double result = 0;

        Date dt = period.getStartDate();
        Date startDate = (Date) dt.clone();
        startDate.setYear(startDate.getYear() - 1);
        startDate.setDate(startDate.getDate() + 10);

        Periode lastYeartPeriod = DbPeriode.getPeriodByTransDate(startDate);

        //if periode 13 then get prev period 13
        if (period.getType() == DbPeriode.TYPE_PERIOD13) {
            lastYeartPeriod = DbPeriode.getLastYearPeriod13(period);
        }

        result = result + DbCoaOpeningBalance.getOpeningBalance(lastYeartPeriod, coaId);
        result = result + getAmountInPeriod(lastYeartPeriod.getOID(), coaId);

        return result;

    }

    public static double getTotalIncomeInPeriodLabaThnBerjalan(long periodId, String whereSeg) {

        if (periodId == 0) {
            return 0;
        }
        double result = 0;

        String sql = "select sum(gd." + colNames[COL_CREDIT] + ")-sum(gd." + colNames[COL_DEBET] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_REVENUE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_REVENUE + "') " +
                "and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                "and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static double getTotalIncomeInPeriod(long periodId, String whereSeg) {

        if (periodId == 0) {
            return 0;
        }

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_CREDIT] + ")-sum(gd." + colNames[COL_DEBET] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_REVENUE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_REVENUE + "') " +
                "and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                "and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    //posted only
    public static double getTotalIncomeInPeriod(long periodId) {

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_CREDIT] + ")-sum(gd." + colNames[COL_DEBET] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_REVENUE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_REVENUE + "') " +
                "and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                "and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }
    
    public static double getTotalIncomeInPeriod(long periodId,long segment1Id) {

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_CREDIT] + ")-sum(gd." + colNames[COL_DEBET] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_REVENUE + "' " +
                " or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_REVENUE + "') " +
                " and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                " and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
        
        if(segment1Id != 0){
            sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+segment1Id;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static double getTotalExpenseInPeriod(long periodId, String whereSeg) {

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_DEBET] + ")-sum(gd." + colNames[COL_CREDIT] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_EXPENSE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "') " +
                "and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                "and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    //posted only
    public static double getTotalExpenseInPeriod(long periodId) {

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_DEBET] + ")-sum(gd." + colNames[COL_CREDIT] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_EXPENSE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "') " +
                "and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                "and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }
    
    public static double getTotalExpenseInPeriod(long periodId,long segment1Id) {

        double result = 0;

        String sql = "select sum(gd." + colNames[COL_DEBET] + ")-sum(gd." + colNames[COL_CREDIT] + ") " +
                "from " + DB_GL_DETAIL + " gd " +
                "inner join " + DbCoa.DB_COA + " c on c." + DbCoa.colNames[DbCoa.COL_COA_ID] +
                "=gd." + colNames[COL_COA_ID] + " " +
                "inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] +
                "=gd." + colNames[COL_GL_ID] + " " +
                "where " +
                "(c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_EXPENSE + "' " +
                "or c." + DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "') " +
                " and g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId + " " +
                " and g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;
        
        
        if(segment1Id != 0){
            sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+segment1Id;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static Vector getDebCredit(long glId) {

        CONResultSet crs = null;
        Vector result = new Vector();
        try {

            String sql = "SELECT SUM(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "),SUM(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ") " + " FROM " + DbGlDetail.DB_GL_DETAIL + " WHERE " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {

                double debet = 0;
                double credit = 0;

                try {
                    debet = rs.getDouble(1);
                    credit = rs.getDouble(2);
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }

                result.add(new Double(debet));
                result.add(new Double(credit));

                return result;
            }

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static void deleteAllDetail(long glId) {

        if (glId != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DbGlDetail.DB_GL_DETAIL + " WHERE " +
                        DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }

    public static void deleteAllDetail(long glId, Vector listGlDetail) {

        if (glId != 0) {
            String where = "";

            if (listGlDetail != null && listGlDetail.size() > 0) {
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail glDetail = (GlDetail) listGlDetail.get(i);
                    where = where + DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID] + " != " + glDetail.getOID();
                }
            }

            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DbGlDetail.DB_GL_DETAIL + " WHERE " +
                        DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId;

                if (where.length() > 0) {
                    sql = sql + " and " + where;
                }

                CONHandler.execUpdate(sql);

            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }

    public static double getOpeningBalance(Periode openPeriod, long coaId, String whereSeg) {

        double result = 0;
        if (openPeriod.getOID() == 0) {
            return 0;
        }
        int level = 0;
        Coa coa = new Coa();

        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;
        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                " where " +
                " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + openPeriod.getStartDate() + "' AND " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static double getAccRecursif(Periode openPeriod, long coaId, String whereSeg) {

        double result = 0;
        if (openPeriod.getOID() == 0) {
            return 0;
        }

        Date startDate = openPeriod.getStartDate();
        int year = startDate.getYear() + 1900;
        Date strDt = new Date();

        if (startDate.getMonth() == 0) {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(year - 1);
        } else {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(startDate.getYear());
        }

        int level = 0;
        Coa coa = new Coa();

        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {

            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), DbCoa.colNames[DbCoa.COL_CODE]);
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccRecursif(openPeriod, coax.getOID(), whereSeg);
                    } else {
                        //debet credit position
                        boolean isDebet = false;
                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                            isDebet = true;
                        }

                        String sql = "";

                        if (isDebet) {
                            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
                        } else {
                            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
                        }

                        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                                " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                                " where " +
                                " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " >= '" + JSPFormater.formatDate(strDt, "yyyy-MM-dd") + "' and " +
                                " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "' AND " +
                                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

                        if (whereSeg.length() > 0) {
                            sql = sql + " and " + whereSeg;
                        }

                        switch (level) {
                            case 1:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                                break;
                            case 2:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                                break;
                            case 3:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                                break;
                            case 4:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                                break;
                            case 5:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                                break;
                            case 6:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                                break;
                            case 7:
                                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                                break;
                            }

                        CONResultSet crs = null;
                        try {
                            crs = CONHandler.execQueryResult(sql);
                            ResultSet rs = crs.getResultSet();
                            while (rs.next()) {
                                result = rs.getDouble(1);
                            }
                        } catch (Exception e) {
                            System.out.println("[Exception] " + e.toString());
                        } finally {
                            CONResultSet.close(crs);
                        }
                    }
                }
            }

        } else {

            //debet credit position
            boolean isDebet = false;
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                isDebet = true;
            }

            String sql = "";

            if (isDebet) {
                sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
            } else {
                sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
            }

            sql = sql + " from " + DB_GL_DETAIL + " gd " +
                    " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                    " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " where " +
                    " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " >= '" + JSPFormater.formatDate(strDt, "yyyy-MM-dd") + "' and " +
                    " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "' AND " +
                    " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

            if (whereSeg.length() > 0) {
                sql = sql + " and " + whereSeg;
            }

            switch (level) {
                case 1:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                    break;
                case 2:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                    break;
                case 3:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                    break;
                case 4:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                    break;
                case 5:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                    break;
                case 6:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                    break;
                case 7:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                    break;
            }

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println("[Exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }

        }

        return result;

    }

    public static double getOpBalancePrevious(Periode openPeriod, long coaId, String whereSeg) {

        double result = 0;
        if (openPeriod.getOID() == 0) {
            return 0;
        }

        Date startDate = openPeriod.getStartDate();
        int year = startDate.getYear() + 1900;
        Date strDt = new Date();

        if (startDate.getMonth() == 0) {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(year - 1);
        } else {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(startDate.getYear());
        }

        int level = 0;
        Coa coa = new Coa();

        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            result = result + getAccRecursif(openPeriod, coa.getOID(), whereSeg);
        } else {

            //debet credit position
            boolean isDebet = false;
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                isDebet = true;
            }

            String sql = "";

            if (isDebet) {
                sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
            } else {
                sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
            }

            sql = sql + " from " + DB_GL_DETAIL + " gd " +
                    " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                    " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " where " +
                    " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " >= '" + JSPFormater.formatDate(strDt, "yyyy-MM-dd") + "' and " +
                    " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "' AND " +
                    " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

            if (whereSeg.length() > 0) {
                sql = sql + " and " + whereSeg;
            }

            switch (level) {
                case 1:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                    break;
                case 2:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                    break;
                case 3:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                    break;
                case 4:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                    break;
                case 5:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                    break;
                case 6:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                    break;
                case 7:
                    sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                    break;
            }

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {

            } finally {
                CONResultSet.close(crs);
            }
        }
        return result;
    }

    public static double getOpeningBalancePrevious(Periode openPeriod, long coaId, String whereSeg){

        double result = 0;
        if (openPeriod.getOID() == 0) {
            return 0;
        }

        Date startDate = openPeriod.getStartDate();
        int year = startDate.getYear() + 1900;
        Date strDt = new Date();

        if (startDate.getMonth() == 0) {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(year - 1);
        } else {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(startDate.getYear());
        }

        int level = 0;
        Coa coa = new Coa();

        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
        }

        //debet credit position
        boolean isDebet = false;
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;
        }

        String sql = "";

        if (isDebet) {
            sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
        } else {
            sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
        }

        sql = sql + " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                " where " +
                " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " >= '" + JSPFormater.formatDate(strDt, "yyyy-MM-dd") + "' and " +
                " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "' AND " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (whereSeg.length() > 0) {
            sql = sql + " and " + whereSeg;
        }

        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coaId;
                break;
        }

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static double getSumOpeningBalance(String whereSg) {
        Periode openPeriod = new Periode();
        Vector listCoa = DbCoa.list(0, 0, "", "code");

        try {
            openPeriod = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        }

        double result = 0;

        if (openPeriod.getOID() == 0) {
            return 0;
        }

        Date startDate = openPeriod.getStartDate();
        int year = startDate.getYear() + 1900;
        Date strDt = new Date();

        if (startDate.getMonth() == 0) {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(year - 1);
        } else {
            strDt.setDate(1);
            strDt.setMonth(0);
            strDt.setYear(startDate.getYear());
        }

        if (listCoa != null && listCoa.size() > 0) {

            for (int i = 0; i < listCoa.size(); i++) {

                Coa coa = (Coa) listCoa.get(i);

                //debet credit position
                boolean isDebet = false;

                if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                    isDebet = true;
                }

                String sql = "";

                if (isDebet) {
                    sql = "select sum(" + colNames[COL_DEBET] + ")-sum(" + colNames[COL_CREDIT] + ")";
                } else {
                    sql = "select sum(" + colNames[COL_CREDIT] + ")-sum(" + colNames[COL_DEBET] + ")";
                }

                sql = sql + " from " + DB_GL_DETAIL + " gd " +
                        " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + "=gd." + colNames[COL_GL_ID] +
                        " inner join " + DbPeriode.DB_PERIODE + " p on g." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                        " where " +
                        " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " >= '" + JSPFormater.formatDate(strDt, "yyyy-MM-dd") + "' and " +
                        " p." + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " < '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "' AND " +
                        " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

                if (whereSg.length() > 0) {
                    sql = sql + " and " + whereSg;
                }

                CONResultSet crs = null;
                try {

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    double tmpResult = 0;

                    while (rs.next()) {
                        tmpResult = rs.getDouble(1);
                    }

                    result = result + tmpResult;

                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                } finally {
                    CONResultSet.close(crs);
                }
            }
        }
        return result;
    }

    /**
     * Untuk di buku besar, menampilkan biaya/pendapatan per departemen
     * by gwawan aug 2012
     * @param selectedDate
     * @param coa
     * @param depId
     * @return
     */
    public static double getGLOpeningBalance(Date selectedDate, Coa coa, long depId) {

        Calendar calendar1 = new GregorianCalendar(1900 + selectedDate.getYear(), selectedDate.getMonth(), selectedDate.getDate());
        calendar1.add(Calendar.DAY_OF_MONTH, -1);
        Date endDate = calendar1.getTime(); //end date is one day before selected date

        String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where gd." + colNames[COL_COA_ID] + " = " + coa.getOID() +
                " and g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + (selectedDate.getYear() + 1900) + "-01-01 00:00:00" + "'" +
                " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd 23:59:59") + "'";

        if (depId != 0) {
            sql += " AND ";//gd." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            
            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(depId);
            } catch(Exception e) {}
            
            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }

        double debet = 0;
        double credit = 0;
        double openingBalance = 0;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                debet = rs.getDouble(1);
                credit = rs.getDouble(2);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) { //debet position
            openingBalance = debet - credit;
        } else {
            openingBalance = credit - debet;
        }

        return openingBalance;
    }
    
    public static double getCoaOpeningBalance(Date selectedDate, Coa coa, long depId) {

        Calendar calendar1 = new GregorianCalendar(1900 + selectedDate.getYear(), selectedDate.getMonth(), selectedDate.getDate());
        calendar1.add(Calendar.DAY_OF_MONTH, -1);
        Date endDate = calendar1.getTime(); //end date is one day before selected date

        String sql = "select sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "), " +
                " sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                " from " + DB_GL_DETAIL + " gd " +
                " inner join " + DbGl.DB_GL + " g on g." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + colNames[COL_GL_ID] +
                " where g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + (selectedDate.getYear() + 1900) + "-01-01 00:00:00" + "'" +
                " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd 23:59:59") + "'";

        int level = coa.getLevel();
        
        switch (level) {
            case 1:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL1_ID] + "=" + coa.getOID();
                break;
            case 2:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL2_ID] + "=" + coa.getOID();
                break;
            case 3:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL3_ID] + "=" + coa.getOID();
                break;
            case 4:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL4_ID] + "=" + coa.getOID();
                break;
            case 5:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL5_ID] + "=" + coa.getOID();
                break;
            case 6:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL6_ID] + "=" + coa.getOID();
                break;
            case 7:
                sql = sql + " and  gd." + colNames[COL_COA_LEVEL7_ID] + "=" + coa.getOID();
                break;
        }
        
        
        if (depId != 0) {

            Department dep = new Department();
            try{
                dep = DbDepartment.fetchExc(depId);
            }catch(Exception e){}
            
            sql = sql + " and ";

            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + depId;
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + depId;
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + depId;
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + depId;
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + depId;
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + depId;
                    break;
            }
        }

        double debet = 0;
        double credit = 0;
        double openingBalance = 0;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                debet = rs.getDouble(1);
                credit = rs.getDouble(2);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        
        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) { //debet position
            openingBalance = debet - credit;
        } else {
            openingBalance = credit - debet;
        }

        return openingBalance;
    }

    /**
     * Untuk di buku besar, menampilkan biaya/pendapatan per departemen
     * by gwawan aug 2012
     * @param startDate
     * @param endDate
     * @param oidCoa
     * @param depId
     * @return
     */
    public static Vector getGeneralLedger(Date startDate, Date endDate, long oidCoa, long depId) {

        String sql = " select g.*, gd.* from " + DbGl.DB_GL + " g " +
                " inner join " + DbGlDetail.DB_GL_DETAIL + " gd on " +
                " gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=g." + DbGl.colNames[DbGl.COL_GL_ID] +
                " where (to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")>=to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")<=to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')) and " +
                " coa_id = " + oidCoa + " and " +
                " g." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + "=" + DbGl.POSTED;

        if (depId != 0) {
            sql += " AND ";//gd." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            
            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(depId);
            } catch(Exception e) {}
            
            switch (dep.getLevel()) {
                case 0:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL0_ID] + "=" + dep.getOID();
                    break;
                case 1:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL1_ID] + "=" + dep.getOID();
                    break;
                case 2:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL2_ID] + "=" + dep.getOID();
                    break;
                case 3:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL3_ID] + "=" + dep.getOID();
                    break;
                case 4:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL4_ID] + "=" + dep.getOID();
                    break;
                case 5:
                    sql = sql + " gd." + colNames[COL_DEP_LEVEL5_ID] + "=" + dep.getOID();
                    break;
            }
        }

        sql = sql + " order by g." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ", g." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                DbGlDetail.resultToObject(rs, gd);
                Gl gl = new Gl();
                DbGl.resultToObject(rs, gl);

                Vector temp = new Vector();
                temp.add(gl);
                temp.add(gd);
                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    /**
     * Fetch GL list and incapsulation into CashRegister object
     * by gwawan 201209
     * @param userId
     * @param coaId
     * @param date
     * @return
     */
    public static Vector getCashRegister(long userId, long coaId, Date date) {
        Vector result = new Vector();
        CONResultSet crs = null;

        try {
            String sql = " SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] +
                    ", gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] +
                    ", gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] +
                    ", gl." + DbGl.colNames[DbGl.COL_MEMO] +
                    ", gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] +
                    " FROM " + DbGl.DB_GL + " gl " + " INNER JOIN " + DbGlDetail.DB_GL_DETAIL + " gd " +
                    " ON " + " gl." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                    " WHERE (TO_DAYS(gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")" +
                    " = TO_DAYS('" + JSPFormater.formatDate(date, "yyyy-MM-dd") + "'))" +
                    " AND gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + " = " + coaId +
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                long glId = rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]);
                
                String name = "";
                try {
                    name = SessReport.getPemberiOrPenerima(glId);
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
                
                CashRegister cashRegister = new CashRegister();                
                cashRegister.setOID(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]));
                cashRegister.setUserId(userId);
                cashRegister.setDocNumber(rs.getString(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]));
                cashRegister.setTransDate(rs.getDate(DbGl.colNames[DbGl.COL_TRANS_DATE]));
                cashRegister.setCheckBGNumber("");
                cashRegister.setName(name);
                cashRegister.setDescription(rs.getString(DbGl.colNames[DbGl.COL_MEMO]));
                cashRegister.setDebet(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_DEBET]));
                cashRegister.setCredit(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_CREDIT]));
                cashRegister.setStatus(rs.getInt(DbGl.colNames[DbGl.COL_POSTED_STATUS]));
                
                result.add(cashRegister);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    /**
     * Fetch GL list and incapsulation into BankRegister object
     * by gwawan 201212
     * @param userId
     * @param coaId
     * @param date
     * @return
     */
    public static Vector getBankRegister(long userId, long coaId, Date date) {
        Vector result = new Vector();
        CONResultSet crs = null;

        try {
            String sql = " SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] +
                    ", gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] +
                    ", gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] +
                    ", gl." + DbGl.colNames[DbGl.COL_MEMO] +
                    ", gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] +
                    ", gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] +
                    " FROM " + DbGl.DB_GL + " gl " + " INNER JOIN " + DbGlDetail.DB_GL_DETAIL + " gd " +
                    " ON " + " gl." + DbGl.colNames[DbGl.COL_GL_ID] + " = gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                    " WHERE (TO_DAYS(gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")" +
                    " = TO_DAYS('" + JSPFormater.formatDate(date, "yyyy-MM-dd") + "'))" +
                    " AND gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + " = " + coaId +
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                long glId = rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]);
                
                String name = "";
                try {
                    name = SessReport.getPemberiOrPenerima(glId);
                } catch (Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
                
                BankRegister bankRegister = new BankRegister();                
                bankRegister.setOID(rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]));
                bankRegister.setUserId(userId);
                bankRegister.setDocNumber(rs.getString(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]));
                bankRegister.setTransDate(rs.getDate(DbGl.colNames[DbGl.COL_TRANS_DATE]));
                bankRegister.setCheckBGNumber("");
                bankRegister.setName(name);
                bankRegister.setDescription(rs.getString(DbGl.colNames[DbGl.COL_MEMO]));
                bankRegister.setDebet(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_DEBET]));
                bankRegister.setCredit(rs.getDouble(DbGlDetail.colNames[DbGlDetail.COL_CREDIT]));
                bankRegister.setStatus(rs.getInt(DbGl.colNames[DbGl.COL_POSTED_STATUS]));
                
                result.add(bankRegister);
            }
        } catch (Exception e) {
            System.out.println("[Exception] "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    /**
     * Modul untuk melakukan proses update level departemen pada GL
     * create by gwawan 201210
     * @param departmentId
     * @return
     */
    public static boolean updateDepartmenLevel(long departmentId) {
        try {
            String where = colNames[COL_DEPARTMENT_ID] + " = " + departmentId;
            Vector vGlDetail = list(0, 0, where, "");
            
            if(vGlDetail != null && vGlDetail.size() > 0) {
                for(int i=0; i<vGlDetail.size(); i++) {
                    GlDetail glDetail = (GlDetail)vGlDetail.get(i);
                    glDetail = setOrganizationLevel(glDetail);
                    updateExc(glDetail);
                }
            }
        } catch(Exception e) {
            System.out.println("[Exception] "+e.toString());
            return false;
        }
        
        return true;
    }
}
