package com.project.ccs.postransaction.repack;

import com.project.main.entity.*;

public class RepackItem extends Entity {

    private long repackId;
    private long itemMasterId;
    private double qty;
    private int type;
    private double cogs = 0;
    private double qtyStock;
    private double percentCogs;

    public double getPercentCogs() {
        return percentCogs;
    }

    public void setPercentCogs(double percentCogs) {
        this.percentCogs = percentCogs;
    }
    
    public double getQtyStock() {
        return qtyStock;
    }

    public void setQtyStock(double qtyStock) {
        this.qtyStock = qtyStock;
    }
    
    public long getRepackId() {
        return repackId;
    }

    public void setRepackId(long repackId) {
        this.repackId = repackId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public double getCogs() {
        return cogs;
    }

    public void setCogs(double cogs) {
        this.cogs = cogs;
    }
}
