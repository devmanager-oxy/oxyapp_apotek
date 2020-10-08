package com.project.fms.pdf;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class GeneralLedger {
    String reportTitle = "";
    Date startDate = new Date();
    Date endDate = new Date();
    String coaCode = "";
    String coaGroup = "";
    Date transDate = new Date();
    String journalNumber = "";
    String description = "";
    double debet = 0;
    double credit = 0;
    double saldo = 0;
    int rowType = 0;
    String departement = "";
    
    public static final int ROW_TYPE_COA = 0;
    public static final int ROW_TYPE_CONTENT = 1;
    public static final int ROW_TYPE_TOTAL = 2;

    public String getCoaCode() {
        return coaCode;
    }

    public void setCoaCode(String coaCode) {
        this.coaCode = coaCode;
    }

    public String getCoaGroup() {
        return coaGroup;
    }

    public void setCoaGroup(String coaGroup) {
        this.coaGroup = coaGroup;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) {
        this.departement = departement;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public String getReportTitle() {
        return reportTitle;
    }

    public void setReportTitle(String reportTitle) {
        this.reportTitle = reportTitle;
    }

    public int getRowType() {
        return rowType;
    }

    public void setRowType(int rowType) {
        this.rowType = rowType;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

}
