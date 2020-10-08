/*
 * SrcCustomer.java
 *
 * Created on August 23, 2007, 4:03 PM
 */

package com.project.general;

/**
 *
 * @author  TOSHIBA
 */
public class SrcCustomer {
    
    /**
     * Holds value of property address.
     */
    private String address="";
    
    /**
     * Holds value of property country.
     */
    private String country="";
    
    /**
     * Holds value of property nationality.
     */
    private String nationality="";
    
    /**
     * Holds value of property dobFrom.
     */
    private String dobFrom="";
    
    /**
     * Holds value of property dobTo.
     */
    private String dobTo="";
    
    /**
     * Holds value of property name.
     */
    private String name="";
    
    /**
     * Holds value of property dobIgnore.
     */
    private int dobIgnore=1;
    
    /** Creates a new instance of SrcCustomer */
    public SrcCustomer() {
    }
    
    /**
     * Getter for property address.
     * @return Value of property address.
     */
    public String getAddress() {
        return this.address;
    }
    
    /**
     * Setter for property address.
     * @param address New value of property address.
     */
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * Getter for property country.
     * @return Value of property country.
     */
    public String getCountry() {
        return this.country;
    }
    
    /**
     * Setter for property country.
     * @param country New value of property country.
     */
    public void setCountry(String country) {
        this.country = country;
    }
    
    /**
     * Getter for property nationality.
     * @return Value of property nationality.
     */
    public String getNationality() {
        return this.nationality;
    }
    
    /**
     * Setter for property nationality.
     * @param nationality New value of property nationality.
     */
    public void setNationality(String nationality) {
        this.nationality = nationality;
    }
    
    /**
     * Getter for property dobfrom.
     * @return Value of property dobfrom.
     */
    public String getDobFrom() {
        return this.dobFrom;
    }
    
    /**
     * Setter for property dobfrom.
     * @param dobfrom New value of property dobfrom.
     */
    public void setDobFrom(String dobFrom) {
        this.dobFrom = dobFrom;
    }
    
    /**
     * Getter for property dobTo.
     * @return Value of property dobTo.
     */
    public String getDobTo() {
        return this.dobTo;
    }
    
    /**
     * Setter for property dobTo.
     * @param dobTo New value of property dobTo.
     */
    public void setDobTo(String dobTo) {
        this.dobTo = dobTo;
    }
    
    /**
     * Getter for property name.
     * @return Value of property name.
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Setter for property name.
     * @param name New value of property name.
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * Getter for property dobIgnore.
     * @return Value of property dobIgnore.
     */
    public int getDobIgnore() {
        return this.dobIgnore;
    }
    
    /**
     * Setter for property dobIgnore.
     * @param dobIgnore New value of property dobIgnore.
     */
    public void setDobIgnore(int dobIgnore) {
        this.dobIgnore = dobIgnore;
    }
    
}
