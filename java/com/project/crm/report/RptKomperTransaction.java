package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class RptKomperTransaction {
    private long sewaTanahInvoiceId = 0;
    private String InvoiceNumber = "";
    private String NoFp = "";
    private double JumlahKomper = 0;
    private String CustomerName = "";
    private Date JatuhTempo = new Date();
    private double TotalDenda = 0;
    private String StatusPembayaran = "";
    private String CurrencyCode = "";

    public String getCurrencyCode() {
        return CurrencyCode;
    }

    public void setCurrencyCode(String CurrencyCode) {
        this.CurrencyCode = CurrencyCode;
    }

    public Date getJatuhTempo() {
        return JatuhTempo;
    }

    public void setJatuhTempo(Date JatuhTempo) {
        this.JatuhTempo = JatuhTempo;
    }

    public String getStatusPembayaran() {
        return StatusPembayaran;
    }

    public void setStatusPembayaran(String StatusPembayaran) {
        this.StatusPembayaran = StatusPembayaran;
    }

    public double getTotalDenda() {
        return TotalDenda;
    }

    public void setTotalDenda(double TotalDenda) {
        this.TotalDenda = TotalDenda;
    }

    public String getCustomerName() {
        return CustomerName;
    }

    public void setCustomerName(String CustomerName) {
        this.CustomerName = CustomerName;
    }

    public String getInvoiceNumber() {
        return InvoiceNumber;
    }

    public void setInvoiceNumber(String InvoiceNumber) {
        this.InvoiceNumber = InvoiceNumber;
    }

    public double getJumlahKomper() {
        return JumlahKomper;
    }

    public void setJumlahKomper(double JumlahKomper) {
        this.JumlahKomper = JumlahKomper;
    }

    public String getNoFp() {
        return NoFp;
    }

    public void setNoFp(String NoFp) {
        this.NoFp = NoFp;
    }

    public long getSewaTanahInvoiceId() {
        return sewaTanahInvoiceId;
    }

    public void setSewaTanahInvoiceId(long sewaTanahInvoiceId) {
        this.sewaTanahInvoiceId = sewaTanahInvoiceId;
    }

}
