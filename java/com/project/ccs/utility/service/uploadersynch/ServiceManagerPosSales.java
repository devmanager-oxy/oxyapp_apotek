/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.utility.service.uploadersynch;

/**
 *
 * @author Roy
 */
public class ServiceManagerPosSales {

    private static ServiceManagerPosSales serviceManager_1;
    public static boolean running = false;

    public boolean getStatus() {
        return running;
    }

    public ServiceManagerPosSales() {
    }

    public static ServiceManagerPosSales getSingleObject() {
        if (serviceManager_1 == null){
            serviceManager_1 = new ServiceManagerPosSales();
        }
        return serviceManager_1;
    }

    public void startWatcherUploaderSynch_1() {
        if (!running) {
            System.out.println("\r.:: UploaderSynch 1 service started ... !!!");
            try {
                running = true;
                Thread thr = new Thread(new WatcherUploaderPosSales());
                thr.setDaemon(false);
                thr.start();
            } catch (Exception e) {
                System.out.println(">>> Exc when UploaderSynch 1 start ... !!!");
            }
        }
    }

    public void stopWatcherUploaderSynch_1() {
        running = false;
        System.out.println("\r.:: UploaderSynch 1 service stopped ... !!!");
    }
}
