/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.service;

/**
 *
 * @author Roy Andika
 */
public class Reload {

    public Reload() {
    }
    
    static boolean running = false; // status service

    public boolean getStatus()
    {
        return running;
    }    
    
    public synchronized void startService() 
    {
        if (!running) 
        {
            System.out.println(".:: Reload service started ... !!!");   
            try 
            {
                running = true;
                Thread thr = new Thread(new ServiceReload());
                thr.setDaemon(false);
                thr.start();

            }
            catch (Exception e) 
            {
                System.out.println(">>> Exc when Reload start ... !!!");
            }
        }
    }

    public synchronized void stopService() 
    {
        running = false;
        System.out.println(".:: Reload service stoped ... !!!");
    }
    
}
