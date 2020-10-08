
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

public class CmdCoaPortofolioSetup extends Control implements I_Language 
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
	private CoaPortofolioSetup coaPortofolioSetup;
	private DbCoaPortofolioSetup pstCoaPortofolioSetup;
	private JspCoaPortofolioSetup jspCoaPortofolioSetup;
	int language = LANGUAGE_DEFAULT;

	public CmdCoaPortofolioSetup(HttpServletRequest request){
		msgString = "";
		coaPortofolioSetup = new CoaPortofolioSetup();
		try{
			pstCoaPortofolioSetup = new DbCoaPortofolioSetup(0);
		}catch(Exception e){;}
		jspCoaPortofolioSetup = new JspCoaPortofolioSetup(request, coaPortofolioSetup);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCoaPortofolioSetup.addError(jspCoaPortofolioSetup.JSP_FIELD_portofolio_setup_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public CoaPortofolioSetup getCoaPortofolioSetup() { return coaPortofolioSetup; } 

	public JspCoaPortofolioSetup getForm() { return jspCoaPortofolioSetup; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCoaPortofolioSetup){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidCoaPortofolioSetup != 0){
					try{
						coaPortofolioSetup = DbCoaPortofolioSetup.fetchExc(oidCoaPortofolioSetup);
					}catch(Exception exc){
					}
				}

				jspCoaPortofolioSetup.requestEntityObject(coaPortofolioSetup);
                                
                                if(coaPortofolioSetup.getCoaRevenueId()==0 && coaPortofolioSetup.getCoaExpenseId()==0){
                                    jspCoaPortofolioSetup.addError(jspCoaPortofolioSetup.JSP_COA_REVENUE_ID, "Entry required"); 
                                }

				if(jspCoaPortofolioSetup.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                
                                Coa coa = new Coa();
                                if(coaPortofolioSetup.getCoaRevenueId()!=0){
                                    try{
                                        coa = DbCoa.fetchExc(coaPortofolioSetup.getCoaRevenueId());
                                    }
                                    catch(Exception e){
                                    }
                                }
                                else if(coaPortofolioSetup.getCoaExpenseId()!=0){
                                    try{
                                        coa = DbCoa.fetchExc(coaPortofolioSetup.getCoaExpenseId());
                                    }
                                    catch(Exception e){
                                    }
                                }
                                
                                coaPortofolioSetup.setCoaCode(coa.getCode());
                                coaPortofolioSetup.setCoaRefId(coa.getAccRefId());                                

				if(coaPortofolioSetup.getOID()==0){
					try{
						long oid = pstCoaPortofolioSetup.insertExc(this.coaPortofolioSetup);
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
						long oid = pstCoaPortofolioSetup.updateExc(this.coaPortofolioSetup);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidCoaPortofolioSetup != 0) {
					try {
						coaPortofolioSetup = DbCoaPortofolioSetup.fetchExc(oidCoaPortofolioSetup);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCoaPortofolioSetup != 0) {
					try {
						coaPortofolioSetup = DbCoaPortofolioSetup.fetchExc(oidCoaPortofolioSetup);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCoaPortofolioSetup != 0){
					try{
						long oid = DbCoaPortofolioSetup.deleteExc(oidCoaPortofolioSetup);
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
