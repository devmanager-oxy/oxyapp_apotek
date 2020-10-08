package com.project.general;

import com.project.main.entity.Entity;
import java.util.Date;

public class CustomerHistory extends Entity{

    private int type                = 0;     
    private int typeHistory         = 0;     
    private long customerId         = 0;     
    private long userId             = 0;     
    private Date date ;
    private String status           = "";    
    private Date statusDate         = new Date(); 
    private String note             = "";
    private String barcode          = "";
    private String name             = "";
    private long salesId            = 0;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getTypeHistory() {
        return typeHistory;
    }

    public void setTypeHistory(int typeHistory) {
        this.typeHistory = typeHistory;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStatusDate() {
        return statusDate;
    }

    public void setStatusDate(Date statusDate) {
        this.statusDate = statusDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

}
