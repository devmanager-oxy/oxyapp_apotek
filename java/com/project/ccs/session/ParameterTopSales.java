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
public class ParameterTopSales {

    private long employeeId = 0;
    private String prdukName = "";
    private Date startDate = new Date();
    private Date endDate = new Date();
    private long locationid = 0;

    public String getPrdukName() {
        return prdukName;
    }

    public void setPrdukName(String prdukName) {
        this.prdukName = prdukName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public long getLocationid() {
        return locationid;
    }

    public void setLocationid(long locationid) {
        this.locationid = locationid;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }
}
