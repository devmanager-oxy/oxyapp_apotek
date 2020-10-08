/* 
 * Ctrl Name  		:  CtrlPettycashPaymentDetail.java 
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
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class CmdPettycashPaymentDetail extends Control implements I_Language 
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
	private PettycashPaymentDetail pettycashPaymentDetail;
	private DbPettycashPaymentDetail dbPettycashPaymentDetail;
	private JspPettycashPaymentDetail jspPettycashPaymentDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdPettycashPaymentDetail(HttpServletRequest request){
		msgString = "";
		pettycashPaymentDetail = new PettycashPaymentDetail();
		try{
			dbPettycashPaymentDetail = new DbPettycashPaymentDetail(0);
		}catch(Exception e){;}
		jspPettycashPaymentDetail = new JspPettycashPaymentDetail(request, pettycashPaymentDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_PETTYCASH_PAYMENT_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public PettycashPaymentDetail getPettycashPaymentDetail() { return pettycashPaymentDetail; } 

	public JspPettycashPaymentDetail getForm() { return jspPettycashPaymentDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPettycashPaymentDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SEARCH :
				if(oidPettycashPaymentDetail != 0){
					try{
						pettycashPaymentDetail = DbPettycashPaymentDetail.fetchExc(oidPettycashPaymentDetail);
					}catch(Exception exc){
					}
				}

				jspPettycashPaymentDetail.requestEntityObject(pettycashPaymentDetail);

				if(jspPettycashPaymentDetail.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(pettycashPaymentDetail.getOID()==0){
					try{
						long oid = dbPettycashPaymentDetail.insertExc(this.pettycashPaymentDetail);
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
						long oid = dbPettycashPaymentDetail.updateExc(this.pettycashPaymentDetail);
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
                            
                            jspPettycashPaymentDetail.requestEntityObject(pettycashPaymentDetail);
                            
                            Company sysCompany = DbCompany.getCompany();
                            //total corporate
                            /*
                            if(sysCompany.getDepartmentLevel()==-1){
                                pettycashPaymentDetail.setDepartmentId(0);
                            }
                            else{
                                if(pettycashPaymentDetail.getDepartmentId()!=0){
                                    Department d = new Department();
                                    try{
                                        d = DbDepartment.fetchExc(pettycashPaymentDetail.getDepartmentId());
                                        if(d.getLevel()!=sysCompany.getDepartmentLevel()){
                                            jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                        }
                                    }
                                    catch(Exception e){
                                    }
                                }                                    
                                else{
                                    jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                }
                            }*/
                            
                            /*if(pettycashPaymentDetail.getDepartmentId()!=0){
                                Department d = new Department();
                                try{
                                    d = DbDepartment.fetchExc(pettycashPaymentDetail.getDepartmentId());
                                    if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
                                        jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID, "Postable department required");
                                    }
                                }
                                catch(Exception e){
                                }
                            }
                            else{
                                jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID, "Postable department required");
                            }
                             */

                            Coa coa = new Coa();
                            try{
                                coa = DbCoa.fetchExc(pettycashPaymentDetail.getCoaId());
                            }
                            catch(Exception e){
                                
                            }
                            
                            if(pettycashPaymentDetail.getAmount()==0 && pettycashPaymentDetail.getCreditAmount()==0){
                            	jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_AMOUNT, "debet or credit amount required");
                            }
                            
                            //jika tidak postable tidak boleh
                            if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                jspPettycashPaymentDetail.addError(jspPettycashPaymentDetail.JSP_COA_ID, "postable account type required");
                            }
                            
                            if(jspPettycashPaymentDetail.errorSize()>0) { 
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE ;
                            }
                            
                            break;
                                
			case JSPCommand.EDIT :
				if (oidPettycashPaymentDetail != 0) {
					try {
						pettycashPaymentDetail = DbPettycashPaymentDetail.fetchExc(oidPettycashPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPettycashPaymentDetail != 0) {
					try {
						pettycashPaymentDetail = DbPettycashPaymentDetail.fetchExc(oidPettycashPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidPettycashPaymentDetail != 0){
					try{
						long oid = DbPettycashPaymentDetail.deleteExc(oidPettycashPaymentDetail);
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
