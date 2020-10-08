
package com.project.ccs.posmaster; 

import java.io.*;
import java.sql.*;
import java.util.*;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

public class DbItemGroup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ITEM_GROUP = "pos_item_group";

	public static final  int COL_ITEM_GROUP_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_ACCOUNT_CODE = 2;
        public static final  int COL_CODE = 3;        
        public static final  int COL_TYPE = 4;
        public static final  int COL_ACCOUNT_SALES = 5;
        public static final  int COL_ACCOUNT_COGS = 6;
        public static final  int COL_ACCOUNT_INV = 7;
        public static final  int COL_IMAGE_NAME = 8;
        public static final  int COL_COMPANY_ID = 9;
        public static final  int COL_ACCOUNT_SALES_CASH = 10;        
        public static final  int COL_ACCOUNT_CASH_INCOME = 11;
        public static final  int COL_ACCOUNT_CREDIT_INCOME = 12;
        public static final  int COL_ACCOUNT_VAT = 13;
        public static final  int COL_ACCOUNT_PPH = 14;
        public static final  int COL_ACCOUNT_DISCOUNT = 15;        
        public static final  int COL_ACCOUNT_SALES_JASA = 16;
        public static final  int COL_ACCOUNT_EXPENSE_JASA = 17;
        public static final  int COL_ACCOUNT_COSTING = 18;        
        public static final  int COL_ACCOUNT_OTHER_INCOME = 19;
        public static final  int COL_ACCOUNT_BONUS_INCOME = 20;
        public static final  int COL_ACCOUNT_AJUSTMENT = 21;
        public static final  int COL_BONUS = 22;
        public static final  int COL_QTY_BELI = 23;
        public static final  int COL_QTY_BONUS = 24;
        
        public static final  int COL_ACCOUNT_GROSIR_SALES = 25;
        public static final  int COL_ACCOUNT_GROSIR_COGS = 26;
        public static final  int COL_ACCOUNT_GROSIR_INVENTORY = 27;
        public static final  int COL_ACCOUNT_GROSIR_DISCOUNT = 28;
        public static final  int COL_ACCOUNT_GROSIR_ADJUSMENT = 29;
        
	public static final  String[] colNames = {
		"item_group_id",
		"name",
		"account_code",
                "code",                
                "type",
                "account_sales",
                "account_cogs",
                "account_inv",
                "image_name",
                "company_id",
                "account_sales_cash",                
                "account_cash_income",
                "account_credit_income",
                "account_vat",
                "account_pph",
                "account_discount",                
                "account_sales_jasa",
                "account_expense_jasa",
                "account_costing",
                "account_other_income",
                "account_bonus_income",
                "account_ajustment",
                "bonus",
                "qty_beli",
                "qty_bonus",
                //untuk kepentingan barang grosir
                "account_grosir_sales",
                "account_grosir_cogs",
                "account_grosir_inventory",
                "account_grosir_discount",
                "account_grosir_adjusment"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_STRING,                
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_STRING,                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                
	 }; 

	public DbItemGroup(){
	}

	public DbItemGroup(int i) throws CONException { 
		super(new DbItemGroup()); 
	}

	public DbItemGroup(String sOid) throws CONException { 
		super(new DbItemGroup(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbItemGroup(long lOid) throws CONException { 
		super(new DbItemGroup(0)); 
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
		return DB_ITEM_GROUP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbItemGroup().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ItemGroup itemgroup = fetchExc(ent.getOID()); 
		ent = (Entity)itemgroup; 
		return itemgroup.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ItemGroup) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ItemGroup) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ItemGroup fetchExc(long oid) throws CONException{ 
		try{ 
			ItemGroup itemgroup = new ItemGroup();
			DbItemGroup pstItemGroup = new DbItemGroup(oid); 
			itemgroup.setOID(oid);

			itemgroup.setName(pstItemGroup.getString(COL_NAME));
			itemgroup.setAccountCode(pstItemGroup.getString(COL_ACCOUNT_CODE));
                        itemgroup.setCode(pstItemGroup.getString(COL_CODE));
                        
                        itemgroup.setType(pstItemGroup.getInt(COL_TYPE));
                        itemgroup.setAccountSales(pstItemGroup.getString(COL_ACCOUNT_SALES));
                        itemgroup.setAccountCogs(pstItemGroup.getString(COL_ACCOUNT_COGS));
                        itemgroup.setAccountInv(pstItemGroup.getString(COL_ACCOUNT_INV));
                        itemgroup.setImageName(pstItemGroup.getString(COL_IMAGE_NAME));
                        itemgroup.setCompanyId(pstItemGroup.getlong(COL_COMPANY_ID));
                        itemgroup.setAccountSalesCash(pstItemGroup.getString(COL_ACCOUNT_SALES_CASH));
                        
                        itemgroup.setAccountCashIncome(pstItemGroup.getString(COL_ACCOUNT_CASH_INCOME));
                        itemgroup.setAccountCreditIncome(pstItemGroup.getString(COL_ACCOUNT_CREDIT_INCOME));
                        itemgroup.setAccountVat(pstItemGroup.getString(COL_ACCOUNT_VAT));
                        itemgroup.setAccountPph(pstItemGroup.getString(COL_ACCOUNT_PPH));
                        itemgroup.setAccountDiscount(pstItemGroup.getString(COL_ACCOUNT_DISCOUNT));
                        itemgroup.setAccountDiscount(pstItemGroup.getString(COL_ACCOUNT_DISCOUNT));
                        itemgroup.setAccountDiscount(pstItemGroup.getString(COL_ACCOUNT_DISCOUNT));
                        
                        itemgroup.setAccountSalesJasa(pstItemGroup.getString(COL_ACCOUNT_SALES_JASA));
                        itemgroup.setAccountExpenseJasa(pstItemGroup.getString(COL_ACCOUNT_EXPENSE_JASA));                        
                        itemgroup.setAccountCosting(pstItemGroup.getString(COL_ACCOUNT_COSTING));          
                        
                        itemgroup.setAccountOtherIncome(pstItemGroup.getString(COL_ACCOUNT_OTHER_INCOME));  
                        itemgroup.setAccountBonusIncome(pstItemGroup.getString(COL_ACCOUNT_BONUS_INCOME)); 
                        itemgroup.setAccountAjustment(pstItemGroup.getString(COL_ACCOUNT_AJUSTMENT)); 
                        
                        itemgroup.setBonus(pstItemGroup.getInt(COL_BONUS)); 
                        itemgroup.setQtyBeli(pstItemGroup.getdouble(COL_QTY_BELI)); 
                        itemgroup.setQtyBonus(pstItemGroup.getdouble(COL_QTY_BONUS)); 
                        
                        itemgroup.setAccountGrosirSales(pstItemGroup.getString(COL_ACCOUNT_GROSIR_SALES)); 
                        itemgroup.setAccountGrosirCOGS(pstItemGroup.getString(COL_ACCOUNT_GROSIR_COGS)); 
                        itemgroup.setAccountGrosirInventory(pstItemGroup.getString(COL_ACCOUNT_GROSIR_INVENTORY)); 
                        itemgroup.setAccountGrosirDiscount(pstItemGroup.getString(COL_ACCOUNT_GROSIR_DISCOUNT)); 
                        itemgroup.setAccountGrosirAdjusment(pstItemGroup.getString(COL_ACCOUNT_GROSIR_ADJUSMENT)); 

			return itemgroup; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemGroup(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ItemGroup itemgroup) throws CONException{ 
		try{ 
			DbItemGroup pstItemGroup = new DbItemGroup(0);

			pstItemGroup.setString(COL_NAME, itemgroup.getName());
			pstItemGroup.setString(COL_ACCOUNT_CODE, itemgroup.getAccountCode());
                        pstItemGroup.setString(COL_CODE, itemgroup.getCode());
                        
                        pstItemGroup.setInt(COL_TYPE, itemgroup.getType());
                        pstItemGroup.setString(COL_ACCOUNT_COGS, itemgroup.getAccountCogs());
                        pstItemGroup.setString(COL_ACCOUNT_INV, itemgroup.getAccountInv());
                        pstItemGroup.setString(COL_ACCOUNT_SALES, itemgroup.getAccountSales());
                        pstItemGroup.setLong(COL_COMPANY_ID, itemgroup.getCompanyId());
                        pstItemGroup.setString(COL_IMAGE_NAME, itemgroup.getImageName());
                        pstItemGroup.setString(COL_ACCOUNT_SALES_CASH, itemgroup.getAccountSalesCash());
                        
                        pstItemGroup.setString(COL_ACCOUNT_CASH_INCOME, itemgroup.getAccountCashIncome());
                        pstItemGroup.setString(COL_ACCOUNT_CREDIT_INCOME, itemgroup.getAccountCreditIncome());
                        pstItemGroup.setString(COL_ACCOUNT_VAT, itemgroup.getAccountVat());
                        pstItemGroup.setString(COL_ACCOUNT_PPH, itemgroup.getAccountPph());
                        pstItemGroup.setString(COL_ACCOUNT_DISCOUNT, itemgroup.getAccountDiscount());
                        
                        pstItemGroup.setString(COL_ACCOUNT_SALES_JASA, itemgroup.getAccountSalesJasa());
                        pstItemGroup.setString(COL_ACCOUNT_EXPENSE_JASA, itemgroup.getAccountExpenseJasa());
                        pstItemGroup.setString(COL_ACCOUNT_COSTING, itemgroup.getAccountCosting());
                        
                        pstItemGroup.setString(COL_ACCOUNT_OTHER_INCOME, itemgroup.getAccountOtherIncome());
                        pstItemGroup.setString(COL_ACCOUNT_BONUS_INCOME, itemgroup.getAccountBonusIncome());
                        pstItemGroup.setString(COL_ACCOUNT_AJUSTMENT, itemgroup.getAccountAjustment());
                        
                        pstItemGroup.setInt(COL_BONUS, itemgroup.getBonus());
                        pstItemGroup.setDouble(COL_QTY_BELI, itemgroup.getQtyBeli());
                        pstItemGroup.setDouble(COL_QTY_BONUS, itemgroup.getQtyBonus());
                        
                        pstItemGroup.setString(COL_ACCOUNT_GROSIR_SALES, itemgroup.getAccountGrosirSales());
                        pstItemGroup.setString(COL_ACCOUNT_GROSIR_COGS, itemgroup.getAccountGrosirCOGS());
                        pstItemGroup.setString(COL_ACCOUNT_GROSIR_INVENTORY, itemgroup.getAccountGrosirInventory());
                        pstItemGroup.setString(COL_ACCOUNT_GROSIR_DISCOUNT, itemgroup.getAccountGrosirDiscount());
                        pstItemGroup.setString(COL_ACCOUNT_GROSIR_ADJUSMENT, itemgroup.getAccountGrosirAdjusment());

			pstItemGroup.insert(); 
			itemgroup.setOID(pstItemGroup.getlong(COL_ITEM_GROUP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemGroup(0),CONException.UNKNOWN); 
		}
		return itemgroup.getOID();
	}

	public static long updateExc(ItemGroup itemgroup) throws CONException{ 
		try{ 
			if(itemgroup.getOID() != 0){ 
				DbItemGroup pstItemGroup = new DbItemGroup(itemgroup.getOID());

				pstItemGroup.setString(COL_NAME, itemgroup.getName());
				pstItemGroup.setString(COL_ACCOUNT_CODE, itemgroup.getAccountCode());
                                pstItemGroup.setString(COL_CODE, itemgroup.getCode());
                                
                                pstItemGroup.setInt(COL_TYPE, itemgroup.getType());
                                pstItemGroup.setString(COL_ACCOUNT_COGS, itemgroup.getAccountCogs());
                                pstItemGroup.setString(COL_ACCOUNT_INV, itemgroup.getAccountInv());
                                pstItemGroup.setString(COL_ACCOUNT_SALES, itemgroup.getAccountSales());
                                pstItemGroup.setLong(COL_COMPANY_ID, itemgroup.getCompanyId());
                                pstItemGroup.setString(COL_IMAGE_NAME, itemgroup.getImageName());
                                pstItemGroup.setString(COL_ACCOUNT_SALES_CASH, itemgroup.getAccountSalesCash());
                                
                                pstItemGroup.setString(COL_ACCOUNT_CASH_INCOME, itemgroup.getAccountCashIncome());
                                pstItemGroup.setString(COL_ACCOUNT_CREDIT_INCOME, itemgroup.getAccountCreditIncome());
                                pstItemGroup.setString(COL_ACCOUNT_VAT, itemgroup.getAccountVat());
                                pstItemGroup.setString(COL_ACCOUNT_PPH, itemgroup.getAccountPph());
                                pstItemGroup.setString(COL_ACCOUNT_DISCOUNT, itemgroup.getAccountDiscount());
                                
                                pstItemGroup.setString(COL_ACCOUNT_SALES_JASA, itemgroup.getAccountSalesJasa());
                                pstItemGroup.setString(COL_ACCOUNT_EXPENSE_JASA, itemgroup.getAccountExpenseJasa());
                                pstItemGroup.setString(COL_ACCOUNT_COSTING, itemgroup.getAccountCosting());
                                
                                pstItemGroup.setString(COL_ACCOUNT_OTHER_INCOME, itemgroup.getAccountOtherIncome());
                                pstItemGroup.setString(COL_ACCOUNT_BONUS_INCOME, itemgroup.getAccountBonusIncome());
                                pstItemGroup.setString(COL_ACCOUNT_AJUSTMENT, itemgroup.getAccountAjustment());
                                
                                pstItemGroup.setInt(COL_BONUS, itemgroup.getBonus());
                                pstItemGroup.setDouble(COL_QTY_BELI, itemgroup.getQtyBeli());
                                pstItemGroup.setDouble(COL_QTY_BONUS, itemgroup.getQtyBonus());
                                
                                pstItemGroup.setString(COL_ACCOUNT_GROSIR_SALES, itemgroup.getAccountGrosirSales());
                                pstItemGroup.setString(COL_ACCOUNT_GROSIR_COGS, itemgroup.getAccountGrosirCOGS());
                                pstItemGroup.setString(COL_ACCOUNT_GROSIR_INVENTORY, itemgroup.getAccountGrosirInventory());
                                pstItemGroup.setString(COL_ACCOUNT_GROSIR_DISCOUNT, itemgroup.getAccountGrosirDiscount());
                                pstItemGroup.setString(COL_ACCOUNT_GROSIR_ADJUSMENT, itemgroup.getAccountGrosirAdjusment());

				pstItemGroup.update(); 
				return itemgroup.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemGroup(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbItemGroup pstItemGroup = new DbItemGroup(oid);
			pstItemGroup.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemGroup(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ITEM_GROUP; 
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
				ItemGroup itemgroup = new ItemGroup();
				resultToObject(rs, itemgroup);
				lists.add(itemgroup);
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

	public static void resultToObject(ResultSet rs, ItemGroup itemgroup){
		try{
			itemgroup.setOID(rs.getLong(DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]));
			itemgroup.setName(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_NAME]));
			itemgroup.setAccountCode(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_CODE]));
                        itemgroup.setCode(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_CODE]));
                        
                        itemgroup.setType(rs.getInt(DbItemGroup.colNames[DbItemGroup.COL_TYPE]));
                        itemgroup.setAccountCogs(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]));
                        itemgroup.setAccountInv(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]));
                        itemgroup.setAccountSales(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES]));
                        itemgroup.setImageName(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_IMAGE_NAME]));
                        itemgroup.setCompanyId(rs.getLong(DbItemGroup.colNames[DbItemGroup.COL_COMPANY_ID]));
                        itemgroup.setAccountSalesCash(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]));
                        
                        itemgroup.setAccountCashIncome(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_CASH_INCOME]));
                        itemgroup.setAccountCreditIncome(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_CREDIT_INCOME]));
                        itemgroup.setAccountVat(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]));
                        itemgroup.setAccountPph(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_PPH]));
                        itemgroup.setAccountDiscount(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]));
                        
                        itemgroup.setAccountSalesJasa(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_JASA]));
                        itemgroup.setAccountExpenseJasa(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_EXPENSE_JASA]));                        
                        itemgroup.setAccountCosting(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COSTING]));                        
                        itemgroup.setAccountOtherIncome(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_OTHER_INCOME]));
                        itemgroup.setAccountBonusIncome(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_BONUS_INCOME]));
                        itemgroup.setAccountAjustment(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT]));
                        
                        itemgroup.setBonus(rs.getInt(DbItemGroup.colNames[DbItemGroup.COL_BONUS]));
                        itemgroup.setQtyBeli(rs.getDouble(DbItemGroup.colNames[DbItemGroup.COL_QTY_BELI]));
                        itemgroup.setQtyBonus(rs.getDouble(DbItemGroup.colNames[DbItemGroup.COL_QTY_BONUS]));
                        
                        itemgroup.setAccountGrosirSales(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]));
                        itemgroup.setAccountGrosirCOGS(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]));
                        itemgroup.setAccountGrosirInventory(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]));
                        itemgroup.setAccountGrosirDiscount(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]));
                        itemgroup.setAccountGrosirAdjusment(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_ADJUSMENT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long itemGroupId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ITEM_GROUP + " WHERE " + 
						DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + itemGroupId;

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
			String sql = "SELECT COUNT("+ DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + ") FROM " + DB_ITEM_GROUP;
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
			  	   ItemGroup itemgroup = (ItemGroup)list.get(ls);
				   if(oid == itemgroup.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
