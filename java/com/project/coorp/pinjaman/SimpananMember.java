
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class SimpananMember extends Entity { 

	private long memberId;
	private double pokok;
	private double wajib;
	private double sukarelaShu;
	private double sukarelaTabungan;
	private double potonganPinjaman;
	private double total;
	private Date tanggal;
	private String keterangan = "";
	private long userId;
	private int status;
	private int counter;
	private String prefixNumber = "";
	private String number = "";

        /**
         * Holds value of property simpananCoaDebetId.
         */
        private long simpananCoaDebetId;
        
        /**
         * Holds value of property simpananCoaCreditId.
         */
        private long simpananCoaCreditId;
        
        /**
         * Holds value of property type.
         */
        private int type;
        
        /**
         * Holds value of property simpananCoaPokokId.
         */
        private long simpananCoaPokokId;
        
        /**
         * Holds value of property simpananCoaSukarelaId.
         */
        private long simpananCoaSukarelaId;
        
        /**
         * Holds value of property simpananCoaShuId.
         */
        private long simpananCoaShuId;
        
        /**
         * Holds value of property simpananCoaDebetNSPId.
         */
        private long simpananCoaDebetNSPId;
        
        /**
         * Holds value of property simpananCoaWajibId.
         */
        private long simpananCoaWajibId;
        
	public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		this.memberId = memberId; 
	} 

	public double getPokok(){ 
		return pokok; 
	} 

	public void setPokok(double pokok){ 
		this.pokok = pokok; 
	} 

	public double getWajib(){ 
		return wajib; 
	} 

	public void setWajib(double wajib){ 
		this.wajib = wajib; 
	} 

	public double getSukarelaShu(){ 
		return sukarelaShu; 
	} 

	public void setSukarelaShu(double sukarelaShu){ 
		this.sukarelaShu = sukarelaShu; 
	} 

	public double getSukarelaTabungan(){ 
		return sukarelaTabungan; 
	} 

	public void setSukarelaTabungan(double sukarelaTabungan){ 
		this.sukarelaTabungan = sukarelaTabungan; 
	} 

	public double getPotonganPinjaman(){ 
		return potonganPinjaman; 
	} 

	public void setPotonganPinjaman(double potonganPinjaman){ 
		this.potonganPinjaman = potonganPinjaman; 
	} 

	public double getTotal(){ 
		return total; 
	} 

	public void setTotal(double total){ 
		this.total = total; 
	} 

	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
	} 

	public String getKeterangan(){ 
		return keterangan; 
	} 

	public void setKeterangan(String keterangan){ 
		if ( keterangan == null ) {
			keterangan = ""; 
		} 
		this.keterangan = keterangan; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
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

	public String getNumber(){ 
		return number; 
	} 

	public void setNumber(String number){ 
		if ( number == null ) {
			number = ""; 
		} 
		this.number = number; 
	} 

        /**
         * Getter for property simpananCoaDebetId.
         * @return Value of property simpananCoaDebetId.
         */
        public long getSimpananCoaDebetId() {
            return this.simpananCoaDebetId;
        }
        
        /**
         * Setter for property simpananCoaDebetId.
         * @param simpananCoaDebetId New value of property simpananCoaDebetId.
         */
        public void setSimpananCoaDebetId(long simpananCoaDebetId) {
            this.simpananCoaDebetId = simpananCoaDebetId;
        }
        
        /**
         * Getter for property simpananCoaCreditId.
         * @return Value of property simpananCoaCreditId.
         */
        public long getSimpananCoaCreditId() {
            return this.simpananCoaCreditId;
        }    
        
        /**
         * Setter for property simpananCoaCreditId.
         * @param simpananCoaCreditId New value of property simpananCoaCreditId.
         */
        public void setSimpananCoaCreditId(long simpananCoaCreditId) {
            this.simpananCoaCreditId = simpananCoaCreditId;
        }
        
        /**
         * Getter for property type.
         * @return Value of property type.
         */
        public int getType() {
            return this.type;
        }
        
        /**
         * Setter for property type.
         * @param type New value of property type.
         */
        public void setType(int type) {
            this.type = type;
        }
        
        /**
         * Getter for property simpananCoaPokokId.
         * @return Value of property simpananCoaPokokId.
         */
        public long getSimpananCoaPokokId() {
            return this.simpananCoaPokokId;
        }
        
        /**
         * Setter for property simpananCoaPokokId.
         * @param simpananCoaPokokId New value of property simpananCoaPokokId.
         */
        public void setSimpananCoaPokokId(long simpananCoaPokokId) {
            this.simpananCoaPokokId = simpananCoaPokokId;
        }
        
        /**
         * Getter for property simpananCoaSukarelaId.
         * @return Value of property simpananCoaSukarelaId.
         */
        public long getSimpananCoaSukarelaId() {
            return this.simpananCoaSukarelaId;
        }
        
        /**
         * Setter for property simpananCoaSukarelaId.
         * @param simpananCoaSukarelaId New value of property simpananCoaSukarelaId.
         */
        public void setSimpananCoaSukarelaId(long simpananCoaSukarelaId) {
            this.simpananCoaSukarelaId = simpananCoaSukarelaId;
        }
        
        /**
         * Getter for property simpananCoaShuId.
         * @return Value of property simpananCoaShuId.
         */
        public long getSimpananCoaShuId() {
            return this.simpananCoaShuId;
        }
        
        /**
         * Setter for property simpananCoaShuId.
         * @param simpananCoaShuId New value of property simpananCoaShuId.
         */
        public void setSimpananCoaShuId(long simpananCoaShuId) {
            this.simpananCoaShuId = simpananCoaShuId;
        }
        
        /**
         * Getter for property simpananCoaDebetSpId.
         * @return Value of property simpananCoaDebetSpId.
         */
        public long getSimpananCoaDebetNSPId() {
            return this.simpananCoaDebetNSPId;
        }
        
        /**
         * Setter for property simpananCoaDebetSpId.
         * @param simpananCoaDebetSpId New value of property simpananCoaDebetSpId.
         */
        public void setSimpananCoaDebetNSPId(long simpananCoaDebetNSPId) {
            this.simpananCoaDebetNSPId = simpananCoaDebetNSPId;
        }
        
        /**
         * Getter for property simpananCoaWajibId.
         * @return Value of property simpananCoaWajibId.
         */
        public long getSimpananCoaWajibId() {
            return this.simpananCoaWajibId;
        }
        
        /**
         * Setter for property simpananCoaWajibId.
         * @param simpananCoaWajibId New value of property simpananCoaWajibId.
         */
        public void setSimpananCoaWajibId(long simpananCoaWajibId) {
            this.simpananCoaWajibId = simpananCoaWajibId;
        }
        
}
