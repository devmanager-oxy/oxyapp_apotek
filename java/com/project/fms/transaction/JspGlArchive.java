/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/6/2008 9:19:08 PM
\***********************************/

package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspGlArchive extends JSPHandler implements I_JSPInterface, I_JSPType {

	private GlArchive glArchive;

	public static final  String JSP_NAME_GLARCHIVE = "glarchive";

	public static final  int JSP_ARCHIVE_ID = 0;
	public static final  int JSP_SEARCH_FOR = 1;
	public static final  int JSP_START_DATE = 2;
	public static final  int JSP_END_DATE = 3;
	public static final  int JSP_IGNORE_INPUT_DATE = 4;
	public static final  int JSP_TRANSACTION_DATE = 5;
	public static final  int JSP_IGNORE_TRANSACTION_DATE = 6;
	public static final  int JSP_JOURNAL_NUMBER = 7;
	public static final  int JSP_BLANK_JOURNAL_NUMBER = 8;
	public static final  int JSP_PERIODE_ID = 9;

	public static final  String[] colNames = {
		"x_archive_id",
		"x_search_for",
		"x_start_date",
		"x_end_date",
		"x_ignore_input_date",
		"x_transaction_date_xx",
		"x_ignore_transaction_date_xx",
		"x_journal_number",
		"x_blank_journal_number",
		"x_periode_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,
		//TYPE_STRING,
                TYPE_DATE,
		//TYPE_STRING,
                TYPE_DATE,
		TYPE_INT,
		//TYPE_STRING,
                TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG
	};

	public JspGlArchive(){
	}

	public JspGlArchive(GlArchive glArchive) {
		this.glArchive = glArchive;
	}

	public JspGlArchive(HttpServletRequest request, GlArchive glArchive)
	{
		super(new JspGlArchive(glArchive), request);
		this.glArchive = glArchive;
	}

	public String getFormName() { return JSP_NAME_GLARCHIVE; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public GlArchive getEntityObject(){ return glArchive; }

	public void requestEntityObject(GlArchive glArchive) {
		try{
			this.requestParam();
			glArchive.setSearchFor(getString(JSP_SEARCH_FOR));			
			glArchive.setIgnoreInputDate(getInt(JSP_IGNORE_INPUT_DATE));			
			glArchive.setIgnoreTransactionDate(getInt(JSP_IGNORE_TRANSACTION_DATE));
			glArchive.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			glArchive.setBlankJournalNumber(getInt(JSP_BLANK_JOURNAL_NUMBER));
			glArchive.setPeriodeId(getLong(JSP_PERIODE_ID));                        
                        glArchive.setStartDate(getDate(JSP_START_DATE));			
                        glArchive.setEndDate(getDate(JSP_END_DATE));                        
                        glArchive.setTransactionDate(getDate(JSP_TRANSACTION_DATE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
