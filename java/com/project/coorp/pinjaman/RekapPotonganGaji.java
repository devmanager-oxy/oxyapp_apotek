
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class RekapPotonganGaji extends Entity { 

	private long periodeRekapId;
	private long memberId;
	private double simpananPokok;
	private double simpananWajib;
	private double simpananSukarela;
	private double pinjamanPokok;
	private double pinjamanBunga;
	private double minimarket;
	private double elektronikPokok;
	private double elektronikBunga;
	private double mandiri;
	private double bni;
	private double bca;
	private double lainlain;
	private int status;
	private int approved;
	private Date date;
	private int userId;

        /**
         * Holds value of property fasjabtel.
         */
        private double fasjabtel;
        
        /**
         * Holds value of property note.
         */
        private String note;
        
        /**
         * Holds value of property statusDocument.
         */
        private int statusDocument;
        
        /**
         * Holds value of property disetujui.
         */
        private double disetujui;
        
        /**
         * Holds value of property rekapMainId.
         */
        private long rekapMainId;
        
        /**
         * Holds value of property mandiriBunga.
         */
        private double mandiriBunga;
        
	public long getPeriodeRekapId(){ 
		return periodeRekapId; 
	} 

	public void setPeriodeRekapId(long periodeRekapId){ 
		this.periodeRekapId = periodeRekapId; 
	} 

	public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		this.memberId = memberId; 
	} 

	public double getSimpananPokok(){ 
		return simpananPokok; 
	} 

	public void setSimpananPokok(double simpananPokok){ 
		this.simpananPokok = simpananPokok; 
	} 

	public double getSimpananWajib(){ 
		return simpananWajib; 
	} 

	public void setSimpananWajib(double simpananWajib){ 
		this.simpananWajib = simpananWajib; 
	} 

	public double getSimpananSukarela(){ 
		return simpananSukarela; 
	} 

	public void setSimpananSukarela(double simpananSukarela){ 
		this.simpananSukarela = simpananSukarela; 
	} 

	public double getPinjamanPokok(){ 
		return pinjamanPokok; 
	} 

	public void setPinjamanPokok(double pinjamanPokok){ 
		this.pinjamanPokok = pinjamanPokok; 
	} 

	public double getPinjamanBunga(){ 
		return pinjamanBunga; 
	} 

	public void setPinjamanBunga(double pinjamanBunga){ 
		this.pinjamanBunga = pinjamanBunga; 
	} 

	public double getMinimarket(){ 
		return minimarket; 
	} 

	public void setMinimarket(double minimarket){ 
		this.minimarket = minimarket; 
	} 

	public double getElektronikPokok(){ 
		return elektronikPokok; 
	} 

	public void setElektronikPokok(double elektronikPokok){ 
		this.elektronikPokok = elektronikPokok; 
	} 

	public double getElektronikBunga(){ 
		return elektronikBunga; 
	} 

	public void setElektronikBunga(double elektronikBunga){ 
		this.elektronikBunga = elektronikBunga; 
	} 

	public double getMandiri(){ 
		return mandiri; 
	} 

	public void setMandiri(double mandiri){ 
		this.mandiri = mandiri; 
	} 

	public double getBni(){ 
		return bni; 
	} 

	public void setBni(double bni){ 
		this.bni = bni; 
	} 

	public double getBca(){ 
		return bca; 
	} 

	public void setBca(double bca){ 
		this.bca = bca; 
	} 

	public double getLainlain(){ 
		return lainlain; 
	} 

	public void setLainlain(double lainlain){ 
		this.lainlain = lainlain; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public int getApproved(){ 
		return approved; 
	} 

	public void setApproved(int approved){ 
		this.approved = approved; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public int getUserId(){ 
		return userId; 
	} 

	public void setUserId(int userId){ 
		this.userId = userId; 
	} 

        /**
         * Getter for property fasjabtel.
         * @return Value of property fasjabtel.
         */
        public double getFasjabtel() {
            return this.fasjabtel;
        }
        
        /**
         * Setter for property fasjabtel.
         * @param fasjabtel New value of property fasjabtel.
         */
        public void setFasjabtel(double fasjabtel) {
            this.fasjabtel = fasjabtel;
        }
        
        /**
         * Getter for property note.
         * @return Value of property note.
         */
        public String getNote() {
            return this.note;
        }
        
        /**
         * Setter for property note.
         * @param note New value of property note.
         */
        public void setNote(String note) {
            this.note = note;
        }
        
        /**
         * Getter for property statusDocument.
         * @return Value of property statusDocument.
         */
        public int getStatusDocument() {
            return this.statusDocument;
        }
        
        /**
         * Setter for property statusDocument.
         * @param statusDocument New value of property statusDocument.
         */
        public void setStatusDocument(int statusDocument) {
            this.statusDocument = statusDocument;
        }
        
        /**
         * Getter for property disetujui.
         * @return Value of property disetujui.
         */
        public double getDisetujui() {
            return this.disetujui;
        }
        
        /**
         * Setter for property disetujui.
         * @param disetujui New value of property disetujui.
         */
        public void setDisetujui(double disetujui) {
            this.disetujui = disetujui;
        }
        
        /**
         * Getter for property rekapMainId.
         * @return Value of property rekapMainId.
         */
        public long getRekapMainId() {
            return this.rekapMainId;
        }
        
        /**
         * Setter for property rekapMainId.
         * @param rekapMainId New value of property rekapMainId.
         */
        public void setRekapMainId(long rekapMainId) {
            this.rekapMainId = rekapMainId;
        }
        
        /**
         * Getter for property mandiriBunga.
         * @return Value of property mandiriBunga.
         */
        public double getMandiriBunga() {
            return this.mandiriBunga;
        }
        
        /**
         * Setter for property mandiriBunga.
         * @param mandiriBunga New value of property mandiriBunga.
         */
        public void setMandiriBunga(double mandiriBunga) {
            this.mandiriBunga = mandiriBunga;
        }
        
}
