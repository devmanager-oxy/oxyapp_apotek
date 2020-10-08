package com.project.ccs.report;

import java.util.Date;

public class SrcStockReportMinimum {
    
    private String code;
    private String description;
    private double qty_system;
    private double qty_minimum;
    private long locationId;
    
    /**
     * Holds value of property locationName.
     */
    private String locationName;
    
    /**
     * Holds value of property groupName.
     */
    private String groupName;
    
    /**
     * Holds value of property itemMasterId.
     */
    private long itemMasterId;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getQty_system() {
        return qty_system;
    }

    public void setQty_system(double qty_system) {
        this.qty_system = qty_system;
    }

    public double getQty_minimum() {
        return qty_minimum;
    }

    public void setQty_minimum(double qty_minimum) {
        this.qty_minimum = qty_minimum;
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

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }
    
    /**
     * Getter for property code.
     * @return Value of property code.
     */
   
    
}
