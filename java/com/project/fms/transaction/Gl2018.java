/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class Gl2018 extends Entity{
    
    private String journalNumber = "";
    private int journalCounter = 0;
    private String journalPrefix = "";
    private Date date = new Date();
    private Date transDate = new Date();
    private long operatorId = 0;
    private String operatorName = "";
    private int journalType = 0;
    private long ownerId = 0;
    private String refNumber = "";
    private long currencyId = 0;
    private String memo = "";
    private int isReversal = 0;
    private Date reversalDate = new Date();
    private int reversalType = 0;
    private int reversalStatus = 0;
    private int postedStatus = 0;
    private long postedById = 0;
    private Date postedDate;
    private Date effectiveDate;
    private long referensiId = 0;

    public int getIsReversal() {
        return isReversal;
    }

    public void setIsReversal(int isReversal) {
        this.isReversal = isReversal;
    }

    public Date getReversalDate() {
        return reversalDate;
    }

    public void setReversalDate(Date reversalDate) {
        this.reversalDate = reversalDate;
    }

    public int getReversalStatus() {
        return reversalStatus;
    }

    public void setReversalStatus(int reversalStatus) {
        this.reversalStatus = reversalStatus;
    }

    public int getReversalType() {
        return reversalType;
    }

    public void setReversalType(int reversalType) {
        this.reversalType = reversalType;
    }
    /**
     * Holds value of property periodId.
     */
    private long periodId;
    /**
     * Holds value of property activityStatus.
     */
    private String activityStatus;
    /**
     * Holds value of property notActivityBase.
     */
    private int notActivityBase;

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        if (journalNumber == null) {
            journalNumber = "";
        }
        this.journalNumber = journalNumber;
    }

    public int getJournalCounter() {
        return journalCounter;
    }

    public void setJournalCounter(int journalCounter) {
        this.journalCounter = journalCounter;
    }

    public String getJournalPrefix() {
        return journalPrefix;
    }

    public void setJournalPrefix(String journalPrefix) {
        if (journalPrefix == null) {
            journalPrefix = "";
        }
        this.journalPrefix = journalPrefix;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

    public long getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(long operatorId) {
        this.operatorId = operatorId;
    }

    public String getOperatorName() {
        return operatorName;
    }

    public void setOperatorName(String operatorName) {
        if (operatorName == null) {
            operatorName = "";
        }
        this.operatorName = operatorName;
    }

    public int getJournalType() {
        return journalType;
    }

    public void setJournalType(int journalType) {
        this.journalType = journalType;
    }

    public long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(long ownerId) {
        this.ownerId = ownerId;
    }

    public String getRefNumber() {
        return refNumber;
    }

    public void setRefNumber(String refNumber) {
        this.refNumber = refNumber;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        if (memo == null) {
            memo = "";
        }
        this.memo = memo;
    }

    public long getPeriodId() {
        return this.periodId;
    }

    public void setPeriodId(long periodId) {
        this.periodId = periodId;
    }

    /**
     * Getter for property activityStatus.
     * @return Value of property activityStatus.
     */
    public String getActivityStatus() {
        return this.activityStatus;
    }

    /**
     * Setter for property activityStatus.
     * @param activityStatus New value of property activityStatus.
     */
    public void setActivityStatus(String activityStatus) {
        this.activityStatus = activityStatus;
    }

    public int getNotActivityBase() {
        return this.notActivityBase;
    }

    public void setNotActivityBase(int notActivityBase) {
        this.notActivityBase = notActivityBase;
    }

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public long getReferensiId() {
        return referensiId;
    }

    public void setReferensiId(long referensiId) {
        this.referensiId = referensiId;
    }

}
