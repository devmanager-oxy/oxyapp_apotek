
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class BayarPinjaman extends Entity { 

	private long memberId;
	private long pinjamanId;
	private long pinjamanDetailId;
	private Date tanggal;
	private double amount;
	private double bunga;
	private double denda;
	private int status;
	private int type;
	private int cicilanKe;
	private double pinalti;
	private String noTransaksi = "";
	private int counter;
	private String prefixNumber = "";

        /**
         * Holds value of property userId.
         */
        private long userId;
        
        /**
         * Holds value of property typePinjaman.
         */
        private int typePinjaman;
        
        /**
         * Holds value of property coaPokokDebetId.
         */
        private long coaPokokDebetId;
        
        /**
         * Holds value of property coaPokokCreditId.
         */
        private long coaPokokCreditId;
        
        /**
         * Holds value of property coaBungaDebetId.
         */
        private long coaBungaDebetId;
        
        /**
         * Holds value of property coaBungaCreditId.
         */
        private long coaBungaCreditId;
        
        /**
         * Holds value of property coaDendaDebetId.
         */
        private long coaDendaDebetId;
        
        /**
         * Holds value of property coaDendaCreditId.
         */
        private long coaDendaCreditId;
        
        /**
         * Holds value of property coaPinaltiDebetId.
         */
        private long coaPinaltiDebetId;
        
        /**
         * Holds value of property coaPinaltiCreditId.
         */
        private long coaPinaltiCreditId;
        
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

	public long getPinjamanDetailId(){ 
		return pinjamanDetailId; 
	} 

	public void setPinjamanDetailId(long pinjamanDetailId){ 
		this.pinjamanDetailId = pinjamanDetailId; 
	} 

	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
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

	public double getDenda(){ 
		return denda; 
	} 

	public void setDenda(double denda){ 
		this.denda = denda; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public int getCicilanKe(){ 
		return cicilanKe; 
	} 

	public void setCicilanKe(int cicilanKe){ 
		this.cicilanKe = cicilanKe; 
	} 

	public double getPinalti(){ 
		return pinalti; 
	} 

	public void setPinalti(double pinalti){ 
		this.pinalti = pinalti; 
	} 

	public String getNoTransaksi(){ 
		return noTransaksi; 
	} 

	public void setNoTransaksi(String noTransaksi){ 
		if ( noTransaksi == null ) {
			noTransaksi = ""; 
		} 
		this.noTransaksi = noTransaksi; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public String getPrefixNumber(){ 
		return prefixNumber; 
	} 

	public void setPrefixNumber(String prefixNumber){ 
		if ( prefixNumber == null ) {
			prefixNumber = ""; 
		} 
		this.prefixNumber = prefixNumber; 
	} 

        /**
         * Getter for property userId.
         * @return Value of property userId.
         */
        public long getUserId() {
            return this.userId;
        }
        
        /**
         * Setter for property userId.
         * @param userId New value of property userId.
         */
        public void setUserId(long userId) {
            this.userId = userId;
        }
        
        /**
         * Getter for property type_pinjaman.
         * @return Value of property type_pinjaman.
         */
        public int getTypePinjaman() {
            return this.typePinjaman;
        }
        
        /**
         * Setter for property type_pinjaman.
         * @param type_pinjaman New value of property type_pinjaman.
         */
        public void setTypePinjaman(int typePinjaman) {
            this.typePinjaman = typePinjaman;
        }
        
        /**
         * Getter for property coaPokokDebetId.
         * @return Value of property coaPokokDebetId.
         */
        public long getCoaPokokDebetId() {
            return this.coaPokokDebetId;
        }
        
        /**
         * Setter for property coaPokokDebetId.
         * @param coaPokokDebetId New value of property coaPokokDebetId.
         */
        public void setCoaPokokDebetId(long coaPokokDebetId) {
            this.coaPokokDebetId = coaPokokDebetId;
        }
        
        /**
         * Getter for property coaPokokCreditId.
         * @return Value of property coaPokokCreditId.
         */
        public long getCoaPokokCreditId() {
            return this.coaPokokCreditId;
        }
        
        /**
         * Setter for property coaPokokCreditId.
         * @param coaPokokCreditId New value of property coaPokokCreditId.
         */
        public void setCoaPokokCreditId(long coaPokokCreditId) {
            this.coaPokokCreditId = coaPokokCreditId;
        }
        
        /**
         * Getter for property coaBungaDebetId.
         * @return Value of property coaBungaDebetId.
         */
        public long getCoaBungaDebetId() {
            return this.coaBungaDebetId;
        }
        
        /**
         * Setter for property coaBungaDebetId.
         * @param coaBungaDebetId New value of property coaBungaDebetId.
         */
        public void setCoaBungaDebetId(long coaBungaDebetId) {
            this.coaBungaDebetId = coaBungaDebetId;
        }
        
        /**
         * Getter for property coaBungaCreditId.
         * @return Value of property coaBungaCreditId.
         */
        public long getCoaBungaCreditId() {
            return this.coaBungaCreditId;
        }
        
        /**
         * Setter for property coaBungaCreditId.
         * @param coaBungaCreditId New value of property coaBungaCreditId.
         */
        public void setCoaBungaCreditId(long coaBungaCreditId) {
            this.coaBungaCreditId = coaBungaCreditId;
        }
        
        /**
         * Getter for property coaDendaDebetId.
         * @return Value of property coaDendaDebetId.
         */
        public long getCoaDendaDebetId() {
            return this.coaDendaDebetId;
        }
        
        /**
         * Setter for property coaDendaDebetId.
         * @param coaDendaDebetId New value of property coaDendaDebetId.
         */
        public void setCoaDendaDebetId(long coaDendaDebetId) {
            this.coaDendaDebetId = coaDendaDebetId;
        }
        
        /**
         * Getter for property coaDendaCreditId.
         * @return Value of property coaDendaCreditId.
         */
        public long getCoaDendaCreditId() {
            return this.coaDendaCreditId;
        }
        
        /**
         * Setter for property coaDendaCreditId.
         * @param coaDendaCreditId New value of property coaDendaCreditId.
         */
        public void setCoaDendaCreditId(long coaDendaCreditId) {
            this.coaDendaCreditId = coaDendaCreditId;
        }
        
        /**
         * Getter for property coaPinaltiDebetId.
         * @return Value of property coaPinaltiDebetId.
         */
        public long getCoaPinaltiDebetId() {
            return this.coaPinaltiDebetId;
        }
        
        /**
         * Setter for property coaPinaltiDebetId.
         * @param coaPinaltiDebetId New value of property coaPinaltiDebetId.
         */
        public void setCoaPinaltiDebetId(long coaPinaltiDebetId) {
            this.coaPinaltiDebetId = coaPinaltiDebetId;
        }
        
        /**
         * Getter for property coaPinaltiCreditId.
         * @return Value of property coaPinaltiCreditId.
         */
        public long getCoaPinaltiCreditId() {
            return this.coaPinaltiCreditId;
        }
        
        /**
         * Setter for property coaPinaltiCreditId.
         * @param coaPinaltiCreditId New value of property coaPinaltiCreditId.
         */
        public void setCoaPinaltiCreditId(long coaPinaltiCreditId) {
            this.coaPinaltiCreditId = coaPinaltiCreditId;
        }
        
}
