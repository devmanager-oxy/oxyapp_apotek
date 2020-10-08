/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

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
import com.project.fms.master.*;
import com.project.util.*;
import com.project.payroll.*;
import com.project.fms.activity.*;
/**
 *
 * @author Roy
 */
public class CmdGlDetail2016 extends Control implements I_Language {

     public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private GlDetail2016 glDetail2016;
    private DbGlDetail2016 dbGlDetail2016;
    private JspGlDetail2016 jspGlDetail2016;
    int language = LANGUAGE_DEFAULT;

    public CmdGlDetail2016(HttpServletRequest request) {
        msgString = "";
        glDetail2016 = new GlDetail2016();
        try {
            dbGlDetail2016 = new DbGlDetail2016(0);
        } catch (Exception e) {}
        jspGlDetail2016 = new JspGlDetail2016(request, glDetail2016);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspGlDetail2016.addError(jspGlDetail2016.JSP_GL_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public GlDetail2016 getGlDetail2015() {
        return glDetail2016;
    }

    public JspGlDetail2016 getForm() {
        return jspGlDetail2016;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, Periode periode, long oidGlDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SEARCH:
                if (oidGlDetail != 0) {
                    try {
                        glDetail2016 = DbGlDetail2016.fetchExc(oidGlDetail);
                    } catch (Exception exc) {
                    }
                }

                jspGlDetail2016.requestEntityObject(glDetail2016);

                glDetail2016 = DbGlDetail2016.setCoaLevel(glDetail2016);
                glDetail2016 = DbGlDetail2016.setOrganizationLevel(glDetail2016);

                if (jspGlDetail2016.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (glDetail2016.getOID() == 0) {
                    try {
                        long oid = dbGlDetail2016.insertExc(this.glDetail2016);
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
                        long oid = dbGlDetail2016.updateExc(this.glDetail2016);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspGlDetail2016.requestEntityObject(glDetail2016);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(glDetail2016.getCoaId());
                } catch (Exception e) {
                }


                if (glDetail2016.getSegment1Id() == 0 && glDetail2016.getModuleId() != 0) {
                    try {

                        Module md = DbModule.fetchExc(glDetail2016.getModuleId());
                        glDetail2016.setSegment1Id(md.getSegment1Id());
                        glDetail2016.setSegment2Id(md.getSegment2Id());
                        glDetail2016.setSegment3Id(md.getSegment3Id());
                        glDetail2016.setSegment4Id(md.getSegment4Id());
                        glDetail2016.setSegment5Id(md.getSegment5Id());
                        glDetail2016.setSegment6Id(md.getSegment6Id());
                        glDetail2016.setSegment7Id(md.getSegment7Id());
                        glDetail2016.setSegment8Id(md.getSegment8Id());
                        glDetail2016.setSegment9Id(md.getSegment9Id());
                        glDetail2016.setSegment10Id(md.getSegment10Id());
                        glDetail2016.setSegment11Id(md.getSegment11Id());
                        glDetail2016.setSegment12Id(md.getSegment12Id());
                        glDetail2016.setSegment13Id(md.getSegment13Id());
                        glDetail2016.setSegment14Id(md.getSegment14Id());
                        glDetail2016.setSegment15Id(md.getSegment15Id());
                    } catch (Exception e) {

                    }
                }

                
                Periode per13 = DbPeriode.getOpenPeriod13();
                if (per13.getOID() != 0) {

                    try {
                        //Gl gl = DbGl.fetchExc(glOID);
                        if (per13.getOID() == periode.getOID()) {
                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "Can not book a P&L account in 13th period");
                            }
                        }
                    } catch (Exception e) {
                    }

                }



                if (glDetail2016.getDebet() == 0 && glDetail2016.getCredit() == 0) {
                    msgString = "Journal amount required";
                    return RSLT_FORM_INCOMPLETE;
                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "postable account type required");
                }

                Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                if (coaLabaBerjalan.getOID() == glDetail2016.getCoaId()) {
                    jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "can not book for current year earning account");
                }

                //jika tidak postable tidak boleh
                Department dept = new Department();

                try {
                    if (glDetail2016.getDepartmentId() != 0) {

                        dept = DbDepartment.fetchExc(glDetail2016.getDepartmentId());

                        if (!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            jspGlDetail2016.addError(jspGlDetail2016.JSP_DEPARTMENT_ID, "postable department type required");
                        }

                    }
                } catch (Exception e) {
                }

                if (jspGlDetail2016.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspGlDetail2016.requestEntityObject(glDetail2016);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(glDetail2016.getCoaId());
                } catch (Exception e) {

                }

                if (glDetail2016.getDebet() == 0 && glDetail2016.getCredit() == 0) {
                    msgString = "Journal amount required";
                    return RSLT_FORM_INCOMPLETE;
                }

                //check periode 13
                //coa tidak boleh expense dan income, tidak boleh mempengaruhi P&L
                per13 = DbPeriode.getOpenPeriod13();
                if (per13.getOID() != 0) {

                    try {                        
                        if (per13.getOID() == periode.getOID()) {
                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "Can not book a P&L account in 13th period");
                            }
                        }
                    } catch (Exception e) {
                    }

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "postable account type required");
                }

                coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                if (coaLabaBerjalan.getOID() == glDetail2016.getCoaId()) {
                    jspGlDetail2016.addError(jspGlDetail2016.JSP_COA_ID, "can not book for current year earning account");
                }

                //jika tidak postable tidak boleh
                dept = new Department();

                try {
                    if (glDetail2016.getDepartmentId() != 0) {

                        dept = DbDepartment.fetchExc(glDetail2016.getDepartmentId());

                        if (!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            jspGlDetail2016.addError(jspGlDetail2016.JSP_DEPARTMENT_ID, "postable department type required");
                        }

                    }
                } catch (Exception e) {
                }


                if (jspGlDetail2016.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidGlDetail != 0) {
                    try {
                        glDetail2016 = DbGlDetail2016.fetchExc(oidGlDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidGlDetail != 0) {
                    try {
                        glDetail2016 = DbGlDetail2016.fetchExc(oidGlDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidGlDetail != 0) {
                    try {
                        long oid = DbGlDetail2016.deleteExc(oidGlDetail);
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
