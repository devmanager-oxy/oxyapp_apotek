package com.project.fms.reportform;

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
import com.project.util.lang.*;
import java.util.Date;

public class CmdRptFormat extends Control implements I_Language 
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
	private RptFormat rptFormat;
	private DbRptFormat pstRptFormat;
	private JspRptFormat jspRptFormat;
	int language = LANGUAGE_DEFAULT;

	public CmdRptFormat(HttpServletRequest request){
		msgString = "";
		rptFormat = new RptFormat();
		try{
			pstRptFormat = new DbRptFormat(0);
		}catch(Exception e){;}
		jspRptFormat = new JspRptFormat(request, rptFormat);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspRptFormat.addError(jspRptFormat.JSP_FIELD_rpt_format_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public RptFormat getRptFormat() { return rptFormat; } 

	public JspRptFormat getForm() { return jspRptFormat; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidRptFormat, long userId){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidRptFormat != 0){
					try{
						rptFormat = DbRptFormat.fetchExc(oidRptFormat);
					}catch(Exception exc){
					}
				}

				jspRptFormat.requestEntityObject(rptFormat);

				if(jspRptFormat.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(rptFormat.getOID()==0){
					try{
						rptFormat.setCreateDate(new Date());
						rptFormat.setStatus(0);
						rptFormat.setCreatorId(userId);
						
						long oid = pstRptFormat.insertExc(this.rptFormat);
						
						if(oid!=0 && rptFormat.getRefId()!=0){
							RptFormat rF = DbRptFormat.fetchExc(rptFormat.getRefId());
							rF.setUpdateDate(new Date());
							rF.setUpdateById(userId);
							rF.setStatus(1);
							rF.setInactiveDate(new Date());
							
							DbRptFormat.updateExc(rF);
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
						
						rptFormat.setUpdateDate(new Date());
						rptFormat.setUpdateById(userId);
						
						long oid = pstRptFormat.updateExc(this.rptFormat);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidRptFormat != 0) {
					try {
						rptFormat = DbRptFormat.fetchExc(oidRptFormat);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidRptFormat != 0) {
					try {
						rptFormat = DbRptFormat.fetchExc(oidRptFormat);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidRptFormat != 0){
					try{
						long oid = DbRptFormat.deleteExc(oidRptFormat);
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
