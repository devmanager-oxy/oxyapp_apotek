/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class SalesHistory extends Entity {

    private long cashCashierId = 0;
    private long glId = 0;
    private Date date;
    private String journalNumber = "";

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public long getCashCashierId() {
        return cashCashierId;
    }

    public void setCashCashierId(long cashCashierId) {
        this.cashCashierId = cashCashierId;
    }
}
