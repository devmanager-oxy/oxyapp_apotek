

package com.project.admin;


import java.util.*;
import com.project.main.entity.*;

public class Group extends Entity {
    
    private String groupName;
    
    private java.util.Date regDate;
    
    private Integer status;
    
    private String description="";
    
    public Group() {
    }
        
    public String getGroupName() {
        return groupName;
    }
    
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
    
    public java.util.Date getRegDate() {
        return regDate;
    }
    
    public void setRegDate(java.util.Date regDate) {
        this.regDate = regDate;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
        
}

