/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class SewaTanahKomperProp extends Entity {

    private int kategori;
    private double persentase;
    private long sewaTanahId;

    public int getKategori() {
        return kategori;
    }

    public void setKategori(int kategori) {
        this.kategori = kategori;
    }

    public double getPersentase() {
        return persentase;
    }

    public void setPersentase(double persentase) {
        this.persentase = persentase;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }

    public long getSewaTanahId() {
        return (this.sewaTanahId);
    }
}
