
package com.project.simprop.property;

import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahBenefitProp extends Entity {

    private long sewaTanahId;
    private Date tanggal;
    private Date tanggalBenefit;
    private long investorId;
    private long saranaId;
    private int counter;
    private String prefixNumber = "";
    private String number = "";
    private String keterangan = "";
    private int status;
    private long createdById;
    private long approvedById;
    private long approvedByDate;
    private long sewaTanahInvoiceId;
    private double ppn;
    private double ppnPercent;
    private double pph;
    private double pphPercent;
    private double totalDenda;
    private int statusPembayaran;
    private long currencyId;
    private double totalKomper;
    private Date jatuhTempo;
    private String noFp = "";
    private double dendaDiakui;
    private long dendaApproveId;
    private Date dendaApproveDate;
    private String dendaKeterangan = "";
    private int dendaPostStatus;
    private String dendaClientName = "";
    private String dendaClientPosition = "";

    public String getNoFp() {
        return noFp;
    }

    public void setNoFp(String noFp) {
        this.noFp = noFp;
    }

    public Date getJatuhTempo() {
        return jatuhTempo;
    }

    public void setJatuhTempo(Date jatuhTempo) {
        this.jatuhTempo = jatuhTempo;
    }

    public double getTotalKomper() {
        return totalKomper;
    }

    public void setTotalKomper(double totalKomper) {
        this.totalKomper = totalKomper;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public int getStatusPembayaran() {
        return statusPembayaran;
    }

    public void setStatusPembayaran(int statusPembayaran) {
        this.statusPembayaran = statusPembayaran;
    }

    public double getTotalDenda() {
        return totalDenda;
    }

    public void setTotalDenda(double totalDenda) {
        this.totalDenda = totalDenda;
    }

    public double getPphPercent() {
        return pphPercent;
    }

    public void setPphPercent(double pphPercent) {
        this.pphPercent = pphPercent;
    }

    public double getPph() {
        return pph;
    }

    public void setPph(double pph) {
        this.pph = pph;
    }

    public double getPpnPercent() {
        return ppnPercent;
    }

    public void setPpnPercent(double ppnPercent) {
        this.ppnPercent = ppnPercent;
    }

    public double getPpn() {
        return ppn;
    }

    public void setPpn(double ppn) {
        this.ppn = ppn;
    }

    public long getSewaTanahInvoiceId() {
        return sewaTanahInvoiceId;
    }

    public void setSewaTanahInvoiceId(long sewaTanahInvoiceId) {
        this.sewaTanahInvoiceId = sewaTanahInvoiceId;
    }

    public long getSewaTanahId() {
        return sewaTanahId;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public Date getTanggalBenefit() {
        return tanggalBenefit;
    }

    public void setTanggalBenefit(Date tanggalBenefit) {
        this.tanggalBenefit = tanggalBenefit;
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

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        if (keterangan == null) {
            keterangan = "";
        }
        this.keterangan = keterangan;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getCreatedById() {
        return createdById;
    }

    public void setCreatedById(long createdById) {
        this.createdById = createdById;
    }

    public long getApprovedById() {
        return approvedById;
    }

    public void setApprovedById(long approvedById) {
        this.approvedById = approvedById;
    }

    public long getApprovedByDate() {
        return approvedByDate;
    }

    public void setApprovedByDate(long approvedByDate) {
        this.approvedByDate = approvedByDate;
    }

    public double getDendaDiakui() {
        return dendaDiakui;
    }

    public void setDendaDiakui(double dendaDiakui) {
        this.dendaDiakui = dendaDiakui;
    }

    public long getDendaApproveId() {
        return dendaApproveId;
    }

    public void setDendaApproveId(long dendaApproveId) {
        this.dendaApproveId = dendaApproveId;
    }

    public Date getDendaApproveDate() {
        return dendaApproveDate;
    }

    public void setDendaApproveDate(Date dendaApproveDate) {
        this.dendaApproveDate = dendaApproveDate;
    }

    public String getDendaKeterangan() {
        return dendaKeterangan;
    }

    public void setDendaKeterangan(String dendaKeterangan) {
        this.dendaKeterangan = dendaKeterangan;
    }

    public int getDendaPostStatus() {
        return dendaPostStatus;
    }

    public void setDendaPostStatus(int dendaPostStatus) {
        this.dendaPostStatus = dendaPostStatus;
    }

    public String getDendaClientName() {
        return dendaClientName;
    }

    public void setDendaClientName(String dendaClientName) {
        this.dendaClientName = dendaClientName;
    }

    public String getDendaClientPosition() {
        return dendaClientPosition;
    }

    public void setDendaClientPosition(String dendaClientPosition) {
        this.dendaClientPosition = dendaClientPosition;
    }
}
