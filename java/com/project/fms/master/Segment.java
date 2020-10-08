package com.project.fms.master; 
 
/* package java */ 
import java.util.Date;
import com.project.main.entity.*;

public class Segment extends Entity { 

	private String name = "";
	private String type = "";
	private String function = "";
	private String columnName = "";
	private int count;

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
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

	public String getFunction(){ 
		return function; 
	} 

	public void setFunction(String function){ 
		if ( function == null ) {
			function = ""; 
		} 
		this.function = function; 
	} 

	public String getColumnName(){ 
		return columnName; 
	} 

	public void setColumnName(String columnName){ 
		if ( columnName == null ) {
			columnName = ""; 
		} 
		this.columnName = columnName; 
	} 

	public int getCount(){ 
		return count; 
	} 

	public void setCount(int count){ 
		this.count = count; 
	} 

}
