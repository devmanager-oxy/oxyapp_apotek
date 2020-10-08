
package com.project.crm.transaction;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;


public class CmdLimbahTransaction extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private LimbahTransaction limbahTransaction;
	private DbLimbahTransaction dblimbahTransaction;
	private JspLimbahTransaction jsplimbahTransaction;

	int language = LANGUAGE_DEFAULT;

	public CmdLimbahTransaction(HttpServletRequest request){
		msgString = "";
		limbahTransaction = new LimbahTransaction();
		try{
			dblimbahTransaction = new  DbLimbahTransaction(0);
		}catch(Exception e){;}
		jsplimbahTransaction = new JspLimbahTransaction (request, limbahTransaction);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCompany.addError(jspCompany.JSP_FIELD_company_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public LimbahTransaction getLimbahTransaction() { return limbahTransaction; } 

	public JspLimbahTransaction getForm() { return jsplimbahTransaction; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidLimbahTransaction){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;  

			case JSPCommand.SAVE :
				if(oidLimbahTransaction != 0){
					try{
						limbahTransaction = DbLimbahTransaction.fetchExc(oidLimbahTransaction);
					}catch(Exception exc){
					}
				}

				jsplimbahTransaction.requestEntityObject(limbahTransaction);

				if(jsplimbahTransaction.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(limbahTransaction.getOID()==0){
					try{
						long oid = dblimbahTransaction.insertExc(this.limbahTransaction);
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
						long oid = dblimbahTransaction.updateExc(this.limbahTransaction);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
                                                return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
                                                return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}
				break;

                        case JSPCommand.SUBMIT :
                                jsplimbahTransaction.requestEntityObject(limbahTransaction);

				if(jsplimbahTransaction.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                            break;
                            
			case JSPCommand.EDIT :
				if (oidLimbahTransaction != 0) {
					try {
						limbahTransaction = DbLimbahTransaction.fetchExc(oidLimbahTransaction);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidLimbahTransaction != 0) {
					try {
						limbahTransaction = DbLimbahTransaction.fetchExc(oidLimbahTransaction);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidLimbahTransaction != 0){
					try{
						long oid = dblimbahTransaction.deleteExc(oidLimbahTransaction);
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
