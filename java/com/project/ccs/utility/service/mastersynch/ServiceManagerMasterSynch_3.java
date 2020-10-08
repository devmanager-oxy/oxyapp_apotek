package com.project.ccs.utility.service.mastersynch;

public class ServiceManagerMasterSynch_3 { 

    private static ServiceManagerMasterSynch_3 serviceManager_3;
    
    public static boolean running = false;    
    
    public boolean getStatus() {
        return running;
    }
    
    public ServiceManagerMasterSynch_3() {
    }
    
    public static ServiceManagerMasterSynch_3 getSingleObject(){
        if (serviceManager_3 == null)
            // it's ok, we can call this constructor
            serviceManager_3 = new ServiceManagerMasterSynch_3();
        
        return serviceManager_3;
    }

    public void startWatcherMasterSynch_3() 
    {
        if (!running) {
            System.out.println("\r.:: MasterSynch 3 service started ... !!!");   
            try {
                running = true;
                Thread thr = new Thread(new WatcherMasterSynch_3());     
                thr.setDaemon(false);                
                thr.start();
            } catch (Exception e) {
                System.out.println(">>> Exc when MasterSynch 3 start ... !!!");
            }             
        }
    }

    public void stopWatcherMasterSynch_3() {  
        running = false;
        System.out.println("\r.:: MasterSynch 3 service stopped ... !!!");  
    }
}
