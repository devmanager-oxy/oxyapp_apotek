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
import com.project.system.DbSystemProperty;
import com.project.util.jsp.*;

public class CmdCustomer extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}};
    
    private String msgString;
    private int start;
    private Customer customer;
    private DbCustomer dbCustomer;
    private JspCustomer jspCustomer;

    /** Creates new CtrlUser */
    public CmdCustomer(HttpServletRequest request) {
        msgString = "";
        customer = new Customer();
        try {
            dbCustomer = new DbCustomer(0);
        } catch (Exception e) {
        }
        jspCustomer = new JspCustomer(request);
    }

    public String getErrMessage(int errCode) {
        switch (errCode) {
            case JSPMessage.ERR_DELETED:
                return "Can't Delete Customer";
            case JSPMessage.ERR_SAVED:
                if (jspCustomer.getFieldSize() > 0) {
                    return "Can't save custumer, because some required data are incomplete ";
                } else {
                    return "Can't save customer, Duplicate customer ID, please type another customer ID";
                }
            default:
                return "Can't save customer";
        }
    }

    public Customer getCustomer() {
        return customer;
    }

    public JspCustomer getForm() {
        return jspCustomer;
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

    public int action(int cmd, long oidCustomer) {
        long oid = 0;
        //int errCode = -1;
        int excCode = 0;
        msgString = "";

        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SUBMIT:

                if (oidCustomer != 0) {
                    try {
                        customer = DbCustomer.fetchExc(oidCustomer);
                    } catch (Exception e) {
                    }
                }

                jspCustomer.requestEntityObject(customer);

                break;

            case JSPCommand.SAVE:

                if (oidCustomer != 0) {
                    try {
                        customer = DbCustomer.fetchExc(oidCustomer);
                    } catch (Exception e) {

                    }
                }

                String genCodeMember = "N";
                try {
                    genCodeMember = DbSystemProperty.getValueByName("GENERATE_CODE_MEMBER_AUTOMATIC");
                } catch (Exception e) {
                }

                jspCustomer.requestEntityObject(customer);

                if (jspCustomer.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return JSPMessage.MSG_INCOMPLATE;
                }
                try {
                    if (customer.getOID() == 0) {

                        SystemDocNumber systemDocNumber = new SystemDocNumber();

                        if (genCodeMember.equalsIgnoreCase("Y")) {
                            String formatDocCode = "";
                            int counter = 0;

                            formatDocCode = DbCustomer.getPrefix(new Date());
                            counter = DbCustomer.getNextCounter(formatDocCode);
                            // proses untuk object ke general penanpungan code

                            systemDocNumber.setCounter(counter);
                            systemDocNumber.setDate(new Date());
                            systemDocNumber.setPrefixNumber(formatDocCode);
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_CUSTOMER]);

                            systemDocNumber.setYear(new Date().getYear() + 1900);
                            formatDocCode = DbCustomer.getNumber(formatDocCode, counter);
                            systemDocNumber.setDocNumber(formatDocCode);
                            customer.setCode(formatDocCode);
                        }
                        this.customer.setRegDate(new Date());
                        oid = DbCustomer.insert(this.customer);
                        if (genCodeMember.equalsIgnoreCase("Y")) {
                            if (oid != 0) {
                                try {
                                    DbSystemDocNumber.insertExc(systemDocNumber);
                                } catch (Exception E) {
                                    System.out.println("[exception] " + E.toString());
                                }
                            }
                        }
                    } else {
                        oid = DbCustomer.update(this.customer);
                    }

                    if (oid == 0) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                    } else {
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                    }

                } catch (CONException exc) {
                    excCode = exc.getErrorCode();
                    msgString = getErrMessage(excCode);
                }

                break;

            case JSPCommand.EDIT:

                if (oidCustomer != 0) {
                    try {
                        customer = (Customer) dbCustomer.fetchExc(oidCustomer);
                    } catch (Exception E) {
                    }
                }
                break;

            case JSPCommand.ASK:

                if (oidCustomer != 0) {
                    try {
                        customer = (Customer) dbCustomer.fetchExc(oidCustomer);
                        msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                    } catch (Exception E) {
                    }
                }
                break;

            case JSPCommand.DELETE:

                if (oidCustomer != 0) {
                    DbCustomer dbCustomer = new DbCustomer();
                    try {
                        oid = dbCustomer.delete(oidCustomer);
                    } catch (Exception E) {
                    }
                    if (oid == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
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
