/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/* package qdep */
import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class GlDetail2016 extends Entity {

    private long glId = 0;
    private long coaId = 0;
    private double debet = 0;
    private double credit = 0;
    private long foreignCurrencyId = 0;
    private double foreignCurrencyAmount = 0;
    private String memo = "";
    private double bookedRate = 0;
    private long divisionId = 0;
    private long directorateId = 0;
    /**
     * Holds value of property isDebet.
     */
    private int isDebet = 0;
    /**
     * Holds value of property departmentId.
     */
    private long departmentId = 0;
    /**
     * Holds value of property sectionId.
     */
    private long sectionId = 0;
    /**
     * Holds value of property subSectionId.
     */
    private long subSectionId = 0;
    /**
     * Holds value of property jobId.
     */
    private long jobId = 0;
    /**
     * Holds value of property statusTransaction.
     */
    private int statusTransaction = 0;
    /**
     * Holds value of property customerId.
     */
    private long customerId = 0;
    private long coaLevel1Id = 0;
    private long coaLevel2Id = 0;
    private long coaLevel3Id = 0;
    private long coaLevel4Id = 0;
    private long coaLevel5Id = 0;
    private long coaLevel6Id = 0;
    private long coaLevel7Id = 0;
    private long depLevel1Id = 0;
    private long depLevel2Id = 0;
    private long depLevel3Id = 0;
    private long depLevel4Id = 0;
    private long depLevel5Id = 0;
    
    private long segment1Id = 0;
    private long segment2Id = 0;
    private long segment3Id = 0;
    private long segment4Id = 0;
    private long segment5Id = 0;
    private long segment6Id = 0;
    private long segment7Id = 0;
    private long segment8Id = 0;
    private long segment9Id = 0;
    private long segment10Id = 0;
    private long segment11Id = 0;
    private long segment12Id = 0;
    private long segment13Id = 0;
    private long segment14Id = 0;
    private long segment15Id = 0;
    private long moduleId = 0;    
    private long depLevel0Id = 0;

    public long getDepLevel0Id() {
        return depLevel0Id;
    }

    public void setDepLevel0Id(long depLevel0Id) {
        this.depLevel0Id = depLevel0Id;
    }

    //====== segment
    public long getModuleId() {
        return moduleId;
    }

    public void setModuleId(long moduleId) {
        this.moduleId = moduleId;
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
    public long getDepLevel5Id() {
        return depLevel5Id;
    }

    public void setDepLevel5Id(long depLevel5Id) {
        this.depLevel5Id = depLevel5Id;
    }

    public long getDepLevel4Id() {
        return depLevel4Id;
    }

    public void setDepLevel4Id(long depLevel4Id) {
        this.depLevel4Id = depLevel4Id;
    }

    public long getDepLevel3Id() {
        return depLevel3Id;
    }

    public void setDepLevel3Id(long depLevel3Id) {
        this.depLevel3Id = depLevel3Id;
    }

    public long getDepLevel2Id() {
        return depLevel2Id;
    }

    public void setDepLevel2Id(long depLevel2Id) {
        this.depLevel2Id = depLevel2Id;
    }

    public long getDepLevel1Id() {
        return depLevel1Id;
    }

    public void setDepLevel1Id(long depLevel1Id) {
        this.depLevel1Id = depLevel1Id;
    }

    public long getDirectorateId() {
        return directorateId;
    }

    public void setDirectorateId(long directorateId) {
        this.directorateId = directorateId;
    }

    public long getDivisionId() {
        return divisionId;
    }

    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }

    public long getCoaLevel7Id() {
        return coaLevel7Id;
    }

    public void setCoaLevel7Id(long coaLevel7Id) {
        this.coaLevel7Id = coaLevel7Id;
    }

    public long getCoaLevel6Id() {
        return coaLevel6Id;
    }

    public void setCoaLevel6Id(long coaLevel6Id) {
        this.coaLevel6Id = coaLevel6Id;
    }

    public long getCoaLevel5Id() {
        return coaLevel5Id;
    }

    public void setCoaLevel5Id(long coaLevel5Id) {
        this.coaLevel5Id = coaLevel5Id;
    }

    public long getCoaLevel4Id() {
        return coaLevel4Id;
    }

    public void setCoaLevel4Id(long coaLevel4Id) {
        this.coaLevel4Id = coaLevel4Id;
    }

    public long getCoaLevel3Id() {
        return coaLevel3Id;
    }

    public void setCoaLevel3Id(long coaLevel3Id) {
        this.coaLevel3Id = coaLevel3Id;
    }

    public long getCoaLevel2Id() {
        return coaLevel2Id;
    }

    public void setCoaLevel2Id(long coaLevel2Id) {
        this.coaLevel2Id = coaLevel2Id;
    }

    public long getCoaLevel1Id() {
        return coaLevel1Id;
    }

    public void setCoaLevel1Id(long coaLevel1Id) {
        this.coaLevel1Id = coaLevel1Id;
    }

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public long getForeignCurrencyId() {
        return foreignCurrencyId;
    }

    public void setForeignCurrencyId(long foreignCurrencyId) {
        this.foreignCurrencyId = foreignCurrencyId;
    }

    public double getForeignCurrencyAmount() {
        return foreignCurrencyAmount;
    }

    public void setForeignCurrencyAmount(double foreignCurrencyAmount) {
        this.foreignCurrencyAmount = foreignCurrencyAmount;
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

    public double getBookedRate() {
        return bookedRate;
    }

    public void setBookedRate(double bookedRate) {
        this.bookedRate = bookedRate;
    }

    /**
     * Getter for property isDebet.
     * @return Value of property isDebet.
     */
    public int getIsDebet() {
        return this.isDebet;
    }

    /**
     * Setter for property isDebet.
     * @param isDebet New value of property isDebet.
     */
    public void setIsDebet(int isDebet) {
        this.isDebet = isDebet;
    }

    /**
     * Getter for property departmentId.
     * @return Value of property departmentId.
     */
    public long getDepartmentId() {
        return this.departmentId;
    }

    /**
     * Setter for property departmentId.
     * @param departmentId New value of property departmentId.
     */
    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    /**
     * Getter for property sectionId.
     * @return Value of property sectionId.
     */
    public long getSectionId() {
        return this.sectionId;
    }

    /**
     * Setter for property sectionId.
     * @param sectionId New value of property sectionId.
     */
    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    /**
     * Getter for property subSectionId.
     * @return Value of property subSectionId.
     */
    public long getSubSectionId() {
        return this.subSectionId;
    }

    /**
     * Setter for property subSectionId.
     * @param subSectionId New value of property subSectionId.
     */
    public void setSubSectionId(long subSectionId) {
        this.subSectionId = subSectionId;
    }

    /**
     * Getter for property jobId.
     * @return Value of property jobId.
     */
    public long getJobId() {
        return this.jobId;
    }

    /**
     * Setter for property jobId.
     * @param jobId New value of property jobId.
     */
    public void setJobId(long jobId) {
        this.jobId = jobId;
    }

    /**
     * Getter for property statusTitipan.
     * @return Value of property statusTitipan.
     */
    public int getStatusTransaction() {
        return this.statusTransaction;
    }

    /**
     * Setter for property statusTitipan.
     * @param statusTitipan New value of property statusTitipan.
     */
    public void setStatusTransaction(int statusTransaction) {
        this.statusTransaction = statusTransaction;
    }

    /**
     * Getter for property customerId.
     * @return Value of property customerId.
     */
    public long getCustomerId() {
        return this.customerId;
    }

    /**
     * Setter for property customerId.
     * @param customerId New value of property customerId.
     */
    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }
}
