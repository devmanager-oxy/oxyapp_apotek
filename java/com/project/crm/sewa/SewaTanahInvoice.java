
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.crm.sewa;

import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahInvoice extends Entity {

    private Date tanggal;
    private long investorId;
    private long saranaId;
    private long currencyId;
    private double jumlah;
    private String keterangan = "";
    private Date jatuhTempo;
    private long sewaTanahId;
    private long userId;
    private int status;
    private Date tanggalInput;
    private int counter;
    private String prefixNumber = "";
    private String number = "";
    private int type;
    private long masaInvoiceId;
    private int jmlBulan;
    private String noFp = "";
    private double totalDenda;
    private double ppnPersen;
    private double ppn;
    private double pphPersen;
    private double pph;
    private int statusPembayaran;
    private double dendaDiakui;
    private long dendaApproveId;
    private Date dendaApproveDate;
    private String dendaKeterangan;
    private int dendaPostStatus;
    private String dendaClientName;
    private String dendaClientPosition;
    private int paymentType;
    private long salesDataId;
    private long paymentSimulationId;
    private int stsPrintXls;
    private int stsPrintPdf;
    
    private long createId;
    private long approveId;
    private Date createDate;
    private Date approveDate;

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

    public int getDendaPostStatus() {
        return dendaPostStatus;
    }

    public void setDendaPostStatus(int dendaPostStatus) {
        this.dendaPostStatus = dendaPostStatus;
    }

    public Date getDendaApproveDate() {
        return dendaApproveDate;
    }

    public void setDendaApproveDate(Date dendaApproveDate) {
        this.dendaApproveDate = dendaApproveDate;
    }

    public long getDendaApproveId() {
        return dendaApproveId;
    }

    public void setDendaApproveId(long dendaApproveId) {
        this.dendaApproveId = dendaApproveId;
    }

    public double getDendaDiakui() {
        return dendaDiakui;
    }

    public void setDendaDiakui(double dendaDiakui) {
        this.dendaDiakui = dendaDiakui;
    }

    public String getDendaKeterangan() {
        return dendaKeterangan;
    }

    public void setDendaKeterangan(String dendaKeterangan) {
        this.dendaKeterangan = dendaKeterangan;
    }

    public int getStatusPembayaran() {
        return statusPembayaran;
    }

    public void setStatusPembayaran(int statusPembayaran) {
        this.statusPembayaran = statusPembayaran;
    }

    public double getPph() {
        return pph;
    }

    public void setPph(double pph) {
        this.pph = pph;
    }

    public double getPphPersen() {
        return pphPersen;
    }

    public void setPphPersen(double pphPersen) {
        this.pphPersen = pphPersen;
    }

    public double getPpn() {
        return ppn;
    }

    public void setPpn(double ppn) {
        this.ppn = ppn;
    }

    public double getPpnPersen() {
        return ppnPersen;
    }

    public void setPpnPersen(double ppnPersen) {
        this.ppnPersen = ppnPersen;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
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

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        if (keterangan == null) {
            keterangan = "";
        }
        this.keterangan = keterangan;
    }

    public Date getJatuhTempo() {
        return jatuhTempo;
    }

    public void setJatuhTempo(Date jatuhTempo) {
        this.jatuhTempo = jatuhTempo;
    }

    public long getSewaTanahId() {
        return sewaTanahId;
    }

    public void setSewaTanahId(long sewaTanahId) {
        this.sewaTanahId = sewaTanahId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
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

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getMasaInvoiceId() {
        return masaInvoiceId;
    }

    public void setMasaInvoiceId(long masaInvoiceId) {
        this.masaInvoiceId = masaInvoiceId;
    }

    public int getJmlBulan() {
        return jmlBulan;
    }

    public void setJmlBulan(int jmlBulan) {
        this.jmlBulan = jmlBulan;
    }

    public String getNoFp() {
        return noFp;
    }

    public void setNoFp(String noFp) {
        if (noFp == null) {
            noFp = "";
        }
        this.noFp = noFp;
    }

    public double getTotalDenda() {
        return totalDenda;
    }

    public void setTotalDenda(double totalDenda) {
        this.totalDenda = totalDenda;
    }

    public int getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(int paymentType) {
        this.paymentType = paymentType;
    }

    public long getSalesDataId() {
        return salesDataId;
    }

    public void setSalesDataId(long salesDataId) {
        this.salesDataId = salesDataId;
    }

    public long getPaymentSimulationId() {
        return paymentSimulationId;
    }

    public void setPaymentSimulationId(long paymentSimulationId) {
        this.paymentSimulationId = paymentSimulationId;
    }

    public int getStsPrintXls() {
        return stsPrintXls;
    }

    public void setStsPrintXls(int stsPrintXls) {
        this.stsPrintXls = stsPrintXls;
    }

    public int getStsPrintPdf() {
        return stsPrintPdf;
    }

    public void setStsPrintPdf(int stsPrintPdf) {
        this.stsPrintPdf = stsPrintPdf;
    }

    public long getCreateId() {
        return createId;
    }

    public void setCreateId(long createId) {
        this.createId = createId;
    }

    public long getApproveId() {
        return approveId;
    }

    public void setApproveId(long approveId) {
        this.approveId = approveId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getApproveDate() {
        return approveDate;
    }

    public void setApproveDate(Date approveDate) {
        this.approveDate = approveDate;
    }
}
