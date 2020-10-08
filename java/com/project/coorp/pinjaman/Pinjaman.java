
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;


public class Pinjaman extends Entity { 

	private long memberId;
	private int counter;
	private String prefixNumber = "";
	private String number = "";
	private Date date;
	private String note = "";
	private double totalPinjaman;
	private double bunga;
	private int status;
	private long userId;
	private double biayaAdministrasi;
	private int jenisBarang;
	private String detailJenisBarang = "";
	private int lamaCicilan;
	private int type;
	private long bankId;

        /**
         * Holds value of property tanggalJatuhTempo.
         */
        private int tanggalJatuhTempo;
        
        /**
         * Holds value of property approveById.
         */
        private long approveById;
        
        /**
         * Holds value of property approveDate.
         */
        private Date approveDate;
        
        /**
         * Holds value of property bungaBank.
         */
        private double bungaBank;
        
        /**
         * Holds value of property provisi.
         */
        private double provisi;
        
        /**
         * Holds value of property asuransi.
         */
        private double asuransi;
        
        /**
         * Holds value of property cicilan.
         */
        private double cicilan;
        
        /**
         * Holds value of property jenisCicilan.
         */
        private int jenisCicilan;
        
        /**
         * Holds value of property coaArDebetId.
         */
        private long coaArDebetId;
        
        /**
         * Holds value of property coaArCreditId.
         */
        private long coaArCreditId;
        
        /**
         * Holds value of property coaAdminDebetId.
         */
        private long coaAdminDebetId;
        
        /**
         * Holds value of property coaAdminCreditId.
         */
        private long coaAdminCreditId;
        
        /**
         * Holds value of property coaProvisiDebetId.
         */
        private long coaProvisiDebetId;
        
        /**
         * Holds value of property coaProvisiCreditId.
         */
        private long coaProvisiCreditId;
        
        /**
         * Holds value of property coaAsuransiDebetId.
         */
        private long coaAsuransiDebetId;
        
        /**
         * Holds value of property coaAsuransiCreditId.
         */
        private long coaAsuransiCreditId;
        
        /**
         * Holds value of property coaTitipanDebetId.
         */
        private long coaTitipanDebetId;
        
        /**
         * Holds value of property coaTitipanCreditId.
         */
        private long coaTitipanCreditId;
        
        /**
         * Holds value of property angsuranTerakhir.
         */
        private int angsuranTerakhir;
        
	public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		this.memberId = memberId; 
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

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
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

	public double getTotalPinjaman(){ 
		return totalPinjaman; 
	} 

	public void setTotalPinjaman(double totalPinjaman){ 
		this.totalPinjaman = totalPinjaman; 
	} 

	public double getBunga(){ 
		return bunga; 
	} 

	public void setBunga(double bunga){ 
		this.bunga = bunga; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public double getBiayaAdministrasi(){ 
		return biayaAdministrasi; 
	} 

	public void setBiayaAdministrasi(double biayaAdministrasi){ 
		this.biayaAdministrasi = biayaAdministrasi; 
	} 

	public int getJenisBarang(){ 
		return jenisBarang; 
	} 

	public void setJenisBarang(int jenisBarang){ 
		this.jenisBarang = jenisBarang; 
	} 

	public String getDetailJenisBarang(){ 
		return detailJenisBarang; 
	} 

	public void setDetailJenisBarang(String detailJenisBarang){ 
		if ( detailJenisBarang == null ) {
			detailJenisBarang = ""; 
		} 
		this.detailJenisBarang = detailJenisBarang; 
	} 

	public int getLamaCicilan(){ 
		return lamaCicilan; 
	} 

	public void setLamaCicilan(int lamaCicilan){ 
		this.lamaCicilan = lamaCicilan; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public long getBankId(){ 
		return bankId; 
	} 

	public void setBankId(long bankId){ 
		this.bankId = bankId; 
	} 

        /**
         * Getter for property tanggalJatuhTempo.
         * @return Value of property tanggalJatuhTempo.
         */
        public int getTanggalJatuhTempo() {
            return this.tanggalJatuhTempo;
        }
        
        /**
         * Setter for property tanggalJatuhTempo.
         * @param tanggalJatuhTempo New value of property tanggalJatuhTempo.
         */
        public void setTanggalJatuhTempo(int tanggalJatuhTempo) {
            this.tanggalJatuhTempo = tanggalJatuhTempo;
        }
        
        /**
         * Getter for property approved_by.
         * @return Value of property approved_by.
         */
        public long getApproveById() {
            return this.approveById;
        }
        
        /**
         * Setter for property approved_by.
         * @param approved_by New value of property approved_by.
         */
        public void setApproveById(long approveById) {
            this.approveById = approveById;
        }
        
        /**
         * Getter for property approveDate.
         * @return Value of property approveDate.
         */
        public Date getApproveDate() {
            return this.approveDate;
        }
        
        /**
         * Setter for property approveDate.
         * @param approveDate New value of property approveDate.
         */
        public void setApproveDate(Date approveDate) {
            this.approveDate = approveDate;
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
         * Getter for property provisi.
         * @return Value of property provisi.
         */
        public double getProvisi() {
            return this.provisi;
        }
        
        /**
         * Setter for property provisi.
         * @param provisi New value of property provisi.
         */
        public void setProvisi(double provisi) {
            this.provisi = provisi;
        }
        
        /**
         * Getter for property asuransi.
         * @return Value of property asuransi.
         */
        public double getAsuransi() {
            return this.asuransi;
        }
        
        /**
         * Setter for property asuransi.
         * @param asuransi New value of property asuransi.
         */
        public void setAsuransi(double asuransi) {
            this.asuransi = asuransi;
        }
        
        /**
         * Getter for property cicilan.
         * @return Value of property cicilan.
         */
        public double getCicilan() {
            return this.cicilan;
        }
        
        /**
         * Setter for property cicilan.
         * @param cicilan New value of property cicilan.
         */
        public void setCicilan(double cicilan) {
            this.cicilan = cicilan;
        }
        
        /**
         * Getter for property jenisCicilan.
         * @return Value of property jenisCicilan.
         */
        public int getJenisCicilan() {
            return this.jenisCicilan;
        }
        
        /**
         * Setter for property jenisCicilan.
         * @param jenisCicilan New value of property jenisCicilan.
         */
        public void setJenisCicilan(int jenisCicilan) {
            this.jenisCicilan = jenisCicilan;
        }
        
        /**
         * Getter for property coaArDebetId.
         * @return Value of property coaArDebetId.
         */
        public long getCoaArDebetId() {
            return this.coaArDebetId;
        }
        
        /**
         * Setter for property coaArDebetId.
         * @param coaArDebetId New value of property coaArDebetId.
         */
        public void setCoaArDebetId(long coaArDebetId) {
            this.coaArDebetId = coaArDebetId;
        }
        
        /**
         * Getter for property coaArCreditId.
         * @return Value of property coaArCreditId.
         */
        public long getCoaArCreditId() {
            return this.coaArCreditId;
        }
        
        /**
         * Setter for property coaArCreditId.
         * @param coaArCreditId New value of property coaArCreditId.
         */
        public void setCoaArCreditId(long coaArCreditId) {
            this.coaArCreditId = coaArCreditId;
        }
        
        /**
         * Getter for property coaAdminDebetId.
         * @return Value of property coaAdminDebetId.
         */
        public long getCoaAdminDebetId() {
            return this.coaAdminDebetId;
        }
        
        /**
         * Setter for property coaAdminDebetId.
         * @param coaAdminDebetId New value of property coaAdminDebetId.
         */
        public void setCoaAdminDebetId(long coaAdminDebetId) {
            this.coaAdminDebetId = coaAdminDebetId;
        }
        
        /**
         * Getter for property coaAdminCreditId.
         * @return Value of property coaAdminCreditId.
         */
        public long getCoaAdminCreditId() {
            return this.coaAdminCreditId;
        }
        
        /**
         * Setter for property coaAdminCreditId.
         * @param coaAdminCreditId New value of property coaAdminCreditId.
         */
        public void setCoaAdminCreditId(long coaAdminCreditId) {
            this.coaAdminCreditId = coaAdminCreditId;
        }
        
        /**
         * Getter for property coaProvisiDebetId.
         * @return Value of property coaProvisiDebetId.
         */
        public long getCoaProvisiDebetId() {
            return this.coaProvisiDebetId;
        }
        
        /**
         * Setter for property coaProvisiDebetId.
         * @param coaProvisiDebetId New value of property coaProvisiDebetId.
         */
        public void setCoaProvisiDebetId(long coaProvisiDebetId) {
            this.coaProvisiDebetId = coaProvisiDebetId;
        }
        
        /**
         * Getter for property coaProvisiCreditId.
         * @return Value of property coaProvisiCreditId.
         */
        public long getCoaProvisiCreditId() {
            return this.coaProvisiCreditId;
        }
        
        /**
         * Setter for property coaProvisiCreditId.
         * @param coaProvisiCreditId New value of property coaProvisiCreditId.
         */
        public void setCoaProvisiCreditId(long coaProvisiCreditId) {
            this.coaProvisiCreditId = coaProvisiCreditId;
        }
        
        /**
         * Getter for property coaAsuransiDebetId.
         * @return Value of property coaAsuransiDebetId.
         */
        public long getCoaAsuransiDebetId() {
            return this.coaAsuransiDebetId;
        }
        
        /**
         * Setter for property coaAsuransiDebetId.
         * @param coaAsuransiDebetId New value of property coaAsuransiDebetId.
         */
        public void setCoaAsuransiDebetId(long coaAsuransiDebetId) {
            this.coaAsuransiDebetId = coaAsuransiDebetId;
        }
        
        /**
         * Getter for property coaAsuransiCreditId.
         * @return Value of property coaAsuransiCreditId.
         */
        public long getCoaAsuransiCreditId() {
            return this.coaAsuransiCreditId;
        }
        
        /**
         * Setter for property coaAsuransiCreditId.
         * @param coaAsuransiCreditId New value of property coaAsuransiCreditId.
         */
        public void setCoaAsuransiCreditId(long coaAsuransiCreditId) {
            this.coaAsuransiCreditId = coaAsuransiCreditId;
        }
        
        /**
         * Getter for property coaTitipanDebetId.
         * @return Value of property coaTitipanDebetId.
         */
        public long getCoaTitipanDebetId() {
            return this.coaTitipanDebetId;
        }
        
        /**
         * Setter for property coaTitipanDebetId.
         * @param coaTitipanDebetId New value of property coaTitipanDebetId.
         */
        public void setCoaTitipanDebetId(long coaTitipanDebetId) {
            this.coaTitipanDebetId = coaTitipanDebetId;
        }
        
        /**
         * Getter for property coaTitipanCreditId.
         * @return Value of property coaTitipanCreditId.
         */
        public long getCoaTitipanCreditId() {
            return this.coaTitipanCreditId;
        }
        
        /**
         * Setter for property coaTitipanCreditId.
         * @param coaTitipanCreditId New value of property coaTitipanCreditId.
         */
        public void setCoaTitipanCreditId(long coaTitipanCreditId) {
            this.coaTitipanCreditId = coaTitipanCreditId;
        }
        
        /**
         * Getter for property angsuranTerakhir.
         * @return Value of property angsuranTerakhir.
         */
        public int getAngsuranTerakhir() {
            return this.angsuranTerakhir;
        }
        
        /**
         * Setter for property angsuranTerakhir.
         * @param angsuranTerakhir New value of property angsuranTerakhir.
         */
        public void setAngsuranTerakhir(int angsuranTerakhir) {
            this.angsuranTerakhir = angsuranTerakhir;
        }
        
}
