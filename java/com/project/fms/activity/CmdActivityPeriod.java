

package com.project.fms.activity;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;

public class CmdActivityPeriod extends Control
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Can not process duplicate entry", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private ActivityPeriod activityPeriod;
	private DbActivityPeriod dbActivityPeriod;
	private JspActivityPeriod jspActivityPeriod;
	
	public CmdActivityPeriod(HttpServletRequest request){
		msgString = "";
		activityPeriod = new ActivityPeriod();
		try{
			dbActivityPeriod = new DbActivityPeriod(0);
		}catch(Exception e){;}
		jspActivityPeriod = new JspActivityPeriod(request, activityPeriod);
	}

	private String getSystemMessage(int msgCode){
                switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCashCount.addError(jspCashCount.JSP_FIELD_cash_count_id, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[1][RSLT_EST_CODE_EXIST];
			default:
				return resultText[1][RSLT_UNKNOWN_ERROR]; 
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

	public ActivityPeriod getActivityPeriod() { return activityPeriod; } 

	public JspActivityPeriod getForm() { return jspActivityPeriod; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidActivityPeriod){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidActivityPeriod != 0){
					try{
						activityPeriod = DbActivityPeriod.fetchExc(oidActivityPeriod);
					}catch(Exception exc){
					}
				}

				jspActivityPeriod.requestEntityObject(activityPeriod);
                                
                                String where = "('"+JSPFormater.formatDate(activityPeriod.getStartDate(), "")+"' between start_date and end_date) or "+
                                        "('"+JSPFormater.formatDate(activityPeriod.getEndDate(), "")+"' between start_date and end_date)";
                                
                                if(DbActivityPeriod.getCount(where)>0){
                                        jspActivityPeriod.addError(jspActivityPeriod.JSP_START_DATE, "overlaping date");                                        
                                        msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE)+", overlaping date";
                                }

				if(jspActivityPeriod.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(activityPeriod.getOID()==0){
					try{
                                                if(DbActivityPeriod.getCount("")<1){
                                                    activityPeriod.setStatus(I_Project.STATUS_PERIOD_OPEN);                                                    
                                                }
                                                else{
                                                    activityPeriod.setStatus(I_Project.STATUS_PERIOD_PREPARED_OPEN);                                                    
                                                }
						long oid = dbActivityPeriod.insertExc(this.activityPeriod);
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
						long oid = dbActivityPeriod.updateExc(this.activityPeriod);
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
				if (oidActivityPeriod != 0) {
					try {
						activityPeriod = DbActivityPeriod.fetchExc(oidActivityPeriod);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
                                                
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidActivityPeriod != 0) {
					try {
						activityPeriod = DbActivityPeriod.fetchExc(oidActivityPeriod);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidActivityPeriod != 0){
					try{
						long oid = DbActivityPeriod.deleteExc(oidActivityPeriod);
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
