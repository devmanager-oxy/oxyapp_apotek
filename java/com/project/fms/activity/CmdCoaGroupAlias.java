
package com.project.fms.activity;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;

public class CmdCoaGroupAlias extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Duplicate data entry ", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private CoaGroupAlias coaNatureExpenseCategory;
	private DbCoaGroupAlias pstCoaGroupAlias;
	private JspCoaGroupAlias jspCoaGroupAlias;
	int language = LANGUAGE_DEFAULT;

	public CmdCoaGroupAlias(HttpServletRequest request){
		msgString = "";
		coaNatureExpenseCategory = new CoaGroupAlias();
		try{
			pstCoaGroupAlias = new DbCoaGroupAlias(0);
		}catch(Exception e){;}
		jspCoaGroupAlias = new JspCoaGroupAlias(request, coaNatureExpenseCategory);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCoaGroupAlias.addError(jspCoaGroupAlias.JSP_FIELD_coa_nature_expense_category_id, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR]; 
		}
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage(){ return language; }

	public void setLanguage(int language){ this.language = language; }

	public CoaGroupAlias getCoaGroupAlias() { return coaNatureExpenseCategory; } 

	public JspCoaGroupAlias getForm() { return jspCoaGroupAlias; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCoaGroupAlias){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidCoaGroupAlias != 0){
					try{
						coaNatureExpenseCategory = DbCoaGroupAlias.fetchExc(oidCoaGroupAlias);
					}catch(Exception exc){
					}
				}

				jspCoaGroupAlias.requestEntityObject(coaNatureExpenseCategory);

				if(jspCoaGroupAlias.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(coaNatureExpenseCategory.getOID()==0){
					try{
						long oid = pstCoaGroupAlias.insertExc(this.coaNatureExpenseCategory);
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
						return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}else{
					try {
						long oid = pstCoaGroupAlias.updateExc(this.coaNatureExpenseCategory);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidCoaGroupAlias != 0) {
					try {
						coaNatureExpenseCategory = DbCoaGroupAlias.fetchExc(oidCoaGroupAlias);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCoaGroupAlias != 0) {
					try {
						coaNatureExpenseCategory = DbCoaGroupAlias.fetchExc(oidCoaGroupAlias);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCoaGroupAlias != 0){
					try{
						long oid = DbCoaGroupAlias.deleteExc(oidCoaGroupAlias);
						if(oid!=0){
							msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}
}
