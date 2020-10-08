
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class BanknonpoPaymentDetail extends Entity { 

	private long banknonpoPaymentId;
	private long coaId;
	private double amount;
	private String memo = "";

        /**
         * Holds value of property foreignCurrencyId.
         */
        private long foreignCurrencyId;
        
        /**
         * Holds value of property foreignAmount.
         */
        private double foreignAmount;
        
        /**
         * Holds value of property bookedRate.
         */
        private double bookedRate;
        
        /**
         * Holds value of property departmentId.
         */
        private long departmentId;
        
        /**
         * Holds value of property coaIdTemp.
         */
        private long coaIdTemp;
        
        /**
         * Holds value of property type.
         */
        private int type;
        
    //added by eka    
    private long segment1Id;
    private long segment2Id;
    private long segment3Id;
    private long segment4Id;
    private long segment5Id;
    private long segment6Id;
    private long segment7Id;
    private long segment8Id;
    private long segment9Id;
    private long segment10Id;
    private long segment11Id;
    private long segment12Id;
    private long segment13Id;
    private long segment14Id;
    private long segment15Id;
    private long moduleId; 
    	       
    //====== segment
    
    private long coaIdAct; 
    	
    public long getCoaIdAct(){ 
		return coaIdAct; 
	} 

	public void setCoaIdAct(long coaIdAct){ 
		this.coaIdAct = coaIdAct; 
	}	
    
    public long getModuleId(){ 
		return moduleId; 
	} 

	public void setModuleId(long moduleId){ 
		this.moduleId = moduleId; 
	}
	
    public long getSegment15Id(){ 
		return segment15Id; 
	} 

	public void setSegment15Id(long segment15Id){ 
		this.segment15Id = segment15Id; 
	}  
		
    public long getSegment14Id(){ 
		return segment14Id; 
	} 

	public void setSegment14Id(long segment14Id){ 
		this.segment14Id = segment14Id; 
	}  
		
    public long getSegment13Id(){ 
		return segment13Id; 
	} 

	public void setSegment13Id(long segment13Id){ 
		this.segment13Id = segment13Id; 
	}  
		
    public long getSegment12Id(){ 
		return segment12Id; 
	} 

	public void setSegment12Id(long segment12Id){ 
		this.segment12Id = segment12Id; 
	}  
		
    public long getSegment11Id(){ 
		return segment11Id; 
	} 

	public void setSegment11Id(long segment11Id){ 
		this.segment11Id = segment11Id; 
	}  
		
    public long getSegment10Id(){ 
		return segment10Id; 
	} 

	public void setSegment10Id(long segment10Id){ 
		this.segment10Id = segment10Id; 
	}  
		
    public long getSegment9Id(){ 
		return segment9Id; 
	} 

	public void setSegment9Id(long segment9Id){ 
		this.segment9Id = segment9Id; 
	}  
    
    public long getSegment8Id(){ 
		return segment8Id; 
	} 

	public void setSegment8Id(long segment8Id){ 
		this.segment8Id = segment8Id; 
	}  
    
    public long getSegment7Id(){ 
		return segment7Id; 
	} 

	public void setSegment7Id(long segment7Id){ 
		this.segment7Id = segment7Id; 
	}  
		
    public long getSegment6Id(){ 
		return segment6Id; 
	} 

	public void setSegment6Id(long segment6Id){ 
		this.segment6Id = segment6Id; 
	}  
    
    public long getSegment5Id(){ 
		return segment5Id; 
	} 

	public void setSegment5Id(long segment5Id){ 
		this.segment5Id = segment5Id; 
	}  
    
    public long getSegment4Id(){ 
		return segment4Id; 
	} 

	public void setSegment4Id(long segment4Id){ 
		this.segment4Id = segment4Id; 
	}  
		
	public long getSegment3Id(){ 
		return segment3Id; 
	} 

	public void setSegment3Id(long segment3Id){ 
		this.segment3Id = segment3Id; 
	}  
		
    public long getSegment2Id(){ 
		return segment2Id; 
	} 

	public void setSegment2Id(long segment2Id){ 
		this.segment2Id = segment2Id; 
	}  
		
    public long getSegment1Id(){ 
		return segment1Id; 
	} 

	public void setSegment1Id(long segment1Id){ 
		this.segment1Id = segment1Id; 
	}     
    
    
    //========	      
        
	public long getBanknonpoPaymentId(){ 
		return banknonpoPaymentId; 
	} 

	public void setBanknonpoPaymentId(long banknonpoPaymentId){ 
		this.banknonpoPaymentId = banknonpoPaymentId; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

        /**
         * Getter for property foreignCurrencyId.
         * @return Value of property foreignCurrencyId.
         */
        public long getForeignCurrencyId() {
            return this.foreignCurrencyId;
        }
        
        /**
         * Setter for property foreignCurrencyId.
         * @param foreignCurrencyId New value of property foreignCurrencyId.
         */
        public void setForeignCurrencyId(long foreignCurrencyId) {
            this.foreignCurrencyId = foreignCurrencyId;
        }
        
        /**
         * Getter for property foreignAmount.
         * @return Value of property foreignAmount.
         */
        public double getForeignAmount() {
            return this.foreignAmount;
        }
        
        /**
         * Setter for property foreignAmount.
         * @param foreignAmount New value of property foreignAmount.
         */
        public void setForeignAmount(double foreignAmount) {
            this.foreignAmount = foreignAmount;
        }
        
        /**
         * Getter for property bookedRate.
         * @return Value of property bookedRate.
         */
        public double getBookedRate() {
            return this.bookedRate;
        }
        
        /**
         * Setter for property bookedRate.
         * @param bookedRate New value of property bookedRate.
         */
        public void setBookedRate(double bookedRate) {
            this.bookedRate = bookedRate;
        }
        
        /**
         * Getter for property departmentId.
         * @return Value of property departmentId.
         */
        public long getDepartmentId() {
            return this.departmentId;
        }
        
        /**
         * Setter for property departmentId.
         * @param departmentId New value of property departmentId.
         */
        public void setDepartmentId(long departmentId) {
            this.departmentId = departmentId;
        }
        
        /**
         * Getter for property coaIdTemp.
         * @return Value of property coaIdTemp.
         */
        public long getCoaIdTemp() {
            return this.coaIdTemp;
        }
        
        /**
         * Setter for property coaIdTemp.
         * @param coaIdTemp New value of property coaIdTemp.
         */
        public void setCoaIdTemp(long coaIdTemp) {
            this.coaIdTemp = coaIdTemp;
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
        
}
