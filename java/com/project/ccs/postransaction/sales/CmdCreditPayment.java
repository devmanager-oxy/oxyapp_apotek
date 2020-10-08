/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;

/**
 *
 * @author Administrator
 */
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


public class CmdCreditPayment extends Control implements I_Language {

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
	private CreditPayment creditPayment ;
	private DbCreditPayment dbCreditPayment;
	private JspCreditPayment jspCreditPayment;
	int language = LANGUAGE_DEFAULT;

	public CmdCreditPayment(HttpServletRequest request){
		msgString = "";
		creditPayment = new CreditPayment();
		try{
			dbCreditPayment = new DbCreditPayment(0); 
		}catch(Exception e){;}
		jspCreditPayment = new JspCreditPayment(request, creditPayment);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspCreditPayment.addError(jspCreditPayment.JSP_CREDIT_PAYMENT_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public CreditPayment getCreditPayment() { return creditPayment; }

	public JspCreditPayment getForm() { return jspCreditPayment; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	//public int action(int cmd , long oidSalesDetail,long companyId)
        public int action(int cmd , long oidCreditPayment, long oidSales)
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
				break;

			case JSPCommand.SUBMIT :
				jspCreditPayment.requestEntityObject(creditPayment);
				break;

			case JSPCommand.SAVE :
				if(oidCreditPayment != 0)
				{
					try
					{
						creditPayment = DbCreditPayment.fetchExc(oidCreditPayment);
					}
					catch(Exception exc)
					{
					}
				}
                                
				jspCreditPayment.requestEntityObject(creditPayment);
                                
                                creditPayment.setSales_id(oidSales);
                                

				if(jspCreditPayment.errorSize()>0 || oidSales==0) 
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
                                //   im = DbItemMaster.fetchExc(salesDetail.getProductMasterId());
                                 //   salesDetail.setCogs(im.getCogs());
                                //}
                                //catch(Exception ex){
                                        
                                //}
                                
                                //System.out.println("----> salesDetail.getProductMasterId() : "+salesDetail.getProductMasterId());                                
                                //System.out.println("----> im.getCogs() : "+im.getCogs());                                

				if(creditPayment.getOID()==0)
				{
					try
					{
						long oid = dbCreditPayment.insertExc(this.creditPayment);
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
						long oid = dbCreditPayment.updateExc(this.creditPayment);
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
				if (oidCreditPayment != 0) 
				{
					try 
					{
						creditPayment = DbCreditPayment.fetchExc(oidCreditPayment);
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
				if (oidCreditPayment != 0) 
				{
					try 
					{
						creditPayment = DbCreditPayment.fetchExc(oidCreditPayment);
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
				if (oidCreditPayment != 0)
				{
					try
					{
						long oid = DbCreditPayment.deleteExc(oidCreditPayment);
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
