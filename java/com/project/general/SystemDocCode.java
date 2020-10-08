
package com.project.general; 

import com.project.main.entity.*;

public class SystemDocCode extends Entity { 

	private String code = "";
	private String type = "";
	private String codeFormat = "";
	private String separator = "";
        
        //add by roy andika 2012-01-09
        private int digitCounter;
        private int posisiAfterCode;
        private int yearDigit;
        private int monthDigit;
        private int monthType;

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

	public String getType(){ 
		return type; 
	} 

	public void setType(String type){ 
		if ( type == null ) {
			type = ""; 
		} 
		this.type = type; 
	} 

	public String getCodeFormat(){ 
		return codeFormat; 
	} 

	public void setCodeFormat(String codeFormat){ 
		if ( codeFormat == null ) {
			codeFormat = ""; 
		} 
		this.codeFormat = codeFormat; 
	} 

	public String getSeparator(){ 
		return separator; 
	} 

	public void setSeparator(String separator){ 
		if ( separator == null ) {
			separator = ""; 
		} 
		this.separator = separator; 
	}

    public int getDigitCounter() {
        return digitCounter;
    }

    public void setDigitCounter(int digitCounter) {
        this.digitCounter = digitCounter;
    }

    public int getPosisiAfterCode() {
        return posisiAfterCode;
    }

    public void setPosisiAfterCode(int posisiAfterCode) {
        this.posisiAfterCode = posisiAfterCode;
    }

    public int getYearDigit() {
        return yearDigit;
    }

    public void setYearDigit(int yearDigit) {
        this.yearDigit = yearDigit;
    }

    public int getMonthDigit() {
        return monthDigit;
    }

    public void setMonthDigit(int monthDigit) {
        this.monthDigit = monthDigit;
    }

    public int getMonthType() {
        return monthType;
    }

    public void setMonthType(int monthType) {
        this.monthType = monthType;
    }

    

}
