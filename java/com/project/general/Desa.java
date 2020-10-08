/*
 * Desa.java
 *
 * Created on April 21, 2009, 8:53 AM
 */

package com.project.general;

import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class Desa extends Entity {
    
    /**
     * Holds value of property kecamatanId.
     */
    private long kecamatanId;
    
    /**
     * Holds value of property kode.
     */
    private String kode;
    
    /**
     * Holds value of property nama.
     */
    private String nama;
    
    /** Creates a new instance of Desa */
    public Desa() {
    }
    
    /**
     * Getter for property kecamatanId.
     * @return Value of property kecamatanId.
     */
    public long getKecamatanId() {
        return this.kecamatanId;
    }
    
    /**
     * Setter for property kecamatanId.
     * @param kecamatanId New value of property kecamatanId.
     */
    public void setKecamatanId(long kecamatanId) {
        this.kecamatanId = kecamatanId;
    }
    
    /**
     * Getter for property kode.
     * @return Value of property kode.
     */
    public String getKode() {
        return this.kode;
    }
    
    /**
     * Setter for property kode.
     * @param kode New value of property kode.
     */
    public void setKode(String kode) {
        this.kode = kode;
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
    
}
