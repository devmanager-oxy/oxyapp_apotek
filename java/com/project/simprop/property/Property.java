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
import java.util.Date;

public class Property extends Entity{
    
    private int salesType;
    private String buildingName = "";
    private long locationId;
    private String address = "";
    private String city = "";
    private int propertyType;
    private String imbNumber = "";
    private String owner = "";
    private String landSertificateNumber = "";
    private int numberOfFloor;    
    private int selectFacilitiesOther;
    private String nameFacilitiesOther = "";
    private String description = "";
    private int propertyStatus;
    private String locationMap = "";    
    private String landArea = "";
    private String buildingArea = "";
    private Date commencement = new Date();
    private Date completion = new Date();
    private String developer = "";

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

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(int propertyType) {
        this.propertyType = propertyType;
    }

    public String getImbNumber() {
        return imbNumber;
    }

    public void setImbNumber(String imbNumber) {
        this.imbNumber = imbNumber;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getLandSertificateNumber() {
        return landSertificateNumber;
    }

    public void setLandSertificateNumber(String landSertificateNumber) {
        this.landSertificateNumber = landSertificateNumber;
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

    public int getPropertyStatus() {
        return propertyStatus;
    }

    public void setPropertyStatus(int propertyStatus) {
        this.propertyStatus = propertyStatus;
    }

    public String getLocationMap() {
        return locationMap;
    }

    public void setLocationMap(String locationMap) {
        this.locationMap = locationMap;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getLandArea() {
        return landArea;
    }

    public void setLandArea(String landArea) {
        this.landArea = landArea;
    }

    public String getBuildingArea() {
        return buildingArea;
    }

    public void setBuildingArea(String buildingArea) {
        this.buildingArea = buildingArea;
    }

    public Date getCommencement() {
        return commencement;
    }

    public void setCommencement(Date commencement) {
        this.commencement = commencement;
    }

    public Date getCompletion() {
        return completion;
    }

    public void setCompletion(Date completion) {
        this.completion = completion;
    }

    public String getDeveloper() {
        return developer;
    }

    public void setDeveloper(String developer) {
        this.developer = developer;
    }
    
    
}
