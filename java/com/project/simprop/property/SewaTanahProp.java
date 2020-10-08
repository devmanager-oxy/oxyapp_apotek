/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy Andika
 */
public class SewaTanahProp extends Entity{

    private String nomorKontrak = "";
    private long investorId;
    private long customerId;
    private int jenisBangunan;
    private long lotId;
    private double luas;
    private int jmlKamar;
    private int dasarKomin;
    private Date tanggalMulai;
    private Date tanggalSelesai;
    private int status;
    private Date tanggalInput;
    private double rate;
    private int penambahanKontrak;
    private long refId;
    private long currencyId;
    private int assesmentStatus;
    private Date tglMulaiKomin;
    private Date tglMulaiKomper;
    private Date tglMulaiAssesment;
    private String keteranganAmandemen = "";
    private Date tglInvoiceKomin;
    private Date tglInvoiceAssesment;

    public Date getTglInvoiceAssesment() {
        return tglInvoiceAssesment;
    }

    public void setTglInvoiceAssesment(Date tglInvoiceAssesment) {
        this.tglInvoiceAssesment = tglInvoiceAssesment;
    }

    public Date getTglInvoiceKomin() {
        return tglInvoiceKomin;
    }

    public void setTglInvoiceKomin(Date tglInvoiceKomin) {
        this.tglInvoiceKomin = tglInvoiceKomin;
    }

    public Date getTglMulaiAssesment() {
        return tglMulaiAssesment;
    }

    public void setTglMulaiAssesment(Date tglMulaiAssesment) {

        this.tglMulaiAssesment = tglMulaiAssesment;
    }

    public Date getTglMulaiKomper() {
        return tglMulaiKomper;
    }

    public void setTglMulaiKomper(Date tglMulaiKomper) {

        this.tglMulaiKomper = tglMulaiKomper;
    }

    public Date getTglMulaiKomin() {
        return tglMulaiKomin;
    }

    public void setTglMulaiKomin(Date tglMulaiKomin) {

        this.tglMulaiKomin = tglMulaiKomin;
    }

    public int getAssesmentStatus() {
        return assesmentStatus;
    }

    public void setAssesmentStatus(int assesmentStatus) {

        this.assesmentStatus = assesmentStatus;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {

        this.currencyId = currencyId;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {

        this.refId = refId;
    }

    public String getNomorKontrak() {
        return nomorKontrak;
    }

    public void setNomorKontrak(String nomorKontrak) {
        if (nomorKontrak == null) {
            nomorKontrak = "";
        }
        this.nomorKontrak = nomorKontrak;
    }

    public long getInvestorId() {
        return investorId;
    }

    public void setInvestorId(long investorId) {
        this.investorId = investorId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public int getJenisBangunan() {
        return jenisBangunan;
    }

    public void setJenisBangunan(int jenisBangunan) {
        this.jenisBangunan = jenisBangunan;
    }

    public long getLotId() {
        return lotId;
    }

    public void setLotId(long lotId) {
        this.lotId = lotId;
    }

    public double getLuas() {
        return luas;
    }

    public void setLuas(double luas) {
        this.luas = luas;
    }

    public int getJmlKamar() {
        return jmlKamar;
    }

    public void setJmlKamar(int jmlKamar) {
        this.jmlKamar = jmlKamar;
    }

    public int getDasarKomin() {
        return dasarKomin;
    }

    public void setDasarKomin(int dasarKomin) {
        this.dasarKomin = dasarKomin;
    }

    public Date getTanggalMulai() {
        return tanggalMulai;
    }

    public void setTanggalMulai(Date tanggalMulai) {
        this.tanggalMulai = tanggalMulai;
    }

    public Date getTanggalSelesai() {
        return tanggalSelesai;
    }

    public void setTanggalSelesai(Date tanggalSelesai) {
        this.tanggalSelesai = tanggalSelesai;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getTanggalInput() {
        return tanggalInput;
    }

    public void setTanggalInput(Date tanggalInput) {
        this.tanggalInput = tanggalInput;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public int getPenambahanKontrak() {
        return penambahanKontrak;
    }

    public void setPenambahanKontrak(int penambahanKontrak) {
        this.penambahanKontrak = penambahanKontrak;
    }

    public String getKeteranganAmandemen() {
        return keteranganAmandemen;
    }

    public void setKeteranganAmandemen(String keteranganAmandemen) {
        this.keteranganAmandemen = keteranganAmandemen;
    }
}
