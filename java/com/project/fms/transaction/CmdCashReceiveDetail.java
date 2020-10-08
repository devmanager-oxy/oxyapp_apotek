
package com.project.fms.transaction;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.lang.*;
import com.project.fms.master.*;
import com.project.payroll.*;

public class CmdCashReceiveDetail extends Control implements I_Language 
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
	private CashReceiveDetail cashReceiveDetail;
	private DbCashReceiveDetail pstCashReceiveDetail;
	private JspCashReceiveDetail jspCashReceiveDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdCashReceiveDetail(HttpServletRequest request){
		msgString = "";
		cashReceiveDetail = new CashReceiveDetail();
		try{
			pstCashReceiveDetail = new DbCashReceiveDetail(0);
		}catch(Exception e){;}
		jspCashReceiveDetail = new JspCashReceiveDetail(request, cashReceiveDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCashReceiveDetail.addError(jspCashReceiveDetail.JSP_FIELD_cash_receive_detail_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public CashReceiveDetail getCashReceiveDetail() { return cashReceiveDetail; } 

	public JspCashReceiveDetail getForm() { return jspCashReceiveDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCashReceiveDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

                        //diganti agar tidak ngesave        
			case JSPCommand.SEARCH :
				if(oidCashReceiveDetail != 0){
					try{
						cashReceiveDetail = DbCashReceiveDetail.fetchExc(oidCashReceiveDetail);
					}catch(Exception exc){
					}
				}

				jspCashReceiveDetail.requestEntityObject(cashReceiveDetail);
				
				
				

				if(jspCashReceiveDetail.errorSize()>0) { 
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
	            //jika bymhd baru, ambil bymhd id dari cash receive
	            //jika payment, ambil bymhd dari detail
	            CashReceive cashReceive = new CashReceive();
	            try{
	                cashReceive = DbCashReceive.fetchExc(cashReceiveDetail.getCashReceiveId());
	            }
	            catch(Exception e){
	            }
	            
	            if(cashReceive.getType()==DbCashReceive.TYPE_BYMHD_NEW){
	                cashReceiveDetail.setBymhdCoaId(cashReceive.getCoaId());
	            }
	            else{
	                cashReceiveDetail.setBymhdCoaId(cashReceiveDetail.getCoaId());
	                cashReceiveDetail.setInOut(-1);
                                }

				if(cashReceiveDetail.getOID()==0){
					try{
						long oid = pstCashReceiveDetail.insertExc(this.cashReceiveDetail);
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
						long oid = pstCashReceiveDetail.updateExc(this.cashReceiveDetail);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidCashReceiveDetail != 0) {
					try {
						cashReceiveDetail = DbCashReceiveDetail.fetchExc(oidCashReceiveDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

       		case JSPCommand.SUBMIT :
                            
                            jspCashReceiveDetail.requestEntityObject(cashReceiveDetail);
                            
                                                       
                            Coa coa = new Coa();
                            try{
                                coa = DbCoa.fetchExc(cashReceiveDetail.getCoaId());
                            }catch(Exception e){}
                            
                            if(cashReceiveDetail.getAmount()==0 && cashReceiveDetail.getCreditAmount()==0){
                            	jspCashReceiveDetail.addError(jspCashReceiveDetail.JSP_FOREIGN_AMOUNT, "debet or credit amount required");
                            }
                            
                            //jika tidak postable tidak boleh
                            if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                jspCashReceiveDetail.addError(jspCashReceiveDetail.JSP_COA_ID, "postable account type required");
                            }
                            
                            if(cashReceiveDetail.getDepartmentId()!=0){
								Department dept = new Department();
								try{
									dept = DbDepartment.fetchExc(cashReceiveDetail.getDepartmentId());
									if(!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
			                            jspCashReceiveDetail.addError(jspCashReceiveDetail.JSP_DEPARTMENT_ID, "postable department type required");
			                        }
								}
								catch(Exception ex){
								
								}
								
							}
							else{
								//Coa coa = new Coa();
								try{
									
									//coa = DbCoa.fetchExc(cashReceiveDetail.getCoaId());
									
									if(coa.getAccountGroup()==I_Project.ACC_GROUP_REVENUE ||
									   coa.getAccountGroup()==I_Project.ACC_GROUP_COST_OF_SALES ||
									   coa.getAccountGroup()==I_Project.ACC_GROUP_OTHER_REVENUE ||
									   coa.getAccountGroup()==I_Project.ACC_GROUP_OTHER_EXPENSE ||			
									   coa.getAccountGroup()==I_Project.ACC_GROUP_EXPENSE){
									   		
									   jspCashReceiveDetail.addError(jspCashReceiveDetail.JSP_DEPARTMENT_ID, "entry required");	
									   		
									}
								}
								catch(Exception ex){
								
								}
							}
                            
                            if(jspCashReceiveDetail.errorSize()>0) { 
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE ;
                            }
                            
                            break;
                            
			case JSPCommand.ASK :
				if (oidCashReceiveDetail != 0) {
					try {
						cashReceiveDetail = DbCashReceiveDetail.fetchExc(oidCashReceiveDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCashReceiveDetail != 0){
					try{
						long oid = DbCashReceiveDetail.deleteExc(oidCashReceiveDetail);
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
