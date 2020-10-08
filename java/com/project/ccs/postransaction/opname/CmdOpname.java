package com.project.ccs.postransaction.opname;

import com.project.I_Project;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import java.util.Date;

public class CmdOpname extends Control implements I_Language {

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
    private Opname opname;
    private DbOpname pstOpname;
    private JspOpname jspOpname;
    int language = LANGUAGE_DEFAULT;

    public CmdOpname(HttpServletRequest request) {
        msgString = "";
        opname = new Opname();
        try {
            pstOpname = new DbOpname(0);
        } catch (Exception e) {
            ;
        }
        jspOpname = new JspOpname(request, opname);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspOpname.addError(jspOpname.JSP_FIELD_opname_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Opname getOpname() {
        return opname;
    }

    public JspOpname getForm() {
        return jspOpname;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidOpname) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }
                break;


            case JSPCommand.SAVE:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }

                
                jspOpname.requestEntityObject(opname);

                if (jspOpname.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (opname.getOID() == 0) {
                    try {
                        
                        try {
                            int ctr = DbOpname.getNextCounter();
                            opname.setCounter(ctr);
                            opname.setPrefixNumber(DbOpname.getNumberPrefix());
                            opname.setNumber(DbOpname.getNextNumber(ctr));
                            opname.setStatus(I_Project.DOC_STATUS_DRAFT);
                        } catch (Exception xx) {
                            System.out.println("zzzz : " + xx.toString());
                        }
                        //opname.setDate(new Date());
                        long oid = pstOpname.insertExc(this.opname);
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
                        long oid = pstOpname.updateExc(this.opname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
            case JSPCommand.DELETE:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    

            /*case JSPCommand.DELETE:
                if (oidOpname != 0) {
                    try {
                        long oid = DbOpname.deleteExc(oidOpname);
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
             */

            case JSPCommand.POST:
                long userId = 0;
                long app1Id = 0;
                long app2Id = 0;
                long app3Id = 0;

                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);

                        userId = opname.getUserId();
                        app1Id = opname.getApproval1();
                        app2Id = opname.getApproval2();
                        app3Id = opname.getApproval3();

                    } catch (Exception exc) {
                    }
                }

                jspOpname.requestEntityObject(opname);

                //approval check ----------------
                if (opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    //approved status
                    opname.setApproval1(0);
                    //check status
                    opname.setApproval2(0);
                    //close status 
                    opname.setApproval3(0);
                } else if (opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    opname.setApproval1(opname.getUserId());
                    opname.setApproval1_date(new Date());
                    //draft status
                    opname.setUserId(userId);
                    //check status
                    opname.setApproval2(0);
                    //close status
                    opname.setApproval3(0);
                } else if (opname.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc
                    opname.setApproval2(opname.getUserId());
                    opname.setApproval2_date(new Date());
                    //draft status
                    opname.setUserId(userId);
                    //close
                    opname.setApproval3(0);
                } else if (opname.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                    opname.setApproval3(opname.getUserId());
                    opname.setApproval3_date(new Date());
                    //draft status
                    opname.setUserId(userId);
                }
                //--------------------------------

                if (jspOpname.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (opname.getOID() == 0) {
                    try {

                        int ctr = DbOpname.getNextCounter();
                        opname.setCounter(ctr);
                        opname.setPrefixNumber(DbOpname.getNumberPrefix());
                        opname.setNumber(DbOpname.getNextNumber(ctr));

                        long oid = pstOpname.insertExc(this.opname);

                        //proses penambahan stock
                        //if (oid != 0 && opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnameItem.proceedStock(opname);
                        //}

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
                        long oid = pstOpname.updateExc(this.opname);

                        //proses penambahan stock
                        //if (oid != 0 && opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnameItem.proceedStock(opname);
                        //}

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.LOAD:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspOpname.requestEntityObject(opname);

                int count = DbOpnameItem.getCount(DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID] + "=" + opname.getOID());

                if (oidOpname != 0) {
                    //DbOpname.validatePurchaseItem(opname);
                    //setelah diupdate- save purchse
                    try {
                        DbOpname.updateExc(opname);
                    } catch (Exception e) {
                    }
                //update total amount
                //DbOpname.fixGrandTotalAmount(oidOpname);
                }

                break;

            case JSPCommand.SUBMIT:
                if (oidOpname != 0) {
                    try {
                        opname = DbOpname.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.CONFIRM:
                if (oidOpname != 0) {
                    try {
                        //DbOpnameItem.deleteAllItem(oidOpname); 
                        long oid = DbOpname.deleteExc(oidOpname);
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
