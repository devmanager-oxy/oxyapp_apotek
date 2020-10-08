package com.project.ccs.postransaction.transfer;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbStockCode;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.stock.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.system.DbSystemProperty;

public class CmdFakturPajakDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private FakturPajakDetail fakturDetail;
    private DbFakturPajakDetail pstFakturDetail;
    private JspFakturPajakDetail jspFakturDetail;
    int language = LANGUAGE_DEFAULT;    

    public CmdFakturPajakDetail(HttpServletRequest request) {
        msgString = "";
        fakturDetail = new FakturPajakDetail();
        try {
            pstFakturDetail = new DbFakturPajakDetail(0);
        } catch (Exception e) {
            ;
        }
        jspFakturDetail = new JspFakturPajakDetail(request, fakturDetail);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspFakturDetail.addError(jspFakturDetail.JSP_FIELD_transfer_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public FakturPajakDetail getFakturItem() {
        return fakturDetail;
    }

    public JspFakturPajakDetail getForm() {
        return jspFakturDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFakturDetail, long oidFakturPajak) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.VIEW:

                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (Exception exc) {}
                }
                jspFakturDetail.requestEntityObject(fakturDetail);

                break;

            case JSPCommand.SAVE:
                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (Exception exc) {
                    }
                }
                System.out.println("err >>> : masuk");
                
                jspFakturDetail.requestEntityObject(fakturDetail);
                
                if(fakturDetail.getItemMasterId() != 0){
                    
                    try{
                        
                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(fakturDetail.getItemMasterId());
                        
                        //update harga dan total karena di jsp nya di hide
                        //fakturDetail.setPrice(im.getCogs());
                        //fakturDetail.setAmount((im.getCogs()*fakturDetail.getQty()));
                        
                        
                    }catch(Exception e){}
                    
                }    
                
                int totQty = 0;
                
                

                fakturDetail.setFakturPajakId(oidFakturPajak);
                

                if (jspFakturDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (fakturDetail.getOID() == 0) {
                    System.out.println("err >>> : masuk 2");
                    try {
                        long oid = pstFakturDetail.insertExc(this.fakturDetail);
                        System.out.println("err >>> : masuk sukses");
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
                                          
                        long oid = pstFakturDetail.updateExc(this.fakturDetail);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.REFRESH:
                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspFakturDetail.requestEntityObject(fakturDetail);
                break;    
                

            case JSPCommand.ASK:
                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.POST:
                if (oidFakturDetail != 0) {
                    try {
                        fakturDetail = DbFakturPajakDetail.fetchExc(oidFakturDetail);
                    } catch (Exception exc) {
                    }
                }
                System.out.println("err >>> : masuk");
                
                jspFakturDetail.requestEntityObject(fakturDetail);
                
                if(fakturDetail.getItemMasterId() != 0){
                    
                    try{
                        
                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(fakturDetail.getItemMasterId());
                        
                        //update harga dan total karena di jsp nya di hide
                        //fakturDetail.setPrice(im.getCogs());
                        //fakturDetail.setAmount((im.getCogs()*fakturDetail.getQty()));
                        
                        
                    }catch(Exception e){}
                    
                }    
                
                
                
                

                fakturDetail.setFakturPajakId(oidFakturPajak);
                

                if (jspFakturDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (fakturDetail.getOID() == 0) {
                    System.out.println("err >>> : masuk 2");
                    try {
                        long oid = pstFakturDetail.insertExc(this.fakturDetail);
                        System.out.println("err >>> : masuk sukses");
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
                                          
                        long oid = pstFakturDetail.updateExc(this.fakturDetail);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;
                

            case JSPCommand.DELETE:
                if (oidFakturDetail != 0) {
                    try {
                        
                        DbStockCode.deleteStockCodeByTransferItem(oidFakturDetail);
                        long oid = DbFakturPajakDetail.deleteExc(oidFakturDetail);
                        if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                            DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ITEM_ID]+ " = " + oidFakturDetail);
                        }
                        
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
