package com.project.simprop.property;

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

public class CmdSewaTanahIncomeProp extends Control implements I_Language 
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
	private SewaTanahIncomeProp sewaTanahIncomeProp;
	private DbSewaTanahIncomeProp pstSewaTanahIncomeProp;
	private JspSewaTanahIncomeProp jspSewaTanahIncomeProp;
	int language = LANGUAGE_DEFAULT;

	public CmdSewaTanahIncomeProp(HttpServletRequest request){
		msgString = "";
		sewaTanahIncomeProp = new SewaTanahIncomeProp();
		try{
			pstSewaTanahIncomeProp = new DbSewaTanahIncomeProp(0);
		}catch(Exception e){;}
		jspSewaTanahIncomeProp = new JspSewaTanahIncomeProp(request, sewaTanahIncomeProp);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSewaTanahIncomeProp.addError(jspSewaTanahIncomeProp.JSP_sewa_tanah_income_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public SewaTanahIncomeProp getSewaTanahIncome() { return sewaTanahIncomeProp; } 

	public JspSewaTanahIncomeProp getForm() { return jspSewaTanahIncomeProp; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSewaTanahIncomeProp){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSewaTanahIncomeProp != 0){
					try{
						sewaTanahIncomeProp = DbSewaTanahIncomeProp.fetchExc(oidSewaTanahIncomeProp);
					}catch(Exception exc){
					}
				}

				jspSewaTanahIncomeProp.requestEntityObject(sewaTanahIncomeProp);

				if(jspSewaTanahIncomeProp.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(sewaTanahIncomeProp.getOID()==0){
					try{
						long oid = pstSewaTanahIncomeProp.insertExc(this.sewaTanahIncomeProp);
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
						long oid = pstSewaTanahIncomeProp.updateExc(this.sewaTanahIncomeProp);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSewaTanahIncomeProp != 0) {
					try {
						sewaTanahIncomeProp = DbSewaTanahIncomeProp.fetchExc(oidSewaTanahIncomeProp);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSewaTanahIncomeProp != 0) {
					try {
						sewaTanahIncomeProp = DbSewaTanahIncomeProp.fetchExc(oidSewaTanahIncomeProp);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSewaTanahIncomeProp != 0){
					try{
						long oid = DbSewaTanahIncomeProp.deleteExc(oidSewaTanahIncomeProp);
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
