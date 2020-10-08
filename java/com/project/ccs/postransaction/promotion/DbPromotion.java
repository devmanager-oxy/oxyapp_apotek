package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.promotion.*;
import com.project.I_Project;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbExchangeRate;
import com.project.general.ExchangeRate;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;

public class DbPromotion extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_PROMOTION = "pos_promotion";
    public static final int COL_PROMOTION_ID = 0;
    public static final int COL_START_DATE = 1;
    public static final int COL_END_DATE = 2;
    public static final int COL_USER_ID = 3;
    public static final int COL_USER_NAME = 4;
    public static final int COL_PROMO_DESC = 5;
    public static final int COL_COUNTER = 6;
    public static final int COL_NUMBER = 7;
    public static final int COL_STATUS = 8;
    public static final int COL_PREFIX_NUMBER = 9;
    public static final int COL_TIPE = 10;
    public static final int COL_JENIS = 11;
    
    public static final String[] colNames = {
        "promotion_id",
        "start_date",
        "end_date",
        "user_id",
        "user_name",
        "promo_desc",
        "counter",
        "number",
        "status",
        "prefix_number",
        "tipe",
        "jenis"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT
    };

    public DbPromotion() {
    }

    public DbPromotion(int i) throws CONException {
        super(new DbPromotion());
    }

    public DbPromotion(String sOid) throws CONException {
        super(new DbPromotion(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPromotion(long lOid) throws CONException {
        super(new DbPromotion(0));
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
        return DB_POS_PROMOTION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPromotion().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Promotion promotion = fetchExc(ent.getOID());
        ent = (Entity) promotion;
        return promotion.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Promotion) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Promotion) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Promotion fetchExc(long oid) throws CONException {
        try {
            Promotion promotion = new Promotion();
            DbPromotion pstPromotion = new DbPromotion(oid);
            promotion.setOID(oid);

            promotion.setStartDate(pstPromotion.getDate(COL_START_DATE));
            promotion.setEndDate(pstPromotion.getDate(COL_END_DATE));
            promotion.setUserId(pstPromotion.getlong(COL_USER_ID));
            promotion.setUserName(pstPromotion.getString(COL_USER_NAME));
            promotion.setPromoDesc(pstPromotion.getString(COL_PROMO_DESC));
            promotion.setCounter(pstPromotion.getInt(COL_COUNTER));
            promotion.setNumber(pstPromotion.getString(COL_NUMBER));
            promotion.setStatus(pstPromotion.getString(COL_STATUS));
            promotion.setPrefixNumber(pstPromotion.getString(COL_PREFIX_NUMBER));
            promotion.setTipe(pstPromotion.getInt(COL_TIPE));
            promotion.setJenis(pstPromotion.getInt(COL_JENIS));
            return promotion;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotion(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Promotion promotion) throws CONException {
        try {
            DbPromotion pstPromotion = new DbPromotion(0);

            pstPromotion.setDate(COL_START_DATE, promotion.getStartDate());
            pstPromotion.setDate(COL_END_DATE, promotion.getEndDate());
            pstPromotion.setLong(COL_USER_ID, promotion.getUserId());
            pstPromotion.setString(COL_USER_NAME, promotion.getUserName());
            pstPromotion.setString(COL_PROMO_DESC, promotion.getPromoDesc());
            pstPromotion.setInt(COL_COUNTER, promotion.getCounter());
            pstPromotion.setString(COL_NUMBER, promotion.getNumber());
            pstPromotion.setString(COL_STATUS, promotion.getStatus());
            pstPromotion.setString(COL_PREFIX_NUMBER, promotion.getPrefixNumber());
            pstPromotion.setInt(COL_JENIS, promotion.getJenis());
            pstPromotion.setInt(COL_TIPE, promotion.getTipe());
            
            pstPromotion.insert();
            
            promotion.setOID(pstPromotion.getlong(COL_PROMOTION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotion(0), CONException.UNKNOWN);
        }
        return promotion.getOID();
    }

    public static long updateExc(Promotion promotion) throws CONException {
        try {
            if (promotion.getOID() != 0) {
                DbPromotion pstPromotion = new DbPromotion(promotion.getOID());

                pstPromotion.setDate(COL_START_DATE, promotion.getStartDate());
                pstPromotion.setDate(COL_END_DATE, promotion.getEndDate());
                pstPromotion.setLong(COL_USER_ID, promotion.getUserId());
                pstPromotion.setString(COL_USER_NAME, promotion.getUserName());
                pstPromotion.setString(COL_PROMO_DESC, promotion.getPromoDesc());
                pstPromotion.setInt(COL_COUNTER, promotion.getCounter());
                pstPromotion.setString(COL_NUMBER, promotion.getNumber());
                pstPromotion.setString(COL_STATUS, promotion.getStatus());
                pstPromotion.setString(COL_PREFIX_NUMBER, promotion.getPrefixNumber());
                pstPromotion.setInt(COL_JENIS, promotion.getJenis());
                pstPromotion.setInt(COL_TIPE, promotion.getTipe());
                pstPromotion.update();
                return promotion.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotion(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPromotion pstPromotion = new DbPromotion(oid);
            pstPromotion.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotion(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_PROMOTION;
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
                Promotion promotion = new Promotion();
                resultToObject(rs, promotion);
                lists.add(promotion);
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

    private static void resultToObject(ResultSet rs, Promotion promotion) {
        try {
            promotion.setOID(rs.getLong(DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]));
            promotion.setStartDate(rs.getDate(DbPromotion.colNames[DbPromotion.COL_START_DATE]));
            promotion.setEndDate(rs.getDate(DbPromotion.colNames[DbPromotion.COL_END_DATE]));
            promotion.setUserId(rs.getLong(DbPromotion.colNames[DbPromotion.COL_USER_ID]));
            promotion.setUserName(rs.getString(DbPromotion.colNames[DbPromotion.COL_USER_NAME]));
            promotion.setPromoDesc(rs.getString(DbPromotion.colNames[DbPromotion.COL_PROMO_DESC]));
            promotion.setCounter(rs.getInt(DbPromotion.colNames[DbPromotion.COL_COUNTER]));
            promotion.setNumber(rs.getString(DbPromotion.colNames[DbPromotion.COL_NUMBER]));
            promotion.setStatus(rs.getString(DbPromotion.colNames[DbPromotion.COL_STATUS]));
            promotion.setPrefixNumber(rs.getString(DbPromotion.colNames[DbPromotion.COL_PREFIX_NUMBER]));
            promotion.setJenis(rs.getInt(DbPromotion.colNames[DbPromotion.COL_JENIS]));
            promotion.setTipe(rs.getInt(DbPromotion.colNames[DbPromotion.COL_TIPE]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long costingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_PROMOTION + " WHERE " +
                    DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID] + " = " + costingId;

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
            String sql = "SELECT COUNT(" + DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID] + ") FROM " + DB_POS_PROMOTION;
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
                    Promotion promotion = (Promotion) list.get(ls);
                    if (oid == promotion.getOID()) {
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

   public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_PROMOTION + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix() {
        String code = "";
        
        code = code + "PRM";

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr) {

        String code = getNumberPrefix();

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }
        return code;
    }
    
    
}
