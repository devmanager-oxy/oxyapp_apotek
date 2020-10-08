
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;


public class PinjamanDetail extends Entity { 

	private long memberId;
	private long pinjamanId;
	private double amount;
	private double bunga;
	private int cicilanKe;
	private Date jatuhTempo;
	private int status;

        /**
         * Holds value of property bungaBank.
         */
        private double bungaBank;
        
        /**
         * Holds value of property totalKoperasi.
         */
        private double totalKoperasi;
        
        /**
         * Holds value of property totalBank.
         */
        private double totalBank;
        
        /**
         * Holds value of property saldoBank.
         */
        private double saldoBank;
        
        /**
         * Holds value of property saldoKoperasi.
         */
        private double saldoKoperasi;
        
        /**
         * Holds value of property bungaBankPercent.
         */
        private double bungaBankPercent;
        
        /**
         * Holds value of property bungaKoperasiPercent.
         */
        private double bungaKoperasiPercent;
        
        /**
         * Holds value of property amountBank.
         */
        private double amountBank;
        
	public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		this.memberId = memberId; 
	} 

	public long getPinjamanId(){ 
		return pinjamanId; 
	} 

	public void setPinjamanId(long pinjamanId){ 
		this.pinjamanId = pinjamanId; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public double getBunga(){ 
		return bunga; 
	} 

	public void setBunga(double bunga){ 
		this.bunga = bunga; 
	} 

	public int getCicilanKe(){ 
		return cicilanKe; 
	} 

	public void setCicilanKe(int cicilanKe){ 
		this.cicilanKe = cicilanKe; 
	} 

	public Date getJatuhTempo(){ 
		return jatuhTempo; 
	} 

	public void setJatuhTempo(Date jatuhTempo){ 
		this.jatuhTempo = jatuhTempo; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

        /**
         * Getter for property bungaBank.
         * @return Value of property bungaBank.
         */
        public double getBungaBank() {
            return this.bungaBank;
        }
        
        /**
         * Setter for property bungaBank.
         * @param bungaBank New value of property bungaBank.
         */
        public void setBungaBank(double bungaBank) {
            this.bungaBank = bungaBank;
        }
        
        /**
         * Getter for property totalKoperasi.
         * @return Value of property totalKoperasi.
         */
        public double getTotalKoperasi() {
            return this.totalKoperasi;
        }
        
        /**
         * Setter for property totalKoperasi.
         * @param totalKoperasi New value of property totalKoperasi.
         */
        public void setTotalKoperasi(double totalKoperasi) {
            this.totalKoperasi = totalKoperasi;
        }
        
        /**
         * Getter for property totalBank.
         * @return Value of property totalBank.
         */
        public double getTotalBank() {
            return this.totalBank;
        }
        
        /**
         * Setter for property totalBank.
         * @param totalBank New value of property totalBank.
         */
        public void setTotalBank(double totalBank) {
            this.totalBank = totalBank;
        }
        
        /**
         * Getter for property saldoBank.
         * @return Value of property saldoBank.
         */
        public double getSaldoBank() {
            return this.saldoBank;
        }
        
        /**
         * Setter for property saldoBank.
         * @param saldoBank New value of property saldoBank.
         */
        public void setSaldoBank(double saldoBank) {
            this.saldoBank = saldoBank;
        }
        
        /**
         * Getter for property saldoKoperasi.
         * @return Value of property saldoKoperasi.
         */
        public double getSaldoKoperasi() {
            return this.saldoKoperasi;
        }
        
        /**
         * Setter for property saldoKoperasi.
         * @param saldoKoperasi New value of property saldoKoperasi.
         */
        public void setSaldoKoperasi(double saldoKoperasi) {
            this.saldoKoperasi = saldoKoperasi;
        }
        
        /**
         * Getter for property bungaBankPercent.
         * @return Value of property bungaBankPercent.
         */
        public double getBungaBankPercent() {
            return this.bungaBankPercent;
        }
        
        /**
         * Setter for property bungaBankPercent.
         * @param bungaBankPercent New value of property bungaBankPercent.
         */
        public void setBungaBankPercent(double bungaBankPercent) {
            this.bungaBankPercent = bungaBankPercent;
        }
        
        /**
         * Getter for property bungaKoperasiPercent.
         * @return Value of property bungaKoperasiPercent.
         */
        public double getBungaKoperasiPercent() {
            return this.bungaKoperasiPercent;
        }
        
        /**
         * Setter for property bungaKoperasiPercent.
         * @param bungaKoperasiPercent New value of property bungaKoperasiPercent.
         */
        public void setBungaKoperasiPercent(double bungaKoperasiPercent) {
            this.bungaKoperasiPercent = bungaKoperasiPercent;
        }
        
        /**
         * Getter for property amountBank.
         * @return Value of property amountBank.
         */
        public double getAmountBank() {
            return this.amountBank;
        }
        
        /**
         * Setter for property amountBank.
         * @param amountBank New value of property amountBank.
         */
        public void setAmountBank(double amountBank) {
            this.amountBank = amountBank;
        }
        
}
