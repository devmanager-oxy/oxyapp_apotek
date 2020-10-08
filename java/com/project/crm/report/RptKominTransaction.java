package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class RptKominTransaction {
    private long sewaTanahInvoiceId = 0;
    private String InvoiceNumber = "";
    private String NoFp = "";
    private double JumlahKomin = 0;
    private String CustomerName = "";
    private Date JatuhTempo = new Date();
    private double TotalDenda = 0;
    private String StatusPembayaran = "";
    private String CurrencyCode = "";
    private double DendaDiakui = 0;
    private long DendaApproveId = 0;
    private Date DendaApproveDate = new Date();
    private String DendaKeterangan = "";
    private String DendaClientName = "";
    private String DendaClientPosition = "";

    public Date getDendaApproveDate() {
        return DendaApproveDate;
    }

    public void setDendaApproveDate(Date DendaApproveDate) {
        this.DendaApproveDate = DendaApproveDate;
    }

    public long getDendaApproveId() {
        return DendaApproveId;
    }

    public void setDendaApproveId(long DendaApproveId) {
        this.DendaApproveId = DendaApproveId;
    }

    public String getDendaClientName() {
        return DendaClientName;
    }

    public void setDendaClientName(String DendaClientName) {
        this.DendaClientName = DendaClientName;
    }

    public String getDendaClientPosition() {
        return DendaClientPosition;
    }

    public void setDendaClientPosition(String DendaClientPosition) {
        this.DendaClientPosition = DendaClientPosition;
    }

    public double getDendaDiakui() {
        return DendaDiakui;
    }

    public void setDendaDiakui(double DendaDiakui) {
        this.DendaDiakui = DendaDiakui;
    }

    public String getDendaKeterangan() {
        return DendaKeterangan;
    }

    public void setDendaKeterangan(String DendaKeterangan) {
        this.DendaKeterangan = DendaKeterangan;
    }

    public String getCurrencyCode() {
        return CurrencyCode;
    }

    public void setCurrencyCode(String CurrencyCode) {
        this.CurrencyCode = CurrencyCode;
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

    public Date getJatuhTempo() {
        return JatuhTempo;
    }

    public void setJatuhTempo(Date JatuhTempo) {
        this.JatuhTempo = JatuhTempo;
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

    public double getJumlahKomin() {
        return JumlahKomin;
    }

    public void setJumlahKomin(double JumlahKomin) {
        this.JumlahKomin = JumlahKomin;
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
