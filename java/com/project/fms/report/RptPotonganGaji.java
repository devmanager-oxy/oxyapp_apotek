/*
 * RptPotonganGaji.java
 *
 * Created on July 16, 2009, 10:21 AM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptPotonganGaji extends Entity {
    
    /**
     * Holds value of property dinas.
     */
    private String dinas;
    private String periode;
    private Date tanggal;
    private String nomor;
    private double totalSimPokok;
    private double totalSimWajib;
    private double totalSimSukarela;
    private double totalPinPokok;
    private double totalPinBunga;
    private double totalMini;
    private double totalElektroPokok;
    private double totalElektroBunga;
    private double totalManPokok;
    private double totalManBunga;
    private double totalFasjabtel;
    
    /**
     * Holds value of property totalTtp.
     */
    private double totalTtp;
    
    /**
     * Holds value of property totalJmlhPotongan.
     */
    private double totalJmlhPotongan;
    
    /** Creates a new instance of RptPotonganGaji */
    public RptPotonganGaji() {
    }
    
    /**
     * Getter for property dinas.
     * @return Value of property dinas.
     */
    public String getDinas() {
        return this.dinas;
    }
    
    /**
     * Setter for property dinas.
     * @param dinas New value of property dinas.
     */
    public void setDinas(String dinas) {
        this.dinas = dinas;
    }
    
    /**
     * Getter for property periode.
     * @return Value of property periode.
     */
    public String getPeriode() {
        return this.periode;
    }
    
    /**
     * Setter for property periode.
     * @param periode New value of property periode.
     */
    public void setPeriode(String periode) {
        this.periode = periode;
    }
    
    /**
     * Getter for property tanggal.
     * @return Value of property tanggal.
     */
    public Date getTanggal() {
        return this.tanggal;
    }
    
    /**
     * Setter for property tanggal.
     * @param tanggal New value of property tanggal.
     */
    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }
    
    /**
     * Getter for property nomor.
     * @return Value of property nomor.
     */
    public String getNomor() {
        return this.nomor;
    }
    
    /**
     * Setter for property nomor.
     * @param nomor New value of property nomor.
     */
    public void setNomor(String nomor) {
        this.nomor = nomor;
    }
    
    /**
     * Getter for property totalSimPokok.
     * @return Value of property totalSimPokok.
     */
    public double getTotalSimPokok() {
        return this.totalSimPokok;
    }
    
    /**
     * Setter for property totalSimPokok.
     * @param totalSimPokok New value of property totalSimPokok.
     */
    public void setTotalSimPokok(double totalSimPokok) {
        this.totalSimPokok = totalSimPokok;
    }
    
    /**
     * Getter for property totalSimWajib.
     * @return Value of property totalSimWajib.
     */
    public double getTotalSimWajib() {
        return this.totalSimWajib;
    }
    
    /**
     * Setter for property totalSimWajib.
     * @param totalSimWajib New value of property totalSimWajib.
     */
    public void setTotalSimWajib(double totalSimWajib) {
        this.totalSimWajib = totalSimWajib;
    }
    
    /**
     * Getter for property totalSimSukarela.
     * @return Value of property totalSimSukarela.
     */
    public double getTotalSimSukarela() {
        return this.totalSimSukarela;
    }
    
    /**
     * Setter for property totalSimSukarela.
     * @param totalSimSukarela New value of property totalSimSukarela.
     */
    public void setTotalSimSukarela(double totalSimSukarela) {
        this.totalSimSukarela = totalSimSukarela;
    }
    
    /**
     * Getter for property totalPinPokok.
     * @return Value of property totalPinPokok.
     */
    public double getTotalPinPokok() {
        return this.totalPinPokok;
    }
    
    /**
     * Setter for property totalPinPokok.
     * @param totalPinPokok New value of property totalPinPokok.
     */
    public void setTotalPinPokok(double totalPinPokok) {
        this.totalPinPokok = totalPinPokok;
    }
    
    /**
     * Getter for property totalPinBunga.
     * @return Value of property totalPinBunga.
     */
    public double getTotalPinBunga() {
        return this.totalPinBunga;
    }
    
    /**
     * Setter for property totalPinBunga.
     * @param totalPinBunga New value of property totalPinBunga.
     */
    public void setTotalPinBunga(double totalPinBunga) {
        this.totalPinBunga = totalPinBunga;
    }
    
    /**
     * Getter for property totalMini.
     * @return Value of property totalMini.
     */
    public double getTotalMini() {
        return this.totalMini;
    }
    
    /**
     * Setter for property totalMini.
     * @param totalMini New value of property totalMini.
     */
    public void setTotalMini(double totalMini) {
        this.totalMini = totalMini;
    }
    
    /**
     * Getter for property totalElektroPokok.
     * @return Value of property totalElektroPokok.
     */
    public double getTotalElektroPokok() {
        return this.totalElektroPokok;
    }
    
    /**
     * Setter for property totalElektroPokok.
     * @param totalElektroPokok New value of property totalElektroPokok.
     */
    public void setTotalElektroPokok(double totalElektroPokok) {
        this.totalElektroPokok = totalElektroPokok;
    }
    
    /**
     * Getter for property totalElektroBunga.
     * @return Value of property totalElektroBunga.
     */
    public double getTotalElektroBunga() {
        return this.totalElektroBunga;
    }
    
    /**
     * Setter for property totalElektroBunga.
     * @param totalElektroBunga New value of property totalElektroBunga.
     */
    public void setTotalElektroBunga(double totalElektroBunga) {
        this.totalElektroBunga = totalElektroBunga;
    }
    
    /**
     * Getter for property totalManPokok.
     * @return Value of property totalManPokok.
     */
    public double getTotalManPokok() {
        return this.totalManPokok;
    }
    
    /**
     * Setter for property totalManPokok.
     * @param totalManPokok New value of property totalManPokok.
     */
    public void setTotalManPokok(double totalManPokok) {
        this.totalManPokok = totalManPokok;
    }
    
    /**
     * Getter for property totalManBunga.
     * @return Value of property totalManBunga.
     */
    public double getTotalManBunga() {
        return this.totalManBunga;
    }
    
    /**
     * Setter for property totalManBunga.
     * @param totalManBunga New value of property totalManBunga.
     */
    public void setTotalManBunga(double totalManBunga) {
        this.totalManBunga = totalManBunga;
    }
    
    /**
     * Getter for property totalFasjabtel.
     * @return Value of property totalFasjabtel.
     */
    public double getTotalFasjabtel() {
        return this.totalFasjabtel;
    }
    
    /**
     * Setter for property totalFasjabtel.
     * @param totalFasjabtel New value of property totalFasjabtel.
     */
    public void setTotalFasjabtel(double totalFasjabtel) {
        this.totalFasjabtel = totalFasjabtel;
    }
    
    /**
     * Getter for property totalTtp.
     * @return Value of property totalTtp.
     */
    public double getTotalTtp() {
        return this.totalTtp;
    }
    
    /**
     * Setter for property totalTtp.
     * @param totalTtp New value of property totalTtp.
     */
    public void setTotalTtp(double totalTtp) {
        this.totalTtp = totalTtp;
    }
    
    /**
     * Getter for property totalJmlhPotongan.
     * @return Value of property totalJmlhPotongan.
     */
    public double getTotalJmlhPotongan() {
        return this.totalJmlhPotongan;
    }
    
    /**
     * Setter for property totalJmlhPotongan.
     * @param totalJmlhPotongan New value of property totalJmlhPotongan.
     */
    public void setTotalJmlhPotongan(double totalJmlhPotongan) {
        this.totalJmlhPotongan = totalJmlhPotongan;
    }
    
}
