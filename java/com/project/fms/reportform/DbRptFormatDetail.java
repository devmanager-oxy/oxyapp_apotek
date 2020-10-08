package com.project.fms.reportform;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class DbRptFormatDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_RPT_FORMAT_DETAIL = "rpt_format_detail";
    public static final int COL_RPT_FORMAT_DETAIL_ID = 0;
    public static final int COL_DESCRIPTION = 1;
    public static final int COL_LEVEL = 2;
    public static final int COL_REF_ID = 3;
    public static final int COL_TYPE = 4;
    public static final int COL_RPT_FORMAT_ID = 5;
    public static final int COL_SQUENCE = 6;
    public static final int COL_NEW_PAGE = 7;
    
    public static final String[] colNames = {
        "rpt_format_detail_id",
        "description",
        "level",
        "ref_id",
        "type",
        "rpt_format_id",
        "squence",
        "new_page"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_BOOL
    };
    
    public static final int RPT_TYPE_DATA = 0;
    public static final int RPT_TYPE_TOTAL = 1;
    public static final int RPT_TYPE_LABA_TAHUN_BERJALAN = 2;
    public static final int RPT_TYPE_LABA_TAHUN_LALU = 3;
    public static final int RPT_TYPE_MODAL = 4;
    public static String[][] strDetailType = {
        {},
        {"-", "Total", "Current Year Earning", "Last Year Earning", "Equity"},
        {"-", "Total", "Laba Tahun Berjalan", "Laba Tahun Lalu", "Modal/Ekuitas"}};

    public DbRptFormatDetail() {
    }

    public DbRptFormatDetail(int i) throws CONException {
        super(new DbRptFormatDetail());
    }

    public DbRptFormatDetail(String sOid) throws CONException {
        super(new DbRptFormatDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbRptFormatDetail(long lOid) throws CONException {
        super(new DbRptFormatDetail(0));
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
        return DB_RPT_FORMAT_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbRptFormatDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        RptFormatDetail rptformatdetail = fetchExc(ent.getOID());
        ent = (Entity) rptformatdetail;
        return rptformatdetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((RptFormatDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((RptFormatDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static RptFormatDetail fetchExc(long oid) throws CONException {
        try {
            RptFormatDetail rptformatdetail = new RptFormatDetail();
            DbRptFormatDetail pstRptFormatDetail = new DbRptFormatDetail(oid);
            rptformatdetail.setOID(oid);

            rptformatdetail.setDescription(pstRptFormatDetail.getString(COL_DESCRIPTION));
            rptformatdetail.setLevel(pstRptFormatDetail.getInt(COL_LEVEL));
            rptformatdetail.setRefId(pstRptFormatDetail.getlong(COL_REF_ID));
            rptformatdetail.setType(pstRptFormatDetail.getInt(COL_TYPE));
            rptformatdetail.setRptFormatId(pstRptFormatDetail.getlong(COL_RPT_FORMAT_ID));
            rptformatdetail.setSquence(pstRptFormatDetail.getInt(COL_SQUENCE));
            rptformatdetail.setNewPage(pstRptFormatDetail.getBoolean(COL_NEW_PAGE));

            return rptformatdetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptFormatDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(RptFormatDetail rptformatdetail) throws CONException {
        try {
            DbRptFormatDetail pstRptFormatDetail = new DbRptFormatDetail(0);

            pstRptFormatDetail.setString(COL_DESCRIPTION, rptformatdetail.getDescription());
            pstRptFormatDetail.setInt(COL_LEVEL, rptformatdetail.getLevel());
            pstRptFormatDetail.setLong(COL_REF_ID, rptformatdetail.getRefId());
            pstRptFormatDetail.setInt(COL_TYPE, rptformatdetail.getType());
            pstRptFormatDetail.setLong(COL_RPT_FORMAT_ID, rptformatdetail.getRptFormatId());
            pstRptFormatDetail.setInt(COL_SQUENCE, rptformatdetail.getSquence());
            pstRptFormatDetail.setBoolean(COL_NEW_PAGE, rptformatdetail.isNewPage());

            pstRptFormatDetail.insert();
            rptformatdetail.setOID(pstRptFormatDetail.getlong(COL_RPT_FORMAT_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptFormatDetail(0), CONException.UNKNOWN);
        }
        return rptformatdetail.getOID();
    }

    public static long updateExc(RptFormatDetail rptformatdetail) throws CONException {
        try {
            if (rptformatdetail.getOID() != 0) {
                DbRptFormatDetail pstRptFormatDetail = new DbRptFormatDetail(rptformatdetail.getOID());

                pstRptFormatDetail.setString(COL_DESCRIPTION, rptformatdetail.getDescription());
                pstRptFormatDetail.setInt(COL_LEVEL, rptformatdetail.getLevel());
                pstRptFormatDetail.setLong(COL_REF_ID, rptformatdetail.getRefId());
                pstRptFormatDetail.setInt(COL_TYPE, rptformatdetail.getType());
                pstRptFormatDetail.setLong(COL_RPT_FORMAT_ID, rptformatdetail.getRptFormatId());
                pstRptFormatDetail.setInt(COL_SQUENCE, rptformatdetail.getSquence());
                pstRptFormatDetail.setBoolean(COL_NEW_PAGE, rptformatdetail.isNewPage());

                pstRptFormatDetail.update();
                return rptformatdetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptFormatDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbRptFormatDetail pstRptFormatDetail = new DbRptFormatDetail(oid);
            pstRptFormatDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptFormatDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_RPT_FORMAT_DETAIL;
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
                RptFormatDetail rptformatdetail = new RptFormatDetail();
                resultToObject(rs, rptformatdetail);
                lists.add(rptformatdetail);
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

    private static void resultToObject(ResultSet rs, RptFormatDetail rptformatdetail) {
        try {
            rptformatdetail.setOID(rs.getLong(colNames[COL_RPT_FORMAT_DETAIL_ID]));
            rptformatdetail.setDescription(rs.getString(colNames[COL_DESCRIPTION]));
            rptformatdetail.setLevel(rs.getInt(colNames[COL_LEVEL]));
            rptformatdetail.setRefId(rs.getLong(colNames[COL_REF_ID]));
            rptformatdetail.setType(rs.getInt(colNames[COL_TYPE]));
            rptformatdetail.setRptFormatId(rs.getLong(colNames[COL_RPT_FORMAT_ID]));
            rptformatdetail.setSquence(rs.getInt(colNames[COL_SQUENCE]));
            rptformatdetail.setNewPage(rs.getBoolean(colNames[COL_NEW_PAGE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long rptFormatDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_RPT_FORMAT_DETAIL + " WHERE " +
                    DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_DETAIL_ID] + " = " + rptFormatDetailId;

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
            String sql = "SELECT COUNT(" + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_DETAIL_ID] + ") FROM " + DB_RPT_FORMAT_DETAIL;
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
                    RptFormatDetail rptformatdetail = (RptFormatDetail) list.get(ls);
                    if (oid == rptformatdetail.getOID()) {
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
    
    /**
     * Get parent level
     * create by gwawan 082012
     * @param parentlId
     * @return
     */
    public static int getParentLevel(long parentlId) {
        int level = 0;
        
        try {
            RptFormatDetail parent = fetchExc(parentlId);
            level = parent.getLevel();
        } catch(Exception e) {
            System.out.println("[ERROR] getParentLevel(#) "+e.toString());
        }
        
        return level;
    }
}
