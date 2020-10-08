/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.master;

import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;
import com.project.simprop.property.*;

/**
 *
 * @author Tu Roy
 */
public class CmdLot extends Control {
    
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_TYPE_AND_EPLOYEE_EXIST = 4;
    
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete","Type dan employee sudah ada"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete","Type and employee exist"}};
    
    private int start;
    private String msgString;
    private Lot lot;
    private DbLot dbLot;
    private JspLot jspLot;

    public CmdLot(HttpServletRequest request) {
        msgString = "";
        lot = new Lot();
        try {
            dbLot = new DbLot(0);
        } catch (Exception e) {
            ;
        }
        jspLot = new JspLot(request, lot);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:                
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

    public Lot getLot() {
        return lot;
    }

    public JspLot getForm() {
        return jspLot;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidLot) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:                
                if (oidLot != 0) {
                    try {

                        lot = DbLot.fetchExc(oidLot);

                    } catch (Exception exc) {
                        System.out.println("ERR >>> : " + exc.toString());
                    }
                }

                jspLot.requestEntityObject(lot);                

                if (jspLot.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (oidLot == 0) {
                    try {

                        long oid = dbLot.insertExc(this.lot);
                        if(oid!=0){
                        	DbFloor.updateLotQty(oid, lot.getFloorId(), lot.getLotTypeId(), JSPCommand.SAVE);
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
                        
                        long oid = dbLot.updateExc(this.lot);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                
                if (oidLot != 0) {
                    try {
                        lot = DbLot.fetchExc(oidLot);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidLot != 0) {
                    try {
                        lot = DbLot.fetchExc(oidLot);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                jspLot.requestEntityObject(lot);
                break;

            case JSPCommand.DELETE:
                if (oidLot != 0) {
                    try {
                    	
                    	lot = DbLot.fetchExc(oidLot);
                    	
                        long oid = DbLot.deleteExc(oidLot);
                        
                        System.out.println("-------- delete sukses oid : "+oid);
                        
                        if (oid != 0) {
                        	
                        	System.out.println("-------- delete sukses lot.getFloorId() : "+lot.getFloorId()+", lot.getLotTypeId() : "+lot.getLotTypeId()+", command DELETE");
                        	
                        	DbFloor.updateLotQty(oidLot, lot.getFloorId(), lot.getLotTypeId(), JSPCommand.DELETE);
                        	
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
                
            case JSPCommand.RESET:
                if (oidLot != 0) {
                    try {
                        long oid = DbLot.deleteExc(oidLot);
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
