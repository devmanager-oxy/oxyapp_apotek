
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class PurchaseItem extends Entity { 

	private long purchaseId;
	private String itemName = "";
	private double qty;
	private double price;
	private double totalAmount;
	private double discount;
	private String itemType;
	private long coaId;

        /**
         * Holds value of property coaId2.
         */
        private long coaId2;
        
        /**
         * Holds value of property departmentId.
         */
        private long departmentId;
        
	public long getPurchaseId(){ 
		return purchaseId; 
	} 

	public void setPurchaseId(long purchaseId){ 
		this.purchaseId = purchaseId; 
	} 

	public String getItemName(){ 
		return itemName; 
	} 

	public void setItemName(String itemName){ 
		if ( itemName == null ) {
			itemName = ""; 
		} 
		this.itemName = itemName; 
	} 

	public double getQty(){ 
		return qty; 
	} 

	public void setQty(double qty){ 
		this.qty = qty; 
	} 

	public double getPrice(){ 
		return price; 
	} 

	public void setPrice(double price){ 
		this.price = price; 
	} 

	public double getTotalAmount(){ 
		return totalAmount; 
	} 

	public void setTotalAmount(double totalAmount){ 
		this.totalAmount = totalAmount; 
	} 

	public double getDiscount(){ 
		return discount; 
	} 

	public void setDiscount(double discount){ 
		this.discount = discount; 
	} 

	public String getItemType(){
            return itemType;
        } 

	public void setItemType(String itemType){
            this.itemType = itemType;
        } 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

        /**
         * Getter for property coaId2.
         * @return Value of property coaId2.
         */
        public long getCoaId2() {
            return this.coaId2;
        }
        
        /**
         * Setter for property coaId2.
         * @param coaId2 New value of property coaId2.
         */
        public void setCoaId2(long coaId2) {
            this.coaId2 = coaId2;
        }
        
        /**
         * Getter for property departmentId.
         * @return Value of property departmentId.
         */
        public long getDepartmentId() {
            return this.departmentId;
        }
        
        /**
         * Setter for property departmentId.
         * @param departmentId New value of property departmentId.
         */
        public void setDepartmentId(long departmentId) {
            this.departmentId = departmentId;
        }
        
}
