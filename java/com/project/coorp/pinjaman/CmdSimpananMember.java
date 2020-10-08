
package com.project.coorp.pinjaman;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;


public class CmdSimpananMember extends Control implements I_Language 
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
	private SimpananMember simpananMember;
	private DbSimpananMember pstSimpananMember;
	private JspSimpananMember jspSimpananMember;
	int language = LANGUAGE_DEFAULT;

	public CmdSimpananMember(HttpServletRequest request){
		msgString = "";
		simpananMember = new SimpananMember();
		try{
			pstSimpananMember = new DbSimpananMember(0);
		}catch(Exception e){;}
		jspSimpananMember = new JspSimpananMember(request, simpananMember);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSimpananMember.addError(jspSimpananMember.JSP_FIELD_simpanan_member_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public SimpananMember getSimpananMember() { return simpananMember; } 

	public JspSimpananMember getForm() { return jspSimpananMember; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSimpananMember){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSimpananMember != 0){
					try{
						simpananMember = DbSimpananMember.fetchExc(oidSimpananMember);
					}catch(Exception exc){
					}
				}

				jspSimpananMember.requestEntityObject(simpananMember);

				if(jspSimpananMember.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(simpananMember.getOID()==0){
					try{
                                                //simpananMember.setTanggal(new Date());
                                                simpananMember.setCounter(DbSimpananMember.getNextCounter());
                                                simpananMember.setPrefixNumber(DbSimpananMember.getNumberPrefix());
                                                simpananMember.setNumber(DbSimpananMember.getNextNumber(simpananMember.getCounter()));
                                                
						long oid = pstSimpananMember.insertExc(this.simpananMember);
                                                
                                                if(oid!=0){
                                                    DbSimpananMember.postJournal(simpananMember);
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
						long oid = pstSimpananMember.updateExc(this.simpananMember);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSimpananMember != 0) {
					try {
						simpananMember = DbSimpananMember.fetchExc(oidSimpananMember);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSimpananMember != 0) {
					try {
						simpananMember = DbSimpananMember.fetchExc(oidSimpananMember);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSimpananMember != 0){
					try{
						long oid = DbSimpananMember.deleteExc(oidSimpananMember);
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
