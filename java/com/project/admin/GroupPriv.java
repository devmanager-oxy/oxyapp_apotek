

package com.project.admin;



import java.util.*;
import com.project.main.entity.*;

public class GroupPriv extends Entity { 
    
    public GroupPriv() {
    }
        
    public long getGroupID() {
        return this.getOID(0) ;
    }

    public void setGroupID(long groupID) {
        this.setOID(0, groupID);
    }
    
    public long getPrivID() {
        return this.getOID(1) ;
    }

    public void setPrivID(long privID) {
        this.setOID(1, privID);
    }            
}

