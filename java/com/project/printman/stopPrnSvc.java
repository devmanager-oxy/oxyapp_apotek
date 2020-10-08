/*
 * stopPrnSvc.java
 *
 *  Created on July 19, 2003, 9:16 AM
 */

package com.project.printman;

import java.rmi.*;

/**
 *
 * @author ktanjana
 * @version 1.0
 */
public class stopPrnSvc extends Object {

    /** Creates new stopPrnSvc */
    public stopPrnSvc() {
    }

    /**
    * @param args the command line arguments
    */
    public static void main (String args[]) {
        //System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget myrmt=null;
        String host="localhost";
        try{
            host = args[0];
        } catch(Exception e){}
                try{
                    
             
            if(host==null)
                host="localhost";
            System.out.println(" HOST " + host);
            
            myrmt = (I_OXY_PrintTarget) Naming.lookup("//"+host+":1099/RemotePrintTarget");
            String rslt = "";
            rslt = myrmt.hello();
            System.out.println(rslt);
            myrmt.stopPrintSvc();            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }        
    }
}
