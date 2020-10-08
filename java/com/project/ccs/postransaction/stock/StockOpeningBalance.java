
package com.project.ccs.postransaction.stock; 
 
import java.util.Date;
import com.project.main.entity.Entity;

public class StockOpeningBalance extends Entity { 

	private long locationId;
        private long itemMasterId;
        private long stockPeriodeId;
        
        private double incoming;
	private double transferOut;
	private double transferIn;
	
	private double sales;
	private double returVendor;
	private double opname;
	
        private double adjusment;
	private double costing;
	private double repack;
        private double balanceStock;

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

    public long getStockPeriodeId() {
        return stockPeriodeId;
    }

    public void setStockPeriodeId(long stockPeriodeId) {
        this.stockPeriodeId = stockPeriodeId;
    }

    public double getIncoming() {
        return incoming;
    }

    public void setIncoming(double incoming) {
        this.incoming = incoming;
    }

    public double getTransferOut() {
        return transferOut;
    }

    public void setTransferOut(double transferOut) {
        this.transferOut = transferOut;
    }

    public double getTransferIn() {
        return transferIn;
    }

    public void setTransferIn(double transferIn) {
        this.transferIn = transferIn;
    }

    public double getSales() {
        return sales;
    }

    public void setSales(double sales) {
        this.sales = sales;
    }

    public double getReturVendor() {
        return returVendor;
    }

    public void setReturVendor(double returVendor) {
        this.returVendor = returVendor;
    }

    public double getOpname() {
        return opname;
    }

    public void setOpname(double opname) {
        this.opname = opname;
    }

    public double getAdjusment() {
        return adjusment;
    }

    public void setAdjusment(double adjusment) {
        this.adjusment = adjusment;
    }

    public double getCosting() {
        return costing;
    }

    public void setCosting(double costing) {
        this.costing = costing;
    }

    public double getRepack() {
        return repack;
    }

    public void setRepack(double repack) {
        this.repack = repack;
    }

    public double getBalanceStock() {
        return balanceStock;
    }

    public void setBalanceStock(double balanceStock) {
        this.balanceStock = balanceStock;
    }
	
        
	
        
}
