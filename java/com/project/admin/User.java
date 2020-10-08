package com.project.admin;

import java.util.*;
import com.project.main.entity.*;

public class User extends Entity {

    public final static int STATUS_NEW = 0;
    public final static int STATUS_LOGOUT = 1;
    public final static int STATUS_LOGIN = 2;
    
    public final static String[] statusTxt = {"New", "Logged out", "Logged In"};
    
    private String loginId = "";
    private String password = "";
    private String fullName = "";
    private String email = "";
    private String description = "";
    private java.util.Date regDate = new Date();
    private java.util.Date updateDate = new Date();
    private int userStatus = 0;
    private java.util.Date lastLoginDate = new Date();
    private String lastLoginIp = "";
    private long employeeId;
    private String employeeNum;
    private int userLevel;
    private Date lastLoginDate1;
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
    private long companyId;
    private String userKey;
    private boolean resetPassword = false;

    public User() {
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public java.util.Date getRegDate() {
        return regDate;
    }

    public void setRegDate(java.util.Date regDate) {
        this.regDate = regDate;
    }

    public java.util.Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(java.util.Date updateDate) {
        this.updateDate = updateDate;
    }

    public int getUserStatus() {
        return userStatus;
    }

    public static String getStatusTxt(int sts) {
        if ((sts < 0) || (sts > statusTxt.length)) {
            return "";
        }
        return statusTxt[sts];
    }

    public static Vector getStatusTxts() {
        Vector vct = new Vector(1, 1);
        for (int i = 0; i < statusTxt.length; i++) {
            vct.add(statusTxt[i]);
        }
        return vct;
    }

    public static Vector getStatusVals() {
        Vector vct = new Vector(1, 1);
        for (int i = 0; i < statusTxt.length; i++) {
            vct.add(Integer.toString(i));
        }
        return vct;
    }

    public void setUserStatus(int userStatus) {
        this.userStatus = userStatus;
    }

    public java.util.Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(java.util.Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public String getLastLoginIp() {
        return lastLoginIp;
    }

    public void setLastLoginIp(String lastLoginIp) {
        this.lastLoginIp = lastLoginIp;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }
    
    public String getEmployeeNum() {
        return this.employeeNum;
    }
    
    public void setEmployeeNum(String employeeNum) {
        this.employeeNum = employeeNum;
    }
    
    public int getUserLevel() {
        return this.userLevel;
    }
    
    public void setUserLevel(int userLevel) {
        this.userLevel = userLevel;
    }
    
    public Date getLastLoginDate1() {
        return this.lastLoginDate1;
    }
    
    public void setLastLoginDate1(Date lastLoginDate1) {
        this.lastLoginDate1 = lastLoginDate1;
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

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public String getUserKey() {
        return userKey;
    }

    public void setUserKey(String userKey) {
        this.userKey = userKey;
    }

    public boolean isResetPassword() {
        return resetPassword;
    }

    public void setResetPassword(boolean resetPassword) {
        this.resetPassword = resetPassword;
    }
    
}

