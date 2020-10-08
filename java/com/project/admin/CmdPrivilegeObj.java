

package com.project.admin;


import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import java.util.*;
import com.project.admin.*;
import com.project.admin.*;
import com.project.util.jsp.*;

public class CmdPrivilegeObj {

    private String msgString;
    private int start;
    private PrivilegeObj appPrivObj;
    private DbPrivilegeObj pstcolNamesPrivObj;
    private JspPrivilegeObj frmcolNamesPrivObj;
    
    /** Creates new CtrlcolNamesPriv */
    public CmdPrivilegeObj(HttpServletRequest request) {
        msgString = "";
        // errCode = Message.OK;
        
        appPrivObj = new PrivilegeObj();
        try{
            pstcolNamesPrivObj = new DbPrivilegeObj(0);
        }catch(Exception e){}
        frmcolNamesPrivObj = new JspPrivilegeObj(request);
    }
    
    
    public PrivilegeObj getPrivObj() {
        return appPrivObj;
    }
    
    public JspPrivilegeObj getForm() {
        return frmcolNamesPrivObj;
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
    
    
    
    public int action(int cmd, long appPrivObjOID) {
        msgString = "";
        int excCode = 0;
        switch(cmd){
            case JSPCommand.ADD :
                appPrivObj.setPrivId(0);
                appPrivObj.setCode(0);
                appPrivObj.setPrivObjId(0);
                appPrivObj.setCode(0);
                appPrivObj.setCommands(new Vector(1,1));
                break;
                
            case JSPCommand.SAVE :
                frmcolNamesPrivObj.requestEntityObject(appPrivObj);
                appPrivObj.setOID(appPrivObjOID);
                
                System.out.println("*** errSize : " + frmcolNamesPrivObj.errorSize());
                
                if( (frmcolNamesPrivObj.errorSize() > 0) || (appPrivObj.getCommandsSize()<1)) {
                    excCode = JSPMessage.MSG_INCOMPLATE;
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return excCode;
                }
                
                long rsCode = 0;
                if (appPrivObj.getOID() ==0 ){
                    
                    rsCode = DbPrivilegeObj.insert(this.appPrivObj);
                    
                    /* to get the start number of list last */
                    /*
                    int mdl = (vectSize+1)  % recordToGet;
                    if(mdl>0){
                        this.start = (vectSize+1)  - mdl;
                    }
                    else{
                        this.start = (vectSize+1) - recordToGet;
                    }
                     **/
                }
                else
                    rsCode = DbPrivilegeObj.update(this.appPrivObj);
                
                if(rsCode == JSPMessage.NONE){
                    msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
               		excCode = JSPMessage.ERR_SAVED;
                }else
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                
                break;
                
            case JSPCommand.EDIT :
                
                if (appPrivObjOID != 0){
                    appPrivObj = (PrivilegeObj)pstcolNamesPrivObj.fetch(appPrivObjOID);
                }
                break;
                
            case JSPCommand.ASK :
                
                if (appPrivObjOID != 0){
                    appPrivObj = (PrivilegeObj)pstcolNamesPrivObj.fetch(appPrivObjOID);
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;
                
            case JSPCommand.DELETE :
                
                if (appPrivObjOID != 0){

                    DbPrivilegeObj pstcolNamesPrivObj = new DbPrivilegeObj();

                    appPrivObj = (PrivilegeObj)pstcolNamesPrivObj.fetch(appPrivObjOID);

                    rsCode = pstcolNamesPrivObj.deleteByPrivOIDObjCode(appPrivObj.getPrivId() , appPrivObj.getCode() );
                    
                    if(rsCode == JSPMessage.NONE)
                        msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                    else
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                }
                break;
                
                
            default:
                
        }//end switch
        return excCode;
    }
    
}
