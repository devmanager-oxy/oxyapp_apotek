/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
/**
 *
 * @author Roy Andika
 */
public class CmdCoaOpeningBalanceLocation extends Control implements I_Language {
    public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not save duplicate entry", "Can not save duplicate entry", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private CoaOpeningBalanceLocation coaOpeningBalanceLocation;
	private DbCoaOpeningBalanceLocation pstCoaOpeningBalanceLocation;
	private JspCoaOpeningBalanceLocation jspCoaOpeningBalanceLocation;
	int language = LANGUAGE_DEFAULT;

	public CmdCoaOpeningBalanceLocation(HttpServletRequest request){
		msgString = "";
		coaOpeningBalanceLocation = new CoaOpeningBalanceLocation();
		try{
			pstCoaOpeningBalanceLocation = new DbCoaOpeningBalanceLocation(0);
		}catch(Exception e){;}
		jspCoaOpeningBalanceLocation = new JspCoaOpeningBalanceLocation(request, coaOpeningBalanceLocation);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :				
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

	public CoaOpeningBalanceLocation getCoaOpeningBalance() { return coaOpeningBalanceLocation; } 

	public JspCoaOpeningBalanceLocation getForm() { return jspCoaOpeningBalanceLocation; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCoaOpeningBalanceLocation){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidCoaOpeningBalanceLocation != 0){
					try{
						coaOpeningBalanceLocation = DbCoaOpeningBalanceLocation.fetchExc(oidCoaOpeningBalanceLocation);
					}catch(Exception exc){
					}
				}

				jspCoaOpeningBalanceLocation.requestEntityObject(coaOpeningBalanceLocation);

				if(jspCoaOpeningBalanceLocation.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(coaOpeningBalanceLocation.getOID()==0){
					try{
						long oid = pstCoaOpeningBalanceLocation.insertExc(this.coaOpeningBalanceLocation);
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
						long oid = pstCoaOpeningBalanceLocation.updateExc(this.coaOpeningBalanceLocation);
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

			case JSPCommand.EDIT :
				if (oidCoaOpeningBalanceLocation != 0) {
					try {
						coaOpeningBalanceLocation = DbCoaOpeningBalanceLocation.fetchExc(oidCoaOpeningBalanceLocation);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCoaOpeningBalanceLocation != 0) {
					try {
						coaOpeningBalanceLocation = DbCoaOpeningBalanceLocation.fetchExc(oidCoaOpeningBalanceLocation);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCoaOpeningBalanceLocation != 0){
					try{
						long oid = DbCoaOpeningBalanceLocation.deleteExc(oidCoaOpeningBalanceLocation);
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
