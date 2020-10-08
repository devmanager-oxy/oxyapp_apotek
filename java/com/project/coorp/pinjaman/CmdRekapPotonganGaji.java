
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

public class CmdRekapPotonganGaji extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCONPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private RekapPotonganGaji rekapPotonganGaji;
	private DbRekapPotonganGaji pstRekapPotonganGaji;
	private JspRekapPotonganGaji jspRekapPotonganGaji;
	int language = LANGUAGE_DEFAULT;

	public CmdRekapPotonganGaji(HttpServletRequest request){
		msgString = "";
		rekapPotonganGaji = new RekapPotonganGaji();
		try{
			pstRekapPotonganGaji = new DbRekapPotonganGaji(0);
		}catch(Exception e){;}
		jspRekapPotonganGaji = new JspRekapPotonganGaji(request, rekapPotonganGaji);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspRekapPotonganGaji.addError(jspRekapPotonganGaji.JSP_FIELD_rekap_potongan_gaji_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public RekapPotonganGaji getRekapPotonganGaji() { return rekapPotonganGaji; } 

	public JspRekapPotonganGaji getForm() { return jspRekapPotonganGaji; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidRekapPotonganGaji){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidRekapPotonganGaji != 0){
					try{
						rekapPotonganGaji = DbRekapPotonganGaji.fetchExc(oidRekapPotonganGaji);
					}catch(Exception exc){
					}
				}

				jspRekapPotonganGaji.requestEntityObject(rekapPotonganGaji);

				if(jspRekapPotonganGaji.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCONPLETE ;
				}

				if(rekapPotonganGaji.getOID()==0){
					try{
						long oid = pstRekapPotonganGaji.insertExc(this.rekapPotonganGaji);
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
						long oid = pstRekapPotonganGaji.updateExc(this.rekapPotonganGaji);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidRekapPotonganGaji != 0) {
					try {
						rekapPotonganGaji = DbRekapPotonganGaji.fetchExc(oidRekapPotonganGaji);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidRekapPotonganGaji != 0) {
					try {
						rekapPotonganGaji = DbRekapPotonganGaji.fetchExc(oidRekapPotonganGaji);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidRekapPotonganGaji != 0){
					try{
						long oid = DbRekapPotonganGaji.deleteExc(oidRekapPotonganGaji);
						if(oid!=0){
							msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCONPLETE;
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
