/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class SetoranKasirDetail extends Entity {
    
    private long setoranKasirId = 0;
    private Date tanggal;
    private double cash = 0;
    private double card = 0;
    private double cashBack = 0;
    private double setoranToko = 0;
    private double selisih = 0;
    private long coaId = 0;
    private double system = 0;

    public long getSetoranKasirId() {
        return setoranKasirId;
    }

    public void setSetoranKasirId(long setoranKasirId) {
        this.setoranKasirId = setoranKasirId;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public double getCash() {
        return cash;
    }

    public void setCash(double cash) {
        this.cash = cash;
    }

    public double getCard() {
        return card;
    }

    public void setCard(double card) {
        this.card = card;
    }

    public double getCashBack() {
        return cashBack;
    }

    public void setCashBack(double cashBack) {
        this.cashBack = cashBack;
    }

    public double getSetoranToko() {
        return setoranToko;
    }

    public void setSetoranToko(double setoranToko) {
        this.setoranToko = setoranToko;
    }

    public double getSelisih() {
        return selisih;
    }

    public void setSelisih(double selisih) {
        this.selisih = selisih;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public double getSystem() {
        return system;
    }

    public void setSystem(double system) {
        this.system = system;
    }
}
