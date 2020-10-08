/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author Tu Roy
 */
public class IndukCustomer extends Entity {

    private String name = "";
    private String address = "";
    private String city = "";
    private long countryId = 0;
    private String postalCode = "";
    private String contactPerson = "";
    private String posisiContactPerson = "";
    private String countryCode = "";
    private String areaCode = "";
    private String phone = "";
    private String website = "";
    private String email = "";
    private String npwp = "";
    private String fax = "";

    public void setFax(String fax) {
        this.fax = fax;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setCountryId(long countryId) {
        this.countryId = countryId;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public void setPosisiContactPerson(String posisiContactPerson) {
        this.posisiContactPerson = posisiContactPerson;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFax() {
        return (this.fax);
    }

    public String getName() {
        return (this.name);
    }

    public String getAddress() {
        return (this.address);
    }

    public String getCity() {
        return (this.city);
    }

    public long getCountryId() {
        return (this.countryId);
    }

    public String getPostalCode() {
        return (this.postalCode);
    }

    public String getContactPerson() {
        return (this.contactPerson);
    }

    public String getPosisiContactPerson() {
        return (this.posisiContactPerson);
    }

    public String getCountryCode() {
        return (this.countryCode);
    }

    public String getAreaCode() {
        return (this.areaCode);
    }

    public String getPhone() {
        return (this.phone);
    }

    public String getWebsite() {
        return (this.website);
    }

    public String getEmail() {
        return (this.email);
    }

    public void setNpwp(String npwp) {
        this.npwp = npwp;
    }

    public String getNpwp() {
        return (this.npwp);
    }
}
