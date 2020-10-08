package com.project.fms.master;

import com.project.main.entity.*;

public class PaymentMethod extends Entity {

    private String description = "";
    private int posCode;
    private int status;
    private int order;
    private int merchantPayment;
    private int merchantType;
    private int apStatus;
    private long segment1Id = 0;

    public int getApStatus() {
        return apStatus;
    }

    public void setApStatus(int apStatus) {
        this.apStatus = apStatus;
    }

    public int getMerchantType() {
        return merchantType;
    }

    public void setMerchantType(int merchantType) {
        this.merchantType = merchantType;
    }

    public int getMerchantPayment() {
        return merchantPayment;
    }

    public void setMerchantPayment(int merchantPayment) {
        this.merchantPayment = merchantPayment;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getPosCode() {
        return posCode;
    }

    public void setPosCode(int posCode) {
        this.posCode = posCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null) {
            description = "";
        }
        this.description = description;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }
}
