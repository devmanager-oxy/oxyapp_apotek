package com.project.fms.activity;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.lang.*;

public class CmdModuleBudget extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private ModuleBudget moduleBudget;
    private DbModuleBudget pstModuleBudget;
    private JspModuleBudget jspModuleBudget;
    int language = LANGUAGE_DEFAULT;

    public CmdModuleBudget(HttpServletRequest request) {
        msgString = "";
        moduleBudget = new ModuleBudget();
        try {
            pstModuleBudget = new DbModuleBudget(0);
        } catch (Exception e) {
            ;
        }
        jspModuleBudget = new JspModuleBudget(request, moduleBudget);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspModuleBudget.addError(jspModuleBudget.JSP_module_budget_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public ModuleBudget getModuleBudget() {
        return moduleBudget;
    }

    public JspModuleBudget getForm() {
        return jspModuleBudget;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidModuleBudget) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:

                double oldBudget = 0;
                double amountUsed = 0;
                long coaId = 0;
                String description = "";
                long currId = 0;
                Date updateDate = new Date();
                long userUpdateId = 0;

                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                        oldBudget = moduleBudget.getAmount();
                        amountUsed = moduleBudget.getAmountUsed();
                        coaId = moduleBudget.getCoaId();
                        description = moduleBudget.getDescription();
                        currId = moduleBudget.getCurrencyId();
                        updateDate = moduleBudget.getUpdateDate();
                        userUpdateId = moduleBudget.getUserUpdateId();
                    } catch (Exception exc) {
                    }
                }

                jspModuleBudget.requestEntityObject(moduleBudget);

                if (jspModuleBudget.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (moduleBudget.getOID() == 0) {
                    try {
                        this.moduleBudget.setRefHistoryId(0);
                        this.moduleBudget.setUpdateDate(new Date());
                        this.moduleBudget.setStatus(DbModuleBudget.DOC_NOT_HISTORY);
                                
                        long oid = pstModuleBudget.insertExc(this.moduleBudget);
                        //update total budget
                        if (oid != 0) {
                            DbModule.updateBudgetRecursif(moduleBudget.getModuleId(), moduleBudget.getAmount());
                        }
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
                        ModuleBudget md = new ModuleBudget();                        
                        try{
                            md.setOID(0);
                            md.setAmount(oldBudget);
                            md.setAmountUsed(amountUsed);
                            md.setCoaId(coaId);
                            md.setRefHistoryId(moduleBudget.getOID());
                            md.setUpdateDate(updateDate);
                            md.setStatus(DbModuleBudget.DOC_HISTORY);
                            md.setDescription(description);
                            md.setCurrencyId(currId);
                            md.setUserUpdateId(userUpdateId);
                            md.setModuleId(moduleBudget.getModuleId());
                            DbModuleBudget.insertExc(md);                            
                        }catch(Exception e){}   
                        this.moduleBudget.setUpdateDate(new Date());
                        long oid = pstModuleBudget.updateExc(this.moduleBudget);        
                        
                        if (oid != 0) {
                            oldBudget = moduleBudget.getAmount() - oldBudget;
                            if (oldBudget != 0) {
                                DbModule.updateBudgetRecursif(moduleBudget.getModuleId(), oldBudget);
                            }
                        }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.ASSIGN:
                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.YES:
                if (oidModuleBudget != 0) {
                    try {                        
                        ModuleBudget xmoduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                        xmoduleBudget.setOID(0);
                        xmoduleBudget.setRefHistoryId(oidModuleBudget);                        
                        xmoduleBudget.setStatus(DbModuleBudget.DOC_HISTORY);
                        DbModuleBudget.insertExc(xmoduleBudget);
                        
                        long oid = DbModuleBudget.deleteExc(oidModuleBudget);
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

            case JSPCommand.LOCK:
                if (oidModuleBudget != 0) {
                    try {
                        moduleBudget = DbModuleBudget.fetchExc(oidModuleBudget);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            case JSPCommand.DETAIL:
                break;

            default:

        }
        return rsCode;
    }
}
