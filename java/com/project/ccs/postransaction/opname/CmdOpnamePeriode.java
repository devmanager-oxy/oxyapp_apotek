package com.project.ccs.postransaction.opname;

import com.project.I_Project;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import java.util.Date;

public class CmdOpnamePeriode extends Control implements I_Language {

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
    private OpnamePeriode opnamePeriode;
    private DbOpnamePeriode pstOpname;
    private JspOpnamePeriode jspOpname;
    int language = LANGUAGE_DEFAULT;

    public CmdOpnamePeriode(HttpServletRequest request) {
        msgString = "";
        opnamePeriode = new OpnamePeriode();
        try {
            pstOpname = new DbOpnamePeriode(0);
        } catch (Exception e) {
            ;
        }
        jspOpname = new JspOpnamePeriode(request, opnamePeriode);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspOpname.addError(jspOpname.JSP_FIELD_opnamePeriode_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public OpnamePeriode getOpname() {
        return opnamePeriode;
    }

    public JspOpnamePeriode getForm() {
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidOpname != 0) {
                    try {
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }
                break;


            case JSPCommand.SAVE:
                if (oidOpname != 0) {
                    try {
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
                    } catch (Exception exc) {
                    }
                }

                System.out.println("masuk 0");
                jspOpname.requestEntityObject(opnamePeriode);

                if (jspOpname.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (opnamePeriode.getOID() == 0) {
                    try {
                        System.out.println("masuk 1");
                        try {
                            //int ctr = DbOpnamePeriode.getNextCounter();
                            //opnamePeriode.setCounter(ctr);
                            //opnamePeriode.setPrefixNumber(DbOpnamePeriode.getNumberPrefix());
                            //opnamePeriode.setNumber(DbOpnamePeriode.getNextNumber(ctr));
                            opnamePeriode.setStatus(I_Project.DOC_STATUS_DRAFT);
                        } catch (Exception xx) {
                            System.out.println("zzzz : " + xx.toString());
                        }

                        long oid = pstOpname.insertExc(this.opnamePeriode);
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
                        long oid = pstOpname.updateExc(this.opnamePeriode);
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
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
                        long oid = DbOpnamePeriode.deleteExc(oidOpname);
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);

                        //userId = opnamePeriode.getUserId();
                        //app1Id = opnamePeriode.getApproval1();
                        //app2Id = opnamePeriode.getApproval2();
                        //app3Id = opnamePeriode.getApproval3();

                    } catch (Exception exc) {
                    }
                }

                jspOpname.requestEntityObject(opnamePeriode);

                //approval check ----------------
                if (opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    //approved status
                    //opnamePeriode.setApproval1(0);
                    //check status
                    //opnamePeriode.setApproval2(0);
                    //close status 
                    //opnamePeriode.setApproval3(0);
                } else if (opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    //opnamePeriode.setApproval1(opnamePeriode.getUserId());
                    //opnamePeriode.setApproval1_date(new Date());
                    //draft status
                    //opnamePeriode.setUserId(userId);
                    //check status
                    //opnamePeriode.setApproval2(0);
                    //close status
                    //opnamePeriode.setApproval3(0);
                } else if (opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc
                    //opnamePeriode.setApproval2(opnamePeriode.getUserId());
                    //opnamePeriode.setApproval2_date(new Date());
                    //draft status
                    //opnamePeriode.setUserId(userId);
                    //close
                    //opnamePeriode.setApproval3(0);
                } else if (opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                    //opnamePeriode.setApproval3(opnamePeriode.getUserId());
                    //opnamePeriode.setApproval3_date(new Date());
                    //draft status
                    //opnamePeriode.setUserId(userId);
                }
                //--------------------------------

                if (jspOpname.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (opnamePeriode.getOID() == 0) {
                    try {

                        //int ctr = DbOpnamePeriode.getNextCounter();
                        //opnamePeriode.setCounter(ctr);
                        //opnamePeriode.setPrefixNumber(DbOpnamePeriode.getNumberPrefix());
                        //opnamePeriode.setNumber(DbOpnamePeriode.getNextNumber(ctr));

                        long oid = pstOpname.insertExc(this.opnamePeriode);

                        //proses penambahan stock
                        //if (oid != 0 && opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnamePeriodeItem.proceedStock(opnamePeriode);
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
                        long oid = pstOpname.updateExc(this.opnamePeriode);

                        //proses penambahan stock
                        //if (oid != 0 && opnamePeriode.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnamePeriodeItem.proceedStock(opnamePeriode);
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
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspOpname.requestEntityObject(opnamePeriode);

                //int count = DbOpnamePeriodeItem.getCount(DbOpnamePeriodeItem.colNames[DbOpnamePeriodeItem.COL_OPNAME_ID] + "=" + opnamePeriode.getOID());

                if (oidOpname != 0) {
                    //DbOpnamePeriode.validatePurchaseItem(opnamePeriode);
                    //setelah diupdate- save purchse
                    try {
                        DbOpnamePeriode.updateExc(opnamePeriode);
                    } catch (Exception e) {
                    }
                //update total amount
                //DbOpnamePeriode.fixGrandTotalAmount(oidOpname);
                }

                break;

            case JSPCommand.SUBMIT:
                if (oidOpname != 0) {
                    try {
                        opnamePeriode = DbOpnamePeriode.fetchExc(oidOpname);
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
                        //DbOpnamePeriodeItem.deleteAllItem(oidOpname); 
                        long oid = DbOpnamePeriode.deleteExc(oidOpname);
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
