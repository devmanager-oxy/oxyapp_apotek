/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/3/2008 11:46:59 AM
\***********************************/

package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspBankArchive extends JSPHandler implements I_JSPInterface, I_JSPType {

	private BankArchive bankArchive;

	public static final  String JSP_NAME_BANKARCHIVE = "bankarchive";

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

	public JspBankArchive(){
	}

	public JspBankArchive(BankArchive bankArchive) {
		this.bankArchive = bankArchive;
	}

	public JspBankArchive(HttpServletRequest request, BankArchive bankArchive)
	{
		super(new JspBankArchive(bankArchive), request);
		this.bankArchive = bankArchive;
	}

	public String getFormName() { return JSP_NAME_BANKARCHIVE; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public BankArchive getEntityObject(){ return bankArchive; }

	public void requestEntityObject(BankArchive bankArchive) {
		try{
			this.requestParam();

			bankArchive.setSearchFor(getString(JSP_SEARCH_FOR));
			//bankArchive.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
                        bankArchive.setStartDate(getDate(JSP_START_DATE));
			//bankArchive.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
                        bankArchive.setEndDate(getDate(JSP_END_DATE));
			bankArchive.setIgnoreInputDate(getInt(JSP_IGNORE_INPUT_DATE));
			//bankArchive.setTransactionDate(JSPFormater.formatDate(getString(JSP_TRANSACTION_DATE),"dd/MM/yyyy"));
                        bankArchive.setTransactionDate(getDate(JSP_TRANSACTION_DATE));
			bankArchive.setIgnoreTransactionDate(getInt(JSP_IGNORE_TRANSACTION_DATE));
			bankArchive.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			bankArchive.setBlankJournalNumber(getInt(JSP_BLANK_JOURNAL_NUMBER));
			bankArchive.setPeriodeId(getLong(JSP_PERIODE_ID));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
