/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy
 */
public class MemberParameter {

    private int type = 0;
    private String name = "";
    private String code = "";
    private String id = "";
    private long locationRegId = 0;
    
    private int ignoreReg = 0;
    private Date regStart;
    private Date regEnd;
    
    private int ignoreDob = 0;
    private Date dobStart;
    private Date dobEnd;
    
    private String address ="";
    private int statusDraft = 0;
    private int statusApprove = 0;
    private int statusExpired = 0;
    
    private String golPrice = "";
    private int termOfPayment= 0;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public long getLocationRegId() {
        return locationRegId;
    }

    public void setLocationRegId(long locationRegId) {
        this.locationRegId = locationRegId;
    }

    public int getIgnoreReg() {
        return ignoreReg;
    }

    public void setIgnoreReg(int ignoreReg) {
        this.ignoreReg = ignoreReg;
    }

    public Date getRegStart() {
        return regStart;
    }

    public void setRegStart(Date regStart) {
        this.regStart = regStart;
    }

    public Date getRegEnd() {
        return regEnd;
    }

    public void setRegEnd(Date regEnd) {
        this.regEnd = regEnd;
    }

    public int getIgnoreDob() {
        return ignoreDob;
    }

    public void setIgnoreDob(int ignoreDob) {
        this.ignoreDob = ignoreDob;
    }

    public Date getDobStart() {
        return dobStart;
    }

    public void setDobStart(Date dobStart) {
        this.dobStart = dobStart;
    }

    public Date getDobEnd() {
        return dobEnd;
    }

    public void setDobEnd(Date dobEnd) {
        this.dobEnd = dobEnd;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getStatusDraft() {
        return statusDraft;
    }

    public void setStatusDraft(int statusDraft) {
        this.statusDraft = statusDraft;
    }

    public int getStatusApprove() {
        return statusApprove;
    }

    public void setStatusApprove(int statusApprove) {
        this.statusApprove = statusApprove;
    }

    public int getStatusExpired() {
        return statusExpired;
    }

    public void setStatusExpired(int statusExpired) {
        this.statusExpired = statusExpired;
    }

    public String getGolPrice() {
        return golPrice;
    }

    public void setGolPrice(String golPrice) {
        this.golPrice = golPrice;
    }

    public int getTermOfPayment() {
        return termOfPayment;
    }

    public void setTermOfPayment(int termOfPayment) {
        this.termOfPayment = termOfPayment;
    }
    
}
