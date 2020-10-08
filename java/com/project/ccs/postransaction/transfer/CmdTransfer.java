package com.project.ccs.postransaction.transfer;

import java.util.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.system.DbSystemProperty;

public class CmdTransfer extends Control implements I_Language {

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
    private Transfer transfer;
    private DbTransfer pstTransfer;
    private JspTransfer jspTransfer;
    int language = LANGUAGE_DEFAULT;

    public CmdTransfer(HttpServletRequest request) {
        msgString = "";
        transfer = new Transfer();
        try {
            pstTransfer = new DbTransfer(0);
        } catch (Exception e) {
            ;
        }
        jspTransfer = new JspTransfer(request, transfer);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspTransfer.addError(jspTransfer.JSP_FIELD_transfer_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Transfer getTransfer() {
        return transfer;
    }

    public JspTransfer getForm() {
        return jspTransfer;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
        
    }

    synchronized public int action(int cmd, long oidTransfer) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspTransfer.requestEntityObject(transfer);
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (Exception exc) {
                    }
                }
                break; 

            case JSPCommand.SAVE:
                if (oidTransfer != 0){
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (Exception exc) {
                    }
                }
                
                //jika posisi update & dokumen statusnya sudah terupdate dan tidak draft maka cancel update
                boolean statusError = false;
                if(oidTransfer!=0 && !transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    statusError = true;
                }
                
                // System.out.println("err >>>> masuk");
                jspTransfer.requestEntityObject(transfer);
                
                if(statusError){
                    jspTransfer.addError(jspTransfer.JSP_STATUS, "Can't save data, doc is locked for update");
                }

                if (jspTransfer.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (transfer.getOID() == 0){
                    try {
                        // System.out.println("err >>>> masuk 2");
                        int ctr = DbTransfer.getNextCounter(transfer.getFromLocationId());
                        transfer.setCounter(ctr);
                        transfer.setPrefixNumber(DbTransfer.getNumberPrefix(transfer.getFromLocationId()));
                        transfer.setNumber(DbTransfer.getNextNumber(ctr, transfer.getFromLocationId()));
                        //transfer.setStatus(I_Project.DOC_STATUS_DRAFT);
                        //transfer.setDate(new Date());
                        
                       
                        long oid = pstTransfer.insertExc(this.transfer);
                        //System.out.println("err >>>> masuk sukses");
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
                        long oid = pstTransfer.updateExc(this.transfer);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:

                System.out.println("\n\nPOSTING command POST - new synchronized\n");
                    
                long userId = 0;
                long app1Id = 0;
                long app2Id = 0;
                long app3Id = 0;
                
                String prevStatus = "";

                if (oidTransfer != 0){
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                        
                        prevStatus = transfer.getStatus();
                        userId = transfer.getUserId();
                        app1Id = transfer.getApproval1();
                        app2Id = transfer.getApproval2();
                        app3Id = transfer.getApproval3();

                    } catch (Exception exc) {
                    }
                }

                jspTransfer.requestEntityObject(transfer);
                
                System.out.println("\n\n status = "+transfer.getStatus());

                if(transfer.getStatus().equals("REQUEST")){
                    transfer.setApproval3(transfer.getUserId());
                    transfer.setApproval3Date(new Date());
                    transfer.setApproval1(0);
                    transfer.setApproval2(0);                    
                }
                //approval check ----------------
                if (transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                    transfer.setUserId(userId);
                    //approved status
                    transfer.setApproval1(0);
                    //check status
                    transfer.setApproval2(0);
                    //close status
                    //transfer.setApproval3(0);
                    
                    //tidak sama2 draft - errorkan
                    if(oidTransfer!=0 && !prevStatus.equals(transfer.getStatus())){
                        jspTransfer.addError(jspTransfer.JSP_STATUS, "Can't save data, doc is locked for update");
                    }
                } else if (transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    //approved status
                    transfer.setApproval1(transfer.getUserId());
                    transfer.setApproval1Date(new Date());
                    //draft status
                    transfer.setUserId(userId);
                    //check status
                    transfer.setApproval2(0);
                    //close status
                    //transfer.setApproval3(0);
                } else if (transfer.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                    //close statusc
                    transfer.setApproval2(transfer.getUserId());
                    transfer.setApproval2Date(new Date());
                    //draft status
                    transfer.setUserId(userId);
                    //close
                    transfer.setApproval3(0);
                } else if (transfer.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                    //close status
                    transfer.setApproval3(transfer.getUserId());
                    transfer.setApproval3Date(new Date());
                    //draft status
                    transfer.setUserId(userId);
                }
                //--------------------------------

                if (jspTransfer.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (transfer.getOID() == 0) {
                    try {

                        int ctr = DbTransfer.getNextCounter(transfer.getFromLocationId());
                        transfer.setCounter(ctr);
                        transfer.setPrefixNumber(DbTransfer.getNumberPrefix(transfer.getFromLocationId()));
                        transfer.setNumber(DbTransfer.getNextNumber(ctr, transfer.getFromLocationId()));

                        long oid = pstTransfer.insertExc(this.transfer);
                        
                        System.out.println("\n--- insert oid : "+oid+", "+transfer.getStatus());
                        
                        //proses penambahan stock
                       // if (oid!=0 && transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                        //    DbTransferItem.proceedStock(transfer); 
                       // }

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
                        long oid = pstTransfer.updateExc(this.transfer);
                        
                        //System.out.println("update oid : "+oid+", "+transfer.getStatus());
                        
                        if(transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            //DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ID]+"="+ transfer.getOID()+" and type=3");
                            
                            DbTransferItem.proceedStockIn(transfer);
                            
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
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
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
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    
                
            /*    
            case JSPCommand.DELETE:
                if (oidTransfer != 0) {
                    try {
                        long oid = DbTransfer.deleteExc(oidTransfer);
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

            case JSPCommand.LOAD:
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspTransfer.requestEntityObject(transfer);

                int count = DbTransferItem.getCount(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID] + "=" + transfer.getOID());

                if (oidTransfer != 0) {
                    //DbTransfer.validatePurchaseItem(transfer);
                    //setelah diupdate- save purchse
                    try {
                        DbTransfer.updateExc(transfer);
                    } catch (Exception e) {
                    }
                //update total amount
                //DbTransfer.fixGrandTotalAmount(oidTransfer);
                }

                break;

            case JSPCommand.SUBMIT:
                if (oidTransfer != 0) {
                    try {
                        transfer = DbTransfer.fetchExc(oidTransfer);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
                
              case JSPCommand.RESET:
                     transfer = new Transfer();
                   
                
                break;   


            case JSPCommand.CONFIRM:
                if (oidTransfer != 0) {
                   
                   int rslt = DbTransferItem.deleteAllItem(oidTransfer);     
                   
                   try {
                        
                        long oid = DbTransfer.deleteExc(oidTransfer);
                        if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                            DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ID] + "=" + oidTransfer);
                        }
                        DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ID] + "=" + oidTransfer);
                        DbOrder.updateAuto("set status='DRAFT', transfer_id=0, transfer_item_id=0 where transfer_id="+oidTransfer);
                        if (rslt == 0) {
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
