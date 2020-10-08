/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.admin;
import com.project.main.entity.Entity;

/**
 *
 * @author Roy Andika
 */
public class SegmentUser extends Entity {

    private long userId = 0;
    private long segmentDetailId = 0;
    private long locationId = 0;

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

    public long getSegmentDetailId() {
        return segmentDetailId;
    }

    public void setSegmentDetailId(long segmentDetailId) {
        this.segmentDetailId = segmentDetailId;
    }
}
