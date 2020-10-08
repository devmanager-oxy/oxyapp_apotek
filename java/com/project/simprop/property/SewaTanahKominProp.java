/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class SewaTanahKominProp extends Entity {

    private String nama = "";
    private int type;
    private Date mulai;
    private Date selesai;
    private double rate = 0;
    private long unitKontrakId;
    private String keterangan = "";
    private long sewaTanahId;
    private int dasarPerhitungan;

    public int getDasarPerhitungan() {
        return dasarPerhitungan;
    }

    public void setDasarPerhitungan(int dasarPerhitungan) {
        this.dasarPerhitungan = dasarPerhitungan;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        if (nama == null) {
            nama = "";
        }
        this.nama = nama;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Date getMulai() {
        return mulai;
    }

    public void setMulai(Date mulai) {
        this.mulai = mulai;
    }

    public Date getSelesai() {
        return selesai;
    }

    public void setSelesai(Date selesai) {
        this.selesai = selesai;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public long getUnitKontrakId() {
        return unitKontrakId;
    }

    public void setUnitKontrakId(long unitKontrakId) {
        this.unitKontrakId = unitKontrakId;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        if (keterangan == null) {
            keterangan = "";
        }
        this.keterangan = keterangan;
    }

    public long getSewaTanahId() {
        return sewaTanahId;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }
}
