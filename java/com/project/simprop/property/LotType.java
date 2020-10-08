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
public class LotType extends Entity{

    private long lotTypeId;
    private String lotType;
    private double amountHardCash;
    private double amountCashByTermin;
    private double amountKPA;
    private double rentalRate;    
    private int salesType;
    private String namePic = "";    

    public long getLotTypeId() {
        return lotTypeId;
    }

    public void setLotTypeId(long lotTypeId) {
        this.lotTypeId = lotTypeId;
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

    public double getRentalRate() {
        return rentalRate;
    }

    public void setRentalRate(double rentalRate) {
        this.rentalRate = rentalRate;
    }

    public int getSalesType() {
        return salesType;
    }

    public void setSalesType(int salesType) {
        this.salesType = salesType;
    }

    public String getNamePic() {
        return namePic;
    }

    public void setNamePic(String namePic) {
        this.namePic = namePic;
    }

    public String getLotType() {
        return lotType;
    }

    public void setLotType(String lotType) {
        this.lotType = lotType;
    }

       
}
