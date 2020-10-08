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
public class BuildingFac extends Entity{

    private long buildingId;
    private long buildingFacilitiesId;
    private int qty;

    public long getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(long buildingId) {
        this.buildingId = buildingId;
    }

    public long getBuildingFacilitiesId() {
        return buildingFacilitiesId;
    }

    public void setBuildingFacilitiesId(long buildingFacilitiesId) {
        this.buildingFacilitiesId = buildingFacilitiesId;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    
}
