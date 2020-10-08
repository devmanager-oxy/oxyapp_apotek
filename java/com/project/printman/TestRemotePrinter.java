
package com.project.printman;
/*
 * @author ktanjana
 * @version 1.0
 * Copyright : PT. project Sora Jayate , 2003
 */

import java.rmi.*;

/**
 *
 * @author ktanjana
 * @version 1.0
 */
public class TestRemotePrinter extends Object {
    
    /** Creates new TestRemotePrinter */
    public TestRemotePrinter() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        //RemotePrintMan.getPrinterList(
        //testPrn(args);
        String hostIpIdx = "127.0.0.1;1";
        System.out.println("Print on "+hostIpIdx);
        if(hostIpIdx!=null){
            PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx,";");
            PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx,";");
            OXY_PrintObj obj= TestPrn.getTestObj();
            obj.setPrnIndex(prn.getPrnIndex());
            RemotePrintMan.printObj(prnHost,obj );
        }        
    }
    
    public static void testPrn(String args[]){
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
            
            OXY_PrintObj obj= TestPrn.getTestObj();
            myrmt.printObj(obj);
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        try{
            System.out.println("Press Any Key");
            //int i = System.in.read();
            //myrmt.stopPrintSvc();
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        
    }
}
