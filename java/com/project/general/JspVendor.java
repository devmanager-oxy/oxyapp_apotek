
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspVendor extends JSPHandler implements I_JSPInterface, I_JSPType {
    
	private Vendor vendor;
        
	public static final String JSP_NAME_VENDOR		=  "vendor";

	public static final int JSP_NAME			= 0 ;
	public static final int JSP_VENDOR_ID			= 1 ;
	public static final int JSP_CODE			= 2 ;
	public static final int JSP_ADDRESS			= 3 ;
	public static final int JSP_CITY			= 4 ;
	public static final int JSP_STATE			= 5 ;
	public static final int JSP_PHONE			= 6 ;
	public static final int JSP_HP                          = 7 ;
	public static final int JSP_FAX                         = 8 ;
	public static final int JSP_DUE_DATE			= 9 ;
	public static final int JSP_CONTACT			= 10 ;
	public static final int JSP_COUNTRY_NAME		= 11 ;
	public static final int JSP_COUNTRY_ID			= 12 ;
	public static final int JSP_TYPE			= 13 ;
        
        public static final  int JSP_DISCOUNT                   = 14;
        public static final  int JSP_EMAIL                      = 15;
        public static final  int JSP_NPWP                       = 16;
        public static final  int JSP_VENDOR_TYPE                = 17;
        public static final  int JSP_PREV_LIABILITY             = 18;
        public static final  int JSP_WEB_PAGE                   = 19;
        public static final  int JSP_DIRECT_RECEIVE             = 20;
        public static final  int JSP_IS_KONSINYASI              = 21;
        public static final  int JSP_IS_PKP                     = 22;
        public static final  int JSP_INCLUDE_PPN                = 23;
        public static final  int JSP_KOMISI_PERCENT             = 24;        
        public static final int JSP_PERCENT_MARGIN              = 25;
        public static final int JSP_PERCENT_PROMOSI             = 26;
        public static final int JSP_PERCENT_BARCODE             = 27;
        public static final int JSP_SYSTEM                      = 28;
        
        public static final int JSP_KOMISI_MARGIN  =29;
        public static final int JSP_KOMISI_PROMOSI =30;
        public static final int JSP_KOMISI_BARCODE =31;
        public static final int JSP_IS_KOMISI  = 32;
        
        public static final int JSP_ODR_SENIN  = 33;
        public static final int JSP_ODR_SELASA  = 34;
        public static final int JSP_ODR_RABU  = 35;
        public static final int JSP_ODR_KAMIS  = 36;
        public static final int JSP_ODR_JUMAT  = 37;
        public static final int JSP_ODR_SABTU  = 38;
        public static final int JSP_ODR_MINGGU  = 39;
        public static final int JSP_PENDING_ONE_PO  = 40;
        public static final int JSP_TYPE_LOC_INCOMING  = 41;
        
        public static final int JSP_NO_REK = 42;
        public static final int JSP_BANK_ID = 43;
        public static final int JSP_PAYMENT_TYPE = 44;
        public static final int JSP_PIC = 45;        
        public static final int JSP_LIABILITIES_TYPE = 46;

	public static String[] colNames = {
		"JSP_NAME",  
                "JSP_VENDOR_ID",
		"JSP_CODE",  
                "JSP_ADDRESS",
		"JSP_CITY",  
                "JSP_STATE",
		"JSP_PHONE",  
                "JSP_HP",
		"JSP_FAX",  
                "JSP_DUE_DATE",
		"JSP_CONTACT",  
                "JSP_COUNTRY_NAME",
		"JSP_COUNTRY_ID",  
                "JSP_TYPE",
                
                "JSP_DISCOUNT",
                "JSP_EMAIL",
                "JSP_NPWP",
                "JSP_VENDOR_TYPE",
                "JSP_PREV_LIABILITY",
                "JSP_WEB_PAGE",
                "JSP_DIRECT_RECEIVE",
                "JSP_IS_KONSINYASI",
                "JSP_IS_PKP",
                "JSP_INCLUDE_PPN",
                "JSP_KOMISI_PERCENT",
                "JSP_PERCENT_MARGIN",
                "JSP_PERCENT_PROMOSI",
                "JSP_PERCENT_BARCODE",
                "JSP_SYSTEM",
                "JSP_KOMISI_MARGIN",
                "JSP_KOMISI_PROMOSI",
                "JSP_KOMISI_BARCODE",
                "JSP_IS_KOMISI",
                "JSP_ODR_SENIN",
                "JSP_ODR_SELASA",
                "JSP_ODR_RABU",
                "JSP_ODR_KAMIS",
                "JSP_ODR_JUMAT",
                "JSP_ODR_SABTU",
                "JSP_ODR_MINGGU",
                "JSP_PENDING_ONE_PO",
                "JSP_TYPE_LOC_INCOMING",
                "JSP_NO_REK",
                "JSP_BANK_ID",
                "JSP_PAYMENT_TYPE",
                "JSP_PIC",
                "JSP_LIABILITIES_TYPE"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING + ENTRY_REQUIRED,  
                TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,  
                TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  
                TYPE_STRING,
		TYPE_STRING,  
                TYPE_STRING,
		TYPE_STRING,  
                TYPE_INT,
		TYPE_STRING,  
                TYPE_STRING,
		TYPE_LONG,  
                TYPE_INT,
                
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_INT,
                TYPE_STRING,
                TYPE_INT
	};        

	public JspVendor(){
	}
        
	public JspVendor(Vendor vendor){
		this.vendor = vendor;
	}

	public JspVendor(HttpServletRequest request, Vendor vendor){
		super(new JspVendor(vendor), request);
		this.vendor = vendor;
	}

	public String getFormName() { return JSP_NAME_VENDOR; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Vendor getEntityObject(){ return vendor; }

	public void requestEntityObject(Vendor vendor) {
		try{
			this.requestParam();
			vendor.setName(getString(JSP_NAME));
			vendor.setCode(getString(JSP_CODE));
			vendor.setAddress(getString(JSP_ADDRESS));
			vendor.setCity(getString(JSP_CITY));
			vendor.setState(getString(JSP_STATE));
			vendor.setPhone(getString(JSP_PHONE));
			vendor.setHp(getString(JSP_HP));
			vendor.setFax(getString(JSP_FAX));
			vendor.setDueDate(getInt(JSP_DUE_DATE));			
			vendor.setCountryName(getString(JSP_COUNTRY_NAME));
			vendor.setCountryId(getLong(JSP_COUNTRY_ID));
			vendor.setType(getInt(JSP_TYPE));
                     
                        vendor.setDiscount(getDouble(JSP_DISCOUNT));
                        vendor.setEmail(getString(JSP_EMAIL));
                        vendor.setNpwp(getString(JSP_NPWP));
                        vendor.setVendorType(getString(JSP_VENDOR_TYPE));
                        vendor.setPrevLiability(getDouble(JSP_PREV_LIABILITY));
                        vendor.setWebPage(getString(JSP_WEB_PAGE));
                        vendor.setDirectReceive(getInt(JSP_DIRECT_RECEIVE));
                        vendor.setIsKonsinyasi(getInt(JSP_IS_KONSINYASI));
                        vendor.setIsPKP(getInt(JSP_IS_PKP));
                        vendor.setIncludePPN(getInt(JSP_INCLUDE_PPN));
                        vendor.setKomisiPercent(getDouble(JSP_KOMISI_PERCENT));                        
                        vendor.setPercentMargin(getDouble(JSP_PERCENT_MARGIN));
                        vendor.setPercentPromosi(getDouble(JSP_PERCENT_PROMOSI));
                        vendor.setPercentBarcode(getDouble(JSP_PERCENT_BARCODE));
                        vendor.setSystem(getInt(JSP_SYSTEM));                        
                        vendor.setKomisiMargin(getDouble(JSP_KOMISI_MARGIN));
                        vendor.setKomisiPromosi(getDouble(JSP_KOMISI_PROMOSI));
                        vendor.setKomisiBarcode(getDouble(JSP_KOMISI_BARCODE));
                        vendor.setIsKomisi(getInt(JSP_IS_KOMISI));                        
                        vendor.setOdrSenin(getInt(JSP_ODR_SENIN));
                        vendor.setOdrSelasa(getInt(JSP_ODR_SELASA));
                        vendor.setOdrRabu(getInt(JSP_ODR_RABU));
                        vendor.setOdrKamis(getInt(JSP_ODR_KAMIS));
                        vendor.setOdrJumat(getInt(JSP_ODR_JUMAT));
                        vendor.setOdrSabtu(getInt(JSP_ODR_SABTU));
                        vendor.setOdrMinggu(getInt(JSP_ODR_MINGGU));
                        vendor.setPendingOnePo(getInt(JSP_PENDING_ONE_PO));
                        vendor.setTypeLocIncoming(getString(JSP_TYPE_LOC_INCOMING));                        
                        vendor.setPic(getString(JSP_PIC));
                        vendor.setLiabilitiesType(getInt(JSP_LIABILITIES_TYPE));                        
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
