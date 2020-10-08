
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.simprop.property;

import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahIncomeProp extends Entity {

    private long sewaTanahInvoiceId;
    private long currencyId;
    private double jumlah;
    private int status;
    private String createdById = "";
    private Date postedDate;
    private Date tanggal;
    private int counter;
    private String prefixNumber = "";
    private String number = "";
    private long postedById;
    private String keterangan = "";
    private long glId;
    private int type;
    private Date tanggalInput;
    private long investorId;
    private long saranaId;

    public long getSewaTanahInvoiceId() {
        return sewaTanahInvoiceId;
    }

    public void setSewaTanahInvoiceId(long sewaTanahInvoiceId) {
        this.sewaTanahInvoiceId = sewaTanahInvoiceId;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public double getJumlah() {
        return jumlah;
    }

    public void setJumlah(double jumlah) {
        this.jumlah = jumlah;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCreatedById() {
        return createdById;
    }

    public void setCreatedById(String createdById) {
        if (createdById == null) {
            createdById = "";
        }
        this.createdById = createdById;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        if (prefixNumber == null) {
            prefixNumber = "";
        }
        this.prefixNumber = prefixNumber;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        if (number == null) {
            number = "";
        }
        this.number = number;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
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

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Date getTanggalInput() {
        return tanggalInput;
    }

    public void setTanggalInput(Date tanggalInput) {
        this.tanggalInput = tanggalInput;
    }

    public long getInvestorId() {
        return investorId;
    }

    public void setInvestorId(long investorId) {
        this.investorId = investorId;
    }

    public long getSaranaId() {
        return saranaId;
    }

    public void setSaranaId(long saranaId) {
        this.saranaId = saranaId;
    }
}
