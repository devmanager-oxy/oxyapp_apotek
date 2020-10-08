
package com.project.fms.journal;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.*;
import com.project.util.jsp.*;

public class JspJournalDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private JournalDetail journalDetail;

	public static final String JSP_NAME_JOURNALDETAIL		=  "JSP_NAME_JOURNALDETAIL" ;

	public static final int JSP_JOURNAL_ID			=  0 ;
	public static final int JSP_JOURNAL_DETAIL_ID			=  1 ;
	public static final int JSP_COA_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_DEPARTMENT_ID			=  4 ;
	public static final int JSP_SECTION_ID			=  5 ;
	public static final int JSP_PERIODE_ID			=  6 ;
	public static final int JSP_EXCHANGE_RATE			=  7 ;
	public static final int JSP_CURRENCY			=  8 ;
	public static final int JSP_USER_ID			=  9 ;
	public static final int JSP_STATUS			=  10 ;
	public static final int JSP_IS_DEBET			=  11 ;
	public static final int JSP_DEBET			=  12 ;
	public static final int JSP_CREDIT			=  13 ;

	public static String[] colNames = {
		"JSP_JOURNAL_ID",  "JSP_JOURNAL_DETAIL_ID",
		"JSP_COA_ID",  "JSP_AMOUNT",
		"JSP_DEPARTMENT_ID",  "JSP_SECTION_ID",
		"JSP_PERIODE_ID",  "JSP_EXCHANGE_RATE",
		"JSP_CURRENCY",  "JSP_USER_ID",
		"JSP_STATUS",  "JSP_IS_DEBET",
		"JSP_DEBET",  "JSP_CREDIT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_INT,
		TYPE_FLOAT,  TYPE_FLOAT
	} ;

	public JspJournalDetail(){
	}
	public JspJournalDetail(JournalDetail journalDetail){
		this.journalDetail = journalDetail;
	}

	public JspJournalDetail(HttpServletRequest request, JournalDetail journalDetail){
		super(new JspJournalDetail(journalDetail), request);
		this.journalDetail = journalDetail;
	}

	public String getFormName() { return JSP_NAME_JOURNALDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public JournalDetail getEntityObject(){ return journalDetail; }

	public void requestEntityObject(JournalDetail journalDetail) {
		try{
			this.requestParam();
			journalDetail.setJournalId(getLong(JSP_JOURNAL_ID));
			journalDetail.setCoaId(getLong(JSP_COA_ID));
			journalDetail.setAmount(getDouble(JSP_AMOUNT));
			journalDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
			journalDetail.setSectionId(getLong(JSP_SECTION_ID));
			journalDetail.setPeriodeId(getLong(JSP_PERIODE_ID));
			journalDetail.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			journalDetail.setCurrency(getString(JSP_CURRENCY));
			journalDetail.setUserId(getLong(JSP_USER_ID));
			journalDetail.setStatus(getString(JSP_STATUS));
			journalDetail.setIsDebet(getInt(JSP_IS_DEBET));
			journalDetail.setDebet(getDouble(JSP_DEBET));
			journalDetail.setCredit(getDouble(JSP_CREDIT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
