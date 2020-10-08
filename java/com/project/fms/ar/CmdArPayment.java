/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/17/2008 11:07:36 AM
\***********************************/

package com.project.fms.ar;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;


public class CmdArPayment extends Control implements I_Language {

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
	private ArPayment arPayment ;
	private DbArPayment dbArPayment;
	private JspArPayment jspArPayment;
	int language = LANGUAGE_DEFAULT;

	public CmdArPayment(HttpServletRequest request){
		msgString = "";
		arPayment = new ArPayment();
		try{
			dbArPayment = new DbArPayment(0);
		}catch(Exception e){;}
		jspArPayment = new JspArPayment(request, arPayment);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspArPayment.addError(jspArPayment.JSP_AR_PAYMENT_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public ArPayment getArPayment() { return arPayment; }

	public JspArPayment getForm() { return jspArPayment; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidArPayment,long companyId)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspArPayment.requestEntityObject(arPayment);
				break;

			case JSPCommand.SAVE :
				if(oidArPayment != 0)
				{
					try
					{
						arPayment = DbArPayment.fetchExc(oidArPayment);
					}
					catch(Exception exc)
					{
					}
				}

				jspArPayment.requestEntityObject(arPayment);
                                
                                Coa coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(arPayment.getArAccountId());
                                    if(!coa.getStatus().equals("POSTABLE")){
                                        jspArPayment.addError(jspArPayment.JSP_AR_ACCOUNT_ID, "postable account reqquired");
                                    }
                                }
                                catch(Exception e){
                                }
                                
                                coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(arPayment.getReceiptAccountId());
                                    if(!coa.getStatus().equals("POSTABLE")){
                                        jspArPayment.addError(jspArPayment.JSP_RECEIPT_ACCOUNT_ID, "postable account reqquired");
                                    }
                                }
                                catch(Exception e){
                                }

				if(jspArPayment.errorSize()>0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(companyId==0)
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				arPayment.setCompanyId(companyId);

				if(arPayment.getOID()==0)
				{
					try
					{
                                                arPayment.setCounter(DbArPayment.getNextCounter(companyId));
                                                arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(companyId));
                                                arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(),companyId));                                            
                                            
						long oid = dbArPayment.insertExc(this.arPayment);
						if(oid!=0)
						{
							rsCode = RSLT_OK;
							msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                                                        //posting journal
                                                        DbArPayment.postJournal(oid);
                                                        //update status
                                                        DbArPayment.postStatusInvoice(oid);
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
						long oid = dbArPayment.updateExc(this.arPayment);
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
				if (oidArPayment != 0) 
				{
					try 
					{
						arPayment = DbArPayment.fetchExc(oidArPayment);
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
				if (oidArPayment != 0) 
				{
					try 
					{
						arPayment = DbArPayment.fetchExc(oidArPayment);
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
				if (oidArPayment != 0)
				{
					try
					{
						long oid = DbArPayment.deleteExc(oidArPayment);
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
