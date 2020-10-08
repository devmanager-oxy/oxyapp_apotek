/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class UniqKey extends Entity {
    private long uniqId = 0;
    private int type = 0;
    private long refId = 0;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

    public long getUniqId() {
        return uniqId;
    }

    public void setUniqId(long uniqId) {
        this.uniqId = uniqId;
    }
    
    

}
