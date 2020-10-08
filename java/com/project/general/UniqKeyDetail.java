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
public class UniqKeyDetail extends Entity {
    
    private long uniqKeyId = 0;
    private long uniqDetailId = 0;

    public long getUniqKeyId() {
        return uniqKeyId;
    }

    public void setUniqKeyId(long uniqKeyId) {
        this.uniqKeyId = uniqKeyId;
    }

    public long getUniqDetailId() {
        return uniqDetailId;
    }

    public void setUniqDetailId(long uniqDetailId) {
        this.uniqDetailId = uniqDetailId;
    }

    
}
