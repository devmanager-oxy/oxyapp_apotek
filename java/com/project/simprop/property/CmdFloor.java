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
public class CmdFloor extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Floor floor;
    private DbFloor pstFloor;
    private JspFloor jspFloor;
    int language = LANGUAGE_DEFAULT;

    public CmdFloor(HttpServletRequest request) {
        msgString = "";
        floor = new Floor();
        try {
            pstFloor = new DbFloor(0);
        } catch (Exception e) {}
        jspFloor = new JspFloor(request, floor);
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

    public Floor getFloor() {
        return floor;
    }

    public JspFloor getForm() {
        return jspFloor;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFloor) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;
                
            case JSPCommand.ASSIGN:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (Exception exc) {
                    }
                }

                jspFloor.requestEntityObject(floor);

                if (jspFloor.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (floor.getOID() == 0) {
                    try {
                        long oid = pstFloor.insertExc(this.floor);
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
                        long oid = pstFloor.updateExc(this.floor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;   
            case JSPCommand.SUBMIT:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (Exception exc) {
                    }
                }

                jspFloor.requestEntityObject(floor);

                if (jspFloor.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (floor.getOID() == 0) {
                    try {
                        long oid = pstFloor.insertExc(this.floor);
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
                        long oid = pstFloor.updateExc(this.floor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.SAVE:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (Exception exc) {
                    }
                }

                jspFloor.requestEntityObject(floor);

                if (jspFloor.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (floor.getOID() == 0) {
                    try {
                        long oid = pstFloor.insertExc(this.floor);
                        if(oid!=0){
                        	DbBuilding.updateFloorQty(floor.getBuildingId());
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
                        long oid = pstFloor.updateExc(this.floor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.CONFIRM:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    
                
            case JSPCommand.DETAIL:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;        

            case JSPCommand.ASK:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidFloor != 0) {
                    try {
                    	
                    	int count = DbLot.getCount(DbLot.colNames[DbLot.COL_FLOOR_ID]+"="+oidFloor+" and  "+DbLot.colNames[DbLot.COL_STATUS]+"!="+DbLot.LOT_STATUS_AVAILABLE);
                    	if(count!=0){
                    		msgString = (language==0) ? "Data lantai tidak bisa dihapus" : "Floor data locked from deletion";
                    		return RSLT_FORM_INCOMPLETE;
                    	}
                    	else{
                    		
                    		Floor fl = DbFloor.fetchExc(oidFloor);                  
                    		
                    		DbLot.del(DbLot.colNames[DbLot.COL_FLOOR_ID]+"="+oidFloor);
	                        long oid = DbFloor.deleteExc(oidFloor);
	                        if (oid != 0) {
	                        	
	                        	DbBuilding.updateFloorQty(fl.getBuildingId());
	                        	
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
                
            case JSPCommand.RESET:
                if (oidFloor != 0) {
                    try {
                        floor = DbFloor.fetchExc(oidFloor);
                    } catch (Exception exc) {
                    }
                }
                jspFloor.requestEntityObject(floor);

            default:

        }
        return rsCode;
    }
}
