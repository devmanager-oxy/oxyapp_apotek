package com.project.fms.master;
import com.project.main.entity.*;

public class CoaBudget extends Entity {

    private long coaId;
    private long periodeId;
    private double amount;
    /**
     * Holds value of property bgtYear.
     */
    private int bgtYear;
    /**
     * Holds value of property bgtMonth.
     */
    private int bgtMonth;
    
    private String coaCode;
    
    private long direktoratId = 0;
    private long departmentId = 0;
    private long divisionId = 0;
    private long sectionId = 0;
    private long subSectionId = 0;
    private long jobId = 0;
    
    private long coaLevel1Id = 0;
    private long coaLevel2Id = 0;
    private long coaLevel3Id = 0;
    private long coaLevel4Id = 0;
    private long coaLevel5Id = 0;
    private long coaLevel6Id = 0;
    private long coaLevel7Id = 0;
    
    private long segment1Id = 0;
    private long segment2Id = 0;
    private long segment3Id = 0;
    private long segment4Id = 0;
    private long segment5Id = 0;

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    /**
     * Getter for property bgtYear.
     * @return Value of property bgtYear.
     */
    public int getBgtYear() {
        return this.bgtYear;
    }

    /**
     * Setter for property bgtYear.
     * @param bgtYear New value of property bgtYear.
     */
    public void setBgtYear(int bgtYear) {
        this.bgtYear = bgtYear;
    }

    /**
     * Getter for property bgtMonth.
     * @return Value of property bgtMonth.
     */
    public int getBgtMonth() {
        return this.bgtMonth;
    }

    /**
     * Setter for property bgtMonth.
     * @param bgtMonth New value of property bgtMonth.
     */
    public void setBgtMonth(int bgtMonth) {
        this.bgtMonth = bgtMonth;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getDivisionId() {
        return divisionId;
    }

    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }

    public long getDirektoratId() {
        return direktoratId;
    }

    public void setDirektoratId(long direktoratId) {
        this.direktoratId = direktoratId;
    }

    public String getCoaCode() {
        return coaCode;
    }

    public void setCoaCode(String coaCode) {
        this.coaCode = coaCode;
    }

    public long getSectionId() {
        return sectionId;
    }

    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    public long getJobId() {
        return jobId;
    }

    public void setJobId(long jobId) {
        this.jobId = jobId;
    }

    public long getCoaLevel1Id() {
        return coaLevel1Id;
    }

    public void setCoaLevel1Id(long coaLevel1Id) {
        this.coaLevel1Id = coaLevel1Id;
    }

    public long getCoaLevel2Id() {
        return coaLevel2Id;
    }

    public void setCoaLevel2Id(long coaLevel2Id) {
        this.coaLevel2Id = coaLevel2Id;
    }

    public long getCoaLevel3Id() {
        return coaLevel3Id;
    }

    public void setCoaLevel3Id(long coaLevel3Id) {
        this.coaLevel3Id = coaLevel3Id;
    }

    public long getCoaLevel4Id() {
        return coaLevel4Id;
    }

    public void setCoaLevel4Id(long coaLevel4Id) {
        this.coaLevel4Id = coaLevel4Id;
    }

    public long getCoaLevel5Id() {
        return coaLevel5Id;
    }

    public void setCoaLevel5Id(long coaLevel5Id) {
        this.coaLevel5Id = coaLevel5Id;
    }

    public long getCoaLevel6Id() {
        return coaLevel6Id;
    }

    public void setCoaLevel6Id(long coaLevel6Id) {
        this.coaLevel6Id = coaLevel6Id;
    }

    public long getCoaLevel7Id() {
        return coaLevel7Id;
    }

    public void setCoaLevel7Id(long coaLevel7Id) {
        this.coaLevel7Id = coaLevel7Id;
    }

    public long getSubSectionId() {
        return subSectionId;
    }

    public void setSubSectionId(long subSectionId) {
        this.subSectionId = subSectionId;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }

    public long getSegment2Id() {
        return segment2Id;
    }

    public void setSegment2Id(long segment2Id) {
        this.segment2Id = segment2Id;
    }

    public long getSegment3Id() {
        return segment3Id;
    }

    public void setSegment3Id(long segment3Id) {
        this.segment3Id = segment3Id;
    }

    public long getSegment4Id() {
        return segment4Id;
    }

    public void setSegment4Id(long segment4Id) {
        this.segment4Id = segment4Id;
    }

    public long getSegment5Id() {
        return segment5Id;
    }

    public void setSegment5Id(long segment5Id) {
        this.segment5Id = segment5Id;
    }
}
