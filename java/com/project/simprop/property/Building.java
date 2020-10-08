/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

/**
 *
 * @author Roy Andika
 */
import com.project.main.entity.*;

public class Building extends Entity {

    private long propertyId;
    private int salesType;
    private String buildingName = "";
    private int buildingType;
    private int numberOfFloor;
    private int selectFacilitiesOther;
    private String nameFacilitiesOther = "";
    private String description = "";
    private int buildingStatus;
    private String namePic = "";

    public int getSalesType() {
        return salesType;
    }

    public void setSalesType(int salesType) {
        this.salesType = salesType;
    }

    public String getBuildingName() {
        return buildingName;
    }

    public void setBuildingName(String buildingName) {
        this.buildingName = buildingName;
    }

    public int getNumberOfFloor() {
        return numberOfFloor;
    }

    public void setNumberOfFloor(int numberOfFloor) {
        this.numberOfFloor = numberOfFloor;
    }

    public int getSelectFacilitiesOther() {
        return selectFacilitiesOther;
    }

    public void setSelectFacilitiesOther(int selectFacilitiesOther) {
        this.selectFacilitiesOther = selectFacilitiesOther;
    }

    public String getNameFacilitiesOther() {
        return nameFacilitiesOther;
    }

    public void setNameFacilitiesOther(String nameFacilitiesOther) {
        this.nameFacilitiesOther = nameFacilitiesOther;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(long propertyId) {
        this.propertyId = propertyId;
    }

    public int getBuildingType() {
        return buildingType;
    }

    public void setBuildingType(int buildingType) {
        this.buildingType = buildingType;
    }

    public int getBuildingStatus() {
        return buildingStatus;
    }

    public void setBuildingStatus(int buildingStatus) {
        this.buildingStatus = buildingStatus;
    }

    public String getNamePic() {
        return namePic;
    }

    public void setNamePic(String namePic) {
        this.namePic = namePic;
    }
}
