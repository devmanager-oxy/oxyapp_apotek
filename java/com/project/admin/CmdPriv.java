

package com.project.admin;



import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import java.util.*;
import com.project.admin.*;
import com.project.admin.*;
import com.project.util.jsp.*;

public class CmdPriv {
    
    private String msgString;
    private int start;
    private Priv appPriv;
    private DbPriv pstPriv;
    private JspPriv frmPriv;
    
    /** Creates new CtrlPriv */
    public CmdPriv(HttpServletRequest request) {
        msgString = "";
        // errCode = Message.OK;
        
        appPriv = new Priv();
        try{
            pstPriv = new DbPriv(0);
        }catch(Exception e){}
        frmPriv = new JspPriv(request);
    }
    
    
    public Priv getPriv() {
        return appPriv;
    }
    
    public JspPriv getForm() {
        return frmPriv;
    }
    
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    public int action(int cmd, long appPrivOID, int start, int vectSize, int recordToGet) {
        msgString = "";
        int excCode = 0;
        switch(cmd){
            case JSPCommand.ADD :
                appPriv.setPrivName("");
                appPriv.setRegDate(new Date());
                break;
                
            case JSPCommand.SAVE :
                frmPriv.requestEntityObject(appPriv);
                appPriv.setOID(appPrivOID);
                
                System.out.println("*** errSize : " + frmPriv.errorSize());
                
                if(frmPriv.errorSize() > 0) {
                    excCode = JSPMessage.MSG_INCOMPLATE;
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return excCode;
                }
                
                long rsCode = 0;
                if (appPriv.getOID() == 0){
                    rsCode = DbPriv.insert(this.appPriv);
                }
                else
                    rsCode = DbPriv.update(this.appPriv);
                    this.start = start;
                if(rsCode == JSPMessage.NONE){
                    excCode = JSPMessage.ERR_SAVED;
                    msgString = JSPMessage.getErr(excCode);
                }else
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                
                break;
                
            case JSPCommand.EDIT :
                if (appPrivOID != 0){
                    appPriv = (Priv)pstPriv.fetch(appPrivOID);
                }
                break;
                
            case JSPCommand.ASK :
                if (appPrivOID !=0 ){
                    appPriv = (Priv)pstPriv.fetch(appPrivOID);
                    excCode = JSPMessage.MSG_ASKDEL;
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;
                
            case JSPCommand.DELETE :
                if (appPrivOID != 0){
                    rsCode = DbPrivilegeObj.deleteByPrivOID(appPrivOID);
                    if(rsCode == JSPMessage.NONE)
                        msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                    else{
                        rsCode = DbGroupPriv.deleteByPriv(appPrivOID);
                        if(rsCode == JSPMessage.NONE)
                            msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                        else{                                            
                            DbPriv pstPriv = new DbPriv();
                            rsCode = pstPriv.delete(appPrivOID);

                            if(rsCode == JSPMessage.NONE)
                                msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                            else
                                msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                        }
                    }
                    
                }
                break;
                
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
                
        }//end switch
        return excCode;
    }
    
}
