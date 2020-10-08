package com.project.fms.report;

/**
 *
 * @author gwawan
 */
public class RptBiayaOperasiDireksi {
    String coaName = "";
    String coaCode = "";
    int coaLevel = 0;
    String coaStatus = "";
    String uraian = "";
    double totalBiaya = 0;
    double biayaUmum = 0;
    double biayaPerencanaan = 0;
    double biayaKeuangan = 0;

    public double getBiayaKeuangan() {
        return biayaKeuangan;
    }

    public void setBiayaKeuangan(double biayaKeuangan) {
        this.biayaKeuangan = biayaKeuangan;
    }

    public double getBiayaPerencanaan() {
        return biayaPerencanaan;
    }

    public void setBiayaPerencanaan(double biayaPerencanaan) {
        this.biayaPerencanaan = biayaPerencanaan;
    }

    public double getBiayaUmum() {
        return biayaUmum;
    }

    public void setBiayaUmum(double biayaUmum) {
        this.biayaUmum = biayaUmum;
    }

    public double getTotalBiaya() {
        return totalBiaya;
    }

    public void setTotalBiaya(double totalBiaya) {
        this.totalBiaya = totalBiaya;
    }

    public String getUraian() {
        return uraian;
    }

    public void setUraian(String uraian) {
        this.uraian = uraian;
    }

    public String getCoaStatus() {
        return coaStatus;
    }

    public void setCoaStatus(String coaStatus) {
        this.coaStatus = coaStatus;
    }

    public int getCoaLevel() {
        return coaLevel;
    }

    public void setCoaLevel(int coaLevel) {
        this.coaLevel = coaLevel;
    }

    public String getCoaCode() {
        return coaCode;
    }

    public void setCoaCode(String coaCode) {
        this.coaCode = coaCode;
    }

    public String getCoaName() {
        return coaName;
    }

    public void setCoaName(String coaName) {
        this.coaName = coaName;
    }
    
}
