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
public class CmdGlDetail2015 extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private GlDetail2015 glDetail2015;
    private DbGlDetail2015 dbGlDetail;
    private JspGlDetail2015 jspGlDetail;
    int language = LANGUAGE_DEFAULT;

    public CmdGlDetail2015(HttpServletRequest request) {
        msgString = "";
        glDetail2015 = new GlDetail2015();
        try {
            dbGlDetail = new DbGlDetail2015(0);
        } catch (Exception e) {
            ;
        }
        jspGlDetail = new JspGlDetail2015(request, glDetail2015);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspGlDetail.addError(jspGlDetail.JSP_GL_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public GlDetail2015 getGlDetail2015() {
        return glDetail2015;
    }

    public JspGlDetail2015 getForm() {
        return jspGlDetail;
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
                        glDetail2015 = DbGlDetail2015.fetchExc(oidGlDetail);
                    } catch (Exception exc) {
                    }
                }

                jspGlDetail.requestEntityObject(glDetail2015);

                glDetail2015 = DbGlDetail2015.setCoaLevel(glDetail2015);
                glDetail2015 = DbGlDetail2015.setOrganizationLevel(glDetail2015);

                if (jspGlDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (glDetail2015.getOID() == 0) {
                    try {
                        long oid = dbGlDetail.insertExc(this.glDetail2015);
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
                        long oid = dbGlDetail.updateExc(this.glDetail2015);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspGlDetail.requestEntityObject(glDetail2015);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(glDetail2015.getCoaId());
                } catch (Exception e) {
                }


                if (glDetail2015.getSegment1Id() == 0 && glDetail2015.getModuleId() != 0) {
                    try {

                        Module md = DbModule.fetchExc(glDetail2015.getModuleId());
                        glDetail2015.setSegment1Id(md.getSegment1Id());
                        glDetail2015.setSegment2Id(md.getSegment2Id());
                        glDetail2015.setSegment3Id(md.getSegment3Id());
                        glDetail2015.setSegment4Id(md.getSegment4Id());
                        glDetail2015.setSegment5Id(md.getSegment5Id());
                        glDetail2015.setSegment6Id(md.getSegment6Id());
                        glDetail2015.setSegment7Id(md.getSegment7Id());
                        glDetail2015.setSegment8Id(md.getSegment8Id());
                        glDetail2015.setSegment9Id(md.getSegment9Id());
                        glDetail2015.setSegment10Id(md.getSegment10Id());
                        glDetail2015.setSegment11Id(md.getSegment11Id());
                        glDetail2015.setSegment12Id(md.getSegment12Id());
                        glDetail2015.setSegment13Id(md.getSegment13Id());
                        glDetail2015.setSegment14Id(md.getSegment14Id());
                        glDetail2015.setSegment15Id(md.getSegment15Id());
                    } catch (Exception e) {

                    }
                }

                
                Periode per13 = DbPeriode.getOpenPeriod13();
                if (per13.getOID() != 0) {

                    try {
                        //Gl gl = DbGl.fetchExc(glOID);
                        if (per13.getOID() == periode.getOID()) {
                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "Can not book a P&L account in 13th period");
                            }
                        }
                    } catch (Exception e) {
                    }

                }



                if (glDetail2015.getDebet() == 0 && glDetail2015.getCredit() == 0) {
                    msgString = "Journal amount required";
                    return RSLT_FORM_INCOMPLETE;
                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "postable account type required");
                }

                Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                if (coaLabaBerjalan.getOID() == glDetail2015.getCoaId()) {
                    jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "can not book for current year earning account");
                }

                //jika tidak postable tidak boleh
                Department dept = new Department();

                try {
                    if (glDetail2015.getDepartmentId() != 0) {

                        dept = DbDepartment.fetchExc(glDetail2015.getDepartmentId());

                        if (!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            jspGlDetail.addError(jspGlDetail.JSP_DEPARTMENT_ID, "postable department type required");
                        }

                    }
                } catch (Exception e) {
                }

                if (jspGlDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspGlDetail.requestEntityObject(glDetail2015);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(glDetail2015.getCoaId());
                } catch (Exception e) {

                }

                if (glDetail2015.getDebet() == 0 && glDetail2015.getCredit() == 0) {
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
                                jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "Can not book a P&L account in 13th period");
                            }
                        }
                    } catch (Exception e) {
                    }

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "postable account type required");
                }

                coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                if (coaLabaBerjalan.getOID() == glDetail2015.getCoaId()) {
                    jspGlDetail.addError(jspGlDetail.JSP_COA_ID, "can not book for current year earning account");
                }

                //jika tidak postable tidak boleh
                dept = new Department();

                try {
                    if (glDetail2015.getDepartmentId() != 0) {

                        dept = DbDepartment.fetchExc(glDetail2015.getDepartmentId());

                        if (!dept.getType().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            jspGlDetail.addError(jspGlDetail.JSP_DEPARTMENT_ID, "postable department type required");
                        }

                    }
                } catch (Exception e) {
                }


                if (jspGlDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidGlDetail != 0) {
                    try {
                        glDetail2015 = DbGlDetail2015.fetchExc(oidGlDetail);
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
                        glDetail2015 = DbGlDetail2015.fetchExc(oidGlDetail);
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
                        long oid = DbGlDetail2015.deleteExc(oidGlDetail);
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
