package com.project.ccs.postransaction.costing;

import java.util.Date;
import com.project.main.entity.*;

public class Costing extends Entity {

    private Date date;
    private int counter;
    private String number = "";
    private String note = "";
    private long approval1;
    private long approval2;
    private long approval3;
    private String status = "";
    private long locationId;
    private long userId;
    private String prefixNumber = "";    
    private int postedStatus;
    private long postedById;
    private Date postedDate;
    private Date effectiveDate;
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

    public long getApproval2() {
        return approval2;
    }

    public void setApproval2(long approval2) {
        this.approval2 = approval2;
    }

    public long getApproval3() {
        return approval3;
    }

    public void setApproval3(long approval3) {
        this.approval3 = approval3;
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

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
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
}
