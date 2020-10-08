/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/7/2008 2:36:52 PM
\***********************************/

package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspCashArchive extends JSPHandler implements I_JSPInterface, I_JSPType {

	private CashArchive cashArchive;

	public static final  String JSP_NAME_CASHARCHIVE = "casharchive";

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
		"x_transaction_date",
		"x_ignore_transaction_date",
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

	public JspCashArchive(){
	}

	public JspCashArchive(CashArchive cashArchive) {
		this.cashArchive = cashArchive;
	}

	public JspCashArchive(HttpServletRequest request, CashArchive cashArchive)
	{
		super(new JspCashArchive(cashArchive), request);
		this.cashArchive = cashArchive;
	}

	public String getFormName() { return JSP_NAME_CASHARCHIVE; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public CashArchive getEntityObject(){ return cashArchive; }

	public void requestEntityObject(CashArchive cashArchive) {
		try{
			this.requestParam();

			cashArchive.setSearchFor(getString(JSP_SEARCH_FOR));
			//cashArchive.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
                        cashArchive.setStartDate(getDate(JSP_START_DATE));
			//cashArchive.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
                        cashArchive.setEndDate(getDate(JSP_END_DATE));
			cashArchive.setIgnoreInputDate(getInt(JSP_IGNORE_INPUT_DATE));
			//cashArchive.setTransactionDate(JSPFormater.formatDate(getString(JSP_TRANSACTION_DATE),"dd/MM/yyyy"));
                        cashArchive.setTransactionDate(getDate(JSP_TRANSACTION_DATE));
			cashArchive.setIgnoreTransactionDate(getInt(JSP_IGNORE_TRANSACTION_DATE));
			cashArchive.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			cashArchive.setBlankJournalNumber(getInt(JSP_BLANK_JOURNAL_NUMBER));
			cashArchive.setPeriodeId(getLong(JSP_PERIODE_ID));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
