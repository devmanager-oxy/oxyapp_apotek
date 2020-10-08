package com.project.coorp.member;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.coorp.member.*;
import com.project.general.*;

public class CmdMember extends Control 
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
	private Member customer;
	private DbMember dbMember;
	private JspMember jspMember;
	
	public CmdMember(HttpServletRequest request){
		msgString = "";
		customer = new Member();
		try{
			dbMember = new DbMember(0);
		}catch(Exception e){;}
		jspMember = new JspMember(request, customer);
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

	
	public Member getMember() { return customer; } 

	public JspMember getForm() { return jspMember; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidMember){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;
                                
                        case JSPCommand.SUBMIT:
                            if(oidMember != 0){
                                            try{
                                                    customer = DbMember.fetchExc(oidMember);
                                            }catch(Exception exc){
                                            }
                                    }

                                    jspMember.requestEntityObject(customer);
                                break;

			case JSPCommand.SAVE :
				if(oidMember != 0){
					try{
						customer = DbMember.fetchExc(oidMember);
					}catch(Exception exc){
					}
				}

				jspMember.requestEntityObject(customer);
                                
                                DinasUnit du = new DinasUnit();
                                try{
                                    du = DbDinasUnit.fetchExc(customer.getDinasUnitId());
                                    customer.setDinasId(du.getDinasId());
                                }
                                catch(Exception e){
                                }
                                
                                if(customer.getStatus()==1){
                                    customer.setTglKeluar(null);
                                }

				if(jspMember.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
				if(customer.getOID()==0){
					try{
						long oid = dbMember.insertExc(this.customer);
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
						long oid = dbMember.updateExc(this.customer);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidMember != 0) {
					try {
                                            
                                                System.out.println("\n\n===\nin edit customer : oidMember "+oidMember);
                                            
						customer = DbMember.fetchExc(oidMember);
                                                
                                                System.out.println("customer : "+customer.getOID()+" , "+customer.getNama());
                                                
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidMember != 0) {
					try {
						customer = DbMember.fetchExc(oidMember);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidMember != 0){
					try{
						long oid = DbMember.deleteExc(oidMember);
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
