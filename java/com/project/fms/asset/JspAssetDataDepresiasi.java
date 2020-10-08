

package com.project.fms.asset;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspAssetDataDepresiasi extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private AssetDataDepresiasi assetDataDepresiasi;

	public static final String JSP_NAME_ASSETDATADEPRESIASI		=  "JSP_NAME_ASSETDATADEPRESIASI" ;

	public static final int JSP_ASSET_DATA_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_PERIODE_ID			=  2 ;
	public static final int JSP_MTH			=  3 ;
	public static final int JSP_YEAR			=  4 ;
	public static final int JSP_AMOUNT			=  5 ;
	public static final int JSP_USER_ID			=  6 ;
	public static final int JSP_NUMBER			=  7 ;
	public static final int JSP_PREFIX_NUMBER			=  8 ;
	public static final int JSP_COUNTER			=  9 ;
	public static final int JSP_COA_AKUM_DEP_ID			=  10 ;
	public static final int JSP_COA_EXPENSE_DEP_ID			=  11 ;
	public static final int JSP_DEPRE_DATE			=  12 ;
	public static final int JSP_ASSET_DATA_DEPRESIASI_ID			=  13 ;
        
        public static final int JSP_PENGURANG			=  14 ;

	public static String[] colNames = {
		"JSP_ASSET_DATA_ID",  "JSP_DATE",
		"JSP_PERIODE_ID",  "JSP_MTH",
		"JSP_YEAR",  "JSP_AMOUNT",
		"JSP_USER_ID",  "JSP_NUMBER",
		"JSP_PREFIX_NUMBER",  "JSP_COUNTER",
		"JSP_COA_AKUM_DEP_ID",  "JSP_COA_EXPENSE_DEP_ID",
		"JSP_DEPRE_DATE",  "JSP_ASSET_DATA_DEPRESIASI_ID",
                "JSP_PENGURANG"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_LONG,  TYPE_INT,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_LONG,  TYPE_LONG,
		TYPE_DATE,  TYPE_LONG,
                TYPE_FLOAT
	} ;

	public JspAssetDataDepresiasi(){
	}
	public JspAssetDataDepresiasi(AssetDataDepresiasi assetDataDepresiasi){
		this.assetDataDepresiasi = assetDataDepresiasi;
	}

	public JspAssetDataDepresiasi(HttpServletRequest request, AssetDataDepresiasi assetDataDepresiasi){
		super(new JspAssetDataDepresiasi(assetDataDepresiasi), request);
		this.assetDataDepresiasi = assetDataDepresiasi;
	}

	public String getFormName() { return JSP_NAME_ASSETDATADEPRESIASI; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public AssetDataDepresiasi getEntityObject(){ return assetDataDepresiasi; }

	public void requestEntityObject(AssetDataDepresiasi assetDataDepresiasi) {
		try{
			this.requestParam();
			assetDataDepresiasi.setAssetDataId(getLong(JSP_ASSET_DATA_ID));
			assetDataDepresiasi.setDate(getDate(JSP_DATE));
			assetDataDepresiasi.setPeriodeId(getLong(JSP_PERIODE_ID));
			assetDataDepresiasi.setMth(getInt(JSP_MTH));
			assetDataDepresiasi.setYear(getInt(JSP_YEAR));
			assetDataDepresiasi.setAmount(getDouble(JSP_AMOUNT));
			assetDataDepresiasi.setUserId(getInt(JSP_USER_ID));
			assetDataDepresiasi.setNumber(getString(JSP_NUMBER));
			assetDataDepresiasi.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			assetDataDepresiasi.setCounter(getInt(JSP_COUNTER));
			assetDataDepresiasi.setCoaAkumDepId(getLong(JSP_COA_AKUM_DEP_ID));
			assetDataDepresiasi.setCoaExpenseDepId(getLong(JSP_COA_EXPENSE_DEP_ID));
			assetDataDepresiasi.setDepreDate(getDate(JSP_DEPRE_DATE));
                        
                        assetDataDepresiasi.setPengurang(getDouble(JSP_PENGURANG));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
