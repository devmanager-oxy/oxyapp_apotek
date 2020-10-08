/*
 * SesReportGl.java
 *
 * Created on May 6, 2008, 9:47 PM
 */

package com.project.fms.session;

import java.util.Date;
import com.project.main.entity.*;
import java.util.*;

/**
 *
 * @author  Suarjaya
 */
public class SesReportGl extends Entity {
    
    /**
     * Holds value of property transDate.
     */
    private Date transDate = new Date();
    
    /**
     * Holds value of property memo.
     */
    private String memo = "";
    
    /**
     * Holds value of property debet.
     */
    private double debet = 0;
    
    /**
     * Holds value of property credit.
     */
    private double credit = 0;
    
    /**
     * Holds value of property balance.
     */
    private double balance = 0;
    
    /**
     * Holds value of property journalNumber.
     */
    private String journalNumber = "";
    
    /**
     * Holds value of property strTransDate.
     */
    private String strTransDate = "";
    
    /**
     * Holds value of property description.
     */
    private String description;
    
    /**
     * Holds value of property accGroup.
     */
    private String accGroup;
    
    /**
     * Holds value of property type.
     */
    private String type;
    
    /**
     * Getter for property transDate.
     * @return Value of property transDate.
     */
    public Date getTransDate() {
        return this.transDate;
    }
    
    /**
     * Setter for property transDate.
     * @param transDate New value of property transDate.
     */
    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }
    
    /**
     * Getter for property memo.
     * @return Value of property memo.
     */
    public String getMemo() {
        return this.memo;
    }
    
    /**
     * Setter for property memo.
     * @param memo New value of property memo.
     */
    public void setMemo(String memo) {
        this.memo = memo;
    }
    
    /**
     * Getter for property debet.
     * @return Value of property debet.
     */
    public double getDebet() {
        return this.debet;
    }
    
    /**
     * Setter for property debet.
     * @param debet New value of property debet.
     */
    public void setDebet(double debet) {
        this.debet = debet;
    }
    
    /**
     * Getter for property credit.
     * @return Value of property credit.
     */
    public double getCredit() {
        return this.credit;
    }
    
    /**
     * Setter for property credit.
     * @param credit New value of property credit.
     */
    public void setCredit(double credit) {
        this.credit = credit;
    }
    
    /**
     * Getter for property balance.
     * @return Value of property balance.
     */
    public double getBalance() {
        return this.balance;
    }
    
    /**
     * Setter for property balance.
     * @param balance New value of property balance.
     */
    public void setBalance(double balance) {
        this.balance = balance;
    }
    
    /**
     * Getter for property journalNumber.
     * @return Value of property journalNumber.
     */
    public String getJournalNumber() {
        return this.journalNumber;
    }
    
    /**
     * Setter for property journalNumber.
     * @param journalNumber New value of property journalNumber.
     */
    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }
    
    /**
     * Getter for property strTransDate.
     * @return Value of property strTransDate.
     */
    public String getStrTransDate() {
        return this.strTransDate;
    }
    
    /**
     * Setter for property strTransDate.
     * @param strTransDate New value of property strTransDate.
     */
    public void setStrTransDate(String strTransDate) {
        this.strTransDate = strTransDate;
    }
    
    /**
     * Getter for property description.
     * @return Value of property description.
     */
    public String getDescription() {
        return this.description;
    }
    
    /**
     * Setter for property description.
     * @param description New value of property description.
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * Getter for property accGroup.
     * @return Value of property accGroup.
     */
    public String getAccGroup() {
        return this.accGroup;
    }
    
    /**
     * Setter for property accGroup.
     * @param accGroup New value of property accGroup.
     */
    public void setAccGroup(String accGroup) {
        this.accGroup = accGroup;
    }
    
    /**
     * Getter for property type.
     * @return Value of property type.
     */
    public String getType() {
        return this.type;
    }
    
    /**
     * Setter for property type.
     * @param type New value of property type.
     */
    public void setType(String type) {
        this.type = type;
    }
    
}
