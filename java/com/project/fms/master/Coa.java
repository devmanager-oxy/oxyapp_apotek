package com.project.fms.master;

import java.util.Date;
import com.project.main.entity.Entity;

public class Coa extends Entity {

    private long accRefId = 0;
    private long departmentId = 0;
    private long sectionId = 0;
    private String accountGroup = "";
    private String code = "";
    private String name = "";
    private int level = 0;
    private String saldoNormal = "";
    private String status = "";
    private String departmentName = "";
    private String sectionName = "";
    private long userId = 0;
    private Date regDate = new Date();
    private double openingBalance = 0;
    private long locationId;
    private int departmentalCoa;
    private long coaCategoryId;
    private long coaGroupAliasId;
    private int isNeedExtra;
    private String debetPrefixCode;
    private String creditPrefixCode;
    private long companyId;
    private int accountClass;
    private int autoReverse = 0;
    private long segment1Id = 0;
    private long segment2Id = 0;
    private long segment3Id = 0;
    private long segment4Id = 0;
    private long segment5Id = 0;

    public long getAccRefId() {
        return accRefId;
    }

    public void setAccRefId(long accRefId) {
        this.accRefId = accRefId;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getSectionId() {
        return sectionId;
    }

    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    public String getAccountGroup() {
        return accountGroup;
    }

    public void setAccountGroup(String accountGroup) {
        if (accountGroup == null) {
            accountGroup = "";
        }
        this.accountGroup = accountGroup;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getSaldoNormal() {
        return saldoNormal;
    }

    public void setSaldoNormal(String saldoNormal) {
        if (saldoNormal == null) {
            saldoNormal = "";
        }
        this.saldoNormal = saldoNormal;
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

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        if (departmentName == null) {
            departmentName = "";
        }
        this.departmentName = departmentName;
    }

    public String getSectionName() {
        return sectionName;
    }

    public void setSectionName(String sectionName) {
        if (sectionName == null) {
            sectionName = "";
        }
        this.sectionName = sectionName;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getRegDate() {
        return this.regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public double getOpeningBalance() {
        return this.openingBalance;
    }

    public void setOpeningBalance(double openingBalance) {
        this.openingBalance = openingBalance;
    }

    public long getLocationId() {
        return this.locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public int getDepartmentalCoa() {
        return this.departmentalCoa;
    }

    public void setDepartmentalCoa(int departmentalCoa) {
        this.departmentalCoa = departmentalCoa;
    }

    public long getCoaCategoryId() {
        return this.coaCategoryId;
    }

    public void setCoaCategoryId(long coaCategoryId) {
        this.coaCategoryId = coaCategoryId;
    }

    public long getCoaGroupAliasId() {
        return this.coaGroupAliasId;
    }

    public void setCoaGroupAliasId(long coaGroupAliasId) {
        this.coaGroupAliasId = coaGroupAliasId;
    }

    public int getIsNeedExtra() {
        return this.isNeedExtra;
    }

    public void setIsNeedExtra(int isNeedExtra) {
        this.isNeedExtra = isNeedExtra;
    }

    public String getDebetPrefixCode() {
        return this.debetPrefixCode;
    }

    public void setDebetPrefixCode(String debetPrefixCode) {
        this.debetPrefixCode = debetPrefixCode;
    }

    public String getCreditPrefixCode() {
        return this.creditPrefixCode;
    }

    public void setCreditPrefixCode(String creditPrefixCode) {
        this.creditPrefixCode = creditPrefixCode;
    }

    public long getCompanyId() {
        return this.companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public int getAccountClass() {
        return this.accountClass;
    }

    public void setAccountClass(int accountClass) {
        this.accountClass = accountClass;
    }

    public int getAutoReverse() {
        return autoReverse;
    }

    public void setAutoReverse(int autoReverse) {
        this.autoReverse = autoReverse;
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
