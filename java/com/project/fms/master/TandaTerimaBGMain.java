/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class TandaTerimaBGMain extends Entity {
    
    private String number = "";
    private int counter = 0;
    private String prefix = "";
    private long vendorId = 0;
    private Date transDate;
    private Date createDate;
    private String vendor = "";

    /**
     * @return the number
     */
    public String getNumber() {
        return number;
    }

    /**
     * @param number the number to set
     */
    public void setNumber(String number) {
        this.number = number;
    }

    /**
     * @return the counter
     */
    public int getCounter() {
        return counter;
    }

    /**
     * @param counter the counter to set
     */
    public void setCounter(int counter) {
        this.counter = counter;
    }

    /**
     * @return the prefix
     */
    public String getPrefix() {
        return prefix;
    }

    /**
     * @param prefix the prefix to set
     */
    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    /**
     * @return the vendorId
     */
    public long getVendorId() {
        return vendorId;
    }

    /**
     * @param vendorId the vendorId to set
     */
    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    /**
     * @return the transDate
     */
    public Date getTransDate() {
        return transDate;
    }

    /**
     * @param transDate the transDate to set
     */
    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

    /**
     * @return the createDate
     */
    public Date getCreateDate() {
        return createDate;
    }

    /**
     * @param createDate the createDate to set
     */
    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }
}
