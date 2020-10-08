/* 
 * Ctrl Name  		:  CtrlBankpoPaymentDetail.java 
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

public class CmdBankpoPaymentDetail extends Control implements I_Language 
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
	private BankpoPaymentDetail bankpoPaymentDetail;
	private DbBankpoPaymentDetail dbBankpoPaymentDetail;
	private JspBankpoPaymentDetail jspBankpoPaymentDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdBankpoPaymentDetail(HttpServletRequest request){
		msgString = "";
		bankpoPaymentDetail = new BankpoPaymentDetail();
		try{
			dbBankpoPaymentDetail = new DbBankpoPaymentDetail(0);
		}catch(Exception e){;}
		jspBankpoPaymentDetail = new JspBankpoPaymentDetail(request, bankpoPaymentDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspBankpoPaymentDetail.addError(jspBankpoPaymentDetail.JSP_BANKPO_PAYMENT_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public BankpoPaymentDetail getBankpoPaymentDetail() { return bankpoPaymentDetail; } 

	public JspBankpoPaymentDetail getForm() { return jspBankpoPaymentDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidBankpoPaymentDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidBankpoPaymentDetail != 0){
					try{
						bankpoPaymentDetail = DbBankpoPaymentDetail.fetchExc(oidBankpoPaymentDetail);
					}catch(Exception exc){
					}
				}

				jspBankpoPaymentDetail.requestEntityObject(bankpoPaymentDetail);

				if(jspBankpoPaymentDetail.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(bankpoPaymentDetail.getOID()==0){
					try{
						long oid = dbBankpoPaymentDetail.insertExc(this.bankpoPaymentDetail);
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
						long oid = dbBankpoPaymentDetail.updateExc(this.bankpoPaymentDetail);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidBankpoPaymentDetail != 0) {
					try {
						bankpoPaymentDetail = DbBankpoPaymentDetail.fetchExc(oidBankpoPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidBankpoPaymentDetail != 0) {
					try {
						bankpoPaymentDetail = DbBankpoPaymentDetail.fetchExc(oidBankpoPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidBankpoPaymentDetail != 0){
					try{
						long oid = DbBankpoPaymentDetail.deleteExc(oidBankpoPaymentDetail);
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
