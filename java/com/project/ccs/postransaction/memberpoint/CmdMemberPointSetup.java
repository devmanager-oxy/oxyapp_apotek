package com.project.ccs.postransaction.memberpoint;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.ItemGroup;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import java.util.Date;

public class CmdMemberPointSetup extends Control implements I_Language 
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
	private MemberPointSetup memberPointSetup;
	private DbMemberPointSetup pstMemberPointSetup;
	private JspMemberPointSetup jspMemberPointSetup;
	int language = LANGUAGE_DEFAULT;

	public CmdMemberPointSetup(HttpServletRequest request){
		msgString = "";
		memberPointSetup = new MemberPointSetup();
		try{
			pstMemberPointSetup = new DbMemberPointSetup(0);
		}catch(Exception e){;}
		jspMemberPointSetup = new JspMemberPointSetup(request, memberPointSetup);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspMemberPointSetup.addError(jspMemberPointSetup.JSP_FIELD_member_point_setup_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public MemberPointSetup getMemberPointSetup() { return memberPointSetup; } 

	public JspMemberPointSetup getForm() { return jspMemberPointSetup; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidMemberPointSetup, long userId){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidMemberPointSetup != 0){
					try{
						memberPointSetup = DbMemberPointSetup.fetchExc(oidMemberPointSetup);
					}catch(Exception exc){
					}
				}

				jspMemberPointSetup.requestEntityObject(memberPointSetup);

				if(jspMemberPointSetup.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                if(memberPointSetup.getItemGroupId()!=0){
                                    ItemGroup ig = new ItemGroup();
                                    try{
                                            ig = DbItemGroup.fetchExc(memberPointSetup.getItemGroupId());
                                            memberPointSetup.setGroupType(ig.getType());
                                    }
                                    catch(Exception e){
                                    }
                                }
                                
                                memberPointSetup.setUserId(userId);

				if(memberPointSetup.getOID()==0){
					try{
                                                memberPointSetup.setDate(new Date());
                                                memberPointSetup.setLastUpdateDate(new Date());
						long oid = pstMemberPointSetup.insertExc(this.memberPointSetup);
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
						memberPointSetup.setLastUpdateDate(new Date());
                                                long oid = pstMemberPointSetup.updateExc(this.memberPointSetup);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidMemberPointSetup != 0) {
					try {
						memberPointSetup = DbMemberPointSetup.fetchExc(oidMemberPointSetup);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidMemberPointSetup != 0) {
					try {
						memberPointSetup = DbMemberPointSetup.fetchExc(oidMemberPointSetup);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidMemberPointSetup != 0){
					try{
						long oid = DbMemberPointSetup.deleteExc(oidMemberPointSetup);
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
