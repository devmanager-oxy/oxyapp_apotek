package com.project.general; 
 
import java.util.Date;
import com.project.main.entity.*;

public class BankAccount extends Entity { 

	private String name = "";
	private int type;
	private String accNumber = "";
	private String bankName = "";
	private int status;
	private String accountCode = "";
	private long coaId;

        /**
         * Holds value of property companyId.
         */
        private long companyId;
        
        /**
         * Holds value of property currencyId.
         */
        private long currencyId;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public String getAccNumber(){ 
		return accNumber; 
	} 

	public void setAccNumber(String accNumber){ 
		if ( accNumber == null ) {
			accNumber = ""; 
		} 
		this.accNumber = accNumber; 
	} 

	public String getBankName(){ 
		return bankName; 
	} 

	public void setBankName(String bankName){ 
		if ( bankName == null ) {
			bankName = ""; 
		} 
		this.bankName = bankName; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public String getAccountCode(){ 
		return accountCode; 
	} 

	public void setAccountCode(String accountCode){ 
		if ( accountCode == null ) {
			accountCode = ""; 
		} 
		this.accountCode = accountCode; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

        /**
         * Getter for property companyId.
         * @return Value of property companyId.
         */
        public long getCompanyId() {
            return this.companyId;
        }
        
        /**
         * Setter for property companyId.
         * @param companyId New value of property companyId.
         */
        public void setCompanyId(long companyId) {
            this.companyId = companyId;
        }
        
        /**
         * Getter for property currencyId.
         * @return Value of property currencyId.
         */
        public long getCurrencyId() {
            return this.currencyId;
        }
        
        /**
         * Setter for property currencyId.
         * @param currencyId New value of property currencyId.
         */
        public void setCurrencyId(long currencyId) {
            this.currencyId = currencyId;
        }
        
}
