/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class ReportCreditPayment {

    private String locName = "";
    private long locId;
    private long salesId;
    private String salesNumb = "";
    private long cpId;
    private Date cpDate;
    private double cpAmount;    
    private int cpStatus;
    private long cstId;

    public String getLocName() {
        return locName;
    }

    public void setLocName(String locName) {
        this.locName = locName;
    }

    public long getLocId() {
        return locId;
    }

    public void setLocId(long locId) {
        this.locId = locId;
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public String getSalesNumb() {
        return salesNumb;
    }

    public void setSalesNumb(String salesNumb) {
        this.salesNumb = salesNumb;
    }

    public long getCpId() {
        return cpId;
    }

    public void setCpId(long cpId) {
        this.cpId = cpId;
    }

    public double getCpAmount() {
        return cpAmount;
    }

    public void setCpAmount(double cpAmount) {
        this.cpAmount = cpAmount;
    }

    public int getCpStatus() {
        return cpStatus;
    }

    public void setCpStatus(int cpStatus) {
        this.cpStatus = cpStatus;
    }

    public Date getCpDate() {
        return cpDate;
    }

    public void setCpDate(Date cpDate) {
        this.cpDate = cpDate;
    }

    public long getCstId() {
        return cstId;
    }

    public void setCstId(long cstId) {
        this.cstId = cstId;
    }
    
}
