/*
 * Pekerjaan.java
 *
 * Created on April 26, 2009, 12:22 PM
 */

package com.project.general;

import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class Pekerjaan extends Entity {
    
    /**
     * Holds value of property kode.
     */
    private String kode;
    
    /**
     * Holds value of property nama.
     */
    private String nama;
    
    /** Creates a new instance of Pekerjaan */
    public Pekerjaan() {
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
