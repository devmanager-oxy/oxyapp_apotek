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
public class MemorialDetail extends Entity{
    private long memorialId = 0;
    private long coaId = 0;
    private double amount = 0;
    private String note = "";

    public long getMemorialId() {
        return memorialId;
    }

    public void setMemorialId(long memorialId) {
        this.memorialId = memorialId;
    }

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

}
