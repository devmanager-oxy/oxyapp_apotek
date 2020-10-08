package com.project.crm.sewa;

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

public class CmdSewaTanahBenefit extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SewaTanahBenefit sewaTanahBenefit;
    private DbSewaTanahBenefit pstSewaTanahBenefit;
    private JspSewaTanahBenefit jspSewaTanahBenefit;
    int language = LANGUAGE_DEFAULT;

    public CmdSewaTanahBenefit(HttpServletRequest request) {
        msgString = "";
        sewaTanahBenefit = new SewaTanahBenefit();
        try {
            pstSewaTanahBenefit = new DbSewaTanahBenefit(0);
        } catch (Exception e) {
            ;
        }
        jspSewaTanahBenefit = new JspSewaTanahBenefit(request, sewaTanahBenefit);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspSewaTanahBenefit.addError(jspSewaTanahBenefit.JSP_sewa_tanah_benefit_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public SewaTanahBenefit getSewaTanahBenefit() {
        return sewaTanahBenefit;
    }

    public JspSewaTanahBenefit getForm() {
        return jspSewaTanahBenefit;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSewaTanahBenefit, Vector temp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidSewaTanahBenefit != 0) {
                    try {
                        sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(oidSewaTanahBenefit);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahBenefit.requestEntityObject(sewaTanahBenefit);

                SewaTanahInvoice sti = new SewaTanahInvoice();
                try {
                    sti = DbSewaTanahInvoice.fetchExc(sewaTanahBenefit.getSewaTanahInvoiceId());
                } catch (Exception e) {

                }

                if (jspSewaTanahBenefit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                System.out.println("ctrl ---- oidSewaTanahBenefit : " + oidSewaTanahBenefit);

                if (oidSewaTanahBenefit == 0) {

                    try {
                        sewaTanahBenefit.setTanggal(new Date());
                        int ctr = DbSewaTanahBenefit.getNextCounter();
                        String prefix = DbSewaTanahBenefit.getNumberPrefix();
                        String num = DbSewaTanahBenefit.getNextNumber(ctr);

                        sewaTanahBenefit.setCounter(ctr);
                        sewaTanahBenefit.setPrefixNumber(prefix);
                        sewaTanahBenefit.setNumber(num);

                        long oid = pstSewaTanahBenefit.insertExc(this.sewaTanahBenefit);

                        //lakukan update benefit detail
                        if (oid != 0) {
                            DbSewaTanahBenefitDetail.updateDetailData(oid, sewaTanahBenefit.getSewaTanahId(), temp);
                            sewaTanahBenefit.setTotalKomper(DbSewaTanahBenefitDetail.getTotalInvoice(oid) - sti.getJumlah());
                            double x = 0.1 * sewaTanahBenefit.getTotalKomper();

                            System.out.println("------ x : " + x);

                            sewaTanahBenefit.setPph(-1 * x);
                            sewaTanahBenefit.setPphPercent(10);
                            sewaTanahBenefit.setPpn(x);
                            sewaTanahBenefit.setPpnPercent(10);
                            oid = pstSewaTanahBenefit.updateExc(this.sewaTanahBenefit);
                        }

                        if (oid != 0) {

                            if (sewaTanahBenefit.getTotalKomper() > 0) {

                                SewaTanahBp sewaTanahBp = new SewaTanahBp();
                                sewaTanahBp.setMataUangId(sewaTanahBenefit.getCurrencyId());
                                sewaTanahBp.setDebet(sewaTanahBenefit.getTotalKomper());
                                sewaTanahBp.setRefnumber(sewaTanahBenefit.getNumber());
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setKeterangan(sewaTanahBenefit.getKeterangan());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setSewaTanahId(sewaTanahBenefit.getSewaTanahId());
                                sewaTanahBp.setSewaTanahInvId(sewaTanahBenefit.getSewaTanahInvoiceId());
                                sewaTanahBp.setTanggal(sewaTanahBenefit.getTanggalBenefit());
                                sewaTanahBp.setCustomerId(sewaTanahBenefit.getSaranaId());
                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);

                                try {
                                    long stbOid = DbSewaTanahBp.insertExc(sewaTanahBp);
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
                        
                        long oid = pstSewaTanahBenefit.updateExc(this.sewaTanahBenefit);

                        //lakukan update benefit detail
                        if (oid != 0) {

                            DbSewaTanahBenefitDetail.updateDetailData(oid, sewaTanahBenefit.getSewaTanahId(), temp);
                            sewaTanahBenefit.setTotalKomper(DbSewaTanahBenefitDetail.getTotalInvoice(oid) - sti.getJumlah());
                            double x = 0.1 * sewaTanahBenefit.getTotalKomper();

                            System.out.println("------ x : " + x);

                            sewaTanahBenefit.setPph(-1 * x);
                            sewaTanahBenefit.setPphPercent(10);
                            sewaTanahBenefit.setPpn(x);
                            sewaTanahBenefit.setPpnPercent(10);
                            oid = pstSewaTanahBenefit.updateExc(this.sewaTanahBenefit);
                        }

                        if (sewaTanahBenefit.getTotalKomper() > 0) {
                            
                            if (oid != 0) {

                                String whereStb = DbSewaTanahBp.colNames[DbSewaTanahBp.COL_TANGGAL] + " = '" +
                                        JSPFormater.formatDate(sewaTanahBenefit.getTanggalBenefit(), "yyyy-MM-dd") +
                                        "' AND " + DbSewaTanahBp.colNames[DbSewaTanahBp.COL_REFNUMBER] + " = '" +
                                        sewaTanahBenefit.getNumber() + "' ";

                                Vector list = DbSewaTanahBp.list(0, 0, whereStb, null);

                                if (list != null && list.size() > 0) {

                                    SewaTanahBp sewaTanahBp = (SewaTanahBp) list.get(0);

                                    sewaTanahBp.setMataUangId(sewaTanahBenefit.getCurrencyId());
                                    sewaTanahBp.setDebet(sewaTanahBenefit.getTotalKomper());
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setRefnumber(sewaTanahBenefit.getNumber());
                                    sewaTanahBp.setKeterangan(sewaTanahBenefit.getKeterangan());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setSewaTanahId(sewaTanahBenefit.getSewaTanahId());
                                    sewaTanahBp.setSewaTanahInvId(sewaTanahBenefit.getSewaTanahInvoiceId());
                                    sewaTanahBp.setTanggal(sewaTanahBenefit.getTanggalBenefit());
                                    sewaTanahBp.setCustomerId(sewaTanahBenefit.getSaranaId());
                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);

                                    try {
                                        long stbOid = DbSewaTanahBp.updateExc(sewaTanahBp);
                                    } catch (Exception e) {
                                        System.out.println("[exception] " + e.toString());
                                    }

                                } else {

                                    SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                    sewaTanahBp.setMataUangId(sewaTanahBenefit.getCurrencyId());
                                    sewaTanahBp.setDebet(sewaTanahBenefit.getTotalKomper());
                                    sewaTanahBp.setCredit(0);
                                    sewaTanahBp.setRefnumber(sewaTanahBenefit.getNumber());
                                    sewaTanahBp.setKeterangan(sewaTanahBenefit.getKeterangan());
                                    sewaTanahBp.setMem("-");
                                    sewaTanahBp.setSewaTanahId(sewaTanahBenefit.getSewaTanahId());
                                    sewaTanahBp.setSewaTanahInvId(sewaTanahBenefit.getSewaTanahInvoiceId());
                                    sewaTanahBp.setTanggal(sewaTanahBenefit.getTanggalBenefit());
                                    sewaTanahBp.setCustomerId(sewaTanahBenefit.getSaranaId());
                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);

                                    try {
                                        long stbOid = DbSewaTanahBp.insertExc(sewaTanahBp);
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
                if (oidSewaTanahBenefit != 0) {
                    try {
                        sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(oidSewaTanahBenefit);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSewaTanahBenefit != 0) {
                    try {
                        sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(oidSewaTanahBenefit);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSewaTanahBenefit != 0) {
                    try {
                        long oid = DbSewaTanahBenefit.deleteExc(oidSewaTanahBenefit);

                        DbSewaTanahBenefitDetail.resetDetailData(oid);

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
                if (oidSewaTanahBenefit != 0) {
                    try {
                        sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(oidSewaTanahBenefit);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahBenefit.requestEntityObject(sewaTanahBenefit);

                break;

            default:

        }
        return rsCode;
    }
}
