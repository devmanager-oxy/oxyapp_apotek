package com.project.ccs.postransaction.opname;

import com.project.I_Project;
import com.project.ccs.postransaction.opname.DbOpnameSubLocation;
import com.project.ccs.postransaction.opname.JspOpnameSubLocation;
import com.project.ccs.postransaction.opname.OpnameSubLocation;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import java.util.Date;

public class CmdOpnameSubLocation extends Control implements I_Language {

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
    private OpnameSubLocation OpnameSubLocation;
    private DbOpnameSubLocation pstOpnameSubLocation;
    private JspOpnameSubLocation jspOpnameSubLocation;
    int language = LANGUAGE_DEFAULT;

    public CmdOpnameSubLocation(HttpServletRequest request) {
        msgString = "";
        OpnameSubLocation = new OpnameSubLocation();
        try {
            pstOpnameSubLocation = new DbOpnameSubLocation(0);
        } catch (Exception e) {
            ;
        }
        jspOpnameSubLocation = new JspOpnameSubLocation(request, OpnameSubLocation);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspOpname.addError(jspOpname.JSP_FIELD_OpnameSubLocation_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public OpnameSubLocation getOpnameSubLocation() {
        return OpnameSubLocation;
    }

    public JspOpnameSubLocation getForm() {
        return jspOpnameSubLocation;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidOpname, long oidOpnameSub) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpnameSub);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpnameSub);
                    } catch (Exception exc) {
                    }
                }
                break;


            case JSPCommand.SAVE:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpnameSub);
                    } catch (Exception exc) {
                    }
                }

                
                jspOpnameSubLocation.requestEntityObject(OpnameSubLocation);
                OpnameSubLocation.setOpnameId(oidOpname);

                if (jspOpnameSubLocation.errorSize() > 0){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (OpnameSubLocation.getOID() == 0) {
                    try {
                        
                        try {
                            
                            OpnameSubLocation.setStatus(I_Project.DOC_STATUS_DRAFT);
                        } catch (Exception xx) {
                            System.out.println("zzzz : " + xx.toString());
                        }

                        long oid = pstOpnameSubLocation.insertExc(this.OpnameSubLocation);
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
                        long oid = pstOpnameSubLocation.updateExc(this.OpnameSubLocation);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
            case JSPCommand.DELETE:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpname);
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
                        long oid = DbOpnameSubLocation.deleteExc(oidOpname);
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

                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpname);

                        userId = OpnameSubLocation.getUserId();
                        //app1Id = OpnameSubLocation.getApproval1();
                        //app2Id = OpnameSubLocation.getApproval2();
                        //app3Id = OpnameSubLocation.getApproval3();

                    } catch (Exception exc) {
                    }
                }

                jspOpnameSubLocation.requestEntityObject(OpnameSubLocation);

                //approval check ----------------
                if (OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    //approved status
                    //OpnameSubLocation.setApproval1(0);
                    //check status
                    //OpnameSubLocation.setApproval2(0);
                    //close status 
                    //OpnameSubLocation.setApproval3(0);
                } else if (OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    //OpnameSubLocation.setApproval1(OpnameSubLocation.getUserId());
                    //OpnameSubLocation.setApproval1_date(new Date());
                    //draft status
                    //OpnameSubLocation.setUserId(userId);
                    //check status
                    //OpnameSubLocation.setApproval2(0);
                    //close status
                   // OpnameSubLocation.setApproval3(0);
                } else if (OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc
                    //OpnameSubLocation.setApproval2(OpnameSubLocation.getUserId());
                    //OpnameSubLocation.setApproval2_date(new Date());
                    //draft status
                    //OpnameSubLocation.setUserId(userId);
                    //close
                    //OpnameSubLocation.setApproval3(0);
                } else if (OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                   // OpnameSubLocation.setApproval3(OpnameSubLocation.getUserId());
                    //OpnameSubLocation.setApproval3_date(new Date());
                    //draft status
                    OpnameSubLocation.setUserId(userId);
                }
                //--------------------------------

                if (jspOpnameSubLocation.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (OpnameSubLocation.getOID() == 0) {
                    try {

                        //int ctr = DbOpnameSubLocation.getNextCounter();
                        //OpnameSubLocation.setCounter(ctr);
                        //OpnameSubLocation.setPrefixNumber(DbOpnameSubLocation.getNumberPrefix());
                        //OpnameSubLocation.setNumber(DbOpnameSubLocation.getNextNumber(ctr));

                        long oid = pstOpnameSubLocation.insertExc(this.OpnameSubLocation);

                        //proses penambahan stock
                        //if (oid != 0 && OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnameSubLocationItem.proceedStock(OpnameSubLocation);
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
                        long oid = pstOpnameSubLocation.updateExc(this.OpnameSubLocation);

                        //proses penambahan stock
                        //if (oid != 0 && OpnameSubLocation.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbOpnameSubLocationItem.proceedStock(OpnameSubLocation);
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
//                if (oidOpname != 0) {
//                    try {
//                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpname);
//
//                    } catch (CONException dbexc) {
//                        excCode = dbexc.getErrorCode();
//                        msgString = getSystemMessage(excCode);
//                    } catch (Exception exc) {
//                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
//                    }
//                }
//
//                jspOpname.requestEntityObject(OpnameSubLocation);
//
//                int count = DbOpnameSubLocationItem.getCount(DbOpnameSubLocationItem.colNames[DbOpnameSubLocationItem.COL_OPNAME_ID] + "=" + OpnameSubLocation.getOID());
//
//                if (oidOpname != 0) {
//                    //DbOpnameSubLocation.validatePurchaseItem(OpnameSubLocation);
//                    //setelah diupdate- save purchse
//                    try {
//                        DbOpnameSubLocation.updateExc(OpnameSubLocation);
//                    } catch (Exception e) {
//                    }
//                //update total amount
//                //DbOpnameSubLocation.fixGrandTotalAmount(oidOpname);
//                }

                break;

            case JSPCommand.SUBMIT:
                if (oidOpnameSub != 0) {
                    try {
                        OpnameSubLocation = DbOpnameSubLocation.fetchExc(oidOpnameSub);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.CONFIRM:
                if (oidOpnameSub != 0) {
                    try {
                        //DbOpnameSubLocationItem.deleteAllItem(oidOpname); 
                        long oid = DbOpnameSubLocation.deleteExc(oidOpnameSub);
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
