/*
 * RptPotonganGajiL.java
 *
 * Created on July 16, 2009, 10:24 AM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptPotonganGajiL {
    
    /**
     * Holds value of property nama.
     */
    private String nama;
    private String nik;
    private double simPokok;
    private double simWajib;
    private double simSukarela;
    private double pinPokok;
    private double pinBunga;
    private double mini;
    private double elektroPokok;
    private double elektroBunga;
    private double manPokok;
    private double manBunga;
    private double fasjabtel;
    private double ttp;
    private double jmlhPotongan;
    
    /**
     * Holds value of property keterangan.
     */
    private String keterangan;
    
    /** Creates a new instance of RptPotonganGajiL */
    public RptPotonganGajiL() {
    }
    
    /**
     * Getter for property nama.
     * @return Value of property nama.
     */
    public String getNama() {
        return this.nama;
    }
    
    /**
     * Setter for property nama.
     * @param nama New value of property nama.
     */
    public void setNama(String nama) {
        this.nama = nama;
    }
    
    /**
     * Getter for property nik.
     * @return Value of property nik.
     */
    public String getNik() {
        return this.nik;
    }
    
    /**
     * Setter for property nik.
     * @param nik New value of property nik.
     */
    public void setNik(String nik) {
        this.nik = nik;
    }
    
    /**
     * Getter for property simPokok.
     * @return Value of property simPokok.
     */
    public double getSimPokok() {
        return this.simPokok;
    }
    
    /**
     * Setter for property simPokok.
     * @param simPokok New value of property simPokok.
     */
    public void setSimPokok(double simPokok) {
        this.simPokok = simPokok;
    }
    
    /**
     * Getter for property simWajib.
     * @return Value of property simWajib.
     */
    public double getSimWajib() {
        return this.simWajib;
    }
    
    /**
     * Setter for property simWajib.
     * @param simWajib New value of property simWajib.
     */
    public void setSimWajib(double simWajib) {
        this.simWajib = simWajib;
    }
    
    /**
     * Getter for property simSukarela.
     * @return Value of property simSukarela.
     */
    public double getSimSukarela() {
        return this.simSukarela;
    }
    
    /**
     * Setter for property simSukarela.
     * @param simSukarela New value of property simSukarela.
     */
    public void setSimSukarela(double simSukarela) {
        this.simSukarela = simSukarela;
    }
    
    /**
     * Getter for property pinPokok.
     * @return Value of property pinPokok.
     */
    public double getPinPokok() {
        return this.pinPokok;
    }
    
    /**
     * Setter for property pinPokok.
     * @param pinPokok New value of property pinPokok.
     */
    public void setPinPokok(double pinPokok) {
        this.pinPokok = pinPokok;
    }
    
    /**
     * Getter for property pinBunga.
     * @return Value of property pinBunga.
     */
    public double getPinBunga() {
        return this.pinBunga;
    }
    
    /**
     * Setter for property pinBunga.
     * @param pinBunga New value of property pinBunga.
     */
    public void setPinBunga(double pinBunga) {
        this.pinBunga = pinBunga;
    }
    
    /**
     * Getter for property mini.
     * @return Value of property mini.
     */
    public double getMini() {
        return this.mini;
    }
    
    /**
     * Setter for property mini.
     * @param mini New value of property mini.
     */
    public void setMini(double mini) {
        this.mini = mini;
    }
    
    /**
     * Getter for property eltroPokok.
     * @return Value of property eltroPokok.
     */
    public double getElektroPokok() {
        return this.elektroPokok;
    }
    
    /**
     * Setter for property eltroPokok.
     * @param eltroPokok New value of property eltroPokok.
     */
    public void setElektroPokok(double elektroPokok) {
        this.elektroPokok = elektroPokok;
    }
    
    /**
     * Getter for property elktroBunga.
     * @return Value of property elktroBunga.
     */
    public double getElektroBunga() {
        return this.elektroBunga;
    }
    
    /**
     * Setter for property elktroBunga.
     * @param elktroBunga New value of property elktroBunga.
     */
    public void setElektroBunga(double elektroBunga) {
        this.elektroBunga = elektroBunga;
    }
    
    /**
     * Getter for property manPokok.
     * @return Value of property manPokok.
     */
    public double getManPokok() {
        return this.manPokok;
    }
    
    /**
     * Setter for property manPokok.
     * @param manPokok New value of property manPokok.
     */
    public void setManPokok(double manPokok) {
        this.manPokok = manPokok;
    }
    
    /**
     * Getter for property manBunga.
     * @return Value of property manBunga.
     */
    public double getManBunga() {
        return this.manBunga;
    }
    
    /**
     * Setter for property manBunga.
     * @param manBunga New value of property manBunga.
     */
    public void setManBunga(double manBunga) {
        this.manBunga = manBunga;
    }
    
    /**
     * Getter for property fasjabtel.
     * @return Value of property fasjabtel.
     */
    public double getFasjabtel() {
        return this.fasjabtel;
    }
    
    /**
     * Setter for property fasjabtel.
     * @param fasjabtel New value of property fasjabtel.
     */
    public void setFasjabtel(double fasjabtel) {
        this.fasjabtel = fasjabtel;
    }
    
    /**
     * Getter for property ttp.
     * @return Value of property ttp.
     */
    public double getTtp() {
        return this.ttp;
    }
    
    /**
     * Setter for property ttp.
     * @param ttp New value of property ttp.
     */
    public void setTtp(double ttp) {
        this.ttp = ttp;
    }
    
    /**
     * Getter for property jmlhPotongan.
     * @return Value of property jmlhPotongan.
     */
    public double getJmlhPotongan() {
        return this.jmlhPotongan;
    }
    
    /**
     * Setter for property jmlhPotongan.
     * @param jmlhPotongan New value of property jmlhPotongan.
     */
    public void setJmlhPotongan(double jmlhPotongan) {
        this.jmlhPotongan = jmlhPotongan;
    }
    
    /**
     * Getter for property keterangan.
     * @return Value of property keterangan.
     */
    public String getKeterangan() {
        return this.keterangan;
    }
    
    /**
     * Setter for property keterangan.
     * @param keterangan New value of property keterangan.
     */
    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }
    
}
