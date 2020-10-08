package com.project.ccs.postransaction.adjusment;

import com.project.I_Project;
import com.project.ccs.postransaction.stock.DbStock;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.system.DbSystemProperty;
import java.util.Date;

public class CmdAdjusment extends Control implements I_Language {

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
    private Adjusment adjusment;
    private DbAdjusment pstAdjusment;
    private JspAdjusment jspAdjusment;
    int language = LANGUAGE_DEFAULT;

    public CmdAdjusment(HttpServletRequest request) {
        msgString = "";
        adjusment = new Adjusment();
        try {
            pstAdjusment = new DbAdjusment(0);
        } catch (Exception e) {
            ;
        }
        jspAdjusment = new JspAdjusment(request, adjusment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspAdjusment.addError(jspAdjusment.JSP_FIELD_adjusment_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Adjusment getAdjusment() {
        return adjusment;
    }

    public JspAdjusment getForm() {
        return jspAdjusment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized public int action(int cmd, long oidAdjusment) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.ACTIVATE:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (Exception exc) {
                    }
                }
                break;     
                
            case JSPCommand.BACK:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (Exception exc) {
                    }
                }
                break;    

            case JSPCommand.SAVE:
                
                Date docDate = new Date();
                String oldStatus = "";
                
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                        docDate = adjusment.getDate();
                        oldStatus = adjusment.getStatus();
                    } catch (Exception exc) {
                    }
                }

                System.out.println("masuk 0");
                jspAdjusment.requestEntityObject(adjusment);
                
                //set back doc date
                if (oidAdjusment != 0) {
                    adjusment.setDate(docDate);
                }
                
                //jika status tidak draft tidak boleh update
                if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("") ){
                    jspAdjusment.addError(jspAdjusment.JSP_APPROVAL_1, "Document have been locked for update - current status is "+oldStatus);
                    adjusment.setStatus(oldStatus);
                }

                if (jspAdjusment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (adjusment.getOID() == 0) {
                    try {
                        System.out.println("masuk 1");
                        try {
                            int ctr = DbAdjusment.getNextCounter();
                            adjusment.setCounter(ctr);
                            adjusment.setPrefixNumber(DbAdjusment.getNumberPrefix());
                            adjusment.setNumber(DbAdjusment.getNextNumber(ctr));
                            adjusment.setStatus(I_Project.DOC_STATUS_DRAFT);
                        } catch (Exception xx) {
                            System.out.println("zzzz : " + xx.toString());
                        }

                        long oid = pstAdjusment.insertExc(this.adjusment);
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
                        long oid = pstAdjusment.updateExc(this.adjusment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
           
           case JSPCommand.DELETE:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;     

            /*case JSPCommand.DELETE:
                if (oidAdjusment != 0) {
                    try {
                        long oid = DbAdjusment.deleteExc(oidAdjusment);
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
                docDate = new Date();
                oldStatus = "";

                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                        docDate = adjusment.getDate();
                        oldStatus = adjusment.getStatus();
                        userId = adjusment.getUserId();
                        app1Id = adjusment.getApproval1();
                        app2Id = adjusment.getApproval2();
                        app3Id = adjusment.getApproval3();

                    } catch (Exception exc) {
                    }
                }

                jspAdjusment.requestEntityObject(adjusment);
                
                //kembalikan tanggal - jam - menit membuat ke awal
                adjusment.setDate(docDate);

                //approval check ----------------
                if (adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    //approved status
                    adjusment.setApproval1(0);
                    //check status
                    adjusment.setApproval2(0);
                    //close status 
                    adjusment.setApproval3(0);
                    
                    //jika status tidak draft tidak boleh update
                    if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("") ){
                        jspAdjusment.addError(jspAdjusment.JSP_APPROVAL_1, "Document have been locked for update - current status is "+oldStatus);
                        adjusment.setStatus(oldStatus);
                    }
                    
                } else if (adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    adjusment.setApproval1(adjusment.getUserId());
                    adjusment.setApproval1_date(new Date());
                    //draft status
                    adjusment.setUserId(userId);
                    //check status
                    adjusment.setApproval2(0);
                    //close status
                    adjusment.setApproval3(0);
                } else if (adjusment.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc
                    adjusment.setApproval2(adjusment.getUserId());
                    adjusment.setApproval2_date(new Date());
                    //draft status
                    adjusment.setUserId(userId);
                    //close
                    adjusment.setApproval3(0);
                } else if (adjusment.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                    adjusment.setApproval3(adjusment.getUserId());
                    adjusment.setApproval3_date(new Date());
                    //draft status
                    adjusment.setUserId(userId);
                }
                //--------------------------------

                if (jspAdjusment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (adjusment.getOID() == 0) {
                    try {

                        int ctr = DbAdjusment.getNextCounter();
                        adjusment.setCounter(ctr);
                        adjusment.setPrefixNumber(DbAdjusment.getNumberPrefix());
                        adjusment.setNumber(DbAdjusment.getNextNumber(ctr));
                        adjusment.setStatus(I_Project.STATUS_DOC_DRAFT);

                        long oid = pstAdjusment.insertExc(this.adjusment);

                        //proses penambahan stock
                        //if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                        //if(adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){    
                        //    DbStock.delete(DbStock.colNames[DbStock.COL_ADJUSTMENT_ID] + " = " + oidAdjusment);
                        //    DbAdjusmentItem.proceedStock(adjusment);
                        //}
                        //else{
                        //    if (oid != 0 && adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                        //        DbAdjusmentItem.proceedStock(adjusment);
                        //    }
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
                        long oid = pstAdjusment.updateExc(this.adjusment);

                        //proses penambahan stock
                        //if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                        if(adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            DbStock.delete(DbStock.colNames[DbStock.COL_ADJUSTMENT_ID] + " = " + oidAdjusment);
                            DbAdjusmentItem.proceedStock(adjusment);
                        }
                        //}else{
                        //    if (oid != 0 && adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                        //        DbAdjusmentItem.proceedStock(adjusment);
                        //    }
                       // }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.LOAD:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspAdjusment.requestEntityObject(adjusment);

                //int count = DbAdjusmentItem.getCount(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_OPNAME_ID] + "=" + adjusment.getOID());

                if (oidAdjusment != 0) {
                    //DbAdjusment.validatePurchaseItem(adjusment);
                    //setelah diupdate- save purchse
                    try {
                        //DbAdjusment.updateExc(adjusment);
                    } catch (Exception e) {
                    }
                //update total amount
                //DbAdjusment.fixGrandTotalAmount(oidAdjusment);
                }

                break;

            case JSPCommand.SUBMIT:
                if (oidAdjusment != 0) {
                    try {
                        adjusment = DbAdjusment.fetchExc(oidAdjusment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.CONFIRM:
                if (oidAdjusment != 0) {
                    try {
                        DbAdjusmentItem.deleteAllItem(oidAdjusment); 
                        long oid = DbAdjusment.deleteExc(oidAdjusment);
                        DbStock.delete(DbStock.colNames[DbStock.COL_ADJUSTMENT_ID] + " = " + oidAdjusment);
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
