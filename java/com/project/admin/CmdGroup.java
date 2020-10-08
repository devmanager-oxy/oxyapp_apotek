
package com.project.admin;



import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import java.util.*;
import com.project.util.jsp.*;

public class CmdGroup {
    
    private String msgString;
    private int start;
    private Group appGroup;
    private DbGroup dbGroup;
    private JspGroup frmGroup;
    
    /** Creates new CtrlGroup */
    public CmdGroup(HttpServletRequest request) {
        msgString = "";
        // errCode = Message.OK;
        
        appGroup = new Group();
        try{
            dbGroup = new DbGroup(0);
        }catch(Exception e){}
        frmGroup = new JspGroup(request);
    }
    
    
    public Group getGroup() {
        return appGroup;
    }
    
    public JspGroup getForm() {
        return frmGroup;
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
        
        switch(listCmd){                
            case JSPCommand.FIRST :                
                this.start = 0;
                break;
                
            case JSPCommand.PREV :                
                this.start = start - recordToGet;
                if(start < 0){
                    this.start = 0;
                }                
                break;
                
            case JSPCommand.NEXT :
                this.start = start + recordToGet;
                if(start >= vectSize){
                    this.start = start - recordToGet;
                }                
                break;
                
            case JSPCommand.LAST :
                int mdl = vectSize % recordToGet;
                if(mdl>0){
                    this.start = vectSize - mdl;
                }
                else{
                    this.start = vectSize - recordToGet;
                }                
                
                break;
                
            default:
                this.start = start;
                if(vectSize<1)
                    this.start = 0;                
                
                if(start > vectSize){
                    // set to last
                     mdl = vectSize % recordToGet;
                    if(mdl>0){
                        this.start = vectSize - mdl;
                    }
                    else{
                        this.start = vectSize - recordToGet;
                    }                
                }                
                break;
        } //end switch
        return this.start;
    }
    
    public int action(int cmd, long appGroupOID) {
        msgString = "";
        int excCode = 0;
        switch(cmd){
            case JSPCommand.ADD :
                appGroup.setGroupName("");
                appGroup.setRegDate(new Date());
                break;
                
            case JSPCommand.SAVE :
                
                if(appGroupOID!=0){
                    try{
                        appGroup = DbGroup.fetch(appGroupOID);
                    }
                    catch(Exception e){
                    }
                }
                
                frmGroup.requestEntityObject(appGroup);                
                appGroup.setOID(appGroupOID);
                                
                if(DbGroup.isGroupExist(appGroup.getGroupName(), appGroupOID)){                    
                    msgString = "Can't save data, group name already exist";
                    return excCode;
                }
                
                if(frmGroup.errorSize() > 0) {
                    excCode = JSPMessage.MSG_INCOMPLATE;
                    msgString = JSPMessage.getMsg(excCode);
                    return excCode;
                }
                
                long rsCode = 0;
                if (appGroup.getOID() == 0)
                    rsCode = DbGroup.insert(this.appGroup);
                else
                    rsCode = DbGroup.update(this.appGroup);
                
                if(rsCode == JSPMessage.NONE){
                    	excCode= JSPMessage.ERR_SAVED;
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                }
                else{                    
                    Vector groupPriv = this.frmGroup.getGroupPriv(this.appGroup.getOID());
                    
                    if(QrGroup.setGroupPriv(this.appGroup.getOID(), groupPriv))                    
                        msgString = JSPMessage.getMsg(JSPMessage.ERR_SAVED);
                    else {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_UNKNOWN);
                    	excCode=0;
                    }
                }
                
                break;
                
            case JSPCommand.EDIT :
                
                if (appGroupOID !=0 ){
                    appGroup = (Group)dbGroup.fetch(appGroupOID);
                }
                break;
                
            case JSPCommand.ASK :
                
                if (appGroupOID != 0){
                    appGroup = (Group)dbGroup.fetch(appGroupOID);
                    excCode = JSPMessage.MSG_ASKDEL;
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;
                
            case JSPCommand.DELETE :
                
                if (appGroupOID != 0){
                    
                    rsCode = DbGroupPriv.deleteByGroup(appGroupOID);
                    if(rsCode == JSPMessage.NONE){
                        excCode = JSPMessage.ERR_DELETED;
                        msgString = JSPMessage.getErr(excCode);
                    }
                    else{

                        DbGroup dbGroup = new DbGroup();
                        rsCode = dbGroup.delete(appGroupOID);
                        if(rsCode == JSPMessage.NONE){
                            excCode = JSPMessage.ERR_DELETED;
                            msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                        }else
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                    }
                }
                break;
                                
            default:
                
        }//end switch
        return excCode;
    }
    
}
