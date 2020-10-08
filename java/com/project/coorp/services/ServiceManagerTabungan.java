
package com.project.coorp.services;

import com.project.coorp.services.*;

public class ServiceManagerTabungan {

    public static boolean running = false;
    public static WatcherTabungan watcherSMS = new WatcherTabungan();
    public static ServiceManagerTabungan svcManTab;

    /** Creates new ServiceManagerSMS */
    public ServiceManagerTabungan() {
          
    }

    public void startWatcherTabungan() {
        if (running) return;
        //ServiceManagerTabungan objMan = new ServiceManagerTabungan();
        Thread thLocker = new Thread(new WatcherTabungan());
        thLocker.setDaemon(false);
        running = true;
        thLocker.start();
    }

    public void stopWatcherTabungan() {        
        running = false;
    }

    public boolean getStatus() {
        return running;
    }
    
}
