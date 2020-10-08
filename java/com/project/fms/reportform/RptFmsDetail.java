/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.reportform;

import com.project.main.entity.Entity;
/**
 *
 * @author Roy Andika
 */
public class RptFmsDetail extends Entity {
    
    private long rptFmsId = 0;
    private long periodId;
    private int squence = 0;
    private long coaId;
    private double amount = 0;
    private int type = 0;
    private int level = 0;
    private String description = "";
    private int typeDoc = 0;
    private String status = "";
    private int currentPeriod = 0;

    public long getRptFmsId() {
        return rptFmsId;
    }

    public void setRptFmsId(long rptFmsId) {
        this.rptFmsId = rptFmsId;
    }

    public long getPeriodId() {
        return periodId;
    }

    public void setPeriodId(long periodId) {
        this.periodId = periodId;
    }

    public int getSquence() {
        return squence;
    }

    public void setSquence(int squence) {
        this.squence = squence;
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

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTypeDoc() {
        return typeDoc;
    }

    public void setTypeDoc(int typeDoc) {
        this.typeDoc = typeDoc;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCurrentPeriod() {
        return currentPeriod;
    }

    public void setCurrentPeriod(int currentPeriod) {
        this.currentPeriod = currentPeriod;
    }
    
    
}
