

package com.project.admin;


import java.util.*;
import com.project.main.entity.*;

public class UserGroup extends Entity {
    
    public UserGroup() {
    }
        
    public long getGroupID() {
        return this.getOID(1) ;
    }

    public void setGroupID(long groupID) {
        this.setOID(1, groupID);
    }
    
    public long getUserID() {
        return this.getOID(0) ;
    }

    public void setUserID(long userID) {
        this.setOID(0, userID);
    }            
}

