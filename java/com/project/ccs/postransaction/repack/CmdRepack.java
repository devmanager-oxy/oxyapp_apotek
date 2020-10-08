package com.project.ccs.postransaction.repack;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.system.DbSystemProperty;

public class CmdRepack extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Repack repack;
    private DbRepack pstRepack;
    private JspRepack jspRepack;
    int language = LANGUAGE_DEFAULT;

    public CmdRepack(HttpServletRequest request) {
        msgString = "";
        repack = new Repack();
        try {
            pstRepack = new DbRepack(0);
        } catch (Exception e) {
        }
        jspRepack = new JspRepack(request, repack);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspCosting.addError(jspCosting.JSP_FIELD_costing_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Repack getRepack() {
        return repack;
    }

    public JspRepack getForm() {
        return jspRepack;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized public int action(int cmd, long oidRepack) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.ACTIVATE:
                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);
                    } catch (Exception exc) {
                    }
                }
                break;

            case JSPCommand.SAVE:
                
                String oldStatus = "";
                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);
                        oldStatus = repack.getStatus();
                    } catch (Exception exc) {
                    }
                }

                jspRepack.requestEntityObject(repack);
                
                //jika status tidak draft tidak boleh update
                if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("") ){
                    jspRepack.addError(jspRepack.JSP_STATUS, "Document have been locked for update - current status "+oldStatus);
                }

                if (jspRepack.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (repack.getOID() == 0) {
                    try {
                        int ctr = DbRepack.getNextCounter();
                        repack.setCounter(ctr);
                        repack.setPrefixNumber(DbRepack.getNumberPrefix());
                        repack.setNumber(DbRepack.getNextNumber(ctr));
                        repack.setStatus(I_Project.DOC_STATUS_DRAFT);                        
                        long oid = pstRepack.insertExc(this.repack);
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
                        long oid = pstRepack.updateExc(this.repack);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:

                long userId = 0;
                long app1Id = 0;
                long app2Id = 0;
                long app3Id = 0;
                
                oldStatus = "";

                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);

                        userId = repack.getUserId();
                        app1Id = repack.getApproval1();
                        app2Id = repack.getApproval2();
                        app3Id = repack.getApproval3();
                        oldStatus = repack.getStatus();

                    } catch (Exception exc) {
                    }
                }

                jspRepack.requestEntityObject(repack);


                System.out.println("\n\n status = " + repack.getStatus());

                //approval check ----------------
                if (repack.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    //approved status
                    repack.setApproval1(0);
                    //check status
                    repack.setApproval2(0);
                    //close status
                    repack.setApproval3(0);
                    
                    //jika status tidak draft tidak boleh update
                    if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT)){
                        jspRepack.addError(jspRepack.JSP_APPROVAL_1, "Document have been locked for update - current status "+oldStatus);
                    }
                                        
                } else if (repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    repack.setApproval1(repack.getUserId());                    
                    //draft status
                    repack.setUserId(userId);
                    //check status
                    repack.setApproval2(0);
                    //close status
                    repack.setApproval3(0);
                } else if (repack.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc                    
                    repack.setApproval2(repack.getUserId());                    
                    //draft status
                    repack.setUserId(userId);
                    //close
                    repack.setApproval3(0);
                } else if (repack.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                    repack.setApproval3(repack.getUserId());
                    //costing.setApproval3Date(new Date());
                    //draft status
                    repack.setUserId(userId);
                }
                //--------------------------------
                
                //jika dia lengkap baru jalankan in out lengkap
                if (repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    int cnt = DbRepackItem.getCount("repack_id="+repack.getOID()+" and type=0");
                    if(cnt>0){
                        cnt = DbRepackItem.getCount("repack_id="+repack.getOID()+" and type=1");
                        if(cnt==0){
                            jspRepack.addError(jspRepack.JSP_APPROVAL_1, "INPUT & OUTPUT not complete");
                        }
                    }
                    else{
                        jspRepack.addError(jspRepack.JSP_APPROVAL_1, "INPUT & OUTPUT not complete");
                    }
                }
                
                if(CmdRepackItem.getTotalOutputPercent(oidRepack, 0, 0)!=100){
                    jspRepack.addError(jspRepack.JSP_APPROVAL_1, "Total output limit must be 100%");
                }

                if (jspRepack.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (repack.getOID() == 0) {
                    try {

                        int ctr = DbRepack.getNextCounter();
                        repack.setCounter(ctr);
                        repack.setPrefixNumber(DbRepack.getNumberPrefix());
                        repack.setNumber(DbRepack.getNextNumber(ctr));

                        long oid = pstRepack.insertExc(this.repack);

                        System.out.println("\n--- insert oid : " + oid + ", " + repack.getStatus());

                        //proses penambahan/poengurangan stock
                        if (oid != 0 && repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                            DbStock.delete(DbStock.colNames[DbStock.COL_REPACK_ID] + "=" + repack.getOID());
                            DbRepackItem.proceedStock(repack);
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
                        long oid = pstRepack.updateExc(this.repack);

                        if (repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                                DbStock.delete(DbStock.colNames[DbStock.COL_REPACK_ID] + "=" + repack.getOID());
                                DbRepackItem.proceedStock(repack);//tambah stock
                                //melakukan update cogs - ED - lakukan di jsp - butuh diskusi
                                //DbRepackItem.updateItemOutputCogs(repack);
                        }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;




            case JSPCommand.DELETE:
                if (oidRepack != 0) {
                    try {                        
                        repack = DbRepack.fetchExc(oidRepack);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                if (oidRepack != 0) {
                    try {
                        repack = DbRepack.fetchExc(oidRepack);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.CONFIRM:
                if (oidRepack != 0) {

                    int rslt = DbRepackItem.deleteAllItem(oidRepack);

                    try {

                        long oid = DbRepack.deleteExc(oidRepack);
                        if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {

                        }
                        DbStock.delete(DbStock.colNames[DbStock.COL_REPACK_ID] + "=" + oid);                  
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
