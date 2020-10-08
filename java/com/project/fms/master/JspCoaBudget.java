
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaBudget extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaBudget coaBudget;

	public static final String JSP_NAME_COABUDGET		=  "JSP_NAME_COABUDGET" ;

	public static final int JSP_COA_ID			=  0 ;
	public static final int JSP_PERIODE_ID			=  1 ;
	public static final int JSP_COA_BUDGET_ID		=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
        public static final int JSP_BGT_YEAR			=  4 ;
        public static final int JSP_BGT_MONTH			=  5 ;
        public static final int JSP_DIVISION_ID			=  6 ;
        public static final int JSP_DEPARTMENT_ID		=  7 ;
        public static final int JSP_DIREKTORAT_ID		=  8 ;
        public static final int JSP_COA_CODE                    =  9 ;
        public static final int JSP_SECTION_ID                  = 10;
        public static final int JSP_JOB_ID                      = 11;
    
        public static final int JSP_COALEVEL_1_ID               = 12;
        public static final int JSP_COALEVEL_2_ID               = 13;
        public static final int JSP_COALEVEL_3_ID               = 14;
        public static final int JSP_COALEVEL_4_ID               = 15;
        public static final int JSP_COALEVEL_5_ID               = 16;
        public static final int JSP_COALEVEL_6_ID               = 17;
        public static final int JSP_COALEVEL_7_ID               = 18;
        
        public static final int JSP_SEGMENT1_ID = 19;
        public static final int JSP_SEGMENT2_ID = 20;
        public static final int JSP_SEGMENT3_ID = 21;
        public static final int JSP_SEGMENT4_ID = 22;
        public static final int JSP_SEGMENT5_ID = 23;

	public static String[] colNames = {
		"JSP_COA_ID",  
                "JSP_PERIODE_ID",
		"JSP_COA_BUDGET_ID",  
                "JSP_AMOUNT",                
                "JSP_BGT_YEAR",
                "JSP_BGT_MONTH",
                "JSP_DIVISION_ID",
                "JSP_DEPARTMENT_ID",
                "JSP_DIREKTORAT_ID",
                "JSP_COA_CODE",
                "JSP_SECTION_ID",
                "JSP_JOB_ID",
                "JSP_COALEVEL_1_ID",
                "JSP_COALEVEL_2_ID",
                "JSP_COALEVEL_3_ID",
                "JSP_COALEVEL_4_ID",
                "JSP_COALEVEL_5_ID",
                "JSP_COALEVEL_6_ID",
                "JSP_COALEVEL_7_ID",
                "jsp_segment1_id",
                "jsp_segment2_id",
                "jsp_segment3_id",
                "jsp_segment4_id",
                "jsp_segment5_id",
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_LONG,
		TYPE_LONG,  
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
                
                
	} ;

	public JspCoaBudget(){
	}
	public JspCoaBudget(CoaBudget coaBudget){
		this.coaBudget = coaBudget;
	}

	public JspCoaBudget(HttpServletRequest request, CoaBudget coaBudget){
		super(new JspCoaBudget(coaBudget), request);
		this.coaBudget = coaBudget;
	}

	public String getFormName() { return JSP_NAME_COABUDGET; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaBudget getEntityObject(){ return coaBudget; }

	public void requestEntityObject(CoaBudget coaBudget) {
		try{
			this.requestParam();
			coaBudget.setCoaId(getLong(JSP_COA_ID));
			coaBudget.setPeriodeId(getLong(JSP_PERIODE_ID));
			coaBudget.setAmount(getDouble(JSP_AMOUNT));
                        coaBudget.setBgtMonth(getInt(JSP_BGT_MONTH));
                        coaBudget.setBgtYear(getInt(JSP_BGT_YEAR));
                        coaBudget.setDivisionId(getLong(JSP_DIVISION_ID));
                        coaBudget.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
                        coaBudget.setDirektoratId(getLong(JSP_DIREKTORAT_ID));
                        coaBudget.setSectionId(getLong(JSP_SECTION_ID));
                        coaBudget.setJobId(getLong(JSP_JOB_ID));
                        coaBudget.setCoaLevel1Id(getLong(JSP_COALEVEL_1_ID));
                        coaBudget.setCoaLevel2Id(getLong(JSP_COALEVEL_2_ID));
                        coaBudget.setCoaLevel3Id(getLong(JSP_COALEVEL_3_ID));
                        coaBudget.setCoaLevel4Id(getLong(JSP_COALEVEL_4_ID));
                        coaBudget.setCoaLevel5Id(getLong(JSP_COALEVEL_5_ID));
                        coaBudget.setCoaLevel6Id(getLong(JSP_COALEVEL_6_ID));
                        coaBudget.setCoaLevel7Id(getLong(JSP_COALEVEL_7_ID));
                        
                        coaBudget.setSegment1Id(getLong(JSP_SEGMENT1_ID));
                        coaBudget.setSegment2Id(getLong(JSP_SEGMENT2_ID));
                        coaBudget.setSegment3Id(getLong(JSP_SEGMENT3_ID));
                        coaBudget.setSegment4Id(getLong(JSP_SEGMENT4_ID));
                        coaBudget.setSegment5Id(getLong(JSP_SEGMENT5_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
