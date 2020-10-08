
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class RekapMain extends Entity { 

	private long dinasId;
	private long dinasUnitId;
	private long periodeRekapId;
	private int status;
	private Date date;
	private int counter;
	private String prefixNumber = "";
	private String number = "";
	private String note = "";
	private long angsuranCoaDebetId;
	private long angsuranCoaCreditId;
	private long bungaCoaDebetId;
	private long bungaCoaCreditId;
	private long minimarketCoaDebetId;
	private long minimarketCoaCreditId;
	private long fasjabtelCoaDebetId;
	private long fasjabtelCoaCreditId;
	private long titipanCoaDebetId;
	private long titipanCoaCreditId;
	private long simpananCoaDebetId;
	private long simpananCoaCreditId;

        /**
         * Holds value of property userId.
         */
        private long userId;
        
        /**
         * Holds value of property simpananPokokCoaId.
         */
        private long simpananPokokCoaId;
        
        /**
         * Holds value of property simpananSukarelaCoaId.
         */
        private long simpananSukarelaCoaId;
        
	public long getDinasId(){ 
		return dinasId; 
	} 

	public void setDinasId(long dinasId){ 
		this.dinasId = dinasId; 
	} 

	public long getDinasUnitId(){ 
		return dinasUnitId; 
	} 

	public void setDinasUnitId(long dinasUnitId){ 
		this.dinasUnitId = dinasUnitId; 
	} 

	public long getPeriodeRekapId(){ 
		return periodeRekapId; 
	} 

	public void setPeriodeRekapId(long periodeRekapId){ 
		this.periodeRekapId = periodeRekapId; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
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

	public String getNote(){ 
		return note; 
	} 

	public void setNote(String note){ 
		if ( note == null ) {
			note = ""; 
		} 
		this.note = note; 
	} 

	public long getAngsuranCoaDebetId(){ 
		return angsuranCoaDebetId; 
	} 

	public void setAngsuranCoaDebetId(long angsuranCoaDebetId){ 
		this.angsuranCoaDebetId = angsuranCoaDebetId; 
	} 

	public long getAngsuranCoaCreditId(){ 
		return angsuranCoaCreditId; 
	} 

	public void setAngsuranCoaCreditId(long angsuranCoaCreditId){ 
		this.angsuranCoaCreditId = angsuranCoaCreditId; 
	} 

	public long getBungaCoaDebetId(){ 
		return bungaCoaDebetId; 
	} 

	public void setBungaCoaDebetId(long bungaCoaDebetId){ 
		this.bungaCoaDebetId = bungaCoaDebetId; 
	} 

	public long getBungaCoaCreditId(){ 
		return bungaCoaCreditId; 
	} 

	public void setBungaCoaCreditId(long bungaCoaCreditId){ 
		this.bungaCoaCreditId = bungaCoaCreditId; 
	} 

	public long getMinimarketCoaDebetId(){ 
		return minimarketCoaDebetId; 
	} 

	public void setMinimarketCoaDebetId(long minimarketCoaDebetId){ 
		this.minimarketCoaDebetId = minimarketCoaDebetId; 
	} 

	public long getMinimarketCoaCreditId(){ 
		return minimarketCoaCreditId; 
	} 

	public void setMinimarketCoaCreditId(long minimarketCoaCreditId){ 
		this.minimarketCoaCreditId = minimarketCoaCreditId; 
	} 

	public long getFasjabtelCoaDebetId(){ 
		return fasjabtelCoaDebetId; 
	} 

	public void setFasjabtelCoaDebetId(long fasjabtelCoaDebetId){ 
		this.fasjabtelCoaDebetId = fasjabtelCoaDebetId; 
	} 

	public long getFasjabtelCoaCreditId(){ 
		return fasjabtelCoaCreditId; 
	} 

	public void setFasjabtelCoaCreditId(long fasjabtelCoaCreditId){ 
		this.fasjabtelCoaCreditId = fasjabtelCoaCreditId; 
	} 

	public long getTitipanCoaDebetId(){ 
		return titipanCoaDebetId; 
	} 

	public void setTitipanCoaDebetId(long titipanCoaDebetId){ 
		this.titipanCoaDebetId = titipanCoaDebetId; 
	} 

	public long getTitipanCoaCreditId(){ 
		return titipanCoaCreditId; 
	} 

	public void setTitipanCoaCreditId(long titipanCoaCreditId){ 
		this.titipanCoaCreditId = titipanCoaCreditId; 
	} 

	public long getSimpananCoaDebetId(){ 
		return simpananCoaDebetId; 
	} 

	public void setSimpananCoaDebetId(long simpananCoaDebetId){ 
		this.simpananCoaDebetId = simpananCoaDebetId; 
	} 

	public long getSimpananCoaCreditId(){ 
		return simpananCoaCreditId; 
	} 

	public void setSimpananCoaCreditId(long simpananCoaCreditId){ 
		this.simpananCoaCreditId = simpananCoaCreditId; 
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
         * Getter for property simpananPokokCoaId.
         * @return Value of property simpananPokokCoaId.
         */
        public long getSimpananPokokCoaId() {
            return this.simpananPokokCoaId;
        }
        
        /**
         * Setter for property simpananPokokCoaId.
         * @param simpananPokokCoaId New value of property simpananPokokCoaId.
         */
        public void setSimpananPokokCoaId(long simpananPokokCoaId) {
            this.simpananPokokCoaId = simpananPokokCoaId;
        }
        
        /**
         * Getter for property simpananSukarelaCoaId.
         * @return Value of property simpananSukarelaCoaId.
         */
        public long getSimpananSukarelaCoaId() {
            return this.simpananSukarelaCoaId;
        }
        
        /**
         * Setter for property simpananSukarelaCoaId.
         * @param simpananSukarelaCoaId New value of property simpananSukarelaCoaId.
         */
        public void setSimpananSukarelaCoaId(long simpananSukarelaCoaId) {
            this.simpananSukarelaCoaId = simpananSukarelaCoaId;
        }
        
}
