/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
/**
 *
 * @author Roy Andika
 */
import com.project.main.entity.*;

public class Floor extends Entity{

    private int no;
    private String name = "";
    private String discription = "";
    private String facilities = "";
    private int lotQty;
    private long currencyId;
    private double lotPrice;
    private long propertyId;
    private String namePic = "";
    private double bookedRate;
    private double foreignAmount;
    private long buildingId;

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDiscription() {
        return discription;
    }

    public void setDiscription(String discription) {
        this.discription = discription;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public int getLotQty() {
        return lotQty;
    }

    public void setLotQty(int lotQty) {
        this.lotQty = lotQty;
    }

    public double getLotPrice() {
        return lotPrice;
    }

    public void setLotPrice(double lotPrice) {
        this.lotPrice = lotPrice;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public long getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(long propertyId) {
        this.propertyId = propertyId;
    }

    public String getNamePic() {
        return namePic;
    }

    public void setNamePic(String namePic) {
        this.namePic = namePic;
    }

    public double getBookedRate() {
        return bookedRate;
    }

    public void setBookedRate(double bookedRate) {
        this.bookedRate = bookedRate;
    }

    public double getForeignAmount() {
        return foreignAmount;
    }

    public void setForeignAmount(double foreignAmount) {
        this.foreignAmount = foreignAmount;
    }

    public long getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(long buildingId) {
        this.buildingId = buildingId;
    }
    
}
