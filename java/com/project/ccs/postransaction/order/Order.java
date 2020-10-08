
package com.project.ccs.postransaction.order; 
 
import com.project.ccs.postransaction.stock.*;
import java.util.Date;
import com.project.main.entity.Entity;

public class Order extends Entity { 
        private Date date;
	private long locationId;
	private long itemMasterId;
	private long transferId;
	private long transferItemId;
	private long purchaseId;
        private long purchaseItemId;
        private double qtyOrder;
        private String status = "";
        private String number="";
        private int counter;
        private String prefixNumber="";
        private double qtyProces;
        private double qtyStock;
        private double qtyStandar;
        private double qtyPoPrev;
        private Date date_proces;
        
	

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getTransferId() {
        return transferId;
    }

    public void setTransferId(long transferId) {
        this.transferId = transferId;
    }

    public long getTransferItemId() {
        return transferItemId;
    }

    public void setTransferItemId(long transferItemId) {
        this.transferItemId = transferItemId;
    }

    public long getPurchaseId() {
        return purchaseId;
    }

    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
    }

    public long getPurchaseItemId() {
        return purchaseItemId;
    }

    public void setPurchaseItemId(long purchaseItemId) {
        this.purchaseItemId = purchaseItemId;
    }

   

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public double getQtyOrder() {
        return qtyOrder;
    }

    public void setQtyOrder(double qtyOrder) {
        this.qtyOrder = qtyOrder;
    }

    public double getQtyProces() {
        return qtyProces;
    }

    public void setQtyProces(double qtyProces) {
        this.qtyProces = qtyProces;
    }

    public double getQtyStock() {
        return qtyStock;
    }

    public void setQtyStock(double qtyStock) {
        this.qtyStock = qtyStock;
    }

    public double getQtyStandar() {
        return qtyStandar;
    }

    public void setQtyStandar(double qtyStandar) {
        this.qtyStandar = qtyStandar;
    }

    public double getQtyPoPrev() {
        return qtyPoPrev;
    }

    public void setQtyPoPrev(double qtyPoPrev) {
        this.qtyPoPrev = qtyPoPrev;
    }

    public Date getDate_proces() {
        return date_proces;
    }

    public void setDate_proces(Date date_proces) {
        this.date_proces = date_proces;
    }

    
        
}
