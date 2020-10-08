package com.project.ccs.postransaction.opname;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.general.Company;
import com.project.general.DbCompany;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.util.Date;

public class DbClosingOpname extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_CLOSING_OPNAME = "pos_closing_opname";
    public static final int COL_CLOSING_OPNAME_ID = 0;
        public static final int COL_DATE = 1;
    public static final int COL_LOCATION_ID = 2;
    public static final int COL_ITEM_MASTER_ID = 3;
    public static final int COL_QTY = 4;
    public static final int COL_OPNAME_ID = 5;
    public static final int COL_HPP = 6;
    public static final int COL_HARGA_JUAL = 7;
    
    
    public static final String[] colNames = {
        "closing_opname_id",
        "date",
        "location_id",
        "item_master_id",
        "qty",
        "opname_id",
        "hpp",
        "harga_jual"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
        
    };

    
    
    public DbClosingOpname() {
    }

    public DbClosingOpname(int i) throws CONException {
        super(new DbClosingOpname());
    }

    public DbClosingOpname(String sOid) throws CONException {
        super(new DbClosingOpname(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbClosingOpname(long lOid) throws CONException {
        super(new DbClosingOpname(0));
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
        return DB_POS_CLOSING_OPNAME;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbClosingOpname().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ClosingOpname closingOpname = fetchExc(ent.getOID());
        ent = (Entity) closingOpname;
        return closingOpname.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ClosingOpname) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ClosingOpname) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ClosingOpname fetchExc(long oid) throws CONException {
        try {
            ClosingOpname closingOpname = new ClosingOpname();
            DbClosingOpname pstOpname = new DbClosingOpname(oid);
            closingOpname.setOID(oid);

            
            closingOpname.setDate(pstOpname.getDate(COL_DATE));
            closingOpname.setLocationId(pstOpname.getlong(COL_LOCATION_ID));
            closingOpname.setItemMasterId(pstOpname.getlong(COL_ITEM_MASTER_ID));
            closingOpname.setQty(pstOpname.getdouble(COL_QTY));
            closingOpname.setOpnameId(pstOpname.getlong(COL_OPNAME_ID));
            closingOpname.setHpp(pstOpname.getdouble(COL_HPP));
            closingOpname.setHarga_jual(pstOpname.getdouble(COL_HARGA_JUAL));
            
            return closingOpname;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbClosingOpname(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ClosingOpname closingOpname) throws CONException {
        try {
            DbClosingOpname pstOpname = new DbClosingOpname(0);

            
            pstOpname.setDate(COL_DATE, closingOpname.getDate());
            pstOpname.setLong(COL_LOCATION_ID, closingOpname.getLocationId());
            pstOpname.setLong(COL_ITEM_MASTER_ID, closingOpname.getItemMasterId());
            pstOpname.setDouble(COL_QTY, closingOpname.getQty());
            pstOpname.setLong(COL_OPNAME_ID, closingOpname.getOpnameId());
            pstOpname.setDouble(COL_HPP, closingOpname.getHpp());
            pstOpname.setDouble(COL_HARGA_JUAL, closingOpname.getHarga_jual());
            pstOpname.insert();
            closingOpname.setOID(pstOpname.getlong(COL_CLOSING_OPNAME_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbClosingOpname(0), CONException.UNKNOWN);
        }
        return closingOpname.getOID();
    }

    public static long updateExc(ClosingOpname closingOpname) throws CONException {
        try {
            if (closingOpname.getOID() != 0) {
                DbClosingOpname pstOpname = new DbClosingOpname(closingOpname.getOID());

                
                pstOpname.setDate(COL_DATE, closingOpname.getDate());
                pstOpname.setLong(COL_LOCATION_ID, closingOpname.getLocationId());
                pstOpname.setLong(COL_ITEM_MASTER_ID, closingOpname.getItemMasterId());
                pstOpname.setDouble(COL_QTY, closingOpname.getQty());
                pstOpname.setLong(COL_OPNAME_ID, closingOpname.getOpnameId());
                pstOpname.setDouble(COL_HPP, closingOpname.getHpp());
                pstOpname.setDouble(COL_HARGA_JUAL, closingOpname.getHarga_jual());
                pstOpname.update();
                return closingOpname.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbClosingOpname(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbClosingOpname pstOpname = new DbClosingOpname(oid);
            pstOpname.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbClosingOpname(0), CONException.UNKNOWN);
        }
        return oid;
    }
    //public static int deleteAllItem(long oidOpname){
        
      //  int result = 0;
        
      //  String sql = "delete from "+DB_POS_CLOSING_OPNAME+" where "+colNames[COL_OPNAME_ID]+" = "+oidOpname;
      //  try{
      //      CONHandler.execUpdate(sql);
      //  }
      //  catch(Exception e){
       //     result = -1;
      //  }
        
     //   return result;
   // }
     public static int updateOpnameItem(long oidOpname, long oidOpSub) {

        int result = 0;

        String sql = "update pos_opname_item set opname_sub_location_id="+ oidOpSub + " where opname_id="+ oidOpname;
        try {
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            result = -1;
        }

        return result;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_POS_CLOSING_OPNAME;
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
                ClosingOpname closingOpname = new ClosingOpname();
                resultToObject(rs, closingOpname);
                lists.add(closingOpname);
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
    
    public static Vector getItemMaster(String code, String name, long locationId, long opnameId){
        Vector result = new Vector();
        
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT cl.item_master_id FROM " + DB_POS_CLOSING_OPNAME + " cl " + 
                    " inner join pos_item_master im on cl.item_master_id=im.item_master_id where "+
                    " cl.location_id=" + locationId + " and opname_id=" + opnameId;
            if(code!=null && code.length()>0){
                sql = sql + " and (im.code  like '%" + code + "%' or im.barcode like '%"+ code + "%' or im.barcode_2 like '%" +
                        code + "%' or im.barcode_3 like '%" + code + "%')"  ;
            }
            if(name!=null && name.length()>0){
                sql = sql + " and name like '%" + name + "%'";
            }
            sql = sql + " group by cl.item_master_id";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()){
                try{
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(rs.getLong("item_master_id"));
                    result.add(im);
                }catch(Exception ex){
                    
                }
            }
            rs.close();
            return result;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
       return result;
    }

    private static void resultToObject(ResultSet rs, ClosingOpname closingOpname) {
        try {
            closingOpname.setOID(rs.getLong(DbClosingOpname.colNames[DbClosingOpname.COL_CLOSING_OPNAME_ID]));
            closingOpname.setDate(rs.getDate(DbClosingOpname.colNames[DbClosingOpname.COL_DATE]));
            closingOpname.setLocationId(rs.getLong(DbClosingOpname.colNames[DbClosingOpname.COL_LOCATION_ID]));
            closingOpname.setItemMasterId(rs.getLong(DbClosingOpname.colNames[DbClosingOpname.COL_ITEM_MASTER_ID]));
            closingOpname.setQty(rs.getDouble(DbClosingOpname.colNames[DbClosingOpname.COL_QTY]));
            closingOpname.setOpnameId(rs.getLong(DbClosingOpname.colNames[DbClosingOpname.COL_OPNAME_ID]));
            closingOpname.setHpp(rs.getDouble(DbClosingOpname.colNames[DbClosingOpname.COL_HPP]));
            closingOpname.setHarga_jual(rs.getDouble(DbClosingOpname.colNames[DbClosingOpname.COL_HARGA_JUAL]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long opnamePeriodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_CLOSING_OPNAME + " WHERE " +
                    DbClosingOpname.colNames[DbClosingOpname.COL_CLOSING_OPNAME_ID] + " = " + opnamePeriodeId;

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
            String sql = "SELECT COUNT(" + DbClosingOpname.colNames[DbClosingOpname.COL_CLOSING_OPNAME_ID] + ") FROM " + DB_POS_CLOSING_OPNAME;
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
                    ClosingOpname closingOpname = (ClosingOpname) list.get(ls);
                    if (oid == closingOpname.getOID()) {
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
    public static double getTotalQtyClosing(long itemMasterId, long opnameId, long locationId){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + DbClosingOpname.colNames[DbClosingOpname.COL_QTY] +" FROM " + DB_POS_CLOSING_OPNAME +
                    " where " +DbClosingOpname.colNames[DbClosingOpname.COL_ITEM_MASTER_ID]+ "=" + itemMasterId +
                    " and " + DbClosingOpname.colNames[DbClosingOpname.COL_OPNAME_ID] + "=" + opnameId + 
                    " and " + DbClosingOpname.colNames[DbClosingOpname.COL_LOCATION_ID] + "=" + locationId ;
                    
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

    /*public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_OPNAME + " where " +
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
    }*/

   /* public static String getNumberPrefix() {
        String code = "";
        Company sysCompany = DbCompany.getCompany();
        code = code + sysCompany.getOpnameCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }*/

   /* public static String getNextNumber(int ctr) {

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
    }*/
    
    public static double getCogs(long itemMasterId, long opnameId){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + DbClosingOpname.colNames[DbClosingOpname.COL_HPP] + " FROM " + DB_POS_CLOSING_OPNAME +
                    " where " + DbClosingOpname.colNames[DbClosingOpname.COL_OPNAME_ID] + "=" + opnameId + " and " +
                    DbClosingOpname.colNames[DbClosingOpname.COL_ITEM_MASTER_ID] + "=" + itemMasterId ;
            

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double result = 0;
            while (rs.next()) {
                result = rs.getInt(1);
            }

            rs.close();
            return result;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static double getHargaJual(long itemMasterId, long opnameId){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + DbClosingOpname.colNames[DbClosingOpname.COL_HARGA_JUAL] + " FROM " + DB_POS_CLOSING_OPNAME +
                    " where " + DbClosingOpname.colNames[DbClosingOpname.COL_OPNAME_ID] + "=" + opnameId + " and " +
                    DbClosingOpname.colNames[DbClosingOpname.COL_ITEM_MASTER_ID] + "=" + itemMasterId ;
            

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double result = 0;
            while (rs.next()) {
                result = rs.getInt(1);
            }

            rs.close();
            return result;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
     public static Vector getTotalSummary(long opnameId){
        CONResultSet dbrs = null;
        Vector vsum = new Vector();
        try {
            String sql = "select sum(selisihhpp), sum(selisihjual) from (select item_master_id, sum(totreal), sum(totclosing), hpokok, hjual, ((sum(totreal)-sum(totclosing))* hpokok) as selisihhpp, ((sum(totreal)-sum(totclosing))* hjual) as selisihjual  from " + 
                    " ((select item_master_id, 0 as totreal, sum(qty) as totclosing, hpp as hpokok, harga_jual as hjual from pos_closing_opname where opname_id="+
                    opnameId + " group by item_master_id) union (select item_master_id, sum(qty_real) as totreal, 0 as totclosing, 0 as hpokok, 0 as hjual  from " +
                    " pos_opname_item where opname_id="+ opnameId + " group by item_master_id)) as tabel group by item_master_id) as tabel ";
            

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                vsum.add(rs.getDouble(1));
                vsum.add(rs.getDouble(2));
            }

            rs.close();
            return vsum;
        } catch (Exception e) {
            return new Vector();
        } finally {
            CONResultSet.close(dbrs);
        }
    }
     
     public static Vector getDetailTotalSummary(long opnameId){
        CONResultSet dbrs = null;
        Vector vsum = new Vector();
        try {
            String sql = "select item_master_id, sum(totreal) as totalreal, sum(totclosing) as totalclosing, (sum(totreal)-sum(totclosing)) as selisih,  hpokok, hjual, ((sum(totreal)-sum(totclosing))* hpokok) as selisihhpp, " +
                    "((sum(totreal)-sum(totclosing))* hjual) as selisihjual  from ((select item_master_id, 0 as totreal, sum(qty) as totclosing, " +
                    " hpp as hpokok, harga_jual as hjual from pos_closing_opname where opname_id=" + opnameId + 
                    " group by item_master_id) union (select item_master_id, sum(qty_real) as totreal, 0 as totclosing, 0 as hpokok, 0 as hjual " +
                    " from pos_opname_item where opname_id=" + opnameId  + " group by item_master_id)) as tabel group by item_master_id ";
            

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()){
                Vector vdet = new Vector();
                vdet.add(rs.getLong(1));
                vdet.add(rs.getDouble(2));
                vdet.add(rs.getDouble(3));
                vdet.add(rs.getDouble(4));
                vdet.add(rs.getDouble(5));
                vdet.add(rs.getDouble(6));
                vdet.add(rs.getDouble(7));
                vdet.add(rs.getDouble(8));
                vsum.add(vdet);
                
            }

            rs.close();
            return vsum;
        } catch (Exception e) {
            return new Vector();
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
}
