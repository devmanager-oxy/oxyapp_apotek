package com.project.ccs.postransaction.transfer;

import java.util.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;

public class CmdFakturPajak extends Control implements I_Language {

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
    private FakturPajak fakturPajak;
    private DbFakturPajak pstFakturPajak;
    private JspFakturPajak jspFakturPajak;
    int language = LANGUAGE_DEFAULT;

    public CmdFakturPajak(HttpServletRequest request) {
        msgString = "";
        fakturPajak = new FakturPajak();
        try {
            pstFakturPajak = new DbFakturPajak(0);
        } catch (Exception e) {
            
        }
        jspFakturPajak = new JspFakturPajak(request, fakturPajak);
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

    public FakturPajak getFakturPajak() {
        return fakturPajak;
    }

    public JspFakturPajak getForm() {
        return jspFakturPajak;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFakturPajak) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspFakturPajak.requestEntityObject(fakturPajak);
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (Exception exc) {
                    }
                }
                break; 

            case JSPCommand.SAVE:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (Exception exc) {
                    }
                }                 
                jspFakturPajak.requestEntityObject(fakturPajak);
                
                if (jspFakturPajak.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (fakturPajak.getOID() == 0){
                    try {
                        
                        fakturPajak.setDate(new Date());
                        Date dt = new Date();
                        int counter = DbFakturPajak.getNextCounterFp(fakturPajak.getLocationToId());
                        String formatDocCode = "";
                        if(fakturPajak.getTypeFaktur() == DbFakturPajak.TYPE_FAKTUR_SALES){
                            formatDocCode = DbFakturPajak.getNumberPrefixFp(fakturPajak.getLocationToId());
                        }else{
                            formatDocCode = DbFakturPajak.getNumberPrefixFpTransfer(fakturPajak.getLocationToId());
                        }    
                        
                        fakturPajak.setCounter(counter);
                        fakturPajak.setPrefixNumber(formatDocCode);
                        
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        if(fakturPajak.getTypeFaktur() == DbFakturPajak.TYPE_FAKTUR_SALES){
                            formatDocCode = DbFakturPajak.getNextNumberFp(fakturPajak.getCounter(),fakturPajak.getLocationToId());                        
                        }else{
                            formatDocCode = DbFakturPajak.getNextNumberFpTransfer(fakturPajak.getCounter(),fakturPajak.getLocationToId());                        
                        }    
                        
                        systemDocNumber.setDocNumber(formatDocCode);
                        fakturPajak.setNumber(formatDocCode);
                                               
                        long oid = pstFakturPajak.insertExc(this.fakturPajak);
                        
                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) {
                                System.out.println("[exception] " + E.toString());
                            }
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
                        fakturPajak.setDate(new Date());
                        long oid = pstFakturPajak.updateExc(this.fakturPajak);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:

                System.out.println("\n\nPOSTING command POST\n");

                if (oidFakturPajak != 0){
                    try {
                         fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);

                    } catch (Exception exc) {
                    }
                }

                jspFakturPajak.requestEntityObject(fakturPajak);
               
                if (jspFakturPajak.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (fakturPajak.getOID() == 0) {
                    try {

                        int ctr = DbFakturPajak.getNextCounter();
                        fakturPajak.setCounter(ctr);
                        //fakturPajak.setPrefixNumber(DbTransfer.getNumberPrefix());
                        fakturPajak.setNumber(DbFakturPajak.getNextNumber(ctr));
                        fakturPajak.setDate(new Date());
                        long oid = pstFakturPajak.insertExc(this.fakturPajak);

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
                        long oid = pstFakturPajak.updateExc(this.fakturPajak);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.REFRESH:
                jspFakturPajak.requestEntityObject(fakturPajak);
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    
                
            case JSPCommand.RESET:
                jspFakturPajak.requestEntityObject(fakturPajak);         
                 if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;        

            case JSPCommand.ASK:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
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
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    

            case JSPCommand.LOAD:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspFakturPajak.requestEntityObject(fakturPajak);
           
                break;

            case JSPCommand.SUBMIT:
                if (oidFakturPajak != 0) {
                    try {
                        fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
             case JSPCommand.LIST:
                jspFakturPajak.requestEntityObject(fakturPajak);
                break;    

            case JSPCommand.CONFIRM:
                if (oidFakturPajak != 0) {
                   try {                        
                       long oid = DbTransfer.deleteExc(oidFakturPajak);                    
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
