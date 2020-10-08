/*
 * OXYRemotePrintTarget.java
 *
 * Created on July 18, 2003, 11:07 AM
 */

package com.project.printman;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.MalformedURLException;
import java.util.*;
import java.net.InetAddress;

/** Unicast remote object implementing java.rmi.Remote interface.
 *
 * @author ktanjana
 * @version 1.0
 * Copyright : PT. project Sora Jayate , 2003
 *
 * Note :
 * - java.policy on JAVA_HOME has to be set to All Permision ( FOR NEXT FUTURE HAS TO BE DEFINED MORE SECURE )
 * - comm.jar has to be remove from <java home>/jre/lib/ext
 * - modified comm classes will be used instead of comm.jar
 */

public class RemotePrintTarget extends java.rmi.server.UnicastRemoteObject implements I_OXY_PrintTarget {
    private static OXY_PrinterService prnSvc = null;;
    private static Thread printThr = null;
    private static PrinterHost myHost= new PrinterHost();
    public static  PrinterHost printManSvcHost = new PrinterHost();
    static{
        printManSvcHost.setHostName("?");
        printManSvcHost.setHostIP("");
        printManSvcHost.setPort(1099);
        printManSvcHost.setRMIObjName("PrintManSvc");
        
    }
    
    /** Constructs OXYRemotePrintTarget object and exports it on default port.
     */
    public RemotePrintTarget() throws RemoteException {
        super();
        initPrintSvc();
    }
    
    /** Constructs OXYRemotePrintTarget object and exports it on specified port.
     * @param port The port for exporting
     */
    public RemotePrintTarget(int port) throws RemoteException {
        super(port);
        initPrintSvc();
    }
    
    private void initPrintSvc(){
        if(prnSvc==null){
            prnSvc = OXY_PrinterService.getInstance();
            printThr=new Thread(prnSvc);
            prnSvc.running = true;
            printThr.setDaemon(false);
            printThr.start();
            System.out.println("Print Thread New Initialized");
        }
    }
    
    /** Register OXYRemotePrintTarget object with the RMI registry.
     * @param name - name identifying the service in the RMI registry
     * @param create - create local registry if necessary
     * @throw RemoteException if cannot be exported or bound to RMI registry
     * @throw MalformedURLException if name cannot be used to construct a valid URL
     * @throw IllegalArgumentException if null passed as name
     */
    public static void registerToRegistry(String name, Remote obj, boolean create) throws RemoteException, MalformedURLException{
        
        if (name == null) throw new IllegalArgumentException("registration name can not be null");
        
        try {
            Naming.rebind(name, obj);
        } catch (RemoteException ex){
            if (create) {
                unRegistered(name);
                Registry r = LocateRegistry.createRegistry(Registry.REGISTRY_PORT);
                r.rebind(name, obj);
            } else throw ex;
        }
    }
    
    /** Main method.
     * starting arguments :   <host name> < host IP> < rmi port > <rmi object>
     */
    public static void main(String[] args) {
        //System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null); 
        
        try {
            System.out.println("l="+args.length);
            if((args!=null) && (args.length>0)){
                if(args[0].equalsIgnoreCase("help")){
                    System.out.println("<host name> < host IP> < rmi port > <rmi object> <Ip of Remote Management Service> " );
                    System.out.println("OR \n <Ip of Remote Management Service> " );
                    return;
                }
                
                switch (args.length){
                    
                    case 1 :{
                        InetAddress myInet = InetAddress.getLocalHost();
                        myHost.setHostName(myInet.getHostName());
                        myHost.setHostIP(myInet.getHostAddress());
                        myHost.setPort(1099);
                        myHost.setRMIObjName("RemotePrintTarget");
                        printManSvcHost.setHostIP(new String(args[0]));
                        break;
                    }
                    
                    case 4: {
                        myHost.setHostName(new String(args[0]));
                        myHost.setHostIP(new String(args[1]));
                        myHost.setPort(Integer.parseInt(new String(args[2])));
                        myHost.setRMIObjName(new String(args[3]));
                        printManSvcHost.setHostIP("");
                        break;
                    }
                    
                    case 5: {
                        myHost.setHostName(new String(args[0]));
                        myHost.setHostIP(new String(args[1]));
                        myHost.setPort(Integer.parseInt(new String(args[2])));
                        myHost.setRMIObjName(new String(args[3]));
                        printManSvcHost.setHostIP(new String(args[4]));
                        break;
                    }
                    default:
                        System.out.println("run with parameter: RemotePrintTarget  help   to get options " );
                        return;
                }
            } else {
                InetAddress myInet = InetAddress.getLocalHost();
                myHost.setHostName(myInet.getHostName());
                myHost.setHostIP(myInet.getHostAddress());
                myHost.setPort(1099);
                myHost.setRMIObjName("RemotePrintTarget");
                printManSvcHost.setHostIP(""); // no remote management service / stand alone
            }
            
            System.out.println("project(r) RemotePrintTarget Version 0.1 (C) 2003\n "
            + "Start with default parameters :" + myHost.getHostName() + " "
            + myHost.getHostIP()+ " " + myHost.getPort() + " " + myHost.getRMIObjName());
            String manHost = printManSvcHost.getHostIP(); 
            if((manHost!=null) && (manHost.length()>0)){
                System.out.println(" >>>>> HOST MAN SVC = " + printManSvcHost.getHostIP() );
            } else {
                System.out.println(" >>>>> STANDALONE <<<<< ");                
            }
            try{
                OXY_PrinterXML dummy = new OXY_PrinterXML();   // to initiate loadPrinters();
            } catch (Exception exc){
                System.out.println(" >> reloadLisfOfPrinter "+ exc);
            }
            
            myHost.setListOfPrinters(OXY_PrinterXML.getListPrinter());
            if( (printManSvcHost.getHostIP()!=null) && (printManSvcHost.getHostIP().length()>0))
                regToPrinterManSvc();
            
            System.out.println("Start Remote Printer");
            RemotePrintTarget obj = new RemotePrintTarget();            
            registerToRegistry("RemotePrintTarget", obj, true);
            System.out.println("RemotePrintTarget Object Registered");
            
        } catch (RemoteException ex) {
            ex.printStackTrace();
        } catch (MalformedURLException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        
    }
    
    public int printObj(OXY_PrintObj ObjPrint) throws java.rmi.RemoteException {
        //prnSvc = OXY_PrinterService.getInstance();
        initPrintSvc();
        prnSvc.print(ObjPrint);
        //prnSvc.running = true;
        //prnSvc.run_x();
        
        //PrinterDriverLoader prLd = new PrinterDriverLoader(ObjPrint);
        //prLd.printObject(ObjPrint);
        
        return  prnSvc.getStatusPrnDriverLoader(ObjPrint.getPrnIndex());
    }
    
    /** Hello method usually returns "Hello".
     */
    public String hello() throws java.rmi.RemoteException {
        System.out.println("Remote client greeting me !");
        return "Hello remote Client";
    }
    
    public void stopPrintSvc() throws java.rmi.RemoteException{
        prnSvc.running = false;
        prnSvc = null;;
        printThr = null;
        System.out.println("Remote client Stop Print Svc !");
    }
    
    
    public Vector getLisfOfPrinter() throws java.rmi.RemoteException{
        return OXY_PrinterXML.getListPrinter();
    }
    
    public Vector reloadLisfOfPrinter() throws java.rmi.RemoteException{
        try{ OXY_PrinterXML.loadPrinters();
        } catch (Exception exc){
            System.out.println(" >> reloadLisfOfPrinter "+ exc);
        }
        return OXY_PrinterXML.getListPrinter();
    }
    
    
    public Vector getStatusOfPrinter() throws java.rmi.RemoteException{
        Vector prn=OXY_PrinterXML.getListPrinter();
        if( (prn!=null) && (prn.size()>0)){
            for(int i=0;i<prn.size();i++){
                PrnConfig pc = (PrnConfig) prn.get(i);
                pc.setPrnStatus(OXY_PrinterService.getStatusPrnDriverLoader(pc.getPrnIndex()));
            }
        }
        return prn;
    }
    
    public int pausePrint(PrnConfig prn) throws java.rmi.RemoteException{
        return OXY_PrinterService.pausePrint(prn);
        
    }
    
    public int resumePrint(PrnConfig prn) throws java.rmi.RemoteException{
        return OXY_PrinterService.resumePrint(prn);
    }
    
    public int cancelPrint(PrnConfig prn) throws java.rmi.RemoteException{
        return OXY_PrinterService.cancelPrint(prn);
    }
    
    public static void regToPrinterManSvc(){
        try{
            
            
            //System.setSecurityManager(new RMISecurityManager());
            System.setSecurityManager(null);
            
            String nameLookUp = "//"+printManSvcHost.getHostIP()+":"+printManSvcHost.getPort()+"/"+printManSvcHost.getRMIObjName();
            I_OXY_PrintMan prnManSvc = (I_OXY_PrintMan) Naming.lookup(nameLookUp);
            prnManSvc.setPrinterHost(myHost);
            System.out.println("Printers are registered to :"+ nameLookUp);
        }catch (Exception e){
            System.out.println(" CANNOT CONTACT PRINT MANAGEMENT SVC \n EXCP : "+e);
        }
        
    }
    
    public static void unRegistered(String name){
        if (name == null) throw new IllegalArgumentException("registration name can not be null");
        try{
            Registry r = LocateRegistry.getRegistry(Registry.REGISTRY_PORT);
            r.unbind(name);            
        }catch(RemoteException ex){
            System.out.println("ERR AT UNREGISTERED : "+ex.toString());
            ex.printStackTrace();
        }catch(Exception ex){
            System.out.println("ERR AT UNREGISTERED : "+ex.toString());
            ex.printStackTrace();
        }
    }
}
