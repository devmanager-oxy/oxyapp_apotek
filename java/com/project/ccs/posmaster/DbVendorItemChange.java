package com.project.ccs.posmaster;

import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;

public class DbVendorItemChange extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_VENDOR_ITEM_CHANGE = "pos_vendor_item_change";
    public static final int COL_VENDOR_ITEM_CHANGE_ID = 0;
    public static final int COL_ITEM_MASTER_ID = 1;
    public static final int COL_VENDOR_ID = 2;
    public static final int COL_LAST_PRICE = 3;
    public static final int COL_LAST_DISCOUNT = 4;
    public static final int COL_UPDATE_DATE = 5;
    public static final int COL_LAST_DIS_VAL = 6;
    public static final int COL_REG_DIS_PERCENT = 7;
    public static final int COL_REG_DIS_VALUE = 8;

    public static final int COL_REAL_PRICE = 9;
    public static final int COL_PRICE_MARGIN = 10;
    
    public static final int COL_USER_ID             = 11;
    public static final int COL_DATE                = 12;
    public static final int COL_ACTIVE_DATE         = 13;
    public static final int COL_STATUS              = 14;
    public static final int COL_VENDOR_ITEM_ID      = 15;    
    public static final int COL_LAST_PRICE_ORI      = 16;
    public static final int COL_REF_NUMBER      = 17;
    
    public static final int COL_COUNTER      = 18;
    public static final int COL_PREFIX_NUMBER      = 19;

    public static final String[] colNames = {
        "vendor_item_change_id",
        "item_master_id",
        "vendor_id",
        "last_price",
        "last_discount",
        "update_date",
        "last_dis_val",
        "reg_dis_val",
        "reg_dis_percent",
        "real_price",
        "margin_price",
        
        "user_id",
        "date",
        "active_date",
        "status",
        "vendor_item_id",        
        "last_price_ori",
        "ref_number",
        "counter",
        "prefix_number"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,        
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING
    };

    public DbVendorItemChange() {
    }

    public DbVendorItemChange(int i) throws CONException {
        super(new DbVendorItemChange());
    }

    public DbVendorItemChange(String sOid) throws CONException {
        super(new DbVendorItemChange(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbVendorItemChange(long lOid) throws CONException {
        super(new DbVendorItemChange(0));
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
        return DB_VENDOR_ITEM_CHANGE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbVendorItemChange().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        VendorItemChange vendorItemChange = fetchExc(ent.getOID());
        ent = (Entity) vendorItemChange;
        return vendorItemChange.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((VendorItemChange) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((VendorItemChange) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static VendorItemChange fetchExc(long oid) throws CONException {
        try {
            VendorItemChange vendorItemChange = new VendorItemChange();
            DbVendorItemChange pstVendorItemChange = new DbVendorItemChange(oid);
            vendorItemChange.setOID(oid);

            vendorItemChange.setItemMasterId(pstVendorItemChange.getlong(COL_ITEM_MASTER_ID));
            vendorItemChange.setVendorId(pstVendorItemChange.getlong(COL_VENDOR_ID));
            vendorItemChange.setLastPrice(pstVendorItemChange.getdouble(COL_LAST_PRICE));
            vendorItemChange.setLastDiscount(pstVendorItemChange.getdouble(COL_LAST_DISCOUNT));
            vendorItemChange.setUpdateDate(pstVendorItemChange.getDate(COL_UPDATE_DATE));
            vendorItemChange.setLastDisVal(pstVendorItemChange.getdouble(COL_LAST_DIS_VAL));
            vendorItemChange.setRegDisValue(pstVendorItemChange.getdouble(COL_REG_DIS_VALUE));
            vendorItemChange.setRegDisPercent(pstVendorItemChange.getdouble(COL_REG_DIS_PERCENT));

            vendorItemChange.setRealPrice(pstVendorItemChange.getdouble(COL_REAL_PRICE));
            vendorItemChange.setMarginPrice(pstVendorItemChange.getdouble(COL_PRICE_MARGIN));
            
            vendorItemChange.setUserId(pstVendorItemChange.getlong(COL_USER_ID));
            vendorItemChange.setDate(pstVendorItemChange.getDate(COL_DATE));
            vendorItemChange.setActiveDate(pstVendorItemChange.getDate(COL_ACTIVE_DATE));
            vendorItemChange.setStatus(pstVendorItemChange.getInt(COL_STATUS));
            vendorItemChange.setVendorItemId(pstVendorItemChange.getlong(COL_VENDOR_ITEM_ID));            
            vendorItemChange.setLastPriceOri(pstVendorItemChange.getdouble(COL_LAST_PRICE_ORI));
            vendorItemChange.setRefNumber(pstVendorItemChange.getString(COL_REF_NUMBER));
            
            vendorItemChange.setCounter(pstVendorItemChange.getInt(COL_COUNTER));
            vendorItemChange.setPrefixNumber(pstVendorItemChange.getString(COL_PREFIX_NUMBER));

            return vendorItemChange;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorItemChange(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(VendorItemChange vendorItemChange) throws CONException {
        try {
            DbVendorItemChange pstVendorItemChange = new DbVendorItemChange(0);

            pstVendorItemChange.setLong(COL_ITEM_MASTER_ID, vendorItemChange.getItemMasterId());
            pstVendorItemChange.setLong(COL_VENDOR_ID, vendorItemChange.getVendorId());
            pstVendorItemChange.setDouble(COL_LAST_PRICE, vendorItemChange.getLastPrice());
            pstVendorItemChange.setDouble(COL_LAST_DISCOUNT, vendorItemChange.getLastDiscount());
            pstVendorItemChange.setDate(COL_UPDATE_DATE, vendorItemChange.getUpdateDate());
            pstVendorItemChange.setDouble(COL_LAST_DIS_VAL, vendorItemChange.getLastDisVal());
            pstVendorItemChange.setDouble(COL_REG_DIS_VALUE, vendorItemChange.getRegDisValue());
            pstVendorItemChange.setDouble(COL_REG_DIS_PERCENT, vendorItemChange.getRegDisPercent());

            pstVendorItemChange.setDouble(COL_REAL_PRICE, vendorItemChange.getRealPrice());
            pstVendorItemChange.setDouble(COL_PRICE_MARGIN, vendorItemChange.getMarginPrice());
            
            pstVendorItemChange.setLong(COL_USER_ID, vendorItemChange.getUserId());
            pstVendorItemChange.setDate(COL_DATE, vendorItemChange.getDate());
            pstVendorItemChange.setDate(COL_ACTIVE_DATE, vendorItemChange.getActiveDate());
            pstVendorItemChange.setInt(COL_STATUS, vendorItemChange.getStatus());
            pstVendorItemChange.setLong(COL_VENDOR_ITEM_ID, vendorItemChange.getVendorItemId());                        
            pstVendorItemChange.setDouble(COL_LAST_PRICE_ORI, vendorItemChange.getLastPriceOri());
            pstVendorItemChange.setString(COL_REF_NUMBER, vendorItemChange.getRefNumber());
            
            pstVendorItemChange.setInt(COL_COUNTER, vendorItemChange.getCounter());
            pstVendorItemChange.setString(COL_PREFIX_NUMBER, vendorItemChange.getPrefixNumber());
            
            pstVendorItemChange.insert();
            vendorItemChange.setOID(pstVendorItemChange.getlong(COL_VENDOR_ITEM_CHANGE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorItemChange(0), CONException.UNKNOWN);
        }
        return vendorItemChange.getOID();
    }

    public static long updateExc(VendorItemChange vendorItemChange) throws CONException {
        try {
            if (vendorItemChange.getOID() != 0) {
                DbVendorItemChange pstVendorItemChange = new DbVendorItemChange(vendorItemChange.getOID());

                pstVendorItemChange.setLong(COL_ITEM_MASTER_ID, vendorItemChange.getItemMasterId());
                pstVendorItemChange.setLong(COL_VENDOR_ID, vendorItemChange.getVendorId());
                pstVendorItemChange.setDouble(COL_LAST_PRICE, vendorItemChange.getLastPrice());
                pstVendorItemChange.setDouble(COL_LAST_DISCOUNT, vendorItemChange.getLastDiscount());
                pstVendorItemChange.setDate(COL_UPDATE_DATE, vendorItemChange.getUpdateDate());
                pstVendorItemChange.setDouble(COL_LAST_DIS_VAL, vendorItemChange.getLastDisVal());
                pstVendorItemChange.setDouble(COL_REG_DIS_VALUE, vendorItemChange.getRegDisValue());
                pstVendorItemChange.setDouble(COL_REG_DIS_PERCENT, vendorItemChange.getRegDisPercent());

                pstVendorItemChange.setDouble(COL_REAL_PRICE, vendorItemChange.getRealPrice());
                pstVendorItemChange.setDouble(COL_PRICE_MARGIN, vendorItemChange.getMarginPrice());
                
                pstVendorItemChange.setLong(COL_USER_ID, vendorItemChange.getUserId());
                pstVendorItemChange.setDate(COL_DATE, vendorItemChange.getDate());
                pstVendorItemChange.setDate(COL_ACTIVE_DATE, vendorItemChange.getActiveDate());
                pstVendorItemChange.setInt(COL_STATUS, vendorItemChange.getStatus());
                pstVendorItemChange.setLong(COL_VENDOR_ITEM_ID, vendorItemChange.getVendorItemId());                        
                pstVendorItemChange.setDouble(COL_LAST_PRICE_ORI, vendorItemChange.getLastPriceOri());
                pstVendorItemChange.setString(COL_REF_NUMBER, vendorItemChange.getRefNumber());
                
                pstVendorItemChange.setInt(COL_COUNTER, vendorItemChange.getCounter());
                pstVendorItemChange.setString(COL_PREFIX_NUMBER, vendorItemChange.getPrefixNumber());
            
                pstVendorItemChange.update();
                return vendorItemChange.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorItemChange(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbVendorItemChange pstVendorItemChange = new DbVendorItemChange(oid);
            pstVendorItemChange.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorItemChange(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_VENDOR_ITEM_CHANGE;
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
                VendorItemChange vendorItemChange = new VendorItemChange();
                resultToObject(rs, vendorItemChange);
                lists.add(vendorItemChange);
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

    public static void resultToObject(ResultSet rs, VendorItemChange vendorItemChange) {
        try {
            vendorItemChange.setOID(rs.getLong(DbVendorItemChange.colNames[DbVendorItemChange.COL_VENDOR_ITEM_CHANGE_ID]));
            vendorItemChange.setItemMasterId(rs.getLong(DbVendorItemChange.colNames[DbVendorItemChange.COL_ITEM_MASTER_ID]));
            vendorItemChange.setVendorId(rs.getLong(DbVendorItemChange.colNames[DbVendorItemChange.COL_VENDOR_ID]));
            vendorItemChange.setLastPrice(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_LAST_PRICE]));
            vendorItemChange.setLastDiscount(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_LAST_DISCOUNT]));
            vendorItemChange.setUpdateDate(rs.getDate(DbVendorItemChange.colNames[DbVendorItemChange.COL_UPDATE_DATE]));
            vendorItemChange.setLastDisVal(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_LAST_DIS_VAL]));
            vendorItemChange.setRegDisValue(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_REG_DIS_VALUE]));
            vendorItemChange.setRegDisPercent(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_REG_DIS_PERCENT]));

            vendorItemChange.setRealPrice(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_REAL_PRICE]));
            vendorItemChange.setMarginPrice(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_PRICE_MARGIN]));
            
            vendorItemChange.setUserId(rs.getLong(DbVendorItemChange.colNames[DbVendorItemChange.COL_USER_ID]));
            vendorItemChange.setDate(rs.getDate(DbVendorItemChange.colNames[DbVendorItemChange.COL_DATE]));
            vendorItemChange.setActiveDate(rs.getDate(DbVendorItemChange.colNames[DbVendorItemChange.COL_ACTIVE_DATE]));
            vendorItemChange.setStatus(rs.getInt(DbVendorItemChange.colNames[DbVendorItemChange.COL_STATUS]));
            vendorItemChange.setVendorItemId(rs.getLong(DbVendorItemChange.colNames[DbVendorItemChange.COL_VENDOR_ITEM_ID]));
            vendorItemChange.setLastPriceOri(rs.getDouble(DbVendorItemChange.colNames[DbVendorItemChange.COL_LAST_PRICE_ORI]));
            vendorItemChange.setRefNumber(rs.getString(DbVendorItemChange.colNames[DbVendorItemChange.COL_REF_NUMBER]));
            
            vendorItemChange.setCounter(rs.getInt(DbVendorItemChange.colNames[DbVendorItemChange.COL_COUNTER]));
            vendorItemChange.setPrefixNumber(rs.getString(DbVendorItemChange.colNames[DbVendorItemChange.COL_PREFIX_NUMBER]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long vendorItemChangeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_VENDOR_ITEM_CHANGE + " WHERE "
                    + DbVendorItemChange.colNames[DbVendorItemChange.COL_VENDOR_ITEM_ID] + " = " + vendorItemChangeId;

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
            String sql = "SELECT COUNT(" + DbVendorItemChange.colNames[DbVendorItemChange.COL_VENDOR_ITEM_ID] + ") FROM " + DB_VENDOR_ITEM_CHANGE;
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

    public static int getCountCostChange(String barcode, String code, String nama, long itemGroupId, long itemCategoryId, long status, long oidVendor, String refNumber, String fromDate , String toDate, long ignoreDate){
		CONResultSet dbrs = null;
		try {
                        String wareclause="";
                        String sql = "";
                        if((refNumber.length()>0 && refNumber != null) || (ignoreDate==0)){
                            sql=" select count(*) from pos_item_master im inner join pos_vendor_item_change vic on im.item_master_id=vic.item_master_id ";
                        }else if(oidVendor!=0){
                            sql = " select count(*) from pos_item_master im inner join pos_vendor_item vi on im.item_master_id=vi.item_master_id   ";
                        }else{
                            sql = " select count(*) from pos_item_master im   ";
                        }
                        wareclause = wareclause + " im.is_active=1 ";
			if(barcode.length()>0 && barcode != null){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " im.barcode='"+barcode+"' " ;
                        } 
                        if(code.length()>0 && code != null){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " im.code='"+code+"' " ;
                        }
                        
                        if(nama.length()>0 && nama != null){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " im.name='"+nama+"' " ;
                        }
                        if(itemCategoryId !=0){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " im.item_category_id="+itemCategoryId ;
                        }
                        if(itemGroupId !=0){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " im.item_group_id="+itemGroupId ;
                        }
                        if(status !=-1){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " vic.status="+status ;
                        }
                        if(refNumber != null && refNumber.length()>0 ){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " vic.ref_number='"+refNumber + "'" ;
                        }
                        if(ignoreDate ==0){
                            if(wareclause.length()>0 && wareclause != null){
                                wareclause = wareclause +" and ";
                            }
                            wareclause=wareclause + " to_days(vic.active_date) >= to_days('"+ fromDate + "') and to_days(vic.active_date) <=to_days('"+ toDate+"')";
                        }
                        if(oidVendor !=0){
                            if(refNumber.length()>0 && refNumber !=null ){
                                if(wareclause.length()>0 && wareclause != null){
                                    wareclause = wareclause +" and ";
                                }
                                wareclause=wareclause + " vic.vendor_id="+oidVendor ;
                            }else{
                                if(wareclause.length()>0 && wareclause != null){
                                    wareclause = wareclause +" and ";
                                }
                                wareclause=wareclause + " vi.vendor_id="+oidVendor ;
                            }
                            
                        }
                        if(wareclause.length()>0 && wareclause != null){
                            sql = sql + " where " + wareclause;
                        }

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) {
                            count = rs.getInt(1); 
                        }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
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
                    VendorItemChange vendorItemChange = (VendorItemChange) list.get(ls);
                    if (oid == vendorItemChange.getOID()) {
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
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_VENDOR_ITEM_CHANGE + " where " +
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
        code = "CPC";

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
