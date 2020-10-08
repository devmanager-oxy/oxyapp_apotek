/*
 * PrintManSvc.java
 *
 * Created on July 23, 2003, 7:51 PM
 */

package com.project.printman;

import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.MalformedURLException;
import java.util.*;

/** Unicast remote object implementing java.rmi.Remote interface.
 *
 * @version 1.0
 */
public class PrintManSvc extends java.rmi.server.UnicastRemoteObject implements I_OXY_PrintMan{
    public static int  manRMIPort = 1098;
    
    
    /** Constructs PrintManSvc object and exports it on default port.
     */
    public PrintManSvc() throws RemoteException {
        super();
    }
    
    /** Constructs PrintManSvc object and exports it on specified port.
     * @param port The port for exporting
     */
    public PrintManSvc(int port) throws RemoteException {
        super(port);
    }
    
    /** Register PrintManSvc object with the RMI registry.
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
                Registry r = LocateRegistry.createRegistry(Registry.REGISTRY_PORT);
                r.rebind(name, obj);
            } else throw ex;
        }
    }
    
    public static void initRMIPrinter(int port){
    	manRMIPort = port;
    	System.out.println("Port "+manRMIPort);
    	
        try {
            // initialization
            System.out.println("project(r) PrintManSvc Version 0.1 (C) 2003 ");
            
            //sayHelloToTarget();
            try{
                stReloadPrintersOnAllHost(); // host registered on xml file,
            }catch (Exception exc){
                exc.printStackTrace();
                System.out.println(" EXC at main reload printer : " + exc);
            } 
            
            
            PrintManSvc obj = new PrintManSvc(manRMIPort);
            registerToRegistry("PrintManSvc", obj, true);
            System.out.println("PrintManSvc Object Registered");
        } catch (RemoteException ex) {
            System.out.println("ERR MAIN : "+ex.toString());
            ex.printStackTrace();
        } catch (MalformedURLException ex) {
            System.out.println("ERR MAIN : "+ex.toString());
            ex.printStackTrace();
        }
    }
    
    
    /** Main method.
     */
    public  static void main(String[] args) {
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        try{
            if((args!=null) && (args.length>0)){
                manRMIPort = Integer.parseInt(args[0]);
                System.out.println("Port "+manRMIPort);
            }
        } catch (Exception e){
            System.out.println("Exc " + e + "\n" + " PARAMETER : [port]");
        }
        try {
            // initialization
            System.out.println("project(r) PrintManSvc Version 0.1 (C) 2003 ");
            
            //sayHelloToTarget();
            try{
                stReloadPrintersOnAllHost(); // host registered on xml file,
            }catch (Exception exc){
                exc.printStackTrace();
                System.out.println(" EXC at main reload printer : " + exc);
            } 
            
            
            PrintManSvc obj = new PrintManSvc(manRMIPort);
            registerToRegistry("PrintManSvc", obj, true);
            System.out.println("PrintManSvc Object Registered");
        } catch (RemoteException ex) {
            System.out.println("ERR MAIN : "+ex.toString());
            ex.printStackTrace();
        } catch (MalformedURLException ex) {
            System.out.println("ERR MAIN : "+ex.toString());
            ex.printStackTrace();
        }
    }
    
    
    public static void  sayHelloToTarget(){
        //System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        try{
            PrinterHost rmtPrnHost = new PrinterHost();
            rmtPrnHost.setHostIP("127.0.0.1");
            rmtPrnHost.setPort(1099);
            rmtPrnHost.setRMIObjName("RemotePrintTarget");
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println("getPrinterListWithStatus >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            
            System.out.println(prnTarget.hello());
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
    }
    
    
    /* Get list of printer hosts
     * return as Vector
     */
    public  Vector getHostList() throws java.rmi.RemoteException {
        Vector lst = OXY_PrinterHostXML.getListHost();
        return lst;
    }
    public  Vector getHostList(boolean reload) throws java.rmi.RemoteException {
        Vector lst = OXY_PrinterHostXML.getListHost(true);
        return lst;
    }
    
    /* get printer list of a host
     * return as
     */
    public  Vector getPrinterList(PrinterHost rmtPrnHost) throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return new Vector();
        System.out.println(" getPrinterList STEP  -> setSecurityManager ");
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        System.out.println(" getPrinterList STEP -> create RMI Object ");
        
        Vector prnLst = null;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println(" getPrinterList >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            
            
            prnLst = prnTarget.getLisfOfPrinter();
            
        }catch (Exception e){
            e.printStackTrace();
            System.out.println(" EXCP get printer list : "+e);
        }
        return prnLst;
    }
    
    public  Vector reloadPrinterList(PrinterHost rmtPrnHost) throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return new Vector();
        System.out.println(" reloadPrinterList STEP  -> setSecurityManager ");
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        System.out.println(" reloadPrinterList STEP -> create RMI Object ");
        
        Vector prnLst = null;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println(" reloadPrinterList >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            
            
            prnLst = prnTarget.reloadLisfOfPrinter();
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        return prnLst;
    }
    
    public static Vector stReloadPrinterList(PrinterHost rmtPrnHost) throws java.rmi.RemoteException, java.net.MalformedURLException,java.rmi.NotBoundException {
        if(rmtPrnHost==null)
            return new Vector();
        System.out.println(" reloadPrinterList STEP  -> setSecurityManager ");
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        System.out.println(" reloadPrinterList STEP -> create RMI Object ");
        
        Vector prnLst = null;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println(" reloadPrinterList >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            prnLst = prnTarget.reloadLisfOfPrinter();
            System.out.println(" prnLst top >  : "+prnLst.size());
        }catch (java.rmi.RemoteException e){
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            Registry r = LocateRegistry.createRegistry(Registry.REGISTRY_PORT);
            prnTarget = (I_OXY_PrintTarget) r.lookup(nameLookUp);            
            prnLst = prnTarget.reloadLisfOfPrinter();
            System.out.println(" prnLst top >  : "+prnLst.size());
            if(prnLst==null){
                e.printStackTrace();
                System.out.println(" EXCP reload printer list : "+e);                
            }
            throw e;
        }catch(java.net.MalformedURLException e){
        }catch(Exception e){
        }
        
        return prnLst;
    }
    
    /* get printer list of a host with status of each printer
     * return as
     */
    public  Vector getPrinterListWithStatus(PrinterHost rmtPrnHost)  throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return new Vector();
        
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        Vector prnLst = null;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println("getPrinterListWithStatus >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            
            prnLst = prnTarget.getStatusOfPrinter();
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        return prnLst;
    }
    
    /* stop printer status !!! ALL OBJECT WILL BE REMOVED
     */
    public  void stopPrinterService(PrinterHost rmtPrnHost) throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return;
        
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        Vector prnLst = null;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            System.out.println(" stopPrinterService >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            prnTarget.stopPrintSvc();
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        return ;
    }
    
    /* get printer host from String :  <host IP><separ><printer index>
     */
    public  PrinterHost getPrinterHost(String hostIpIdx, String separ) throws java.rmi.RemoteException {
        if(hostIpIdx!=null){
            int sc = hostIpIdx.indexOf(separ);
            String ip= hostIpIdx.substring(0, sc);
            PrinterHost host = OXY_PrinterHostXML.getPrinterHostByIP(ip);
            return host;
        }
        return null;
    }
    
    public  PrnConfig getPrinterConfig(String hostIpIdx, String separ)  throws java.rmi.RemoteException {
        PrinterHost host = getPrinterHost(hostIpIdx, separ);
        PrnConfig prn = null;
        if(host!=null){
            int sc = hostIpIdx.indexOf(separ)+(separ.length());
            String idxStr= hostIpIdx.substring(sc);
            try{
                int idx = Integer.parseInt(idxStr);
                prn= host.getPrnConfig(idx);
            }catch(Exception exc){
                System.out.println("getPrinterConfig " +exc);
            }
        }
        return prn;
    }
    
    /* print object into a host
     * return int as error message
     */
    public  int printObj(PrinterHost rmtPrnHost, OXY_PrintObj obj) throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return I_OXY_PrinterDriver.ST_ERR_NO_HOST ;
        
        System.out.println("");
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        Vector prnLst = null;
        int st= I_OXY_PrinterDriver.ST_IDLE;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            
            System.out.println(" printObj >  HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            st = prnTarget.printObj(obj);
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        return st;
    }
    
    public   int pausePrinter(PrinterHost rmtPrnHost, PrnConfig prn) throws java.rmi.RemoteException {
        return setPrinterStatus(rmtPrnHost,  prn, I_OXY_PrinterDriver.ST_PAUSED);
    }
    
    public   int resumePrinter(PrinterHost rmtPrnHost, PrnConfig prn)  throws java.rmi.RemoteException {
        return setPrinterStatus(rmtPrnHost,  prn, I_OXY_PrinterDriver.ST_PRINTING);
    }
    
    public   int cancelPrinter(PrinterHost rmtPrnHost, PrnConfig prn) throws java.rmi.RemoteException {
        return setPrinterStatus(rmtPrnHost,  prn, I_OXY_PrinterDriver.ST_IDLE);
    }
    /* set printer into a host
     * return int as error message
     */
    public int setPrinterStatus(PrinterHost rmtPrnHost, PrnConfig prn, int cmd) throws java.rmi.RemoteException {
        if(rmtPrnHost==null)
            return I_OXY_PrinterDriver.ST_ERR_NO_HOST ;
        
        // System.setSecurityManager(new RMISecurityManager());
        System.setSecurityManager(null);
        
        I_OXY_PrintTarget prnTarget=null;
        
        Vector prnLst = null;
        int st= I_OXY_PrinterDriver.ST_IDLE;
        try{
            String nameLookUp = "//"+rmtPrnHost.getHostIP()+":"+rmtPrnHost.getPort()+"/"+rmtPrnHost.getRMIObjName();
            
            System.out.println(" setPrinterStatus > HOST " + rmtPrnHost.getHostName()+ " = " + nameLookUp);
            
            prnTarget = (I_OXY_PrintTarget) Naming.lookup(nameLookUp);
            switch (cmd){
                case I_OXY_PrinterDriver.ST_PAUSED:   st=prnTarget.pausePrint(prn); break;
                case I_OXY_PrinterDriver.ST_IDLE:   st=prnTarget.cancelPrint(prn); break;
                case I_OXY_PrinterDriver.ST_PRINTING: st=prnTarget.resumePrint(prn); break;
                default:;
            }
            
        }catch (Exception e){
            System.out.println(" EXCP : "+e);
        }
        return st;
    }
    
    public  void loadPrintersOnAllHost() throws java.rmi.RemoteException {
        Vector hosts = getHostList();
        System.out.println("");
        if(hosts!=null){
            for(int h=0;h<hosts.size();h++){
                PrinterHost hst = (PrinterHost) hosts.get(h);
                Vector prns = getPrinterList(hst);
                if(prns==null)
                    prns = new Vector();
                hst.setListOfPrinters(prns);
            }
        }
    }
    
    public  void reloadPrintersOnAllHost() throws java.rmi.RemoteException {
        System.out.println("");
        Vector hosts = getHostList(true);
        if(hosts!=null){
            System.out.println(" reloadPrintersOnAllHost > getPrinterList ");
            for(int h=0;h<hosts.size();h++){
                PrinterHost hst = (PrinterHost) hosts.get(h);
                Vector prns = reloadPrinterList(hst);
                if(prns==null)
                    prns = new Vector();
                hst.setListOfPrinters(prns);
            }
        }
    }
    
    public  static void stReloadPrintersOnAllHost() throws java.rmi.RemoteException, java.net.MalformedURLException {
        Vector hosts = OXY_PrinterHostXML.getListHost(true);
        System.out.println("");
        try{
        if(hosts!=null){
            System.out.println(" reloadPrintersOnAllHost > getPrinterList ");
            for(int h=0;h<hosts.size();h++){
                PrinterHost hst = (PrinterHost) hosts.get(h);
                Vector prns = stReloadPrinterList(hst);
                if(prns==null)
                    prns = new Vector();
                hst.setListOfPrinters(prns);
            }
        }
        }catch(java.rmi.RemoteException e){
        }catch(java.net.MalformedURLException e){
        }catch(Exception e){
        }
    }
    
    
    public void setPrinterHost(PrinterHost rmtPrnHost)throws java.rmi.RemoteException{
        if(rmtPrnHost==null)
            return;
        OXY_PrinterHostXML.setPrinterHostByIP(rmtPrnHost);
    }
    
    public PrinterHost getPrinterHostByIP(String ip) throws java.rmi.RemoteException{
        if(ip==null)
            return null;
        
        return OXY_PrinterHostXML.getPrinterHostByIP(ip);
    }
    
    public Vector getPrinterHostExceptIP(String ip) throws java.rmi.RemoteException{
        if(ip==null)
            return null;
        
        return OXY_PrinterHostXML.getPrinterHostExceptIP(ip);
    }
    
}