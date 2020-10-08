/***********************************\
|  Create by rahde              |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  03/11/2011 9:58:08 AM
\***********************************/

package com.project.ccs.postransaction.sales;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.sales.*;
import com.project.ccs.posmaster.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.system.*;


public class CmdReturnPayment extends Control implements I_Language {

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
	private ReturnPayment returnPayment ;
	private DbReturnPayment dbReturnPayment;
	private JspReturnPayment jspReturnPayment;
	int language = LANGUAGE_DEFAULT;

	public CmdReturnPayment(HttpServletRequest request){
		msgString = "";
		returnPayment = new ReturnPayment();
		try{
			dbReturnPayment = new DbReturnPayment(0); 
		}catch(Exception e){;}
		jspReturnPayment = new JspReturnPayment(request, returnPayment);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspReturnPayment.addError(jspReturnPayment.JSP_RETURN_PAYMENT_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public ReturnPayment getReturnPayment() { return returnPayment; }

	public JspReturnPayment getForm() { return jspReturnPayment; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	//public int action(int cmd , long oidSalesDetail,long companyId)
        public int action(int cmd , long oidReturnPayment, long oidSales)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspReturnPayment.requestEntityObject(returnPayment);
				break;

			case JSPCommand.POST :
				if(oidReturnPayment != 0)
				{
					try
					{
						returnPayment = dbReturnPayment.fetchExc(oidReturnPayment);
					}
					catch(Exception exc)
					{
					}
				}

				jspReturnPayment.requestEntityObject(returnPayment);
                                
                                returnPayment.setSales_id(oidSales);
                                Currency c = DbCurrency.getCurrencyByCode(DbSystemProperty.getValueByName("CURRENCY_CODE_IDR"));
                                returnPayment.setCurrency_id(c.getOID());
                                

				if(jspReturnPayment.errorSize()>0 || oidSales==0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                /*
				if(companyId==0)
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				salesDetail.setCompanyId(companyId);
                                 */
                                
                                //ItemMaster im = new ItemMaster();
                                //try{
                                //    im = DbItemMaster.fetchExc(salesDetail.getProductMasterId());
                                //    salesDetail.setCogs(im.getCogs());
                               // }
                                //catch(Exception ex){
                                        
                                //}
                                
                               // System.out.println("----> salesDetail.getProductMasterId() : "+salesDetail.getProductMasterId());                                
                               // System.out.println("----> im.getCogs() : "+im.getCogs());                                

				if(returnPayment.getOID()==0)
				{
					try
					{
						long oid = dbReturnPayment.insertExc(this.returnPayment);
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
						long oid = dbReturnPayment.updateExc(this.returnPayment);
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
				if (oidReturnPayment != 0) 
				{
					try 
					{
						returnPayment = DbReturnPayment.fetchExc(oidReturnPayment);
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
				if (oidReturnPayment != 0) 
				{
					try 
					{
						returnPayment = DbReturnPayment.fetchExc(oidReturnPayment);
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
				if (oidReturnPayment != 0)
				{
					try
					{
						long oid = DbReturnPayment.deleteExc(oidReturnPayment);
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
