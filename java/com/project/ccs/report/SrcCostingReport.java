/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;
import java.util.Date;
/**
 *
 * @author Ngurah Wirata
 */
public class SrcCostingReport {
    private long locationId = 0;
    private Date fromDate = new Date();
    private Date toDate = new Date();
    private int ignoreDate = 0;
    private String status = "";
    private long itemCategoryId = 0;
    //private long itemSubCategoryId = 0;
    
    private String code="";
    private String item_name="";

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public int getIgnoreDate() {
        return ignoreDate;
    }

    public void setIgnoreDate(int ignoreDate) {
        this.ignoreDate = ignoreDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getItemCategoryId() {
        return itemCategoryId;
    }

    public void setItemCategoryId(long itemCategoryId) {
        this.itemCategoryId = itemCategoryId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }
}
