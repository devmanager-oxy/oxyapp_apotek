
package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.costing.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;

public class CmdPromotionItem extends Control implements I_Language 
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
	private PromotionItem promotionItem;
	private DbPromotionItem pstCostingItem;
	private JspPromotionItem jspPromotionItem;
	int language = LANGUAGE_DEFAULT;

	public CmdPromotionItem(HttpServletRequest request){
		msgString = "";
		promotionItem = new PromotionItem();
		try{
			pstCostingItem = new DbPromotionItem(0);
		}catch(Exception e){;}
		jspPromotionItem = new JspPromotionItem(request, promotionItem);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspPromotionItem.addError(jspPromotionItem.JSP_FIELD_costing_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public PromotionItem getCostingItem() { return promotionItem; } 

	public JspPromotionItem getForm() { return jspPromotionItem; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPromotionItem, long oidCosting){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
                            break;
                                
                        case JSPCommand.ACTIVATE:
                            break;        

			case JSPCommand.SAVE :
				if(oidPromotionItem != 0){
					try{
						promotionItem = DbPromotionItem.fetchExc(oidPromotionItem);
					}catch(Exception exc){
					}
				}

				jspPromotionItem.requestEntityObject(promotionItem);
                                promotionItem.setPromotionId(oidCosting);

				if(jspPromotionItem.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(promotionItem.getOID()==0){
					try{
						long oid = pstCostingItem.insertExc(this.promotionItem);
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
						long oid = pstCostingItem.updateExc(this.promotionItem);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidPromotionItem != 0) {
					try {
						promotionItem = DbPromotionItem.fetchExc(oidPromotionItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPromotionItem != 0) {
					try {
						promotionItem = DbPromotionItem.fetchExc(oidPromotionItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
                        

			case JSPCommand.DELETE :
				if (oidPromotionItem != 0){
					try{
						long oid = DbPromotionItem.deleteExc(oidPromotionItem);
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
