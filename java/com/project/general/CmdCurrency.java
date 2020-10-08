package com.project.general;

/* java package */
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;

public class CmdCurrency extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"}};
    private int start;
    private String msgString;
    private Currency currency;
    private DbCurrency pstCurrency;
    private JspCurrency frmCurrency;
    int language = 0;
    private long userId = 0;

    public CmdCurrency(HttpServletRequest request) {
        msgString = "";
        currency = new Currency();
        try {
            pstCurrency = new DbCurrency(0);
        } catch (Exception e) {
        }
        frmCurrency = new JspCurrency(request, currency);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.frmCurrency.addError(frmCurrency.JSP_CURRENCY_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Currency getCurrency() {
        return currency;
    }

    public JspCurrency getForm() {
        return frmCurrency;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCurrency) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                Currency cOld = new Currency();
                if (oidCurrency != 0) {
                    try {
                        currency = DbCurrency.fetchExc(oidCurrency);
                        cOld = DbCurrency.fetchExc(oidCurrency);
                    } catch (Exception exc) {
                    }
                }

                frmCurrency.requestEntityObject(currency);

                if (oidCurrency == 0) {
                    if (pstCurrency.getCount("CURRENCY_CODE='" + currency.getCurrencyCode() + "'") > 0) {
                        frmCurrency.addError(frmCurrency.JSP_CURRENCY_CODE, "Kode sudah ada");
                    }
                } else {
                    if (pstCurrency.getCount("CURRENCY_CODE='" + currency.getCurrencyCode() + "' AND CURRENCY_ID<>" + oidCurrency) > 0) {
                        frmCurrency.addError(frmCurrency.JSP_CURRENCY_CODE, "Kode sudah ada");
                    }
                }

                if (frmCurrency.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (currency.getOID() == 0) {
                    try {
                        long oid = pstCurrency.insertExc(this.currency);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_CURRENCY);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription("Pembuatan Currency Baru : " + this.currency.getCurrencyCode());
                            try {
                                User u = DbUser.fetch(getUserId());
                                historyUser.setUserId(getUserId());
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            try{
                                DbHistoryUser.insertExc(historyUser);
                            }catch(Exception e){}
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
                        long oid = pstCurrency.updateExc(this.currency);
                        String str = "";
                        if (cOld.getCurrencyCode().compareToIgnoreCase(this.currency.getCurrencyCode()) != 0) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Code :" + cOld.getCurrencyCode() + "->" + this.currency.getCurrencyCode();
                        }
                        
                        if (cOld.getDescription().compareToIgnoreCase(this.currency.getDescription()) != 0) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Description :" + cOld.getDescription() + "->" + this.currency.getDescription();
                        }
                        
                        if (cOld.getRate() != this.currency.getRate()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Rate :" + JSPFormater.formatNumber(cOld.getRate(), "###,###.##")+ " -> " + JSPFormater.formatNumber(this.currency.getRate(), "###,###.##");
                        }
                        
                        if (cOld.getCoaId() != this.currency.getCoaId()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            Coa coaOld = new Coa();
                            try{
                                coaOld = DbCoa.fetchExc(cOld.getCoaId());
                            }catch(Exception e){}
                            
                            Coa coaNew = new Coa();
                            try{
                                coaNew = DbCoa.fetchExc(this.currency.getCoaId());
                            }catch(Exception e){}
                            
                            str = str + "Coa :" + coaOld.getName()+ " -> " + coaNew.getName();
                            
                        }
                        
                         if (str != null && str.length() > 0) {
                            str = "Perubahan data : " + str;
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_CURRENCY);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription(str);
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }

                            try {
                                DbHistoryUser.insertExc(historyUser);
                            } catch (Exception e) {
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
                if (oidCurrency != 0) {
                    try {
                        currency = DbCurrency.fetchExc(oidCurrency);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidCurrency != 0) {
                    try {
                        currency = DbCurrency.fetchExc(oidCurrency);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidCurrency != 0) {
                    try {
                        cOld = new Currency();
                        try{
                            cOld = DbCurrency.fetchExc(oidCurrency);
                        }catch(Exception e){}
                        long oid = DbCurrency.deleteExc(oidCurrency);                       
                        
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_CURRENCY);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);                            
                            historyUser.setDescription("Penghapusan data currency : " + cOld.getCurrencyCode());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }                            
                            try{
                                DbHistoryUser.insertExc(historyUser);
                            }catch(Exception e){}
                            
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
