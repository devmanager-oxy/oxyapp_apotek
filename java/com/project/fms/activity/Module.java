package com.project.fms.activity;

import java.util.Date;
import com.project.main.entity.*;

public class Module extends Entity {

    private long parentId = 0;
    private String code = "";
    private String level = "";
    private String description = "";
    private String outputDeliver = "";
    private String performIndicator = "";
    private String assumRisk = "";
    private String status = "";
    private String type = "";
    /**
     * Holds value of property costImplication.
     */
    private String costImplication = "";
    /**
     * Holds value of property parentIdM.
     */
    private long parentIdM;
    /**
     * Holds value of property parentIdS.
     */
    private long parentIdS;
    /**
     * Holds value of property parentIdSH.
     */
    private long parentIdSH;
    /**
     * Holds value of property parentIdA.
     */
    private long parentIdA;
    /**
     * Holds value of property statusPost.
     */
    private String statusPost = "";
    /**
     * Holds value of property initial.
     */
    private String initial = "";
    /**
     * Holds value of property positionLevel.
     */
    private String positionLevel = "";
    /**
     * Holds value of property expiredDate.
     */
    private Date expiredDate = new Date();
    /**
     * Holds value of property activityPeriodId.
     */
    private long activityPeriodId;
    /**
     * Holds value of property parentIdSA.
     */
    private long parentIdSA;
    /**
     * Holds value of property check.
     */
    private int check;
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
    private String actDay = "";
    private String actTime = "";
    private String actDate = "";
    private String note = "";
    private double totalBudget;
    private double totalBudgetUsed;
    private int moduleLevel = 1;
    private int docStatus = 0;
    
    private long createId = 0;
    private Date createDate = new Date();
    
    private long approval1Id = 0;
    private Date approval1Date = new Date();

    public double getTotalBudgetUsed() {
        return totalBudgetUsed;
    }

    public void setTotalBudgetUsed(double totalBudgetUsed) {
        this.totalBudgetUsed = totalBudgetUsed;
    }

    public double getTotalBudget() {
        return totalBudget;
    }

    public void setTotalBudget(double totalBudget) {
        this.totalBudget = totalBudget;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getActDate() {
        return actDate;
    }

    public void setActDate(String actDate) {
        this.actDate = actDate;
    }

    public String getActTime() {
        return actTime;
    }

    public void setActTime(String actTime) {
        this.actTime = actTime;
    }

    public String getActDay() {
        return actDay;
    }

    public void setActDay(String actDay) {
        this.actDay = actDay;
    }

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
    public long getParentId() {
        return parentId;
    }

    public void setParentId(long parentId) {
        this.parentId = parentId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        if (code == null) {
            code = "";
        }
        this.code = code;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        if (level == null) {
            level = "";
        }
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null) {
            description = "";
        }
        this.description = description;
    }

    public String getOutputDeliver() {
        return outputDeliver;
    }

    public void setOutputDeliver(String outputDeliver) {
        if (outputDeliver == null) {
            outputDeliver = "";
        }
        this.outputDeliver = outputDeliver;
    }

    public String getPerformIndicator() {
        return performIndicator;
    }

    public void setPerformIndicator(String performIndicator) {
        if (performIndicator == null) {
            performIndicator = "";
        }
        this.performIndicator = performIndicator;
    }

    public String getAssumRisk() {
        return assumRisk;
    }

    public void setAssumRisk(String assumRisk) {
        if (assumRisk == null) {
            assumRisk = "";
        }
        this.assumRisk = assumRisk;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status == null) {
            status = "";
        }
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        if (type == null) {
            type = "";
        }
        this.type = type;
    }

    /**
     * Getter for property costImplication.
     * @return Value of property costImplication.
     */
    public String getCostImplication() {
        return this.costImplication;
    }

    /**
     * Setter for property costImplication.
     * @param costImplication New value of property costImplication.
     */
    public void setCostImplication(String costImplication) {
        this.costImplication = costImplication;
    }

    /**
     * Getter for property parentIdM.
     * @return Value of property parentIdM.
     */
    public long getParentIdM() {
        return this.parentIdM;
    }

    /**
     * Setter for property parentIdM.
     * @param parentIdM New value of property parentIdM.
     */
    public void setParentIdM(long parentIdM) {
        this.parentIdM = parentIdM;
    }

    /**
     * Getter for property parentIdS.
     * @return Value of property parentIdS.
     */
    public long getParentIdS() {
        return this.parentIdS;
    }

    /**
     * Setter for property parentIdS.
     * @param parentIdS New value of property parentIdS.
     */
    public void setParentIdS(long parentIdS) {
        this.parentIdS = parentIdS;
    }

    /**
     * Getter for property parentIdSH.
     * @return Value of property parentIdSH.
     */
    public long getParentIdSH() {
        return this.parentIdSH;
    }

    /**
     * Setter for property parentIdSH.
     * @param parentIdSH New value of property parentIdSH.
     */
    public void setParentIdSH(long parentIdSH) {
        this.parentIdSH = parentIdSH;
    }

    /**
     * Getter for property parentIdA.
     * @return Value of property parentIdA.
     */
    public long getParentIdA() {
        return this.parentIdA;
    }

    /**
     * Setter for property parentIdA.
     * @param parentIdA New value of property parentIdA.
     */
    public void setParentIdA(long parentIdA) {
        this.parentIdA = parentIdA;
    }

    /**
     * Getter for property statusPost.
     * @return Value of property statusPost.
     */
    public String getStatusPost() {
        return this.statusPost;
    }

    /**
     * Setter for property statusPost.
     * @param statusPost New value of property statusPost.
     */
    public void setStatusPost(String statusPost) {
        this.statusPost = statusPost;
    }

    /**
     * Getter for property initial.
     * @return Value of property initial.
     */
    public String getInitial() {
        return this.initial;
    }

    /**
     * Setter for property initial.
     * @param initial New value of property initial.
     */
    public void setInitial(String initial) {
        this.initial = initial;
    }

    /**
     * Getter for property positionLevel.
     * @return Value of property positionLevel.
     */
    public String getPositionLevel() {
        return this.positionLevel;
    }

    /**
     * Setter for property positionLevel.
     * @param positionLevel New value of property positionLevel.
     */
    public void setPositionLevel(String positionLevel) {
        this.positionLevel = positionLevel;
    }

    /**
     * Getter for property expiredDate.
     * @return Value of property expiredDate.
     */
    public Date getExpiredDate() {
        return this.expiredDate;
    }

    /**
     * Setter for property expiredDate.
     * @param expiredDate New value of property expiredDate.
     */
    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }

    /**
     * Getter for property activityPeriodId.
     * @return Value of property activityPeriodId.
     */
    public long getActivityPeriodId() {
        return this.activityPeriodId;
    }

    /**
     * Setter for property activityPeriodId.
     * @param activityPeriodId New value of property activityPeriodId.
     */
    public void setActivityPeriodId(long activityPeriodId) {
        this.activityPeriodId = activityPeriodId;
    }

    /**
     * Getter for property parentIdSA.
     * @return Value of property parentIdSA.
     */
    public long getParentIdSA() {
        return this.parentIdSA;
    }

    /**
     * Setter for property parentIdSA.
     * @param parentIdSA New value of property parentIdSA.
     */
    public void setParentIdSA(long parentIdSA) {
        this.parentIdSA = parentIdSA;
    }

    /**
     * Getter for property check.
     * @return Value of property check.
     */
    public int getCheck() {
        return this.check;
    }

    /**
     * Setter for property check.
     * @param check New value of property check.
     */
    public void setCheck(int check) {
        this.check = check;
    }

    public int getModuleLevel() {
        return moduleLevel;
    }

    public void setModuleLevel(int moduleLevel) {
        this.moduleLevel = moduleLevel;
    }

    public int getDocStatus() {
        return docStatus;
    }

    public void setDocStatus(int docStatus) {
        this.docStatus = docStatus;
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

    public long getCreateId() {
        return createId;
    }

    public void setCreateId(long createId) {
        this.createId = createId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    
} 
