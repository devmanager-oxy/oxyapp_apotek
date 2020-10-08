package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author Tu Roy
 */
public class RptLimbahPeriod {

    private long custId = 0;
    private String custName = "";
    private int custType = 0;
    private long transId = 0;
    private long transPeriodId = 0;
    private double transBulanIni = 0;
    private double transBulanLalu = 0;
    private double transPercentage = 0;
    private double transHarga = 0;
    private long limId = 0;
    private double limRate = 0;
    private double limPercent = 0;
    private Date limEfective = new Date();
    private double limPpnPercent = 0;
    private int postedStatus = 0;
    private long periodId;
    private String periodName = "";
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

    public double getTransPercentage() {
        return transPercentage;
    }

    public void setTransPercentage(double transPercentage) {
        this.transPercentage = transPercentage;
    }

    public double getTransHarga() {
        return transHarga;
    }

    public void setTransHarga(double transHarga) {
        this.transHarga = transHarga;
    }

    public long getLimId() {
        return limId;
    }

    public void setLimId(long limId) {
        this.limId = limId;
    }

    public double getLimRate() {
        return limRate;
    }

    public void setLimRate(double limRate) {
        this.limRate = limRate;
    }

    public double getLimPercent() {
        return limPercent;
    }

    public void setLimPercent(double limPercent) {
        this.limPercent = limPercent;
    }

    public Date getLimEfective() {
        return limEfective;
    }

    public void setLimEfective(Date limEfective) {
        this.limEfective = limEfective;
    }

    public double getLimPpnPercent() {
        return limPpnPercent;
    }

    public void setLimPpnPercent(double limPpnPercent) {
        this.limPpnPercent = limPpnPercent;
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
