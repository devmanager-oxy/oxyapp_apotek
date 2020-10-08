/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;

import java.util.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;

/**
 *
 * @author Roy Andika
 */
public class CmdTransferRequest extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private TransferRequest transferRequest;
    private DbTransferRequest pstTransferRequest; 
    private JspTransferRequest jspTransferRequest;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;

    public CmdTransferRequest(HttpServletRequest request) {
        msgString = "";
        transferRequest = new TransferRequest();
        try {
            pstTransferRequest = new DbTransferRequest(0);
        } catch (Exception e) {            
        }
        jspTransferRequest = new JspTransferRequest(request, transferRequest);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:                
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

    public TransferRequest getTransfer() {
        return transferRequest;
    }

    public JspTransferRequest getForm() {
        return jspTransferRequest;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;

    }

    synchronized public int action(int cmd, long oidTransferRequest) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:                
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest); 
                    } catch (Exception exc) {
                    }
                }
                jspTransferRequest.requestEntityObject(transferRequest);
                break;
                
            case JSPCommand.LOAD:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspTransferRequest.requestEntityObject(transferRequest);                

                break;    

            case JSPCommand.BACK:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (Exception exc) {
                    }
                }
                break;

            case JSPCommand.SAVE:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (Exception exc) {
                    }
                }

                //jika posisi update & dokumen statusnya sudah terupdate dan tidak draft maka cancel update
                boolean statusError = false;
                if (oidTransferRequest != 0 && !transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    statusError = true;
                }
                
                jspTransferRequest.requestEntityObject(transferRequest);

                if (statusError) {
                    jspTransferRequest.addError(jspTransferRequest.JSP_STATUS, "Can't save data, doc is locked for update");
                }

                if (jspTransferRequest.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (transferRequest.getOID() == 0) {
                    try {            
                        transferRequest.setUserId(getUserId());
                        transferRequest.setCreateDate(new Date());
                        int ctr = DbTransferRequest.getNextCounter(transferRequest.getFromLocationId());
                        transferRequest.setCounter(ctr);
                        transferRequest.setPrefixNumber(DbTransferRequest.getNumberPrefix(transferRequest.getFromLocationId()));
                        transferRequest.setNumber(DbTransferRequest.getNextNumber(ctr, transferRequest.getFromLocationId()));
                        long oid = pstTransferRequest.insertExc(this.transferRequest);                    
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
                        if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || transferRequest.getStatus().equals(I_Project.DOC_STATUS_CANCELED)){
                            //approved status
                            transferRequest.setApproval1(getUserId());
                            transferRequest.setApproval1Date(new Date());
                            //draft status     
                    
                            if(transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && transferRequest.getGenId()==0 ){
                                long oidTransfer = DbTransferRequest.generateTransfer(transferRequest);
                                transferRequest.setGenId(oidTransfer);
                            }
                        }
                        long oid = pstTransferRequest.updateExc(this.transferRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            

            case JSPCommand.EDIT:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.POST:
                String prevStatus = "";
                
                if (oidTransferRequest != 0){
                    try {                
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);                        
                        prevStatus = transferRequest.getStatus();                        
                    } catch (Exception exc) {
                    }
                }
                
                jspTransferRequest.requestEntityObject(transferRequest);                
                
                if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    transferRequest.setUserId(getUserId());                    
                    transferRequest.setApproval1(0);
                    
                    //tidak sama2 draft - errorkan
                    if(oidTransferRequest!=0 && !prevStatus.equals(transferRequest.getStatus())){
                        jspTransferRequest.addError(jspTransferRequest.JSP_STATUS, "Document have been locked for update - current status is "+prevStatus);
                    }
                } else if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || transferRequest.getStatus().equals(I_Project.DOC_STATUS_CANCELED)) {
                    //approved status
                    transferRequest.setApproval1(getUserId());
                    transferRequest.setApproval1Date(new Date());
                    //draft status     
                    
                    if(transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && transferRequest.getGenId()==0 ){
                        long oidTransfer = DbTransferRequest.generateTransfer(transferRequest);
                        transferRequest.setGenId(oidTransfer);
                    }
                    
                    //block untuk double refresh
                    if(prevStatus.equals(I_Project.DOC_STATUS_APPROVED)){
                        jspTransferRequest.addError(jspTransferRequest.JSP_STATUS, "Document have been locked for update - current status is "+prevStatus);
                    }                    
                }              

                if (jspTransferRequest.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (transferRequest.getOID() == 0) {
                    try {
                        transferRequest.setUserId(getUserId());
                        transferRequest.setCreateDate(new Date());
                        int ctr = DbTransferRequest.getNextCounter(transferRequest.getFromLocationId());
                        transferRequest.setCounter(ctr);
                        transferRequest.setPrefixNumber(DbTransferRequest.getNumberPrefix(transferRequest.getFromLocationId()));
                        transferRequest.setNumber(DbTransferRequest.getNextNumber(ctr, transferRequest.getFromLocationId()));
                        long oid = DbTransferRequest.insertExc(this.transferRequest);

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
                        long oid = pstTransferRequest.updateExc(this.transferRequest);                        

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.ASK:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            //menghapus item
            case JSPCommand.DELETE:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                if (oidTransferRequest != 0) {
                    try {
                        transferRequest = DbTransferRequest.fetchExc(oidTransferRequest);
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

    /**
     * @return the userId
     */
    public long getUserId() {
        return userId;
    }

    /**
     * @param userId the userId to set
     */
    public void setUserId(long userId) {
        this.userId = userId;
    }
}
