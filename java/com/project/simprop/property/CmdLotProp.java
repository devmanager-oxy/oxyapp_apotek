/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;

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

/**
 *
 * @author Tu Roy
 */
public class CmdLotProp extends Control {
    
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
    private LotProp lotProp;
    private DbLotProp dbLotProp;
    private JspLotProp jspLotProp;

    public CmdLotProp(HttpServletRequest request) {
        msgString = "";
        lotProp = new LotProp();
        try {
            dbLotProp = new DbLotProp(0);
        } catch (Exception e) {
            ;
        }
        jspLotProp = new JspLotProp(request, lotProp);
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

    public LotProp getLot() {
        return lotProp;
    }

    public JspLotProp getForm() {
        return jspLotProp;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidLotProp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:                
                if (oidLotProp != 0) {
                    try {

                        lotProp = DbLotProp.fetchExc(oidLotProp);

                    } catch (Exception exc) {
                        System.out.println("ERR >>> : " + exc.toString());
                    }
                }

                jspLotProp.requestEntityObject(lotProp);                

                if (jspLotProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (oidLotProp == 0) {
                    try {

                        long oid = dbLotProp.insertExc(this.lotProp);
                        if(oid!=0){
                        	DbFloor.updateLotQty(oid, lotProp.getFloorId(), lotProp.getLotTypeId(), JSPCommand.SAVE);
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
                        
                        long oid = dbLotProp.updateExc(this.lotProp);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                
                if (oidLotProp != 0) {
                    try {
                        lotProp = DbLotProp.fetchExc(oidLotProp);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidLotProp != 0) {
                    try {
                        lotProp = DbLotProp.fetchExc(oidLotProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                jspLotProp.requestEntityObject(lotProp);
                break;

            case JSPCommand.DELETE:
                if (oidLotProp != 0) {
                    try {
                    	
                    	lotProp = DbLotProp.fetchExc(oidLotProp);
                    	
                        long oid = DbLotProp.deleteExc(oidLotProp);
                        
                        System.out.println("-------- delete sukses oid : "+oid);
                        
                        if (oid != 0) {
                        	
                        	System.out.println("-------- delete sukses lotProp.getFloorId() : "+lotProp.getFloorId()+", lotProp.getLotTypeId() : "+lotProp.getLotTypeId()+", command DELETE");
                        	
                        	DbFloor.updateLotQty(oidLotProp, lotProp.getFloorId(), lotProp.getLotTypeId(), JSPCommand.DELETE);
                        	
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
                if (oidLotProp != 0) {
                    try {
                        long oid = DbLotProp.deleteExc(oidLotProp);
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
