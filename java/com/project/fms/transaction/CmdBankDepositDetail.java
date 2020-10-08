/* 
 * Ctrl Name  		:  CtrlBankDepositDetail.java 
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

public class CmdBankDepositDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private BankDepositDetail bankDepositDetail;
    private DbBankDepositDetail dbBankDepositDetail;
    private JspBankDepositDetail jspBankDepositDetail;
    int language = LANGUAGE_DEFAULT;

    public CmdBankDepositDetail(HttpServletRequest request) {
        msgString = "";
        bankDepositDetail = new BankDepositDetail();
        try {
            dbBankDepositDetail = new DbBankDepositDetail(0);
        } catch (Exception e) {
            ;
        }
        jspBankDepositDetail = new JspBankDepositDetail(request, bankDepositDetail);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspBankDepositDetail.addError(jspBankDepositDetail.JSP_BANK_DEPOSIT_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public BankDepositDetail getBankDepositDetail() {
        return bankDepositDetail;
    }

    public JspBankDepositDetail getForm() {
        return jspBankDepositDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBankDepositDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SEARCH:
                if (oidBankDepositDetail != 0) {
                    try {
                        bankDepositDetail = DbBankDepositDetail.fetchExc(oidBankDepositDetail);
                    } catch (Exception exc) {
                    }
                }

                jspBankDepositDetail.requestEntityObject(bankDepositDetail);

                if (jspBankDepositDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (bankDepositDetail.getOID() == 0) {
                    try {
                        long oid = dbBankDepositDetail.insertExc(this.bankDepositDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        long oid = dbBankDepositDetail.updateExc(this.bankDepositDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspBankDepositDetail.requestEntityObject(bankDepositDetail);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDepositDetail.getCoaId());
                } catch (Exception e) {}
                
                if(bankDepositDetail.getAmount()==0 && bankDepositDetail.getCreditAmount()==0){
                    jspBankDepositDetail.addError(jspBankDepositDetail.JSP_FOREIGN_AMOUNT, "debet or credit amount required");
                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDepositDetail.addError(jspBankDepositDetail.JSP_COA_ID, "postable account type required");
                }

                if (bankDepositDetail.getDepartmentId() != 0){
                    Department dept = new Department();
                    try {
                        dept = DbDepartment.fetchExc(bankDepositDetail.getDepartmentId());
                        if (!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            jspBankDepositDetail.addError(jspBankDepositDetail.JSP_DEPARTMENT_ID, "postable department type required");
                        }
                    } catch (Exception ex) {}

                } else {
                    //Coa coa = new Coa();
                    try {

                        //coa = DbCoa.fetchExc(bankDepositDetail.getCoaId());
                        if (coa.getAccountGroup() == I_Project.ACC_GROUP_REVENUE ||
                                coa.getAccountGroup() == I_Project.ACC_GROUP_COST_OF_SALES ||
                                coa.getAccountGroup() == I_Project.ACC_GROUP_OTHER_REVENUE ||
                                coa.getAccountGroup() == I_Project.ACC_GROUP_OTHER_EXPENSE ||
                                coa.getAccountGroup() == I_Project.ACC_GROUP_EXPENSE) {

                            jspBankDepositDetail.addError(jspBankDepositDetail.JSP_DEPARTMENT_ID, "entry required");

                        }
                    } catch (Exception ex) {}
                }

                if (jspBankDepositDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidBankDepositDetail != 0) {
                    try {
                        bankDepositDetail = DbBankDepositDetail.fetchExc(oidBankDepositDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidBankDepositDetail != 0) {
                    try {
                        bankDepositDetail = DbBankDepositDetail.fetchExc(oidBankDepositDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidBankDepositDetail != 0) {
                    try {
                        long oid = DbBankDepositDetail.deleteExc(oidBankDepositDetail);
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default:

        }
        return rsCode;
    }
}