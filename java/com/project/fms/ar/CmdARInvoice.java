
package com.project.fms.ar;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.lang.I_Language;

public class CmdARInvoice extends Control implements I_Language 
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
	private ARInvoice aRInvoice;
	private DbARInvoice pstARInvoice;
	private JspARInvoice jspARInvoice;
	int language = LANGUAGE_DEFAULT;

	public CmdARInvoice(HttpServletRequest request){
		msgString = "";
		aRInvoice = new ARInvoice();
		try{
			pstARInvoice = new DbARInvoice(0);
		}catch(Exception e){;}
		jspARInvoice = new JspARInvoice(request, aRInvoice);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspARInvoice.addError(jspARInvoice.JSP_FIELD_ar_invoice_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public ARInvoice getARInvoice() { return aRInvoice; } 

	public JspARInvoice getForm() { return jspARInvoice; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidARInvoice, long companyOID){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidARInvoice != 0){
                                    try{
                                            aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                                    }catch(Exception exc){
                                    }
				}

				jspARInvoice.requestEntityObject(aRInvoice);
                                
                                aRInvoice.setCompanyId(companyOID);

				if(jspARInvoice.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                if(companyOID==0) {
					msgString = "No company ID available ...";
					return RSLT_FORM_INCOMPLETE ;
				}

				if(aRInvoice.getOID()==0){
					try{
                                                aRInvoice.setDate(new Date());
                                                aRInvoice.setTransDate(new Date());
                                                
                                                int count = DbARInvoice.getNextCounter(companyOID);
                                                aRInvoice.setJournalCounter(count);
                                                aRInvoice.setJournalPrefix(DbARInvoice.getNumberPrefix(companyOID));
                                                aRInvoice.setJournalNumber(DbARInvoice.getNextNumber(count, companyOID));
                                                aRInvoice.setInvoiceNumber(aRInvoice.getJournalNumber());
                                                
						long oid = pstARInvoice.insertExc(this.aRInvoice);
                                                
                                                msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                                                
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
						long oid = pstARInvoice.updateExc(this.aRInvoice);
                                                
                                                msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                                                
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidARInvoice != 0) {
					try {
						aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
                                
                        case JSPCommand.POST :
				if (oidARInvoice != 0) {
					try {
						aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
                                
			case JSPCommand.ASK :
				if (oidARInvoice != 0) {
					try {
						aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidARInvoice != 0){
					try{
						long oid = DbARInvoice.deleteExc(oidARInvoice);
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
