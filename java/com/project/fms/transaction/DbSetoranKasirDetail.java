/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

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
import com.project.system.*;
import com.project.util.*;
import com.project.fms.master.*;
import com.project.fms.*;
import com.project.*;
/**
 *
 * @author Roy
 */
public class DbSetoranKasirDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_SETORAN_KASIR_DETAIL = "setoran_kasir_detail";
    
    public static final int COL_SETORAN_KASIR_DETAIL_ID = 0;
    public static final int COL_SETORAN_KASIR_ID = 1;    
    public static final int COL_TANGGAL = 2;    
    public static final int COL_CASH = 3;
    public static final int COL_CARD = 4;
    public static final int COL_CASH_BACK = 5;
    public static final int COL_SETORAN_TOKO = 6;
    public static final int COL_SELISIH = 7;    
    public static final int COL_COA_ID = 8;  
    public static final int COL_SYSTEM = 9;  
    
    public static final String[] colNames = {
        "setoran_kasir_detail_id",
        "setoran_kasir_id",
        "tanggal",
        "cash",
        "card",
        "cash_back",
        "setoran_toko",        
        "selisih",
        "coa_id",
        "system"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT
    };

    public DbSetoranKasirDetail() {
    }

    public DbSetoranKasirDetail(int i) throws CONException {
        super(new DbSetoranKasirDetail());
    }

    public DbSetoranKasirDetail(String sOid) throws CONException {
        super(new DbSetoranKasirDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSetoranKasirDetail(long lOid) throws CONException {
        super(new DbSetoranKasirDetail(0));
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
        return DB_SETORAN_KASIR_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSetoranKasirDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SetoranKasirDetail setoranKasirDetail = fetchExc(ent.getOID());
        ent = (Entity) setoranKasirDetail;
        return setoranKasirDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SetoranKasirDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SetoranKasirDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SetoranKasirDetail fetchExc(long oid) throws CONException {
        try {
            SetoranKasirDetail setoranKasirDetail = new SetoranKasirDetail();
            DbSetoranKasirDetail dbSetoranKasirDetail = new DbSetoranKasirDetail(oid);
            setoranKasirDetail.setOID(oid);

            setoranKasirDetail.setSetoranKasirId(dbSetoranKasirDetail.getlong(COL_SETORAN_KASIR_ID));
            setoranKasirDetail.setTanggal(dbSetoranKasirDetail.getDate(COL_TANGGAL));
            setoranKasirDetail.setCash(dbSetoranKasirDetail.getdouble(COL_CASH));
            setoranKasirDetail.setCard(dbSetoranKasirDetail.getdouble(COL_CARD));
            setoranKasirDetail.setCashBack(dbSetoranKasirDetail.getdouble(COL_CASH_BACK));
            setoranKasirDetail.setSetoranToko(dbSetoranKasirDetail.getdouble(COL_SETORAN_TOKO));
            setoranKasirDetail.setSelisih(dbSetoranKasirDetail.getdouble(COL_SELISIH));
            setoranKasirDetail.setCoaId(dbSetoranKasirDetail.getlong(COL_COA_ID));
            setoranKasirDetail.setSystem(dbSetoranKasirDetail.getdouble(COL_SYSTEM));
            return setoranKasirDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasirDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SetoranKasirDetail setoranKasirDetail) throws CONException {
        try {
            DbSetoranKasirDetail dbSetoranKasirDetail = new DbSetoranKasirDetail(0);

            dbSetoranKasirDetail.setLong(COL_SETORAN_KASIR_ID, setoranKasirDetail.getSetoranKasirId());
            dbSetoranKasirDetail.setDate(COL_TANGGAL, setoranKasirDetail.getTanggal());
            dbSetoranKasirDetail.setDouble(COL_CASH, setoranKasirDetail.getCash());
            dbSetoranKasirDetail.setDouble(COL_CARD, setoranKasirDetail.getCard());
            dbSetoranKasirDetail.setDouble(COL_CASH_BACK, setoranKasirDetail.getCashBack());
            dbSetoranKasirDetail.setDouble(COL_SETORAN_TOKO, setoranKasirDetail.getSetoranToko());
            dbSetoranKasirDetail.setDouble(COL_SELISIH, setoranKasirDetail.getSelisih());
            dbSetoranKasirDetail.setLong(COL_COA_ID, setoranKasirDetail.getCoaId());
            dbSetoranKasirDetail.setDouble(COL_SYSTEM, setoranKasirDetail.getSystem());
            dbSetoranKasirDetail.insert();
            setoranKasirDetail.setOID(dbSetoranKasirDetail.getlong(COL_SETORAN_KASIR_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasirDetail(0), CONException.UNKNOWN);
        }
        return setoranKasirDetail.getOID();
    }

    public static long updateExc(SetoranKasirDetail setoranKasirDetail) throws CONException {
        try {
            if (setoranKasirDetail.getOID() != 0) {
                DbSetoranKasirDetail dbSetoranKasirDetail = new DbSetoranKasirDetail(setoranKasirDetail.getOID());

                dbSetoranKasirDetail.setLong(COL_SETORAN_KASIR_ID, setoranKasirDetail.getSetoranKasirId());
                dbSetoranKasirDetail.setDate(COL_TANGGAL, setoranKasirDetail.getTanggal());
                dbSetoranKasirDetail.setDouble(COL_CASH, setoranKasirDetail.getCash());
                dbSetoranKasirDetail.setDouble(COL_CARD, setoranKasirDetail.getCard());
                dbSetoranKasirDetail.setDouble(COL_CASH_BACK, setoranKasirDetail.getCashBack());
                dbSetoranKasirDetail.setDouble(COL_SETORAN_TOKO, setoranKasirDetail.getSetoranToko());
                dbSetoranKasirDetail.setDouble(COL_SELISIH, setoranKasirDetail.getSelisih());
                dbSetoranKasirDetail.setLong(COL_COA_ID, setoranKasirDetail.getCoaId());
                dbSetoranKasirDetail.setDouble(COL_SYSTEM, setoranKasirDetail.getSystem());
                dbSetoranKasirDetail.update();
                return setoranKasirDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasirDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSetoranKasirDetail dbSetoranKasir = new DbSetoranKasirDetail(oid);
            dbSetoranKasir.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasirDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SETORAN_KASIR_DETAIL;
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
                SetoranKasirDetail setoranKasirDetail = new SetoranKasirDetail();
                resultToObject(rs, setoranKasirDetail);
                lists.add(setoranKasirDetail);
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

    private static void resultToObject(ResultSet rs, SetoranKasirDetail setoranKasirDetail) {
        try {
            setoranKasirDetail.setOID(rs.getLong(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_DETAIL_ID]));
            setoranKasirDetail.setSetoranKasirId(rs.getLong(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_ID]));
            setoranKasirDetail.setTanggal(rs.getDate(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_TANGGAL]));
            setoranKasirDetail.setCash(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_CASH]));
            setoranKasirDetail.setCard(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_CARD]));
            setoranKasirDetail.setCashBack(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_CASH_BACK]));
            setoranKasirDetail.setSetoranToko(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_TOKO]));
            setoranKasirDetail.setSelisih(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SELISIH]));
            setoranKasirDetail.setCoaId(rs.getLong(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_COA_ID]));
            setoranKasirDetail.setSystem(rs.getDouble(DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SYSTEM]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long setoranId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SETORAN_KASIR_DETAIL + " WHERE " +
                    DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_ID] + " = " + setoranId;
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
            String sql = "SELECT COUNT(" + DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_ID] + ") FROM " + DB_SETORAN_KASIR_DETAIL;
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
    
    public static void getDelete(long kasirId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from "+DbSetoranKasirDetail.DB_SETORAN_KASIR_DETAIL+" where "+DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_ID]+" = "+kasirId;           
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            
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
                    SetoranKasirDetail setoranKasirDetail = (SetoranKasirDetail) list.get(ls);
                    if (oid == setoranKasirDetail.getOID()) {
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
    
    public static double getTotalSelisih(long setoranKasirId){
        CONResultSet dbrs = null;
        double selisih = 0;
        try{
            String sql ="select sum(selisih) as sum_selisih from (select setoran_toko,system,setoran_toko - system as selisih from setoran_kasir_detail where setoran_kasir_id = "+setoranKasirId+" ) as x";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                selisih = rs.getDouble("sum_selisih");
            }
            
        }catch (Exception e) {
            
        } finally {
            CONResultSet.close(dbrs);
        }
        
        
        return selisih;
    }

}
