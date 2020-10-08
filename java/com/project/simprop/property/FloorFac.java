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
public class FloorFac extends Entity{

    private long floorId;
    private long floorFacilitiesId;
    private int qty;

    public long getFloorId() {
        return floorId;
    }

    public void setFloorId(long floorId) {
        this.floorId = floorId;
    }

    public long getFloorFacilitiesId() {
        return floorFacilitiesId;
    }

    public void setFloorFacilitiesId(long floorFacilitiesId) {
        this.floorFacilitiesId = floorFacilitiesId;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

   
}
