/* 
 * Ctrl Name  		:  CtrlBanknonpoPaymentDetail.java 
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
import com.project.*;
import com.project.payroll.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class CmdBanknonpoPaymentDetail extends Control implements I_Language 
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
	private BanknonpoPaymentDetail banknonpoPaymentDetail;
	private DbBanknonpoPaymentDetail dbBanknonpoPaymentDetail;
	private JspBanknonpoPaymentDetail jspBanknonpoPaymentDetail;
	int language = LANGUAGE_DEFAULT;

	public CmdBanknonpoPaymentDetail(HttpServletRequest request){
		msgString = "";
		banknonpoPaymentDetail = new BanknonpoPaymentDetail();
		try{
			dbBanknonpoPaymentDetail = new DbBanknonpoPaymentDetail(0);
		}catch(Exception e){;}
		jspBanknonpoPaymentDetail = new JspBanknonpoPaymentDetail(request, banknonpoPaymentDetail);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				this.jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_BANKNONPO_PAYMENT_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public BanknonpoPaymentDetail getBanknonpoPaymentDetail() { return banknonpoPaymentDetail; } 

	public JspBanknonpoPaymentDetail getForm() { return jspBanknonpoPaymentDetail; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidBanknonpoPaymentDetail){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;
                                
                                
                        case JSPCommand.RECONFIRM :
                                if(oidBanknonpoPaymentDetail != 0){
					try{
						banknonpoPaymentDetail = DbBanknonpoPaymentDetail.fetchExc(oidBanknonpoPaymentDetail);
					}catch(Exception exc){
					}
				}
                                jspBanknonpoPaymentDetail.requestEntityObject(banknonpoPaymentDetail);
                                break;
			case JSPCommand.SEARCH :
				if(oidBanknonpoPaymentDetail != 0){
					try{
						banknonpoPaymentDetail = DbBanknonpoPaymentDetail.fetchExc(oidBanknonpoPaymentDetail);
					}catch(Exception exc){
					}
				}

				jspBanknonpoPaymentDetail.requestEntityObject(banknonpoPaymentDetail);

				if(jspBanknonpoPaymentDetail.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(banknonpoPaymentDetail.getOID()==0){
					try{
						long oid = dbBanknonpoPaymentDetail.insertExc(this.banknonpoPaymentDetail);
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
						long oid = dbBanknonpoPaymentDetail.updateExc(this.banknonpoPaymentDetail);
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
                            
                            jspBanknonpoPaymentDetail.requestEntityObject(banknonpoPaymentDetail);
                            
                            
                            Company sysCompany = DbCompany.getCompany();
                            //total corporate
                            /*if(sysCompany.getDepartmentLevel()==-1){
                                banknonpoPaymentDetail.setDepartmentId(0);
                            }
                            else{
                                if(banknonpoPaymentDetail.getDepartmentId()!=0){
                                    Department d = new Department();
                                    try{
                                        d = DbDepartment.fetchExc(banknonpoPaymentDetail.getDepartmentId());
                                        if(d.getLevel()!=sysCompany.getDepartmentLevel()){
                                            jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                        }
                                    }
                                    catch(Exception e){
                                    }
                                }                                    
                                else{
                                    jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID, DbDepartment.strLevel[sysCompany.getDepartmentLevel()]+" level required");
                                }
                            }*/
                            
                            /*if(banknonpoPaymentDetail.getDepartmentId()!=0){
                                Department d = new Department();
                                try{
                                    d = DbDepartment.fetchExc(banknonpoPaymentDetail.getDepartmentId());
                                    if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
                                        jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID, "Postable department required");
                                    }
                                }
                                catch(Exception e){
                                }
                            }else{
                                jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID, "Postable department required");
                            }
                             */
                            
                            System.out.println("banknonpoPaymentDetail.getType() = "+banknonpoPaymentDetail.getType());
                            Coa coa = new Coa();
                            try{
                                if (banknonpoPaymentDetail.getType()==0)
                                {
                                    coa = DbCoa.fetchExc(banknonpoPaymentDetail.getCoaId());
                                } else
                                {
                                    coa = DbCoa.fetchExc(banknonpoPaymentDetail.getCoaIdTemp());
                                }
                            }
                            catch(Exception e){
                                System.out.println(e);
                            }
                            
                            //jika tidak postable tidak boleh
                            if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                jspBanknonpoPaymentDetail.addError(jspBanknonpoPaymentDetail.JSP_COA_ID, "postable account type required");
                            }
                            
                            if(jspBanknonpoPaymentDetail.errorSize()>0) { 
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE ;
                            }
                            
                            break;        

			case JSPCommand.EDIT :
				if (oidBanknonpoPaymentDetail != 0) {
					try {
						banknonpoPaymentDetail = DbBanknonpoPaymentDetail.fetchExc(oidBanknonpoPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidBanknonpoPaymentDetail != 0) {
					try {
						banknonpoPaymentDetail = DbBanknonpoPaymentDetail.fetchExc(oidBanknonpoPaymentDetail);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidBanknonpoPaymentDetail != 0){
					try{
						long oid = DbBanknonpoPaymentDetail.deleteExc(oidBanknonpoPaymentDetail);
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
