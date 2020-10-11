/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.receiving;
import com.project.main.entity.Entity;
import java.util.Date;

public class ReceiveItem extends Entity {

    private long receiveId;
    private long itemMasterId;
    private double qty;
    private long uomId;
    private String status;
    private double amount;
    private double totalAmount;
    private double totalDiscount;
    private Date deliveryDate;
    private int isBonus;

    /**
     * Holds value of property purchaseItemId.
     */
    private long purchaseItemId;
    
    /**
     * Holds value of property expiredDate.
     */
    private Date expiredDate;
    
    /**
     * Holds value of property apCoaId.
     */
    private long apCoaId;
    private int type;
    private String memo = "";
    private double priceImport;
    private double transport;
    private double bea;
    private double komisi;
    private double lainLain;

    private double qtyPurchase;
    private long uomPurchaseId;

    private double dis1Percent;
    private double dis1Val;
    private double dis2Percent;
    private double dis2Val;
    private double dis3Percent;
    private double dis3Val;
    private double dis4Percent;
    private double dis4Val;

    private String batchNumber = "";
    
    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    } 

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getReceiveId() {
        return receiveId;
    }

    public void setReceiveId(long receiveId) {
        this.receiveId = receiveId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getTotalDiscount() {
        return totalDiscount;
    }

    public void setTotalDiscount(double totalDiscount) {
        this.totalDiscount = totalDiscount;
    }

    public long getUomId() {
        return uomId;
    }

    public void setUomId(long uomId) {
        this.uomId = uomId;
    }
    
    /**
     * Getter for property purchaseItemId.
     * @return Value of property purchaseItemId.
     */
    public long getPurchaseItemId() {
        return this.purchaseItemId;
    }
    
    /**
     * Setter for property purchaseItemId.
     * @param purchaseItemId New value of property purchaseItemId.
     */
    public void setPurchaseItemId(long purchaseItemId) {
        this.purchaseItemId = purchaseItemId;
    }
    
    /**
     * Getter for property expiredDate.
     * @return Value of property expiredDate.
     */
    public Date getExpiredDate() {
        return this.expiredDate;
    }
    
    /**
     * Setter for property expiredDate.
     * @param expiredDate New value of property expiredDate.
     */
    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }
    
    /**
     * Getter for property apCoaId.
     * @return Value of property apCoaId.
     */
    public long getApCoaId() {
        return this.apCoaId;
    }
    
    /**
     * Setter for property apCoaId.
     * @param apCoaId New value of property apCoaId.
     */
    public void setApCoaId(long apCoaId) {
        this.apCoaId = apCoaId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getIsBonus() {
        return isBonus;
    }

    public void setIsBonus(int isBonus) {
        this.isBonus = isBonus;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public double getPriceImport() {
        return priceImport;
    }

    public void setPriceImport(double priceImport) {
        this.priceImport = priceImport;
    }

    public double getTransport() {
        return transport;
    }

    public void setTransport(double transport) {
        this.transport = transport;
    }

    public double getBea() {
        return bea;
    }

    public void setBea(double bea) {
        this.bea = bea;
    }

    public double getKomisi() {
        return komisi;
    }

    public void setKomisi(double komisi) {
        this.komisi = komisi;
    }

    public double getLainLain() {
        return lainLain;
    }

    public void setLainLain(double lainLain) {
        this.lainLain = lainLain;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public double getDis1Percent() {
        return dis1Percent;
    }

    public void setDis1Percent(double dis1Percent) {
        this.dis1Percent = dis1Percent;
    }

    public double getDis1Val() {
        return dis1Val;
    }

    public void setDis1Val(double dis1Val) {
        this.dis1Val = dis1Val;
    }

    public double getDis2Percent() {
        return dis2Percent;
    }

    public void setDis2Percent(double dis2Percent) {
        this.dis2Percent = dis2Percent;
    }

    public double getDis2Val() {
        return dis2Val;
    }

    public void setDis2Val(double dis2Val) {
        this.dis2Val = dis2Val;
    }

    public double getDis3Percent() {
        return dis3Percent;
    }

    public void setDis3Percent(double dis3Percent) {
        this.dis3Percent = dis3Percent;
    }

    public double getDis3Val() {
        return dis3Val;
    }

    public void setDis3Val(double dis3Val) {
        this.dis3Val = dis3Val;
    }

    public double getDis4Percent() {
        return dis4Percent;
    }

    public void setDis4Percent(double dis4Percent) {
        this.dis4Percent = dis4Percent;
    }

    public double getDis4Val() {
        return dis4Val;
    }

    public void setDis4Val(double dis4Val) {
        this.dis4Val = dis4Val;
    }

    public double getQtyPurchase() {
        return qtyPurchase;
    }

    public void setQtyPurchase(double qtyPurchase) {
        this.qtyPurchase = qtyPurchase;
    }

    public long getUomPurchaseId() {
        return uomPurchaseId;
    }

    public void setUomPurchaseId(long uomPurchaseId) {
        this.uomPurchaseId = uomPurchaseId;
    }
    
}
