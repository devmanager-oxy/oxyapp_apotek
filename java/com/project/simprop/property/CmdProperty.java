/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.crm.master.DbLot;

/**
 *
 * @author Roy Andika
 */
public class CmdProperty extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Property property;
    private DbProperty pstProperty;
    private JspProperty jspProperty;
    int language = LANGUAGE_DEFAULT;

    public CmdProperty(HttpServletRequest request) {
        msgString = "";
        property = new Property();
        try {
            pstProperty = new DbProperty(0);
        } catch (Exception e) {
        }
        jspProperty = new JspProperty(request, property);
    }
    
    public CmdProperty(HttpServletRequest request, int lang) {
        msgString = "";
        property = new Property();
        try {
            pstProperty = new DbProperty(0);
        } catch (Exception e) {
        }
        
        language = lang;
        
        jspProperty = new JspProperty(request, property, lang);
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

    public Property getProperty() {
        return property;
    }

    public JspProperty getForm() {
        return jspProperty;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidProperty) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SEARCH:
                jspProperty.requestEntityObject(property);
                break;
            case JSPCommand.SAVE:
                if (oidProperty != 0) {
                    try {
                        property = DbProperty.fetchExc(oidProperty);
                    } catch (Exception exc) {
                    }
                }

                jspProperty.requestEntityObject(property);

                if (jspProperty.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(language,JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (property.getOID() == 0) {
                    try {
                        
                        long oid = pstProperty.insertExc(this.property);
                        msgString = JSPMessage.getMsg(language,JSPMessage.MSG_SAVED);
                        
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
                        long oid = pstProperty.updateExc(this.property);
                        msgString = JSPMessage.getMsg(language,JSPMessage.MSG_SAVED);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidProperty != 0) {
                    try {
                        property = DbProperty.fetchExc(oidProperty);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidProperty != 0) {
                    try {
                        property = DbProperty.fetchExc(oidProperty);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidProperty != 0) {
                    try {
                    	
                    	int count = DbLot.getCount(DbLot.colNames[DbLot.COL_PROPERTY_ID]+"="+oidProperty+" and  "+DbLot.colNames[DbLot.COL_STATUS]+"!="+DbLot.LOT_STATUS_AVAILABLE);
                    	
                    	if(count!=0){
                    		msgString = (language==0) ? "Data proyek tidak bisa dihapus" : "Property data locked from deletion";
                    		excCode = RSLT_FORM_INCOMPLETE;
                    	}
                    	else{
                    		DbLot.del(DbLot.colNames[DbLot.COL_PROPERTY_ID]+"="+oidProperty);
                    		DbFloor.del(DbFloor.colNames[DbFloor.COL_PROPERTY_ID]+"="+oidProperty);
                    		DbBuilding.del(DbBuilding.colNames[DbBuilding.COL_PROPERTY_ID]+"="+oidProperty);
	                        long oid = DbProperty.deleteExc(oidProperty);
	                        if (oid != 0) {
	                            msgString = JSPMessage.getMessage(language, JSPMessage.MSG_DELETED);
	                            excCode = RSLT_OK;
	                        } else {
	                            msgString = JSPMessage.getMessage(language, JSPMessage.ERR_DELETED);
	                            excCode = RSLT_FORM_INCOMPLETE;
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

            default:

        }
        return rsCode;
    }
}
