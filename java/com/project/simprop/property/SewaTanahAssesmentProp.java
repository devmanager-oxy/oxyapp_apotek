/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class SewaTanahAssesmentProp extends Entity {

    private Date mulai;
    private Date selesai;
    private double rate;
    private long unitKontrakId;
    private int dasarPerhitungan;
    private long sewaTanahId;
    private long currencyId;

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public Date getMulai() {
        return mulai;
    }

    public void setMulai(Date mulai) {
        this.mulai = mulai;
    }

    public Date getSelesai() {
        return selesai;
    }

    public void setSelesai(Date selesai) {
        this.selesai = selesai;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public long getUnitKontrakId() {
        return unitKontrakId;
    }

    public void setUnitKontrakId(long unitKontrakId) {
        this.unitKontrakId = unitKontrakId;
    }

    public int getDasarPerhitungan() {
        return dasarPerhitungan;
    }

    public void setDasarPerhitungan(int dasarPerhitungan) {
        this.dasarPerhitungan = dasarPerhitungan;
    }

    public long getSewaTanahId() {
        return sewaTanahId;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }
}
