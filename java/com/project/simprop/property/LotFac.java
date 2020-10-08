/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import com.project.main.entity.*;
/**
 *
 * @author Roy Andika
 */
public class LotFac extends Entity{

    private long lotId;
    private long lotFacilitiesId;
    private int qty;

    public long getLotId() {
        return lotId;
    }

    public void setLotId(long lotId) {
        this.lotId = lotId;
    }

    public long getLotFacilitiesId() {
        return lotFacilitiesId;
    }

    public void setLotFacilitiesId(long lotFacilitiesId) {
        this.lotFacilitiesId = lotFacilitiesId;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }
}
