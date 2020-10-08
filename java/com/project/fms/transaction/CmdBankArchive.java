/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/3/2008 11:46:59 AM
\***********************************/

package com.project.fms.transaction;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;


public class CmdBankArchive extends Control {

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
	private BankArchive bankArchive ;
	private DbBankArchive dbBankArchive;
	private JspBankArchive jspBankArchive;

	public CmdBankArchive(HttpServletRequest request){
		msgString = "";
		bankArchive = new BankArchive();
		try{
			dbBankArchive = new DbBankArchive(0);
		}catch(Exception e){;}
		jspBankArchive = new JspBankArchive(request, bankArchive);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspBankArchive.addError(jspBankArchive.JSP_ARCHIVE_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public BankArchive getBankArchive() { return bankArchive; }

	public JspBankArchive getForm() { return jspBankArchive; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidBankArchive)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspBankArchive.requestEntityObject(bankArchive);
				break;

			case JSPCommand.SAVE :
				if(oidBankArchive != 0)
				{
					try
					{
						bankArchive = DbBankArchive.fetchExc(oidBankArchive);
					}
					catch(Exception exc)
					{
					}
				}

				jspBankArchive.requestEntityObject(bankArchive);

				if(jspBankArchive.errorSize()>0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(bankArchive.getOID()==0)
				{
					try
					{
						long oid = dbBankArchive.insertExc(this.bankArchive);
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
						long oid = dbBankArchive.updateExc(this.bankArchive);
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
				if (oidBankArchive != 0) 
				{
					try 
					{
						bankArchive = DbBankArchive.fetchExc(oidBankArchive);
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
				if (oidBankArchive != 0) 
				{
					try 
					{
						bankArchive = DbBankArchive.fetchExc(oidBankArchive);
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
				if (oidBankArchive != 0)
				{
					try
					{
						long oid = DbBankArchive.deleteExc(oidBankArchive);
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
