
package com.project.fms.master;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.*;

public class CmdAccLink extends Control
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private AccLink accLink;
	private DbAccLink dbAccLink;
	private JspAccLink jspAccLink;
	
	public CmdAccLink(HttpServletRequest request){
		msgString = "";
		accLink = new AccLink();
		try{
			dbAccLink = new DbAccLink(0);
		}catch(Exception e){;}
		jspAccLink = new JspAccLink(request, accLink);
	}

	private String getSystemMessage(int msgCode){
            return "";
        }

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public AccLink getAccLink() { return accLink; } 

	public JspAccLink getForm() { return jspAccLink; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	//public int action(int cmd , long oidAccLink, long userId, long companyId){
        public int action(int cmd , long oidAccLink, long userId){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

                        case JSPCommand.SUBMIT :
                                jspAccLink.requestEntityObject(accLink);
				break;
                                
			case JSPCommand.SAVE :
				if(oidAccLink != 0){
					try{
						accLink = DbAccLink.fetchExc(oidAccLink);
					}catch(Exception exc){
					}
				}
                                
				jspAccLink.requestEntityObject(accLink);
                                
                                //accLink.setCompanyId(companyId);
                                accLink.setUserId(userId);
                                
                                Coa coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(accLink.getCoaId());
                                }
                                catch(Exception e){

                                }

                                //jika tidak postable tidak boleh
                                //if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                //    jspAccLink.addError(jspAccLink.JSP_COA_ID, "postable account type required");
                                //}

				//if(jspAccLink.errorSize()>0 || companyId==0 || userId==0) {
                                if(jspAccLink.errorSize()>0 || userId==0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(accLink.getOID()==0){
					try{
						long oid = dbAccLink.insertExc(this.accLink);
                                                if(oid!=0){
                                                    DbCoa.updateLocation(accLink.getCoaId(), accLink.getLocationId());
                                                }
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
						long oid = dbAccLink.updateExc(this.accLink);
                                                if(oid!=0){
                                                    DbCoa.updateLocation(accLink.getCoaId(), accLink.getLocationId());
                                                }
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidAccLink != 0) {
					try {
						accLink = DbAccLink.fetchExc(oidAccLink);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidAccLink != 0) {
					try {
						accLink = DbAccLink.fetchExc(oidAccLink);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidAccLink != 0){
					try{
						long oid = DbAccLink.deleteExc(oidAccLink);
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
