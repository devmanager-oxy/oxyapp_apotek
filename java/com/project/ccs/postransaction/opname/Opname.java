package com.project.ccs.postransaction.opname;

import java.util.Date;
import com.project.main.entity.*;

public class Opname extends Entity {

    private int counter;
    private String number;
    private Date date;
    private String status = "";
    private String note = ""; 
    private long approval1;
    private long approval2;
    private long approval3; 
    private long userId;
    private long locationId = 0;
    private String prefixNumber = "";
    private Date approval1_date;
    private Date approval2_date;
    private Date approval3_date; 
    private int type;
    private long opnamePeriodeId;
    private int typeOpname;
    
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
        if (status == null) {
            status = ""; 
        }
        this.status = status;
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getApproval1_date() {
        return approval1_date;
    }

    public void setApproval1_date(Date approval1_date) {
        this.approval1_date = approval1_date;
    }

    public Date getApproval2_date() {
        return approval2_date;
    }

    public void setApproval2_date(Date approval2_date) {
        this.approval2_date = approval2_date;
    }

    public Date getApproval3_date() {
        return approval3_date;
    }

    public void setApproval3_date(Date approval3_date) {
        this.approval3_date = approval3_date;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getOpnamePeriodeId() {
        return opnamePeriodeId;
    }

    public void setOpnamePeriodeId(long opnamePeriodeId) {
        this.opnamePeriodeId = opnamePeriodeId;
    }

    public int getTypeOpname() {
        return typeOpname;
    }

    public void setTypeOpname(int typeOpname) {
        this.typeOpname = typeOpname;
    }
    
}
