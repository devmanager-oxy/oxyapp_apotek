package com.project.admin;


import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.admin.*;
import com.project.admin.*;
import com.project.admin.*;
import com.project.util.lang.*;
import com.project.main.entity.*;

public class CmdUserPriv extends Control implements I_Language 
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
	private UserPriv userPriv;
	private DbUserPriv pstUserPriv;
	private JspUserPriv jspUserPriv;
	int language = LANGUAGE_DEFAULT;

	public CmdUserPriv(HttpServletRequest request){
		msgString = "";
		userPriv = new UserPriv();
		try{
			pstUserPriv = new DbUserPriv(0);
		}catch(Exception e){;}
		jspUserPriv = new JspUserPriv(request, userPriv);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspUserPriv.addError(jspUserPriv.JSP_FIELD_priv_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public UserPriv getUserPriv() { return userPriv; } 

	public JspUserPriv getForm() { return jspUserPriv; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidUserPriv){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidUserPriv != 0){
					try{
						userPriv = DbUserPriv.fetchExc(oidUserPriv);
					}catch(Exception exc){
					}
				}

				jspUserPriv.requestEntityObject(userPriv);

				if(jspUserPriv.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(userPriv.getOID()==0){
					try{
						long oid = pstUserPriv.insertExc(this.userPriv);
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
						long oid = pstUserPriv.updateExc(this.userPriv);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidUserPriv != 0) {
					try {
						userPriv = DbUserPriv.fetchExc(oidUserPriv);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidUserPriv != 0) {
					try {
						userPriv = DbUserPriv.fetchExc(oidUserPriv);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidUserPriv != 0){
					try{
						long oid = DbUserPriv.deleteExc(oidUserPriv);
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
