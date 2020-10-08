
package com.project.ccs.postransaction.costing;

import com.project.I_Project;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.postransaction.stock.DbStock;

public class CmdCostingItem extends Control implements I_Language 
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
	private CostingItem costingItem;
	private DbCostingItem pstCostingItem;
	private JspCostingItem jspCostingItem;
	int language = LANGUAGE_DEFAULT;

	public CmdCostingItem(HttpServletRequest request){
		msgString = "";
		costingItem = new CostingItem();
		try{
			pstCostingItem = new DbCostingItem(0);
		}catch(Exception e){;}
		jspCostingItem = new JspCostingItem(request, costingItem);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCostingItem.addError(jspCostingItem.JSP_FIELD_costing_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public CostingItem getCostingItem() { return costingItem; } 

	public JspCostingItem getForm() { return jspCostingItem; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCostingItem, long oidCosting,  int qtyStockCode){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
                            break;
                                
                        case JSPCommand.ACTIVATE:
                            break;        

			case JSPCommand.SAVE :
                                
                                Costing costing = new Costing();
                                
				if(oidCostingItem != 0){
                                    try{
                                            costingItem = DbCostingItem.fetchExc(oidCostingItem);
                                    }catch(Exception exc){
                                    }
				}
                                
                                if(oidCosting!=0){
                                    try {
                                        costing = DbCosting.fetchExc(oidCosting);  
                                    } catch (Exception exc) {
                                    }
                                }

				jspCostingItem.requestEntityObject(costingItem);
                                costingItem.setCostingId(oidCosting);
                                
                                if(costingItem.getCostingId()==0){
                                    jspCostingItem.addError(jspCostingItem.JSP_QTY, "failed to save main data");
                                }
                                
                                //add update item hanya boleh saat draft
                                if(!costing.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                                    jspCostingItem.addError(jspCostingItem.JSP_QTY, "Error, document have been locked for update");
                                }

				if(jspCostingItem.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(costingItem.getOID()==0){
					try{
						long oid = DbCostingItem.insertExc(this.costingItem);
                                               
                                               // DbStock.delete(DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID] + "=" + oid);
                                               // DbStock.insertCostingGoods(rec, costingItem);
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
						long oid = pstCostingItem.updateExc(this.costingItem);
                                                
                                                Costing rec = new Costing();
                                                try{
                                                    rec= DbCosting.fetchExc(oidCosting);
                                                }catch(Exception ex){

                                                }
                                               // DbStock.delete(DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID] + "=" + oid);
                                               // DbStock.insertCostingGoods(rec, costingItem);
                                                
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;
                        
                        case JSPCommand.LOAD :
                                
                                if(oidCostingItem != 0){
                                    try{
                                            costingItem = DbCostingItem.fetchExc(oidCostingItem);
                                    }catch(Exception exc){
                                    }
				}
                                
				jspCostingItem.requestEntityObject(costingItem);
                                
                                break;
                                
			case JSPCommand.EDIT :
				if (oidCostingItem != 0) {
					try {
						costingItem = DbCostingItem.fetchExc(oidCostingItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCostingItem != 0) {
					try {
						costingItem = DbCostingItem.fetchExc(oidCostingItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
                        

			case JSPCommand.DELETE :
				if (oidCostingItem != 0){
					try{
						long oid = DbCostingItem.deleteExc(oidCostingItem);
                                                DbStock.delete(DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID] + "=" + oid);
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
