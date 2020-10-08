package com.project.crm.transaction;

import com.project.crm.transaction.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;


public class CmdIrigasiTransaction extends Control 
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
	private IrigasiTransaction irigasiTransaction;
	private DbIrigasiTransaction pstIrigasiTrasaction;
	private JspIrigasiTransaction jspIrigasiTransaction;
	int language = 0;//LANGUAGE_DEFAULT;

	public CmdIrigasiTransaction(HttpServletRequest request){
		msgString = "";
		irigasiTransaction = new IrigasiTransaction();
		try{
			pstIrigasiTrasaction = new DbIrigasiTransaction(0);
		}catch(Exception e){;}
		jspIrigasiTransaction = new JspIrigasiTransaction(request, irigasiTransaction);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspAkrualProses.addError(jspAkrualProses.JSP_FIELD_akrual_proses_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public IrigasiTransaction getIrigasiTransaction() { return irigasiTransaction; }

	public JspIrigasiTransaction getForm() { return jspIrigasiTransaction; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidIrigationTransaction){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidIrigationTransaction != 0){
					try{
						irigasiTransaction = DbIrigasiTransaction.fetchExc(oidIrigationTransaction);
					}catch(Exception exc){
					}
				}

				jspIrigasiTransaction.requestEntityObject(irigasiTransaction);

				if(jspIrigasiTransaction.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(irigasiTransaction.getOID()==0){
					try{
						long oid = pstIrigasiTrasaction.insertExc(this.irigasiTransaction);
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
						long oid = pstIrigasiTrasaction.updateExc(this.irigasiTransaction);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidIrigationTransaction != 0) {
					try {
						irigasiTransaction = DbIrigasiTransaction.fetchExc(oidIrigationTransaction);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidIrigationTransaction != 0) {
					try {
						irigasiTransaction = DbIrigasiTransaction.fetchExc(oidIrigationTransaction);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidIrigationTransaction != 0){
					try{
						long oid = DbIrigasiTransaction.deleteExc(oidIrigationTransaction);
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
