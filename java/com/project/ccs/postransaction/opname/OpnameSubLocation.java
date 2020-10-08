package com.project.ccs.postransaction.opname;

import java.util.Date;
import com.project.main.entity.*;

public class OpnameSubLocation extends Entity {

    
    private long opnameId;
    private long subLocationId;
    private String subLocationName; 
    private String status;
    private long userId;
    private String formNumber;
    private Date date;

    public long getOpnameId() {
        return opnameId;
    }

    public void setOpnameId(long opnameId) {
        this.opnameId = opnameId;
    }

    public long getSubLocationId() {
        return subLocationId;
    }

    public void setSubLocationId(long subLocationId) {
        this.subLocationId = subLocationId;
    }

   

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getSubLocationName() {
        return subLocationName;
    }

    public void setSubLocationName(String subLocationName) {
        this.subLocationName = subLocationName;
    }

    public String getFormNumber() {
        return formNumber;
    }

    public void setFormNumber(String formNumber) {
        this.formNumber = formNumber;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
    

   
}
