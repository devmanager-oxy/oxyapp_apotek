

package com.project.fms.asset;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.lang.I_Language;

public class CmdAssetDataDepresiasi extends Control implements I_Language 
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
	private AssetDataDepresiasi assetDataDepresiasi;
	private DbAssetDataDepresiasi pstAssetDataDepresiasi;
	private JspAssetDataDepresiasi jspAssetDataDepresiasi;
	int language = LANGUAGE_DEFAULT;

	public CmdAssetDataDepresiasi(HttpServletRequest request){
		msgString = "";
		assetDataDepresiasi = new AssetDataDepresiasi();
		try{
			pstAssetDataDepresiasi = new DbAssetDataDepresiasi(0);
		}catch(Exception e){;}
		jspAssetDataDepresiasi = new JspAssetDataDepresiasi(request, assetDataDepresiasi);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspAssetDataDepresiasi.addError(jspAssetDataDepresiasi.JSP_asset_data_depresiasi_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public AssetDataDepresiasi getAssetDataDepresiasi() { return assetDataDepresiasi; } 

	public JspAssetDataDepresiasi getForm() { return jspAssetDataDepresiasi; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidAssetDataDepresiasi){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidAssetDataDepresiasi != 0){
					try{
						assetDataDepresiasi = DbAssetDataDepresiasi.fetchExc(oidAssetDataDepresiasi);
					}catch(Exception exc){
					}
				}

				jspAssetDataDepresiasi.requestEntityObject(assetDataDepresiasi);

				if(jspAssetDataDepresiasi.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(assetDataDepresiasi.getOID()==0){
					try{
						long oid = pstAssetDataDepresiasi.insertExc(this.assetDataDepresiasi);
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
						long oid = pstAssetDataDepresiasi.updateExc(this.assetDataDepresiasi);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidAssetDataDepresiasi != 0) {
					try {
						assetDataDepresiasi = DbAssetDataDepresiasi.fetchExc(oidAssetDataDepresiasi);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidAssetDataDepresiasi != 0) {
					try {
						assetDataDepresiasi = DbAssetDataDepresiasi.fetchExc(oidAssetDataDepresiasi);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidAssetDataDepresiasi != 0){
					try{
						long oid = DbAssetDataDepresiasi.deleteExc(oidAssetDataDepresiasi);
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
