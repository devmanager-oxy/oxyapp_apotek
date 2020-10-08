
package com.project.fms.transaction; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;

import com.project.fms.transaction.*; 
import com.project.fms.activity.*;

public class DbInvoiceItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_INVOICE_ITEM = "invoice_item";

	public static final  int COL_PURCHASE_ITEM_ID = 0;
	public static final  int COL_INVOICE_ID = 1;
	public static final  int COL_INVOICE_ITEM_ID = 2;
	public static final  int COL_COA_ID = 3;
	public static final  int COL_INV_QTY = 4;
	public static final  int COL_PRICE = 5;
	public static final  int COL_TOTAL = 6;
	public static final  int COL_MEMO = 7;
	public static final  int COL_ITEM_TYPE = 8;
        public static final  int COL_ITEM_NAME = 9;
        
        public static final  int COL_DEPARTMENT_ID = 10;

	public static final  String[] colNames = {
		"purchase_item_id",
		"invoice_id",
		"invoice_item_id",
		"coa_id",
		"inv_qty",
		"price",
		"total",
		"memo",
		"item_type",
                "item_name",
                "department_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG
	 }; 

	public DbInvoiceItem(){
	}

	public DbInvoiceItem(int i) throws CONException { 
		super(new DbInvoiceItem()); 
	}

	public DbInvoiceItem(String sOid) throws CONException { 
		super(new DbInvoiceItem(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbInvoiceItem(long lOid) throws CONException { 
		super(new DbInvoiceItem(0)); 
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
		return DB_INVOICE_ITEM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbInvoiceItem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		InvoiceItem invoiceitem = fetchExc(ent.getOID()); 
		ent = (Entity)invoiceitem; 
		return invoiceitem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((InvoiceItem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((InvoiceItem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static InvoiceItem fetchExc(long oid) throws CONException{ 
		try{ 
			InvoiceItem invoiceitem = new InvoiceItem();
			DbInvoiceItem pstInvoiceItem = new DbInvoiceItem(oid); 
			invoiceitem.setOID(oid);

			invoiceitem.setPurchaseItemId(pstInvoiceItem.getlong(COL_PURCHASE_ITEM_ID));
			invoiceitem.setInvoiceId(pstInvoiceItem.getlong(COL_INVOICE_ID));
			invoiceitem.setCoaId(pstInvoiceItem.getlong(COL_COA_ID));
			invoiceitem.setInvQty(pstInvoiceItem.getInt(COL_INV_QTY));
			invoiceitem.setPrice(pstInvoiceItem.getdouble(COL_PRICE));
			invoiceitem.setTotal(pstInvoiceItem.getdouble(COL_TOTAL));
			invoiceitem.setMemo(pstInvoiceItem.getString(COL_MEMO));
			invoiceitem.setItemType(pstInvoiceItem.getString(COL_ITEM_TYPE));
                        invoiceitem.setItemName(pstInvoiceItem.getString(COL_ITEM_NAME));
                        
                        invoiceitem.setDepartmentId(pstInvoiceItem.getlong(COL_DEPARTMENT_ID));
                        

			return invoiceitem; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoiceItem(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(InvoiceItem invoiceitem) throws CONException{ 
		try{ 
			DbInvoiceItem pstInvoiceItem = new DbInvoiceItem(0);

			pstInvoiceItem.setLong(COL_PURCHASE_ITEM_ID, invoiceitem.getPurchaseItemId());
			pstInvoiceItem.setLong(COL_INVOICE_ID, invoiceitem.getInvoiceId());
			pstInvoiceItem.setLong(COL_COA_ID, invoiceitem.getCoaId());
			pstInvoiceItem.setDouble(COL_INV_QTY, invoiceitem.getInvQty());
			pstInvoiceItem.setDouble(COL_PRICE, invoiceitem.getPrice());
			pstInvoiceItem.setDouble(COL_TOTAL, invoiceitem.getTotal());
			pstInvoiceItem.setString(COL_MEMO, invoiceitem.getMemo());
			pstInvoiceItem.setString(COL_ITEM_TYPE, invoiceitem.getItemType());
                        pstInvoiceItem.setString(COL_ITEM_NAME, invoiceitem.getItemName());
                        
                        pstInvoiceItem.setLong(COL_DEPARTMENT_ID, invoiceitem.getDepartmentId());

			pstInvoiceItem.insert(); 
			invoiceitem.setOID(pstInvoiceItem.getlong(COL_INVOICE_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoiceItem(0),CONException.UNKNOWN); 
		}
		return invoiceitem.getOID();
	}

	public static long updateExc(InvoiceItem invoiceitem) throws CONException{ 
		try{ 
			if(invoiceitem.getOID() != 0){ 
				DbInvoiceItem pstInvoiceItem = new DbInvoiceItem(invoiceitem.getOID());

				pstInvoiceItem.setLong(COL_PURCHASE_ITEM_ID, invoiceitem.getPurchaseItemId());
				pstInvoiceItem.setLong(COL_INVOICE_ID, invoiceitem.getInvoiceId());
				pstInvoiceItem.setLong(COL_COA_ID, invoiceitem.getCoaId());
				pstInvoiceItem.setDouble(COL_INV_QTY, invoiceitem.getInvQty());
				pstInvoiceItem.setDouble(COL_PRICE, invoiceitem.getPrice());
				pstInvoiceItem.setDouble(COL_TOTAL, invoiceitem.getTotal());
				pstInvoiceItem.setString(COL_MEMO, invoiceitem.getMemo());
				pstInvoiceItem.setString(COL_ITEM_TYPE, invoiceitem.getItemType());
                                pstInvoiceItem.setString(COL_ITEM_NAME, invoiceitem.getItemName());
                                pstInvoiceItem.setLong(COL_DEPARTMENT_ID, invoiceitem.getDepartmentId());

				pstInvoiceItem.update(); 
				return invoiceitem.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoiceItem(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbInvoiceItem pstInvoiceItem = new DbInvoiceItem(oid);
			pstInvoiceItem.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoiceItem(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_INVOICE_ITEM; 
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
				InvoiceItem invoiceitem = new InvoiceItem();
				resultToObject(rs, invoiceitem);
				lists.add(invoiceitem);
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

	private static void resultToObject(ResultSet rs, InvoiceItem invoiceitem){
		try{
			invoiceitem.setOID(rs.getLong(DbInvoiceItem.colNames[DbInvoiceItem.COL_INVOICE_ITEM_ID]));
			invoiceitem.setPurchaseItemId(rs.getLong(DbInvoiceItem.colNames[DbInvoiceItem.COL_PURCHASE_ITEM_ID]));
			invoiceitem.setInvoiceId(rs.getLong(DbInvoiceItem.colNames[DbInvoiceItem.COL_INVOICE_ID]));
			invoiceitem.setCoaId(rs.getLong(DbInvoiceItem.colNames[DbInvoiceItem.COL_COA_ID]));
			invoiceitem.setInvQty(rs.getInt(DbInvoiceItem.colNames[DbInvoiceItem.COL_INV_QTY]));
			invoiceitem.setPrice(rs.getDouble(DbInvoiceItem.colNames[DbInvoiceItem.COL_PRICE]));
			invoiceitem.setTotal(rs.getDouble(DbInvoiceItem.colNames[DbInvoiceItem.COL_TOTAL]));
			invoiceitem.setMemo(rs.getString(DbInvoiceItem.colNames[DbInvoiceItem.COL_MEMO]));
			invoiceitem.setItemType(rs.getString(DbInvoiceItem.colNames[DbInvoiceItem.COL_ITEM_TYPE]));
                        invoiceitem.setItemName(rs.getString(DbInvoiceItem.colNames[DbInvoiceItem.COL_ITEM_NAME]));
                        
                        invoiceitem.setDepartmentId(rs.getLong(DbInvoiceItem.colNames[DbInvoiceItem.COL_DEPARTMENT_ID]));

		}catch(Exception e){ }
	}

	

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbInvoiceItem.colNames[DbInvoiceItem.COL_INVOICE_ITEM_ID] + ") FROM " + DB_INVOICE_ITEM;
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
			  	   InvoiceItem invoiceitem = (InvoiceItem)list.get(ls);
				   if(oid == invoiceitem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static double getItemReceived(PurchaseItem pi){
            
                double result = 0;
                CONResultSet crs = null; 
                try{
                    String sql = "select sum(ii.inv_qty) from "+DbInvoiceItem.DB_INVOICE_ITEM+" ii "+
                    " inner join "+DbInvoice.DB_INVOICE+" i on i.invoice_id=ii.invoice_id "+
                    " where ii.item_name='"+pi.getItemName()+"' and ii.coa_id="+pi.getCoaId()+
                    " and ii.item_type='"+pi.getItemType()+"' and i.purchase_id="+pi.getPurchaseId();
                    
                    //System.out.println(sql);
                    
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while(rs.next()){
                        result = rs.getDouble(1);
                    }
                }
                catch(Exception e){
                    System.out.println(e.toString());
                }
                finally{
                    
                }
                return result;
        }
        
        public static void insertItems(long invoiceOID, Vector vInvEdit){
            
            if(vInvEdit!=null && vInvEdit.size()>0){
                
                deleteByInvoiceId(invoiceOID);
                
                for(int i=0; i<vInvEdit.size(); i++){
                    InvoiceItem ii = (InvoiceItem)vInvEdit.get(i);
                    if(ii.getInvQty()>0){
                        try{
                            ii.setInvoiceId(invoiceOID);
                            DbInvoiceItem.insertExc(ii);
                        }
                        catch(Exception e){
                            System.out.println(e.toString());
                        }
                    }
                }
            }
        }
        
        public static void deleteByInvoiceId(long invoiceOID){
            try{
                String str = "delete from "+DB_INVOICE_ITEM+" where "+colNames[COL_INVOICE_ID]+"="+ invoiceOID;
                CONHandler.execUpdate(str);
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
        }
        
        
        public static Vector getActivityPredefined(long paymentOID){
            Vector result = new Vector();
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            CONResultSet crs = null;
            try{
                String sql = "SELECT c.*, pd.* FROM coa_activity_budget c inner join invoice_item pd on pd.coa_id=c.coa_id "+
                    " where pd.invoice_id="+paymentOID+" and c.activity_period_id = "+ap.getOID();
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    CoaActivityBudget cab = new CoaActivityBudget();
                    InvoiceItem ppd = new InvoiceItem();
                    DbCoaActivityBudget.resultToObject(rs, cab);
                    DbInvoiceItem.resultToObject(rs, ppd);
                    Vector v = new Vector();
                    v.add(cab);
                    v.add(ppd);
                    result.add(v);
                }
                
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
}
