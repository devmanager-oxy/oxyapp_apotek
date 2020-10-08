
package com.project.ccs.postransaction.repack;


import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

public class JspRepack extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Repack repack;

	public static final String JSP_NAME_REPACK		=  "JSP_NAME_REPACK" ;

	public static final int JSP_REPACK_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_COUNTER			=  2 ;
	public static final int JSP_NUMBER			=  3 ;
	public static final int JSP_NOTE			=  4 ;
	public static final int JSP_APPROVAL_1			=  5 ;
	public static final int JSP_APPROVAL_2			=  6 ;
	public static final int JSP_APPROVAL_3			=  7 ;
	public static final int JSP_STATUS			=  8 ;
	public static final int JSP_LOCATION_ID			=  9 ;
	public static final int JSP_USER_ID			=  10;
        public static final int JSP_PREFIX_NUMBER		=  11;
        public static final int JSP_POSTED_STATUS               =  12;
        public static final int JSP_POSTED_BY_ID                =  13;
        public static final int JSP_POSTED_DATE                 =  14;
        public static final int JSP_EFFECTIVE_DATE              =  15;

	public static String[] colNames = {
		"JSP_REPACK_ID",  "JSP_DATE",
		"JSP_COUNTER",  "JSP_NUMBER",
		"JSP_NOTE",  "JSP_APPROVAL_1",
		"JSP_APPROVAL_2",  "JSP_APPROVAL_3",
		"JSP_STATUS",  "JSP_LOCATION_ID",
		"JSP_USER_ID", "JSP_PREFIX_NUMBER",
                "JSP_POSTED_STATUS","JSP_POSTED_BY_ID",
                "JSP_POSTED_DATE","JSP_EFFECTIVE_DATE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG, TYPE_INT,
                TYPE_INT,TYPE_LONG,
                TYPE_DATE,TYPE_DATE
	};

	public JspRepack(){
	}
	public JspRepack(Repack repack){
		this.repack = repack;
	}

	public JspRepack(HttpServletRequest request, Repack repack){
		super(new JspRepack(repack), request);
		this.repack = repack;
	}

	public String getFormName() { return JSP_NAME_REPACK; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Repack getEntityObject(){ return repack; }

	public void requestEntityObject(Repack repack) {
		try{
			this.requestParam();                        
                        Date newDate = new Date();
                        newDate =JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
                        newDate.setHours(new Date().getHours());
                        newDate.setMinutes(new Date().getMinutes());
                        newDate.setSeconds(new Date().getSeconds());
                        repack.setDate(newDate);
			repack.setNote(getString(JSP_NOTE));
			repack.setStatus(getString(JSP_STATUS));
			repack.setLocationId(getLong(JSP_LOCATION_ID));
			repack.setUserId(getLong(JSP_USER_ID));                                                
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
