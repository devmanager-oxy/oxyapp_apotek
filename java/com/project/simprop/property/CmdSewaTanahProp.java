/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class CmdSewaTanahProp extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_DATA_EXIST = 4;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap",
    "Data kontrak sudah ada"
    },
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete",
    "Contract data already exist"
    }
    };
    private int start;
    private String msgString;
    private SewaTanahProp sewaTanahProp;
    private DbSewaTanahProp pstSewaTanahProp;
    private JspSewaTanahProp jspSewaTanahProp;
    int language = LANGUAGE_DEFAULT;

    public CmdSewaTanahProp(HttpServletRequest request) {
        msgString = "";
        sewaTanahProp = new SewaTanahProp();
        try {
            pstSewaTanahProp = new DbSewaTanahProp(0);
        } catch (Exception e) {
            ;
        }
        jspSewaTanahProp = new JspSewaTanahProp(request, sewaTanahProp);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspSewaTanahProp.addError(jspSewaTanahProp.JSP_sewa_tanah_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public SewaTanahProp getSewaTanah() {
        return sewaTanahProp;
    }

    public JspSewaTanahProp getForm() {
        return jspSewaTanahProp;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSewaTanahProp, Vector temp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidSewaTanahProp != 0) {
                    try {
                        sewaTanahProp = DbSewaTanahProp.fetchExc(oidSewaTanahProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahProp.requestEntityObject(sewaTanahProp);

                if (jspSewaTanahProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (sewaTanahProp.getOID() == 0) {
                    try {
                        if (DbSewaTanahProp.isContractExist(this.sewaTanahProp)) {
                            msgString = resultText[language][RSLT_DATA_EXIST];
                            return RSLT_DATA_EXIST;
                        } else {
                            long oid = pstSewaTanahProp.insertExc(this.sewaTanahProp);
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
                        long oid = pstSewaTanahProp.updateExc(this.sewaTanahProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidSewaTanahProp != 0) {
                    try {
                        sewaTanahProp = DbSewaTanahProp.fetchExc(oidSewaTanahProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSewaTanahProp != 0) {
                    try {
                        sewaTanahProp = DbSewaTanahProp.fetchExc(oidSewaTanahProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSewaTanahProp != 0) {
                    try {
                        long oid = DbSewaTanahProp.deleteExc(oidSewaTanahProp);
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

            case JSPCommand.SUBMIT:

                if (oidSewaTanahProp != 0) {
                    try {
                        sewaTanahProp = DbSewaTanahProp.fetchExc(oidSewaTanahProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahProp.requestEntityObject(sewaTanahProp);

                if (jspSewaTanahProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                //inserting new kontrak
                sewaTanahProp.setOID(0);
                sewaTanahProp.setRefId(oidSewaTanahProp);
                long oid = 0;
                try {
                    oid = pstSewaTanahProp.insertExc(this.sewaTanahProp);
                } catch (CONException dbexc) {
                    excCode = dbexc.getErrorCode();
                    msgString = getSystemMessage(excCode);
                    return getControlMsgId(excCode);
                } catch (Exception exc) {
                    msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                }

                if (oid != 0) {

                    if (temp != null && temp.size() > 0) {
                        int copyKomin = Integer.parseInt((String) temp.get(0));
                        int copyKompres = Integer.parseInt((String) temp.get(1));
                        int copyAssesment = Integer.parseInt((String) temp.get(2));
                        int copyInvoice = Integer.parseInt((String) temp.get(3));
                        int copyBPP = Integer.parseInt((String) temp.get(4));

                        Vector tempx = new Vector();

                        //kompensasi minimum
                        if (copyKomin == 1) {
                            tempx = DbSewaTanahKominProp.list(0, 0, DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SEWA_TANAH_ID] + "=" + oidSewaTanahProp, "");
                            if (tempx != null && tempx.size() > 0) {
                                for (int i = 0; i < tempx.size(); i++) {
                                    SewaTanahKominProp stk = (SewaTanahKominProp) tempx.get(i);
                                    stk.setOID(0);
                                    stk.setSewaTanahId(oid);
                                    try {
                                        DbSewaTanahKominProp.insertExc(stk);
                                    } catch (Exception e) {
                                    }
                                }
                            }
                        }

                        //kompensasi percen
                        if (copyKompres == 1) {
                            tempx = DbSewaTanahKomperProp.list(0, 0, DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_ID] + "=" + oidSewaTanahProp, "");
                            if (tempx != null && tempx.size() > 0) {
                                for (int i = 0; i < tempx.size(); i++) {
                                    SewaTanahKomperProp stk = (SewaTanahKomperProp) tempx.get(i);
                                    stk.setOID(0);
                                    stk.setSewaTanahId(oid);
                                    try {
                                        DbSewaTanahKomperProp.insertExc(stk);
                                    } catch (Exception e) {

                                    }
                                }
                            }
                        }
                        //assesment
                        if (copyAssesment == 1) {
                            tempx = DbSewaTanahAssesmentProp.list(0, 0, DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SEWA_TANAH_ID] + "=" + oidSewaTanahProp, "");
                            if (tempx != null && tempx.size() > 0) {
                                for (int i = 0; i < tempx.size(); i++) {
                                    SewaTanahAssesmentProp stk = (SewaTanahAssesmentProp) tempx.get(i);
                                    stk.setOID(0);
                                    stk.setSewaTanahId(oid);
                                    try {
                                        DbSewaTanahAssesmentProp.insertExc(stk);
                                    } catch (Exception e) {

                                    }
                                }
                            }
                        }

                        //bppembantu
                        if (copyBPP == 1) {
                            tempx = DbSewaTanahBpProp.list(0, 0, DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_ID] + "=" + oidSewaTanahProp, "");
                            if (tempx != null && tempx.size() > 0) {
                                for (int i = 0; i < tempx.size(); i++) {
                                    SewaTanahBpProp stk = (SewaTanahBpProp) tempx.get(i);
                                    stk.setOID(0);
                                    stk.setSewaTanahId(oid);
                                    try {
                                        DbSewaTanahBpProp.insertExc(stk);
                                    } catch (Exception e) {

                                    }
                                }
                            }
                        }

                        //invoice
                        if (copyInvoice == 1) {
                            tempx = DbSewaTanahInvoiceProp.list(0, 0, DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SEWA_TANAH_ID] + "=" + oidSewaTanahProp, "");
                            if (tempx != null && tempx.size() > 0) {
                                for (int i = 0; i < tempx.size(); i++) {
                                    SewaTanahInvoiceProp stk = (SewaTanahInvoiceProp) tempx.get(i);

                                    //income
                                    Vector tempincome = DbSewaTanahIncomeProp.list(0, 0, DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SEWA_TANAH_INVOICE_ID] + "=" + stk.getOID(), "");
                                    Vector tempdenda = DbDendaProp.list(0, 0, DbDendaProp.colNames[DbDendaProp.COL_SEWA_TANAH_INVOICE_ID] + "=" + stk.getOID(), "");
                                    //Vector tempbayar = DbPembayaran.list(0,0, DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+"="+stk.getOID(), "");

                                    stk.setOID(0);
                                    stk.setSewaTanahId(oid);
                                    try {
                                        long oidInv = DbSewaTanahInvoiceProp.insertExc(stk);

                                        if (tempincome != null && tempincome.size() > 0) {
                                            for (int x = 0; x < tempincome.size(); x++) {
                                                SewaTanahIncomeProp sti = (SewaTanahIncomeProp) tempincome.get(i);
                                                sti.setOID(0);
                                                sti.setSewaTanahInvoiceId(oidInv);
                                                try {
                                                    DbSewaTanahIncomeProp.insertExc(sti);
                                                } catch (Exception e) {

                                                }
                                            }
                                        }

                                        if (tempdenda != null && tempdenda.size() > 0) {
                                            for (int x = 0; x < tempdenda.size(); x++) {
                                                DendaProp dd = (DendaProp) tempdenda.get(i);
                                                dd.setOID(0);
                                                dd.setSewaTanahInvoiceId(oidInv);
                                                try {
                                                    DbDendaProp.insertExc(dd);
                                                } catch (Exception e) {

                                                }
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }
                            }

                            //upadate status
                            if (oidSewaTanahProp != 0) {
                                try {
                                    SewaTanahProp sewaTanahx = DbSewaTanahProp.fetchExc(oidSewaTanahProp);
                                    sewaTanahx.setStatus(DbSewaTanahProp.STATUS_TIDAK_AKTIF);
                                    DbSewaTanahProp.updateExc(sewaTanahx);
                                } catch (Exception exc) {
                                }
                            }
                        }
                    }
                }

                break;

            default:

        }
        return rsCode;
    }
}
