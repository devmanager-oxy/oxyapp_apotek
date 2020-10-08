
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;


public class JspBankAccount extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BankAccount bankAccount;

	public static final String JSP_NAME_BANKACCOUNT		=  "JSP_NAME_BANKACCOUNT" ;

	public static final int JSP_BANK_ACCOUNT_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_TYPE			=  2 ;
	public static final int JSP_ACC_NUMBER			=  3 ;
	public static final int JSP_BANK_NAME			=  4 ;
	public static final int JSP_STATUS			=  5 ;
	public static final int JSP_ACCOUNT_CODE			=  6 ;
	public static final int JSP_COA_ID			=  7 ;
        public static final int JSP_CURRENCY_ID			=  8 ;

	public static String[] colNames = {
		"JSP_BANK_ACCOUNT_ID",  "JSP_NAME",
		"JSP_TYPE",  "JSP_ACC_NUMBER",
		"JSP_BANK_NAME",  "JSP_STATUS",
		"JSP_ACCOUNT_CODE",  "JSP_COA_ID",
                "JSP_CURRENCY_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_STRING,  TYPE_LONG + ENTRY_REQUIRED,
                TYPE_LONG + ENTRY_REQUIRED
	} ;

	public JspBankAccount(){
	}
	public JspBankAccount(BankAccount bankAccount){
		this.bankAccount = bankAccount;
	}

	public JspBankAccount(HttpServletRequest request, BankAccount bankAccount){
		super(new JspBankAccount(bankAccount), request);
		this.bankAccount = bankAccount;
	}

	public String getFormName() { return JSP_NAME_BANKACCOUNT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BankAccount getEntityObject(){ return bankAccount; }

	public void requestEntityObject(BankAccount bankAccount) {
		try{
			this.requestParam();
			bankAccount.setName(getString(JSP_NAME));
			bankAccount.setType(getInt(JSP_TYPE));
			bankAccount.setAccNumber(getString(JSP_ACC_NUMBER));
			bankAccount.setBankName(getString(JSP_BANK_NAME));
			bankAccount.setStatus(getInt(JSP_STATUS));
			bankAccount.setAccountCode(getString(JSP_ACCOUNT_CODE));
			bankAccount.setCoaId(getLong(JSP_COA_ID));
                        bankAccount.setCurrencyId(getLong(JSP_CURRENCY_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
