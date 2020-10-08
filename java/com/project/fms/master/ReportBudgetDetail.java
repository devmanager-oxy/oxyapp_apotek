/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

import com.project.main.entity.Entity;
/**
 *
 * @author Roy
 */
public class ReportBudgetDetail extends Entity {
    
    private long reportBudgetId = 0;
    private long vendorId = 0;
    private int sequence = 0;    

    public long getReportBudgetId() {
        return reportBudgetId;
    }

    public void setReportBudgetId(long reportBudgetId) {
        this.reportBudgetId = reportBudgetId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public int getSequence() {
        return sequence;
    }

    public void setSequence(int sequence) {
        this.sequence = sequence;
    }
}
