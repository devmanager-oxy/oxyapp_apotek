package com.project.ccs.utility.service.mastersynch;

public class ServiceManagerMasterSynch_2 { 

    private static ServiceManagerMasterSynch_2 serviceManager_2;
    
    public static boolean running = false;    
    
    public boolean getStatus() {
        return running;
    }
    
    public ServiceManagerMasterSynch_2() {
    }
    
    public static ServiceManagerMasterSynch_2 getSingleObject(){
        if (serviceManager_2 == null)
            // it's ok, we can call this constructor
            serviceManager_2 = new ServiceManagerMasterSynch_2();
        
        return serviceManager_2;
    }

    public void startWatcherMasterSynch_2() 
    {
        if (!running) {
            System.out.println("\r.:: MasterSynch 2 service started ... !!!");   
            try {
                running = true;
                Thread thr = new Thread(new WatcherMasterSynch_2());     
                thr.setDaemon(false);                
                thr.start();
            } catch (Exception e) {
                System.out.println(">>> Exc when MasterSynch 2 start ... !!!");
            }             
        }
    }

    public void stopWatcherMasterSynch_2() {  
        running = false;
        System.out.println("\r.:: MasterSynch 2 service stopped ... !!!");  
    }
}
