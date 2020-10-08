/*
 * SrcStockReport.java
 *
 * Created on September 8, 2009, 3:39 PM
 */

package com.project.ccs.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class SrcStockReport extends Entity {
    
    /**
     * Holds value of property location.
     */
    private String location;
    
    /** Creates a new instance of SrcStockReport */
    public SrcStockReport() {
    }
    
    /**
     * Getter for property location.
     * @return Value of property location.
     */
    public String getLocation() {
        return this.location;
    }
    
    /**
     * Setter for property location.
     * @param location New value of property location.
     */
    public void setLocation(String location) {
        this.location = location;
    }
    
}
