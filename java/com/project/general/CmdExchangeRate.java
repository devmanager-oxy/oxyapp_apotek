

package com.project.general;

/* java package */ 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.general.*;

public class CmdExchangeRate extends Control 
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
	private ExchangeRate exchangeRate;
	private DbExchangeRate pstExchangeRate;
	private JspExchangeRate frmExchangeRate;
	int language = 0;

	public CmdExchangeRate(HttpServletRequest request){
		msgString = "";
		exchangeRate = new ExchangeRate();
		try{
			pstExchangeRate = new DbExchangeRate(0);
		}catch(Exception e){;}
		frmExchangeRate = new JspExchangeRate(request, exchangeRate);
	}

	private String getSystemMessage(int msgCode){
		return "";
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	

	public ExchangeRate getExchangeRate() { return exchangeRate; } 

	public JspExchangeRate getForm() { return frmExchangeRate; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidExchangeRate){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidExchangeRate != 0){
					try{
						exchangeRate = DbExchangeRate.fetchExc(oidExchangeRate);
					}catch(Exception exc){
					}
				}

				frmExchangeRate.requestEntityObject(exchangeRate);

				if(frmExchangeRate.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(exchangeRate.getOID()==0){
					try{
						long oid = pstExchangeRate.insertExc(this.exchangeRate);
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
						long oid = pstExchangeRate.updateExc(this.exchangeRate);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidExchangeRate != 0) {
					try {
						exchangeRate = DbExchangeRate.fetchExc(oidExchangeRate);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidExchangeRate != 0) {
					try {
						exchangeRate = DbExchangeRate.fetchExc(oidExchangeRate);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidExchangeRate != 0){
					try{
						long oid = DbExchangeRate.deleteExc(oidExchangeRate);
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
