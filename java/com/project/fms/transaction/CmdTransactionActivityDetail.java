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
import com.project.fms.activity.*;

public class CmdTransactionActivityDetail extends Control implements I_Language 
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
	private TransactionActivityDetail transactionActivityDetail;
	private DbTransactionActivityDetail pstTransactionActivityDetail;
	private JspTransactionActivityDetail jspTransactionActivityDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdTransactionActivityDetail(HttpServletRequest request){
		msgString = "";
		transactionActivityDetail = new TransactionActivityDetail();
		try{
			pstTransactionActivityDetail = new DbTransactionActivityDetail(0);
		}catch(Exception e){;}
		jspTransactionActivityDetail = new JspTransactionActivityDetail(request, transactionActivityDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_FIELD_transaction_activity_detail_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public TransactionActivityDetail getTransactionActivityDetail() { return transactionActivityDetail; } 

	public JspTransactionActivityDetail getForm() { return jspTransactionActivityDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidTransactionActivityDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.PRINT :
				if(oidTransactionActivityDetail != 0){
					try{
						transactionActivityDetail = DbTransactionActivityDetail.fetchExc(oidTransactionActivityDetail);
					}catch(Exception exc){
					}
				}

				jspTransactionActivityDetail.requestEntityObject(transactionActivityDetail);

				if(jspTransactionActivityDetail.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(transactionActivityDetail.getOID()==0){
					try{
						long oid = pstTransactionActivityDetail.insertExc(this.transactionActivityDetail);
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
						long oid = pstTransactionActivityDetail.updateExc(this.transactionActivityDetail);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

                        case JSPCommand.SUBMIT :
                            
                            System.out.println("\nin submit\n");
                            
                            jspTransactionActivityDetail.requestEntityObject(transactionActivityDetail);
                            
                            if(transactionActivityDetail.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_FA || 
                                transactionActivityDetail.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_LOG
                            ){
                                transactionActivityDetail.setModuleId(0);
                                transactionActivityDetail.setIsDirect(0);
                                transactionActivityDetail.setCoaId(0);                                                                
                            }
                            else{
                                
                                if(transactionActivityDetail.getModuleId()==0){
                                    jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_MODULE_ID, "Data required");
                                }
                                
                                Module module = new Module();
                                try{
                                    module = DbModule.fetchExc(transactionActivityDetail.getModuleId());
                                }
                                catch(Exception e){

                                }
                                
                                if(transactionActivityDetail.getCoaId()==0){
                                    jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_COA_ID, "Data required");
                                }
                            
                                if(transactionActivityDetail.getIsDirect()==1){
                                    //jika tidak postable tidak boleh
                                    if(!module.getLevel().equals(I_Project.ACTIVITY_CODE_A) && 
                                        !module.getLevel().equals(I_Project.ACTIVITY_CODE_SA) &&
                                        !module.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)
                                    ){
                                        jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_MODULE_ID, "(A)Activity or (SA)Sub Activity or (SSA)Sub Sub Activity level required");
                                    }
                                    else{
                                        if(module.getLevel().equals(I_Project.ACTIVITY_CODE_A)){
                                            if(DbModule.getCount(DbModule.colNames[DbModule.COL_PARENT_ID]+"="+module.getOID())>0){
                                                jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_MODULE_ID, "(SA)Sub Activity level required");
                                            }
                                        }
                                        else if(module.getLevel().equals(I_Project.ACTIVITY_CODE_SA)){
                                            if(DbModule.getCount(DbModule.colNames[DbModule.COL_PARENT_ID]+"="+module.getOID())>0){
                                                jspTransactionActivityDetail.addError(jspTransactionActivityDetail.JSP_MODULE_ID, "(SSA)Sub Sub Activity level required");
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            if(jspTransactionActivityDetail.errorSize()>0) { 
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE ;
                            }
                            
                            break;
                                
			
                                
			case JSPCommand.EDIT :
				if (oidTransactionActivityDetail != 0) {
					try {
						transactionActivityDetail = DbTransactionActivityDetail.fetchExc(oidTransactionActivityDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidTransactionActivityDetail != 0) {
					try {
						transactionActivityDetail = DbTransactionActivityDetail.fetchExc(oidTransactionActivityDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidTransactionActivityDetail != 0){
					try{
						long oid = DbTransactionActivityDetail.deleteExc(oidTransactionActivityDetail);
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
