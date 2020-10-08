/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.journal;

import com.project.main.entity.Entity;
/**
 *
 * @author Roy
 */
public class MemorialKonsinyasiDetail extends Entity {
    
    private long memorialKonsinyasiId = 0;
    private long coaId = 0;
    private double amount = 0;
    private String note = "";

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public long getMemorialKonsinyasiId() {
        return memorialKonsinyasiId;
    }

    public void setMemorialKonsinyasiId(long memorialKonsinyasiId) {
        this.memorialKonsinyasiId = memorialKonsinyasiId;
    }
    
    
}
