/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;
import java.util.Date;

/**
 *
 * @author Tu Roy
 */

public class RptPemakaianIrigasiPeriod {
    
    private long custId;
    private String custName   = "";
    
    private long transId; 
    private long transPeriodId;
    private double transBulanIni;
    private double transBulanLalu;
    private double transPemakaian;
    private String keterangan = "";
    private double persentase = 0.0;
    
    private long IriId;
    private Date limEfective = new Date();
    
    private long periodId;
    private String periodName = "";

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

    public String getKeterangan(){
        return keterangan;
    }

    public void setKeterangan(String keterangan){
        this.keterangan = keterangan;
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

    public double getTransPemakaian(){
        return transPemakaian;
    }

    public void setTransPemakaian(double transpemakaian){
        this.transPemakaian = transpemakaian;
    }

    public long getIriId() {
        return IriId;
    }

    public void setIriId(long iriid) {
        this.IriId = iriid;
    }
    
    public Date getLimEfective() {
        return limEfective;
    }

    public void setLimEfective(Date limEfective) {
        this.limEfective = limEfective;
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

	
	public void setPersentase(double persentase) {
		this.persentase = persentase; 
	}

	public double getPersentase() {
		return (this.persentase); 
	}

}
