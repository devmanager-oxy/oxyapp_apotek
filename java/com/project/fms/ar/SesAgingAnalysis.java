/***********************************\
|  Create by Dek-Ndut               |
|                                   |
|  3/3/2008 11:30:57 AM
\***********************************/

package com.project.fms.ar;

import java.util.Date;
import com.project.main.entity.*;
import java.util.*;

public class SesAgingAnalysis extends Entity {
   
    /**
     * Holds value of property sequence.
     */
    private int sequence = 0;    
    
    /**
     * Holds value of property customerCode.
     */
    private String customerCode = "";
    
    /**
     * Holds value of property customerName.
     */
    private String customerName = "";
    
    /**
     * Holds value of property ageCurrent.
     */
    private double ageCurrent = 0;
    
    /**
     * Holds value of property ageOver30.
     */
    private double ageOver30 = 0;
    
    /**
     * Holds value of property ageOver60.
     */
    private double ageOver60 = 0;
    
    /**
     * Holds value of property ageOver90.
     */
    private double ageOver90 = 0;
    
    /**
     * Holds value of property ageOver120.
     */
    private double ageOver120 = 0;
    
    /**
     * Holds value of property lastPaymentDate.
     */
    private Date lastPaymentDate;
    
    /**
     * Holds value of property lastPaymentAmount.
     */
    private double lastPaymentAmount = 0;
    
    /**
     * Getter for property sequence.
     * @return Value of property sequence.
     */
    public int getSequence() {
        return this.sequence;
    }
    
    /**
     * Setter for property sequence.
     * @param sequence New value of property sequence.
     */
    public void setSequence(int sequence) {
        this.sequence = sequence;
    }
    
    /**
     * Getter for property customerCode.
     * @return Value of property customerCode.
     */
    public String getCustomerCode() {
        return this.customerCode;
    }
    
    /**
     * Setter for property customerCode.
     * @param customerCode New value of property customerCode.
     */
    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }
    
    /**
     * Getter for property customerName.
     * @return Value of property customerName.
     */
    public String getCustomerName() {
        return this.customerName;
    }
    
    /**
     * Setter for property customerName.
     * @param customerName New value of property customerName.
     */
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    /**
     * Getter for property ageCurrent.
     * @return Value of property ageCurrent.
     */
    public double getAgeCurrent() {
        return this.ageCurrent;
    }
    
    /**
     * Setter for property ageCurrent.
     * @param ageCurrent New value of property ageCurrent.
     */
    public void setAgeCurrent(double ageCurrent) {
        this.ageCurrent = ageCurrent;
    }
    
    /**
     * Getter for property ageOver30.
     * @return Value of property ageOver30.
     */
    public double getAgeOver30() {
        return this.ageOver30;
    }
    
    /**
     * Setter for property ageOver30.
     * @param ageOver30 New value of property ageOver30.
     */
    public void setAgeOver30(double ageOver30) {
        this.ageOver30 = ageOver30;
    }
    
    /**
     * Getter for property ageOver60.
     * @return Value of property ageOver60.
     */
    public double getAgeOver60() {
        return this.ageOver60;
    }
    
    /**
     * Setter for property ageOver60.
     * @param ageOver60 New value of property ageOver60.
     */
    public void setAgeOver60(double ageOver60) {
        this.ageOver60 = ageOver60;
    }
    
    /**
     * Getter for property ageOver90.
     * @return Value of property ageOver90.
     */
    public double getAgeOver90() {
        return this.ageOver90;
    }
    
    /**
     * Setter for property ageOver90.
     * @param ageOver90 New value of property ageOver90.
     */
    public void setAgeOver90(double ageOver90) {
        this.ageOver90 = ageOver90;
    }
    
    /**
     * Getter for property ageOver120.
     * @return Value of property ageOver120.
     */
    public double getAgeOver120() {
        return this.ageOver120;
    }
    
    /**
     * Setter for property ageOver120.
     * @param ageOver120 New value of property ageOver120.
     */
    public void setAgeOver120(double ageOver120) {
        this.ageOver120 = ageOver120;
    }
    
    /**
     * Getter for property lastPaymentDate.
     * @return Value of property lastPaymentDate.
     */
    public Date getLastPaymentDate() {
        return this.lastPaymentDate;
    }
    
    /**
     * Setter for property lastPaymentDate.
     * @param lastPaymentDate New value of property lastPaymentDate.
     */
    public void setLastPaymentDate(Date lastPaymentDate) {
        this.lastPaymentDate = lastPaymentDate;
    }
    
    /**
     * Getter for property lastPaymentAmount.
     * @return Value of property lastPaymentAmount.
     */
    public double getLastPaymentAmount() {
        return this.lastPaymentAmount;
    }
    
    /**
     * Setter for property lastPaymentAmount.
     * @param lastPaymentAmount New value of property lastPaymentAmount.
     */
    public void setLastPaymentAmount(double lastPaymentAmount) {
        this.lastPaymentAmount = lastPaymentAmount;
    }
    
    
    public static void main(String[] args){
        
        double hasil = Math.pow(10,2);
        //double hasil = (1/(1.52/100))^(5*12);
        
        System.out.println("hasil : "+hasil);
        
        System.out.println(100000000/((1-(Math.pow((1/(1.52/100)),(5*12))))/(1.25/100)));
       
        double x = Math.pow(1/(1+(1.52/100)),(5*12));
        
        double y = ((1-x))/(1.52/100);
        
        double abc =100000000/y;
        
        System.out.println("x : "+x);
        System.out.println("y : "+y);
        System.out.println("abc : "+abc);        
        
    }
    
    
}
