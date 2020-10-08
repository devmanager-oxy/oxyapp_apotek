/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

/**
 *
 * @author gwawan
 */
public class AR {
    private String title = "";
    private String period = "";
    private String lot = "";
    private String investor = "";
    private double komin = 0;
    private double asses = 0;
    private String kominCurr = "";
    private String assesCurr = "";
    private String kominNote = "";
    private String assesNote = "";
    private String kominMasa = "";
    private String assesMasa = "";
    private String note = "";

    public double getAsses() {
        return asses;
    }

    public void setAsses(double asses) {
        this.asses = asses;
    }

    public String getAssesCurr() {
        return assesCurr;
    }

    public void setAssesCurr(String assesCurr) {
        this.assesCurr = assesCurr;
    }

    public String getAssesMasa() {
        return assesMasa;
    }

    public void setAssesMasa(String assesMasa) {
        this.assesMasa = assesMasa;
    }

    public String getAssesNote() {
        return assesNote;
    }

    public void setAssesNote(String assesNote) {
        this.assesNote = assesNote;
    }

    public String getInvestor() {
        return investor;
    }

    public void setInvestor(String investor) {
        this.investor = investor;
    }

    public double getKomin() {
        return komin;
    }

    public void setKomin(double komin) {
        this.komin = komin;
    }

    public String getKominCurr() {
        return kominCurr;
    }

    public void setKominCurr(String kominCurr) {
        this.kominCurr = kominCurr;
    }

    public String getKominMasa() {
        return kominMasa;
    }

    public void setKominMasa(String kominMasa) {
        this.kominMasa = kominMasa;
    }

    public String getKominNote() {
        return kominNote;
    }

    public void setKominNote(String kominNote) {
        this.kominNote = kominNote;
    }

    public String getLot() {
        return lot;
    }

    public void setLot(String lot) {
        this.lot = lot;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}
