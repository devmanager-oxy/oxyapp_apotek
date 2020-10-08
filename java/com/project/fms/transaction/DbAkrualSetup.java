package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.util.*;
import com.project.*;

public class DbAkrualSetup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_AKRUAL_SETUP = "akrual_setup";
    public static final int COL_AKRUAL_SETUP_ID = 0;
    public static final int COL_NAMA            = 1;
    public static final int COL_ANGGARAN        = 2;
    public static final int COL_PEMBAGI         = 3;
    public static final int COL_CREDIT_COA_ID   = 4;
    public static final int COL_DEBET_COA_ID    = 5;
    public static final int COL_REG_DATE        = 6;
    public static final int COL_LAST_UPDATE     = 7;
    public static final int COL_USER_ID         = 8;
    public static final int COL_STATUS          = 9;
    public static final int COL_DEP_ID          = 10;    
    public static final int COL_SEGMENT1_ID     = 11;
    public static final int COL_SEGMENT2_ID     = 12;
    public static final int COL_SEGMENT3_ID     = 13;
    public static final int COL_SEGMENT4_ID     = 14;
    public static final int COL_SEGMENT5_ID     = 15;
    public static final int COL_SEGMENT6_ID     = 16;
    public static final int COL_SEGMENT7_ID     = 17;
    public static final int COL_SEGMENT8_ID     = 18;
    public static final int COL_SEGMENT9_ID     = 19;
    public static final int COL_SEGMENT10_ID    = 20;
    public static final int COL_SEGMENT11_ID    = 21;
    public static final int COL_SEGMENT12_ID    = 22;
    public static final int COL_SEGMENT13_ID    = 23;
    public static final int COL_SEGMENT14_ID    = 24;
    public static final int COL_SEGMENT15_ID    = 25;
    
    public static final String[] colNames = {
        "akrual_setup_id",
        "nama",
        "anggaran",
        "pembagi",
        "credit_coa_id",
        "debet_coa_id",
        "reg_date",
        "last_update",
        "user_id",
        "status",
        "dep_id",
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
        "segment15_id"
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
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
        TYPE_LONG
    };

    public static int STATUS_AKRUAL_NOT_AKTIF   = 0;
    public static int STATUS_AKRUAL_AKTIF       = 1;
    
    public DbAkrualSetup() {
    }

    public DbAkrualSetup(int i) throws CONException {
        super(new DbAkrualSetup());
    }

    public DbAkrualSetup(String sOid) throws CONException {
        super(new DbAkrualSetup(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbAkrualSetup(long lOid) throws CONException {
        super(new DbAkrualSetup(0));
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
        return DB_AKRUAL_SETUP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbAkrualSetup().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        AkrualSetup akrualsetup = fetchExc(ent.getOID());
        ent = (Entity) akrualsetup;
        return akrualsetup.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((AkrualSetup) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((AkrualSetup) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static AkrualSetup fetchExc(long oid) throws CONException {
        try {
            AkrualSetup akrualsetup = new AkrualSetup();
            DbAkrualSetup pstAkrualSetup = new DbAkrualSetup(oid);
            akrualsetup.setOID(oid);

            akrualsetup.setNama(pstAkrualSetup.getString(COL_NAMA));
            akrualsetup.setAnggaran(pstAkrualSetup.getdouble(COL_ANGGARAN));
            akrualsetup.setPembagi(pstAkrualSetup.getInt(COL_PEMBAGI));
            akrualsetup.setCreditCoaId(pstAkrualSetup.getlong(COL_CREDIT_COA_ID));
            akrualsetup.setDebetCoaId(pstAkrualSetup.getlong(COL_DEBET_COA_ID));
            akrualsetup.setRegDate(pstAkrualSetup.getDate(COL_REG_DATE));
            akrualsetup.setLastUpdate(pstAkrualSetup.getDate(COL_LAST_UPDATE));
            akrualsetup.setUserId(pstAkrualSetup.getlong(COL_USER_ID));
            akrualsetup.setStatus(pstAkrualSetup.getInt(COL_STATUS));
            akrualsetup.setDepId(pstAkrualSetup.getlong(COL_DEP_ID));
            
            akrualsetup.setSegment1Id(pstAkrualSetup.getlong(COL_SEGMENT1_ID));
            akrualsetup.setSegment2Id(pstAkrualSetup.getlong(COL_SEGMENT2_ID));
            akrualsetup.setSegment3Id(pstAkrualSetup.getlong(COL_SEGMENT3_ID));
            akrualsetup.setSegment4Id(pstAkrualSetup.getlong(COL_SEGMENT4_ID));
            akrualsetup.setSegment5Id(pstAkrualSetup.getlong(COL_SEGMENT5_ID));
            akrualsetup.setSegment6Id(pstAkrualSetup.getlong(COL_SEGMENT6_ID));
            akrualsetup.setSegment7Id(pstAkrualSetup.getlong(COL_SEGMENT7_ID));
            akrualsetup.setSegment8Id(pstAkrualSetup.getlong(COL_SEGMENT8_ID));
            akrualsetup.setSegment9Id(pstAkrualSetup.getlong(COL_SEGMENT9_ID));
            akrualsetup.setSegment10Id(pstAkrualSetup.getlong(COL_SEGMENT10_ID));
            akrualsetup.setSegment11Id(pstAkrualSetup.getlong(COL_SEGMENT11_ID));
            akrualsetup.setSegment12Id(pstAkrualSetup.getlong(COL_SEGMENT12_ID));
            akrualsetup.setSegment13Id(pstAkrualSetup.getlong(COL_SEGMENT13_ID));
            akrualsetup.setSegment14Id(pstAkrualSetup.getlong(COL_SEGMENT14_ID));
            akrualsetup.setSegment15Id(pstAkrualSetup.getlong(COL_SEGMENT15_ID));
            

            return akrualsetup;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualSetup(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(AkrualSetup akrualsetup) throws CONException {
        try {
            DbAkrualSetup pstAkrualSetup = new DbAkrualSetup(0);

            pstAkrualSetup.setString(COL_NAMA, akrualsetup.getNama());
            pstAkrualSetup.setDouble(COL_ANGGARAN, akrualsetup.getAnggaran());
            pstAkrualSetup.setInt(COL_PEMBAGI, akrualsetup.getPembagi());
            pstAkrualSetup.setLong(COL_CREDIT_COA_ID, akrualsetup.getCreditCoaId());
            pstAkrualSetup.setLong(COL_DEBET_COA_ID, akrualsetup.getDebetCoaId());
            pstAkrualSetup.setDate(COL_REG_DATE, akrualsetup.getRegDate());
            pstAkrualSetup.setDate(COL_LAST_UPDATE, akrualsetup.getLastUpdate());
            pstAkrualSetup.setLong(COL_USER_ID, akrualsetup.getUserId());
            pstAkrualSetup.setInt(COL_STATUS, akrualsetup.getStatus());
            pstAkrualSetup.setLong(COL_DEP_ID, akrualsetup.getDepId());
            
            pstAkrualSetup.setLong(COL_SEGMENT1_ID, akrualsetup.getSegment1Id());
            pstAkrualSetup.setLong(COL_SEGMENT2_ID, akrualsetup.getSegment2Id());
            pstAkrualSetup.setLong(COL_SEGMENT3_ID, akrualsetup.getSegment3Id());
            pstAkrualSetup.setLong(COL_SEGMENT4_ID, akrualsetup.getSegment4Id());
            pstAkrualSetup.setLong(COL_SEGMENT5_ID, akrualsetup.getSegment5Id());
            pstAkrualSetup.setLong(COL_SEGMENT6_ID, akrualsetup.getSegment6Id());
            pstAkrualSetup.setLong(COL_SEGMENT7_ID, akrualsetup.getSegment7Id());
            pstAkrualSetup.setLong(COL_SEGMENT8_ID, akrualsetup.getSegment8Id());
            pstAkrualSetup.setLong(COL_SEGMENT9_ID, akrualsetup.getSegment9Id());
            pstAkrualSetup.setLong(COL_SEGMENT10_ID, akrualsetup.getSegment10Id());
            pstAkrualSetup.setLong(COL_SEGMENT11_ID, akrualsetup.getSegment11Id());
            pstAkrualSetup.setLong(COL_SEGMENT12_ID, akrualsetup.getSegment12Id());
            pstAkrualSetup.setLong(COL_SEGMENT13_ID, akrualsetup.getSegment13Id());
            pstAkrualSetup.setLong(COL_SEGMENT14_ID, akrualsetup.getSegment14Id());
            pstAkrualSetup.setLong(COL_SEGMENT15_ID, akrualsetup.getSegment15Id());

            pstAkrualSetup.insert();
            akrualsetup.setOID(pstAkrualSetup.getlong(COL_AKRUAL_SETUP_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualSetup(0), CONException.UNKNOWN);
        }
        return akrualsetup.getOID();
    }

    public static long updateExc(AkrualSetup akrualsetup) throws CONException {
        try {
            if (akrualsetup.getOID() != 0) {
                DbAkrualSetup pstAkrualSetup = new DbAkrualSetup(akrualsetup.getOID());

                pstAkrualSetup.setString(COL_NAMA, akrualsetup.getNama());
                pstAkrualSetup.setDouble(COL_ANGGARAN, akrualsetup.getAnggaran());
                pstAkrualSetup.setInt(COL_PEMBAGI, akrualsetup.getPembagi());
                pstAkrualSetup.setLong(COL_CREDIT_COA_ID, akrualsetup.getCreditCoaId());
                pstAkrualSetup.setLong(COL_DEBET_COA_ID, akrualsetup.getDebetCoaId());
                pstAkrualSetup.setDate(COL_REG_DATE, akrualsetup.getRegDate());
                pstAkrualSetup.setDate(COL_LAST_UPDATE, akrualsetup.getLastUpdate());
                pstAkrualSetup.setLong(COL_USER_ID, akrualsetup.getUserId());
                pstAkrualSetup.setInt(COL_STATUS, akrualsetup.getStatus());
                pstAkrualSetup.setLong(COL_DEP_ID, akrualsetup.getDepId());
                
                pstAkrualSetup.setLong(COL_SEGMENT1_ID, akrualsetup.getSegment1Id());
                pstAkrualSetup.setLong(COL_SEGMENT2_ID, akrualsetup.getSegment2Id());
                pstAkrualSetup.setLong(COL_SEGMENT3_ID, akrualsetup.getSegment3Id());
                pstAkrualSetup.setLong(COL_SEGMENT4_ID, akrualsetup.getSegment4Id());
                pstAkrualSetup.setLong(COL_SEGMENT5_ID, akrualsetup.getSegment5Id());
                pstAkrualSetup.setLong(COL_SEGMENT6_ID, akrualsetup.getSegment6Id());
                pstAkrualSetup.setLong(COL_SEGMENT7_ID, akrualsetup.getSegment7Id());
                pstAkrualSetup.setLong(COL_SEGMENT8_ID, akrualsetup.getSegment8Id());
                pstAkrualSetup.setLong(COL_SEGMENT9_ID, akrualsetup.getSegment9Id());
                pstAkrualSetup.setLong(COL_SEGMENT10_ID, akrualsetup.getSegment10Id());
                pstAkrualSetup.setLong(COL_SEGMENT11_ID, akrualsetup.getSegment11Id());
                pstAkrualSetup.setLong(COL_SEGMENT12_ID, akrualsetup.getSegment12Id());
                pstAkrualSetup.setLong(COL_SEGMENT13_ID, akrualsetup.getSegment13Id());
                pstAkrualSetup.setLong(COL_SEGMENT14_ID, akrualsetup.getSegment14Id());
                pstAkrualSetup.setLong(COL_SEGMENT15_ID, akrualsetup.getSegment15Id());

                pstAkrualSetup.update();
                return akrualsetup.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualSetup(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbAkrualSetup pstAkrualSetup = new DbAkrualSetup(oid);
            pstAkrualSetup.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualSetup(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_AKRUAL_SETUP;
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
                AkrualSetup akrualsetup = new AkrualSetup();
                resultToObject(rs, akrualsetup);
                lists.add(akrualsetup);
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

    private static void resultToObject(ResultSet rs, AkrualSetup akrualsetup) {
        try {
            akrualsetup.setOID(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_AKRUAL_SETUP_ID]));
            akrualsetup.setNama(rs.getString(DbAkrualSetup.colNames[DbAkrualSetup.COL_NAMA]));
            akrualsetup.setAnggaran(rs.getDouble(DbAkrualSetup.colNames[DbAkrualSetup.COL_ANGGARAN]));
            akrualsetup.setPembagi(rs.getInt(DbAkrualSetup.colNames[DbAkrualSetup.COL_PEMBAGI]));
            akrualsetup.setCreditCoaId(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_CREDIT_COA_ID]));
            akrualsetup.setDebetCoaId(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_DEBET_COA_ID]));
            akrualsetup.setRegDate(rs.getDate(DbAkrualSetup.colNames[DbAkrualSetup.COL_REG_DATE]));
            akrualsetup.setLastUpdate(rs.getDate(DbAkrualSetup.colNames[DbAkrualSetup.COL_LAST_UPDATE]));
            akrualsetup.setUserId(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_USER_ID]));
            akrualsetup.setStatus(rs.getInt(DbAkrualSetup.colNames[DbAkrualSetup.COL_STATUS]));
            akrualsetup.setDepId(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_DEP_ID]));
            
            akrualsetup.setSegment1Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT1_ID]));
            akrualsetup.setSegment2Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT2_ID]));
            akrualsetup.setSegment3Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT3_ID]));
            akrualsetup.setSegment4Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT4_ID]));
            akrualsetup.setSegment5Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT5_ID]));
            akrualsetup.setSegment6Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT6_ID]));
            akrualsetup.setSegment7Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT7_ID]));
            akrualsetup.setSegment8Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT8_ID]));
            akrualsetup.setSegment9Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT9_ID]));
            akrualsetup.setSegment10Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT10_ID]));
            akrualsetup.setSegment11Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT11_ID]));
            akrualsetup.setSegment12Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT12_ID]));
            akrualsetup.setSegment13Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT13_ID]));
            akrualsetup.setSegment14Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT14_ID]));
            akrualsetup.setSegment15Id(rs.getLong(DbAkrualSetup.colNames[DbAkrualSetup.COL_SEGMENT15_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long akrualSetupId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_AKRUAL_SETUP + " WHERE " +
                    DbAkrualSetup.colNames[DbAkrualSetup.COL_AKRUAL_SETUP_ID] + " = " + akrualSetupId;

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
            String sql = "SELECT COUNT(" + DbAkrualSetup.colNames[DbAkrualSetup.COL_AKRUAL_SETUP_ID] + ") FROM " + DB_AKRUAL_SETUP;
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
                    AkrualSetup akrualsetup = (AkrualSetup) list.get(ls);
                    if (oid == akrualsetup.getOID()) {
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
}
