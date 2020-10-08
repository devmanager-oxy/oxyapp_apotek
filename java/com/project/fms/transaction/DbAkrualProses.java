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
import com.project.fms.master.*;
import com.project.util.*;
import com.project.*;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.general.Company;
import com.project.general.DbCompany;

public class DbAkrualProses extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_AKRUAL_PROSES = "akrual_proses";
    public static final int COL_AKRUAL_PROSES_ID = 0;
    public static final int COL_REG_DATE = 1;
    public static final int COL_JUMLAH = 2;
    public static final int COL_CREDIT_COA_ID = 3;
    public static final int COL_DEBET_COA_ID = 4;
    public static final int COL_PERIODE_ID = 5;
    public static final int COL_USER_ID = 6;
    public static final int COL_AKRUAL_SETUP_ID = 7;
    public static final int COL_DEP_ID = 8;
    
    public static final int COL_SEGMENT1_ID     = 9;
    public static final int COL_SEGMENT2_ID     = 10;
    public static final int COL_SEGMENT3_ID     = 11;
    public static final int COL_SEGMENT4_ID     = 12;
    public static final int COL_SEGMENT5_ID     = 13;
    public static final int COL_SEGMENT6_ID     = 14;
    public static final int COL_SEGMENT7_ID     = 15;
    public static final int COL_SEGMENT8_ID     = 16;
    public static final int COL_SEGMENT9_ID     = 17;
    public static final int COL_SEGMENT10_ID    = 18;
    public static final int COL_SEGMENT11_ID    = 19;
    public static final int COL_SEGMENT12_ID    = 20;
    public static final int COL_SEGMENT13_ID    = 21;
    public static final int COL_SEGMENT14_ID    = 22;
    public static final int COL_SEGMENT15_ID    = 23;
    
    public static final String[] colNames = {
        "akrual_proses_id",
        "reg_date",
        "jumlah",
        "credit_coa_id",
        "debet_coa_id",
        "periode_id",
        "user_id",
        "akrual_setup_id",
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
        TYPE_DATE,
        TYPE_FLOAT,
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
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbAkrualProses() {
    }

    public DbAkrualProses(int i) throws CONException {
        super(new DbAkrualProses());
    }

    public DbAkrualProses(String sOid) throws CONException {
        super(new DbAkrualProses(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbAkrualProses(long lOid) throws CONException {
        super(new DbAkrualProses(0));
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
        return DB_AKRUAL_PROSES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbAkrualProses().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        AkrualProses akrualproses = fetchExc(ent.getOID());
        ent = (Entity) akrualproses;
        return akrualproses.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((AkrualProses) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((AkrualProses) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static AkrualProses fetchExc(long oid) throws CONException {
        try {
            AkrualProses akrualproses = new AkrualProses();
            DbAkrualProses pstAkrualProses = new DbAkrualProses(oid);
            akrualproses.setOID(oid);

            akrualproses.setRegDate(pstAkrualProses.getDate(COL_REG_DATE));
            akrualproses.setJumlah(pstAkrualProses.getdouble(COL_JUMLAH));
            akrualproses.setCreditCoaId(pstAkrualProses.getlong(COL_CREDIT_COA_ID));
            akrualproses.setDebetCoaId(pstAkrualProses.getlong(COL_DEBET_COA_ID));
            akrualproses.setPeriodeId(pstAkrualProses.getlong(COL_PERIODE_ID));
            akrualproses.setUserId(pstAkrualProses.getlong(COL_USER_ID));
            akrualproses.setAkrualSetupId(pstAkrualProses.getlong(COL_AKRUAL_SETUP_ID));
            akrualproses.setDepId(pstAkrualProses.getlong(COL_DEP_ID));
            
            akrualproses.setSegment1Id(pstAkrualProses.getlong(COL_SEGMENT1_ID));
            akrualproses.setSegment2Id(pstAkrualProses.getlong(COL_SEGMENT2_ID));
            akrualproses.setSegment3Id(pstAkrualProses.getlong(COL_SEGMENT3_ID));
            akrualproses.setSegment4Id(pstAkrualProses.getlong(COL_SEGMENT4_ID));
            akrualproses.setSegment5Id(pstAkrualProses.getlong(COL_SEGMENT5_ID));
            akrualproses.setSegment6Id(pstAkrualProses.getlong(COL_SEGMENT6_ID));
            akrualproses.setSegment7Id(pstAkrualProses.getlong(COL_SEGMENT7_ID));
            akrualproses.setSegment8Id(pstAkrualProses.getlong(COL_SEGMENT8_ID));
            akrualproses.setSegment9Id(pstAkrualProses.getlong(COL_SEGMENT9_ID));
            akrualproses.setSegment10Id(pstAkrualProses.getlong(COL_SEGMENT10_ID));
            akrualproses.setSegment11Id(pstAkrualProses.getlong(COL_SEGMENT11_ID));
            akrualproses.setSegment12Id(pstAkrualProses.getlong(COL_SEGMENT12_ID));
            akrualproses.setSegment13Id(pstAkrualProses.getlong(COL_SEGMENT13_ID));
            akrualproses.setSegment14Id(pstAkrualProses.getlong(COL_SEGMENT14_ID));
            akrualproses.setSegment15Id(pstAkrualProses.getlong(COL_SEGMENT15_ID));

            return akrualproses;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualProses(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(AkrualProses akrualproses) throws CONException {
        try {
            DbAkrualProses pstAkrualProses = new DbAkrualProses(0);

            pstAkrualProses.setDate(COL_REG_DATE, akrualproses.getRegDate());
            pstAkrualProses.setDouble(COL_JUMLAH, akrualproses.getJumlah());
            pstAkrualProses.setLong(COL_CREDIT_COA_ID, akrualproses.getCreditCoaId());
            pstAkrualProses.setLong(COL_DEBET_COA_ID, akrualproses.getDebetCoaId());
            pstAkrualProses.setLong(COL_PERIODE_ID, akrualproses.getPeriodeId());
            pstAkrualProses.setLong(COL_USER_ID, akrualproses.getUserId());
            pstAkrualProses.setLong(COL_AKRUAL_SETUP_ID, akrualproses.getAkrualSetupId());
            pstAkrualProses.setLong(COL_DEP_ID, akrualproses.getDepId());
            
            pstAkrualProses.setLong(COL_SEGMENT1_ID, akrualproses.getSegment1Id());
            pstAkrualProses.setLong(COL_SEGMENT2_ID, akrualproses.getSegment2Id());
            pstAkrualProses.setLong(COL_SEGMENT3_ID, akrualproses.getSegment3Id());
            pstAkrualProses.setLong(COL_SEGMENT4_ID, akrualproses.getSegment4Id());
            pstAkrualProses.setLong(COL_SEGMENT5_ID, akrualproses.getSegment5Id());
            pstAkrualProses.setLong(COL_SEGMENT6_ID, akrualproses.getSegment6Id());
            pstAkrualProses.setLong(COL_SEGMENT7_ID, akrualproses.getSegment7Id());
            pstAkrualProses.setLong(COL_SEGMENT8_ID, akrualproses.getSegment8Id());
            pstAkrualProses.setLong(COL_SEGMENT9_ID, akrualproses.getSegment9Id());
            pstAkrualProses.setLong(COL_SEGMENT10_ID, akrualproses.getSegment10Id());
            pstAkrualProses.setLong(COL_SEGMENT11_ID, akrualproses.getSegment11Id());
            pstAkrualProses.setLong(COL_SEGMENT12_ID, akrualproses.getSegment12Id());
            pstAkrualProses.setLong(COL_SEGMENT13_ID, akrualproses.getSegment13Id());
            pstAkrualProses.setLong(COL_SEGMENT14_ID, akrualproses.getSegment14Id());
            pstAkrualProses.setLong(COL_SEGMENT15_ID, akrualproses.getSegment15Id());

            pstAkrualProses.insert();            
            akrualproses.setOID(pstAkrualProses.getlong(COL_AKRUAL_PROSES_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualProses(0), CONException.UNKNOWN);
        }
        return akrualproses.getOID();
    }

    public static long updateExc(AkrualProses akrualproses) throws CONException {
        try {
            if (akrualproses.getOID() != 0) {
                DbAkrualProses pstAkrualProses = new DbAkrualProses(akrualproses.getOID());

                pstAkrualProses.setDate(COL_REG_DATE, akrualproses.getRegDate());
                pstAkrualProses.setDouble(COL_JUMLAH, akrualproses.getJumlah());
                pstAkrualProses.setLong(COL_CREDIT_COA_ID, akrualproses.getCreditCoaId());
                pstAkrualProses.setLong(COL_DEBET_COA_ID, akrualproses.getDebetCoaId());
                pstAkrualProses.setLong(COL_PERIODE_ID, akrualproses.getPeriodeId());
                pstAkrualProses.setLong(COL_USER_ID, akrualproses.getUserId());
                pstAkrualProses.setLong(COL_AKRUAL_SETUP_ID, akrualproses.getAkrualSetupId());
                pstAkrualProses.setLong(COL_DEP_ID, akrualproses.getDepId());
                
                pstAkrualProses.setLong(COL_SEGMENT1_ID, akrualproses.getSegment1Id());
                pstAkrualProses.setLong(COL_SEGMENT2_ID, akrualproses.getSegment2Id());
                pstAkrualProses.setLong(COL_SEGMENT3_ID, akrualproses.getSegment3Id());
                pstAkrualProses.setLong(COL_SEGMENT4_ID, akrualproses.getSegment4Id());
                pstAkrualProses.setLong(COL_SEGMENT5_ID, akrualproses.getSegment5Id());
                pstAkrualProses.setLong(COL_SEGMENT6_ID, akrualproses.getSegment6Id());
                pstAkrualProses.setLong(COL_SEGMENT7_ID, akrualproses.getSegment7Id());
                pstAkrualProses.setLong(COL_SEGMENT8_ID, akrualproses.getSegment8Id());
                pstAkrualProses.setLong(COL_SEGMENT9_ID, akrualproses.getSegment9Id());
                pstAkrualProses.setLong(COL_SEGMENT10_ID, akrualproses.getSegment10Id());
                pstAkrualProses.setLong(COL_SEGMENT11_ID, akrualproses.getSegment11Id());
                pstAkrualProses.setLong(COL_SEGMENT12_ID, akrualproses.getSegment12Id());
                pstAkrualProses.setLong(COL_SEGMENT13_ID, akrualproses.getSegment13Id());
                pstAkrualProses.setLong(COL_SEGMENT14_ID, akrualproses.getSegment14Id());
                pstAkrualProses.setLong(COL_SEGMENT15_ID, akrualproses.getSegment15Id());

                pstAkrualProses.update();
                return akrualproses.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualProses(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbAkrualProses pstAkrualProses = new DbAkrualProses(oid);
            pstAkrualProses.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAkrualProses(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_AKRUAL_PROSES;
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
                AkrualProses akrualproses = new AkrualProses();
                resultToObject(rs, akrualproses);
                lists.add(akrualproses);
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

    private static void resultToObject(ResultSet rs, AkrualProses akrualproses) {
        try {
            akrualproses.setOID(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_PROSES_ID]));
            akrualproses.setRegDate(rs.getDate(DbAkrualProses.colNames[DbAkrualProses.COL_REG_DATE]));
            akrualproses.setJumlah(rs.getDouble(DbAkrualProses.colNames[DbAkrualProses.COL_JUMLAH]));
            akrualproses.setCreditCoaId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_CREDIT_COA_ID]));
            akrualproses.setDebetCoaId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_DEBET_COA_ID]));
            akrualproses.setPeriodeId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_PERIODE_ID]));
            akrualproses.setUserId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_USER_ID]));
            akrualproses.setAkrualSetupId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_SETUP_ID]));
            akrualproses.setDepId(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_DEP_ID]));
            
            akrualproses.setSegment1Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT1_ID]));
            akrualproses.setSegment2Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT2_ID]));
            akrualproses.setSegment3Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT3_ID]));
            akrualproses.setSegment4Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT4_ID]));
            akrualproses.setSegment5Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT5_ID]));
            akrualproses.setSegment6Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT6_ID]));
            akrualproses.setSegment7Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT7_ID]));
            akrualproses.setSegment8Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT8_ID]));
            akrualproses.setSegment9Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT9_ID]));
            akrualproses.setSegment10Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT10_ID]));
            akrualproses.setSegment11Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT11_ID]));
            akrualproses.setSegment12Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT12_ID]));
            akrualproses.setSegment13Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT13_ID]));
            akrualproses.setSegment14Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT14_ID]));
            akrualproses.setSegment15Id(rs.getLong(DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT15_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long akrualProsesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_AKRUAL_PROSES + " WHERE " +
                    DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_PROSES_ID] + " = " + akrualProsesId;

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

    public static int getCount(String whereClause){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_PROSES_ID] + ") FROM " + DB_AKRUAL_PROSES;
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
                    AkrualProses akrualproses = (AkrualProses) list.get(ls);
                    if (oid == akrualproses.getOID()) {
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

    public static double getTotalAkrual(long asId) {
        String sql = "SELECT sum(" + colNames[COL_JUMLAH] + ") FROM " + DB_AKRUAL_PROSES +
                " where year(" + colNames[COL_REG_DATE] + ")=" + JSPFormater.formatDate(new Date(), "yyyy") +
                " and " + colNames[COL_AKRUAL_SETUP_ID] + "=" + asId;

        CONResultSet crs = null;
        double result = 0;
        
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

    public static void postJournal(AkrualProses ap) {
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        AkrualSetup as = new AkrualSetup();
        try {
            as = DbAkrualSetup.fetchExc(ap.getAkrualSetupId());
        } catch (Exception e) {
        }

        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(ap.getPeriodeId());
        } catch (Exception e) {
        }
        
        User user = new User();
        try {
            user = DbUser.fetch(ap.getUserId());
        } catch(Exception e) {}

        if (ap.getOID() != 0) {
            int counter = DbSystemDocNumber.getNextCounterGl(p.getOID());
            String prefixNumber = DbSystemDocNumber.getNumberPrefixGl(p.getOID());
            String journalNumber = DbSystemDocNumber.getNextNumberGl(counter,p.getOID());

            long oid = DbGl.postJournalMain(0, new Date(), counter, journalNumber, prefixNumber, I_Project.JOURNAL_TYPE_AKRUAL,
                    "Jurnal Akrual - " + as.getNama() + " " + p.getName(), ap.getUserId(), user.getFullName(), ap.getOID(), "", ap.getRegDate());

            if (oid != 0) {
                try {
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(counter);
                    systemDocNumber.setPrefixNumber(prefixNumber);
                    systemDocNumber.setDocNumber(journalNumber);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setYear(new Date().getYear() + 1900);
                    
                    DbSystemDocNumber.insertExc(systemDocNumber);
                } catch(Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
                
                //journal debet pada expense
                DbGl.postJournalDetail(er.getValueIdr(), ap.getDebetCoaId(), 0, ap.getJumlah(), ap.getJumlah(), comp.getBookingCurrencyId(), oid, as.getNama() + " " + p.getName(), ap.getDepId());
                //journal credit pada cash
                DbGl.postJournalDetail(er.getValueIdr(), ap.getCreditCoaId(), ap.getJumlah(), 0, ap.getJumlah(), comp.getBookingCurrencyId(), oid, as.getNama() + " " + p.getName(), ap.getDepId());
            }
        }
    }
    
    public static void postJournal(AkrualProses ap,long periodeId) {
        
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        AkrualSetup as = new AkrualSetup();
        try {
            as = DbAkrualSetup.fetchExc(ap.getAkrualSetupId());
        } catch (Exception e) {}

        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(ap.getPeriodeId());
        } catch (Exception e) {
        }
        
        User user = new User();
        try {
            user = DbUser.fetch(ap.getUserId());
        } catch(Exception e) {}
        
        if (ap.getOID() != 0) {
            int counter = DbSystemDocNumber.getNextCounterGl(p.getOID());
            String prefixNumber = DbSystemDocNumber.getNumberPrefixGl(p.getOID());
            String journalNumber = DbSystemDocNumber.getNextNumberGl(counter,p.getOID());

            long oid = DbGl.postJournalMain(0, new Date(), counter, journalNumber, prefixNumber, I_Project.JOURNAL_TYPE_AKRUAL,
                    "Jurnal Akrual - " + as.getNama() + " " + p.getName(), ap.getUserId(), user.getFullName(), ap.getOID(), "", ap.getRegDate(),periodeId, ap.getOID());

            if (oid != 0) {
                try {
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(counter);
                    systemDocNumber.setPrefixNumber(prefixNumber);
                    systemDocNumber.setDocNumber(journalNumber);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setYear(new Date().getYear() + 1900);
                    
                    DbSystemDocNumber.insertExc(systemDocNumber);
                } catch(Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
                
                //journal debet pada expense
                DbGl.postJournalDetail(er.getValueIdr(), ap.getDebetCoaId(), 0, ap.getJumlah(), 
                                        ap.getJumlah(), comp.getBookingCurrencyId(), oid, as.getNama() + " " + p.getName(), ap.getDepId(),
                                        as.getSegment1Id(),as.getSegment2Id(),as.getSegment3Id(),as.getSegment4Id(),
                                        as.getSegment5Id(),as.getSegment6Id(),as.getSegment7Id(),as.getSegment8Id(),
                                        as.getSegment9Id(),as.getSegment10Id(),as.getSegment11Id(),as.getSegment12Id(),
                                        as.getSegment13Id(),as.getSegment14Id(),as.getSegment15Id(),0);
           
                //journal credit pada cash
                DbGl.postJournalDetail(er.getValueIdr(), ap.getCreditCoaId(), ap.getJumlah(), 0, 
                                        ap.getJumlah(), comp.getBookingCurrencyId(), oid, as.getNama() + " " + p.getName(), ap.getDepId(),
                                        as.getSegment1Id(),as.getSegment2Id(),as.getSegment3Id(),as.getSegment4Id(),
                                        as.getSegment5Id(),as.getSegment6Id(),as.getSegment7Id(),as.getSegment8Id(),
                                        as.getSegment9Id(),as.getSegment10Id(),as.getSegment11Id(),as.getSegment12Id(),
                                        as.getSegment13Id(),as.getSegment14Id(),as.getSegment15Id(),0);
            }
        }
    }
    
    public static void postJournal(AkrualProses ap,long periodeId,String memo) {
        
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        AkrualSetup as = new AkrualSetup();
        try {
            as = DbAkrualSetup.fetchExc(ap.getAkrualSetupId());
        } catch (Exception e) {}

        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(ap.getPeriodeId());
        } catch (Exception e) {
        }
        
        User user = new User();
        try {
            user = DbUser.fetch(ap.getUserId());
        } catch(Exception e) {}
        
        if (ap.getOID() != 0) {
            int counter = DbSystemDocNumber.getNextCounterGl(p.getOID());
            String prefixNumber = DbSystemDocNumber.getNumberPrefixGl(p.getOID());
            String journalNumber = DbSystemDocNumber.getNextNumberGl(counter,p.getOID());

            long oid = DbGl.postJournalMain(0, new Date(), counter, journalNumber, prefixNumber, I_Project.JOURNAL_TYPE_AKRUAL,
                    "Jurnal Akrual - " + memo + " " + p.getName(), ap.getUserId(), user.getFullName(), ap.getOID(), "", ap.getRegDate(),periodeId, ap.getOID());

            if (oid != 0) {
                try {
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(counter);
                    systemDocNumber.setPrefixNumber(prefixNumber);
                    systemDocNumber.setDocNumber(journalNumber);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setYear(new Date().getYear() + 1900);
                    
                    DbSystemDocNumber.insertExc(systemDocNumber);
                } catch(Exception e) {
                    System.out.println("[Exception] "+e.toString());
                }
                
                //journal debet pada expense
                DbGl.postJournalDetail(er.getValueIdr(), ap.getDebetCoaId(), 0, ap.getJumlah(), 
                                        ap.getJumlah(), comp.getBookingCurrencyId(), oid, memo + " " + p.getName(), ap.getDepId(),
                                        as.getSegment1Id(),as.getSegment2Id(),as.getSegment3Id(),as.getSegment4Id(),
                                        as.getSegment5Id(),as.getSegment6Id(),as.getSegment7Id(),as.getSegment8Id(),
                                        as.getSegment9Id(),as.getSegment10Id(),as.getSegment11Id(),as.getSegment12Id(),
                                        as.getSegment13Id(),as.getSegment14Id(),as.getSegment15Id(),0);
           
                //journal credit pada cash
                DbGl.postJournalDetail(er.getValueIdr(), ap.getCreditCoaId(), ap.getJumlah(), 0, 
                                        ap.getJumlah(), comp.getBookingCurrencyId(), oid, memo + " " + p.getName(), ap.getDepId(),
                                        as.getSegment1Id(),as.getSegment2Id(),as.getSegment3Id(),as.getSegment4Id(),
                                        as.getSegment5Id(),as.getSegment6Id(),as.getSegment7Id(),as.getSegment8Id(),
                                        as.getSegment9Id(),as.getSegment10Id(),as.getSegment11Id(),as.getSegment12Id(),
                                        as.getSegment13Id(),as.getSegment14Id(),as.getSegment15Id(),0);
            }
        }
    }
    
}
