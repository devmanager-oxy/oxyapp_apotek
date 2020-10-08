/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.service;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class CmdServiceConfiguration extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Konfigurasi tipe ini sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "This configuration type exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private ServiceConfiguration serviceConfiguration;
    private DbServiceConfiguration dbServiceConfiguration;
    private JspServiceConfiguration jspServiceConfiguration;
    int language = LANGUAGE_DEFAULT;

    public CmdServiceConfiguration(HttpServletRequest request) {
        msgString = "";
        serviceConfiguration = new ServiceConfiguration();
        try {
            dbServiceConfiguration = new DbServiceConfiguration(0);
        } catch (Exception e) {
            ;
        }
        jspServiceConfiguration = new JspServiceConfiguration(request, serviceConfiguration);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspServiceConfiguration.addError(jspServiceConfiguration.JSP_SERVICE_TYPE, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public ServiceConfiguration getServiceConfiguration() {
        return serviceConfiguration;
    }

    public JspServiceConfiguration getForm() {
        return jspServiceConfiguration;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidServiceConfiguration, HttpServletRequest request) {

        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {

            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidServiceConfiguration != 0) {
                    try {
                        serviceConfiguration = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                    } catch (Exception exc) {
                    }
                }

                jspServiceConfiguration.requestEntityObject(serviceConfiguration);

                Date startTime = JSPDate.getTime(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_START_TIME], request);

                if (jspServiceConfiguration.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                serviceConfiguration.setStartTime(startTime);

                if (serviceConfiguration.getOID() == 0) {
                    try {
                        long oid = dbServiceConfiguration.insertExc(this.serviceConfiguration);
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
                        long oid = dbServiceConfiguration.updateExc(this.serviceConfiguration);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidServiceConfiguration != 0) {
                    try {
                        serviceConfiguration = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidServiceConfiguration != 0) {
                    try {
                        serviceConfiguration = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidServiceConfiguration != 0) {
                    try {
                        long oid = DbServiceConfiguration.deleteExc(oidServiceConfiguration);
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
                if (oidServiceConfiguration != 0) {
                    try {
                        serviceConfiguration = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

        }
        return rsCode;
    }

    public Vector action(int svcCount, int[] arrCommand, long[] arrOidServiceConfiguration, String[] strSvcType, String[] strTimeHour, String[] strTimeMinutes, String[] strInterval) {
        Vector vectServiceConf = new Vector(1, 1);
        for (int i = 0; i < svcCount; i++) {

            int iCommand = arrCommand[i];
            long oidServiceConfiguration = arrOidServiceConfiguration[i];

            switch (iCommand) {

                case JSPCommand.SAVE:

                    System.out.println("\n\nProcess Save : " + i);

                    ServiceConfiguration svcConf = new ServiceConfiguration();

                    String where = DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_TYPE] + "=" + Integer.parseInt(strSvcType[i]);
                    Vector vct = DbServiceConfiguration.list(0, 0, where, "");
                    if (vct != null && vct.size() > 0) {
                        serviceConfiguration = (ServiceConfiguration) vct.get(0);
                    }

                    Date dtTemp = new Date();
                    Date startTime = new Date(dtTemp.getYear(), dtTemp.getMonth(), dtTemp.getDate(), Integer.parseInt(strTimeHour[i]), Integer.parseInt(strTimeMinutes[i]));

                    serviceConfiguration.setServiceType(Integer.parseInt(strSvcType[i]));
                    serviceConfiguration.setPeriode(Integer.parseInt(strInterval[i]));
                    serviceConfiguration.setStartTime(startTime);

                    if (serviceConfiguration.getOID() == 0) {

                        try {

                            long oid = dbServiceConfiguration.insertExc(serviceConfiguration);
                            vectServiceConf.add(getServiceConfiguration());
                        } catch (Exception exc) {
                            System.out.println("Exc when insert serviceConf : " + exc.toString());
                        }
                    } // update service conf
                    else {
                        try {
                            long oid = dbServiceConfiguration.updateExc(serviceConfiguration);
                            vectServiceConf.add(serviceConfiguration);
                        } catch (Exception exc) {
                            System.out.println("Exc when update serviceConf : " + exc.toString());
                        }
                    }
                    break;

                default:

                    try {

                        String whereClause = DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_TYPE] + "=" + Integer.parseInt(strSvcType[i]);
                        Vector vectTemp = DbServiceConfiguration.list(0, 0, whereClause, "");
                        ServiceConfiguration objServiceConfigurationDefault = new ServiceConfiguration();
                        if (vectTemp != null && vectTemp.size() > 0) {
                            objServiceConfigurationDefault = (ServiceConfiguration) vectTemp.get(0);
                        }
                        vectServiceConf.add(objServiceConfigurationDefault);
                    } catch (Exception exc) {
                        System.out.println("Exc fetch DbServiceConfiguration");
                    }
                    break;
            }
        }
        return vectServiceConf;
    }

    public ServiceConfiguration action(int iCommand, long oidServiceConfiguration, int serviceType, String strTimeHour, String strTimeMinutes, String strInterval) {
        ServiceConfiguration objServiceConfiguration = new ServiceConfiguration();

        System.out.println("\n\n ============================\n");
        System.out.println("\n\n oidServiceConfiguration : " + oidServiceConfiguration + "\n");

        switch (iCommand) {
            case JSPCommand.SAVE:
                ServiceConfiguration svcConf = new ServiceConfiguration();
                if (oidServiceConfiguration != 0) {
                    try {
                        serviceConfiguration = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                        svcConf = DbServiceConfiguration.fetchExc(oidServiceConfiguration);
                    } catch (Exception exc) {
                        System.out.println("Exc fetch DbServiceConfiguration");
                    }
                }

                Date dtTemp = new Date();
                Date startTime = new Date(dtTemp.getYear(), dtTemp.getMonth(), dtTemp.getDate(), Integer.parseInt(strTimeHour), Integer.parseInt(strTimeMinutes));

                serviceConfiguration.setServiceType(serviceType);
                serviceConfiguration.setPeriode(Integer.parseInt(strInterval));
                serviceConfiguration.setStartTime(startTime);

                if (svcConf.getOID() == 0) {
                    try {
                        long oid = dbServiceConfiguration.insertExc(serviceConfiguration);
                        objServiceConfiguration = getServiceConfiguration();
                    } catch (Exception exc) {
                        System.out.println("Exc when insert serviceConf : " + exc.toString());
                    }
                } else {
                    try {
                        long oid = dbServiceConfiguration.updateExc(serviceConfiguration);
                        objServiceConfiguration = serviceConfiguration;
                    } catch (Exception exc) {
                        System.out.println("Exc when update serviceConf : " + exc.toString());
                    }
                }
                break;


            default:
                try {
                    String whereClause = DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_TYPE] + "=" + serviceType;
                    Vector vectTemp = DbServiceConfiguration.list(0, 0, whereClause, "");
                    if (vectTemp != null && vectTemp.size() > 0) {
                        objServiceConfiguration = (ServiceConfiguration) vectTemp.get(0);
                    }
                } catch (Exception exc) {
                    System.out.println("Exc fetch DbServiceConfiguration");
                }
                break;
        }
        return objServiceConfiguration;
    }
}
