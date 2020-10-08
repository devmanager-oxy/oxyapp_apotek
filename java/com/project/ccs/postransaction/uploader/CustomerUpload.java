/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.uploader;
import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy
 */
public class CustomerUpload extends Entity {
    
    private long customerUploadId = 0;
    private long customerId = 0;
    private Date date;
    private String queryString = "";
    private int statusUpload = 0;

    public long getCustomerUploadId() {
        return customerUploadId;
    }

    public void setCustomerUploadId(long customerUploadId) {
        this.customerUploadId = customerUploadId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public int getStatusUpload() {
        return statusUpload;
    }

    public void setStatusUpload(int statusUpload) {
        this.statusUpload = statusUpload;
    }
}
