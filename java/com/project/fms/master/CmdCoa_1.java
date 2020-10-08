
package com.project.fms.master;

import java.util.*; 
import java.sql.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
//import com.project.general.*;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.I_Project;
import com.project.general.*;
import com.project.system.*;

public class CmdCoa_1 extends Control 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private Coa coa;
	private DbCoa dbCoa;
	private JspCoa_1 jspCoa_1;

	public CmdCoa_1(HttpServletRequest request){
		msgString = "";
		coa = new Coa();
		try{
			dbCoa = new DbCoa(0);
		}catch(Exception e){;}
		jspCoa_1 = new JspCoa_1(request, coa);
	}

	private String getSystemMessage(int msgCode){
                switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCoa_1.addError(jspCoa_1.JSP_CODE, resultText[1][RSLT_EST_CODE_EXIST] );
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

	public Coa getCoa() { return coa; } 

	public JspCoa_1 getForm() { return jspCoa_1; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCoa){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				double oldOpeningBalance = 0;
                                if(oidCoa != 0){
					try{
						coa = DbCoa.fetchExc(oidCoa);
                                                oldOpeningBalance = coa.getOpeningBalance();
					}catch(Exception exc){
					}
				}

                                
                                System.out.println("\n\nin coa extra data ....");
                                System.out.println("==================== ....");
                                
                                
				jspCoa_1.requestEntityObject(coa);
                                
                                long oid = 0;
                                if(coa.getDebetPrefixCode().length()==0 && coa.getCreditPrefixCode().length()==0){
                                    jspCoa_1.addError(jspCoa_1.JSP_DEBET_PREFIX_CODE, "Please fill in");
                                    jspCoa_1.addError(jspCoa_1.JSP_CREDIT_PREFIX_CODE, "Please fill in");
                                }
                                else if(coa.getDebetPrefixCode().length()>0 && coa.getCreditPrefixCode().length()==0){
                                    jspCoa_1.addError(jspCoa_1.JSP_CREDIT_PREFIX_CODE, "Please fill in");
                                }
                                else if(coa.getDebetPrefixCode().length()==0 && coa.getCreditPrefixCode().length()>0){
                                    jspCoa_1.addError(jspCoa_1.JSP_DEBET_PREFIX_CODE, "Please fill in");
                                }
                                
                                if(jspCoa_1.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				
                                try {
                                        if(coa.getDebetPrefixCode().length()>0 && coa.getCreditPrefixCode().length()>0){
                                            coa.setIsNeedExtra(1);
                                        }
                                        else{
                                            coa.setIsNeedExtra(0);
                                        }
                                        
                                        oid = dbCoa.updateExc(this.coa);
                                        
                                }catch (CONException dbexc){
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                        return getControlMsgId(excCode);
                                }catch (Exception exc){
                                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
                                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                                }

				
                                                                                                
				break;

                        case JSPCommand.SUBMIT :
                            jspCoa_1.requestEntityObject(coa);
                            break;
                        
                                
			case JSPCommand.EDIT :
				if (oidCoa != 0) {
					try {
						coa = DbCoa.fetchExc(oidCoa);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCoa != 0) {
					try {
						coa = DbCoa.fetchExc(oidCoa);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCoa != 0){
					try{
						oid = DbCoa.deleteExc(oidCoa);
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
