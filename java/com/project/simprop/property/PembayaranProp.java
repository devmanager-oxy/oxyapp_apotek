
package com.project.simprop.property;
 
import java.util.Date;
import com.project.main.entity.*;

public class PembayaranProp extends Entity { 

	private int transactionSource;
	private int type;
	private String noBkm = "";
	private int counter;
	private String noKwitansi = "";
	private String noInvoice = "";
	private Date tanggalInvoice;
	private Date tanggal;
	private long mataUangId;
	private double exchangeRate;
	private long customerId;
	private long irigasiTransactionId;
	private long limbahTransactionId;
	private double jumlah;
	private long createById;
	private long postedById;
	private Date postedDate;
	private long periodId;
	private long glId;
	private int status;
	private long paymentAccountId;
	private long sewaTanahInvoiceId;
	private long sewaTanahBenefitId;
	private long dendaId;
        private double foreignAmount;
        private String memo = "";

	public long getDendaId(){ 
		return dendaId; 
	} 

	public void setDendaId(long dendaId){ 		 
		this.dendaId = dendaId; 
	}
	
	public long getSewaTanahBenefitId(){ 
		return sewaTanahBenefitId; 
	} 

	public void setSewaTanahBenefitId(long sewaTanahBenefitId){ 		 
		this.sewaTanahBenefitId = sewaTanahBenefitId; 
	}
	
	public long getSewaTanahInvoiceId(){ 
		return sewaTanahInvoiceId; 
	} 

	public void setSewaTanahInvoiceId(long sewaTanahInvoiceId){ 		 
		this.sewaTanahInvoiceId = sewaTanahInvoiceId; 
	}
	
	public int getTransactionSource(){ 
		return transactionSource; 
	} 

	public void setTransactionSource(int transactionSource){ 		 
		this.transactionSource = transactionSource; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public String getNoBkm(){ 
		return noBkm; 
	} 

	public void setNoBkm(String noBkm){ 
		if ( noBkm == null ) {
			noBkm = ""; 
		} 
		this.noBkm = noBkm; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public String getNoKwitansi(){ 
		return noKwitansi; 
	} 

	public void setNoKwitansi(String noKwitansi){ 
		if ( noKwitansi == null ) {
			noKwitansi = ""; 
		} 
		this.noKwitansi = noKwitansi; 
	} 

	public String getNoInvoice(){ 
		return noInvoice; 
	} 

	public void setNoInvoice(String noInvoice){ 
		if ( noInvoice == null ) {
			noInvoice = ""; 
		} 
		this.noInvoice = noInvoice; 
	} 

	public Date getTanggalInvoice(){ 
		return tanggalInvoice; 
	} 

	public void setTanggalInvoice(Date tanggalInvoice){ 
		this.tanggalInvoice = tanggalInvoice; 
	} 

	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
	} 

	public long getMataUangId(){ 
		return mataUangId; 
	} 

	public void setMataUangId(long mataUangId){ 
		this.mataUangId = mataUangId; 
	} 

	public double getExchangeRate(){ 
		return exchangeRate; 
	} 

	public void setExchangeRate(double exchangeRate){ 
		this.exchangeRate = exchangeRate; 
	} 

	public long getCustomerId(){ 
		return customerId; 
	} 

	public void setCustomerId(long customerId){ 
		this.customerId = customerId; 
	} 

	public long getIrigasiTransactionId(){ 
		return irigasiTransactionId; 
	} 

	public void setIrigasiTransactionId(long irigasiTransactionId){ 
		this.irigasiTransactionId = irigasiTransactionId; 
	} 

	public long getLimbahTransactionId(){ 
		return limbahTransactionId; 
	} 

	public void setLimbahTransactionId(long limbahTransactionId){ 
		this.limbahTransactionId = limbahTransactionId; 
	} 

	public double getJumlah(){ 
		return jumlah; 
	} 

	public void setJumlah(double jumlah){ 
		this.jumlah = jumlah; 
	} 

	public long getCreateById(){ 
		return createById; 
	} 

	public void setCreateById(long createById){ 
		this.createById = createById; 
	} 

	public long getPostedById(){ 
		return postedById; 
	} 

	public void setPostedById(long postedById){ 
		this.postedById = postedById; 
	} 

	public Date getPostedDate(){ 
		return postedDate; 
	} 

	public void setPostedDate(Date postedDate){ 
		this.postedDate = postedDate; 
	} 

	public long getPeriodId(){ 
		return periodId; 
	} 

	public void setPeriodId(long periodId){ 
		this.periodId = periodId; 
	} 

	public long getGlId(){ 
		return glId; 
	} 

	public void setGlId(long glId){ 
		this.glId = glId; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 
		
	public long getPaymentAccountId(){ 
		return paymentAccountId; 
	} 

	public void setPaymentAccountId(long paymentAccountId){ 
		this.paymentAccountId = paymentAccountId; 
	}

    public double getForeignAmount() {
        return foreignAmount;
    }

    public void setForeignAmount(double foreignAmount) {
        this.foreignAmount = foreignAmount;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

}
