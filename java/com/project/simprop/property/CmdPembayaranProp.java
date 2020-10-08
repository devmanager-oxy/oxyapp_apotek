
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
import com.project.*;

public class CmdPembayaranProp extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_PEMBAYARAN_MELEBIHI_INVOICE = 4;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap", "PembayaranProp melebihi invoice"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete", "Payment more than invoice"}};
    private int start;
    private String msgString;
    private PembayaranProp pembayaranProp;
    private DbPembayaranProp pstPembayaranProp;
    private JspPembayaranProp jspPembayaran;
    int language = LANGUAGE_DEFAULT;

    public CmdPembayaranProp(HttpServletRequest request) {
        msgString = "";
        pembayaranProp = new PembayaranProp();
        try {
            pstPembayaranProp = new DbPembayaranProp(0);
        } catch (Exception e) {
            ;
        }
        jspPembayaran = new JspPembayaranProp(request, pembayaranProp);
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

    public PembayaranProp getPembayaran() {
        return pembayaranProp;
    }

    public JspPembayaranProp getForm() {
        return jspPembayaran;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPembayaran) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:

                Date tglPembayaran = new Date();
                String noInvoice = "";

                if (oidPembayaran != 0) {
                    try {
                        pembayaranProp = DbPembayaranProp.fetchExc(oidPembayaran);
                        tglPembayaran = pembayaranProp.getTanggal();
                        noInvoice = pembayaranProp.getNoInvoice();
                    } catch (Exception exc) {
                        System.out.println("[exception] " + exc.toString());
                    }
                }

                jspPembayaran.requestEntityObject(pembayaranProp);

                double totInvoice = 0;

                if (jspPembayaran.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                SewaTanahInvoiceProp sti = new SewaTanahInvoiceProp();
                try {
                    sti = DbSewaTanahInvoiceProp.fetchExc(pembayaranProp.getSewaTanahInvoiceId());
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                pembayaranProp.setNoInvoice(sti.getNumber());
                pembayaranProp.setTanggalInvoice(sti.getTanggal());
                pembayaranProp.setCustomerId(sti.getSaranaId());

                totInvoice = sti.getJumlah() + sti.getTotalDenda() + sti.getPpn() + sti.getPph();

                boolean totInvoiceMore = DbPembayaranProp.isMoreThanTotInvoice(pembayaranProp, totInvoice);

                if (totInvoiceMore) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_MORE_INVOICE);
                    return RSLT_FORM_PEMBAYARAN_MELEBIHI_INVOICE;
                }

                if (pembayaranProp.getOID() == 0) {

                    try {

                        Date dt = new Date();
                        dt = pembayaranProp.getTanggalInvoice();
                        
                        String formatDocCode = DbSystemDocNumber.getNumberPrefix(dt,DbSystemDocCode.TYPE_DOCUMENT_BKM);
                        int counter = DbSystemDocNumber.getNextCounter(dt,DbSystemDocCode.TYPE_DOCUMENT_BKM);

                        pembayaranProp.setCounter(counter);
                        
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);
                        systemDocNumber.setYear(dt.getYear() + 1900);

                        formatDocCode = DbSystemDocNumber.getNextNumberBkm(pembayaranProp.getCounter(), pembayaranProp.getPeriodId());
                        systemDocNumber.setDocNumber(formatDocCode);
                        pembayaranProp.setNoBkm(formatDocCode);

                        long oid = DbPembayaranProp.insertExc(this.pembayaranProp);

                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) {
                                System.out.println("[exception] " + E.toString());
                            }
                        }

                        DbPembayaranProp.updateStatusInvoice(pembayaranProp.getOID(), pembayaranProp.getSewaTanahInvoiceId(), totInvoice);

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
                        long oid = DbPembayaranProp.updateExc(this.pembayaranProp);
                        DbPembayaranProp.updateStatusInvoice(pembayaranProp.getOID(), pembayaranProp.getSewaTanahInvoiceId(), totInvoice);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidPembayaran != 0) {
                    try {
                        pembayaranProp = DbPembayaranProp.fetchExc(oidPembayaran);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPembayaran != 0) {
                    try {
                        pembayaranProp = DbPembayaranProp.fetchExc(oidPembayaran);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPembayaran != 0) {
                    try {
                        long oid = DbPembayaranProp.deleteExc(oidPembayaran);
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
