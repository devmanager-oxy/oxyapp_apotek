/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.journal;

import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy
 */
public class Memorial extends Entity {
    private Date startDate;
    private Date endDate;
    private long vendorId = 0;
    private long locationId = 0;
    
    private long userId = 0;    
    private Date createDate;
    private long uniqKeyId = 0;

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

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public long getUniqKeyId() {
        return uniqKeyId;
    }

    public void setUniqKeyId(long uniqKeyId) {
        this.uniqKeyId = uniqKeyId;
    }
    
}
