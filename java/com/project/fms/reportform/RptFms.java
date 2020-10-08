/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.reportform;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptFms extends Entity {

    private int typeReport = 0;
    private long userId;
    private Date reportDate = new Date();
    private long periodSearchId = 0;
    private long locationId = 0;
    private String locationName = "";
    private int allCoa = 0;

    public int getTypeReport() {
        return typeReport;
    }

    public void setTypeReport(int typeReport) {
        this.typeReport = typeReport;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public long getPeriodSearchId() {
        return periodSearchId;
    }

    public void setPeriodSearchId(long periodSearchId) {
        this.periodSearchId = periodSearchId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public int getAllCoa() {
        return allCoa;
    }

    public void setAllCoa(int allCoa) {
        this.allCoa = allCoa;
    }
    
    
            
            
            
    
}
