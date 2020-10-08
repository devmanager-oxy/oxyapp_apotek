
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

public class BankDepositDetail extends Entity {

    private long bankDepositId;
    private long coaId;
    private long foreignCurrencyId;
    private double foreignAmount;
    private double bookedRate;
    private String memo = "";
    private double amount;
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
    //====== segment
    private long departmentId;
    
    private double foreignCreditAmount;
    private double creditAmount;

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

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
    public long getBankDepositId() {
        return bankDepositId;
    }

    public void setBankDepositId(long bankDepositId) {
        this.bankDepositId = bankDepositId;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getForeignCurrencyId() {
        return foreignCurrencyId;
    }

    public void setForeignCurrencyId(long foreignCurrencyId) {
        this.foreignCurrencyId = foreignCurrencyId;
    }

    public double getForeignAmount() {
        return foreignAmount;
    }

    public void setForeignAmount(double foreignAmount) {
        this.foreignAmount = foreignAmount;
    }

    public double getBookedRate() {
        return bookedRate;
    }

    public void setBookedRate(double bookedRate) {
        this.bookedRate = bookedRate;
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

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getForeignCreditAmount() {
        return foreignCreditAmount;
    }

    public void setForeignCreditAmount(double foreignCreditAmount) {
        this.foreignCreditAmount = foreignCreditAmount;
    }

    public double getCreditAmount() {
        return creditAmount;
    }

    public void setCreditAmount(double creditAmount) {
        this.creditAmount = creditAmount;
    }
}
