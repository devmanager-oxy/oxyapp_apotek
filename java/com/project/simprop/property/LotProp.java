/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.main.entity.Entity;

/**
 *
 * @author Tu Roy
 */
public class LotProp extends Entity {

    private String nama = "";
    private double panjang = 0;
    private double lebar = 0;
    private double luas = 0;
    private String keterangan = "";
    private int status;    
    private int no;
    private long foreignCurrencyId;
    private double foreignAmount;
    private double bookedRate;
    private double amount;
    private String namePic = "";
    private long propertyId;
    private long floorId;
    private long buildingId;
    private double cashKeras;
    private double cashByTermin;
    private double kpa;
    private long lotValueId;
    private double rentalRate;
    private long lotTypeId;

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public double getPanjang() {
        return panjang;
    }

    public void setPanjang(double panjang) {
        this.luas = this.lebar * panjang;
        this.panjang = panjang;
    }

    public double getLebar() {
        return lebar;
    }

    public void setLebar(double lebar) {
        this.luas = lebar * this.panjang;
        this.lebar = lebar;
    }

    public double getLuas() {
        return luas;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getNamePic() {
        return namePic;
    }

    public void setNamePic(String namePic) {
        this.namePic = namePic;
    }

    public long getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(long propertyId) {
        this.propertyId = propertyId;
    }

    public long getFloorId() {
        return floorId;
    }

    public void setFloorId(long floorId) {
        this.floorId = floorId;
    }

    public long getForeignCurrencyId() {
        return foreignCurrencyId;
    }

    public void setForeignCurrencyId(long foreignCurrencyId) {
        this.foreignCurrencyId = foreignCurrencyId;
    }

    public double getForeignAmount() {
        return foreignAmount;
    }

    public void setForeignAmount(double foreignAmount) {
        this.foreignAmount = foreignAmount;
    }

    public double getBookedRate() {
        return bookedRate;
    }

    public void setBookedRate(double bookedRate) {
        this.bookedRate = bookedRate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(long buildingId) {
        this.buildingId = buildingId;
    }

    public double getCashKeras() {
        return cashKeras;
    }

    public void setCashKeras(double cashKeras) {
        this.cashKeras = cashKeras;
    }

    public double getCashByTermin() {
        return cashByTermin;
    }

    public void setCashByTermin(double cashByTermin) {
        this.cashByTermin = cashByTermin;
    }

    public double getKpa() {
        return kpa;
    }

    public void setKpa(double kpa) {
        this.kpa = kpa;
    }

    public long getLotValueId() {
        return lotValueId;
    }

    public void setLotValueId(long lotValueId) {
        this.lotValueId = lotValueId;
    }

    public double getRentalRate() {
        return rentalRate;
    }

    public void setRentalRate(double rentalRate) {
        this.rentalRate = rentalRate;
    }

    public long getLotTypeId() {
        return lotTypeId;
    }

    public void setLotTypeId(long lotTypeId) {
        this.lotTypeId = lotTypeId;
    }

   
}
