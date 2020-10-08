/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.general.*;
import com.project.ccs.postransaction.stock.*;

/**
 *
 * @author Ngurah Wirata J
 */
public class DbStockMin extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_STOCK_MIN = "pos_stock_min";
    public static final int COL_STOCK_MIN_ID = 0;
    public static final int COL_LOCATION_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_ITEM_NAME = 3;
    public static final int COL_CODE = 4;
    public static final int COL_BARCODE = 5;
    public static final int COL_MIN_STOCK = 6;
    public static final int COL_DELIVERY_UNIT=7;
 
    
    public static final String[] colNames = {
        "stock_min_id",
        "location_id",
        "item_master_id",
        "item_name",
        "code",
        "barcode",
        "min_stock",
        "delivery_unit"
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    

    public DbStockMin() {
    }

    public DbStockMin(int i) throws CONException {
        super(new DbStockMin());
    }

    public DbStockMin(String sOid) throws CONException {
        super(new DbStockMin(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbStockMin(long lOid) throws CONException {
        super(new DbStockMin(0));
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
        return DB_STOCK_MIN;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbStockMin().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        StockMinItem stockMinITem = fetchExc(ent.getOID());
        ent = (Entity) stockMinITem;
        return stockMinITem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((StockMinItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((StockMinItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static StockMinItem fetchExc(long oid) throws CONException {
        try {
            StockMinItem stockMin = new  StockMinItem();
            DbStockMin dbStockMin = new DbStockMin(oid);
            stockMin.setOID(oid);

            stockMin.setLocationId(dbStockMin.getlong(COL_LOCATION_ID));
            stockMin.setItemMasterId(dbStockMin.getlong(COL_ITEM_MASTER_ID));
            stockMin.setItemName(dbStockMin.getString(COL_ITEM_NAME));
            stockMin.setCode(dbStockMin.getString(COL_CODE));
            stockMin.setBarcode(dbStockMin.getString(COL_BARCODE));
            stockMin.setMinStock(dbStockMin.getdouble(COL_MIN_STOCK));
            stockMin.setDeliveryUnit(dbStockMin.getdouble(COL_DELIVERY_UNIT));
            
            return stockMin;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(StockMinItem stockMin) throws CONException {
        try {


            DbStockMin dbStockMin = new DbStockMin(0);

            
            dbStockMin.setLong(COL_LOCATION_ID, stockMin.getLocationId());
            dbStockMin.setLong(COL_ITEM_MASTER_ID, stockMin.getItemMasterId());
            dbStockMin.setString(COL_ITEM_NAME, stockMin.getItemName());
            dbStockMin.setString(COL_CODE, stockMin.getCode());
            dbStockMin.setString(COL_BARCODE, stockMin.getBarcode());
            dbStockMin.setDouble(COL_MIN_STOCK, stockMin.getMinStock());
            dbStockMin.setDouble(COL_DELIVERY_UNIT, stockMin.getDeliveryUnit());
                        
            dbStockMin.insert();
            stockMin.setOID(dbStockMin.getlong(COL_STOCK_MIN_ID));
            if(stockMin.getMinStock()==0){//hilangkan order jika stock standarna sudah di nol kan
                    DbOrder.updateOrderByStockMin(stockMin);
                }else{
                    DbOrder.checkRequestTransfer(stockMin.getItemMasterId(),stockMin.getLocationId());
                }
           

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
        return stockMin.getOID();
    }

    public static long updateExc( StockMinItem stockMin) throws CONException {
        try {
            if (stockMin.getOID() != 0) {

                DbStockMin dbStockMin = new DbStockMin(stockMin.getOID());

                
                dbStockMin.setLong(COL_LOCATION_ID, stockMin.getLocationId());
                dbStockMin.setLong(COL_ITEM_MASTER_ID, stockMin.getItemMasterId());        
                dbStockMin.setString(COL_ITEM_NAME, stockMin.getItemName()); 
                dbStockMin.setString(COL_CODE, stockMin.getCode()); 
                dbStockMin.setString(COL_BARCODE, stockMin.getBarcode()); 
                dbStockMin.setDouble(COL_MIN_STOCK, stockMin.getMinStock()); 
                dbStockMin.setDouble(COL_DELIVERY_UNIT, stockMin.getDeliveryUnit()); 
                
                dbStockMin.update();
                
                if(stockMin.getMinStock()==0){//hilangkan order jika stock standarna sudah di nol kan
                    DbOrder.updateOrderByStockMin(stockMin);
                }else{
                    DbOrder.checkRequestTransfer(stockMin.getItemMasterId(),stockMin.getLocationId());
                }
                
                return stockMin.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockMin(0), CONException.UNKNOWN);
        }
        return 0;
    }

    
    
    public static long deleteExc(long oid) throws CONException {
        try {
            DbStockMin dbStockMin = new DbStockMin(oid);
            dbStockMin.delete();
            StockMinItem stockMin = dbStockMin.fetchExc(oid);
            DbOrder.updateOrderByStockMin(stockMin);
            
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockMin(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_STOCK_MIN;
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
                StockMinItem stockMin = new StockMinItem();
                resultToObject(rs, stockMin);
                lists.add(stockMin);
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

    public static void resultToObject(ResultSet rs, StockMinItem stockMin) {
        try {
            stockMin.setOID(rs.getLong(DbStockMin.colNames[DbStockMin.COL_STOCK_MIN_ID]));
            stockMin.setLocationId(rs.getLong(DbStockMin.colNames[DbStockMin.COL_LOCATION_ID]));
            stockMin.setItemMasterId(rs.getLong(DbStockMin.colNames[DbStockMin.COL_ITEM_MASTER_ID]));
            stockMin.setItemName(rs.getString(DbStockMin.colNames[DbStockMin.COL_ITEM_NAME]));
            stockMin.setCode(rs.getString(DbStockMin.colNames[DbStockMin.COL_CODE]));
            stockMin.setBarcode(rs.getString(DbStockMin.colNames[DbStockMin.COL_BARCODE]));
            stockMin.setMinStock(rs.getDouble(DbStockMin.colNames[DbStockMin.COL_MIN_STOCK]));
            stockMin.setDeliveryUnit(rs.getDouble(DbStockMin.colNames[DbStockMin.COL_DELIVERY_UNIT]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long stokMindId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " +  DB_STOCK_MIN + " WHERE " +
                    DbStockMin.colNames[DbStockMin.COL_STOCK_MIN_ID] + " = " + stokMindId;

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
            String sql = "SELECT COUNT(" + DbStockMin.colNames[DbStockMin.COL_STOCK_MIN_ID] + ") FROM " + DB_STOCK_MIN;
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
    
    
    public static int getStockMinValue(long location_id, long item_master_id) {
        CONResultSet dbrs = null;
        try {
            String sql="";
            if(location_id!=0){
                sql = "SELECT " + DbStockMin.colNames[DbStockMin.COL_MIN_STOCK] + " FROM " + DB_STOCK_MIN + " where location_id=" + location_id + " and item_master_id=" + item_master_id;
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

    public static int getDeliveryUnit(long location_id, long item_master_id) {
        CONResultSet dbrs = null;
        try {
            String sql="";
            if(location_id!=0){
                sql = "SELECT " + DbStockMin.colNames[DbStockMin.COL_DELIVERY_UNIT] + " FROM " + DB_STOCK_MIN + " where location_id=" + location_id + " and item_master_id=" + item_master_id;
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
                    StockMinItem stockMin = (StockMinItem) list.get(ls);
                    if (oid == stockMin.getOID()) {
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

    //IGNWJ
    //========================== operation log management ==============================================
    //insert logs for new item
    public static void insertOperationLog(long oid, long userId, String userName, StockMinItem stockMinItem){
                
            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(oid);
            lo.setUserId(userId);
            lo.setUserName(userName);
            Location loc=new Location();
            try{
                loc= DbLocation.fetchExc(stockMinItem.getLocationId());
            }catch(Exception e){
                
            }
            lo.setLogDesc("Insert new minimum stock for location "+loc.getName()+", minimum stock :"+stockMinItem.getMinStock()+ ", delivery unit :" + stockMinItem.getDeliveryUnit());
            
            try{
                DbLogOperation.insertExc(lo);
            }
            catch(Exception e){
            
            }
        }  
    //insert logs for update item
        public static void insertOperationLog(long oid, long userId, String userName, StockMinItem oldStockMin, StockMinItem stockMinItem){
                
            String logDesc = getLogDesc(oldStockMin, stockMinItem);
            
            if(logDesc.length()>0){
                
                LogOperation lo = new LogOperation();
                lo.setDate(new java.util.Date());
                lo.setOwnerId(oid);
                lo.setUserId(userId);
                lo.setUserName(userName);
                lo.setLogDesc(logDesc);

                try{
                    DbLogOperation.insertExc(lo);
                }
                catch(Exception e){

                }
            }
        }
        public static String getLogDesc(StockMinItem oldStockMinItem, StockMinItem stockMinItem){
            String logDesc = "";
            Location locNow = new Location();
            try{
                locNow = DbLocation.fetchExc(stockMinItem.getLocationId());
                        
            }catch(Exception ex){
                
            }
            
             if(oldStockMinItem.getMinStock()!=stockMinItem.getMinStock()){
                logDesc = logDesc + ((logDesc.length()>0) ? ", " : "" )+ " Minimum Stock :";
                 try{
                    logDesc = logDesc + " "+oldStockMinItem.getMinStock() + " --> "+stockMinItem.getMinStock();
                    
                }
                catch(Exception e){
                }
            }
            
            if(oldStockMinItem.getDeliveryUnit()!=stockMinItem.getDeliveryUnit()){
                logDesc = logDesc + ((logDesc.length()>0) ? ", " : "" )+" Delivery Unit :";
                 try{
                    
                    logDesc = logDesc + " "+oldStockMinItem.getDeliveryUnit()+ " --> "+stockMinItem.getDeliveryUnit();
                    
                    
                }
                catch(Exception e){
                }
            }
            if(oldStockMinItem.getLocationId()!=stockMinItem.getLocationId()){
                logDesc = "location :";
                try{
                    Location locOld = DbLocation.fetchExc(oldStockMinItem.getLocationId());
                    logDesc = logDesc + " "+locOld.getName();
                    Location loc = DbLocation.fetchExc(stockMinItem.getLocationId());
                    logDesc = logDesc + " > "+loc.getName();
                }
                catch(Exception e){
                }
            }
            
           
            if(logDesc.length()>0){
                logDesc = "Update data for location " + locNow.getName() +" >> "+logDesc;
            }
            return logDesc;
        }
  public static int getCount(long categoryId, long groupId, long vendorId, long locationId) {
        CONResultSet dbrs = null;
        try {
            String sql = "select count(tbl.item_master_id) from (( SELECT sm.item_master_id FROM " + DB_STOCK_MIN + " sm " + 
            " INNER JOIN pos_item_master im ON sm.item_master_id=im.item_master_id INNER JOIN pos_vendor_item vi ON sm.item_master_id=vi.item_master_id " +
            " where sm.location_id="+ locationId ;
            
            if(categoryId!=0){
                sql=sql + " and im.item_category_id=" + categoryId;
            }
            if(groupId!=0){
                sql = sql + " and im.item_group_id=" + groupId;
                
            }
           
            
            if(vendorId!=0){
                sql = sql + " and vi.vendor_id=" + vendorId ;
            }
            sql = sql + " group by sm.item_master_id )) as tbl";
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
  public static Vector listByParameter(int limitStart, int recordToGet, long itemCategoryId, long itemGroupId, long vendorId, long locationId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_MIN + " sm INNER JOIN pos_item_master im ON " +
                    " sm.item_master_id=im.item_master_id INNER JOIN pos_vendor_item vi ON "+
                    " sm.item_master_id=vi.item_master_id where sm.location_id=" + locationId;
            
            if (itemCategoryId!=0) {
                sql = sql + " and im.item_category_id=" + itemCategoryId;
            }
            if (itemGroupId!=0) {
                sql = sql + " and im.item_group_id=" + itemGroupId;
            }
            if (vendorId!=0) {
                sql = sql + " and vi.vendor_id=" + vendorId;
            }
            sql=sql+" group by sm.item_master_id ";
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                StockMinItem stockMin = new StockMinItem();
                resultToObject(rs, stockMin);
                lists.add(stockMin);
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
  
  public static void updateStockStandarByLocation(long locationId, StockMinItem stm){
       try {
            Vendor ven = new Vendor();
            ItemMaster im = new ItemMaster();
            try{
                im = DbItemMaster.fetchExc(stm.getItemMasterId());
                ven = DbVendor.fetchExc(im.getDefaultVendorId());
                
            }catch(Exception ex){
                
            }
            double listTime = ven.getOdrSenin()+ ven.getOdrSelasa()+ ven.getOdrRabu()+ ven.getOdrKamis()+ ven.getOdrJumat()+ven.getOdrSabtu()+ ven.getOdrMinggu() ;
            Vector vstokMin = new Vector();
            vstokMin= DbStockMin.list(0, 0, "item_master_id="+im.getOID()+ " and location_id="+ locationId, "");
            StockMinItem stMin = new StockMinItem();
            if(vstokMin.size()>0){
                stMin = (StockMinItem) vstokMin.get(0);
            }else{
                stMin = new StockMinItem();
            }
            if(stMin.getOID()!=0){
                try{
                    stMin= DbStockMin.fetchExc(stMin.getOID());
                }catch(Exception ex){

                }
            }
            stMin.setMinStock(getAkumulasiStockStandar(im.getOID(), locationId) + listTime * im.getDeliveryUnit());
            LogStockStandar logS = new LogStockStandar();
            if(stMin.getOID()!=0){
                DbStockMin.updateExc(stMin);
                logS.setDate(new Date());
                logS.setQtyStandar(stMin.getMinStock());
                logS.setStockMinId(stMin.getOID());
                logS.setUserId(0);
                logS.setUserName("Sistem");
                logS.setLogDesc("update stock standar ="+stMin.getMinStock()+" by system"  );
                DbLogStockStandar.insertExc(logS);
                
                
            }else{
                stMin.setBarcode(im.getBarcode());
                stMin.setCode(im.getCode());
                stMin.setDeliveryUnit(im.getDeliveryUnit());
                stMin.setItemMasterId(im.getOID());
                stMin.setItemName(im.getName());
                stMin.setLocationId(im.getLocationOrder());
                
                DbStockMin.insertExc(stMin);
                logS.setDate(new Date());
                logS.setQtyStandar(stMin.getMinStock());
                logS.setStockMinId(stMin.getOID());
                logS.setUserId(0);
                logS.setUserName("Sistem");
                logS.setLogDesc("insert stock standar ="+stMin.getMinStock()+" by system"  );
                DbLogStockStandar.insertExc(logS);
            }
            
            
          
            
        } catch (Exception e){
            
        } finally {
            
        }
    }  
  
  public static double getAkumulasiStockStandar(long itemMasterId, long oidLocDc){
        CONResultSet dbrs = null;
        try {
            String sql = "select sum(min_stock) as jum from pos_stock_min where item_master_id=" + itemMasterId + " and location_id !="+oidLocDc;
                  
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getInt("jum");
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
  }
  
  
  public static int getTotalTerjual(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT SUM(sd.qty) FROM pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id " ;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
  
  
  public static int getStandarStockTerjual(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT im.item_master_id,im.barcode, im.code, im.name FROM pos_item_master im inner join pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id " ;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
  
        
}
