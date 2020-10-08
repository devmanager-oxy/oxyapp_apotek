
package com.project.coorp.pinjaman;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class CmdPeriodeRekap extends Control
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
	private PeriodeRekap periode;
	private DbPeriodeRekap dbPeriodeRekap;
	private JspPeriodeRekap jspPeriodeRekap;

	public CmdPeriodeRekap(HttpServletRequest request){
		msgString = "";
		periode = new PeriodeRekap();
		try{
			dbPeriodeRekap = new DbPeriodeRekap(0);
		}catch(Exception e){;}
		jspPeriodeRekap = new JspPeriodeRekap(request, periode);
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

	public PeriodeRekap getPeriodeRekap() { return periode; } 

	public JspPeriodeRekap getForm() { return jspPeriodeRekap; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPeriodeRekap){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidPeriodeRekap != 0){
					try{
						periode = DbPeriodeRekap.fetchExc(oidPeriodeRekap);
					}catch(Exception exc){
					}
				}

				jspPeriodeRekap.requestEntityObject(periode);

				if(jspPeriodeRekap.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(periode.getOID()==0){
					try{
						long oid = dbPeriodeRekap.insertExc(this.periode);
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
						long oid = dbPeriodeRekap.updateExc(this.periode);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidPeriodeRekap != 0) {
					try {
						periode = DbPeriodeRekap.fetchExc(oidPeriodeRekap);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPeriodeRekap != 0) {
					try {
						periode = DbPeriodeRekap.fetchExc(oidPeriodeRekap);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidPeriodeRekap != 0){
					try{
						long oid = DbPeriodeRekap.deleteExc(oidPeriodeRekap);
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
