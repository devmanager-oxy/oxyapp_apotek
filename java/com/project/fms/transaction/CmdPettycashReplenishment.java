/* 
 * Ctrl Name  		:  CtrlPettycashReplenishment.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

/* java package */
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.system.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.master.*;

public class CmdPettycashReplenishment extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private PettycashReplenishment pettycashReplenishment;
    private DbPettycashReplenishment dbPettycashReplenishment;
    private JspPettycashReplenishment jspPettycashReplenishment;
    int language = LANGUAGE_DEFAULT;

    public CmdPettycashReplenishment(HttpServletRequest request) {
        msgString = "";
        pettycashReplenishment = new PettycashReplenishment();
        try {
            dbPettycashReplenishment = new DbPettycashReplenishment(0);
        } catch (Exception e) {
            ;
        }
        jspPettycashReplenishment = new JspPettycashReplenishment(request, pettycashReplenishment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspPettycashReplenishment.addError(jspPettycashReplenishment.JSP_PETTYCASH_REPLENISHMENT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public PettycashReplenishment getPettycashReplenishment() {
        return pettycashReplenishment;
    }

    public JspPettycashReplenishment getForm() {
        return jspPettycashReplenishment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPettycashReplenishment) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.PRINT:
                if (oidPettycashReplenishment != 0) {
                    try {
                        pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                    } catch (Exception exc) {
                    }
                }

                if (pettycashReplenishment.getStatus().equals(I_Project.NA_NOT_POSTED_STATUS)) {

                    pettycashReplenishment.setStatus(I_Project.NA_PRINTED);

                    try {
                        dbPettycashReplenishment.updateExc(pettycashReplenishment);
                    } catch (Exception e) {

                    }
                }

                break;

            case JSPCommand.SAVE:
                if (oidPettycashReplenishment != 0) {
                    try {
                        pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                    } catch (Exception exc) {
                    }
                }

                jspPettycashReplenishment.requestEntityObject(pettycashReplenishment);

                String where = "'" + JSPFormater.formatDate(pettycashReplenishment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspPettycashReplenishment.addError(jspPettycashReplenishment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspPettycashReplenishment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (pettycashReplenishment.getOID() == 0) {
                    try {

                        Date dt = new Date();
                        Periode opnPeriode = new Periode();

                        try {
                            opnPeriode = DbPeriode.getOpenPeriod();
                        } catch (Exception e) {
                        }

                        int periodeTaken = 0;

                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e) {
                        }

                        if (periodeTaken == 0) {
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }
                        
                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);

                        int mnth = dt.getMonth() + 1;

                        String month = "";

                        if (mnth >= 10) {
                            month = "" + mnth;
                        } else {
                            month = "0" + mnth;
                        }

                        SystemDocCode systemDocCode = new SystemDocCode();

                        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);

                        String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + month + systemDocCode.getSeparator() + JSPFormater.formatDate(dtx, "yy");

                        int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

                        pettycashReplenishment.setJournalCounter(counter);
                        pettycashReplenishment.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
                        systemDocNumber.setYear(dt.getYear() + 1900);

                        formatDocCode = counter + systemDocCode.getSeparator() + formatDocCode;  // untuk mengeset nomor BKK
                        systemDocNumber.setDocNumber(formatDocCode);

                        /* ---- End--- */
                        pettycashReplenishment.setJournalNumber(formatDocCode);
                        /*---------------------------------*/

                        //pettycashReplenishment.setJournalCounter(DbPettycashReplenishment.getNextCounter());
                        //pettycashReplenishment.setJournalPrefix(DbPettycashReplenishment.getNumberPrefix());
                        //pettycashReplenishment.setJournalNumber(DbPettycashReplenishment.getNextNumber(pettycashReplenishment.getJournalCounter()));
                        pettycashReplenishment.setDate(new Date());
                        pettycashReplenishment.setStatus(I_Project.STATUS_NOT_POSTED);

                        long oid = dbPettycashReplenishment.insertExc(this.pettycashReplenishment);

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
                        pettycashReplenishment.setStatus(I_Project.STATUS_POSTED);
                        long oid = dbPettycashReplenishment.updateExc(this.pettycashReplenishment);

                        //lakukan proses ke jurnal
                        //petty cash pada bank
                        if (oid != 0) {

                        }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:
                try {

                    if (oidPettycashReplenishment != 0) {
                        try {
                            pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                        } catch (Exception exc) {
                        }
                    }

                    pettycashReplenishment.setStatus(I_Project.STATUS_POSTED);
                    long oid = dbPettycashReplenishment.updateExc(this.pettycashReplenishment);

                    //lakukan proses ke jurnal
                    //petty cash pada bank
                    if (oid != 0) {

                    }

                } catch (CONException dbexc) {
                    excCode = dbexc.getErrorCode();
                    msgString = getSystemMessage(excCode);
                } catch (Exception exc) {
                    msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                }

                break;

            case JSPCommand.SUBMIT:
                jspPettycashReplenishment.requestEntityObject(pettycashReplenishment);

                if (jspPettycashReplenishment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.EDIT:
                if (oidPettycashReplenishment != 0) {
                    try {
                        pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPettycashReplenishment != 0) {
                    try {
                        pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPettycashReplenishment != 0) {
                    try {
                        long oid = DbPettycashReplenishment.deleteExc(oidPettycashReplenishment);
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
