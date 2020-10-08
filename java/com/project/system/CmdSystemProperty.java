
package com.project.system;

import javax.servlet.*;
import javax.servlet.http.*;

import com.project.util.*;

import com.project.main.entity.*;
import com.project.system.*;

import com.project.util.jsp.*;
import com.project.system.*;
import com.project.system.*;

public class CmdSystemProperty {

    private int msgCode = 0;
    private long rsCode = 0;
    private String msgString;
        
    private SystemProperty sysProp;
    private DbSystemProperty dbSystemProperty;
    private JspSystemProperty jspSystemProperty;
    
    
    public CmdSystemProperty(HttpServletRequest request) {
        msgString = "";        
        sysProp = new SystemProperty(); 
        try{
            dbSystemProperty = new DbSystemProperty(0);
        }catch(Exception e){}
        jspSystemProperty = new JspSystemProperty(request, sysProp);
    }
    

    public SystemProperty getSystemProperty() {
        return sysProp;
    }
    

    public JspSystemProperty getForm() {
        return jspSystemProperty;
    }
    
    
    public String getMessage(){
        return JSPMessage.getMessage(msgCode);
    }

        
    public int getMsgCode(){
        return msgCode;
    }

   
    public void action(int cmd, long oid) {
        action(cmd, oid, null);
    }
    
    public void action(int cmd, long oid, HttpServletRequest req)
    {
        rsCode = 0;
        msgString = "";        
        switch(cmd){ 
            case JSPCommand.SAVE :
                jspSystemProperty.requestEntityObject(sysProp);
                
                System.out.println("*** errSize : " + jspSystemProperty.errorSize());
                if(jspSystemProperty.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return;
                }                
                
                if(oid == 0) {
                    rsCode = dbSystemProperty.insert(sysProp);
                } else {
                    sysProp.setOID(oid);
                    rsCode = dbSystemProperty.update(sysProp);
                }


                if(rsCode == JSPMessage.NONE){
                    if (oid == 0)
                    	msgCode = JSPMessage.ERR_SAVED;
                	else
                        msgCode = JSPMessage.ERR_UPDATED;
                }else{
                    if (oid == 0)
                    	msgCode = JSPMessage.MSG_SAVED;
                	else
                        msgCode = JSPMessage.MSG_UPDATED;
                }

                break;
            
            case JSPCommand.EDIT :
                sysProp = DbSystemProperty.fetch(oid);
                jspSystemProperty.setEntityObject(sysProp);
                break;
            

            case JSPCommand.UPDATE : // update value only                                
                String newValue = JSPRequestValue.requestString(req, JspSystemProperty.fieldNames[JspSystemProperty.JSP_VALUE]);
                
                if(newValue.trim().length() == 0) {
                    jspSystemProperty.addError(JspSystemProperty.JSP_VALUE, " <<");
                }else{
                    SystemProperty sp = DbSystemProperty.fetch(oid);
                    sp.setValue(newValue);
                    rsCode = DbSystemProperty.update(sp);                    
                }
                               
                if(rsCode == JSPMessage.NONE) {
                    msgString = JSPMessage.getErr(JSPMessage.ERR_UPDATED);
                }else {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_UPDATED);
                }                
                break;

            
            case JSPCommand.ASK:                
                msgCode = JSPMessage.MSG_ASKDEL;
                msgString = JSPMessage.getMsg(JSPMessage.MSG_ASKDEL);
                break;

                
            case JSPCommand.DELETE :    
                rsCode = DbSystemProperty.delete(oid);
                break;

            case JSPCommand.LOAD :    
                QrSystemProperty sysProp = new QrSystemProperty();
                //sysProp.loadFromDB();
                break;
            
            default:
                
        }//end switch
    }
    
 
}
