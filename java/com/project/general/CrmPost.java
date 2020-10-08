/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 * @author  Roy Andika
 */

public class CrmPost extends Entity{
    
    private long referensiId;
    private int journalCounter;
    private String journalNumber = "";
    private String journalPrefix = "";
    private int type;    // INVOICE, etc    
    private long refPembayaranId;
    private Date dateTransaction;   // tanggal transaksi
    private long currencyId;    
    private long postedById;    
    private long periodeId;
    private Date date;    // tanggal input
    private String memo = "";
    private double BookedRate ; // or exchange rate
    private long foreignCurrencyId; // or BookingCurrencyId
    private double foreignAmount; // or jumlah
    private long paymentAccountId;
    private double amount;   
    private long limbahDebetAccountId;
    private long irigasiDebetAccountId;
    private long kominDebetAccountId;
    private long assesmentDebetAccountId;
    private long komperDebetAccountId;
    private long pendapatanTerimaDiMukaAccountId;
    
    private long limbahTransactionId;
    private long irigasiTransactionId;    
    private long sewaTanahInvoiceId;
    private long sewaTanahBenefitId;    
    private boolean statusPembayaran;  // if true pembayaran lunas, if false pembayaran belum lunas    
    private int transactionSource;
    
    private double totPembayaran = 0;
    private double totHarusDibayar = 0;
    private long departmentId;
    private long saranaId;
    

    public Date getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(Date dateTransaction){
        this.dateTransaction = dateTransaction;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public double getAmount(){
        return amount;
    }

    public void setAmount(double amount){
        this.amount = amount;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date){
        this.date = date;
    }

    public int getJournalCounter() {
        return journalCounter;
    }

    public void setJournalCounter(int journalCounter) {
        this.journalCounter = journalCounter;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public String getJournalPrefix() {
        return journalPrefix;
    }

    public void setJournalPrefix(String journaPrefix) {
        this.journalPrefix = journaPrefix;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public long getRefPembayaranId() {
        return refPembayaranId;
    }

    public void setRefPembayaranId(long refPembayaranId) {
        this.refPembayaranId = refPembayaranId;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public double getBookedRate() {
        return BookedRate;
    }

    public void setBookedRate(double BookedRate) {
        this.BookedRate = BookedRate;
    }

    public long getPaymentAccountId() {
        return paymentAccountId;
    }

    public void setPaymentAccountId(long paymentAccountId) {
        this.paymentAccountId = paymentAccountId;
    }

    public long getLimbahDebetAccountId() {
        return limbahDebetAccountId;
    }

    public void setLimbahDebetAccountId(long limbahDebetAccountId) {
        this.limbahDebetAccountId = limbahDebetAccountId;
    }

    public long getPendapatanTerimaDiMukaAccountId() {
        return pendapatanTerimaDiMukaAccountId;
    }

    public void setPendapatanTerimaDiMukaAccountId(long pendapatanTerimaDiMukaAccountId) {
        this.pendapatanTerimaDiMukaAccountId = pendapatanTerimaDiMukaAccountId;
    }

    public long getForeignCurrencyId() {
        return foreignCurrencyId;
    }

    public void setForeignCurrencyId(long foreignCurrencyId) {
        this.foreignCurrencyId = foreignCurrencyId;
    }

    public double getForeignAmount() {
        return foreignAmount;
    }

    public void setForeignAmount(double foreignAmount) {
        this.foreignAmount = foreignAmount;
    }

    public long getReferensiId() {
        return referensiId;
    }

    public void setReferensiId(long referensiId) {
        this.referensiId = referensiId;
    }

    public int getTransactionSource() {
        return transactionSource;
    }

    public void setTransactionSource(int transactionSource) {
        this.transactionSource = transactionSource;
    }

    public long getLimbahTransactionId() {
        return limbahTransactionId;
    }

    public void setLimbahTransactionId(long limbahTransactionId) {
        this.limbahTransactionId = limbahTransactionId;
    }

    public long getIrigasiTransactionId() {
        return irigasiTransactionId;
    }

    public void setIrigasiTransactionId(long irigasiTransactionId) {
        this.irigasiTransactionId = irigasiTransactionId;
    }

    public long getSewaTanahInvoiceId() {
        return sewaTanahInvoiceId;
    }

    public void setSewaTanahInvoiceId(long sewaTanahInvoiceId) {
        this.sewaTanahInvoiceId = sewaTanahInvoiceId;
    }

    public long getSewaTanahBenefitId() {
        return sewaTanahBenefitId;
    }

    public void setSewaTanahBenefitId(long sewaTanahBenefitId) {
        this.sewaTanahBenefitId = sewaTanahBenefitId;
    }

    public boolean isStatusPembayaran() {
        return statusPembayaran;
    }

    public void setStatusPembayaran(boolean statusPembayaran) {
        this.statusPembayaran = statusPembayaran;
    }

    public double getTotPembayaran() {
        return totPembayaran;
    }

    public void setTotPembayaran(double totPembayaran) {
        this.totPembayaran = totPembayaran;
    }

    public double getTotHarusDibayar() {
        return totHarusDibayar;
    }

    public void setTotHarusDibayar(double totHarusDibayar) {
        this.totHarusDibayar = totHarusDibayar;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getIrigasiDebetAccountId() {
        return irigasiDebetAccountId;
    }

    public void setIrigasiDebetAccountId(long irigasiDebetAccountId) {
        this.irigasiDebetAccountId = irigasiDebetAccountId;
    }

    public long getKominDebetAccountId() {
        return kominDebetAccountId;
    }

    public void setKominDebetAccountId(long kominDebetAccountId) {
        this.kominDebetAccountId = kominDebetAccountId;
    }

    public long getAssesmentDebetAccountId() {
        return assesmentDebetAccountId;
    }

    public void setAssesmentDebetAccountId(long assesmentDebetAccountId) {
        this.assesmentDebetAccountId = assesmentDebetAccountId;
    }

    public long getKomperDebetAccountId() {
        return komperDebetAccountId;
    }

    public void setKomperDebetAccountId(long komperDebetAccountId) {
        this.komperDebetAccountId = komperDebetAccountId;
    }

    public long getSaranaId() {
        return saranaId;
    }

    public void setSaranaId(long saranaId) {
        this.saranaId = saranaId;
    }
}
