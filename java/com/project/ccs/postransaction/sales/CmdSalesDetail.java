/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  11/14/2008 9:58:08 AM
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


public class CmdSalesDetail extends Control implements I_Language {

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
	private SalesDetail salesDetail ;
	private DbSalesDetail dbSalesDetail;
	private JspSalesDetail jspSalesDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdSalesDetail(HttpServletRequest request){
		msgString = "";
		salesDetail = new SalesDetail();
		try{
			dbSalesDetail = new DbSalesDetail(0); 
		}catch(Exception e){;}
		jspSalesDetail = new JspSalesDetail(request, salesDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode)
		{
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspSalesDetail.addError(jspSalesDetail.JSP_SALES_DETAIL_ID, resultText[0][RSLT_EST_CODE_EXIST] );
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

	public SalesDetail getSalesDetail() { return salesDetail; }

	public JspSalesDetail getForm() { return jspSalesDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	//public int action(int cmd , long oidSalesDetail,long companyId)
        public int action(int cmd , long oidSalesDetail, long oidSales, boolean isStockCodeEmpty, boolean isStockSame )
	{
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd)
		{
			case JSPCommand.ADD :
                            if (oidSalesDetail != 0){
                                try {
                                    salesDetail = dbSalesDetail.fetchExc(oidSalesDetail);
                                } catch (Exception exc) {}
                            }

                            jspSalesDetail.requestEntityObject(salesDetail);
                
                            break;
				
                        case JSPCommand.VIEW :        
                            if (oidSalesDetail != 0){
                                try {
                                    salesDetail = dbSalesDetail.fetchExc(oidSalesDetail);
                                } catch (Exception exc) {}
                            }

                            jspSalesDetail.requestEntityObject(salesDetail);
                
                            break;
                        
			case JSPCommand.SUBMIT :
				jspSalesDetail.requestEntityObject(salesDetail);
				break;

			case JSPCommand.SAVE :
				if(oidSalesDetail != 0)
				{
					try
					{
						salesDetail = DbSalesDetail.fetchExc(oidSalesDetail);
					}
					catch(Exception exc)
					{
					}
				}

				jspSalesDetail.requestEntityObject(salesDetail);
                                
                                salesDetail.setSalesId(oidSales);

				if(jspSalesDetail.errorSize()>0 || oidSales==0) 
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                if(isStockCodeEmpty == true){
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE;

                                }
                                if(isStockSame==true){
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_EST_CODE_EXIST;
                                }
                                
                                /*
				if(companyId==0)
				{
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				salesDetail.setCompanyId(companyId);
                                 */
                                
                                ItemMaster im = new ItemMaster();
                                try{
                                    im = DbItemMaster.fetchExc(salesDetail.getProductMasterId());
                                    salesDetail.setCogs(im.getCogs());
                                }
                                catch(Exception ex){
                                        
                                }
                                
                                System.out.println("----> salesDetail.getProductMasterId() : "+salesDetail.getProductMasterId());                                
                                System.out.println("----> im.getCogs() : "+im.getCogs());                                

				if(salesDetail.getOID()==0)
				{
					try
					{
						long oid = dbSalesDetail.insertExc(this.salesDetail);
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
						long oid = dbSalesDetail.updateExc(this.salesDetail);
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
				if (oidSalesDetail != 0) 
				{
					try 
					{
						salesDetail = DbSalesDetail.fetchExc(oidSalesDetail);
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
				if (oidSalesDetail != 0) 
				{
					try 
					{
						salesDetail = DbSalesDetail.fetchExc(oidSalesDetail);
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
				if (oidSalesDetail != 0)
				{
					try
					{
						long oid = DbSalesDetail.deleteExc(oidSalesDetail);
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
