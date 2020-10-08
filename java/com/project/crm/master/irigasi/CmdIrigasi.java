
package com.project.crm.master.irigasi;


import java.util.*; 
import java.sql.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;

public class CmdIrigasi extends Control 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private Irigasi irigasi;
	private DbIrigasi dbIrigasi;
	private JspIrigasi jspIrigasi;

	public CmdIrigasi(HttpServletRequest request){
		msgString = "";
		irigasi = new Irigasi();
		try{
			dbIrigasi = new DbIrigasi(0);
		}catch(Exception e){;}
		jspIrigasi = new JspIrigasi(request, irigasi);
	}

	private String getSystemMessage(int msgCode){
                switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspCoa.addError(jspCoa.JSP_CODE, resultText[1][RSLT_EST_CODE_EXIST] );
				return resultText[1][RSLT_EST_CODE_EXIST];
			default:
				return resultText[1][RSLT_UNKNOWN_ERROR]; 
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

	public Irigasi getIrigasi() { return irigasi; }

	public JspIrigasi getForm() { return jspIrigasi; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidIrigasi){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				System.out.println("Masuk pertama ");
				if(oidIrigasi != 0){
					try{
						
                    	irigasi = DbIrigasi.fetchExc(oidIrigasi);
                    	
					}catch(Exception exc){
						System.out.println("ERR >>> : "+exc.toString());
					}  
				}

				jspIrigasi.requestEntityObject(irigasi);
				boolean exist = DbIrigasi.checkPeriodExist(oidIrigasi, irigasi.getPeriodeId(), irigasi.getPriceType());
				if(exist){
					jspIrigasi.addError(JspIrigasi.JSP_PERIODE_ID,"Periode sudah ada");
					msgString = "Error, harga pada periode tersebut sudah disetup";
					return RSLT_FORM_INCOMPLETE ;
				}
				
				if(jspIrigasi.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(oidIrigasi==0){
					try{
						
						long oid = dbIrigasi.insertExc(this.irigasi);
						
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
						
						long oid = dbIrigasi.updateExc(this.irigasi);
						
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}

				}
				break;

			case JSPCommand.EDIT :
				System.out.println("oidIrigasi : "+oidIrigasi);
				if (oidIrigasi != 0) {
					try {
						irigasi = DbIrigasi.fetchExc(oidIrigasi);
						
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidIrigasi != 0) {
					try {
						irigasi = DbIrigasi.fetchExc(oidIrigasi);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
                                
                        case JSPCommand.SUBMIT :
                            jspIrigasi.requestEntityObject(irigasi);
                            break;

			case JSPCommand.DELETE :
				if (oidIrigasi != 0){
					try{
						long oid = DbIrigasi.deleteExc(oidIrigasi);
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
