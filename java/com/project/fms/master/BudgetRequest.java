/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class BudgetRequest extends Entity {

    private String journalNumber = "";
    private int journalCounter= 0;
    private String journalPrefix = "";
    
    private Date date;
    private Date transDate;
    private long periodeId = 0; //6
    private String memo = "";
    private long userId = 0;
    
    //approval 1
    private long approval1Id = 0;
    private Date approval1Date;
    
    //approval 2
    private long approval2Id = 0;
    private Date approval2Date; //12
    
    //approval 3
    private long approval3Id = 0;
    private Date approval3Date; //14
    
    private int status = 0;
    
    private int postedStatus = 0;
    private long postedById = 0;
    private Date postedDate;   //17 
    
    private long departmentId = 0;
    private long coaId = 0;
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
    private long uniqKeyId = 0;
    private long refId = 0;
    private int paymentType = 0;

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
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

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getApproval1Id() {
        return approval1Id;
    }

    public void setApproval1Id(long approval1Id) {
        this.approval1Id = approval1Id;
    }

    public Date getApproval1Date() {
        return approval1Date;
    }

    public void setApproval1Date(Date approval1Date) {
        this.approval1Date = approval1Date;
    }

    public long getApproval2Id() {
        return approval2Id;
    }

    public void setApproval2Id(long approval2Id) {
        this.approval2Id = approval2Id;
    }

    public Date getApproval2Date() {
        return approval2Date;
    }

    public void setApproval2Date(Date approval2Date) {
        this.approval2Date = approval2Date;
    }

    public long getApproval3Id() {
        return approval3Id;
    }

    public void setApproval3Id(long approval3Id) {
        this.approval3Id = approval3Id;
    }

    public Date getApproval3Date() {
        return approval3Date;
    }

    public void setApproval3Date(Date approval3Date) {
        this.approval3Date = approval3Date;
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

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
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

    public long getSegment6Id() {
        return segment6Id;
    }

    public void setSegment6Id(long segment6Id) {
        this.segment6Id = segment6Id;
    }

    public long getSegment7Id() {
        return segment7Id;
    }

    public void setSegment7Id(long segment7Id) {
        this.segment7Id = segment7Id;
    }

    public long getSegment8Id() {
        return segment8Id;
    }

    public void setSegment8Id(long segment8Id) {
        this.segment8Id = segment8Id;
    }

    public long getSegment9Id() {
        return segment9Id;
    }

    public void setSegment9Id(long segment9Id) {
        this.segment9Id = segment9Id;
    }

    public long getSegment10Id() {
        return segment10Id;
    }

    public void setSegment10Id(long segment10Id) {
        this.segment10Id = segment10Id;
    }

    public long getSegment11Id() {
        return segment11Id;
    }

    public void setSegment11Id(long segment11Id) {
        this.segment11Id = segment11Id;
    }

    public long getSegment12Id() {
        return segment12Id;
    }

    public void setSegment12Id(long segment12Id) {
        this.segment12Id = segment12Id;
    }

    public long getSegment13Id() {
        return segment13Id;
    }

    public void setSegment13Id(long segment13Id) {
        this.segment13Id = segment13Id;
    }

    public long getSegment14Id() {
        return segment14Id;
    }

    public void setSegment14Id(long segment14Id) {
        this.segment14Id = segment14Id;
    }

    public long getSegment15Id() {
        return segment15Id;
    }

    public void setSegment15Id(long segment15Id) {
        this.segment15Id = segment15Id;
    }

    public long getUniqKeyId() {
        return uniqKeyId;
    }

    public void setUniqKeyId(long uniqKeyId) {
        this.uniqKeyId = uniqKeyId;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

   

    public int getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(int paymentType) {
        this.paymentType = paymentType;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }
}
