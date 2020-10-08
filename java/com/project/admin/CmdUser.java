package com.project.admin;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.system.DbSystemProperty;
import com.project.util.jsp.*;

public class CmdUser {

    private String msgString;
    private int start;
    private User appUser;
    private DbUser pstUser;
    private JspUser frmUser;

    /** Creates new CtrlUser */
    public CmdUser(HttpServletRequest request) {
        msgString = "";
        // errCode = Message.OK;

        appUser = new User();
        try {
            pstUser = new DbUser(0);
        } catch (Exception e) {
        }
        frmUser = new JspUser(request);
    }

    public String getErrMessage(int errCode) {
        switch (errCode) {
            case JSPMessage.ERR_DELETED:
                return "Can't Delete User";
            case JSPMessage.ERR_SAVED:
                if (frmUser.getFieldSize() > 0) {
                    return "Can't save user, cause some required data are incomplete ";
                } else {
                    return "Can't save user, Duplicate login ID, please type another login ID";
                }
            default:
                return "Can't save user";
        }
    }

    public User getUser() {
        return appUser;
    }

    public JspUser getForm() {
        return frmUser;
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

    public int action(int cmd, long appUserOID) {
        long rsCode = 0;
        int errCode = -1;        
        int excCode = 0;
        msgString = "";
        switch (cmd) {
            case JSPCommand.ADD:
                appUser.setLoginId("");
                appUser.setRegDate(new Date());
                break;

            case JSPCommand.SAVE:

                if (appUserOID != 0) {
                    try {
                        appUser = DbUser.fetch(appUserOID);
                    } catch (Exception e) {
                    }
                }

                int userLevel = appUser.getUserLevel();

                frmUser.requestEntityObject(appUser);
                appUser.setOID(appUserOID);

                if (appUserOID != 0 && userLevel == DbUser.LEVEL_SYSTEM_ADMINISTRATOR) {
                    appUser.setUserLevel(DbUser.LEVEL_SYSTEM_ADMINISTRATOR);
                }

                int count = DbUser.getCountUser(appUser.getOID(),appUser.getLoginId(),appUser.getPassword());                
                if(count > 0){
                    frmUser.addError(frmUser.JSP_LOGIN_ID, "Please change");                    
                    msgString = "Can't save user, login id or password already exist";
                    return JSPMessage.MSG_INCOMPLATE;
                }

                try {
                    
                    String sysPswd = "N";
                    try{
                        sysPswd = DbSystemProperty.getValueByName("SYS_MD5");
                    }catch(Exception e){}
                    
                    if(sysPswd.equals("Y")){
                        //encrypt password using MD5 Hash
                        String md5Password = MD5.getMD5Hash(this.appUser.getPassword());
                        this.appUser.setPassword(md5Password);
                    }
                    
                    this.appUser.setResetPassword(false);
                    Employee emp = new Employee();
                    try{
                        emp = DbEmployee.fetchExc(this.appUser.getEmployeeId());
                        this.appUser.setFullName(emp.getName());
                        this.appUser.setEmployeeNum(emp.getEmpNum());
                    }catch(Exception e){}
                    
                    if (appUser.getOID() == 0) {
                        appUser.setRegDate(new Date());
                        rsCode = DbUser.insert(this.appUser);
                    } else {
                        appUser.setUpdateDate(new Date());
                        rsCode = DbUser.updateUser(this.appUser);
                    }

                    if (rsCode == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                        msgString = getErrMessage(excCode);
                        excCode = 0;
                    } else {
                        Vector userGroup = this.frmUser.getUserGroup(this.appUser.getOID());

                        if (QrUser.setUserGroup(this.appUser.getOID(), userGroup)) {
                            msgString = JSPMessage.getMsg(JSPMessage.ERR_SAVED);
                        } else {
                            msgString = JSPMessage.getErr(JSPMessage.ERR_UNKNOWN);
                            excCode = 0;
                        }
                    }

                } catch (CONException exc) {
                    excCode = exc.getErrorCode();
                    msgString = getErrMessage(excCode);
                }

                break;
                
            case JSPCommand.SUBMIT:

                if (appUserOID != 0) {
                    try {
                        appUser = DbUser.fetch(appUserOID);
                    } catch (Exception e) {
                    }
                }

                userLevel = appUser.getUserLevel();

                frmUser.requestEntityObject(appUser);
                appUser.setOID(appUserOID);

                if (appUserOID != 0 && userLevel == DbUser.LEVEL_SYSTEM_ADMINISTRATOR) {
                    appUser.setUserLevel(DbUser.LEVEL_SYSTEM_ADMINISTRATOR);
                }

                if (frmUser.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return JSPMessage.MSG_INCOMPLATE;
                }

                try {                    
                    this.appUser.setResetPassword(false);    
                    Employee emp = new Employee();
                    try{
                        emp = DbEmployee.fetchExc(this.appUser.getEmployeeId());
                        this.appUser.setFullName(emp.getName());
                        this.appUser.setEmployeeNum(emp.getEmpNum());
                    }catch(Exception e){}
                    
                    if (appUser.getOID() == 0) {
                        appUser.setRegDate(new Date());
                        rsCode = DbUser.insert(this.appUser);
                    } else {
                        appUser.setUpdateDate(new Date());
                        rsCode = DbUser.update(this.appUser);
                    }

                    if (rsCode == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                        msgString = getErrMessage(excCode);
                        excCode = 0;
                    } else {
                        Vector userGroup = this.frmUser.getUserGroup(this.appUser.getOID());

                        if (QrUser.setUserGroup(this.appUser.getOID(), userGroup)) {
                            msgString = JSPMessage.getMsg(JSPMessage.ERR_SAVED);
                        } else {
                            msgString = JSPMessage.getErr(JSPMessage.ERR_UNKNOWN);
                            excCode = 0;
                        }
                    }

                } catch (CONException exc) {
                    excCode = exc.getErrorCode();
                    msgString = getErrMessage(excCode);
                }

                break;    

            case JSPCommand.EDIT:

                if (appUserOID != 0) {
                    appUser = (User) pstUser.fetch(appUserOID);
                }
                break;

            case JSPCommand.ASK:

                if (appUserOID != 0) {
                    appUser = (User) pstUser.fetch(appUserOID);
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;

            case JSPCommand.DELETE:

                if (appUserOID != 0) {

                    rsCode = DbUserGroup.deleteByUser(appUserOID);
                    if (rsCode == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                        errCode = JSPMessage.ERR_DELETED;
                    } else {
                        DbUser pstUser = new DbUser();
                        rsCode = pstUser.delete(appUserOID);

                        if (rsCode == JSPMessage.NONE) {
                            msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                            errCode = JSPMessage.ERR_DELETED;
                        } else {
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                        }
                    }
                }
                break;

            default:

        }//end switch
        return excCode;
    }
}
