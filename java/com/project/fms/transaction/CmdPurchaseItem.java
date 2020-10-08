/* 
 * Ctrl Name  		:  CtrlPurchaseItem.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction;

/* java package */ 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.system.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.general.Company;
import com.project.general.DbCompany;

public class CmdPurchaseItem extends Control implements I_Language 
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
	private PurchaseItem purchaseItem;
	private DbPurchaseItem dbPurchaseItem;
	private JspPurchaseItem jspPurchaseItem;
	int language = LANGUAGE_DEFAULT;

	public CmdPurchaseItem(HttpServletRequest request){
		msgString = "";
		purchaseItem = new PurchaseItem();
		try{
			dbPurchaseItem = new DbPurchaseItem(0);
		}catch(Exception e){;}
		jspPurchaseItem = new JspPurchaseItem(request, purchaseItem);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspPurchaseItem.addError(jspPurchaseItem.JSP_PURCHASE_ITEM_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public PurchaseItem getPurchaseItem() { return purchaseItem; } 

	public JspPurchaseItem getForm() { return jspPurchaseItem; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPurchaseItem, long oidPurchase){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
                            
                                Company sysCompany = DbCompany.getCompany();
                                
				if(oidPurchaseItem != 0){
					try{
						purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
					}catch(Exception exc){
					}
				}
                                
				jspPurchaseItem.requestEntityObject(purchaseItem);
                                
                                //total corporate
                                /*if(sysCompany.getDepartmentLevel()==-1){
                                    purchaseItem.setDepartmentId(0);
                                }
                                else{
                                    if(purchaseItem.getDepartmentId()!=0){
                                        Department d = new Department();
                                        try{
                                            d = DbDepartment.fetchExc(purchaseItem.getDepartmentId());
                                            if(d.getLevel()!=sysCompany.getDepartmentLevel()){
                                                jspPurchaseItem.addError(jspPurchaseItem.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                            }
                                        }
                                        catch(Exception e){
                                        }
                                    }                                    
                                    else{
                                        jspPurchaseItem.addError(jspPurchaseItem.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                    }
                                }
                                 */
                                
                                /*if(purchaseItem.getDepartmentId()!=0){
                                    Department d = new Department();
                                    try{
                                        d = DbDepartment.fetchExc(purchaseItem.getDepartmentId());
                                        if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
                                            jspPurchaseItem.addError(jspPurchaseItem.JSP_DEPARTMENT_ID, "Postable department required");
                                        }
                                    }
                                    catch(Exception e){
                                    }
                                }else{
                                    jspPurchaseItem.addError(jspPurchaseItem.JSP_DEPARTMENT_ID, "Postable department required");
                                }  
                                                               

                                if(purchaseItem.getItemType().equals(I_Project.ACC_LINK_GROUP_NON_INVENTORY)){                                    
                                    purchaseItem.setCoaId(purchaseItem.getCoaId2());
                                    if(purchaseItem.getCoaId()==0){
                                        jspPurchaseItem.addError(jspPurchaseItem.JSP_COA_ID, "entry required");
                                    }                                
                                }
                                 */
                                
                                if(oidPurchase==0){
                                        msgString = "Purchase order id is null";
					return RSLT_FORM_INCOMPLETE ;
                                }
                                
                                purchaseItem.setPurchaseId(oidPurchase);

				if(jspPurchaseItem.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(purchaseItem.getOID()==0){
					try{
						long oid = dbPurchaseItem.insertExc(this.purchaseItem);
                                                msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
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
						long oid = dbPurchaseItem.updateExc(this.purchaseItem);
                                                msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidPurchaseItem != 0) {
					try {
						purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPurchaseItem != 0) {
					try {
						purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidPurchaseItem != 0){
					try{
						
                                            System.out.println("\n\nin delete oidPurchaseItem : "+oidPurchaseItem);
                                            
                                            long oid = DbPurchaseItem.deleteExc(oidPurchaseItem);
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
