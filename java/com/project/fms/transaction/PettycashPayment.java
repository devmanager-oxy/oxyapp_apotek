
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

/* package java */
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class PettycashPayment extends Entity {

    private long coaId;
    private String journalNumber = "";
    private int journalCounter;
    private String journalPrefix = "";
    private Date date;
    private Date transDate;
    private String memo = "";
    private long operatorId;
    private String operatorName = "";
    private double amount;
    private int replaceStatus;
    private String paymentTo = "";
    /**
     * Holds value of property accountBalance.
     */
    private double accountBalance;
    /**
     * Holds value of property activityStatus.
     */
    private String activityStatus;
    /**
     * Holds value of property shareGroupId.
     */
    private long shareGroupId;
    /**
     * Holds value of property shareCategoryId.
     */
    private long shareCategoryId;
    /**
     * Holds value of property status.
     */
    private int status;
    /**
     * Holds value of property expenseCategoryId.
     */
    private long expenseCategoryId;
    private int postedStatus;
    private long postedById;
    private Date postedDate;
    private Date effectiveDate;
    private int type;
    private long customerId;
    //add untuk menu kasbon
    private int typeKasbon;
    private long employeeId;
    private long referensiId;
    //added by eka    
    private long segment1Id;
    private long segment2Id;
    private long segment3Id;
    private long segment4Id;
    private long segment5Id;
    private long segment6Id;
    private long segment7Id;
    private long segment8Id;
    private long segment9Id;
    private long segment10Id;
    private long segment11Id;
    private long segment12Id;
    private long segment13Id;
    private long segment14Id;
    private long segment15Id;
    private long periodeId;

    //====== segment
    public long getSegment15Id() {
        return segment15Id;
    }

    public void setSegment15Id(long segment15Id) {
        this.segment15Id = segment15Id;
    }

    public long getSegment14Id() {
        return segment14Id;
    }

    public void setSegment14Id(long segment14Id) {
        this.segment14Id = segment14Id;
    }

    public long getSegment13Id() {
        return segment13Id;
    }

    public void setSegment13Id(long segment13Id) {
        this.segment13Id = segment13Id;
    }

    public long getSegment12Id() {
        return segment12Id;
    }

    public void setSegment12Id(long segment12Id) {
        this.segment12Id = segment12Id;
    }

    public long getSegment11Id() {
        return segment11Id;
    }

    public void setSegment11Id(long segment11Id) {
        this.segment11Id = segment11Id;
    }

    public long getSegment10Id() {
        return segment10Id;
    }

    public void setSegment10Id(long segment10Id) {
        this.segment10Id = segment10Id;
    }

    public long getSegment9Id() {
        return segment9Id;
    }

    public void setSegment9Id(long segment9Id) {
        this.segment9Id = segment9Id;
    }

    public long getSegment8Id() {
        return segment8Id;
    }

    public void setSegment8Id(long segment8Id) {
        this.segment8Id = segment8Id;
    }

    public long getSegment7Id() {
        return segment7Id;
    }

    public void setSegment7Id(long segment7Id) {
        this.segment7Id = segment7Id;
    }

    public long getSegment6Id() {
        return segment6Id;
    }

    public void setSegment6Id(long segment6Id) {
        this.segment6Id = segment6Id;
    }

    public long getSegment5Id() {
        return segment5Id;
    }

    public void setSegment5Id(long segment5Id) {
        this.segment5Id = segment5Id;
    }

    public long getSegment4Id() {
        return segment4Id;
    }

    public void setSegment4Id(long segment4Id) {
        this.segment4Id = segment4Id;
    }

    public long getSegment3Id() {
        return segment3Id;
    }

    public void setSegment3Id(long segment3Id) {
        this.segment3Id = segment3Id;
    }

    public long getSegment2Id() {
        return segment2Id;
    }

    public void setSegment2Id(long segment2Id) {
        this.segment2Id = segment2Id;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }

    //========	  
    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

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

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        if (memo == null) {
            memo = "";
        }
        this.memo = memo;
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

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getReplaceStatus() {
        return replaceStatus;
    }

    public void setReplaceStatus(int replaceStatus) {
        this.replaceStatus = replaceStatus;
    }

    /**
     * Getter for property accountBalance.
     * @return Value of property accountBalance.
     */
    public double getAccountBalance() {
        return this.accountBalance;
    }

    /**
     * Setter for property accountBalance.
     * @param accountBalance New value of property accountBalance.
     */
    public void setAccountBalance(double accountBalance) {
        this.accountBalance = accountBalance;
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

    /**
     * Getter for property shareGroupId.
     * @return Value of property shareGroupId.
     */
    public long getShareGroupId() {
        return this.shareGroupId;
    }

    /**
     * Setter for property shareGroupId.
     * @param shareGroupId New value of property shareGroupId.
     */
    public void setShareGroupId(long shareGroupId) {
        this.shareGroupId = shareGroupId;
    }

    /**
     * Getter for property shareCategoryId.
     * @return Value of property shareCategoryId.
     */
    public long getShareCategoryId() {
        return this.shareCategoryId;
    }

    /**
     * Setter for property shareCategoryId.
     * @param shareCategoryId New value of property shareCategoryId.
     */
    public void setShareCategoryId(long shareCategoryId) {
        this.shareCategoryId = shareCategoryId;
    }

    /**
     * Getter for property status.
     * @return Value of property status.
     */
    public int getStatus() {
        return this.status;
    }

    /**
     * Setter for property status.
     * @param status New value of property status.
     */
    public void setStatus(int status) {
        this.status = status;
    }

    /**
     * Getter for property expenseCategoryId.
     * @return Value of property expenseCategoryId.
     */
    public long getExpenseCategoryId() {
        return this.expenseCategoryId;
    }

    /**
     * Setter for property expenseCategoryId.
     * @param expenseCategoryId New value of property expenseCategoryId.
     */
    public void setExpenseCategoryId(long expenseCategoryId) {
        this.expenseCategoryId = expenseCategoryId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public int getTypeKasbon() {
        return typeKasbon;
    }

    public void setTypeKasbon(int typeKasbon) {
        this.typeKasbon = typeKasbon;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public long getReferensiId() {
        return referensiId;
    }

    public void setReferensiId(long referensiId) {
        this.referensiId = referensiId;
    }

    public String getPaymentTo() {
        return paymentTo;
    }

    public void setPaymentTo(String paymentTo) {
        this.paymentTo = paymentTo;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }
}
