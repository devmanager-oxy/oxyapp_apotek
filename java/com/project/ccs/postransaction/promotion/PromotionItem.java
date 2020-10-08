
package com.project.ccs.postransaction.promotion; 
 
import com.project.ccs.postransaction.costing.*;
import java.util.Date;
import com.project.main.entity.*;

public class PromotionItem extends Entity { 

	private long promotionId;
	private long itemMasterId;
        private String itemName;
        private String itemCode;
        private String itemBarcode;
        private double discountPercent;
        private double discountValue;
        private double sellingPrice;
        private int tipe;
        private double qtyMin;
        private double qtyBonus;
        private int isVariant;
        

    public long getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(long promotionId) {
        this.promotionId = promotionId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getItemBarcode() {
        return itemBarcode;
    }

    public void setItemBarcode(String itemBarcode) {
        this.itemBarcode = itemBarcode;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getTipe() {
        return tipe;
    }

    public void setTipe(int tipe) {
        this.tipe = tipe;
    }

    public double getQtyMin() {
        return qtyMin;
    }

    public void setQtyMin(double qtyMin) {
        this.qtyMin = qtyMin;
    }

    public double getQtyBonus() {
        return qtyBonus;
    }

    public void setQtyBonus(double qtyBonus) {
        this.qtyBonus = qtyBonus;
    }

    public int getIsVariant() {
        return isVariant;
    }

    public void setIsVariant(int isVariant) {
        this.isVariant = isVariant;
    }

   
        
	
}
