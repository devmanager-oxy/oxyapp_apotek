/*
 *
 */

package com.project.printman;

import java.rmi.*;
import java.util.*;

/** Remote interface.
 *
 * @version 1.0
 */
public interface I_OXY_PrintTarget extends java.rmi.Remote {
    /** Hello method usually returns "Hello".
     */
    public String hello() throws java.rmi.RemoteException;
    
    public int printObj(OXY_PrintObj ObjPrint) throws java.rmi.RemoteException;
    
    public void stopPrintSvc() throws java.rmi.RemoteException;
    
    public Vector getLisfOfPrinter() throws java.rmi.RemoteException;

    public Vector reloadLisfOfPrinter() throws java.rmi.RemoteException;
        
    public Vector getStatusOfPrinter() throws java.rmi.RemoteException;
    
    public int pausePrint(PrnConfig prn) throws java.rmi.RemoteException;
    
    public int resumePrint(PrnConfig prn) throws java.rmi.RemoteException;
    
    public int cancelPrint(PrnConfig printer) throws java.rmi.RemoteException;
    
}
