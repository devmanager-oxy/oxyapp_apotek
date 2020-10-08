/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Roy Andika
 */
public class TransferRequest extends Entity {

    private Date date;
    private String status = "";
    private long fromLocationId;
    private long toLocationId;
    private String note = "";
    private int counter;
    private String number = "";
    private long approval1;    
    private long userId = 0;
    private String prefixNumber = "";   
    private Date approval1Date;       
    private long genId = 0;
    private Date createDate;

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

    public long getFromLocationId() {
        return fromLocationId;
    }

    public void setFromLocationId(long fromLocationId) {
        this.fromLocationId = fromLocationId;
    }

    public long getToLocationId() {
        return toLocationId;
    }

    public void setToLocationId(long toLocationId) {
        this.toLocationId = toLocationId;
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

    public long getApproval1() {
        return approval1;
    }

    public void setApproval1(long approval1) {
        this.approval1 = approval1;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        if (prefixNumber == null) {
            prefixNumber = "";
        }
        this.prefixNumber = prefixNumber;
    }
 
    public Date getApproval1Date() {
        return this.approval1Date;
    }
    
    public void setApproval1Date(Date approval1Date) {
        this.approval1Date = approval1Date;
    }

    public long getGenId() {
        return genId;
    }

    public void setGenId(long genId) {
        this.genId = genId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}
