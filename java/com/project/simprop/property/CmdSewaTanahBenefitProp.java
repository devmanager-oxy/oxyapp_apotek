
package com.project.simprop.property;

import com.project.crm.transaction.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdSewaTanahBenefitProp extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SewaTanahBenefitProp sewaTanahBenefitProp;
    private DbSewaTanahBenefitProp pstSewaTanahBenefitProp;
    private JspSewaTanahBenefitProp jspSewaTanahBenefitProp;
    int language = LANGUAGE_DEFAULT;

    public CmdSewaTanahBenefitProp(HttpServletRequest request) {
        msgString = "";
        sewaTanahBenefitProp = new SewaTanahBenefitProp();
        try {
            pstSewaTanahBenefitProp = new DbSewaTanahBenefitProp(0);
        } catch (Exception e) {
            ;
        }
        jspSewaTanahBenefitProp = new JspSewaTanahBenefitProp(request, sewaTanahBenefitProp);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspSewaTanahBenefitProp.addError(jspSewaTanahBenefitProp.JSP_sewa_tanah_benefit_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public SewaTanahBenefitProp getSewaTanahBenefit() {
        return sewaTanahBenefitProp;
    }

    public JspSewaTanahBenefitProp getForm() {
        return jspSewaTanahBenefitProp;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSewaTanahBenefitProp, Vector temp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidSewaTanahBenefitProp != 0) {
                    try {
                        sewaTanahBenefitProp = DbSewaTanahBenefitProp.fetchExc(oidSewaTanahBenefitProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahBenefitProp.requestEntityObject(sewaTanahBenefitProp);

                SewaTanahInvoiceProp sti = new SewaTanahInvoiceProp();
                try {
                    sti = DbSewaTanahInvoiceProp.fetchExc(sewaTanahBenefitProp.getSewaTanahInvoiceId());
                } catch (Exception e) {

                }

                if (jspSewaTanahBenefitProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                System.out.println("ctrl ---- oidSewaTanahBenefitProp : " + oidSewaTanahBenefitProp);

                if (oidSewaTanahBenefitProp == 0) {

                    try {
                        sewaTanahBenefitProp.setTanggal(new Date());
                        int ctr = DbSewaTanahBenefitProp.getNextCounter();
                        String prefix = DbSewaTanahBenefitProp.getNumberPrefix();
                        String num = DbSewaTanahBenefitProp.getNextNumber(ctr);

                        sewaTanahBenefitProp.setCounter(ctr);
                        sewaTanahBenefitProp.setPrefixNumber(prefix);
                        sewaTanahBenefitProp.setNumber(num);

                        long oid = pstSewaTanahBenefitProp.insertExc(this.sewaTanahBenefitProp);

                        //lakukan update benefit detail
                        if (oid != 0) {
                            DbSewaTanahBenefitDetailProp.updateDetailData(oid, sewaTanahBenefitProp.getSewaTanahId(), temp);
                            sewaTanahBenefitProp.setTotalKomper(DbSewaTanahBenefitDetailProp.getTotalInvoice(oid) - sti.getJumlah());
                            double x = 0.1 * sewaTanahBenefitProp.getTotalKomper();

                            System.out.println("------ x : " + x);

                            sewaTanahBenefitProp.setPph(-1 * x);
                            sewaTanahBenefitProp.setPphPercent(10);
                            sewaTanahBenefitProp.setPpn(x);
                            sewaTanahBenefitProp.setPpnPercent(10);
                            oid = pstSewaTanahBenefitProp.updateExc(this.sewaTanahBenefitProp);
                        }

                        if (oid != 0) {

                            if (sewaTanahBenefitProp.getTotalKomper() > 0) {

                                SewaTanahBpProp sewaTanahBp = new SewaTanahBpProp();
                                sewaTanahBp.setMataUangId(sewaTanahBenefitProp.getCurrencyId());
                                sewaTanahBp.setDebet(sewaTanahBenefitProp.getTotalKomper());
                                sewaTanahBp.setRefnumber(sewaTanahBenefitProp.getNumber());
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setKeterangan(sewaTanahBenefitProp.getKeterangan());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setSewaTanahId(sewaTanahBenefitProp.getSewaTanahId());
                                sewaTanahBp.setSewaTanahInvId(sewaTanahBenefitProp.getSewaTanahInvoiceId());
                                sewaTanahBp.setTanggal(sewaTanahBenefitProp.getTanggalBenefit());
                                sewaTanahBp.setCustomerId(sewaTanahBenefitProp.getSaranaId());
                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);

                                try {
                                    long stbOid = DbSewaTanahBpProp.insertExc(sewaTanahBp);
                                } catch (Exception e) {
                                    System.out.println("");
                                }
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
                        
                        long oid = pstSewaTanahBenefitProp.updateExc(this.sewaTanahBenefitProp);

                        //lakukan update benefit detail
                        if (oid != 0) {

                            DbSewaTanahBenefitDetailProp.updateDetailData(oid, sewaTanahBenefitProp.getSewaTanahId(), temp);
                            sewaTanahBenefitProp.setTotalKomper(DbSewaTanahBenefitDetailProp.getTotalInvoice(oid) - sti.getJumlah());
                            double x = 0.1 * sewaTanahBenefitProp.getTotalKomper();

                            System.out.println("------ x : " + x);

                            sewaTanahBenefitProp.setPph(-1 * x);
                            sewaTanahBenefitProp.setPphPercent(10);
                            sewaTanahBenefitProp.setPpn(x);
                            sewaTanahBenefitProp.setPpnPercent(10);
                            oid = pstSewaTanahBenefitProp.updateExc(this.sewaTanahBenefitProp);
                        }

                        if (sewaTanahBenefitProp.getTotalKomper() > 0) {
                            
                            if (oid != 0) {

                                String whereStb = DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_TANGGAL] + " = '" +
                                        JSPFormater.formatDate(sewaTanahBenefitProp.getTanggalBenefit(), "yyyy-MM-dd") +
                                        "' AND " + DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_REFNUMBER] + " = '" +
                                        sewaTanahBenefitProp.getNumber() + "' ";

                                Vector list = DbSewaTanahBpProp.list(0, 0, whereStb, null);

                                if (list != null && list.size() > 0) {

                                    SewaTanahBpProp sewaTanahBp = (SewaTanahBpProp) list.get(0);

                                    sewaTanahBp.setMataUangId(sewaTanahBenefitProp.getCurrencyId());
                                    sewaTanahBp.setDebet(sewaTanahBenefitProp.getTotalKomper());
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setRefnumber(sewaTanahBenefitProp.getNumber());
                                    sewaTanahBp.setKeterangan(sewaTanahBenefitProp.getKeterangan());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setSewaTanahId(sewaTanahBenefitProp.getSewaTanahId());
                                    sewaTanahBp.setSewaTanahInvId(sewaTanahBenefitProp.getSewaTanahInvoiceId());
                                    sewaTanahBp.setTanggal(sewaTanahBenefitProp.getTanggalBenefit());
                                    sewaTanahBp.setCustomerId(sewaTanahBenefitProp.getSaranaId());
                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);

                                    try {
                                        long stbOid = DbSewaTanahBpProp.updateExc(sewaTanahBp);
                                    } catch (Exception e) {
                                        System.out.println("[exception] " + e.toString());
                                    }

                                } else {

                                    SewaTanahBpProp sewaTanahBp = new SewaTanahBpProp();

                                    sewaTanahBp.setMataUangId(sewaTanahBenefitProp.getCurrencyId());
                                    sewaTanahBp.setDebet(sewaTanahBenefitProp.getTotalKomper());
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setRefnumber(sewaTanahBenefitProp.getNumber());
                                    sewaTanahBp.setKeterangan(sewaTanahBenefitProp.getKeterangan());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setSewaTanahId(sewaTanahBenefitProp.getSewaTanahId());
                                    sewaTanahBp.setSewaTanahInvId(sewaTanahBenefitProp.getSewaTanahInvoiceId());
                                    sewaTanahBp.setTanggal(sewaTanahBenefitProp.getTanggalBenefit());
                                    sewaTanahBp.setCustomerId(sewaTanahBenefitProp.getSaranaId());
                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);

                                    try {
                                        long stbOid = DbSewaTanahBpProp.insertExc(sewaTanahBp);
                                    } catch (Exception e) {
                                        System.out.println("[exception] " + e.toString());
                                    }

                                }
                            }
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
                if (oidSewaTanahBenefitProp != 0) {
                    try {
                        sewaTanahBenefitProp = DbSewaTanahBenefitProp.fetchExc(oidSewaTanahBenefitProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSewaTanahBenefitProp != 0) {
                    try {
                        sewaTanahBenefitProp = DbSewaTanahBenefitProp.fetchExc(oidSewaTanahBenefitProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSewaTanahBenefitProp != 0) {
                    try {
                        long oid = DbSewaTanahBenefitProp.deleteExc(oidSewaTanahBenefitProp);

                        DbSewaTanahBenefitDetailProp.resetDetailData(oid);

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
                if (oidSewaTanahBenefitProp != 0) {
                    try {
                        sewaTanahBenefitProp = DbSewaTanahBenefitProp.fetchExc(oidSewaTanahBenefitProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahBenefitProp.requestEntityObject(sewaTanahBenefitProp);

                break;

            default:

        }
        return rsCode;
    }
}
