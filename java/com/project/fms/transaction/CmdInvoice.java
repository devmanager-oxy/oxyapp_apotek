

package com.project.fms.transaction;

/* java package */ 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.system.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.master.*;
import com.project.util.*;


public class CmdInvoice extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
                {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private Invoice invoice;
	private DbInvoice pstInvoice;
	private JspInvoice jspInvoice;
	int language = LANGUAGE_DEFAULT;

	public CmdInvoice(HttpServletRequest request){
		msgString = "";
		invoice = new Invoice();
		try{
			pstInvoice = new DbInvoice(0);
		}catch(Exception e){;}
		jspInvoice = new JspInvoice(request, invoice);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspInvoice.addError(jspInvoice.JSP_FIELD_invoice_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public Invoice getInvoice() { return invoice; } 

	public JspInvoice getForm() { return jspInvoice; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidInvoice){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidInvoice != 0){
					try{
						invoice = DbInvoice.fetchExc(oidInvoice);
					}catch(Exception exc){
					}
				}

				jspInvoice.requestEntityObject(invoice);
                                
                                String where = "'"+JSPFormater.formatDate(invoice.getTransDate(), "yyyy-MM-dd")+"' between start_date and end_date "+
                                    " and status='"+I_Project.STATUS_PERIOD_OPEN+"'";

                                Vector v = DbPeriode.list(0,0, where, "");
                                if(v==null || v.size()==0){
                                    jspInvoice.addError(jspInvoice.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                                }

				if(jspInvoice.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(invoice.getOID()==0){
					try{
                                                invoice.setJournalCounter(DbInvoice.getNextCounter());
                                                invoice.setDate(new Date());
                                                invoice.setStatus(I_Project.STATUS_NOT_POSTED);
                                                
                                                invoice.setJournalPrefix(DbInvoice.getNumberPrefix());
                                                invoice.setJournalNumber(DbInvoice.getNextNumber(invoice.getJournalCounter()));
                                                invoice.setActivityStatus(I_Project.STATUS_NOT_POSTED);
                                                //invoice.setStatus(I_Project.PURCHASE_STATUS_OPEN);
                                                
                                                if(!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")){
                                                    invoice.setActivityStatus(I_Project.STATUS_POSTED);
                                                }
                                                
						long oid = pstInvoice.insertExc(this.invoice);
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
                                                invoice.setStatus(I_Project.STATUS_NOT_POSTED);
						long oid = pstInvoice.updateExc(this.invoice);
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
				if (oidInvoice != 0) {
					try {
						invoice = DbInvoice.fetchExc(oidInvoice);
                                                
                                                long oid = DbInvoice.postJournal(invoice);
                                                
                                                if(oid!=0){                                                   
                                                    invoice.setStatus(I_Project.STATUS_POSTED);
                                                    DbInvoice.updateExc(invoice);
                                                }
                                                
                                                
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;        
                                
			case JSPCommand.EDIT :
				if (oidInvoice != 0) {
					try {
						invoice = DbInvoice.fetchExc(oidInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidInvoice != 0) {
					try {
						invoice = DbInvoice.fetchExc(oidInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidInvoice != 0){
					try{
						long oid = DbInvoice.deleteExc(oidInvoice);
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
