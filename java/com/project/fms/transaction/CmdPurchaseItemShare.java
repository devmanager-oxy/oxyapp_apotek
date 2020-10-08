/* 
 * Ctrl Name  		:  CtrlPurchaseItemShare.java 
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

public class CmdPurchaseItemShare extends Control implements I_Language 
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
	private PurchaseItemShare purchaseItemShare;
	private DbPurchaseItemShare dbPurchaseItemShare;
	private JspPurchaseItemShare jspPurchaseItemShare;
	int language = LANGUAGE_DEFAULT;

	public CmdPurchaseItemShare(HttpServletRequest request){
		msgString = "";
		purchaseItemShare = new PurchaseItemShare();
		try{
			dbPurchaseItemShare = new DbPurchaseItemShare(0);
		}catch(Exception e){;}
		jspPurchaseItemShare = new JspPurchaseItemShare(request, purchaseItemShare);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_PURCHASE_ITEM_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public PurchaseItemShare getPurchaseItemShare() { return purchaseItemShare; } 

	public JspPurchaseItemShare getForm() { return jspPurchaseItemShare; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPurchaseItemShare, long oidPurchase){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
                            
                                Company sysCompany = DbCompany.getCompany();
                                
				if(oidPurchaseItemShare != 0){
					try{
						purchaseItemShare = DbPurchaseItemShare.fetchExc(oidPurchaseItemShare);
					}catch(Exception exc){
					}
				}
                                
				jspPurchaseItemShare.requestEntityObject(purchaseItemShare);
                                
                                //total corporate
                                /*if(sysCompany.getDepartmentLevel()==-1){
                                    purchaseItemShare.setDepartmentId(0);
                                }
                                else{
                                    if(purchaseItemShare.getDepartmentId()!=0){
                                        Department d = new Department();
                                        try{
                                            d = DbDepartment.fetchExc(purchaseItemShare.getDepartmentId());
                                            if(d.getLevel()!=sysCompany.getDepartmentLevel()){
                                                jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                            }
                                        }
                                        catch(Exception e){
                                        }
                                    }                                    
                                    else{
                                        jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                    }
                                }
                                 */
                                
                                /*if(purchaseItemShare.getDepartmentId()!=0){
                                    Department d = new Department();
                                    try{
                                        d = DbDepartment.fetchExc(purchaseItemShare.getDepartmentId());
                                        if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
                                            jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_DEPARTMENT_ID, "Postable department required");
                                        }
                                    }
                                    catch(Exception e){
                                    }
                                }else{
                                    jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_DEPARTMENT_ID, "Postable department required");
                                }  
                                                               

                                if(purchaseItemShare.getItemType().equals(I_Project.ACC_LINK_GROUP_NON_INVENTORY)){                                    
                                    purchaseItemShare.setCoaId(purchaseItemShare.getCoaId2());
                                    if(purchaseItemShare.getCoaId()==0){
                                        jspPurchaseItemShare.addError(jspPurchaseItemShare.JSP_COA_ID, "entry required");
                                    }                                
                                }
                                 */
                                
                                if(oidPurchase==0){
                                        msgString = "Purchase order id is null";
					return RSLT_FORM_INCOMPLETE ;
                                }
                                
                                purchaseItemShare.setPurchaseId(oidPurchase);

				if(jspPurchaseItemShare.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(purchaseItemShare.getOID()==0){
					try{
						long oid = dbPurchaseItemShare.insertExc(this.purchaseItemShare);
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
						long oid = dbPurchaseItemShare.updateExc(this.purchaseItemShare);
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
				if (oidPurchaseItemShare != 0) {
					try {
						purchaseItemShare = DbPurchaseItemShare.fetchExc(oidPurchaseItemShare);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPurchaseItemShare != 0) {
					try {
						purchaseItemShare = DbPurchaseItemShare.fetchExc(oidPurchaseItemShare);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidPurchaseItemShare != 0){
					try{
						
                                            System.out.println("\n\nin delete oidPurchaseItemShare : "+oidPurchaseItemShare);
                                            
                                            long oid = DbPurchaseItemShare.deleteExc(oidPurchaseItemShare);
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
