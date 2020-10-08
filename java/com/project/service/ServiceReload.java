/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.service;

import com.project.general.Company;
import com.project.general.DbCompany;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class ServiceReload implements Runnable {

    public ServiceReload() {
    }

    public synchronized void run(){
        
        Reload reload = new Reload();

        boolean firstProcess = true;

        while (reload.running) {
            try {
                if (firstProcess) {
                    try {
                        Vector listCompany = DbCompany.list(0, 1, "", null);
                        if (listCompany != null && listCompany.size() > 0) {
                            Company company = (Company) listCompany.get(0);
                            System.out.println("============ Service : " + company.getName() + "====================");
                        }
                    } catch (Exception e) {
                    }

                    Thread.sleep(1000 * 1000);
                    firstProcess = false;
                } else {
                    Vector listCompany = DbCompany.list(0, 1, "", null);
                    if (listCompany != null && listCompany.size() > 0) {
                        Company company = (Company) listCompany.get(0);
                        System.out.println("============ Service : " + company.getName() + "====================");
                    }
                    Thread.sleep(1000 * 1000);
                }

            } catch (Exception e) {
                System.out.println("Exc Service Reload : " + e.toString());
            }
        }
    }

    public int getSleepTime(Date start, Date end) {
        Date s = new Date();
        Date e = new Date();

        s.setHours(start.getHours());
        s.setMinutes(start.getMinutes());
        s.setSeconds(start.getSeconds());

        e.setHours(end.getHours());
        e.setMinutes(end.getMinutes());
        e.setSeconds(end.getSeconds());

        if (end.getHours() < start.getHours()) {
            int dtEnd = e.getDate();
            e.setDate(dtEnd + 1);
        }

        long st = s.getTime();
        long en = e.getTime();
        long rs = en - st;
        if (rs < 0) {
            rs = 0;
        }

        return (new Long(rs)).intValue();
    }
}
