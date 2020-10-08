/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.reportform;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
/**
 *
 * @author Roy Andika
 */

public class JspRptFms extends JSPHandler implements I_JSPInterface, I_JSPType {
    
        private RptFms rptFms;

	public static final String JSP_NAME_RPTFMS	=  "JSP_NAME_RPTFMS" ;

	public static final int JSP_RPT_FMS_ID		=  0 ;
	public static final int JSP_TYPE_REPORT		=  1 ;
	public static final int JSP_USER_ID		=  2 ;
	public static final int JSP_REPORT_DATE		=  3 ;        
        public static final int JSP_PERIOD_SEARCH_ID    = 4;
        public static final int JSP_LOCATION_ID         = 5;
        public static final int JSP_LOCATION_NAME       = 6;
        public static final int JSP_ALL_COA             = 7;
        
	public static String[] colNames = {
		"JSP_RPT_FMS_ID",  "JSP_TYPE_REPORT",
		"JSP_USER_ID",  "JSP_REPORT_DATE",
                
                "JSP_PERIOD_SEARCH_ID","JSP_LOCATION_ID",
                "JSP_LOCATION_NAME","JSP_ALL_COA"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_INT,
		TYPE_LONG,  TYPE_DATE,
                
                TYPE_LONG,TYPE_LONG,
                TYPE_STRING,TYPE_INT                
	} ;

	public JspRptFms(){
	}
        
	public JspRptFms(RptFms rptFms){
		this.rptFms = rptFms;
	}

	public JspRptFms(HttpServletRequest request, RptFms rptFms){
		super(new JspRptFms(rptFms), request);
		this.rptFms = rptFms;
	}

	public String getFormName() { return JSP_NAME_RPTFMS; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RptFms getEntityObject(){ return rptFms; }

	public void requestEntityObject(RptFms rptFms) {
		try{
			this.requestParam();
                        
			rptFms.setTypeReport(getInt(JSP_TYPE_REPORT));
                        rptFms.setUserId(getLong(JSP_USER_ID));                        
                        rptFms.setPeriodSearchId(getLong(JSP_PERIOD_SEARCH_ID));
                        rptFms.setLocationId(getLong(JSP_LOCATION_ID));
                        rptFms.setLocationName(getString(JSP_LOCATION_NAME));
                        rptFms.setAllCoa(getInt(JSP_ALL_COA));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
