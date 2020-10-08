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
import java.util.Date;

public class SalesData extends Entity{
    
    private long propertyId;    
    private long buildingId;
    private long floorId;
    private long lotId;
    private long lotTypeId;    
    private long userId;    
    private String userName = "";
    private String salesNumber = "";    
    private int journalCounter;
    private String journalPrefix = "";    
    private Date dateTransaction;
    private int paymentType;
    private double salesPrice;
    private double discount;
    private double priceAfterDiscount;
    private double ppn;
    private double finalPrice;    
    private double bfAmount;
    private Date bfDueDate;
    private double dpAmount;
    private Date dpDueDate;    
    private double amountPelunasan;
    private Date pelunasanDueDate;    
    private double persenPelunasan;
    private int periode;
    private double angsuran;
    private double persenAngsuran;
    private Date dueDateAngsuran;
    private double persenBunga;
    private double persenDp;
    private int periodeDp = 1;
    private int status;
    
    //customer
    private long customerId;
    private String name = "";
    private String address = "";
    private String address2 = "";
    private String idNumber = "";
    private String ph = "";
    private String telephone = "";
    private String email = "";
    private String specialRequirement = "";
    private double biayaKpa = 0;
    private String npwp = "";
    
    private long bankId;
    private double coverAmount;
    private long createId;

    public double getBiayaKpa() {
        return biayaKpa;
    }

    public void setBiayaKpa(double biayaKpa) {
        this.biayaKpa = biayaKpa;
    }
    
    public long getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(long propertyId) {
        this.propertyId = propertyId;
    }

    public long getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(long buildingId) {
        this.buildingId = buildingId;
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

    public long getLotTypeId() {
        return lotTypeId;
    }

    public void setLotTypeId(long lotTypeId) {
        this.lotTypeId = lotTypeId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getSalesNumber() {
        return salesNumber;
    }

    public void setSalesNumber(String salesNumber) {
        this.salesNumber = salesNumber;
    }

    public Date getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(Date dateTransaction) {
        this.dateTransaction = dateTransaction;
    }

    public int getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(int paymentType) {
        this.paymentType = paymentType;
    }

    public double getSalesPrice() {
        return salesPrice;
    }

    public void setSalesPrice(double salesPrice) {
        this.salesPrice = salesPrice;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getPriceAfterDiscount() {
        return priceAfterDiscount;
    }

    public void setPriceAfterDiscount(double priceAfterDiscount) {
        this.priceAfterDiscount = priceAfterDiscount;
    }

    public double getPpn() {
        return ppn;
    }

    public void setPpn(double ppn) {
        this.ppn = ppn;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }

    public double getBfAmount() {
        return bfAmount;
    }

    public void setBfAmount(double bfAmount) {
        this.bfAmount = bfAmount;
    }

    public Date getBfDueDate() {
        return bfDueDate;
    }

    public void setBfDueDate(Date bfDueDate) {
        this.bfDueDate = bfDueDate;
    }

    public double getDpAmount() {
        return dpAmount;
    }

    public void setDpAmount(double dpAmount) {
        this.dpAmount = dpAmount;
    }

    public Date getDpDueDate() {
        return dpDueDate;
    }

    public void setDpDueDate(Date dpDueDate) {
        this.dpDueDate = dpDueDate;
    }

    public double getAmountPelunasan() {
        return amountPelunasan;
    }

    public void setAmountPelunasan(double amountPelunasan) {
        this.amountPelunasan = amountPelunasan;
    }

    public Date getPelunasanDueDate() {
        return pelunasanDueDate;
    }

    public void setPelunasanDueDate(Date pelunasanDueDate) {
        this.pelunasanDueDate = pelunasanDueDate;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getPh() {
        return ph;
    }

    public void setPh(String ph) {
        this.ph = ph;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSpecialRequirement() {
        return specialRequirement;
    }

    public void setSpecialRequirement(String specialRequirement) {
        this.specialRequirement = specialRequirement;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getJournalCounter() {
        return journalCounter;
    }

    public void setJournalCounter(int journalCounter) {
        this.journalCounter = journalCounter;
    }

    public String getJournalPrefix() {
        return journalPrefix;
    }

    public void setJournalPrefix(String journalPrefix) {
        this.journalPrefix = journalPrefix;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public double getPersenPelunasan() {
        return persenPelunasan;
    }

    public void setPersenPelunasan(double persenPelunasan) {
        this.persenPelunasan = persenPelunasan;
    }

    public int getPeriode() {
        return periode;
    }

    public void setPeriode(int periode) {
        this.periode = periode;
    }

    public double getAngsuran() {
        return angsuran;
    }

    public void setAngsuran(double angsuran) {
        this.angsuran = angsuran;
    }

    public double getPersenAngsuran() {
        return persenAngsuran;
    }

    public void setPersenAngsuran(double persenAngsuran) {
        this.persenAngsuran = persenAngsuran;
    }

    public Date getDueDateAngsuran() {
        return dueDateAngsuran;
    }

    public void setDueDateAngsuran(Date dueDateAngsuran) {
        this.dueDateAngsuran = dueDateAngsuran;
    }

    public double getPersenBunga() {
        return persenBunga;
    }

    public void setPersenBunga(double persenBunga) {
        this.persenBunga = persenBunga;
    }

    public double getPersenDp() {
        return persenDp;
    }

    public void setPersenDp(double persenDp) {
        this.persenDp = persenDp;
    }

    public int getPeriodeDp() {
        return periodeDp;
    }

    public void setPeriodeDp(int periodeDp) {
        this.periodeDp = periodeDp;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public double getCoverAmount() {
        return coverAmount;
    }

    public void setCoverAmount(double coverAmount) {
        this.coverAmount = coverAmount;
    }

    public long getCreateId() {
        return createId;
    }

    public void setCreateId(long createId) {
        this.createId = createId;
    }

    public String getNpwp() {
        return npwp;
    }

    public void setNpwp(String npwp) {
        this.npwp = npwp;
    }
}
