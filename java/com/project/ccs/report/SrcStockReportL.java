package com.project.ccs.report;

import java.util.Date;

public class SrcStockReportL {
    
    private String code;
    private String barcode;
    private String description;
    private double qty;
    private double amount;
    private double price;
    private long location;
    
    
    /**
     * Holds value of property locationName.
     */
    private String locationName;
    
    /**
     * Holds value of property groupName.
     */
    private String groupName;
    private String subCategory;
    /**
     * Holds value of property itemMasterId.
     */
    private long itemMasterId;
    
    /**
     * Getter for property code.
     * @return Value of property code.
     */
    public String getCode() {
        return this.code;
    }
    
    /**
     * Setter for property code.
     * @param code New value of property code.
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * Getter for property description.
     * @return Value of property description.
     */
    public String getDescription() {
        return this.description;
    }
    
    /**
     * Setter for property description.
     * @param description New value of property description.
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * Getter for property qty.
     * @return Value of property qty.
     */
    public double getQty() {
        return this.qty;
    }
    
    /**
     * Setter for property qty.
     * @param qty New value of property qty.
     */
    public void setQty(double qty) {
        this.qty = qty;
    }
    
    /**
     * Getter for property amount.
     * @return Value of property amount.
     */
    public double getAmount() {
        return this.amount;
    }
    
    /**
     * Setter for property amount.
     * @param amount New value of property amount.
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    /**
     * Getter for property price.
     * @return Value of property price.
     */
    public double getPrice() {
        return this.price;
    }
    
    /**
     * Setter for property price.
     * @param price New value of property price.
     */
    public void setPrice(double price) {
        this.price = price;
    }
    
    /**
     * Getter for property location.
     * @return Value of property location.
     */
    public long getLocation() {
        return this.location;
    }
    
    /**
     * Setter for property location.
     * @param location New value of property location.
     */
    public void setLocation(long location) {
        this.location = location;
    }
    
    /**
     * Getter for property locationName.
     * @return Value of property locationName.
     */
    public String getLocationName() {
        return this.locationName;
    }
    
    /**
     * Setter for property locationName.
     * @param locationName New value of property locationName.
     */
    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
    
    /**
     * Getter for property groupName.
     * @return Value of property groupName.
     */
    public String getGroupName() {
        return this.groupName;
    }
    
    /**
     * Setter for property groupName.
     * @param groupName New value of property groupName.
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
    
    /**
     * Getter for property itemMasterId.
     * @return Value of property itemMasterId.
     */
    public long getItemMasterId() {
        return this.itemMasterId;
    }
    
    /**
     * Setter for property itemMasterId.
     * @param itemMasterId New value of property itemMasterId.
     */
    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getSubCategory() {
        return subCategory;
    }

    public void setSubCategory(String subCategory) {
        this.subCategory = subCategory;
    }
    
}
