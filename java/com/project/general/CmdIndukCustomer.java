/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

/**
 *
 * @author Tu Roy
 */
public class CmdIndukCustomer {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}};
    
    
    private String msgString;
    private int start;
    private IndukCustomer indukCustomer;
    private DbIndukCustomer dbIndukCustomer;
    	
    private JspIndukCustomer jspIndukCustomer;

    /** Creates new CtrlUser */
    public CmdIndukCustomer(HttpServletRequest request) {
        msgString = "";
        // errCode = Message.OK;

        indukCustomer = new IndukCustomer();
        try {
            dbIndukCustomer = new DbIndukCustomer(0);
        } catch (Exception e) {
        }
        jspIndukCustomer = new JspIndukCustomer(request);
    }

    public String getErrMessage(int errCode) {
        switch (errCode) {
            case JSPMessage.ERR_DELETED:
                return "Can't Delete IndukCustomer";
            case JSPMessage.ERR_SAVED:
                if (jspIndukCustomer.getFieldSize() > 0) {
                    return "Can't save induk customer, because some required data are incomplete ";
                } else {
                    return "Can't save indukCustomer, Duplicate indukCustomer ID, please type another indukCustomer ID";
                }
            default:
                return "Can't save indukCustomer";
        }
    }

    public IndukCustomer getIndukCustomer() {
        return indukCustomer;
    }

    public JspIndukCustomer getForm() {
        return jspIndukCustomer;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    /*
     * return this.start
     **/
    public int actionList(int listCmd, int start, int vectSize, int recordToGet) {
        msgString = "";

        switch (listCmd) {
            case JSPCommand.FIRST:
                this.start = 0;
                break;

            case JSPCommand.PREV:
                this.start = start - recordToGet;
                if (start < 0) {
                    this.start = 0;
                }
                break;

            case JSPCommand.NEXT:
                this.start = start + recordToGet;
                if (start >= vectSize) {
                    this.start = start - recordToGet;
                }
                break;

            case JSPCommand.LAST:
                int mdl = vectSize % recordToGet;
                if (mdl > 0) {
                    this.start = vectSize - mdl;
                } else {
                    this.start = vectSize - recordToGet;
                }

                break;

            default:
                this.start = start;
                if (vectSize < 1) {
                    this.start = 0;
                }

                if (start > vectSize) {
                    // set to last
                    mdl = vectSize % recordToGet;
                    if (mdl > 0) {
                        this.start = vectSize - mdl;
                    } else {
                        this.start = vectSize - recordToGet;
                    }
                }
                break;
        } //end switch
        return this.start;
    }

    public int action(int cmd, long oidIndukCustomer) {
        long oid = 0;
        int errCode = -1;
        
        int excCode = 0;

        msgString = "";
        switch (cmd) {

            case JSPCommand.ADD:

                break;

            case JSPCommand.SAVE:

                if (oidIndukCustomer != 0) {
                    try {
                        indukCustomer = DbIndukCustomer.fetch(oidIndukCustomer);
                    } catch (Exception e) {

                    }
                }

				
                jspIndukCustomer.requestEntityObject(indukCustomer);
					
                if (jspIndukCustomer.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return JSPMessage.MSG_INCOMPLATE;
                }else{
                	boolean bool = DbIndukCustomer.checkNama(oidIndukCustomer, indukCustomer.getName());
                	if(bool){
                		jspIndukCustomer.addError(JspIndukCustomer.JSP_NAME,"Nama sudah ada");
                		
	                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
	                    return JSPMessage.MSG_INCOMPLATE;
                	}
                }
                
                try {
                    if (indukCustomer.getOID() == 0) {
                        oid = DbIndukCustomer.insert(this.indukCustomer);
							
                    } else {
                        oid = DbIndukCustomer.update(this.indukCustomer);
                    }
                    
                    System.out.println("oid : "+oid);
                    
                    if (oid == 0) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                        errCode = JSPMessage.ERR_SAVED;
                    } else {
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                    }

                }
                catch(CONException dbexc){
					excCode = dbexc.getErrorCode();
					//msgString = getSystemMessage(excCode);
					//return getControlMsgId(excCode);
				}catch (Exception exc){
					//msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					//return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
				}

                break;

            case JSPCommand.EDIT:                
                
                if (oidIndukCustomer != 0) {
                    try{
                        indukCustomer = (IndukCustomer)dbIndukCustomer.fetch(oidIndukCustomer);
                    }catch(Exception E){}
                }
                break;

            case JSPCommand.ASK:

                if (oidIndukCustomer != 0) {
                    try{
                        indukCustomer = (IndukCustomer) dbIndukCustomer.fetch(oidIndukCustomer);
                        msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                    }catch(Exception E){}
                }
                break;

            case JSPCommand.DELETE:
                
                if (oidIndukCustomer!= 0) {

                        DbIndukCustomer dbIndukCustomer = new DbIndukCustomer();
                        try{
                            oid = dbIndukCustomer.delete(oidIndukCustomer);
                        }catch(Exception E){}
                        if (oid == JSPMessage.NONE) {
                            msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                            errCode = JSPMessage.ERR_DELETED;
                        } else {
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                        }
                    
                }
                
                break;

            default:

        }//end switch
        return excCode;
    }
}
