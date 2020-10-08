/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;

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
import com.project.system.*;
/**
 *
 * @author Roy
 */
public class DbGlDetail2015 extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_GL_DETAIL2015 = "gl_detail_2015";
    
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

    public DbGlDetail2015() {
    }

    public DbGlDetail2015(int i) throws CONException {
        super(new DbGlDetail2015());
    }

    public DbGlDetail2015(String sOid) throws CONException {
        super(new DbGlDetail2015(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGlDetail2015(long lOid) throws CONException {
        super(new DbGlDetail2015(0));
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
        return DB_GL_DETAIL2015;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGlDetail2015().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GlDetail2015 gldetail2015 = fetchExc(ent.getOID());
        ent = (Entity) gldetail2015;
        return gldetail2015.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GlDetail2015) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GlDetail2015) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GlDetail2015 fetchExc(long oid) throws CONException {
        try {
            GlDetail2015 gldetail2015 = new GlDetail2015();
            DbGlDetail2015 pstGlDetail2015 = new DbGlDetail2015(oid);
            gldetail2015.setOID(oid);

            gldetail2015.setGlId(pstGlDetail2015.getlong(COL_GL_ID));
            gldetail2015.setCoaId(pstGlDetail2015.getlong(COL_COA_ID));
            gldetail2015.setDebet(pstGlDetail2015.getdouble(COL_DEBET));
            gldetail2015.setCredit(pstGlDetail2015.getdouble(COL_CREDIT));
            gldetail2015.setForeignCurrencyId(pstGlDetail2015.getlong(COL_FOREIGN_CURRENCY_ID));
            gldetail2015.setForeignCurrencyAmount(pstGlDetail2015.getdouble(COL_FOREIGN_CURRENCY_AMOUNT));
            gldetail2015.setMemo(pstGlDetail2015.getString(COL_MEMO));
            gldetail2015.setBookedRate(pstGlDetail2015.getdouble(COL_BOOKED_RATE));

            gldetail2015.setDepartmentId(pstGlDetail2015.getlong(COL_DEPARTMENT_ID));
            gldetail2015.setSectionId(pstGlDetail2015.getlong(COL_SECTION_ID));
            gldetail2015.setSubSectionId(pstGlDetail2015.getlong(COL_SUB_SECTION_ID));
            gldetail2015.setJobId(pstGlDetail2015.getlong(COL_JOB_ID));
            gldetail2015.setStatusTransaction(pstGlDetail2015.getInt(COL_STATUS_TRANSACTION));
            gldetail2015.setCustomerId(pstGlDetail2015.getlong(COL_CUSTOMER_ID));

            gldetail2015.setCoaLevel1Id(pstGlDetail2015.getlong(COL_COA_LEVEL1_ID));
            gldetail2015.setCoaLevel2Id(pstGlDetail2015.getlong(COL_COA_LEVEL2_ID));
            gldetail2015.setCoaLevel3Id(pstGlDetail2015.getlong(COL_COA_LEVEL3_ID));
            gldetail2015.setCoaLevel4Id(pstGlDetail2015.getlong(COL_COA_LEVEL4_ID));
            gldetail2015.setCoaLevel5Id(pstGlDetail2015.getlong(COL_COA_LEVEL5_ID));
            gldetail2015.setCoaLevel6Id(pstGlDetail2015.getlong(COL_COA_LEVEL6_ID));
            gldetail2015.setCoaLevel7Id(pstGlDetail2015.getlong(COL_COA_LEVEL7_ID));

            gldetail2015.setDirectorateId(pstGlDetail2015.getlong(COL_DIRECTORATE_ID));
            gldetail2015.setDivisionId(pstGlDetail2015.getlong(COL_DIVISION_ID));

            gldetail2015.setDepLevel1Id(pstGlDetail2015.getlong(COL_DEP_LEVEL1_ID));
            gldetail2015.setDepLevel2Id(pstGlDetail2015.getlong(COL_DEP_LEVEL2_ID));
            gldetail2015.setDepLevel3Id(pstGlDetail2015.getlong(COL_DEP_LEVEL3_ID));
            gldetail2015.setDepLevel4Id(pstGlDetail2015.getlong(COL_DEP_LEVEL4_ID));
            gldetail2015.setDepLevel5Id(pstGlDetail2015.getlong(COL_DEP_LEVEL5_ID));

            gldetail2015.setSegment1Id(pstGlDetail2015.getlong(COL_SEGMENT1_ID));
            gldetail2015.setSegment2Id(pstGlDetail2015.getlong(COL_SEGMENT2_ID));
            gldetail2015.setSegment3Id(pstGlDetail2015.getlong(COL_SEGMENT3_ID));
            gldetail2015.setSegment4Id(pstGlDetail2015.getlong(COL_SEGMENT4_ID));
            gldetail2015.setSegment5Id(pstGlDetail2015.getlong(COL_SEGMENT5_ID));
            gldetail2015.setSegment6Id(pstGlDetail2015.getlong(COL_SEGMENT6_ID));
            gldetail2015.setSegment7Id(pstGlDetail2015.getlong(COL_SEGMENT7_ID));
            gldetail2015.setSegment8Id(pstGlDetail2015.getlong(COL_SEGMENT8_ID));
            gldetail2015.setSegment9Id(pstGlDetail2015.getlong(COL_SEGMENT9_ID));
            gldetail2015.setSegment10Id(pstGlDetail2015.getlong(COL_SEGMENT10_ID));
            gldetail2015.setSegment11Id(pstGlDetail2015.getlong(COL_SEGMENT11_ID));
            gldetail2015.setSegment12Id(pstGlDetail2015.getlong(COL_SEGMENT12_ID));
            gldetail2015.setSegment13Id(pstGlDetail2015.getlong(COL_SEGMENT13_ID));
            gldetail2015.setSegment14Id(pstGlDetail2015.getlong(COL_SEGMENT14_ID));
            gldetail2015.setSegment15Id(pstGlDetail2015.getlong(COL_SEGMENT15_ID));

            gldetail2015.setModuleId(pstGlDetail2015.getlong(COL_MODULE_ID));

            gldetail2015.setDepLevel0Id(pstGlDetail2015.getlong(COL_DEP_LEVEL0_ID));

            return gldetail2015;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail2015(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GlDetail2015 gldetail2015) throws CONException {
        try {
            DbGlDetail2015 pstGlDetail2015 = new DbGlDetail2015(0);

            pstGlDetail2015.setLong(COL_GL_ID, gldetail2015.getGlId());
            pstGlDetail2015.setLong(COL_COA_ID, gldetail2015.getCoaId());
            pstGlDetail2015.setDouble(COL_DEBET, gldetail2015.getDebet());
            pstGlDetail2015.setDouble(COL_CREDIT, gldetail2015.getCredit());
            pstGlDetail2015.setLong(COL_FOREIGN_CURRENCY_ID, gldetail2015.getForeignCurrencyId());
            pstGlDetail2015.setDouble(COL_FOREIGN_CURRENCY_AMOUNT, gldetail2015.getForeignCurrencyAmount());
            pstGlDetail2015.setString(COL_MEMO, gldetail2015.getMemo());
            pstGlDetail2015.setDouble(COL_BOOKED_RATE, gldetail2015.getBookedRate());

            pstGlDetail2015.setLong(COL_DEPARTMENT_ID, gldetail2015.getDepartmentId());
            pstGlDetail2015.setLong(COL_SECTION_ID, gldetail2015.getSectionId());
            pstGlDetail2015.setLong(COL_SUB_SECTION_ID, gldetail2015.getSubSectionId());
            pstGlDetail2015.setLong(COL_JOB_ID, gldetail2015.getJobId());

            pstGlDetail2015.setInt(COL_STATUS_TRANSACTION, gldetail2015.getStatusTransaction());
            pstGlDetail2015.setLong(COL_CUSTOMER_ID, gldetail2015.getCustomerId());

            pstGlDetail2015.setLong(COL_COA_LEVEL1_ID, gldetail2015.getCoaLevel1Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL2_ID, gldetail2015.getCoaLevel2Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL3_ID, gldetail2015.getCoaLevel3Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL4_ID, gldetail2015.getCoaLevel4Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL5_ID, gldetail2015.getCoaLevel5Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL6_ID, gldetail2015.getCoaLevel6Id());
            pstGlDetail2015.setLong(COL_COA_LEVEL7_ID, gldetail2015.getCoaLevel7Id());

            pstGlDetail2015.setLong(COL_DIRECTORATE_ID, gldetail2015.getDirectorateId());
            pstGlDetail2015.setLong(COL_DIVISION_ID, gldetail2015.getDivisionId());

            pstGlDetail2015.setLong(COL_DEP_LEVEL1_ID, gldetail2015.getDepLevel1Id());
            pstGlDetail2015.setLong(COL_DEP_LEVEL2_ID, gldetail2015.getDepLevel2Id());
            pstGlDetail2015.setLong(COL_DEP_LEVEL3_ID, gldetail2015.getDepLevel3Id());
            pstGlDetail2015.setLong(COL_DEP_LEVEL4_ID, gldetail2015.getDepLevel4Id());
            pstGlDetail2015.setLong(COL_DEP_LEVEL5_ID, gldetail2015.getDepLevel5Id());

            pstGlDetail2015.setLong(COL_SEGMENT1_ID, gldetail2015.getSegment1Id());
            pstGlDetail2015.setLong(COL_SEGMENT2_ID, gldetail2015.getSegment2Id());
            pstGlDetail2015.setLong(COL_SEGMENT3_ID, gldetail2015.getSegment3Id());
            pstGlDetail2015.setLong(COL_SEGMENT4_ID, gldetail2015.getSegment4Id());
            pstGlDetail2015.setLong(COL_SEGMENT5_ID, gldetail2015.getSegment5Id());
            pstGlDetail2015.setLong(COL_SEGMENT6_ID, gldetail2015.getSegment6Id());
            pstGlDetail2015.setLong(COL_SEGMENT7_ID, gldetail2015.getSegment7Id());
            pstGlDetail2015.setLong(COL_SEGMENT8_ID, gldetail2015.getSegment8Id());
            pstGlDetail2015.setLong(COL_SEGMENT9_ID, gldetail2015.getSegment9Id());
            pstGlDetail2015.setLong(COL_SEGMENT10_ID, gldetail2015.getSegment10Id());
            pstGlDetail2015.setLong(COL_SEGMENT11_ID, gldetail2015.getSegment11Id());
            pstGlDetail2015.setLong(COL_SEGMENT12_ID, gldetail2015.getSegment12Id());
            pstGlDetail2015.setLong(COL_SEGMENT13_ID, gldetail2015.getSegment13Id());
            pstGlDetail2015.setLong(COL_SEGMENT14_ID, gldetail2015.getSegment14Id());
            pstGlDetail2015.setLong(COL_SEGMENT15_ID, gldetail2015.getSegment15Id());

            pstGlDetail2015.setLong(COL_MODULE_ID, gldetail2015.getModuleId());

            pstGlDetail2015.setLong(COL_DEP_LEVEL0_ID, gldetail2015.getDepLevel0Id());

            pstGlDetail2015.insert();
            gldetail2015.setOID(pstGlDetail2015.getlong(COL_GL_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail2015(0), CONException.UNKNOWN);
        }
        return gldetail2015.getOID();
    }

    public static long updateExc(GlDetail2015 gldetail2015) throws CONException {
        try {
            if (gldetail2015.getOID() != 0) {
                DbGlDetail2015 pstGlDetail2015 = new DbGlDetail2015(gldetail2015.getOID());

                pstGlDetail2015.setLong(COL_GL_ID, gldetail2015.getGlId());
                pstGlDetail2015.setLong(COL_COA_ID, gldetail2015.getCoaId());
                pstGlDetail2015.setDouble(COL_DEBET, gldetail2015.getDebet());
                pstGlDetail2015.setDouble(COL_CREDIT, gldetail2015.getCredit());
                pstGlDetail2015.setLong(COL_FOREIGN_CURRENCY_ID, gldetail2015.getForeignCurrencyId());
                pstGlDetail2015.setDouble(COL_FOREIGN_CURRENCY_AMOUNT, gldetail2015.getForeignCurrencyAmount());
                pstGlDetail2015.setString(COL_MEMO, gldetail2015.getMemo());
                pstGlDetail2015.setDouble(COL_BOOKED_RATE, gldetail2015.getBookedRate());

                pstGlDetail2015.setLong(COL_DEPARTMENT_ID, gldetail2015.getDepartmentId());
                pstGlDetail2015.setLong(COL_SECTION_ID, gldetail2015.getSectionId());
                pstGlDetail2015.setLong(COL_SUB_SECTION_ID, gldetail2015.getSubSectionId());
                pstGlDetail2015.setLong(COL_JOB_ID, gldetail2015.getJobId());

                pstGlDetail2015.setInt(COL_STATUS_TRANSACTION, gldetail2015.getStatusTransaction());
                pstGlDetail2015.setLong(COL_CUSTOMER_ID, gldetail2015.getCustomerId());

                pstGlDetail2015.setLong(COL_COA_LEVEL1_ID, gldetail2015.getCoaLevel1Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL2_ID, gldetail2015.getCoaLevel2Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL3_ID, gldetail2015.getCoaLevel3Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL4_ID, gldetail2015.getCoaLevel4Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL5_ID, gldetail2015.getCoaLevel5Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL6_ID, gldetail2015.getCoaLevel6Id());
                pstGlDetail2015.setLong(COL_COA_LEVEL7_ID, gldetail2015.getCoaLevel7Id());

                pstGlDetail2015.setLong(COL_DIRECTORATE_ID, gldetail2015.getDirectorateId());
                pstGlDetail2015.setLong(COL_DIVISION_ID, gldetail2015.getDivisionId());

                pstGlDetail2015.setLong(COL_DEP_LEVEL1_ID, gldetail2015.getDepLevel1Id());
                pstGlDetail2015.setLong(COL_DEP_LEVEL2_ID, gldetail2015.getDepLevel2Id());
                pstGlDetail2015.setLong(COL_DEP_LEVEL3_ID, gldetail2015.getDepLevel3Id());
                pstGlDetail2015.setLong(COL_DEP_LEVEL4_ID, gldetail2015.getDepLevel4Id());
                pstGlDetail2015.setLong(COL_DEP_LEVEL5_ID, gldetail2015.getDepLevel5Id());

                pstGlDetail2015.setLong(COL_SEGMENT1_ID, gldetail2015.getSegment1Id());
                pstGlDetail2015.setLong(COL_SEGMENT2_ID, gldetail2015.getSegment2Id());
                pstGlDetail2015.setLong(COL_SEGMENT3_ID, gldetail2015.getSegment3Id());
                pstGlDetail2015.setLong(COL_SEGMENT4_ID, gldetail2015.getSegment4Id());
                pstGlDetail2015.setLong(COL_SEGMENT5_ID, gldetail2015.getSegment5Id());
                pstGlDetail2015.setLong(COL_SEGMENT6_ID, gldetail2015.getSegment6Id());
                pstGlDetail2015.setLong(COL_SEGMENT7_ID, gldetail2015.getSegment7Id());
                pstGlDetail2015.setLong(COL_SEGMENT8_ID, gldetail2015.getSegment8Id());
                pstGlDetail2015.setLong(COL_SEGMENT9_ID, gldetail2015.getSegment9Id());
                pstGlDetail2015.setLong(COL_SEGMENT10_ID, gldetail2015.getSegment10Id());
                pstGlDetail2015.setLong(COL_SEGMENT11_ID, gldetail2015.getSegment11Id());
                pstGlDetail2015.setLong(COL_SEGMENT12_ID, gldetail2015.getSegment12Id());
                pstGlDetail2015.setLong(COL_SEGMENT13_ID, gldetail2015.getSegment13Id());
                pstGlDetail2015.setLong(COL_SEGMENT14_ID, gldetail2015.getSegment14Id());
                pstGlDetail2015.setLong(COL_SEGMENT15_ID, gldetail2015.getSegment15Id());

                pstGlDetail2015.setLong(COL_MODULE_ID, gldetail2015.getModuleId());

                pstGlDetail2015.setLong(COL_DEP_LEVEL0_ID, gldetail2015.getDepLevel0Id());

                pstGlDetail2015.update();
                return gldetail2015.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail2015(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGlDetail2015 pstGlDetail2015 = new DbGlDetail2015(oid);
            pstGlDetail2015.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGlDetail2015(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL_DETAIL2015;
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
                GlDetail2015 gldetail2015 = new GlDetail2015();
                resultToObject(rs, gldetail2015);
                lists.add(gldetail2015);
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

    public static void resultToObject(ResultSet rs, GlDetail2015 gldetail2015) {
        try {
            gldetail2015.setOID(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_GL_DETAIL_ID]));
            gldetail2015.setGlId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_GL_ID]));
            gldetail2015.setCoaId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_ID]));
            gldetail2015.setDebet(rs.getDouble(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEBET]));
            gldetail2015.setCredit(rs.getDouble(DbGlDetail2015.colNames[DbGlDetail2015.COL_CREDIT]));
            gldetail2015.setForeignCurrencyId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_FOREIGN_CURRENCY_ID]));
            gldetail2015.setForeignCurrencyAmount(rs.getDouble(DbGlDetail2015.colNames[DbGlDetail2015.COL_FOREIGN_CURRENCY_AMOUNT]));
            gldetail2015.setMemo(rs.getString(DbGlDetail2015.colNames[DbGlDetail2015.COL_MEMO]));
            gldetail2015.setBookedRate(rs.getDouble(DbGlDetail2015.colNames[DbGlDetail2015.COL_BOOKED_RATE]));

            gldetail2015.setDepartmentId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEPARTMENT_ID]));
            gldetail2015.setSectionId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SECTION_ID]));
            gldetail2015.setSubSectionId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SUB_SECTION_ID]));
            gldetail2015.setJobId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_JOB_ID]));

            gldetail2015.setStatusTransaction(rs.getInt(DbGlDetail2015.colNames[DbGlDetail2015.COL_STATUS_TRANSACTION]));
            gldetail2015.setCustomerId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_CUSTOMER_ID]));

            gldetail2015.setCoaLevel1Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL1_ID]));
            gldetail2015.setCoaLevel2Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL2_ID]));
            gldetail2015.setCoaLevel3Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL3_ID]));
            gldetail2015.setCoaLevel4Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL4_ID]));
            gldetail2015.setCoaLevel5Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL5_ID]));
            gldetail2015.setCoaLevel6Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL6_ID]));
            gldetail2015.setCoaLevel7Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_COA_LEVEL7_ID]));

            gldetail2015.setDirectorateId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DIRECTORATE_ID]));
            gldetail2015.setDivisionId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DIVISION_ID]));

            gldetail2015.setDepLevel1Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL1_ID]));
            gldetail2015.setDepLevel2Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL2_ID]));
            gldetail2015.setDepLevel3Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL3_ID]));
            gldetail2015.setDepLevel4Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL4_ID]));
            gldetail2015.setDepLevel5Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL5_ID]));

            gldetail2015.setSegment1Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT1_ID]));
            gldetail2015.setSegment2Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT2_ID]));
            gldetail2015.setSegment3Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT3_ID]));
            gldetail2015.setSegment4Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT4_ID]));
            gldetail2015.setSegment5Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT5_ID]));
            gldetail2015.setSegment6Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT6_ID]));
            gldetail2015.setSegment7Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT7_ID]));
            gldetail2015.setSegment8Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT8_ID]));
            gldetail2015.setSegment9Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT9_ID]));
            gldetail2015.setSegment10Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT10_ID]));
            gldetail2015.setSegment11Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT11_ID]));
            gldetail2015.setSegment12Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT12_ID]));
            gldetail2015.setSegment13Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT13_ID]));
            gldetail2015.setSegment14Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT14_ID]));
            gldetail2015.setSegment15Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_SEGMENT15_ID]));

            gldetail2015.setModuleId(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_MODULE_ID]));

            gldetail2015.setDepLevel0Id(rs.getLong(DbGlDetail2015.colNames[DbGlDetail2015.COL_DEP_LEVEL0_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long glDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL_DETAIL2015 + " WHERE " +
                    DbGlDetail2015.colNames[DbGlDetail2015.COL_GL_ID] + " = " + glDetailId;

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
            String sql = "SELECT COUNT(" + DbGlDetail2015.colNames[DbGlDetail2015.COL_GL_DETAIL_ID] + ") FROM " + DB_GL_DETAIL2015;
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
                    GlDetail2015 gldetail2015 = (GlDetail2015) list.get(ls);
                    if (oid == gldetail2015.getOID()) {
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
    
    public static GlDetail2015 setCoaLevel(GlDetail2015 glDetail2015) {

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(glDetail2015.getCoaId());
        } catch (Exception e) {

        }

        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

        if (coaLabaLalu.getCode().equals(coa.getCode()) || coaLabaBerjalan.getCode().equals(coa.getCode())) {

            glDetail2015.setCoaLevel7Id(coa.getOID());
            glDetail2015.setCoaLevel6Id(coa.getOID());
            glDetail2015.setCoaLevel5Id(coa.getOID());
            glDetail2015.setCoaLevel4Id(coa.getOID());
            glDetail2015.setCoaLevel3Id(coa.getOID());
            glDetail2015.setCoaLevel2Id(coa.getOID());
            glDetail2015.setCoaLevel1Id(coa.getOID());

        } else {

            switch (coa.getLevel()) {
                case 1:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getOID());
                    glDetail2015.setCoaLevel4Id(coa.getOID());
                    glDetail2015.setCoaLevel3Id(coa.getOID());
                    glDetail2015.setCoaLevel2Id(coa.getOID());
                    glDetail2015.setCoaLevel1Id(coa.getOID());
                    break;
                case 2:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getOID());
                    glDetail2015.setCoaLevel4Id(coa.getOID());
                    glDetail2015.setCoaLevel3Id(coa.getOID());
                    glDetail2015.setCoaLevel2Id(coa.getOID());
                    glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    break;
                case 3:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getOID());
                    glDetail2015.setCoaLevel4Id(coa.getOID());
                    glDetail2015.setCoaLevel3Id(coa.getOID());
                    glDetail2015.setCoaLevel2Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 4:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getOID());
                    glDetail2015.setCoaLevel4Id(coa.getOID());
                    glDetail2015.setCoaLevel3Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 5:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getOID());
                    glDetail2015.setCoaLevel4Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 6:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getOID());
                    glDetail2015.setCoaLevel5Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel4Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
                case 7:
                    glDetail2015.setCoaLevel7Id(coa.getOID());
                    glDetail2015.setCoaLevel6Id(coa.getAccRefId());
                    try {
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel5Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel4Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel3Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel2Id(coa.getAccRefId());
                        coa = DbCoa.fetchExc(coa.getAccRefId());
                        glDetail2015.setCoaLevel1Id(coa.getAccRefId());
                    } catch (Exception e) {
                    }
                    break;
            }

        }

        return glDetail2015;

    }
    
    public static GlDetail2015 setOrganizationLevel(GlDetail2015 glDetail2015) {
        Department dep = new Department();
        
        try {
            dep = DbDepartment.fetchExc(glDetail2015.getDepartmentId());
        } catch (Exception e) {
        }

        switch (dep.getLevel()) {
            case 0://direktorat
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getOID());
                glDetail2015.setDepLevel3Id(dep.getOID());
                glDetail2015.setDepLevel2Id(dep.getOID());
                glDetail2015.setDepLevel1Id(dep.getOID());
                glDetail2015.setDepLevel0Id(dep.getOID());
                break;
            case 1:
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getOID());
                glDetail2015.setDepLevel3Id(dep.getOID());
                glDetail2015.setDepLevel2Id(dep.getOID());
                glDetail2015.setDepLevel1Id(dep.getOID());
                glDetail2015.setDepLevel0Id(dep.getRefId());
                break;
            case 2:
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getOID());
                glDetail2015.setDepLevel3Id(dep.getOID());
                glDetail2015.setDepLevel2Id(dep.getOID());
                glDetail2015.setDepLevel1Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 3:
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getOID());
                glDetail2015.setDepLevel3Id(dep.getOID());
                glDetail2015.setDepLevel2Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 4:
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getOID());
                glDetail2015.setDepLevel3Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel2Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
            case 5:
                glDetail2015.setDepLevel5Id(dep.getOID());
                glDetail2015.setDepLevel4Id(dep.getRefId());
                try {
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel3Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel2Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel1Id(dep.getRefId());
                    dep = DbDepartment.fetchExc(dep.getRefId());
                    glDetail2015.setDepLevel0Id(dep.getRefId());
                } catch (Exception e) {
                }
                break;
        }

        return glDetail2015;
    }

}
