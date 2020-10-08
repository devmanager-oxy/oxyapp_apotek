
package com.project.general;

import com.project.util.JSPFormater;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspLocation extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Location location;

	public static final String JSP_NAME_LOCATION		=  "JSP_NAME_LOCATION" ;

	public static final int JSP_LOCATION_ID			=  0 ;
	public static final int JSP_TYPE			=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_ADDRESS_STREET		=  3 ;
	public static final int JSP_ADDRESS_COUNTRY		=  4 ;
	public static final int JSP_ADDRESS_CITY		=  5 ;
	public static final int JSP_TELP			=  6 ;
        public static final int JSP_PIC                         =  7 ;
        public static final int JSP_CODE			=  8 ;
        public static final int JSP_DESCRIPTION			=  9 ;
        public static final int JSP_COA_AR_ID			=  10;
	public static final int JSP_COA_AP_ID			=  11;
	public static final int JSP_COA_PPN_ID			=  12;
	public static final int JSP_COA_PPH_ID			=  13;
	public static final int JSP_COA_DISCOUNT_ID		=  14;   
        public static final int JSP_COA_SALES_ID		=  15;           
        public static final int JSP_COA_PROJECT_PPH_PASAL_23_ID =  16;
        public static final int JSP_COA_PROJECT_PPH_PASAL_22_ID =  17;
        public static final int JSP_LOCATION_ID_REQUEST         =  18;
        public static final int JSP_GOL_PRICE                   =  19;
        public static final int JSP_NPWP                        =  20;
        public static final int JSP_PREFIX_FAKTUR_PAJAK         =  21;
        public static final int JSP_PREFIX_FAKTUR_TRANSFER      =  22;
        public static final int JSP_AKTIF_AUTO_ORDER            =  23;
        public static final int JSP_DATE_START                  =  24;
        public static final int JSP_TYPE_GROSIR                 =  25;
        public static final int JSP_TYPE_24HOUR                 =  26;
        public static final int JSP_AMOUNT_TARGET               =  27;
        public static final int JSP_COA_AP_GROSIR_ID	        =  28;
        
	public static String[] colNames = {
		"JSP_LOCATION_ID",  "JSP_TYPE",
		"JSP_NAME",  "JSP_ADDRESS_STREET",
		"JSP_ADDRESS_COUNTRY",  "JSP_ADDRESS_CITY",
		"JSP_TELP",  "JSP_PIC",
                "JSP_CODE", "JSP_DESCRIPTION",
                "JSP_COA_AR_ID",
		"JSP_COA_AP_ID",  "JSP_COA_PPN_ID",
		"JSP_COA_PPH_ID",  "JSP_COA_DISCOUNT_ID",  
                "JSP_COA_SALES_ID", "JSP_COA_PROJECT_PPH_PASAL_23_ID",
                "JSP_COA_PROJECT_PPH_PASAL_22_ID", "JSP_LOCATION_ID_REQUEST",
                "JSP_GOL_PRICE","JPS_NPWP",
                "JSP_PREFIX_FAKTUR_PAJAK",
                "JSP_PREFIX_FAKTUR_TRANSFER",
                "JSP_AKTIF_AUTO_ORDER","JSP_DATE_START",
                "JSP_TYPE_GROSIR","JSP_TYPE_24HOUR",
                "JSP_AMOUNT_TARGET","JSP_COA_AP_GROSIR_ID"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
                TYPE_STRING + ENTRY_REQUIRED, TYPE_STRING,
                TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
                TYPE_LONG,  TYPE_LONG,
                TYPE_LONG, TYPE_STRING,
                TYPE_STRING, TYPE_STRING,
                TYPE_STRING, TYPE_INT,
                TYPE_STRING,TYPE_INT,
                TYPE_INT,TYPE_FLOAT,
                TYPE_LONG
	};

	public JspLocation(){
	}
	public JspLocation(Location location){
		this.location = location;
	}

	public JspLocation(HttpServletRequest request, Location location){
		super(new JspLocation(location), request);
		this.location = location;
	}

	public String getFormName() { return JSP_NAME_LOCATION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Location getEntityObject(){ return location; }

	public void requestEntityObject(Location location) {
		try{			
                        this.requestParam();
			location.setType(getString(JSP_TYPE));
			location.setName(getString(JSP_NAME));
			location.setAddressStreet(getString(JSP_ADDRESS_STREET));
			location.setAddressCountry(getString(JSP_ADDRESS_COUNTRY));
			location.setAddressCity(getString(JSP_ADDRESS_CITY));
			location.setTelp(getString(JSP_TELP));
			location.setPic(getString(JSP_PIC));
                        location.setCode(getString(JSP_CODE));
                        location.setDescription(getString(JSP_DESCRIPTION));
                        location.setCoaArId(getLong(JSP_COA_AR_ID));
			location.setCoaApId(getLong(JSP_COA_AP_ID));
			location.setCoaPpnId(getLong(JSP_COA_PPN_ID));
			location.setCoaPphId(getLong(JSP_COA_PPH_ID));
			location.setCoaDiscountId(getLong(JSP_COA_DISCOUNT_ID));
                        location.setCoaSalesId(getLong(JSP_COA_SALES_ID));
                        location.setCoaProjectPPHPasal23Id(getLong(JSP_COA_PROJECT_PPH_PASAL_23_ID));
                        location.setCoaProjectPPHPasal22Id(getLong(JSP_COA_PROJECT_PPH_PASAL_22_ID));
                        location.setLocationIdRequest(getLong(JSP_LOCATION_ID_REQUEST));
                        location.setGol_price(getString(JSP_GOL_PRICE));
                        location.setNpwp(getString(JSP_NPWP));
                        location.setPrefixFakturPajak(getString(JSP_PREFIX_FAKTUR_PAJAK));
                        location.setPrefixFakturTransfer(getString(JSP_PREFIX_FAKTUR_TRANSFER));
                        location.setAktifAutoOrder(getInt(JSP_AKTIF_AUTO_ORDER));                        
                        location.setDateStart(JSPFormater.formatDate(getString(JSP_DATE_START), "dd/MM/yyyy"));
                        location.setTypeGrosir(getInt(JSP_TYPE_GROSIR));
                        location.setType24Hour(getInt(JSP_TYPE_24HOUR));
                        location.setAmountTarget(getDouble(JSP_AMOUNT_TARGET));
                        location.setCoaApGrosirId(getLong(JSP_COA_AP_GROSIR_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
