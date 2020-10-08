package com.project.fms.pdf;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class Worksheet {
    private int rowType = 0;
    private String journalNumber = "";
    private String refNumber = "";
    private Date date = new Date();
    private Date transDate = new Date();
    private String note = "";
    private String account = "";
    private String accountType = "";
    private double debet = 0;
    private double credit = 0;
    private String detailNote = "";
    
    public static int ROW_TYPE_DEFAULT = 0;
    public static int ROW_TYPE_DESCRIPTION = 1;
    public static int ROW_TYPE_SUB_TOTAL = 2;
    public static int ROW_TYPE_TOTAL = 3;

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public String getDetailNote() {
        return detailNote;
    }

    public void setDetailNote(String detailNote) {
        this.detailNote = detailNote;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRefNumber() {
        return refNumber;
    }

    public void setRefNumber(String refNumber) {
        this.refNumber = refNumber;
    }

    public int getRowType() {
        return rowType;
    }

    public void setRowType(int rowType) {
        this.rowType = rowType;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

}
