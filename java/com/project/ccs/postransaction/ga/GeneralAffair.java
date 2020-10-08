/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.ga;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class GeneralAffair extends Entity{
    
    private Date date;
    private Date transactionDate;
    private int counter = 0;
    private String number = "";
    private String note = "";
    private long approval1 = 0;
    private Date approval1Date;
    private String status = "";
    private long locationId = 0;
    private long userId = 0;
    private String prefixNumber = "";    
    private int postedStatus = 0;
    private long postedById = 0;
    private Date postedDate;    
    private long locationPostId = 0;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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
        if (number == null) {
            number = "";
        }
        this.number = number;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        if (note == null) {
            note = "";
        }
        this.note = note;
    }

    public long getApproval1() {
        return approval1;        
    }

    public void setApproval1(long approval1) {
        this.approval1 = approval1;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status == null) {
            status = "";
        }
        this.status = status;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public long getLocationPostId() {
        return locationPostId;
    }

    public void setLocationPostId(long locationPostId) {
        this.locationPostId = locationPostId;
    }

    public Date getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Date transactionDate) {
        this.transactionDate = transactionDate;
    }

    public Date getApproval1Date() {
        return approval1Date;
    }

    public void setApproval1Date(Date approval1Date) {
        this.approval1Date = approval1Date;
    }

}
