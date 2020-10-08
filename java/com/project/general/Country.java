

package com.project.general; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Country extends Entity { 

	private String name = "";
	private String nationality = "";
	private String continent = "";
	private String hub = "";

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getNationality(){ 
		return nationality; 
	} 

	public void setNationality(String nationality){ 
		if ( nationality == null ) {
			nationality = ""; 
		} 
		this.nationality = nationality; 
	} 

	public String getContinent(){ 
		return continent; 
	} 

	public void setContinent(String continent){ 
		if ( continent == null ) {
			continent = ""; 
		} 
		this.continent = continent; 
	} 

	public String getHub(){ 
		return hub; 
	} 

	public void setHub(String hub){ 
		if ( hub == null ) {
			hub = ""; 
		} 
		this.hub = hub; 
	} 

}
