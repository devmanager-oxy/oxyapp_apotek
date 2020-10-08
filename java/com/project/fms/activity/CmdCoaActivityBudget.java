
package com.project.fms.activity;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.*;


public class CmdCoaActivityBudget extends Control implements I_Language 
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
	private CoaActivityBudget coaActivityBudget;
	private DbCoaActivityBudget pstCoaActivityBudget;
	private JspCoaActivityBudget jspCoaActivityBudget;
	int language = LANGUAGE_DEFAULT;

	public CmdCoaActivityBudget(HttpServletRequest request){
		msgString = "";
		coaActivityBudget = new CoaActivityBudget();
		try{
			pstCoaActivityBudget = new DbCoaActivityBudget(0);
		}catch(Exception e){;}
		jspCoaActivityBudget = new JspCoaActivityBudget(request, coaActivityBudget);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCoaActivityBudget.addError(jspCoaActivityBudget.JSP_coa_activity_budget_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public CoaActivityBudget getCoaActivityBudget() { return coaActivityBudget; } 

	public JspCoaActivityBudget getForm() { return jspCoaActivityBudget; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCoaActivityBudget){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidCoaActivityBudget != 0){
					try{
						coaActivityBudget = DbCoaActivityBudget.fetchExc(oidCoaActivityBudget);
					}catch(Exception exc){
					}
				}

				jspCoaActivityBudget.requestEntityObject(coaActivityBudget);
                                
                                Coa coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(coaActivityBudget.getCoaId());
                                }
                                catch(Exception e){

                                }

                                //jika tidak postable tidak boleh
                                if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                    jspCoaActivityBudget.addError(jspCoaActivityBudget.JSP_COA_ID, "postable account type required");
                                }
                                
                                //check duplikasi
                                String where = "";
                                if(oidCoaActivityBudget != 0){
                                    where = "coa_id="+coaActivityBudget.getCoaId()+" and activity_period_id="+coaActivityBudget.getActivityPeriodId()+" and coa_activity_budget_id !="+oidCoaActivityBudget;                                    
                                }
                                else{
                                    where = "coa_id="+coaActivityBudget.getCoaId()+" and activity_period_id="+coaActivityBudget.getActivityPeriodId();
                                }
                                
                                if(DbCoaActivityBudget.getCount(where)>0){
                                    jspCoaActivityBudget.addError(jspCoaActivityBudget.JSP_COA_ID, "account already exist, duplicate data entry");
                                }
                                

				if(jspCoaActivityBudget.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(coaActivityBudget.getOID()==0){
					try{
						long oid = pstCoaActivityBudget.insertExc(this.coaActivityBudget);
                                                msgString = "Data has been saved successfully";
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
						long oid = pstCoaActivityBudget.updateExc(this.coaActivityBudget);
                                                msgString = "Data has been saved successfully";
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
				if (oidCoaActivityBudget != 0) {
					try {
						coaActivityBudget = DbCoaActivityBudget.fetchExc(oidCoaActivityBudget);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCoaActivityBudget != 0) {
					try {
						coaActivityBudget = DbCoaActivityBudget.fetchExc(oidCoaActivityBudget);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCoaActivityBudget != 0){
					try{
						long oid = DbCoaActivityBudget.deleteExc(oidCoaActivityBudget);
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
