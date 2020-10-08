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

import com.project.crm.master.*;
import com.project.crm.master.DbLot;
import com.project.crm.master.JspLot;
import com.project.crm.master.Lot;

/**
 *
 * @author Roy Andika
 */
public class CmdBuilding extends Control implements I_Language{

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Building building;
    private DbBuilding pstBuilding;
    private JspBuilding jspBuilding;
    int language = LANGUAGE_DEFAULT;

    public CmdBuilding(HttpServletRequest request) {
        msgString = "";
        building = new Building();
        try {
            pstBuilding = new DbBuilding(0);
        } catch (Exception e) {}
        jspBuilding = new JspBuilding(request, building);
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

    public Building getBuilding() {
        return building;
    }

    public JspBuilding getForm() {
        return jspBuilding;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBuilding){
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidBuilding != 0) {
                    try {
                        building = DbBuilding.fetchExc(oidBuilding);
                    } catch (Exception exc) {
                    }
                }

                jspBuilding.requestEntityObject(building);
                
                if (jspBuilding.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (building.getOID() == 0) {
                    try {
                        long oid = pstBuilding.insertExc(this.building);
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
                        long oid = pstBuilding.updateExc(this.building);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidBuilding != 0) {
                    try {
                        building = DbBuilding.fetchExc(oidBuilding);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidBuilding != 0) {
                    try {
                        building = DbBuilding.fetchExc(oidBuilding);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidBuilding != 0) {
                    try {
                    	
                    	int count = DbLot.getCount(DbLot.colNames[DbLot.COL_BUILDING_ID]+"="+oidBuilding+" and  "+DbLot.colNames[DbLot.COL_STATUS]+"!="+DbLot.LOT_STATUS_AVAILABLE);
                    	
                    	if(count!=0){
                    		msgString = (language==0) ? "Data gedung tidak bisa dihapus" : "Tower data locked from deletion";
                    		return RSLT_FORM_INCOMPLETE;
                    	}
                    	else{
                    		DbLot.del(DbLot.colNames[DbLot.COL_BUILDING_ID]+"="+oidBuilding);
                    		DbFloor.del(DbFloor.colNames[DbFloor.COL_BUILDING_ID]+"="+oidBuilding);
                    		long oid = DbBuilding.deleteExc(oidBuilding);
	                        if (oid != 0) {
	                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
	                            return RSLT_OK;
	                        } else {
	                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
	                            return RSLT_FORM_INCOMPLETE;
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
