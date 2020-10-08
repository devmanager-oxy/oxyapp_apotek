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
public class SewaTanahRincianPiutangProp extends Entity {

    private long saranaId;
    private long investorId;
    private long sewaTanahId;
    private double luasLahan;
    private Date mulaiSewa;
    private long lotId;
    private long kominCurrencyId;
    private int periodeTahun;
    private double nilaiKominTh;
    private long masaKominId;
    private int masaKominJmlBulan;
    private long masaAssesId;
    private int masaAssesJmlBulan;
    private double nilaiAssesTh;
    private String perhitunganAssesNote = "";
    private String perhitunganKominNote = "";
    private long assesCurrencyId;
    private String keterangan = "";
    private double perhitunganAsses1;
    private double perhitunganAsses2;
    private double perhitunganKomin1;
    private double perhitunganKomin2;

    public long getSaranaId() {
        return saranaId;
    }

    public void setSaranaId(long saranaId) {
        this.saranaId = saranaId;
    }

    public long getInvestorId() {
        return investorId;
    }

    public void setInvestorId(long investorId) {
        this.investorId = investorId;
    }

    public long getSewaTanahId() {
        return sewaTanahId;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }

    public double getLuasLahan() {
        return luasLahan;
    }

    public void setLuasLahan(double luasLahan) {
        this.luasLahan = luasLahan;
    }

    public Date getMulaiSewa() {
        return mulaiSewa;
    }

    public void setMulaiSewa(Date mulaiSewa) {
        this.mulaiSewa = mulaiSewa;
    }

    public long getLotId() {
        return lotId;
    }

    public void setLotId(long lotId) {
        this.lotId = lotId;
    }

    public long getKominCurrencyId() {
        return kominCurrencyId;
    }

    public void setKominCurrencyId(long kominCurrencyId) {
        this.kominCurrencyId = kominCurrencyId;
    }

    public int getPeriodeTahun() {
        return periodeTahun;
    }

    public void setPeriodeTahun(int periodeTahun) {
        this.periodeTahun = periodeTahun;
    }

    public double getNilaiKominTh() {
        return nilaiKominTh;
    }

    public void setNilaiKominTh(double nilaiKominTh) {
        this.nilaiKominTh = nilaiKominTh;
    }

    public long getMasaKominId() {
        return masaKominId;
    }

    public void setMasaKominId(long masaKominId) {
        this.masaKominId = masaKominId;
    }

    public int getMasaKominJmlBulan() {
        return masaKominJmlBulan;
    }

    public void setMasaKominJmlBulan(int masaKominJmlBulan) {
        this.masaKominJmlBulan = masaKominJmlBulan;
    }

    public long getMasaAssesId() {
        return masaAssesId;
    }

    public void setMasaAssesId(long masaAssesId) {
        this.masaAssesId = masaAssesId;
    }

    public int getMasaAssesJmlBulan() {
        return masaAssesJmlBulan;
    }

    public void setMasaAssesJmlBulan(int masaAssesJmlBulan) {
        this.masaAssesJmlBulan = masaAssesJmlBulan;
    }

    public double getNilaiAssesTh() {
        return nilaiAssesTh;
    }

    public void setNilaiAssesTh(double nilaiAssesTh) {
        this.nilaiAssesTh = nilaiAssesTh;
    }

    public String getPerhitunganAssesNote() {
        return perhitunganAssesNote;
    }

    public void setPerhitunganAssesNote(String perhitunganAssesNote) {
        if (perhitunganAssesNote == null) {
            perhitunganAssesNote = "";
        }
        this.perhitunganAssesNote = perhitunganAssesNote;
    }

    public String getPerhitunganKominNote() {
        return perhitunganKominNote;
    }

    public void setPerhitunganKominNote(String perhitunganKominNote) {
        if (perhitunganKominNote == null) {
            perhitunganKominNote = "";
        }
        this.perhitunganKominNote = perhitunganKominNote;
    }

    public long getAssesCurrencyId() {
        return assesCurrencyId;
    }

    public void setAssesCurrencyId(long assesCurrencyId) {
        this.assesCurrencyId = assesCurrencyId;
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

    public double getPerhitunganAsses1() {
        return perhitunganAsses1;
    }

    public void setPerhitunganAsses1(double perhitunganAsses1) {
        this.perhitunganAsses1 = perhitunganAsses1;
    }

    public double getPerhitunganAsses2() {
        return perhitunganAsses2;
    }

    public void setPerhitunganAsses2(double perhitunganAsses2) {
        this.perhitunganAsses2 = perhitunganAsses2;
    }

    public double getPerhitunganKomin1() {
        return perhitunganKomin1;
    }

    public void setPerhitunganKomin1(double perhitunganKomin1) {
        this.perhitunganKomin1 = perhitunganKomin1;
    }

    public double getPerhitunganKomin2() {
        return perhitunganKomin2;
    }

    public void setPerhitunganKomin2(double perhitunganKomin2) {
        this.perhitunganKomin2 = perhitunganKomin2;
    }
}
