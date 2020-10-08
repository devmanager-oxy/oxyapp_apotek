package com.project.ccs.postransaction.opname;

import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;

public class DbOpnameItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_OPNAME_ITEM = "pos_opname_item";
    public static final int COL_OPNAME_ITEM_ID = 0;
    public static final int COL_OPNAME_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY_SYSTEM = 3;
    public static final int COL_QTY_REAL = 4;
    //public static final  int COL_AMOUNT = 5;
    public static final  int COL_NOTE = 5;
    public static final int COL_TYPE = 6;
    public static final int COL_SUB_LOCATION_ID = 7;
    public static final int COL_OPNAME_SUB_LOCATION_ID = 8;
    public static final int COL_DATE = 9;
    
    public static final String[] colNames = {
        "opname_item_id",
        "opname_id",
        "item_master_id",
        "qty_system",
        "qty_real",
        "note",
        "type",
        "sub_location_id",
        "opname_sub_location_id",
        "date"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE
    };

    public static final int TYPE_NON_CONSIGMENT =0;
    public static final int TYPE_CONSIGMENT =1;
    
    public DbOpnameItem() {
    }

    public DbOpnameItem(int i) throws CONException {
        super(new DbOpnameItem());
    }

    public DbOpnameItem(String sOid) throws CONException {
        super(new DbOpnameItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbOpnameItem(long lOid) throws CONException {
        super(new DbOpnameItem(0));
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
        return DB_POS_OPNAME_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbOpnameItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        OpnameItem opnameitem = fetchExc(ent.getOID());
        ent = (Entity) opnameitem;
        return opnameitem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((OpnameItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((OpnameItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static OpnameItem fetchExc(long oid) throws CONException {
        try {
            OpnameItem opnameitem = new OpnameItem();
            DbOpnameItem pstOpnameItem = new DbOpnameItem(oid);
            opnameitem.setOID(oid);

            opnameitem.setOpnameId(pstOpnameItem.getlong(COL_OPNAME_ID));
            opnameitem.setItemMasterId(pstOpnameItem.getlong(COL_ITEM_MASTER_ID));
            opnameitem.setQtySystem(pstOpnameItem.getdouble(COL_QTY_SYSTEM));
            opnameitem.setQtyReal(pstOpnameItem.getdouble(COL_QTY_REAL));
            // opnameitem.setAmount(pstOpnameItem.getdouble(COL_AMOUNT));
            opnameitem.setNote(pstOpnameItem.getString(COL_NOTE));
            opnameitem.setType(pstOpnameItem.getInt(COL_TYPE));
            opnameitem.setSubLocationId(pstOpnameItem.getlong(COL_SUB_LOCATION_ID));
            opnameitem.setOpnameSubLocationId(pstOpnameItem.getlong(COL_OPNAME_SUB_LOCATION_ID));
            opnameitem.setDate(pstOpnameItem.getDate(COL_DATE));
            return opnameitem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(OpnameItem opnameitem) throws CONException {
        try {
            DbOpnameItem pstOpnameItem = new DbOpnameItem(0);

            pstOpnameItem.setLong(COL_OPNAME_ID, opnameitem.getOpnameId());
            pstOpnameItem.setLong(COL_ITEM_MASTER_ID, opnameitem.getItemMasterId());
            pstOpnameItem.setDouble(COL_QTY_SYSTEM, opnameitem.getQtySystem());
            pstOpnameItem.setDouble(COL_QTY_REAL, opnameitem.getQtyReal());
            // pstOpnameItem.setDouble(COL_AMOUNT, opnameitem.getAmount());
            pstOpnameItem.setString(COL_NOTE, opnameitem.getNote());
            pstOpnameItem.setInt(COL_TYPE, opnameitem.getType());
            pstOpnameItem.setLong(COL_SUB_LOCATION_ID, opnameitem.getSubLocationId());
            pstOpnameItem.setLong(COL_OPNAME_SUB_LOCATION_ID, opnameitem.getOpnameSubLocationId());
            pstOpnameItem.setDate(COL_DATE, opnameitem.getDate());
            pstOpnameItem.insert();
            opnameitem.setOID(pstOpnameItem.getlong(COL_OPNAME_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameItem(0), CONException.UNKNOWN);
        }
        return opnameitem.getOID();
    }

    public static long updateExc(OpnameItem opnameitem) throws CONException {
        try {
            if (opnameitem.getOID() != 0) {
                DbOpnameItem pstOpnameItem = new DbOpnameItem(opnameitem.getOID());

                pstOpnameItem.setLong(COL_OPNAME_ID, opnameitem.getOpnameId());
                pstOpnameItem.setLong(COL_ITEM_MASTER_ID, opnameitem.getItemMasterId());
                pstOpnameItem.setDouble(COL_QTY_REAL, opnameitem.getQtyReal());
                pstOpnameItem.setDouble(COL_QTY_SYSTEM, opnameitem.getQtySystem());
                // pstOpnameItem.setDouble(COL_AMOUNT, opnameitem.getAmount());
                pstOpnameItem.setString(COL_NOTE, opnameitem.getNote());
                pstOpnameItem.setInt(COL_TYPE, opnameitem.getType());
                pstOpnameItem.setLong(COL_SUB_LOCATION_ID, opnameitem.getSubLocationId());
                pstOpnameItem.setLong(COL_OPNAME_SUB_LOCATION_ID, opnameitem.getOpnameSubLocationId());
                pstOpnameItem.setDate(COL_DATE, opnameitem.getDate());
                pstOpnameItem.update();
                return opnameitem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbOpnameItem pstOpnameItem = new DbOpnameItem(oid);
            pstOpnameItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_OPNAME_ITEM;
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
                OpnameItem opnameitem = new OpnameItem();
                resultToObject(rs, opnameitem);
                lists.add(opnameitem);
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

    private static void resultToObject(ResultSet rs, OpnameItem opnameitem) {
        try {
            opnameitem.setOID(rs.getLong(DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID]));
            opnameitem.setOpnameId(rs.getLong(DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID]));
            opnameitem.setItemMasterId(rs.getLong(DbOpnameItem.colNames[DbOpnameItem.COL_ITEM_MASTER_ID]));
            opnameitem.setQtyReal(rs.getDouble(DbOpnameItem.colNames[DbOpnameItem.COL_QTY_REAL]));
            opnameitem.setQtySystem(rs.getDouble(DbOpnameItem.colNames[DbOpnameItem.COL_QTY_SYSTEM]));
        // opnameitem.setAmount(rs.getDouble(DbOpnameItem.colNames[DbOpnameItem.COL_AMOUNT]));
            opnameitem.setNote(rs.getString(DbOpnameItem.colNames[DbOpnameItem.COL_NOTE]));
            opnameitem.setType(rs.getInt(DbOpnameItem.colNames[DbOpnameItem.COL_TYPE]));
            opnameitem.setSubLocationId(rs.getLong(DbOpnameItem.colNames[DbOpnameItem.COL_SUB_LOCATION_ID]));
            opnameitem.setOpnameSubLocationId(rs.getLong(DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_SUB_LOCATION_ID]));
            opnameitem.setDate(rs.getDate(DbOpnameItem.colNames[DbOpnameItem.COL_DATE]));
        } catch (Exception e) {
            System.out.println("Err >>> "+e.toString());
        }
    }

    public static boolean checkOID(long opnameItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_OPNAME_ITEM + " WHERE " +
                    DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID] + " = " + opnameItemId;

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

    public static double getTotalQtyOpname(long opnameId, String colNames) {
        CONResultSet dbrs = null;
        double totalQty = 0.0; 
        try {
            String sql = "SELECT SUM("+colNames+") as TOTALQTY FROM " + DB_POS_OPNAME_ITEM + " WHERE " +
                    DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID] + " = " + opnameId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                totalQty = rs.getDouble("TOTALQTY");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return totalQty;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID] + ") FROM " + DB_POS_OPNAME_ITEM;
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
    public static int getCountOpnameItem(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + DbOpnameItem.colNames[DbOpnameItem.COL_ITEM_MASTER_ID] + " FROM " + DB_POS_OPNAME_ITEM;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = count + 1;
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    
     public static double getTotalQty(long itemMasterId, long opnameId, long subLocationId){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT sum(" + DbOpnameItem.colNames[DbOpnameItem.COL_QTY_REAL] + ") as tot FROM " + DB_POS_OPNAME_ITEM +
                    " where " +DbOpnameItem.colNames[DbOpnameItem.COL_ITEM_MASTER_ID]+ "=" + itemMasterId +
                    " and " + DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID] + "=" + opnameId + 
                    " and " + DbOpnameItem.colNames[DbOpnameItem.COL_SUB_LOCATION_ID] + "=" + subLocationId +
                    " group by " + DbOpnameItem.colNames[DbOpnameItem.COL_ITEM_MASTER_ID];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
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
                    OpnameItem opnameitem = (OpnameItem) list.get(ls);
                    if (oid == opnameitem.getOID()) {
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
    
    
   // public static int deleteAllItem(long oidOpname){
        
     //   int result = 0;
        
    //    String sql = "delete from "+DB_POS_OPNAME_ITEM+" where "+colNames[COL_OPNAME_ID]+" = "+oidOpname;
     //   try{
     //       CONHandler.execUpdate(sql);
     //   }
    //    catch(Exception e){
     //       result = -1;
    //    }
        
     //   return result;
   // }
    
     public static int deleteItem(long oidOpnameSub){
        
        int result = 0;
        
        String sql = "delete from "+DB_POS_OPNAME_ITEM+" where "+colNames[COL_OPNAME_SUB_LOCATION_ID]+" = "+oidOpnameSub;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
    public static void proceedStock(Opname opname){
        
        //System.out.println("in inserting stock - opname ...");    
            
        Vector temp = DbOpnameItem.list(0,0, colNames[COL_OPNAME_ID]+"="+opname.getOID(), "");
        
        //System.out.println("temp : "+temp);    
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                OpnameItem ri = (OpnameItem)temp.get(i);                
                DbStock.insertOpnameGoods(opname, ri);                
            }            
        }
        
    } 
    
    public static OpnameItem getOpnameItem(long opnameOID, long itemOID){
        
        Vector v = list(0,0, colNames[COL_OPNAME_ID]+"="+opnameOID+" and "+colNames[COL_ITEM_MASTER_ID]+"="+itemOID, "");
        
        if(v!=null && v.size()>0){
            return (OpnameItem)v.get(0);
        }
        
        return new OpnameItem();
        
    }
    
    
    
}
