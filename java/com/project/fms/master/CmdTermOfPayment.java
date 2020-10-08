
package com.project.fms.master;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdTermOfPayment extends Control {

	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private TermOfPayment termOfPayment ;
	private DbTermOfPayment dbTermOfPayment;
	private JspTermOfPayment jspTermOfPayment;

	public CmdTermOfPayment(HttpServletRequest request){
		msgString = "";
		termOfPayment = new TermOfPayment();
		try{
			dbTermOfPayment = new DbTermOfPayment(0);
		}catch(Exception e){;}
		jspTermOfPayment = new JspTermOfPayment(request, termOfPayment);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspTermOfPayment.addError(jspTermOfPayment.JSP_TERM_OF_PAYMENT_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public TermOfPayment getTermOfPayment() { return termOfPayment; }

	public JspTermOfPayment getForm() { return jspTermOfPayment; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidTermOfPayment)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspTermOfPayment.requestEntityObject(termOfPayment);
				break;

			case JSPCommand.SAVE :
				if(oidTermOfPayment != 0)
				{
					try
					{
						termOfPayment = DbTermOfPayment.fetchExc(oidTermOfPayment);
					}
					catch(Exception exc)
					{
					}
				}

				jspTermOfPayment.requestEntityObject(termOfPayment);

				if(jspTermOfPayment.errorSize()>0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(termOfPayment.getOID()==0)
				{
					try
					{
						long oid = dbTermOfPayment.insertExc(this.termOfPayment);
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
						long oid = dbTermOfPayment.updateExc(this.termOfPayment);
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
				if (oidTermOfPayment != 0) 
				{
					try 
					{
						termOfPayment = DbTermOfPayment.fetchExc(oidTermOfPayment);
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
				if (oidTermOfPayment != 0) 
				{
					try 
					{
						termOfPayment = DbTermOfPayment.fetchExc(oidTermOfPayment);
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
				if (oidTermOfPayment != 0)
				{
					try
					{
						long oid = DbTermOfPayment.deleteExc(oidTermOfPayment);
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
