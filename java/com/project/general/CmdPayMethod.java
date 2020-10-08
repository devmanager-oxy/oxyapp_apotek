

package com.project.general;

/* java package */ 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 

import com.project.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.general.*;

public class CmdPayMethod extends Control
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
	private PayMethod payMethod;
	private DbPayMethod pstPayMethod;
	private JspPayMethod frmPayMethod;
	int language = 0;

	public CmdPayMethod(HttpServletRequest request){
		msgString = "";
		payMethod = new PayMethod();
		try{
			pstPayMethod = new DbPayMethod(0);
		}catch(Exception e){;}
		frmPayMethod = new JspPayMethod(request, payMethod);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.frmPayMethod.addError(frmPayMethod.JSP_PAY_METHOD_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public PayMethod getPayMethod() { return payMethod; } 

	public JspPayMethod getForm() { return frmPayMethod; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPayMethod){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidPayMethod != 0){
					try{
						payMethod = DbPayMethod.fetchExc(oidPayMethod);
					}catch(Exception exc){
					}
				}

				frmPayMethod.requestEntityObject(payMethod);

				if(frmPayMethod.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                if(oidPayMethod == 0){
                                    if(pstPayMethod.getCount("PAY_METHOD='"+payMethod.getPayMethod()+"'")>0){
                                        frmPayMethod.addError(frmPayMethod.JSP_PAY_METHOD, "Duplicat entry");
                                        return RSLT_FORM_INCOMPLETE ;
                                    }
                                }
                                else{
                                    if(pstPayMethod.getCount("PAY_METHOD='"+payMethod.getPayMethod()+"' AND PAY_METHOD_ID<>"+oidPayMethod)>0){
                                        frmPayMethod.addError(frmPayMethod.JSP_PAY_METHOD, "Duplicat entry");
                                        return RSLT_FORM_INCOMPLETE ;
                                    }
                                }

				if(payMethod.getOID()==0){
					try{
						long oid = pstPayMethod.insertExc(this.payMethod);
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
						long oid = pstPayMethod.updateExc(this.payMethod);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidPayMethod != 0) {
					try {
						payMethod = DbPayMethod.fetchExc(oidPayMethod);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPayMethod != 0) {
					try {
						payMethod = DbPayMethod.fetchExc(oidPayMethod);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidPayMethod != 0){
					try{
						long oid = DbPayMethod.deleteExc(oidPayMethod);
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
