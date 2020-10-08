
package com.project.general; 

import com.project.main.entity.*;

public class SubLocation extends Entity { 

	private long location_id;
	private String name = "";
	private String description="";
        

    public long getLocation_id() {
        return location_id;
    }

    public void setLocation_id(long location_id) {
        this.location_id = location_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    
	
	
}
