/*
 * RptAktivaTetapL.java
 *
 * Created on October 1, 2009, 2:16 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptAktivaTetapL extends Entity {
    
    /**
     * Holds value of property nomor.
     */
    private String nomor;
    private String aktiva;
    private double persentase;
    private double jumlahUnit;
    private Date tahunPerolehan;
    
    private double perolehanSd;
    private double perolehanPenambahan;
    private double penyusutanPer;
    private double penyusutanSaldo;
    private double penyusutanPenambah;
    private String keterangan;
    private double penyusutanPengurang;
    
    private double totalPerolehanSd;
    private double totalPerolehanPenambah;
    private double totalPerolehanSaldoSaatIni;
    private double totalPenyusutanPer;
    private double totalPenyusutanSaldo1;
    private double totalPenyusutanSo;
    private double totalPenyusutanPenambah;
    private double totalPenyusutanPengurang;
    private double totalPenyusutanSaldo2;
    private double totalPenyusutanSaldo3;
    private double totalNilaiBuku;
    
    private double taNilaiBuku;
    private double taPenyusutanPenambahan;
    private double taPenyusutanPengurangan;
    private double taPenyusutanPer;
    private double taPenyusutanSaldo1;
    private double taPenyusutanSaldo2;
    private double taPenyusutanSaldo3;
    private double taPenyusutanSo;
    private double taPerolehanPenambahan;
    private double taPerolehanSaldoSaatIni;
    private double taPerolehanSd;
    
    private int level;
    private String header1;
    private String header2;
    
    /**
     * Holds value of property totalNilaiBuku2.
     */
    private double totalNilaiBuku2;
    
    /**
     * Holds value of property totalPenyusutanPenambah2.
     */
    private double totalPenyusutanPenambah2;
    
    /**
     * Holds value of property totalPenyusutanPengurang2.
     */
    private double totalPenyusutanPengurang2;
    
    /**
     * Holds value of property totalPenyusutanPer2.
     */
    private double totalPenyusutanPer2;
    
    /**
     * Holds value of property totalPenyusutanSaldo11.
     */
    private double totalPenyusutanSaldo11;
    
    /**
     * Holds value of property totalPenyusutanSaldo21.
     */
    private double totalPenyusutanSaldo21;
    
    /**
     * Holds value of property totalPenyusutanSaldo31.
     */
    private double totalPenyusutanSaldo31;
    
    /**
     * Holds value of property totalPenyusutanSo2.
     */
    private double totalPenyusutanSo2;
    
    /**
     * Holds value of property totalPerolehanPenambah2.
     */
    private double totalPerolehanPenambah2;
    
    /**
     * Holds value of property totalPerolehanSaldoSaatIni2.
     */
    private double totalPerolehanSaldoSaatIni2;
    
    /**
     * Holds value of property totalPerolehanSd2.
     */
    private double totalPerolehanSd2;
    
    /** Creates a new instance of RptAktivaTetapL */
    public RptAktivaTetapL() {
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
     * Getter for property aktiva.
     * @return Value of property aktiva.
     */
    public String getAktiva() {
        return this.aktiva;
    }
    
    /**
     * Setter for property aktiva.
     * @param aktiva New value of property aktiva.
     */
    public void setAktiva(String aktiva) {
        this.aktiva = aktiva;
    }
    
    /**
     * Getter for property persentase.
     * @return Value of property persentase.
     */
    public double getPersentase() {
        return this.persentase;
    }
    
    /**
     * Setter for property persentase.
     * @param persentase New value of property persentase.
     */
    public void setPersentase(double persentase) {
        this.persentase = persentase;
    }
    
    /**
     * Getter for property jumlahUnit.
     * @return Value of property jumlahUnit.
     */
    public double getJumlahUnit() {
        return this.jumlahUnit;
    }
    
    /**
     * Setter for property jumlahUnit.
     * @param jumlahUnit New value of property jumlahUnit.
     */
    public void setJumlahUnit(double jumlahUnit) {
        this.jumlahUnit = jumlahUnit;
    }
    
    /**
     * Getter for property tahunPerolehan.
     * @return Value of property tahunPerolehan.
     */
    public Date getTahunPerolehan() {
        return this.tahunPerolehan;
    }
    
    /**
     * Setter for property tahunPerolehan.
     * @param tahunPerolehan New value of property tahunPerolehan.
     */
    public void setTahunPerolehan(Date tahunPerolehan) {
        this.tahunPerolehan = tahunPerolehan;
    }
    
    /**
     * Getter for property perolehanSd.
     * @return Value of property perolehanSd.
     */
    public double getPerolehanSd() {
        return this.perolehanSd;
    }
    
    /**
     * Setter for property perolehanSd.
     * @param perolehanSd New value of property perolehanSd.
     */
    public void setPerolehanSd(double perolehanSd) {
        this.perolehanSd = perolehanSd;
    }
    
    /**
     * Getter for property perolehanPenambahan.
     * @return Value of property perolehanPenambahan.
     */
    public double getPerolehanPenambahan() {
        return this.perolehanPenambahan;
    }
    
    /**
     * Setter for property perolehanPenambahan.
     * @param perolehanPenambahan New value of property perolehanPenambahan.
     */
    public void setPerolehanPenambahan(double perolehanPenambahan) {
        this.perolehanPenambahan = perolehanPenambahan;
    }
    
    /**
     * Getter for property penyusutanPer.
     * @return Value of property penyusutanPer.
     */
    public double getPenyusutanPer() {
        return this.penyusutanPer;
    }
    
    /**
     * Setter for property penyusutanPer.
     * @param penyusutanPer New value of property penyusutanPer.
     */
    public void setPenyusutanPer(double penyusutanPer) {
        this.penyusutanPer = penyusutanPer;
    }
    
    /**
     * Getter for property penyusutanSaldo.
     * @return Value of property penyusutanSaldo.
     */
    public double getPenyusutanSaldo() {
        return this.penyusutanSaldo;
    }
    
    /**
     * Setter for property penyusutanSaldo.
     * @param penyusutanSaldo New value of property penyusutanSaldo.
     */
    public void setPenyusutanSaldo(double penyusutanSaldo) {
        this.penyusutanSaldo = penyusutanSaldo;
    }
    
    /**
     * Getter for property penyusutanPenambah.
     * @return Value of property penyusutanPenambah.
     */
    public double getPenyusutanPenambah() {
        return this.penyusutanPenambah;
    }
    
    /**
     * Setter for property penyusutanPenambah.
     * @param penyusutanPenambah New value of property penyusutanPenambah.
     */
    public void setPenyusutanPenambah(double penyusutanPenambah) {
        this.penyusutanPenambah = penyusutanPenambah;
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
    
    /**
     * Getter for property penyusutanPengurang.
     * @return Value of property penyusutanPengurang.
     */
    public double getPenyusutanPengurang() {
        return this.penyusutanPengurang;
    }
    
    /**
     * Setter for property penyusutanPengurang.
     * @param penyusutanPengurang New value of property penyusutanPengurang.
     */
    public void setPenyusutanPengurang(double penyusutanPengurang) {
        this.penyusutanPengurang = penyusutanPengurang;
    }
    
    /**
     * Getter for property totalPerolehan.
     * @return Value of property totalPerolehan.
     */
    public double getTotalPerolehanSd() {
        return this.totalPerolehanSd;
    }
    
    /**
     * Setter for property totalPerolehan.
     * @param totalPerolehan New value of property totalPerolehan.
     */
    public void setTotalPerolehanSd(double totalPerolehanSd) {
        this.totalPerolehanSd = totalPerolehanSd;
    }
    
    /**
     * Getter for property totalPerolehanPenambah.
     * @return Value of property totalPerolehanPenambah.
     */
    public double getTotalPerolehanPenambah() {
        return this.totalPerolehanPenambah;
    }
    
    /**
     * Setter for property totalPerolehanPenambah.
     * @param totalPerolehanPenambah New value of property totalPerolehanPenambah.
     */
    public void setTotalPerolehanPenambah(double totalPerolehanPenambah) {
        this.totalPerolehanPenambah = totalPerolehanPenambah;
    }
    
    /**
     * Getter for property totalPerolehanSaldoSaatIni.
     * @return Value of property totalPerolehanSaldoSaatIni.
     */
    public double getTotalPerolehanSaldoSaatIni() {
        return this.totalPerolehanSaldoSaatIni;
    }
    
    /**
     * Setter for property totalPerolehanSaldoSaatIni.
     * @param totalPerolehanSaldoSaatIni New value of property totalPerolehanSaldoSaatIni.
     */
    public void setTotalPerolehanSaldoSaatIni(double totalPerolehanSaldoSaatIni) {
        this.totalPerolehanSaldoSaatIni = totalPerolehanSaldoSaatIni;
    }
    
    /**
     * Getter for property totalPenyusutanPer.
     * @return Value of property totalPenyusutanPer.
     */
    public double getTotalPenyusutanPer() {
        return this.totalPenyusutanPer;
    }
    
    /**
     * Setter for property totalPenyusutanPer.
     * @param totalPenyusutanPer New value of property totalPenyusutanPer.
     */
    public void setTotalPenyusutanPer(double totalPenyusutanPer) {
        this.totalPenyusutanPer = totalPenyusutanPer;
    }
    
    /**
     * Getter for property totalPenyusutanSaldo1.
     * @return Value of property totalPenyusutanSaldo1.
     */
    public double getTotalPenyusutanSaldo1() {
        return this.totalPenyusutanSaldo1;
    }
    
    /**
     * Setter for property totalPenyusutanSaldo1.
     * @param totalPenyusutanSaldo1 New value of property totalPenyusutanSaldo1.
     */
    public void setTotalPenyusutanSaldo1(double totalPenyusutanSaldo1) {
        this.totalPenyusutanSaldo1 = totalPenyusutanSaldo1;
    }
    
    /**
     * Getter for property totalPenyusutanSo.
     * @return Value of property totalPenyusutanSo.
     */
    public double getTotalPenyusutanSo() {
        return this.totalPenyusutanSo;
    }
    
    /**
     * Setter for property totalPenyusutanSo.
     * @param totalPenyusutanSo New value of property totalPenyusutanSo.
     */
    public void setTotalPenyusutanSo(double totalPenyusutanSo) {
        this.totalPenyusutanSo = totalPenyusutanSo;
    }
    
    /**
     * Getter for property totalPenyusutanPenambah.
     * @return Value of property totalPenyusutanPenambah.
     */
    public double getTotalPenyusutanPenambah() {
        return this.totalPenyusutanPenambah;
    }
    
    /**
     * Setter for property totalPenyusutanPenambah.
     * @param totalPenyusutanPenambah New value of property totalPenyusutanPenambah.
     */
    public void setTotalPenyusutanPenambah(double totalPenyusutanPenambah) {
        this.totalPenyusutanPenambah = totalPenyusutanPenambah;
    }
    
    /**
     * Getter for property totalPenyusutanPengurang.
     * @return Value of property totalPenyusutanPengurang.
     */
    public double getTotalPenyusutanPengurang() {
        return this.totalPenyusutanPengurang;
    }
    
    /**
     * Setter for property totalPenyusutanPengurang.
     * @param totalPenyusutanPengurang New value of property totalPenyusutanPengurang.
     */
    public void setTotalPenyusutanPengurang(double totalPenyusutanPengurang) {
        this.totalPenyusutanPengurang = totalPenyusutanPengurang;
    }
    
    /**
     * Getter for property totalPenyusutanSaldow2.
     * @return Value of property totalPenyusutanSaldow2.
     */
    public double getTotalPenyusutanSaldo2() {
        return this.totalPenyusutanSaldo2;
    }
    
    /**
     * Setter for property totalPenyusutanSaldow2.
     * @param totalPenyusutanSaldow2 New value of property totalPenyusutanSaldow2.
     */
    public void setTotalPenyusutanSaldo2(double totalPenyusutanSaldo2) {
        this.totalPenyusutanSaldo2 = totalPenyusutanSaldo2;
    }
    
    /**
     * Getter for property totalPenyusutanSaldo3.
     * @return Value of property totalPenyusutanSaldo3.
     */
    public double getTotalPenyusutanSaldo3() {
        return this.totalPenyusutanSaldo3;
    }
    
    /**
     * Setter for property totalPenyusutanSaldo3.
     * @param totalPenyusutanSaldo3 New value of property totalPenyusutanSaldo3.
     */
    public void setTotalPenyusutanSaldo3(double totalPenyusutanSaldo3) {
        this.totalPenyusutanSaldo3 = totalPenyusutanSaldo3;
    }
    
    /**
     * Getter for property totalNilaiBuku.
     * @return Value of property totalNilaiBuku.
     */
    public double getTotalNilaiBuku() {
        return this.totalNilaiBuku;
    }
    
    /**
     * Setter for property totalNilaiBuku.
     * @param totalNilaiBuku New value of property totalNilaiBuku.
     */
    public void setTotalNilaiBuku(double totalNilaiBuku) {
        this.totalNilaiBuku = totalNilaiBuku;
    }
    
    /**
     * Getter for property taNilaiBuku.
     * @return Value of property taNilaiBuku.
     */
    public double getTaNilaiBuku() {
        return this.taNilaiBuku;
    }
    
    /**
     * Setter for property taNilaiBuku.
     * @param taNilaiBuku New value of property taNilaiBuku.
     */
    public void setTaNilaiBuku(double taNilaiBuku) {
        this.taNilaiBuku = taNilaiBuku;
    }
    
    /**
     * Getter for property taPenyusutanPenambahan.
     * @return Value of property taPenyusutanPenambahan.
     */
    public double getTaPenyusutanPenambahan() {
        return this.taPenyusutanPenambahan;
    }
    
    /**
     * Setter for property taPenyusutanPenambahan.
     * @param taPenyusutanPenambahan New value of property taPenyusutanPenambahan.
     */
    public void setTaPenyusutanPenambahan(double taPenyusutanPenambahan) {
        this.taPenyusutanPenambahan = taPenyusutanPenambahan;
    }
    
    /**
     * Getter for property taPenyusutanPengurangan.
     * @return Value of property taPenyusutanPengurangan.
     */
    public double getTaPenyusutanPengurangan() {
        return this.taPenyusutanPengurangan;
    }
    
    /**
     * Setter for property taPenyusutanPengurangan.
     * @param taPenyusutanPengurangan New value of property taPenyusutanPengurangan.
     */
    public void setTaPenyusutanPengurangan(double taPenyusutanPengurangan) {
        this.taPenyusutanPengurangan = taPenyusutanPengurangan;
    }
    
    /**
     * Getter for property taPenyusutanPer.
     * @return Value of property taPenyusutanPer.
     */
    public double getTaPenyusutanPer() {
        return this.taPenyusutanPer;
    }
    
    /**
     * Setter for property taPenyusutanPer.
     * @param taPenyusutanPer New value of property taPenyusutanPer.
     */
    public void setTaPenyusutanPer(double taPenyusutanPer) {
        this.taPenyusutanPer = taPenyusutanPer;
    }
    
    /**
     * Getter for property taPenyusutanSaldo1.
     * @return Value of property taPenyusutanSaldo1.
     */
    public double getTaPenyusutanSaldo1() {
        return this.taPenyusutanSaldo1;
    }
    
    /**
     * Setter for property taPenyusutanSaldo1.
     * @param taPenyusutanSaldo1 New value of property taPenyusutanSaldo1.
     */
    public void setTaPenyusutanSaldo1(double taPenyusutanSaldo1) {
        this.taPenyusutanSaldo1 = taPenyusutanSaldo1;
    }
    
    /**
     * Getter for property taPenyusutanSaldo2.
     * @return Value of property taPenyusutanSaldo2.
     */
    public double getTaPenyusutanSaldo2() {
        return this.taPenyusutanSaldo2;
    }
    
    /**
     * Setter for property taPenyusutanSaldo2.
     * @param taPenyusutanSaldo2 New value of property taPenyusutanSaldo2.
     */
    public void setTaPenyusutanSaldo2(double taPenyusutanSaldo2) {
        this.taPenyusutanSaldo2 = taPenyusutanSaldo2;
    }
    
    /**
     * Getter for property taPenyusutanSaldo3.
     * @return Value of property taPenyusutanSaldo3.
     */
    public double getTaPenyusutanSaldo3() {
        return this.taPenyusutanSaldo3;
    }
    
    /**
     * Setter for property taPenyusutanSaldo3.
     * @param taPenyusutanSaldo3 New value of property taPenyusutanSaldo3.
     */
    public void setTaPenyusutanSaldo3(double taPenyusutanSaldo3) {
        this.taPenyusutanSaldo3 = taPenyusutanSaldo3;
    }
    
    /**
     * Getter for property taPenyusutanSo.
     * @return Value of property taPenyusutanSo.
     */
    public double getTaPenyusutanSo() {
        return this.taPenyusutanSo;
    }
    
    /**
     * Setter for property taPenyusutanSo.
     * @param taPenyusutanSo New value of property taPenyusutanSo.
     */
    public void setTaPenyusutanSo(double taPenyusutanSo) {
        this.taPenyusutanSo = taPenyusutanSo;
    }
    
    /**
     * Getter for property taPerolehanPenambahan.
     * @return Value of property taPerolehanPenambahan.
     */
    public double getTaPerolehanPenambahan() {
        return this.taPerolehanPenambahan;
    }
    
    /**
     * Setter for property taPerolehanPenambahan.
     * @param taPerolehanPenambahan New value of property taPerolehanPenambahan.
     */
    public void setTaPerolehanPenambahan(double taPerolehanPenambahan) {
        this.taPerolehanPenambahan = taPerolehanPenambahan;
    }
    
    /**
     * Getter for property taPerolehanSaldoSaatIni.
     * @return Value of property taPerolehanSaldoSaatIni.
     */
    public double getTaPerolehanSaldoSaatIni() {
        return this.taPerolehanSaldoSaatIni;
    }
    
    /**
     * Setter for property taPerolehanSaldoSaatIni.
     * @param taPerolehanSaldoSaatIni New value of property taPerolehanSaldoSaatIni.
     */
    public void setTaPerolehanSaldoSaatIni(double taPerolehanSaldoSaatIni) {
        this.taPerolehanSaldoSaatIni = taPerolehanSaldoSaatIni;
    }
    
    /**
     * Getter for property taPerolehanSd.
     * @return Value of property taPerolehanSd.
     */
    public double getTaPerolehanSd() {
        return this.taPerolehanSd;
    }
    
    /**
     * Setter for property taPerolehanSd.
     * @param taPerolehanSd New value of property taPerolehanSd.
     */
    public void setTaPerolehanSd(double taPerolehanSd) {
        this.taPerolehanSd = taPerolehanSd;
    }
    
    /**
     * Getter for property level.
     * @return Value of property level.
     */
    public int getLevel() {
        return this.level;
    }
    
    /**
     * Setter for property level.
     * @param level New value of property level.
     */
    public void setLevel(int level) {
        this.level = level;
    }
    
    /**
     * Getter for property header1.
     * @return Value of property header1.
     */
    public String getHeader1() {
        return this.header1;
    }
    
    /**
     * Setter for property header1.
     * @param header1 New value of property header1.
     */
    public void setHeader1(String header1) {
        this.header1 = header1;
    }
    
    /**
     * Getter for property header2.
     * @return Value of property header2.
     */
    public String getHeader2() {
        return this.header2;
    }
    
    /**
     * Setter for property header2.
     * @param header2 New value of property header2.
     */
    public void setHeader2(String header2) {
        this.header2 = header2;
    }
    
    /**
     * Getter for property totalNilaiBuku2.
     * @return Value of property totalNilaiBuku2.
     */
    public double getTotalNilaiBuku2() {
        return this.totalNilaiBuku2;
    }
    
    /**
     * Setter for property totalNilaiBuku2.
     * @param totalNilaiBuku2 New value of property totalNilaiBuku2.
     */
    public void setTotalNilaiBuku2(double totalNilaiBuku2) {
        this.totalNilaiBuku2 = totalNilaiBuku2;
    }
    
    /**
     * Getter for property totalPenyusutanPenambah2.
     * @return Value of property totalPenyusutanPenambah2.
     */
    public double getTotalPenyusutanPenambah2() {
        return this.totalPenyusutanPenambah2;
    }
    
    /**
     * Setter for property totalPenyusutanPenambah2.
     * @param totalPenyusutanPenambah2 New value of property totalPenyusutanPenambah2.
     */
    public void setTotalPenyusutanPenambah2(double totalPenyusutanPenambah2) {
        this.totalPenyusutanPenambah2 = totalPenyusutanPenambah2;
    }
    
    /**
     * Getter for property totalPenyusutanPengurang2.
     * @return Value of property totalPenyusutanPengurang2.
     */
    public double getTotalPenyusutanPengurang2() {
        return this.totalPenyusutanPengurang2;
    }
    
    /**
     * Setter for property totalPenyusutanPengurang2.
     * @param totalPenyusutanPengurang2 New value of property totalPenyusutanPengurang2.
     */
    public void setTotalPenyusutanPengurang2(double totalPenyusutanPengurang2) {
        this.totalPenyusutanPengurang2 = totalPenyusutanPengurang2;
    }
    
    /**
     * Getter for property totalPenyusutanPer2.
     * @return Value of property totalPenyusutanPer2.
     */
    public double getTotalPenyusutanPer2() {
        return this.totalPenyusutanPer2;
    }
    
    /**
     * Setter for property totalPenyusutanPer2.
     * @param totalPenyusutanPer2 New value of property totalPenyusutanPer2.
     */
    public void setTotalPenyusutanPer2(double totalPenyusutanPer2) {
        this.totalPenyusutanPer2 = totalPenyusutanPer2;
    }
    
    /**
     * Getter for property totalPenyusutanSaldo11.
     * @return Value of property totalPenyusutanSaldo11.
     */
    public double getTotalPenyusutanSaldo11() {
        return this.totalPenyusutanSaldo11;
    }
    
    /**
     * Setter for property totalPenyusutanSaldo11.
     * @param totalPenyusutanSaldo11 New value of property totalPenyusutanSaldo11.
     */
    public void setTotalPenyusutanSaldo11(double totalPenyusutanSaldo11) {
        this.totalPenyusutanSaldo11 = totalPenyusutanSaldo11;
    }
    
    /**
     * Getter for property totalPenyusutanSaldo21.
     * @return Value of property totalPenyusutanSaldo21.
     */
    public double getTotalPenyusutanSaldo21() {
        return this.totalPenyusutanSaldo21;
    }
    
    /**
     * Setter for property totalPenyusutanSaldo21.
     * @param totalPenyusutanSaldo21 New value of property totalPenyusutanSaldo21.
     */
    public void setTotalPenyusutanSaldo21(double totalPenyusutanSaldo21) {
        this.totalPenyusutanSaldo21 = totalPenyusutanSaldo21;
    }
    
    /**
     * Getter for property totalPenyusutanSaldo31.
     * @return Value of property totalPenyusutanSaldo31.
     */
    public double getTotalPenyusutanSaldo31() {
        return this.totalPenyusutanSaldo31;
    }
    
    /**
     * Setter for property totalPenyusutanSaldo31.
     * @param totalPenyusutanSaldo31 New value of property totalPenyusutanSaldo31.
     */
    public void setTotalPenyusutanSaldo31(double totalPenyusutanSaldo31) {
        this.totalPenyusutanSaldo31 = totalPenyusutanSaldo31;
    }
    
    /**
     * Getter for property totalPenyusutanSo2.
     * @return Value of property totalPenyusutanSo2.
     */
    public double getTotalPenyusutanSo2() {
        return this.totalPenyusutanSo2;
    }
    
    /**
     * Setter for property totalPenyusutanSo2.
     * @param totalPenyusutanSo2 New value of property totalPenyusutanSo2.
     */
    public void setTotalPenyusutanSo2(double totalPenyusutanSo2) {
        this.totalPenyusutanSo2 = totalPenyusutanSo2;
    }
    
    /**
     * Getter for property totalPerolehanPenambah2.
     * @return Value of property totalPerolehanPenambah2.
     */
    public double getTotalPerolehanPenambah2() {
        return this.totalPerolehanPenambah2;
    }
    
    /**
     * Setter for property totalPerolehanPenambah2.
     * @param totalPerolehanPenambah2 New value of property totalPerolehanPenambah2.
     */
    public void setTotalPerolehanPenambah2(double totalPerolehanPenambah2) {
        this.totalPerolehanPenambah2 = totalPerolehanPenambah2;
    }
    
    /**
     * Getter for property totalPerolehanSaldoSaatIni2.
     * @return Value of property totalPerolehanSaldoSaatIni2.
     */
    public double getTotalPerolehanSaldoSaatIni2() {
        return this.totalPerolehanSaldoSaatIni2;
    }
    
    /**
     * Setter for property totalPerolehanSaldoSaatIni2.
     * @param totalPerolehanSaldoSaatIni2 New value of property totalPerolehanSaldoSaatIni2.
     */
    public void setTotalPerolehanSaldoSaatIni2(double totalPerolehanSaldoSaatIni2) {
        this.totalPerolehanSaldoSaatIni2 = totalPerolehanSaldoSaatIni2;
    }
    
    /**
     * Getter for property totalPerolehanSd2.
     * @return Value of property totalPerolehanSd2.
     */
    public double getTotalPerolehanSd2() {
        return this.totalPerolehanSd2;
    }
    
    /**
     * Setter for property totalPerolehanSd2.
     * @param totalPerolehanSd2 New value of property totalPerolehanSd2.
     */
    public void setTotalPerolehanSd2(double totalPerolehanSd2) {
        this.totalPerolehanSd2 = totalPerolehanSd2;
    }
    
}
