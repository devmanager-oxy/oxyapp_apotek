package com.project.ccs.postransaction.order; 

import com.project.ccs.postransaction.stock.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.math.*;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.util.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.receiving.*;
import com.project.ccs.postransaction.transfer.*;
import com.project.ccs.postransaction.adjusment.*;
import com.project.ccs.postransaction.opname.*;
import com.project.ccs.postransaction.costing.*;
import com.project.ccs.postransaction.stock.*;
import com.project.general.*;
import com.project.ccs.*;
import com.project.ccs.postransaction.repack.DbRepackItem;
import com.project.ccs.postransaction.repack.Repack;
import com.project.ccs.postransaction.repack.RepackItem;
import com.project.fms.asset.*;
import com.project.ccs.postransaction.sales.*;
import com.project.system.*;


public class DbOrder extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_POS_AUTO_ORDER = "pos_auto_order";

	public static final  int COL_AUTO_ORDER_ID = 0;
        public static final  int COL_DATE = 1;
	public static final  int COL_LOCATION_ID = 2;
	public static final  int COL_ITEM_MASTER_ID = 3;
	public static final  int COL_TRANSFER_ID = 4;
	public static final  int COL_TRANSFER_ITEM_ID = 5;
	public static final  int COL_PURCHASE_ID = 6;
	public static final  int COL_PURCHASE_ITEM_ID = 7;
	public static final int COL_QTY_ORDER =8;
        public static final int COL_STATUS =9;
        public static final int COL_NUMBER =10;
        public static final int COL_COUNTER =11;
        public static final int COL_PREFIX_NUMBER =12;
        public static final int COL_QTY_PROCES =13;
        public static final int COL_QTY_STOCK =14;
        public static final int COL_QTY_STANDAR =15;
        public static final int COL_QTY_PO_PREV =16;
        public static final int COL_DATE_PROCES =17;
        
	public static final  String[] colNames = {
		"auto_order_id",
                "date",
                "location_id",
                "item_master_id",
                "transfer_id",
                "transfer_item_id",
                "purchase_id",
                "purchase_item_id",
                "qty_order",
                "status",
                "number",
                "counter",
                "prefix_number",
                "qty_proces",
                "qty_stock",
                "qty_standar",
                "qty_po_prev",
                "date_proces"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                TYPE_STRING,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_DATE
	 };
    
         
             
          
        
	public DbOrder(){
	}

	public DbOrder(int i) throws CONException { 
		super(new DbOrder()); 
	}

	public DbOrder(String sOid) throws CONException { 
		super(new DbOrder(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbOrder(long lOid) throws CONException { 
		super(new DbOrder(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return colNames.length; 
	}

	public String getTableName(){ 
		return DB_POS_AUTO_ORDER;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbOrder().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Order order = fetchExc(ent.getOID()); 
		ent = (Entity)order; 
		return order.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Order) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Order) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Order fetchExc(long oid) throws CONException{ 
		try{ 
			Order order = new Order();
			DbOrder pstOrder = new DbOrder(oid); 
			order.setOID(oid);
                        
                        order.setDate(pstOrder.getDate(COL_DATE));
			order.setLocationId(pstOrder.getlong(COL_LOCATION_ID));
			
			order.setItemMasterId(pstOrder.getlong(COL_ITEM_MASTER_ID));
			order.setTransferId(pstOrder.getlong(COL_TRANSFER_ID));
			order.setTransferItemId(pstOrder.getlong(COL_TRANSFER_ITEM_ID));
			order.setPurchaseId(pstOrder.getlong(COL_PURCHASE_ID));
			order.setPurchaseItemId(pstOrder.getlong(COL_PURCHASE_ITEM_ID));
			order.setQtyOrder(pstOrder.getdouble(COL_QTY_ORDER));
			order.setStatus(pstOrder.getString(COL_STATUS));
                        order.setNumber(pstOrder.getString(COL_NUMBER));
                        order.setCounter(pstOrder.getInt(COL_COUNTER));
                        order.setPrefixNumber(pstOrder.getString(COL_PREFIX_NUMBER));
                        order.setQtyProces(pstOrder.getdouble(COL_QTY_PROCES));
                        order.setQtyStock(pstOrder.getdouble(COL_QTY_STOCK));
                        order.setQtyStandar(pstOrder.getdouble(COL_QTY_STANDAR));
                        order.setQtyPoPrev(pstOrder.getdouble(COL_QTY_PO_PREV));
                        order.setDate_proces(pstOrder.getDate(COL_DATE_PROCES));
			return order; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbOrder(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Order order) throws CONException{ 
		try{ 
			DbOrder pstOrder = new DbOrder(0);

                        pstOrder.setDate(COL_DATE, order.getDate());
			pstOrder.setLong(COL_LOCATION_ID, order.getLocationId());
			pstOrder.setLong(COL_ITEM_MASTER_ID, order.getItemMasterId());
			pstOrder.setLong(COL_TRANSFER_ID, order.getTransferId());
			pstOrder.setLong(COL_TRANSFER_ITEM_ID, order.getTransferItemId());
			pstOrder.setLong(COL_PURCHASE_ID, order.getPurchaseId());
			pstOrder.setLong(COL_PURCHASE_ITEM_ID, order.getPurchaseItemId());
			pstOrder.setDouble(COL_QTY_ORDER, order.getQtyOrder());
			pstOrder.setString(COL_STATUS, order.getStatus());
                        pstOrder.setString(COL_NUMBER, order.getNumber());
                        pstOrder.setInt(COL_COUNTER, order.getCounter());
                        pstOrder.setString(COL_PREFIX_NUMBER, order.getPrefixNumber());
                        pstOrder.setDouble(COL_QTY_PROCES, order.getQtyProces());
                        pstOrder.setDouble(COL_QTY_STOCK, order.getQtyStock());
                        pstOrder.setDouble(COL_QTY_STANDAR, order.getQtyStandar());
                        pstOrder.setDouble(COL_QTY_PO_PREV, order.getQtyPoPrev());
                        pstOrder.setDate(COL_DATE_PROCES, order.getDate_proces());
			pstOrder.insert(); 
			order.setOID(pstOrder.getlong(COL_AUTO_ORDER_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbOrder(0),CONException.UNKNOWN); 
		}
		return order.getOID();
	}

	public static long updateExc(Order order) throws CONException{ 
		try{ 
			if(order.getOID() != 0){ 
				DbOrder pstOrder = new DbOrder(order.getOID());
                                
                                pstOrder.setDate(COL_DATE, order.getDate());
				pstOrder.setLong(COL_LOCATION_ID, order.getLocationId());
				pstOrder.setLong(COL_ITEM_MASTER_ID, order.getItemMasterId());
				pstOrder.setLong(COL_TRANSFER_ID, order.getTransferId());
				pstOrder.setLong(COL_TRANSFER_ITEM_ID, order.getTransferItemId());
				pstOrder.setLong(COL_PURCHASE_ID, order.getPurchaseId());
				pstOrder.setLong(COL_PURCHASE_ITEM_ID, order.getPurchaseItemId());
				pstOrder.setDouble(COL_QTY_ORDER, order.getQtyOrder());
				pstOrder.setString(COL_STATUS, order.getStatus());
                                pstOrder.setString(COL_NUMBER, order.getNumber());
                                pstOrder.setInt(COL_COUNTER, order.getCounter());
                                pstOrder.setString(COL_PREFIX_NUMBER, order.getPrefixNumber());
                                pstOrder.setDouble(COL_QTY_PROCES, order.getQtyProces());
                                pstOrder.setDouble(COL_QTY_STOCK, order.getQtyStock());
                                pstOrder.setDouble(COL_QTY_STANDAR, order.getQtyStandar());
                                pstOrder.setDouble(COL_QTY_PO_PREV, order.getQtyPoPrev());
                                pstOrder.setDate(COL_DATE_PROCES, order.getDate_proces());
				pstOrder.update(); 
				return order.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbOrder(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbOrder pstStock = new DbOrder(oid);
			pstStock.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbOrder(0),CONException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_POS_AUTO_ORDER  + " ao inner join pos_item_master im on ao.item_master_id=im.item_master_id "  ; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				Order orde = new Order();
				resultToObject(rs, orde);
				lists.add(orde);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}
        
        
        
        public static Vector listByVendor(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_POS_AUTO_ORDER + " ao INNER JOIN pos_vendor_item vi ON ao.item_master_id=vi.item_master_id INNER JOIN pos_item_master im ON ao.item_master_id=im.item_master_id " ; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				Order orde = new Order();
				resultToObject(rs, orde);
				lists.add(orde);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}
        
        public static Vector listByVendorPO(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_POS_AUTO_ORDER + " ao INNER JOIN pos_vendor_item vi ON " + 
                                "ao.item_master_id=vi.item_master_id INNER JOIN pos_item_master im ON " +
                                "ao.item_master_id=im.item_master_id INNER JOIN vendor v ON vi.vendor_id=v.vendor_id " ; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				Order orde = new Order();
				resultToObject(rs, orde);
				lists.add(orde);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}
        
        
	public static void resultToObject(ResultSet rs, Order order){
		try{
			order.setOID(rs.getLong(DbOrder.colNames[DbOrder.COL_AUTO_ORDER_ID]));
                        order.setDate(rs.getDate(DbOrder.colNames[DbOrder.COL_DATE]));
			order.setLocationId(rs.getLong(DbOrder.colNames[DbOrder.COL_LOCATION_ID]));
			order.setItemMasterId(rs.getLong(DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID]));
			order.setTransferId(rs.getLong(DbOrder.colNames[DbOrder.COL_TRANSFER_ID]));
			order.setTransferItemId(rs.getLong(DbOrder.colNames[DbOrder.COL_TRANSFER_ITEM_ID]));
			order.setPurchaseId(rs.getLong(DbOrder.colNames[DbOrder.COL_PURCHASE_ID]));
			order.setPurchaseItemId(rs.getLong(DbOrder.colNames[DbOrder.COL_PURCHASE_ITEM_ID]));
			order.setQtyOrder(rs.getDouble(DbOrder.colNames[DbOrder.COL_QTY_ORDER]));
			order.setStatus(rs.getString(DbOrder.colNames[DbOrder.COL_STATUS]));
                        order.setNumber(rs.getString(DbOrder.colNames[DbOrder.COL_NUMBER]));
                        order.setCounter(rs.getInt(DbOrder.colNames[DbOrder.COL_COUNTER]));
                        order.setPrefixNumber(rs.getString(DbOrder.colNames[DbOrder.COL_PREFIX_NUMBER]));
                        order.setQtyProces(rs.getDouble(DbOrder.colNames[DbOrder.COL_QTY_PROCES]));
                        order.setQtyStock(rs.getDouble(DbOrder.colNames[DbOrder.COL_QTY_STOCK]));
                        order.setQtyStandar(rs.getDouble(DbOrder.colNames[DbOrder.COL_QTY_STANDAR]));
                        order.setQtyPoPrev(rs.getDouble(DbOrder.colNames[DbOrder.COL_QTY_PO_PREV]));
                        order.setDate_proces(rs.getDate(DbOrder.colNames[DbOrder.COL_DATE_PROCES]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long orderId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_AUTO_ORDER + " WHERE " + 
						DbOrder.colNames[DbOrder.COL_AUTO_ORDER_ID] + " = " + orderId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbOrder.colNames[DbOrder.COL_AUTO_ORDER_ID] + ") FROM " + DB_POS_AUTO_ORDER;
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


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   Stock stock = (Stock)list.get(ls);
				   if(oid == stock.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
       
        
       public static double getTotalOrder(long location_id, long item_master_id) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT sum(qty_order) from pos_auto_order where location_id= " + location_id + " and status !='APPROVED' and item_master_id=" + item_master_id;
            

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
       
   public static String getNumberPrefix() {
        String code = "";
        //Company sysCompany = DbCompany.getCompany();
        code = code + "ODR";

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }    
   
   public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_AUTO_ORDER + " where " +
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
        
        
      public static void updateAuto(String kondisi ) throws CONException {
            try {
                String sql = "update " + DB_POS_AUTO_ORDER + " " + kondisi ;
                        
                CONHandler.execUpdate(sql);
            } catch (CONException dbe) {
                throw dbe;
            } catch (Exception e) {
                throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
            }
            
        }
      
      public static void deleteOrder(long itemMasterId, long LocationId ) throws CONException {
            try {
                String sql = "delete from " + DB_POS_AUTO_ORDER + " where item_master_id=" +itemMasterId + " and location_id=" + LocationId + " and status='DRAFT' "  ;
                        
                CONHandler.execUpdate(sql);
            } catch (CONException dbe) {
                throw dbe;
            } catch (Exception e) {
                throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
            }
            
        }
      
      
      
        
        
        public static Order getServiceLevel(long toLocationId, long fromLocationId, Date startDate, Date endDate ){
		CONResultSet dbrs = null;
                Order odr = new Order();
		try {
			String sql = "SELECT SUM(" + DbOrder.colNames[DbOrder.COL_QTY_ORDER] + "), SUM(" + DbOrder.colNames[DbOrder.COL_QTY_PROCES] + ") FROM " + DB_POS_AUTO_ORDER + " odr " + " INNER JOIN pos_tranfer t ON odr.tranfer_id=t.transfer_id " +
                                " where t.from_location_id=" + fromLocationId + " and odr.location_id=" + toLocationId + 
                                " and odr.transfer_id!=0 " +
                                " and to_days(odr.date) BETWEEN to_days('"+ JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"') and to_days('" + JSPFormater.formatDate(endDate,"yyyy-MM-dd") + "')" ;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			
			while(rs.next()) {
                            odr.setQtyOrder(rs.getInt(1)); 
                            odr.setQtyProces(rs.getInt(1)); 
                        }
                        
			rs.close();
			return odr;
		}catch(Exception e) {
			return odr;
		}finally {
			CONResultSet.close(dbrs);
		}
	} 
        public static Order getServiceLevelDetail(String whereClause){
		CONResultSet dbrs = null;
                Order odr = new Order();
		try {
			String sql = "SELECT SUM("+ DbOrder.colNames[DbOrder.COL_QTY_ORDER] + "), SUM(" + DbOrder.colNames[DbOrder.COL_QTY_PROCES] + ") FROM " + DB_POS_AUTO_ORDER;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			
			while(rs.next()) {
                            odr.setQtyOrder(rs.getInt(1)); 
                            odr.setQtyProces(rs.getInt(1)); 
                        }
                        
			rs.close();
			return odr;
		}catch(Exception e){
			return odr;
		}finally {
			CONResultSet.close(dbrs);
		}
	} 
        
        public static int getQtyProses(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT SUM("+ DbOrder.colNames[DbOrder.COL_QTY_PROCES] + ") FROM " + DB_POS_AUTO_ORDER;
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
        public static void updateOrderByTransfer(Transfer transfer){
            Vector vtransferitem = DbTransferItem.list(0, 0, DbTransfer.colNames[DbTransfer.COL_TRANSFER_ID]+ "=" + transfer.getOID(), "");
            if(vtransferitem.size()>0 && vtransferitem !=null){
                for(int i=0;i<vtransferitem.size();i++){
                    TransferItem ti = new TransferItem();
                    ti = (TransferItem) vtransferitem.get(i);
                    Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + ti.getItemMasterId() + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + transfer.getToLocationId() + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                    if(vOrder != null && vOrder.size()>0){
                        Order odrPrev = (Order)vOrder.get(0);
                        Order oder = new Order();
                        try{
                            oder = DbOrder.fetchExc(odrPrev.getOID());
                            oder.setStatus("APPROVED");
                            oder.setQtyProces(ti.getQty());
                            oder.setDate_proces(transfer.getDate());
                            oder.setTransferId(transfer.getOID());
                            oder.setTransferItemId(ti.getOID());
                            DbOrder.updateExc(odrPrev);
                        }catch(Exception ex) {

                        }
                    }
                }
            }
            
            
        }
        
         public static Vector getDetailServiceLevel(long locationId, Date startDate, Date endDate){
		CONResultSet dbrs = null;
                Vector vt = new Vector();
		try {
			String sql = "SELECT odr.number as odrnumber, t.number as trfnumber, im.code, im.barcode, " +
                                " im.name, odr.qty_order as qtyorder, ti.qty as qtytrans  FROM pos_auto_order odr INNER JOIN pos_transfer t " +
                                " ON odr.transfer_id=t.transfer_id LEFT JOIN pos_transfer_item ti ON odr.transfer_item_id=ti.transfer_item_id " +
                                " INNER JOIN pos_item_master im ON pi.item_master_id=im.item_master_id " +
                                " where r.purchase_id!=0 ";
                        if(locationId!=0){
                            sql = sql + " and t.to_location_id="+ locationId;
                        }
                        
                        sql = sql + " and to_days(t.date) between to_days('" + JSPFormater.formatDate(startDate,"yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')";       
                               
			sql= sql + " order by odr.auto_order_id";
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			
			while(rs.next()) {
                            Vector vtdet = new Vector();
                            vtdet.add(rs.getString("odrnumber"));
                            vtdet.add(rs.getString("trfnumber"));
                            vtdet.add(rs.getString("code"));
                            vtdet.add(rs.getString("barcode"));
                            vtdet.add(rs.getString("name"));
                            vtdet.add(rs.getDouble("qtyorder"));
                            vtdet.add(rs.getDouble("qtytrans"));
                            vt.add(vtdet);
                        }

			rs.close();
			return vt;
		}catch(Exception e) {
			return vt;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
        
        public static void updateOrderByTransferItem(Transfer transfer, TransferItem transferItem){
                Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + transferItem.getItemMasterId() + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + transfer.getToLocationId() + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                    
                    
                    if(vOrder != null && vOrder.size()>0){
                        Order odrPrev = (Order)vOrder.get(0);
                        Order oder = new Order();
                        try{
                            oder = DbOrder.fetchExc(odrPrev.getOID());
                            oder.setStatus("APPROVED");
                            oder.setQtyProces(transferItem.getQty());
                            oder.setDate_proces(transfer.getDate());
                            oder.setTransferId(transfer.getOID());
                            oder.setTransferItemId(transferItem.getOID());
                            DbOrder.updateExc(oder);
                        }catch(Exception ex) {

                        }
                    }
                
            
            
            
        }
        
    public static int getTotalStockByTransaksi(String itemCode, long locationId){
            
            String sql = "";// select sum(ri.qty) from pos_transfer ic inner join pos_transfer_item ri on ic.transfer_id=ri.transfer_id where to_days(ic.date) < to_days('2013-06-01') and ic.from_location_id=504404504052494548 and ri.item_master_id=4000266;
            
            int result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getInt(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }    
    public static void updateOrderByStockMin(StockMinItem stockMin){
                Vector vOrder = DbOrder.list(0, 0, " ao.status='DRAFT' and ao.location_id="+stockMin.getLocationId() + " and ao.item_master_id="+stockMin.getItemMasterId(), "");
                    
                    
                    if(vOrder != null && vOrder.size()>0){
                        Order odrPrev = (Order)vOrder.get(0);
                        try{
                            odrPrev.setStatus("APPROVED");
                            DbOrder.updateExc(odrPrev);
                        }catch(Exception ex) {

                        }
                    }
                
            
            
            
        }
    
    public static void getStockListByVendor(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder, long vendorId){
            
            String sql = "select im.item_master_id from pos_item_master im "+
                " inner join pos_vendor_item vi "+
                " on im.item_master_id = vi.item_master_id " +
                " where (im.location_order ="+ locationOrder + " or im.location_order=0) and im.is_auto_order=1 and im.is_active=1 and im.for_sales=1 " ;
                                
                if(code!=null && code.length()>0){
                    sql = sql + " and im.code like '%"+code+"%'"; 
                }
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and im.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and im.name like '%"+name+"%'"; 
                }
                if(groupid.length()>0){
                    sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" in ("+groupid + ") ";
                }
               //if(locationOrder!=0){
                  //  sql = sql + " and (m."+DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]+"="+locationOrder + " or m.location_order=0)";
               // }
                if(vendorId!=0){
                    sql = sql + " and vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+"="+vendorId;
                }
                if(categoryid.length() > 0){
                    sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+" in ("+categoryid +") ";
                }
                
              
                sql = sql + " group by im.item_master_id";
                
                
                
                
                
            CONResultSet crs = null;
                     
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    DbOrder.checkRequestTransfer(rs.getLong(1), locationId);//langsung di check order jika item sudah ditemukan
                    
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            //return result;
                
        }
        
        
       
    public static void getStockList(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder){
            
            String sql = "select m.item_master_id from pos_item_master m "+
                " where (m.location_order="+locationOrder + " or m.location_order=0) ";
            
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
               // if(locationOrder!=0){
                  //  sql = sql + " and (m."+DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]+"="+locationOrder + " or m.location_order=0)";
               // }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
                
                sql = sql + " group by m.item_master_id";
                     
                
            CONResultSet crs = null;
                      
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    DbOrder.checkRequestTransfer(rs.getLong(1), locationId);//langsung di check order jika item sudah ditemukan    
                   
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
           
                
        } 
    
    public static void checkRequestTransfer(long item_master_id, long location_id){
              
              ItemMaster im = new ItemMaster();
              try{
                 im= DbItemMaster.fetchExc(item_master_id);
              }catch(Exception ex){

              }
              
              try{
                 DbOrder.deleteOrder(item_master_id, location_id);
              }catch(Exception ex){
              }  
              
              if(im.getIsAutoOrder()==1){
                  
                 Location loc = new Location()   ;
                 try{
                     loc = DbLocation.fetchExc(location_id);
                 }catch(Exception ex)   {

                 }

                 if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){
                    
                    double minStock = DbStockMin.getStockMinValue(location_id, item_master_id);
                     
                    
                    if(minStock > 0){

                        double totalStock = DbStock.getItemTotalStock(location_id, item_master_id);
                        if(totalStock < 0){
                            totalStock =0;
                        }

                        double totalPoPrev = DbStock.getTotalPo(location_id, item_master_id);// mencari total po yg masih outstanding
                        //double totalRequest = DbOrder.getTotalOrder(location_id, item_master_id); // qty yg sudah pernah di order dengan status draft   
                        double totalTransferDraft = DbStock.getTotalTransfer(location_id, item_master_id);//mencari transfer ke lokasi ini yang masih out standing
                        double du = im.getDeliveryUnit();
                        if((totalStock + totalTransferDraft + totalPoPrev)<=(minStock - du)){

                            double qtyRequest;

                            qtyRequest=(((minStock-(totalStock + totalTransferDraft + totalPoPrev)))/im.getDeliveryUnit());
                            qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();
                          
                         
                            //otomatis buatkan order;
                            try{

                                 int nextCounter;
                                 nextCounter=DbOrder.getNextCounter();

                                 Order order = new Order();
                                 order.setCounter(nextCounter);
                                 order.setPrefixNumber(DbOrder.getNumberPrefix());
                                 order.setNumber(DbOrder.getNextNumber(nextCounter));
                                 order.setQtyOrder(qtyRequest);
                                 order.setDate(new Date());
                                 order.setQtyStock((totalStock));
                                 order.setQtyPoPrev(totalPoPrev);
                                 order.setQtyStandar(minStock);
                                 order.setLocationId(location_id);
                                 order.setItemMasterId(item_master_id);
                                 order.setStatus("DRAFT");
                                 //order.setDate_proces(new Date()) ;

                                 DbOrder.insertExc(order);

                             }catch(Exception ex){

                             }
                       
                    }
                      //du = im.getDeliveryUnit();   

                 }//min stock>0

              }//if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){

           }//if(im.getIsAutoOrder()==1){
        
        } 
    

public static void checkItemOrderPObyVendor(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder, long vendorId, int days){
            
            String sql = "select m.item_master_id" +
                " from pos_item_master m "+
                " inner join "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                " on m.item_master_id = vi."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                " inner join "+DbVendor.DB_VENDOR + " v " +
                " on vi." + DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+ "=v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                " where (m.location_order=" + locationOrder + " or m.location_order=0) ";//location_order=0 untuk order ke buyer dan DC.
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
                if(vendorId!=0){
                    sql = sql + " and vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+"="+vendorId;
                }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
                if(days!=0){
                    if(days==1){
                        sql = sql + " and v.odr_senin=1";
                    }else if(days==2){
                        sql = sql + " and v.odr_selasa=1";
                    }else if(days==3){
                        sql = sql + " and v.odr_rabu=1";
                    }else if(days==4){
                        sql = sql + " and v.odr_kamis=1";
                    }else if(days==5){
                        sql = sql + " and v.odr_jumat=1";
                    }else if(days==6){
                        sql = sql + " and v.odr_sabtu=1";
                    }else if(days==7){
                        sql = sql + " and v.odr_minggu=1";
                    }
                    
                }
              
                sql = sql + " group by m.item_master_id";
                
                
                
                //System.out.println("\n=================\n"+sql);
                
            CONResultSet crs = null;
                     
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    DbOrder.checkRequestTransfer(rs.getLong(1), locationId);//langsung di check order jika item sudah ditemukan
                    
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
                            
        }    
    
        public static void checkItemOrder(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder){
            
            String sql = "select m.item_master_id" +
                " from pos_item_master m "+
                " where (m.location_order=" + locationOrder + " or m.location_order=0) and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 ";
                
            
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid.length() > 0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" in ("+groupid +") ";
                }
                if(categoryid.length() > 0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+" in ("+categoryid + ") ";
                }
                
                sql = sql + " group by m.item_master_id";
                
                                
            CONResultSet crs = null;
                    
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    DbOrder.checkRequestTransfer(rs.getLong(1), locationId);//langsung di check order jika item sudah ditemukan
                    
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            
                
        }
        
 public static Vector getStockListByVendorSearch(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder, long vendorId){
            
           String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           String sql4="";
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, sum(du) as totdu, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev, sum(ss) as totminStock from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, sum(s.in_out*s.qty) as tot, 0 as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev, 0 as ss  from pos_item_master m inner join pos_stock s on m.item_master_id=s.item_master_id "+
                " inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id " +
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id  where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 and s.location_id="+locationId+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 and vi.vendor_id="+vendorId;
            
                if(groupid.length()>0 && (groupid != null)){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id ) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, sm.min_stock as minStock, sum(pi.qty) as poprev, 0 as transferprev, 0 as ss "+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_stock_min sm on m.item_master_id=sm.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and sm.location_id="+locationId+" and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and vi.vendor_id="+vendorId+" and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid.length()>0 && (groupid != null)){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, sm.min_stock as minStock, 0 as poprev, sum(ti.qty) as transferprev, 0 as ss "+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join "+
                " pos_stock_min sm on m.item_master_id=sm.item_master_id inner join "+
                " pos_transfer t on ti.transfer_id=t.transfer_id inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id where (m.location_order=504404549948215616 or m.location_order=0)"+
                " and m.is_auto_order=1 and sm.location_id="+locationId+" and m.delivery_unit<>0 and m.is_active=1 and vi.vendor_id="+vendorId+" and m.for_sales=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid.length()>0 && (groupid != null)){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            
            sql4=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock,"+
                " 0 as poprev, 0 as transferprev, sm.min_stock as ss  from pos_item_master m "+
                " inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id " +
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id  where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 "+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 and vi.vendor_id="+vendorId;
            
                if(groupid.length()>0 && (groupid != null)){
                    sql4=sql4+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql4=sql4+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql4=sql4+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql4=sql4+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql4=sql4+" and m.name like '%"+name+"%'";
                }
            sql4=sql4+" group by m.item_master_id ) ";
            
            
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + " union " + sql4+" )) as tabel group by itemId having ((totminStock -(soh+tottransferprev+totpoprev))>=totdu) ";
                                   
            CONResultSet crs = null;
                    
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("totminStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("totdu")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("totminStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("totdu"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("totdu");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("totminStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return vOrder;
        }
public static Vector checkItemOrderSearch(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder){
           String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           String sql4="";
           
           
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, sum(du) as totdu, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev, sum(ss) as totminStock from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, sum(s.in_out*s.qty) as tot, 0 as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev, 0 as ss   from pos_item_master m inner join pos_stock s on m.item_master_id=s.item_master_id "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id  where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 and m.for_buy=1 and s.location_id="+locationId+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 ";
            
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0")){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0")){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id ) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, sm.min_stock as minStock, sum(pi.qty) as poprev, 0 as transferprev, 0 as ss "+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id "+
                " where sm.location_id="+locationId+" and (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and sm.location_id="+locationId+" and sm.min_stock <> 0 and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_buy=1 and m.for_sales=1 and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0")){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0")){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, 0 as minStock, 0 as poprev, sum(ti.qty) as transferprev, 0 as ss"+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join"+
                " pos_transfer t on ti.transfer_id=t.transfer_id "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id "+
                " where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and sm.location_id="+locationId+" and sm.min_stock <> 0 and m.is_auto_order=1 and m.delivery_unit<>0 and sm.location_id="+locationId+" and m.is_active=1 and m.for_buy=1 and m.for_sales=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0")){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0")){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            
            sql4=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev, sm.min_stock as ss  from pos_item_master m "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id  where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_buy=1 and m.for_sales=1 "+
                " and sm.location_id="+locationId+" and sm.min_stock <> 0 ";
            
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0")){
                    sql4=sql4+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0")){
                    sql4=sql4+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql4=sql4+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql4=sql4+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql4=sql4+" and m.name like '%"+name+"%'";
                }
            sql4=sql4+" group by m.item_master_id ";
               
            
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + " union "+sql4+" ))) as tabel group by itemId having ((totminStock -(soh+tottransferprev+totpoprev))>=totdu) ";
                                   
            CONResultSet crs = null;
                    
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("totminStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("totdu")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("totminStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("totdu"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("totdu");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("totminStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return vOrder;
                
        }

public static Vector checkItemOrderPObyVendorSearch(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder, long vendorId, int days){
            
           String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           String sql4="";
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, sum(du) as totdu, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev, sum(ss) as totminStock from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, sum(s.in_out*s.qty) as tot, 0 as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev, 0 as ss  from pos_item_master m inner join pos_stock s on m.item_master_id=s.item_master_id "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id " +
                " inner join pos_vendor_item vi on m.default_vendor_id=vi.vendor_id "+
                " inner join vendor v on vi.vendor_id=v.vendor_id where (m.location_order="+locationOrder+
                " or m.location_order=0) and sm.location_id="+locationId+" and m.delivery_unit<>0 and v.vendor_id="+vendorId+" and vi.vendor_id="+vendorId+" and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 and m.for_buy=1 and s.location_id="+locationId+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 ";
                if(days!=0){
                    if(days==1){
                        sql1 = sql1 + " and v.odr_senin=1";
                    }else if(days==2){
                        sql1 = sql1 + " and v.odr_selasa=1";
                    }else if(days==3){
                        sql1 = sql1 + " and v.odr_rabu=1";
                    }else if(days==4){
                        sql1 = sql1 + " and v.odr_kamis=1";
                    }else if(days==5){
                        sql1 = sql1 + " and v.odr_jumat=1";
                    }else if(days==6){
                        sql1 = sql1 + " and v.odr_sabtu=1";
                    }else if(days==7){
                        sql1 = sql1 + " and v.odr_minggu=1";
                    }
                    
                }
                if(groupid != 0){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id ) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, sm.min_stock as minStock, sum(pi.qty) as poprev, 0 as transferprev, 0 as ss "+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id inner join pos_stock_min sm on m.item_master_id=sm.item_master_id "+
                " where sm.location_id="+locationId+" and (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_buy=1 and m.for_sales=1 and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid != 0){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, 0 as du, sm.min_stock as minStock, 0 as poprev, sum(ti.qty) as transferprev, 0 as ss "+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join"+
                " pos_transfer t on ti.transfer_id=t.transfer_id inner join pos_stock_min sm on m.item_master_id=sm.item_master_id"+
                " where sm.location_id="+locationId+" and (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and m.for_buy=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid != 0){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            sql4=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev, sm.min_stock as ss  from pos_item_master m "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id " +
                " inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id "+
                " inner join vendor v on vi.vendor_id=v.vendor_id where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and v.vendor_id="+vendorId+" and vi.vendor_id="+vendorId+" and m.is_auto_order=1 and m.is_active=1 and m.for_buy=1 and m.for_sales=1" +
                " and sm.location_id="+locationId+" and sm.min_stock<>0 ";
                if(days!=0){
                    if(days==1){
                        sql4 = sql4 + " and v.odr_senin=1";
                    }else if(days==2){
                        sql4 = sql4 + " and v.odr_selasa=1";
                    }else if(days==3){
                        sql4 = sql4 + " and v.odr_rabu=1";
                    }else if(days==4){
                        sql4 = sql4 + " and v.odr_kamis=1";
                    }else if(days==5){
                        sql4 = sql4 + " and v.odr_jumat=1";
                    }else if(days==6){
                        sql4 = sql4 + " and v.odr_sabtu=1";
                    }else if(days==7){
                        sql4 = sql4 + " and v.odr_minggu=1";
                    }
                    
                }
                if(groupid != 0){
                    sql4=sql4+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql4=sql4+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql4=sql4+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql4=sql4+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql4=sql4+" and m.name like '%"+name+"%'";
                }
            sql4=sql4+" group by m.item_master_id ) ";
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + " union " + sql4+ " )) as tabel group by itemId having ((totminStock -(soh+tottransferprev+totpoprev))>=totdu) ";
                                   
            CONResultSet crs = null;
                       
            
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("totminStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("totdu")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("totminStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("totdu"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("totdu");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("totminStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            return vOrder;
                            
        }
public static Vector getStockListByVendorSearchStockAwal(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder, long vendorId){
            
           String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, du, minStock, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev  from pos_item_master m "+
                " inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id " +
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id  where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 "+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 and vi.vendor_id="+vendorId;
            
                if(groupid.length()>0 && (groupid != null)){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id having ((minStock -tot)>=du)) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, sum(pi.qty) as poprev, 0 as transferprev"+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and vi.vendor_id="+vendorId+" and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid.length()>0 && (groupid != null)){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, 0 as poprev, sum(ti.qty) as transferprev"+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join"+
                " pos_transfer t on ti.transfer_id=t.transfer_id inner join pos_vendor_item vi on m.item_master_id=vi.item_master_id where (m.location_order=504404549948215616 or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and vi.vendor_id="+vendorId+" and m.for_sales=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid.length()>0 && (groupid != null)){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null)){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + ")) as tabel group by itemId having ((minStock -(soh+tottransferprev+totpoprev))>=du) ";
                                   
            CONResultSet crs = null;
                    
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("minStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("du")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("minStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("du"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("du");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("minStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return vOrder;
        }

        public static Vector checkItemOrderSearchStockAwal(String barcode, String code, String name, String groupid, String categoryid, long locationId, long locationOrder){
           String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, du, minStock, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev  from pos_item_master m inner join pos_stock_min sm on m.item_master_id=sm.item_master_id "+
                " where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 "+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 ";
            
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0") ){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0") ){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id having ((minStock -tot)>=du)) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, sum(pi.qty) as poprev, 0 as transferprev"+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0") ){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0") ){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, 0 as poprev, sum(ti.qty) as transferprev"+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join"+
                " pos_transfer t on ti.transfer_id=t.transfer_id where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid.length()>0 && (groupid != null) && !groupid.equalsIgnoreCase("0") ){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid.length()>0 && (categoryid != null) && !categoryid.equalsIgnoreCase("0") ){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + ")) as tabel group by itemId having ((minStock -(soh+tottransferprev+totpoprev))>=du) ";
                                   
            CONResultSet crs = null;
                    
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("minStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("du")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("minStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("du"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("du");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("minStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return vOrder;
                
        }
        public static Vector checkItemOrderPObyVendorSearchStockAwal(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder, long vendorId, int days){
            
            String sqlGeneral="" ;
           String sql1="";
           String sql2="";
           String sql3="";
           Vector vOrder= new Vector();
            sqlGeneral="select itemId, sum(tot) as soh, du, minStock, sum(poprev) as totpoprev, sum(transferprev) as tottransferprev from "+
                "(( " ;
            sql1=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, sm.min_stock as minStock,"+
                " 0 as poprev, 0 as transferprev  from pos_item_master m "+
                " inner join pos_stock_min sm on m.item_master_id=sm.item_master_id " +
                " inner join pos_vendor_item vi on m.default_vendor_id=vi.vendor_id "+
                " inner join vendor v on vi.vendor_id=v.vendor_id where (m.location_order="+locationOrder+
                " or m.location_order=0) and m.delivery_unit<>0 and v.vendor_id="+vendorId+" and vi.vendor_id="+vendorId+" and m.is_auto_order=1 and m.is_active=1 and m.for_sales=1 "+
                " and sm.location_id="+locationId+" and sm.min_stock<>0 ";
                if(days!=0){
                    if(days==1){
                        sql1 = sql1 + " and v.odr_senin=1";
                    }else if(days==2){
                        sql1 = sql1 + " and v.odr_selasa=1";
                    }else if(days==3){
                        sql1 = sql1 + " and v.odr_rabu=1";
                    }else if(days==4){
                        sql1 = sql1 + " and v.odr_kamis=1";
                    }else if(days==5){
                        sql1 = sql1 + " and v.odr_jumat=1";
                    }else if(days==6){
                        sql1 = sql1 + " and v.odr_sabtu=1";
                    }else if(days==7){
                        sql1 = sql1 + " and v.odr_minggu=1";
                    }
                    
                }
                if(groupid != 0){
                    sql1=sql1+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql1=sql1+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql1=sql1+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                    sql1=sql1+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql1=sql1+" and m.name like '%"+name+"%'";
                }
            sql1=sql1+" group by m.item_master_id having ((minStock -tot)>=du)) ";
            
            sql2=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, sum(pi.qty) as poprev, 0 as transferprev"+
                " from pos_purchase_item pi inner join pos_item_master m on pi.item_master_id=m.item_master_id inner join "+
                " pos_purchase p on pi.purchase_id=p.purchase_id where (m.location_order="+locationOrder+" or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and p.location_id="+locationId+" and p.status='CHECKED' ";
                if(groupid != 0){
                    sql2=sql2+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql2=sql2+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql2=sql2+" and (m.barcode = '"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"') ";
                }
                if(code.length()>0 && code != null){
                    sql2=sql2+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql2=sql2+" and m.name like '%"+name+"%'";
                }
                sql2=sql2+" group by m.item_master_id) ";
                
            sql3=" (select m.name, m.item_master_id as itemId, 0 as tot, m.delivery_unit as du, 0 as minStock, 0 as poprev, sum(ti.qty) as transferprev"+
                " from pos_transfer_item ti inner join pos_item_master m on ti.item_master_id=m.item_master_id inner join"+
                " pos_transfer t on ti.transfer_id=t.transfer_id where (m.location_order=504404549948215616 or m.location_order=0)"+
                " and m.is_auto_order=1 and m.delivery_unit<>0 and m.is_active=1 and m.for_sales=1 and t.to_location_id="+locationId+" and t.status='DRAFT' ";
                if(groupid != 0){
                    sql3=sql3+" and m.item_group_id in ("+groupid+") ";
                }
                if(categoryid != 0){
                    sql3=sql3+" and m.item_category_id in ("+categoryid+") ";
                }
                if(barcode.length()>0 && barcode != null){
                    sql3=sql3+" and (m.barcode like '%"+barcode+"%' or barcode_2 like '%"+barcode+"%' or barcode_3 like '%"+barcode+"%') ";
                }
                if(code.length()>0 && code != null){
                     sql3=sql3+" and m.code  like '%"+code+"%'";
                }
                if(name.length()>0 && name != null){
                    sql3=sql3+" and m.name like '%"+name+"%'";
                }
            sql3=sql3+" group by m.item_master_id) " ;
            sqlGeneral= sqlGeneral + sql1+" union "+ sql2 + " union "+ sql3 + ")) as tabel group by itemId having ((minStock -(soh+tottransferprev+totpoprev))>=du) ";
                                   
            CONResultSet crs = null;
                       
            
            try{
                crs = CONHandler.execQueryResult(sqlGeneral);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    double soh=rs.getDouble("soh");
                    
                    if(soh<0){
                        soh=0;
                    }
                    if(rs.getDouble("minStock")-(soh+rs.getDouble("totpoprev")+rs.getDouble("tottransferprev"))>=rs.getDouble("du")){
                            
                    
                    
                        Order odr = new Order();
                        odr.setLocationId(locationId);
                        odr.setItemMasterId(rs.getLong("itemId"));

                       
                        double qtyRequest=0;
                                qtyRequest=(((rs.getDouble("minStock")-(soh + rs.getDouble("tottransferprev") + rs.getDouble("totpoprev"))))/rs.getDouble("du"));
                                qtyRequest=Math.floor(qtyRequest)* rs.getDouble("du");

                        odr.setQtyOrder(qtyRequest);
                        odr.setQtyPoPrev(rs.getDouble("totpoprev"));
                        odr.setQtyStandar(rs.getDouble("minStock"));
                        odr.setQtyStock(soh);
                        odr.setStatus("DRAFT");
                        odr.setQtyProces(rs.getDouble("tottransferprev"));
                        odr.setDate(new Date());
                        
                                           
                        vOrder.add(odr);
                    }
                }
            }catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            return vOrder;
                            
        }
     
}
