/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.master;

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

/**
 *
 * @author Tu Roy
 */
public class CmdUnitContract extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_TYPE_AND_EPLOYEE_EXIST = 4;
    
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete","Type dan employee sudah ada"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete","Type and employee exist"}};
    
    private int start;
    private String msgString;
    private UnitContract unitContract;
    private DbUnitContract dbUnitContract;
    private JspUnitContract jspUnitContract;

    public CmdUnitContract(HttpServletRequest request) {
        msgString = "";
        unitContract = new UnitContract();
        try {
            dbUnitContract = new DbUnitContract(0);
        } catch (Exception e) {
            ;
        }
        jspUnitContract = new JspUnitContract(request, unitContract);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:                
                return resultText[1][RSLT_EST_CODE_EXIST];
            default:
                return resultText[1][RSLT_UNKNOWN_ERROR];
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

    public UnitContract getUnitContract() {
        return unitContract;
    }

    public JspUnitContract getForm() {
        return jspUnitContract;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidUnitContract) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:                
                if (oidUnitContract != 0) {
                    try {

                        unitContract = DbUnitContract.fetchExc(oidUnitContract);

                    } catch (Exception exc) {
                        System.out.println("ERR >>> : " + exc.toString());
                    }
                }

                jspUnitContract.requestEntityObject(unitContract);                

                if (jspUnitContract.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (oidUnitContract == 0) {
                    try {

                        long oid = dbUnitContract.insertExc(this.unitContract);

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
                        
                        long oid = dbUnitContract.updateExc(this.unitContract);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                
                if (oidUnitContract != 0) {
                    try {
                        unitContract = DbUnitContract.fetchExc(oidUnitContract);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidUnitContract != 0) {
                    try {
                        unitContract = DbUnitContract.fetchExc(oidUnitContract);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                jspUnitContract.requestEntityObject(unitContract);
                break;

            case JSPCommand.DELETE:
                if (oidUnitContract != 0) {
                    try {
                        long oid = DbUnitContract.deleteExc(oidUnitContract);
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
