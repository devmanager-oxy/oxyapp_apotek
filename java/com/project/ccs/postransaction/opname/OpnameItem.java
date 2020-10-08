

package com.project.ccs.postransaction.opname; 
 
import com.project.main.entity.*;
import java.util.Date;

public class OpnameItem extends Entity { 

	private long opnameId;
	private long itemMasterId;
	private double qtyReal;
        private double qtySystem;
	private double price;
	private double amount;

        /**
         * Holds value of property note.
         */
        private String note;
        private int type;
        private long subLocationId;
        private long opnameSubLocationId;
        private Date date;
        
	public long getOpnameId(){ 
		return opnameId; 
	} 

	public void setOpnameId(long opnameId){ 
		this.opnameId = opnameId; 
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
         * Getter for property note.
         * @return Value of property note.
         */
        public String getNote() {
            return this.note;
        }
        
        /**
         * Setter for property note.
         * @param note New value of property note.
         */
        public void setNote(String note) {
            this.note = note;
        }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getSubLocationId() {
        return subLocationId;
    }

    public void setSubLocationId(long subLocationId) {
        this.subLocationId = subLocationId;
    }

    public long getOpnameSubLocationId() {
        return opnameSubLocationId;
    }

    public void setOpnameSubLocationId(long opnameSubLocationId) {
        this.opnameSubLocationId = opnameSubLocationId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
        
}
