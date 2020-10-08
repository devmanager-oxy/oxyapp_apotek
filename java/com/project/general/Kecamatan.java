/*
 * Kecamatan.java
 *
 * Created on September 17, 2008, 11:54 AM
 */

package com.project.general;

import com.project.main.entity.*;

/**
 *
 * @author  ViCtoR
 */
public class Kecamatan extends Entity {
    
    /**
     * Holds value of property kabupatenId.
     */
    private long kabupatenId;
    
    /**
     * Holds value of property kode.
     */
    private String kode;
    
    /**
     * Holds value of property nama.
     */
    private String nama;
    
    /** Creates a new instance of Kecamatan */
    public Kecamatan() {
    }
    
    /**
     * Getter for property kabupaten_id.
     * @return Value of property kabupaten_id.
     */
    public long getKabupatenId() {
        return this.kabupatenId;
    }
    
    /**
     * Setter for property kabupaten_id.
     * @param kabupaten_id New value of property kabupaten_id.
     */
    public void setKabupatenId(long kabupatenId) {
        this.kabupatenId = kabupatenId;
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
