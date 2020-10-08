package com.project.crm.sewa;

import com.project.crm.transaction.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdSewaTanahBenefitDetail extends Control implements I_Language 
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
	private SewaTanahBenefitDetail sewaTanahBenefitDetail;
	private DbSewaTanahBenefitDetail pstSewaTanahBenefitDetail;
	private JspSewaTanahBenefitDetail jspSewaTanahBenefitDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdSewaTanahBenefitDetail(HttpServletRequest request){
		msgString = "";
		sewaTanahBenefitDetail = new SewaTanahBenefitDetail();
		try{
			pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetail(0);
		}catch(Exception e){;}
		jspSewaTanahBenefitDetail = new JspSewaTanahBenefitDetail(request, sewaTanahBenefitDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSewaTanahBenefitDetail.addError(jspSewaTanahBenefitDetail.JSP_sewa_tanah_benefit_detail_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public SewaTanahBenefitDetail getSewaTanahBenefitDetail() { return sewaTanahBenefitDetail; } 

	public JspSewaTanahBenefitDetail getForm() { return jspSewaTanahBenefitDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSewaTanahBenefitDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSewaTanahBenefitDetail != 0){
					try{
						sewaTanahBenefitDetail = DbSewaTanahBenefitDetail.fetchExc(oidSewaTanahBenefitDetail);
					}catch(Exception exc){
					}
				}

				jspSewaTanahBenefitDetail.requestEntityObject(sewaTanahBenefitDetail);

				if(jspSewaTanahBenefitDetail.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(sewaTanahBenefitDetail.getOID()==0){
					try{
						long oid = pstSewaTanahBenefitDetail.insertExc(this.sewaTanahBenefitDetail);
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
						long oid = pstSewaTanahBenefitDetail.updateExc(this.sewaTanahBenefitDetail);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSewaTanahBenefitDetail != 0) {
					try {
						sewaTanahBenefitDetail = DbSewaTanahBenefitDetail.fetchExc(oidSewaTanahBenefitDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSewaTanahBenefitDetail != 0) {
					try {
						sewaTanahBenefitDetail = DbSewaTanahBenefitDetail.fetchExc(oidSewaTanahBenefitDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSewaTanahBenefitDetail != 0){
					try{
						long oid = DbSewaTanahBenefitDetail.deleteExc(oidSewaTanahBenefitDetail);
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
