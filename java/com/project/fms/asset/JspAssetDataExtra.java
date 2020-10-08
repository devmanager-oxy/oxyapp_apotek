

package com.project.fms.asset;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspAssetDataExtra extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private AssetDataExtra assetDataExtra;

	public static final String JSP_NAME_ASSETDATAEXTRA		=  "JSP_NAME_ASSETDATAEXTRA" ;

	public static final int JSP_ASSET_DATA_EXTRA_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_YEAR			=  2 ;
	public static final int JSP_PENGURANG_PEROLEHAN			=  3 ;
	public static final int JSP_PENGURANG_DEPRE			=  4 ;
	public static final int JSP_USER_ID			=  5 ;
	public static final int JSP_ASSET_DATA_ID			=  6 ;

	public static String[] colNames = {
		"JSP_ASSET_DATA_EXTRA_ID",  "JSP_DATE",
		"JSP_YEAR",  "JSP_PENGURANG_PEROLEHAN",
		"JSP_PENGURANG_DEPRE",  "JSP_USER_ID",
		"JSP_ASSET_DATA_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_LONG,
		TYPE_LONG
	} ;

	public JspAssetDataExtra(){
	}
	public JspAssetDataExtra(AssetDataExtra assetDataExtra){
		this.assetDataExtra = assetDataExtra;
	}

	public JspAssetDataExtra(HttpServletRequest request, AssetDataExtra assetDataExtra){
		super(new JspAssetDataExtra(assetDataExtra), request);
		this.assetDataExtra = assetDataExtra;
	}

	public String getFormName() { return JSP_NAME_ASSETDATAEXTRA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public AssetDataExtra getEntityObject(){ return assetDataExtra; }

	public void requestEntityObject(AssetDataExtra assetDataExtra) {
		try{
			this.requestParam();
			assetDataExtra.setDate(getDate(JSP_DATE));
			assetDataExtra.setYear(getInt(JSP_YEAR));
			assetDataExtra.setPengurangPerolehan(getDouble(JSP_PENGURANG_PEROLEHAN));
			assetDataExtra.setPengurangDepre(getDouble(JSP_PENGURANG_DEPRE));
			assetDataExtra.setUserId(getLong(JSP_USER_ID));
			assetDataExtra.setAssetDataId(getLong(JSP_ASSET_DATA_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
