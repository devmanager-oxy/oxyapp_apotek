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
public class CashCashierUpload extends Entity {
    
    private long cashCashierUploadId = 0;
    private long cashCashierId = 0;
    private Date date;
    private String queryString = "";
    private int statusUpload = 0;

    public long getCashCashierUploadId() {
        return cashCashierUploadId;
    }

    public void setCashCashierUploadId(long cashCashierUploadId) {
        this.cashCashierUploadId = cashCashierUploadId;
    }

    public long getCashCashierId() {
        return cashCashierId;
    }

    public void setCashCashierId(long cashCashierId) {
        this.cashCashierId = cashCashierId;
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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
