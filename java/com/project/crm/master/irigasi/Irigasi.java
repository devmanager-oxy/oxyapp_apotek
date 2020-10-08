package com.project.crm.master.irigasi;

import com.project.main.entity.*;

public class Irigasi extends Entity {

    private double rate = 0;
    private long unit = 0;
    private int status = 0;
    private double ppnPercent = 0;
    private long periodeId = 0;
    private int priceType = 0;

    public int getPriceType() {
        return priceType;
    }

    public void setPriceType(int priceType) {
        this.priceType = priceType;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public long getUnit() {
        return unit;
    }

    public void setUnit(long unit) {
        this.unit = unit;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getPpnPercent() {
        return ppnPercent;
    }

    public void setPpnPercent(double ppnPercent) {
        this.ppnPercent = ppnPercent;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public long getPeriodeId() {
        return (this.periodeId);
    }
}
