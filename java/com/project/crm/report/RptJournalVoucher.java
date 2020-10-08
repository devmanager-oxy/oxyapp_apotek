/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author Tu Roy
 */
public class RptJournalVoucher {

    private Date tgl            = new Date();
    private String kodeRek      = "";
    private String penjelasan   = "";
    private double debet;
    private double kredit;

    public Date getTgl() {
        return tgl;
    }

    public void setTgl(Date tgl) {
        this.tgl = tgl;
    }

    public String getKodeRek() {
        return kodeRek;
    }

    public void setKodeRek(String kodeRek) {
        this.kodeRek = kodeRek;
    }

    public String getPenjelasan() {
        return penjelasan;
    }

    public void setPenjelasan(String penjelasan) {
        this.penjelasan = penjelasan;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public double getKredit() {
        return kredit;
    }

    public void setKredit(double kredit) {
        this.kredit = kredit;
    }
    
}
