
package com.project.simprop.property;

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

public class CmdSewaTanahBenefitDetailProp extends Control implements I_Language 
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
	private SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp;
	private DbSewaTanahBenefitDetailProp pstSewaTanahBenefitDetailProp;
	private JspSewaTanahBenefitDetailProp jspSewaTanahBenefitDetailProp;
	int language = LANGUAGE_DEFAULT;

	public CmdSewaTanahBenefitDetailProp(HttpServletRequest request){
		msgString = "";
		sewaTanahBenefitDetailProp = new SewaTanahBenefitDetailProp();
		try{
			pstSewaTanahBenefitDetailProp = new DbSewaTanahBenefitDetailProp(0);
		}catch(Exception e){;}
		jspSewaTanahBenefitDetailProp = new JspSewaTanahBenefitDetailProp(request, sewaTanahBenefitDetailProp);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSewaTanahBenefitDetailProp.addError(jspSewaTanahBenefitDetailProp.JSP_sewa_tanah_benefit_detail_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public SewaTanahBenefitDetailProp getSewaTanahBenefitDetail() { return sewaTanahBenefitDetailProp; } 

	public JspSewaTanahBenefitDetailProp getForm() { return jspSewaTanahBenefitDetailProp; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSewaTanahBenefitDetailProp){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSewaTanahBenefitDetailProp != 0){
					try{
						sewaTanahBenefitDetailProp = DbSewaTanahBenefitDetailProp.fetchExc(oidSewaTanahBenefitDetailProp);
					}catch(Exception exc){
					}
				}

				jspSewaTanahBenefitDetailProp.requestEntityObject(sewaTanahBenefitDetailProp);

				if(jspSewaTanahBenefitDetailProp.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(sewaTanahBenefitDetailProp.getOID()==0){
					try{
						long oid = pstSewaTanahBenefitDetailProp.insertExc(this.sewaTanahBenefitDetailProp);
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
						long oid = pstSewaTanahBenefitDetailProp.updateExc(this.sewaTanahBenefitDetailProp);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSewaTanahBenefitDetailProp != 0) {
					try {
						sewaTanahBenefitDetailProp = DbSewaTanahBenefitDetailProp.fetchExc(oidSewaTanahBenefitDetailProp);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSewaTanahBenefitDetailProp != 0) {
					try {
						sewaTanahBenefitDetailProp = DbSewaTanahBenefitDetailProp.fetchExc(oidSewaTanahBenefitDetailProp);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSewaTanahBenefitDetailProp != 0){
					try{
						long oid = DbSewaTanahBenefitDetailProp.deleteExc(oidSewaTanahBenefitDetailProp);
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
