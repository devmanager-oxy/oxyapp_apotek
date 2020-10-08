/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.utility.service.salessynch;

/**
 *
 * @author Roy
 */
public class ServiceManagerTransaction {
    
    private static ServiceManagerTransaction serviceManagerUpload_1;
    public static boolean running = false;

    public boolean getStatus() {
        return running;
    }

    public ServiceManagerTransaction() {
    }

    public static ServiceManagerTransaction getSingleObject() {
        if (serviceManagerUpload_1 == null){
            serviceManagerUpload_1 = new ServiceManagerTransaction();
        }
        return serviceManagerUpload_1;
    }

    public void startWatcherUploaderSynch_1() {
        if (!running) {
            System.out.println("\r.:: Uploader service started ... !!!");
            try {
                running = true;
                Thread thr = new Thread(new WatcherUploaderTransaction());
                thr.setDaemon(false);
                thr.start();
            } catch (Exception e) {
                System.out.println(">>> Exc when Uploader start ... !!!");
            }
        }
    }

    public void stopWatcherUploaderSynch_1() {
        running = false;
        System.out.println("\r.:: Uploader service stopped ... !!!");
    }

}
