package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspSystemDocCode extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SystemDocCode systemDocCode;

	public static final String JSP_NAME_SYSTEMDOCCODE	=  "JSP_NAME_SYSTEMDOCCODE" ;

	public static final int JSP_SYSTEM_DOC_CODE_ID		=  0 ;
	public static final int JSP_CODE			=  1 ;
	public static final int JSP_TYPE			=  2 ;
	public static final int JSP_CODE_FORMAT			=  3 ;
	public static final int JSP_SEPARATOR			=  4 ;
        public static final int JSP_DIGIT_COUNTER		=  5 ;
        public static final int JSP_POSISI_AFTER_CODE		=  6 ;        
        public static final int JSP_YEAR_DIGIT                  =  7 ;
        public static final int JSP_MONTH_DIGIT                 =  8 ;
        public static final int JSP_MONTH_TYPE                  =  9 ;        

	public static String[] colNames = {
		"JSP_SYSTEM_DOC_CODE_ID",  "JSP_CODE",
		"JSP_TYPE",  "JSP_CODE_FORMAT",
		"JSP_SEPARATOR","JSP_DIGIT_COUNTER",
                "JSP_POSISI_AFTER_CODE","JSP_YEAR_DIGIT",
                "JSP_MONTH_DIGIT","JSP_MONTH_TYPE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING, TYPE_INT,
                TYPE_INT,TYPE_INT,
                TYPE_INT,TYPE_INT
	} ;

	public JspSystemDocCode(){
	}
        
	public JspSystemDocCode(SystemDocCode systemDocCode){
		this.systemDocCode = systemDocCode;
	}

	public JspSystemDocCode(HttpServletRequest request, SystemDocCode systemDocCode){
		super(new JspSystemDocCode(systemDocCode), request);
		this.systemDocCode = systemDocCode;
	}

	public String getFormName() { return JSP_NAME_SYSTEMDOCCODE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SystemDocCode getEntityObject(){ return systemDocCode; }

	public void requestEntityObject(SystemDocCode systemDocCode) {
		try{
			this.requestParam();
			systemDocCode.setCode(getString(JSP_CODE));
			systemDocCode.setType(getString(JSP_TYPE));
			systemDocCode.setCodeFormat(getString(JSP_CODE_FORMAT));
			systemDocCode.setSeparator(getString(JSP_SEPARATOR));                        
                        systemDocCode.setDigitCounter(getInt(JSP_DIGIT_COUNTER));
                        systemDocCode.setPosisiAfterCode(getInt(JSP_POSISI_AFTER_CODE));
                        systemDocCode.setYearDigit(getInt(JSP_YEAR_DIGIT));
                        systemDocCode.setMonthDigit(getInt(JSP_MONTH_DIGIT));
                        systemDocCode.setMonthType(getInt(JSP_MONTH_TYPE));                        
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
