

package com.project.ccs.postransaction.adjusment; 
 
import com.project.main.entity.*;

public class AdjusmentItem extends Entity {

	private long adjusmentId;
	private long itemMasterId;
	private double qtyReal;
        private double qtySystem;
	private double price;
	private double amount;
        private int type;
        private long company_id;

        /**
         * Holds value of property qtyBalance.
         */
        private double qtyBalance;
        
	public long getAdjusmentId(){
		return adjusmentId;
	} 

	public void setAdjusmentId(long adjusmentId){
		this.adjusmentId = adjusmentId;
	} 

	public long getItemMasterId(){ 
		return itemMasterId; 
	} 

	public void setItemMasterId(long itemMasterId){ 
		this.itemMasterId = itemMasterId; 
	}

    public double getQtyReal() { 
        return qtyReal;
    }

    public void setQtyReal(double qtyReal) { 
        this.qtyReal = qtyReal;
    }

    public double getQtySystem() {
        return qtySystem;
    }

    public void setQtySystem(double qtySystem) {
        this.qtySystem = qtySystem;
    }

	public double getPrice(){ 
		return price; 
	} 

	public void setPrice(double price){ 
		this.price = price; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

        /**
         * Getter for property qtyBalance.
         * @return Value of property qtyBalance.
         */
        public double getQtyBalance() {
            return this.qtyBalance;
        }
        
        /**
         * Setter for property qtyBalance.
         * @param qtyBalance New value of property qtyBalance.
         */
        public void setQtyBalance(double qtyBalance) {
            this.qtyBalance = qtyBalance;
        }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getCompany_id() {
        return company_id;
    }

    public void setCompany_id(long company_id) {
        this.company_id = company_id;
    }
        
}
