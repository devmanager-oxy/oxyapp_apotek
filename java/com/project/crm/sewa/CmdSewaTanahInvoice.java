package com.project.crm.sewa;

import com.project.crm.transaction.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdSewaTanahInvoice extends Control implements I_Language 
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
	private SewaTanahInvoice sewaTanahInvoice;
	private DbSewaTanahInvoice pstSewaTanahInvoice;
	private JspSewaTanahInvoice jspSewaTanahInvoice;
	int language = LANGUAGE_DEFAULT;

	public CmdSewaTanahInvoice(HttpServletRequest request){
		msgString = "";
		sewaTanahInvoice = new SewaTanahInvoice();
		try{
			pstSewaTanahInvoice = new DbSewaTanahInvoice(0);
		}catch(Exception e){;}
		jspSewaTanahInvoice = new JspSewaTanahInvoice(request, sewaTanahInvoice);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSewaTanahInvoice.addError(jspSewaTanahInvoice.JSP_sewa_tanah_invoice_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public SewaTanahInvoice getSewaTanahInvoice() { return sewaTanahInvoice; } 

	public JspSewaTanahInvoice getForm() { return jspSewaTanahInvoice; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSewaTanahInvoice){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSewaTanahInvoice != 0){
					try{
						sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(oidSewaTanahInvoice);
					}catch(Exception exc){
					}
				}

				jspSewaTanahInvoice.requestEntityObject(sewaTanahInvoice);

				if(jspSewaTanahInvoice.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(sewaTanahInvoice.getOID()==0){
					try{
						long oid = pstSewaTanahInvoice.insertExc(this.sewaTanahInvoice);
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
						long oid = pstSewaTanahInvoice.updateExc(this.sewaTanahInvoice);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSewaTanahInvoice != 0) {
					try {
						sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(oidSewaTanahInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSewaTanahInvoice != 0) {
					try {
						sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(oidSewaTanahInvoice);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSewaTanahInvoice != 0){
					try{
						long oid = DbSewaTanahInvoice.deleteExc(oidSewaTanahInvoice);
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
