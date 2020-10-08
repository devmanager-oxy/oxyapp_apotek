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
public class BankPaymentHistory extends Entity {

    private long bankPaymentId = 0;
    private int type = 0;
    private long glId = 0;
    private Date date;
    private String journalNumber = "";

    public long getBankPaymentId() {
        return bankPaymentId;
    }

    public void setBankPaymentId(long bankPaymentId) {
        this.bankPaymentId = bankPaymentId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
