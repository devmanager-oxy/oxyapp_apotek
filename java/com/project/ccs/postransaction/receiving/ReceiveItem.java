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
    
}
