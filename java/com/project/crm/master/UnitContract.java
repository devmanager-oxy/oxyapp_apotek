/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.master;
import com.project.main.entity.Entity;
/**
 *
 * @author Tu Roy
 */
public class UnitContract extends Entity {
    
    private String name = "";
    private String kode = "";
    private int jmlBulan = 0;
    private int status = 0;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getKode() {
        return kode;
    }

    public void setKode(String kode) {
        this.kode = kode;
    }

    public int getJmlBulan() {
        return jmlBulan;
    }

    public void setJmlBulan(int jmlBulan) {
        this.jmlBulan = jmlBulan;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    
    
    
    
    

}
