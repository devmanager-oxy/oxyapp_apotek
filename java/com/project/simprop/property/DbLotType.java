/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class DbLotType extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_LOT_TYPE = "prop_lot_type";
    
    public static final int COL_LOT_TYPE_ID = 0;
    public static final int COL_AMOUNT_HARD_CASH = 1;
    public static final int COL_AMOUNT_CASH_BY_TERMIN = 2;
    public static final int COL_AMOUNT_KPA = 3;    
    public static final int COL_LOT_TYPE = 4;    
    public static final int COL_RENTAL_RATE = 5;
    public static final int COL_SALES_TYPE = 6;
    public static final int COL_NAME_PIC = 7;
    
     public static final String[] colNames = {
        "lot_type_id",
        "amount_hard_cash",
        "amount_cash_by_termin",
        "amount_kpr",
        "lot_type",
        "rental_rate",
        "sales_type",
        "name_pic"
     };    
     
      public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT ,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING
    };     
      
    public static final int TYPE_MAWAR = 0;
    public static final int TYPE_KAMBOJA = 1;
    public static final int TYPE_MELATI = 2;
    public static final int[] typeValue = {0,1,2};
    public static final String[] typeKey = {"Type Mawar", "Type Kamboja","Type Melati"};
    
    public static final int TYPE_SALE_SELLABLE = 0;
    public static final int TYPE_SALE_RENTABBLE = 1;
    
    public static final int[] typeSellValue = {0,1};
    public static final String[] typeSellKey = {"Sellable", "Rent-able"};
    
    public DbLotType() {
    }

    public DbLotType(int i) throws CONException {
        super(new DbLotType());
    }

    public DbLotType(String sOid) throws CONException {
        super(new DbLotType(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLotType(long lOid) throws CONException {
        super(new DbLotType(0));
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
        return DB_LOT_TYPE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLotType().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LotType lotType = fetchExc(ent.getOID());
        ent = (Entity) lotType;
        return lotType.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LotType) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LotType) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static LotType fetchExc(long oid) throws CONException {
        try {
            LotType lotType = new LotType();
            DbLotType pstLotType = new DbLotType(oid);            
            lotType.setOID(oid);
            
            lotType.setAmountHardCash(pstLotType.getdouble(COL_AMOUNT_HARD_CASH));
            lotType.setAmountCashByTermin(pstLotType.getdouble(COL_AMOUNT_CASH_BY_TERMIN));
            lotType.setAmountKPA(pstLotType.getdouble(COL_AMOUNT_KPA));
            lotType.setLotType(pstLotType.getString(COL_LOT_TYPE));
            lotType.setRentalRate(pstLotType.getdouble(COL_RENTAL_RATE));
            lotType.setSalesType(pstLotType.getInt(COL_SALES_TYPE));
            lotType.setNamePic(pstLotType.getString(COL_NAME_PIC));

            return lotType;
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotType(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LotType lotType) throws CONException {
        try {
            DbLotType pstLotTye = new DbLotType(0);
            
            pstLotTye.setDouble(COL_AMOUNT_HARD_CASH, lotType.getAmountHardCash());
            pstLotTye.setDouble(COL_AMOUNT_CASH_BY_TERMIN, lotType.getAmountCashByTermin());
            pstLotTye.setDouble(COL_AMOUNT_KPA, lotType.getAmountKPA());
            pstLotTye.setString(COL_LOT_TYPE, lotType.getLotType());           
            pstLotTye.setDouble(COL_RENTAL_RATE, lotType.getRentalRate());           
            pstLotTye.setInt(COL_SALES_TYPE, lotType.getSalesType());           
            pstLotTye.setString(COL_NAME_PIC, lotType.getNamePic());           
           
            pstLotTye.insert();
            lotType.setOID(pstLotTye.getlong(COL_LOT_TYPE_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotType(0), CONException.UNKNOWN);
        }
        return lotType.getOID();
    }

    public static long updateExc(LotType lotType) throws CONException {
        try {
            if (lotType.getOID() != 0) {
                DbLotType pstLotType = new DbLotType(lotType.getOID());
                
                pstLotType.setDouble(COL_AMOUNT_HARD_CASH, lotType.getAmountHardCash());
                pstLotType.setDouble(COL_AMOUNT_CASH_BY_TERMIN, lotType.getAmountCashByTermin());
                pstLotType.setDouble(COL_AMOUNT_KPA, lotType.getAmountKPA());
                pstLotType.setString(COL_LOT_TYPE, lotType.getLotType());           
                pstLotType.setDouble(COL_RENTAL_RATE, lotType.getRentalRate());           
                pstLotType.setInt(COL_SALES_TYPE, lotType.getSalesType());           
                pstLotType.setString(COL_NAME_PIC, lotType.getNamePic());

                pstLotType.update();
                return lotType.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotType(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLotType pstLotTye = new DbLotType(oid);
            pstLotTye.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotType(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOT_TYPE;
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
                LotType lotType = new LotType();
                resultToObject(rs, lotType);
                lists.add(lotType);
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

    private static void resultToObject(ResultSet rs, LotType lotType) {
        try {
            
            lotType.setOID(rs.getLong(DbLotType.colNames[DbLotType.COL_LOT_TYPE_ID]));
            lotType.setAmountHardCash(rs.getDouble(DbLotType.colNames[DbLotType.COL_AMOUNT_HARD_CASH]));
            lotType.setAmountCashByTermin(rs.getDouble(DbLotType.colNames[DbLotType.COL_AMOUNT_CASH_BY_TERMIN]));
            lotType.setAmountKPA(rs.getDouble(DbLotType.colNames[DbLotType.COL_AMOUNT_KPA]));
            lotType.setLotType(rs.getString(DbLotType.colNames[DbLotType.COL_LOT_TYPE]));            
            lotType.setRentalRate(rs.getDouble(DbLotType.colNames[DbLotType.COL_RENTAL_RATE]));
            lotType.setSalesType(rs.getInt(DbLotType.colNames[DbLotType.COL_SALES_TYPE]));
            lotType.setNamePic(rs.getString(DbLotType.colNames[DbLotType.COL_NAME_PIC]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotTypeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT_TYPE + " WHERE " +
                    DbLotType.colNames[DbLotType.COL_LOT_TYPE_ID] + " = " + lotTypeId;

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
            String sql = "SELECT COUNT(" + DbLotType.colNames[DbLotType.COL_LOT_TYPE_ID] + ") FROM " + DB_LOT_TYPE;
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
                    LotType lotType = (LotType) list.get(ls);
                    if (oid == lotType.getOID()) {
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
