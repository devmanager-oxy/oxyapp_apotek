package com.project.ccs.postransaction.sales;

import com.project.admin.User;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.crm.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.system.*;

public class CmdSales extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Sales sales;
    private DbSales dbSales;
    private JspSales jspSales;
    int language = LANGUAGE_DEFAULT;

    public CmdSales(HttpServletRequest request) {
        msgString = "";
        sales = new Sales();
        try {
            dbSales = new DbSales(0);
        } catch (Exception e) {
            ;
        }
        jspSales = new JspSales(request, sales);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return resultText[0][RSLT_EST_CODE_EXIST];
            default:
                return resultText[0][RSLT_UNKNOWN_ERROR];
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

    public Sales getSales() {
        return sales;
    }

    public JspSales getForm() {
        return jspSales;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSales, long companyId, User user) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }

                jspSales.requestEntityObject(sales);

                break;

            case JSPCommand.SUBMIT:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }
                jspSales.requestEntityObject(sales);
                break;

            case JSPCommand.BACK:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }
                jspSales.requestEntityObject(sales);
                break;

            case JSPCommand.LIST:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }

                break;
            case JSPCommand.SAVE:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }

                jspSales.requestEntityObject(sales);

                if (sales.getType() == DbSales.TYPE_CREDIT) {
                    if (sales.getCustomerId() == 0) {
                        jspSales.addError(jspSales.JSP_CUSTOMER_ID, "entry required");
                    }
                }

                if (jspSales.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                sales.setCompanyId(companyId);
                Currency c = DbCurrency.getCurrencyByCode(DbSystemProperty.getValueByName("CURRENCY_CODE_IDR"));
                sales.setCurrencyId(c.getOID());
                ExchangeRate er = DbExchangeRate.getStandardRate();
                sales.setBookingRate(er.getValueIdr());
                sales.setExchangeAmount(sales.getAmount());

                if (sales.getOID() == 0) {
                    try {
                        if (sales.getNumber() == null || sales.getNumber().length() == 0) {
                            sales.setCounter(DbSales.getNextCounter(companyId));
                            sales.setNumberPrefix(DbSales.getNumberPrefix(companyId));
                            sales.setNumber(DbSales.getNextNumber(sales.getCounter(), companyId));
                        }

                        long oid = dbSales.insertExc(this.sales);
                        rsCode = RSLT_OK;
                        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);

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
                        long oid = dbSales.updateExc(this.sales);
                        if (oid != 0) {
                            rsCode = RSLT_OK;
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_UPDATED);
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:

                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (Exception exc) {
                    }
                }

                jspSales.requestEntityObject(sales);

                if (jspSales.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                sales.setCompanyId(companyId);
                c = DbCurrency.getCurrencyByCode(DbSystemProperty.getValueByName("CURRENCY_CODE_IDR"));
                sales.setCurrencyId(c.getOID());
                er = DbExchangeRate.getStandardRate();
                sales.setBookingRate(er.getValueIdr());
                sales.setExchangeAmount(sales.getAmount());

                if (sales.getOID() == 0) {
                    try {
                        if (sales.getNumber() == null || sales.getNumber().length() == 0) {
                            sales.setCounter(DbSales.getNextCounter(companyId));
                            sales.setNumberPrefix(DbSales.getNumberPrefix(companyId));
                            sales.setNumber(DbSales.getNextNumber(sales.getCounter(), companyId));
                        }
                        long oid = dbSales.insertExc(this.sales);
                        rsCode = RSLT_OK;
                        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);

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

                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            sales.setPaymentStatus(DbSales.TYPE_BELUM_LUNAS);
                        }
                        long oid = dbSales.updateExc(this.sales);
                        if (oid != 0) {
                            rsCode = RSLT_OK;
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_UPDATED);
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspSales.requestEntityObject(sales);
                break;

            case JSPCommand.ASK:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSales != 0) {
                    try {
                        sales = DbSales.fetchExc(oidSales);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspSales.requestEntityObject(sales);
                break;
            //delete doc
            case JSPCommand.START:
                if (oidSales != 0) {
                    try {
                        DbSalesDetail.deleteDocSales(oidSales);

                        long oid = DbSales.deleteExc(oidSales);
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
