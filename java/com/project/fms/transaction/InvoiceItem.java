
package com.project.fms.transaction; 
 
import java.util.Date;

import com.project.main.entity.*;

public class InvoiceItem extends Entity { 

	private long purchaseItemId;
	private long invoiceId;
	private long coaId;
	private double invQty;
	private double price = 0;
	private double total = 0;
	private String memo = "";
	private String itemType = "";

        /**
         * Holds value of property itemName.
         */
        private String itemName;
        
        /**
         * Holds value of property departmentId.
         */
        private long departmentId;
        
	public long getPurchaseItemId(){ 
		return purchaseItemId; 
	} 

	public void setPurchaseItemId(long purchaseItemId){ 
		this.purchaseItemId = purchaseItemId; 
	} 

	public long getInvoiceId(){ 
		return invoiceId; 
	} 

	public void setInvoiceId(long invoiceId){ 
		this.invoiceId = invoiceId; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public double getInvQty(){ 
		return invQty; 
	} 

	public void setInvQty(double invQty){ 
		this.invQty = invQty; 
	} 

	public double getPrice(){ 
		return price; 
	} 

	public void setPrice(double price){ 
		this.price = price; 
	} 

	public double getTotal(){ 
		return total; 
	} 

	public void setTotal(double total){ 
		this.total = total; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

	public String getItemType(){ 
		return itemType; 
	} 

	public void setItemType(String itemType){ 
		if ( itemType == null ) {
			itemType = ""; 
		} 
		this.itemType = itemType; 
	} 

        /**
         * Getter for property itemName.
         * @return Value of property itemName.
         */
        public String getItemName() {
            return this.itemName;
        }
        
        /**
         * Setter for property itemName.
         * @param itemName New value of property itemName.
         */
        public void setItemName(String itemName) {
            this.itemName = itemName;
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
