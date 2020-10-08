/*
 * RptLaporanHutangSumray.java
 *
 * Created on July 15, 2009, 11:31 AM
 */

package com.project.fms.report;

 import java.util.Date;
 import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
 public class RptTypeLaporan extends Entity {
    
     /**
      * Holds value of property sumrayHutang.
      */
     private String sumrayHutang;
     private String sumrayPiutang;
     private String hutangDetail;
     private String piutangDetail;
     private double totalPinjamanSamHutang;
     private double totalAngsuranSamHutang;
     private double totalSaldoSamHutang;
     private double totalAngsuranHutangDetail;
     private double totalPinjamanHutangDetail;
     private double totalSaldoHutangDetail;
     private double totalAngsuranPiutangDetail;
     private double totalPinjamanPiutangDetail;
     private double totalSaldoPiutangDetail;
     private double totalAngsuranSamPiutang;
     private double totalPinjamanSamPiutang;
     private double totalSaldoSamPiutang;
     
    /** Creates a new instance of RptLaporanHutangSumray */
    public RptTypeLaporan() {
    }
    
    /**
     * Getter for property typeLaporan.
     * @return Value of property typeLaporan.
     */
    public String getSumrayHutang() {
        return this.sumrayHutang;
    }
    
    /**
     * Setter for property typeLaporan.
     * @param typeLaporan New value of property typeLaporan.
     */
    public void setSumrayHutang(String sumrayHutang) {
        this.sumrayHutang = sumrayHutang;
    }
    
    /**
     * Getter for property sumrayPiutang.
     * @return Value of property sumrayPiutang.
     */
    public String getSumrayPiutang() {
        return this.sumrayPiutang;
    }
    
    /**
     * Setter for property sumrayPiutang.
     * @param sumrayPiutang New value of property sumrayPiutang.
     */
    public void setSumrayPiutang(String sumrayPiutang) {
        this.sumrayPiutang = sumrayPiutang;
    }
    
    /**
     * Getter for property sumrayHutangDetail.
     * @return Value of property sumrayHutangDetail.
     */
    public String getHutangDetail() {
        return this.hutangDetail;
    }
    
    /**
     * Setter for property sumrayHutangDetail.
     * @param sumrayHutangDetail New value of property sumrayHutangDetail.
     */
    public void setHutangDetail(String hutangDetail) {
        this.hutangDetail = hutangDetail;
    }
    
    /**
     * Getter for property piutangDetail.
     * @return Value of property piutangDetail.
     */
    public String getPiutangDetail() {
        return this.piutangDetail;
    }
    
    /**
     * Setter for property piutangDetail.
     * @param piutangDetail New value of property piutangDetail.
     */
    public void setPiutangDetail(String piutangDetail) {
        this.piutangDetail = piutangDetail;
    }
    
    /**
     * Getter for property totalPinjamanSamHutang.
     * @return Value of property totalPinjamanSamHutang.
     */
    public double getTotalPinjamanSamHutang() {
        return this.totalPinjamanSamHutang;
    }
    
    /**
     * Setter for property totalPinjamanSamHutang.
     * @param totalPinjamanSamHutang New value of property totalPinjamanSamHutang.
     */
    public void setTotalPinjamanSamHutang(double totalPinjamanSamHutang) {
        this.totalPinjamanSamHutang = totalPinjamanSamHutang;
    }
    
    /**
     * Getter for property totalAngsuranSamHutang.
     * @return Value of property totalAngsuranSamHutang.
     */
    public double getTotalAngsuranSamHutang() {
        return this.totalAngsuranSamHutang;
    }
    
    /**
     * Setter for property totalAngsuranSamHutang.
     * @param totalAngsuranSamHutang New value of property totalAngsuranSamHutang.
     */
    public void setTotalAngsuranSamHutang(double totalAngsuranSamHutang) {
        this.totalAngsuranSamHutang = totalAngsuranSamHutang;
    }
    
    /**
     * Getter for property totalSaldoSamHutang.
     * @return Value of property totalSaldoSamHutang.
     */
    public double getTotalSaldoSamHutang() {
        return this.totalSaldoSamHutang;
    }
    
    /**
     * Setter for property totalSaldoSamHutang.
     * @param totalSaldoSamHutang New value of property totalSaldoSamHutang.
     */
    public void setTotalSaldoSamHutang(double totalSaldoSamHutang) {
        this.totalSaldoSamHutang = totalSaldoSamHutang;
    }
    
    /**
     * Getter for property totalAngsuranHutangDetail.
     * @return Value of property totalAngsuranHutangDetail.
     */
    public double getTotalAngsuranHutangDetail() {
        return this.totalAngsuranHutangDetail;
    }
    
    /**
     * Setter for property totalAngsuranHutangDetail.
     * @param totalAngsuranHutangDetail New value of property totalAngsuranHutangDetail.
     */
    public void setTotalAngsuranHutangDetail(double totalAngsuranHutangDetail) {
        this.totalAngsuranHutangDetail = totalAngsuranHutangDetail;
    }
    
    /**
     * Getter for property totalPinjamanHutangDetail.
     * @return Value of property totalPinjamanHutangDetail.
     */
    public double getTotalPinjamanHutangDetail() {
        return this.totalPinjamanHutangDetail;
    }
    
    /**
     * Setter for property totalPinjamanHutangDetail.
     * @param totalPinjamanHutangDetail New value of property totalPinjamanHutangDetail.
     */
    public void setTotalPinjamanHutangDetail(double totalPinjamanHutangDetail) {
        this.totalPinjamanHutangDetail = totalPinjamanHutangDetail;
    }
    
    /**
     * Getter for property totalSaldoHutangDetail.
     * @return Value of property totalSaldoHutangDetail.
     */
    public double getTotalSaldoHutangDetail() {
        return this.totalSaldoHutangDetail;
    }
    
    /**
     * Setter for property totalSaldoHutangDetail.
     * @param totalSaldoHutangDetail New value of property totalSaldoHutangDetail.
     */
    public void setTotalSaldoHutangDetail(double totalSaldoHutangDetail) {
        this.totalSaldoHutangDetail = totalSaldoHutangDetail;
    }
    
    /**
     * Getter for property totalAngsuranPiutangDetail.
     * @return Value of property totalAngsuranPiutangDetail.
     */
    public double getTotalAngsuranPiutangDetail() {
        return this.totalAngsuranPiutangDetail;
    }
    
    /**
     * Setter for property totalAngsuranPiutangDetail.
     * @param totalAngsuranPiutangDetail New value of property totalAngsuranPiutangDetail.
     */
    public void setTotalAngsuranPiutangDetail(double totalAngsuranPiutangDetail) {
        this.totalAngsuranPiutangDetail = totalAngsuranPiutangDetail;
    }
    
    /**
     * Getter for property totalPinjamanPiutangDetail.
     * @return Value of property totalPinjamanPiutangDetail.
     */
    public double getTotalPinjamanPiutangDetail() {
        return this.totalPinjamanPiutangDetail;
    }
    
    /**
     * Setter for property totalPinjamanPiutangDetail.
     * @param totalPinjamanPiutangDetail New value of property totalPinjamanPiutangDetail.
     */
    public void setTotalPinjamanPiutangDetail(double totalPinjamanPiutangDetail) {
        this.totalPinjamanPiutangDetail = totalPinjamanPiutangDetail;
    }
    
    /**
     * Getter for property totalSaldoPiutangDetail.
     * @return Value of property totalSaldoPiutangDetail.
     */
    public double getTotalSaldoPiutangDetail() {
        return this.totalSaldoPiutangDetail;
    }
    
    /**
     * Setter for property totalSaldoPiutangDetail.
     * @param totalSaldoPiutangDetail New value of property totalSaldoPiutangDetail.
     */
    public void setTotalSaldoPiutangDetail(double totalSaldoPiutangDetail) {
        this.totalSaldoPiutangDetail = totalSaldoPiutangDetail;
    }
    
    /**
     * Getter for property totalAngsuranSamPiutang.
     * @return Value of property totalAngsuranSamPiutang.
     */
    public double getTotalAngsuranSamPiutang() {
        return this.totalAngsuranSamPiutang;
    }
    
    /**
     * Setter for property totalAngsuranSamPiutang.
     * @param totalAngsuranSamPiutang New value of property totalAngsuranSamPiutang.
     */
    public void setTotalAngsuranSamPiutang(double totalAngsuranSamPiutang) {
        this.totalAngsuranSamPiutang = totalAngsuranSamPiutang;
    }
    
    /**
     * Getter for property totalPinjamanSamPiutang.
     * @return Value of property totalPinjamanSamPiutang.
     */
    public double getTotalPinjamanSamPiutang() {
        return this.totalPinjamanSamPiutang;
    }
    
    /**
     * Setter for property totalPinjamanSamPiutang.
     * @param totalPinjamanSamPiutang New value of property totalPinjamanSamPiutang.
     */
    public void setTotalPinjamanSamPiutang(double totalPinjamanSamPiutang) {
        this.totalPinjamanSamPiutang = totalPinjamanSamPiutang;
    }
    
    /**
     * Getter for property totalSaldoSamPiutang.
     * @return Value of property totalSaldoSamPiutang.
     */
    public double getTotalSaldoSamPiutang() {
        return this.totalSaldoSamPiutang;
    }
    
    /**
     * Setter for property totalSaldoSamPiutang.
     * @param totalSaldoSamPiutang New value of property totalSaldoSamPiutang.
     */
    public void setTotalSaldoSamPiutang(double totalSaldoSamPiutang) {
        this.totalSaldoSamPiutang = totalSaldoSamPiutang;
    }
    
}
