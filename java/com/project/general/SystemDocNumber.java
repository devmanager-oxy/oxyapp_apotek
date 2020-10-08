
package com.project.general; 
 
import java.util.Date;
import com.project.main.entity.*;

public class SystemDocNumber extends Entity { 

	private String type = "";
	private int counter;
	private String prefixNumber = "";
	private int year;
	private Date date;
	private long userId;
	private String docNumber = "";

	public String getType(){ 
		return type; 
	} 

	public void setType(String type){ 
		if ( type == null ) {
			type = ""; 
		} 
		this.type = type; 
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

	public int getYear(){ 
		return year; 
	} 

	public void setYear(int year){ 
		this.year = year; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getDocNumber(){ 
		return docNumber; 
	} 

	public void setDocNumber(String docNumber){ 
		if ( docNumber == null ) {
			docNumber = ""; 
		} 
		this.docNumber = docNumber; 
	} 

}
