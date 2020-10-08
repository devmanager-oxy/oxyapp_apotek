/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class LotValue extends Entity{

    private long lotValueId;
    private long lotType;
    private double amountHardCash;
    private double amountCashByTermin;
    private double amountKPA;
    private double rentalRate;
    private int lotQty;
    private long floorId;
    private long lotId;
    private int lotFrom;
    private int lotTo;

    public long getLotValueId() {
        return lotValueId;
    }

    public void setValueTypeId(long lotValueId) {
        this.lotValueId = lotValueId;
    }

    public double getAmountHardCash() {
        return amountHardCash;
    }

    public void setAmountHardCash(double amountHardCash) {
        this.amountHardCash = amountHardCash;
    }

    public double getAmountCashByTermin() {
        return amountCashByTermin;
    }

    public void setAmountCashByTermin(double amountCashByTermin) {
        this.amountCashByTermin = amountCashByTermin;
    }

    public double getAmountKPA() {
        return amountKPA;
    }

    public void setAmountKPA(double amountKPA) {
        this.amountKPA = amountKPA;
    }

    public int getLotQty() {
        return lotQty;
    }

    public void setLotQty(int lotQty) {
        this.lotQty = lotQty;
    }

    public long getFloorId() {
        return floorId;
    }

    public void setFloorId(long floorId) {
        this.floorId = floorId;
    }

    public long getLotId() {
        return lotId;
    }

    public void setLotId(long lotId) {
        this.lotId = lotId;
    }

    public int getLotFrom() {
        return lotFrom;
    }

    public void setLotFrom(int lotFrom) {
        this.lotFrom = lotFrom;
    }

    public int getLotTo() {
        return lotTo;
    }

    public void setLotTo(int lotTo) {
        this.lotTo = lotTo;
    }

    public double getRentalRate() {
        return rentalRate;
    }

    public void setRentalRate(double rentalRate) {
        this.rentalRate = rentalRate;
    }

    public long getLotType() {
        return lotType;
    }

    public void setLotType(long lotType) {
        this.lotType = lotType;
    }

}
