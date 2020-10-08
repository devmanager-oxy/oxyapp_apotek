

package com.project.fms.asset;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspAssetData extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private AssetData assetData;

	public static final String JSP_NAME_ASSETDATA		=  "JSP_NAME_ASSETDATA" ;

	public static final int JSP_ASSET_DATA_ID			=  0 ;
	public static final int JSP_ITEM_GROUP_ID			=  1 ;
	public static final int JSP_ITEM_CATEGORY_ID			=  2 ;
	public static final int JSP_ITEM_MASTER_ID			=  3 ;
	public static final int JSP_TYPE			=  4 ;
	public static final int JSP_LOCATION_ID			=  5 ;
	public static final int JSP_DEPRESIASI_PERCENT			=  6 ;
	public static final int JSP_QTY			=  7 ;
	public static final int JSP_TGL_PEROLEHAN			=  8 ;
	public static final int JSP_AMOUNT_PEROLEHAN			=  9 ;
	public static final int JSP_BULAN_MULAI_DEPRESIASI			=  10 ;
	public static final int JSP_YEAR_PEROLEHAN			=  11 ;
	public static final int JSP_RESIDU			=  12 ;
	public static final int JSP_YEARLY_DEPRESIASI			=  13 ;
	public static final int JSP_MTH_DEPRESIASI			=  14 ;
	public static final int JSP_COA_AKUM_DEP_ID			=  15 ;
	public static final int JSP_COA_EXPENSE_DEP_ID			=  16 ;
	public static final int JSP_USER_ID			=  17 ;
	public static final int JSP_DATE			=  18 ;
        
        public static final int JSP_TOTAL_DEPRE_SEBELUM			=  19 ;
        public static final int JSP_TGL_DEPRE_TERAKHIR			=  20 ;

	public static String[] colNames = {
		"JSP_ASSET_DATA_ID",  "JSP_ITEM_GROUP_ID",
		"JSP_ITEM_CATEGORY_ID",  "JSP_ITEM_MASTER_ID",
		"JSP_TYPE",  "JSP_LOCATION_ID",
		"JSP_DEPRESIASI_PERCENT",  "JSP_QTY",
		"JSP_TGL_PEROLEHAN",  "JSP_AMOUNT_PEROLEHAN",
		"JSP_BULAN_MULAI_DEPRESIASI",  "JSP_YEAR_PEROLEHAN",
		"JSP_RESIDU",  "JSP_YEARLY_DEPRESIASI",
		"JSP_MTH_DEPRESIASI",  "JSP_COA_AKUM_DEP_ID",
		"JSP_COA_EXPENSE_DEP_ID",  "JSP_USER_ID",
		"JSP_DATE", "JSP_TOTAL_DEPRE_SEBELUM",
                "JSP_TGL_DEPRE_TERAKHIR"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_LONG,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_INT,  TYPE_INT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_DATE, TYPE_FLOAT,
                TYPE_STRING
	} ;

	public JspAssetData(){
	}
	public JspAssetData(AssetData assetData){
		this.assetData = assetData;
	}

	public JspAssetData(HttpServletRequest request, AssetData assetData){
		super(new JspAssetData(assetData), request);
		this.assetData = assetData;
	}

	public String getFormName() { return JSP_NAME_ASSETDATA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public AssetData getEntityObject(){ return assetData; }

	public void requestEntityObject(AssetData assetData) {
		try{
			this.requestParam();
			//assetData.setItemGroupId(getLong(JSP_ITEM_GROUP_ID));
			//assetData.setItemCategoryId(getLong(JSP_ITEM_CATEGORY_ID));
			assetData.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			//assetData.setType(getInt(JSP_TYPE));
			//assetData.setLocationId(getLong(JSP_LOCATION_ID));
			assetData.setDepresiasiPercent(getDouble(JSP_DEPRESIASI_PERCENT));
			//assetData.setQty(getInt(JSP_QTY));
			assetData.setTglPerolehan(JSPFormater.formatDate(getString(JSP_TGL_PEROLEHAN),"dd/MM/yyyy"));
			//assetData.setAmountPerolehan(getDouble(JSP_AMOUNT_PEROLEHAN));
			assetData.setBulanMulaiDepresiasi(getInt(JSP_BULAN_MULAI_DEPRESIASI));
			//assetData.setYearPerolehan(getInt(JSP_YEAR_PEROLEHAN));
			assetData.setResidu(getDouble(JSP_RESIDU));
			//assetData.setYearlyDepresiasi(getDouble(JSP_YEARLY_DEPRESIASI));
			//assetData.setMthDepresiasi(getDouble(JSP_MTH_DEPRESIASI));
			assetData.setCoaAkumDepId(getLong(JSP_COA_AKUM_DEP_ID));
			assetData.setCoaExpenseDepId(getLong(JSP_COA_EXPENSE_DEP_ID));
			assetData.setUserId(getLong(JSP_USER_ID));
                        assetData.setTotalDepreSebelum(getDouble(JSP_TOTAL_DEPRE_SEBELUM));
                        assetData.setTglDepreTerakhir(JSPFormater.formatDate(getString(JSP_TGL_DEPRE_TERAKHIR), "dd/MM/yyyy"));
			//assetData.setDate(getDate(JSP_DATE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
