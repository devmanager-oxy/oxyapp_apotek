/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/7/2008 8:34:41 PM
\***********************************/

package com.project.crm.project;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;


public class CmdProjectProductDetail extends Control implements I_Language {

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
	private ProjectProductDetail projectProductDetail ;
	private DbProjectProductDetail dbProjectProductDetail;
	private JspProjectProductDetail jspProjectProductDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdProjectProductDetail(HttpServletRequest request){
		msgString = "";
		projectProductDetail = new ProjectProductDetail();
		try{
			dbProjectProductDetail = new DbProjectProductDetail(0);
		}catch(Exception e){;}
		jspProjectProductDetail = new JspProjectProductDetail(request, projectProductDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspProjectProductDetail.addError(jspProjectProductDetail.JSP_PROJECT_PRODUCT_DETAIL_ID, resultText[0][RSLT_EST_CODE_EXIST] );
				return resultText[0][RSLT_EST_CODE_EXIST];
			default:
				return resultText[0][RSLT_UNKNOWN_ERROR];
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

	public ProjectProductDetail getProjectProductDetail() { return projectProductDetail; }

	public JspProjectProductDetail getForm() { return jspProjectProductDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidProjectProductDetail,long companyId)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspProjectProductDetail.requestEntityObject(projectProductDetail);
				break;

			case JSPCommand.SAVE :
				if(oidProjectProductDetail != 0)
				{
					try
					{
						projectProductDetail = DbProjectProductDetail.fetchExc(oidProjectProductDetail);
					}
					catch(Exception exc)
					{
					}
				}

				jspProjectProductDetail.requestEntityObject(projectProductDetail);

				if(jspProjectProductDetail.errorSize()>0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(companyId==0)
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				projectProductDetail.setCompanyId(companyId);

				if(projectProductDetail.getOID()==0)
				{
					try
					{
						long oid = dbProjectProductDetail.insertExc(this.projectProductDetail);
						if(oid!=0)
						{
							rsCode = RSLT_OK;
							msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
						}
					}
					catch(CONException dbexc)
					{
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}
					catch (Exception exc)
					{
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
						return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}
				else
				{
					try 
					{
						long oid = dbProjectProductDetail.updateExc(this.projectProductDetail);
						if(oid!=0)
						{
							rsCode = RSLT_OK;
							msgString = JSPMessage.getMessage(JSPMessage.MSG_UPDATED);
						}
					}
					catch (CONException dbexc)
					{
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}
					catch (Exception exc)
					{
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
						return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidProjectProductDetail != 0) 
				{
					try 
					{
						projectProductDetail = DbProjectProductDetail.fetchExc(oidProjectProductDetail);
					} 
					catch (CONException dbexc)
					{
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} 
					catch (Exception exc)
					{ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidProjectProductDetail != 0) 
				{
					try 
					{
						projectProductDetail = DbProjectProductDetail.fetchExc(oidProjectProductDetail);
					} 
					catch (CONException dbexc)
					{
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} 
					catch (Exception exc)
					{ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidProjectProductDetail != 0)
				{
					try
					{
						long oid = DbProjectProductDetail.deleteExc(oidProjectProductDetail);
						if(oid!=0)
						{
							msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}
						else
						{
							msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}
					catch(CONException dbexc)
					{
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}
					catch(Exception exc)
					{	
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}

}
