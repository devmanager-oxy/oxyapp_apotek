package com.project.ccs.utility.service.mastersynch;

public class ServiceManagerMasterSynch_1 { 

    private static ServiceManagerMasterSynch_1 serviceManager_1;
    
    public static boolean running = false;    
    
    public boolean getStatus() {
        return running;
    }
    
    public ServiceManagerMasterSynch_1() {
    }
    
    public static ServiceManagerMasterSynch_1 getSingleObject(){
        if (serviceManager_1 == null)
            // it's ok, we can call this constructor
            serviceManager_1 = new ServiceManagerMasterSynch_1();
        
        return serviceManager_1;
    }

    public void startWatcherMasterSynch_1() 
    {
        if (!running) {
            System.out.println("\r.:: MasterSynch 1 service started ... !!!");   
            try {
                running = true;
                Thread thr = new Thread(new WatcherMasterSynch_1());     
                thr.setDaemon(false);                
                thr.start();
            } catch (Exception e) {
                System.out.println(">>> Exc when MasterSynch 1 start ... !!!");
            }             
        }
    }

    public void stopWatcherMasterSynch_1() {  
        running = false;
        System.out.println("\r.:: MasterSynch 1 service stopped ... !!!");  
    }
}
