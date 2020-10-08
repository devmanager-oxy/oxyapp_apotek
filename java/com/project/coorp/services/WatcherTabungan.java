
package com.project.coorp.services;

import java.util.Vector;
import java.util.Date;

import com.project.coorp.services.*;
import com.project.system.*;
import com.project.coorp.pinjaman.*;

public class WatcherTabungan implements Runnable {

    int i = 0;
    /** Creates new WatcherTabungan */
    public WatcherTabungan() {
    }

    public void run() {
        System.out.println("\t[WatcherTabungan] starting...");
        
        while (ServiceManagerTabungan.running) { 
            try {
                
                process();

                long WATCHING_INTERVAL = 10000;
                
                int sleepTime = (int) (WATCHING_INTERVAL);
                System.out.println("\tWATCHING_INTERVAL = " + WATCHING_INTERVAL/1000 + " detik");
                
                Thread.sleep(sleepTime);

                if (!ServiceManagerTabungan.running)
                    break;
            }
            catch (Exception e) {
                System.out.println("\t[WatcherTabungan] interrupted with message : " + e);
                
            }
        
        }
          
        System.out.println("\t[WatcherTabungan] stopped.");
    }
    
    
    

    public void process() {
        
        try{
        
            System.out.println("\n\n --- watcher ... get new incoming Tabungan -----------------");

            Vector v = DbTabunganSukarela.getAllPenabung();

            if(v!=null && v.size()>0){

                System.out.println("--- watcher ... new sms number : "+v.size());

                for(int i=0; i<v.size(); i++){
                    
                    long oidMember = Long.parseLong((String)v.get(i));
                    TabunganSetup ts = DbTabunganSetup.getTabunganSetup();
                    DbTabunganSukarela.postAutoBunga(ts, oidMember);

                    System.out.println("--- watcher - end");
                    //System.out.println("--- watcher - processing sms no : "+i);
                }
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
    }
    
    
    
}
