package com.project.fms.master;

import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.I_Project;
import com.project.main.db.CONException;
import com.project.main.entity.I_CONExceptionInfo;
import com.project.system.DbSystemProperty;
import com.project.util.JSPCommand;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;

public class CmdCoa extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}};
    private int start;
    private String msgString;
    private Coa coa;
    private DbCoa dbCoa;
    private JspCoa jspCoa;

    public CmdCoa(HttpServletRequest request) {
        msgString = "";
        coa = new Coa();
        try {
            dbCoa = new DbCoa(0);
        } catch (Exception e) {
            ;
        }
        jspCoa = new JspCoa(request, coa);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspCoa.addError(jspCoa.JSP_CODE, resultText[1][RSLT_EST_CODE_EXIST] );
                return resultText[1][RSLT_EST_CODE_EXIST];
            default:
                return resultText[1][RSLT_UNKNOWN_ERROR];
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

    public Coa getCoa() {
        return coa;
    }

    public JspCoa getForm() {
        return jspCoa;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCoa, double budget, long periodId, long loginId, long companyId) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                double oldOpeningBalance = 0;
                if (oidCoa != 0) {
                    try {
                        coa = DbCoa.fetchExc(oidCoa);
                        oldOpeningBalance = coa.getOpeningBalance();
                    } catch (Exception exc) {
                    }
                }

                jspCoa.requestEntityObject(coa);

                coa.setUserId(loginId);

                //jika laba berjalan set ke 0, ga boleh ada balance
                Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

                if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getCode().equals(coaLabaBerjalan.getCode())) {
                    coa.setOpeningBalance(0);
                }

                if (DbSystemProperty.getValueByName("APPLY_ACTIVITY").equals("Y")) {
                    if (coa.getCoaCategoryId() == 0 && coa.getCoaGroupAliasId() != 0) {
                        jspCoa.addError(jspCoa.JSP_COA_CATEGORY_ID, "Data required");
                    }

                    if (coa.getCoaCategoryId() != 0 && coa.getCoaGroupAliasId() == 0) {
                        jspCoa.addError(jspCoa.JSP_COA_GROUP_ALIAS_ID, "Data required");
                    }
                }

                if (jspCoa.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (coa.getLevel() < 2) {
                    coa.setAccRefId(0);
                } else {
                    if (coa.getAccRefId() == 0) {
                        jspCoa.addError(jspCoa.JSP_ACC_REF_ID, "please fill in");
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                        return RSLT_FORM_INCOMPLETE;
                    } else {
                        Coa coaParent = new Coa();
                        try {
                            coaParent = DbCoa.fetchExc(coa.getAccRefId());
                            if (coa.getLevel() - 1 != coaParent.getLevel()) {
                                jspCoa.addError(jspCoa.JSP_LEVEL, "invalid level for ref. account level " + coaParent.getLevel());
                                msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                return RSLT_FORM_INCOMPLETE;
                            }
                        } catch (Exception ez) {

                        }
                    }
                }

                String where = "code='" + coa.getCode() + "' and name='" + coa.getName() + "' and department_id=" + coa.getDepartmentId();
                if (coa.getOID() != 0) {
                    where = where + " and coa_id<>" + coa.getOID();
                }

                if (DbCoa.getCount(where) > 0) {
                    msgString = "Can not save duplicate entry for combination of code, name and department";
                    return RSLT_FORM_INCOMPLETE;
                }

                long oid = 0;

                if (coa.getOID() == 0) {
                    try {
                        coa.setRegDate(new java.util.Date());
                        oid = dbCoa.insertExc(this.coa);

                        if (oid != 0) {
                            Vector pers = DbPeriode.list(0, 0, "", "");
                            if (pers != null && pers.size() > 0) {
                                for (int i = 0; i < pers.size(); i++) {
                                    Periode p = (Periode) pers.get(i);

                                    CoaOpeningBalance ob = new CoaOpeningBalance();
                                    ob.setCoaId(oid);
                                    ob.setOpeningBalance(0);
                                    ob.setPeriodeId(p.getOID());
                                    DbCoaOpeningBalance.insertExc(ob);
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
                        oid = dbCoa.updateExc(this.coa);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                //proses budget
                if (oid != 0 && periodId != 0) {
                    try {
                        Vector v = DbCoaBudget.list(0, 0, "coa_id=" + oid + " and periode_id=" + periodId, "");
                        if (v != null && v.size() > 0) {
                            CoaBudget cb = (CoaBudget) v.get(0);
                            cb.setAmount(budget);
                            DbCoaBudget.updateExc(cb);
                        } else {
                            CoaBudget cb = new CoaBudget();
                            cb.setAmount(budget);
                            cb.setCoaId(oid);
                            cb.setPeriodeId(periodId);
                            DbCoaBudget.insertExc(cb);
                        }
                    } catch (Exception ex) {
                        System.out.println(ex.toString());
                    }
                }

                //proses opening balance
                //dilakukan jika baru periode pertama dan bukan expence, cogs, revenue
                //bukan laba
                //jika periode yang pertama, proses opening balance
                if (DbPeriode.getCount("") == 1 && !coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) && !coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) && !coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) && !coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) && !coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                    //Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                    //Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

                    if (oid != 0 && periodId != 0) {
                        //&& !coa.getCode().equals(coaLabaBerjalan.getCode()) 
                        //&& !coa.getCode().equals(coaLabaLalu.getCode())){
                        DbCoaOpeningBalance.updateOpeningBalanceRecursif(oid, coa.getOpeningBalance() - oldOpeningBalance, periodId);
                    }
                }

                break;

            case JSPCommand.SUBMIT:
                jspCoa.requestEntityObject(coa);
                break;

            case JSPCommand.EDIT:
                if (oidCoa != 0) {
                    try {
                        coa = DbCoa.fetchExc(oidCoa);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidCoa != 0) {
                    try {
                        coa = DbCoa.fetchExc(oidCoa);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidCoa != 0) {
                    try {
                        oid = DbCoa.deleteExc(oidCoa);
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
                break;
        }
        return rsCode;
    }
}
