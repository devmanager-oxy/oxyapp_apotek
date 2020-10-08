
package com.project.fms.activity;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;

public class CmdActivityPeriodBudget extends Control 
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
	private ActivityPeriodBudget donorActivityPeriod;
	private DbActivityPeriodBudget dbActivityPeriodBudget;
	private JspActivityPeriodBudget jspActivityPeriodBudget;
	
	public CmdActivityPeriodBudget(HttpServletRequest request){
		msgString = "";
		donorActivityPeriod = new ActivityPeriodBudget();
		try{
			dbActivityPeriodBudget = new DbActivityPeriodBudget(0);
		}catch(Exception e){;}
		jspActivityPeriodBudget = new JspActivityPeriodBudget(request, donorActivityPeriod);
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

	public ActivityPeriodBudget getActivityPeriodBudget() { return donorActivityPeriod; } 

	public JspActivityPeriodBudget getForm() { return jspActivityPeriodBudget; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidActivityPeriodBudget){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidActivityPeriodBudget != 0){
					try{
						donorActivityPeriod = DbActivityPeriodBudget.fetchExc(oidActivityPeriodBudget);
					}catch(Exception exc){
					}
				}

				jspActivityPeriodBudget.requestEntityObject(donorActivityPeriod);

				if(jspActivityPeriodBudget.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                String where = "activity_period_id="+donorActivityPeriod.getActivityPeriodId() +" and module_id="+donorActivityPeriod.getModuleId();
                                if(donorActivityPeriod.getOID()!=0){
                                    where = where +" and activity_period_budget_id<>"+oidActivityPeriodBudget;
                                }
                                if(DbActivityPeriodBudget.getCount(where)>0){
                                        msgString = "Can not save duplicate entry";
					return RSLT_FORM_INCOMPLETE ;
                                }

				if(donorActivityPeriod.getOID()==0){
					try{
						long oid = dbActivityPeriodBudget.insertExc(this.donorActivityPeriod);
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
						long oid = dbActivityPeriodBudget.updateExc(this.donorActivityPeriod);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidActivityPeriodBudget != 0) {
					try {
						donorActivityPeriod = DbActivityPeriodBudget.fetchExc(oidActivityPeriodBudget);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidActivityPeriodBudget != 0) {
					try {
						donorActivityPeriod = DbActivityPeriodBudget.fetchExc(oidActivityPeriodBudget);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidActivityPeriodBudget != 0){
					try{
						long oid = DbActivityPeriodBudget.deleteExc(oidActivityPeriodBudget);
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
