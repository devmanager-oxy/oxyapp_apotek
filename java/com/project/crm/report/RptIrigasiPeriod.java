package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author Tu Roy
 */
public class RptIrigasiPeriod {

    private long custId = 0;
    private String custName = "";
    private int custType = 0;
    private long transId = 0;
    private long transPeriodId = 0;
    private double transBulanIni = 0;
    private double transBulanLalu = 0;
    private double transHarga = 0;
    private long irigasiId = 0;
    private double irigasiRate = 0;
    private double irigasiPercent = 0;
    private Date irigasiEfective = new Date();
    private double irigasiPpnPercent = 0;
    private long periodId = 0;
    private String periodName = "";
    private int postedStatus = 0;
    private String nomorTransaksi = "";
    private String nomorFP = "";
    private Date jatuhTempo = new Date();
    private double totalDenda = 0;
    private String statusPembayaran = "";
    private String currencyCode = "";

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public Date getJatuhTempo() {
        return jatuhTempo;
    }

    public void setJatuhTempo(Date jatuhTempo) {
        this.jatuhTempo = jatuhTempo;
    }

    public String getStatusPembayaran() {
        return statusPembayaran;
    }

    public void setStatusPembayaran(String statusPembayaran) {
        this.statusPembayaran = statusPembayaran;
    }

    public double getTotalDenda() {
        return totalDenda;
    }

    public void setTotalDenda(double totalDenda) {
        this.totalDenda = totalDenda;
    }

    public long getCustId() {
        return custId;
    }

    public void setCustId(long custId) {
        this.custId = custId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public int getCustType() {
        return custType;
    }

    public void setCustType(int custType) {
        this.custType = custType;
    }

    public long getTransId() {
        return transId;
    }

    public void setTransId(long transId) {
        this.transId = transId;
    }

    public long getTransPeriodId() {
        return transPeriodId;
    }

    public void setTransPeriodId(long transPeriodId) {
        this.transPeriodId = transPeriodId;
    }

    public double getTransBulanIni() {
        return transBulanIni;
    }

    public void setTransBulanIni(double transBulanIni) {
        this.transBulanIni = transBulanIni;
    }

    public double getTransBulanLalu() {
        return transBulanLalu;
    }

    public void setTransBulanLalu(double transBulanLalu) {
        this.transBulanLalu = transBulanLalu;
    }

    public double getTransHarga() {
        return transHarga;
    }

    public void setTransHarga(double transHarga) {
        this.transHarga = transHarga;
    }

    public long getIrigasiId() {
        return irigasiId;
    }

    public void setIrigasiId(long irigasiId) {
        this.irigasiId = irigasiId;
    }

    public double getIrigasiRate() {
        return irigasiRate;
    }

    public void setIrigasiRate(double irigasiRate) {
        this.irigasiRate = irigasiRate;
    }

    public double getIrigasiPercent() {
        return irigasiPercent;
    }

    public void setIrigasiPercent(double irigasiPercent) {
        this.irigasiPercent = irigasiPercent;
    }

    public Date getIrigasiEfective() {
        return irigasiEfective;
    }

    public void setIrigasiEfective(Date irigasiEfective) {
        this.irigasiEfective = irigasiEfective;
    }

    public double getIrigasiPpnPercent() {
        return irigasiPpnPercent;
    }

    public void setIrigasiPpnPercent(double irigasiPpnPercent) {
        this.irigasiPpnPercent = irigasiPpnPercent;
    }

    public long getPeriodId() {
        return periodId;
    }

    public void setPeriodId(long periodId) {
        this.periodId = periodId;
    }

    public String getPeriodName() {
        return periodName;
    }

    public void setPeriodName(String periodName) {
        this.periodName = periodName;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public int getPostedStatus() {
        return (this.postedStatus);
    }

    public void setNomorTransaksi(String nomorTransaksi) {
        this.nomorTransaksi = nomorTransaksi;
    }

    public void setNomorFP(String nomorFP) {
        this.nomorFP = nomorFP;
    }

    public String getNomorTransaksi() {
        return (this.nomorTransaksi);
    }

    public String getNomorFP() {
        return (this.nomorFP);
    }
}
