package com.project.ccs.postransaction.transfer;

import java.util.Date;
import com.project.main.entity.*;

public class FakturPajak extends Entity {

    private String nama_pkp = "";
    private int counter;
    private String number = "";
    private String transfer_number = "";
    private String salesNumber = "";
    private Date date;
    
    //add by roy andika
    private String PkpAddress = "";
    private String npwpPkp = "";    
    private long CustomerId;
    private String customerAddress;
    private String npwpCustomer = "";    
    private long salesId;
    private String prefixNumber = "";    
    private long locationId;    
    private int typeFaktur; 
    private long locationToId; 

    public String getNama_pkp() {
        return nama_pkp;
    }

    public void setNama_pkp(String nama_pkp) {
        this.nama_pkp = nama_pkp;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getTransfer_number() {
        return transfer_number;
    }

    public void setTransfer_number(String transfer_number) {
        this.transfer_number = transfer_number;
    }

    public String getSalesNumber() {
        return salesNumber;
    }

    public void setSalesNumber(String salesNumber) {
        this.salesNumber = salesNumber;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNpwpPkp() {
        return npwpPkp;
    }

    public void setNpwpPkp(String npwpPkp) {
        this.npwpPkp = npwpPkp;
    }

    public long getCustomerId() {
        return CustomerId;
    }

    public void setCustomerId(long CustomerId) {
        this.CustomerId = CustomerId;
    }

    public String getNpwpCustomer() {
        return npwpCustomer;
    }

    public void setNpwpCustomer(String npwpCustomer) {
        this.npwpCustomer = npwpCustomer;
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public String getPkpAddress() {
        return PkpAddress;
    }

    public void setPkpAddress(String PkpAddress) {
        this.PkpAddress = PkpAddress;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public int getTypeFaktur() {
        return typeFaktur;
    }

    public void setTypeFaktur(int typeFaktur) {
        this.typeFaktur = typeFaktur;
    }

    public long getLocationToId() {
        return locationToId;
    }

    public void setLocationToId(long locationToId) {
        this.locationToId = locationToId;
    }
    
}
