/*
 * RptAdjustment.java
 *
 * Created on July 21, 2009, 2:20 PM
 */

package com.project.ccs.report;

import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author  Kyo
 */
public class RptServiceLevelSupplier extends Entity {
    
   
    private Date tanggalFrom;
    private Date tanggalTo;
    private long locationId;
    
    
    /** Creates a new instance of RptAdjustment */
    public RptServiceLevelSupplier() {
    }
         

    public Date getTanggalFrom() {
        return tanggalFrom;
    }

    public void setTanggalFrom(Date tanggalFrom) {
        this.tanggalFrom = tanggalFrom;
    }

    public Date getTanggalTo() {
        return tanggalTo;
    }

    public void setTanggalTo(Date tanggalTo) {
        this.tanggalTo = tanggalTo;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }
    
}
