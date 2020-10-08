
package com.project.general;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdCompany_2 extends Control implements I_Language 
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
	private Company company;
	private DbCompany pstCompany;
	private JspCompany_2 jspCompany;
	int language = LANGUAGE_DEFAULT;

	public CmdCompany_2(HttpServletRequest request){
		msgString = "";
		company = new Company();
		try{
			pstCompany = new DbCompany(0);
		}catch(Exception e){;}
		jspCompany = new JspCompany_2(request, company);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCompany.addError(jspCompany.JSP_FIELD_company_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public Company getCompany() { return company; } 

	public JspCompany_2 getForm() { return jspCompany; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidCompany){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidCompany != 0){
					try{
						company = DbCompany.fetchExc(oidCompany);
					}catch(Exception exc){
					}
				}

				jspCompany.requestEntityObject(company);

				if(jspCompany.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(company.getOID()==0){
					try{
						long oid = pstCompany.insertExc(this.company);
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
						long oid = pstCompany.updateExc(this.company);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
                                                return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
                                                return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}
				break;

                        case JSPCommand.SUBMIT :
                                jspCompany.requestEntityObject(company);
                                
				if(jspCompany.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                if(company.getBankDepositCode().equalsIgnoreCase(company.getBankPaymentNonpoCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getBankPaymentPoCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getCashReceiveCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getGeneralLedgerCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getPettycashPaymentCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getBankDepositCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getBankPaymentPoCode())
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getCashReceiveCode())
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getGeneralLedgerCode())
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getPettycashPaymentCode())
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getBankPaymentNonpoCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getBankPaymentPoCode().equalsIgnoreCase(company.getCashReceiveCode())
                                   ||  company.getBankPaymentPoCode().equalsIgnoreCase(company.getGeneralLedgerCode())
                                   ||  company.getBankPaymentPoCode().equalsIgnoreCase(company.getPettycashPaymentCode())
                                   ||  company.getBankPaymentPoCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getBankPaymentPoCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getCashReceiveCode().equalsIgnoreCase(company.getGeneralLedgerCode())
                                   ||  company.getCashReceiveCode().equalsIgnoreCase(company.getPettycashPaymentCode())
                                   ||  company.getCashReceiveCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getCashReceiveCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getGeneralLedgerCode().equalsIgnoreCase(company.getPettycashPaymentCode())
                                   ||  company.getGeneralLedgerCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getGeneralLedgerCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getPettycashPaymentCode().equalsIgnoreCase(company.getPettycashReplaceCode())
                                   ||  company.getPettycashPaymentCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                   ||  company.getPettycashReplaceCode().equalsIgnoreCase(company.getPurchaseOrderCode())
                                   
                                ){
                                        msgString = "Can not save registration, non unique document code";//JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
                                }
                                
                            break;
                            
			case JSPCommand.EDIT :
				if (oidCompany != 0) {
					try {
						company = DbCompany.fetchExc(oidCompany);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidCompany != 0) {
					try {
						company = DbCompany.fetchExc(oidCompany);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidCompany != 0){
					try{
						long oid = DbCompany.deleteExc(oidCompany);
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
