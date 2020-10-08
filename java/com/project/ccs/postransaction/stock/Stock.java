
package com.project.ccs.postransaction.stock; 
 
import java.util.Date;
import com.project.main.entity.Entity;

public class Stock extends Entity { 

	private long locationId;
	private int type;
	private double qty;
	private double price;
	private double total;
	private long itemMasterId;
	private String itemCode = "";
	private String itemBarcode = "";
	private String itemName = "";
	private long unitId;
	private String unit = "";
	private int inOut;
	private Date date;
	private long userId;
	private String noFaktur = "";
	private long incomingId;
	private long returId;
	private long transferId;
	private long transferInId;
	private long adjustmentId;
        private long costingId;
        private long costingItemId;
        private long repackId;
        private long repackItemId;
       
        

        /**
         * Holds value of property opnameId.
         */
        private long opnameId;
        
        /**
         * Holds value of property salesDetailId.
         */
        private long salesDetailId;
        private int type_item;
        private long receive_item_id;
        private long retur_item_id;
        private long transfer_item_id;
        private long adjustment_item_id;
        
        private String lot_number;
        private Date expired_date;
         private String status = "";
        
	public long getLocationId(){ 
		return locationId; 
	} 

	public void setLocationId(long locationId){ 
		this.locationId = locationId; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){
		this.type = type; 
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

	public double getTotal(){ 
		return total; 
	} 

	public void setTotal(double total){ 
		this.total = total; 
	} 

	public long getItemMasterId(){ 
		return itemMasterId; 
	} 

	public void setItemMasterId(long itemMasterId){ 
		this.itemMasterId = itemMasterId; 
	} 

	public String getItemCode(){ 
		return itemCode; 
	} 

	public void setItemCode(String itemCode){ 
		if ( itemCode == null ) {
			itemCode = ""; 
		} 
		this.itemCode = itemCode; 
	} 

	public String getItemBarcode(){ 
		return itemBarcode; 
	} 

	public void setItemBarcode(String itemBarcode){ 
		if ( itemBarcode == null ) {
			itemBarcode = ""; 
		} 
		this.itemBarcode = itemBarcode; 
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

	public long getUnitId(){ 
		return unitId; 
	} 

	public void setUnitId(long unitId){ 
		this.unitId = unitId; 
	} 

	public String getUnit(){ 
		return unit; 
	} 

	public void setUnit(String unit){ 
		if ( unit == null ) {
			unit = ""; 
		} 
		this.unit = unit; 
	} 

	public int getInOut(){ 
		return inOut; 
	} 

	public void setInOut(int inOut){ 
		this.inOut = inOut; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getNoFaktur(){ 
		return noFaktur; 
	} 

	public void setNoFaktur(String noFaktur){ 
		if ( noFaktur == null ) {
			noFaktur = ""; 
		} 
		this.noFaktur = noFaktur; 
	} 

	public long getIncomingId(){ 
		return incomingId; 
	} 

	public void setIncomingId(long incomingId){ 
		this.incomingId = incomingId; 
	} 

	public long getReturId(){ 
		return returId; 
	} 

	public void setReturId(long returId){ 
		this.returId = returId; 
	} 

	public long getTransferId(){ 
		return transferId; 
	} 

	public void setTransferId(long transferId){ 
		this.transferId = transferId; 
	} 

	public long getTransferInId(){ 
		return transferInId; 
	} 

	public void setTransferInId(long transferInId){ 
		this.transferInId = transferInId; 
	} 

	public long getAdjustmentId(){ 
		return adjustmentId; 
	} 

	public void setAdjustmentId(long adjustmentId){ 
		this.adjustmentId = adjustmentId; 
	} 

        /**
         * Getter for property opnameId.
         * @return Value of property opnameId.
         */
        public long getOpnameId() {
            return this.opnameId;
        }
        
        /**
         * Setter for property opnameId.
         * @param opnameId New value of property opnameId.
         */
        public void setOpnameId(long opnameId) {
            this.opnameId = opnameId;
        }
        
        /**
         * Getter for property salesDetailId.
         * @return Value of property salesDetailId.
         */
        public long getSalesDetailId() {
            return this.salesDetailId;
        }
        
        /**
         * Setter for property salesDetailId.
         * @param salesDetailId New value of property salesDetailId.
         */
        public void setSalesDetailId(long salesDetailId) {
            this.salesDetailId = salesDetailId;
        }

    public int getType_item() {
        return type_item;
    }

    public void setType_item(int type_item) {
        this.type_item = type_item;
    }

    public long getReceive_item_id() {
        return receive_item_id;
    }

    public void setReceive_item_id(long receive_item_id) {
        this.receive_item_id = receive_item_id;
    }

    public long getRetur_item_id() {
        return retur_item_id;
    }

    public void setRetur_item_id(long retur_item_id) {
        this.retur_item_id = retur_item_id;
    }

    public long getTransfer_item_id() {
        return transfer_item_id;
    }

    public void setTransfer_item_id(long transfer_item_id) {
        this.transfer_item_id = transfer_item_id;
    }

    public long getAdjustment_item_id() {
        return adjustment_item_id;
    }

    public void setAdjustment_item_id(long adjustment_item_id) {
        this.adjustment_item_id = adjustment_item_id;
    }

    public long getCostingId() {
        return costingId;
    }

    public void setCostingId(long costingId) {
        this.costingId = costingId;
    }

    public long getCostingItemId() {
        return costingItemId;
    }

    public void setCostingItemId(long costingItemId) {
        this.costingItemId = costingItemId;
    }

    public long getRepackId() {
        return repackId;
    }

    public void setRepackId(long repackId) {
        this.repackId = repackId;
    }

    public long getRepackItemId() {
        return repackItemId;
    }

    public void setRepackItemId(long repackItemId) {
        this.repackItemId = repackItemId;
    }

    public String getLot_number() {
        return lot_number;
    }

    public void setLot_number(String lot_number) {
        this.lot_number = lot_number;
    }

    public Date getExpired_date() {
        return expired_date;
    }

    public void setExpired_date(Date expired_date) {
        this.expired_date = expired_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
        
}
