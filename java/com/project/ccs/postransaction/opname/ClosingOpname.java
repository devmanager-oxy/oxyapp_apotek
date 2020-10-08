package com.project.ccs.postransaction.opname;

import java.util.Date;
import com.project.main.entity.*;

public class ClosingOpname extends Entity {
    
    private Date date;
    private long locationId;
    private long itemMasterId;
    private double qty=0;
    private long opnameId;
    private double hpp=0;
    private double harga_jual=0;
    

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

   

    public long getOpnameId() {
        return opnameId;
    }

    public void setOpnameId(long opnameId) {
        this.opnameId = opnameId;
    }

    public double getHpp() {
        return hpp;
    }

    public void setHpp(double hpp) {
        this.hpp = hpp;
    }

    public double getHarga_jual() {
        return harga_jual;
    }

    public void setHarga_jual(double harga_jual) {
        this.harga_jual = harga_jual;
    }
    

    
    
    
    
}
