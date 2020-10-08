
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class TabunganSukarela extends Entity { 

	private Date tanggal;
	private double jumlah;
	private int pengali;
	private int type;
	private String note = "";        
	private long userId;
	private Date transDate;
	private long periodId;
	private int postStatus;
	private double saldo;

        /**
         * Holds value of property sortNum.
         */
        private int sortNum;
        
        /**
         * Holds value of property memberId.
         */
        private long memberId;
        
        /**
         * Holds value of property debet.
         */
        private double debet;
        
        /**
         * Holds value of property credit.
         */
        private double credit;
        
        /**
         * Holds value of property counter.
         */
        private int counter;
        
        /**
         * Holds value of property cashBankCoaId.
         */
        private long cashBankCoaId;
        
        /**
         * Holds value of property number.
         */
        private String number;
        
	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
	} 

	public double getJumlah(){
            return jumlah;
        } 

	public void setJumlah(double jumlah){
            this.jumlah = jumlah;
        } 

	public int getPengali(){
            return pengali;
        } 

	public void setPengali(int pengali){
            this.pengali = pengali;
        } 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public String getNote(){ 
		return note; 
	} 

	public void setNote(String note){ 
		if ( note == null ) {
			note = ""; 
		} 
		this.note = note; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public Date getTransDate(){ 
		return transDate; 
	} 

	public void setTransDate(Date transDate){ 
		this.transDate = transDate; 
	} 

	public long getPeriodId(){ 
		return periodId; 
	} 

	public void setPeriodId(long periodId){ 
		this.periodId = periodId; 
	} 

	public int getPostStatus(){ 
		return postStatus; 
	} 

	public void setPostStatus(int postStatus){ 
		this.postStatus = postStatus; 
	} 

	public double getSaldo(){ 
		return saldo; 
	} 

	public void setSaldo(double saldo){ 
		this.saldo = saldo; 
	} 

        /**
         * Getter for property sortNum.
         * @return Value of property sortNum.
         */
        public int getSortNum() {
            return this.sortNum;
        }
        
        /**
         * Setter for property sortNum.
         * @param sortNum New value of property sortNum.
         */
        public void setSortNum(int sortNum) {
            this.sortNum = sortNum;
        }
        
        /**
         * Getter for property memberId.
         * @return Value of property memberId.
         */
        public long getMemberId() {
            return this.memberId;
        }
        
        /**
         * Setter for property memberId.
         * @param memberId New value of property memberId.
         */
        public void setMemberId(long memberId) {
            this.memberId = memberId;
        }
        
        /**
         * Getter for property debet.
         * @return Value of property debet.
         */
        public double getDebet() {
            return this.debet;
        }
        
        /**
         * Setter for property debet.
         * @param debet New value of property debet.
         */
        public void setDebet(double debet) {
            this.debet = debet;
        }
        
        /**
         * Getter for property credit.
         * @return Value of property credit.
         */
        public double getCredit() {
            return this.credit;
        }
        
        /**
         * Setter for property credit.
         * @param credit New value of property credit.
         */
        public void setCredit(double credit) {
            this.credit = credit;
        }
        
        /**
         * Getter for property counter.
         * @return Value of property counter.
         */
        public int getCounter() {
            return this.counter;
        }
        
        /**
         * Setter for property counter.
         * @param counter New value of property counter.
         */
        public void setCounter(int counter) {
            this.counter = counter;
        }
        
        /**
         * Getter for property cashBankCoaId.
         * @return Value of property cashBankCoaId.
         */
        public long getCashBankCoaId() {
            return this.cashBankCoaId;
        }
        
        /**
         * Setter for property cashBankCoaId.
         * @param cashBankCoaId New value of property cashBankCoaId.
         */
        public void setCashBankCoaId(long cashBankCoaId) {
            this.cashBankCoaId = cashBankCoaId;
        }
        
        /**
         * Getter for property number.
         * @return Value of property number.
         */
        public String getNumber() {
            return this.number;
        }
        
        /**
         * Setter for property number.
         * @param number New value of property number.
         */
        public void setNumber(String number) {
            this.number = number;
        }
        
}
