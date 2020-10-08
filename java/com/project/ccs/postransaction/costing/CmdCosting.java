
package com.project.ccs.postransaction.costing;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.system.DbSystemProperty;

public class CmdCosting extends Control implements I_Language 
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
	private Costing costing;
	private DbCosting pstCosting;
	private JspCosting jspCosting;
	int language = LANGUAGE_DEFAULT;

	public CmdCosting(HttpServletRequest request){
		msgString = "";
		costing = new Costing();
		try{
			pstCosting = new DbCosting(0);
		}catch(Exception e){;}
		jspCosting = new JspCosting(request, costing);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCosting.addError(jspCosting.JSP_FIELD_costing_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public Costing getCosting() { return costing; } 

	public JspCosting getForm() { return jspCosting; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	synchronized public int action(int cmd , long oidCosting){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;
                        
                        case JSPCommand.ACTIVATE :
                                if(oidCosting != 0){
					try{
						costing = DbCosting.fetchExc(oidCosting);
					}catch(Exception exc){
					}
				}
			break;             

			case JSPCommand.SAVE :
                                
                                String oldStatus = "";
                                
				if(oidCosting != 0){
					try{
						costing = DbCosting.fetchExc(oidCosting);
                                                oldStatus = costing.getStatus();                                                
					}catch(Exception exc){
					}
				}

				jspCosting.requestEntityObject(costing);
                                
                                //jika status tidak draft tidak boleh update
                                if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("") ){
                                    jspCosting.addError(jspCosting.JSP_APPROVAL_1, "Document have been locked for update - current status "+oldStatus);
                                }

				if(jspCosting.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(costing.getOID()==0){
					try{
                                            int ctr = DbCosting.getNextCounter();
                                            costing.setCounter(ctr);
                                            costing.setPrefixNumber(DbCosting.getNumberPrefix());
                                            costing.setNumber(DbCosting.getNextNumber(ctr));
                                            costing.setStatus(I_Project.DOC_STATUS_DRAFT);
                                            
                                            long oid = pstCosting.insertExc(this.costing);
                                            
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
                                                
						long oid = pstCosting.updateExc(this.costing);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;
                                
                        case JSPCommand.POST:

                                System.out.println("\n\nPOSTING command POST - synchronized --- \n");

                                long userId = 0;
                                long app1Id = 0;
                                long app2Id = 0;
                                long app3Id = 0;
                                
                                oldStatus = "";

                                if (oidCosting != 0) {
                                    try {
                                        costing = DbCosting.fetchExc(oidCosting);

                                        userId = costing.getUserId();
                                        app1Id = costing.getApproval1();
                                        app2Id = costing.getApproval2();
                                        app3Id = costing.getApproval3();
                                        
                                        oldStatus = costing.getStatus();

                                    } catch (Exception exc) {
                                    }
                                }

                                jspCosting.requestEntityObject(costing);
                                

                                System.out.println("\n\n status = "+costing.getStatus());

                                //approval check ----------------
                                if (costing.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                                    //approved status
                                    costing.setApproval1(0);
                                    //check status
                                    costing.setApproval2(0);
                                    //close status
                                    costing.setApproval3(0);
                                    
                                    //jika status tidak draft tidak boleh update
                                    if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT)){
                                        jspCosting.addError(jspCosting.JSP_APPROVAL_1, "Document have been locked for update - current status "+oldStatus);
                                    }
                                    
                                } else if (costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                                    //approved status
                                    costing.setEffectiveDate(new Date());
                                    costing.setApproval1(costing.getUserId());
                                    //costing.setApproval1Date(new Date());
                                    //draft status
                                    costing.setUserId(userId);
                                    //check status
                                    costing.setApproval2(0);
                                    //close status
                                    costing.setApproval3(0);
                                } else if (costing.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                                    //close statusc
                                    costing.setApproval2(costing.getUserId());
                                    //costing.setApproval2Date(new Date());
                                    //draft status
                                    costing.setUserId(userId);
                                    //close
                                    costing.setApproval3(0);
                                } else if (costing.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                                    //close status
                                    costing.setApproval3(costing.getUserId());
                                    //costing.setApproval3Date(new Date());
                                    //draft status
                                    costing.setUserId(userId);
                                }
                                //--------------------------------

                                if (jspCosting.errorSize() > 0) {
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE;
                                }

                                if (costing.getOID() == 0) {
                                    try {

                                        int ctr = DbCosting.getNextCounter();
                                        costing.setCounter(ctr);
                                        costing.setPrefixNumber(DbCosting.getNumberPrefix());
                                        costing.setNumber(DbCosting.getNextNumber(ctr));
                                        if(costing.getDate()==null){
                                            costing.setDate(new Date());                                         
                                        }

                                        long oid = pstCosting.insertExc(this.costing);

                                        System.out.println("\n--- insert oid : "+oid+", "+costing.getStatus());

                                        //proses penambahan stock
                                        if (oid!=0 && costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                                            //DbCostingItem.proceedStock(costing); 
                                             DbStock.updateStockCosting(costing);
                                        }

                                    } catch (CONException dbexc) {
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                        return getControlMsgId(excCode);
                                    } catch (Exception exc) {
                                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                                    }

                                } else {
                                    try {
                                        long oid = pstCosting.updateExc(this.costing);

                                        System.out.println("update oid : "+oid+", "+costing.getStatus());
                                        
                                        if(oid!=0 && costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                                                DbStock.delete(DbStock.colNames[DbStock.COL_COSTING_ID]+"="+ costing.getOID());
                                                DbCostingItem.proceedStock(costing);//tambah stock
                                        }

                                    } catch (CONException dbexc) {
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                    } catch (Exception exc) {
                                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                    }

                                }
                                break;

                        case JSPCommand.LOAD :
                                
                                if(oidCosting != 0){
					try{
						costing = DbCosting.fetchExc(oidCosting);                                                
					}catch(Exception exc){
					}
				}

				jspCosting.requestEntityObject(costing);        
                                
                                break;
                                
			case JSPCommand.EDIT :
				if (oidCosting != 0) {
					try {
						costing = DbCosting.fetchExc(oidCosting);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCosting != 0) {
					try {
						costing = DbCosting.fetchExc(oidCosting);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			

			case JSPCommand.SUBMIT:
                            if (oidCosting != 0){
                                try {
                                    costing = DbCosting.fetchExc(oidCosting);
                                } catch (CONException dbexc) {
                                    excCode = dbexc.getErrorCode();
                                    msgString = getSystemMessage(excCode);
                                } catch (Exception exc) {
                                    msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                }
                            }
                            break;


                    case JSPCommand.CONFIRM:
                        if (oidCosting != 0){

                           int rslt = DbCostingItem.deleteAllItem(oidCosting);     

                           try {

                                long oid = DbCosting.deleteExc(oidCosting);
                                if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                                    DbStock.delete(DbStock.colNames[DbStock.COL_COSTING_ID] + "=" + oidCosting);
                                }

                                if (rslt == 0) {
                                    msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                                    excCode = RSLT_OK;
                                } else {
                                    msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                                    excCode = RSLT_FORM_INCOMPLETE;
                                }
                                
                                DbStock.delete(DbStock.colNames[DbStock.COL_COSTING_ID] + "=" + oidCosting);
                                
                            } catch (CONException dbexc) {
                                excCode = dbexc.getErrorCode();
                                msgString = getSystemMessage(excCode);
                            } catch (Exception exc) {
                                msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                            }

                        }
                        break;
                
                    default:    
		}
		return rsCode;
	}
}
