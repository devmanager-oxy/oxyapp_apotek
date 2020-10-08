
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Recipe extends Entity { 

	private long itemMasterId;
	private long itemRecipeId;
	private double qty;
	private long uomId;
	private double cost;
	private String type = "";
	private Date lastUpdate;

        /**
         * Holds value of property description.
         */
        private String description;
        
       
        
	public long getItemMasterId(){ 
		return itemMasterId; 
	} 

	public void setItemMasterId(long itemMasterId){ 
		this.itemMasterId = itemMasterId; 
	} 

	public long getItemRecipeId(){ 
		return itemRecipeId; 
	} 

	public void setItemRecipeId(long itemRecipeId){ 
		this.itemRecipeId = itemRecipeId; 
	} 

	public double getQty(){ 
		return qty; 
	} 

	public void setQty(double qty){ 
		this.qty = qty; 
	} 

	public long getUomId(){ 
		return uomId; 
	} 

	public void setUomId(long uomId){ 
		this.uomId = uomId; 
	} 

	public double getCost(){ 
		return cost; 
	} 

	public void setCost(double cost){ 
		this.cost = cost; 
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

	public Date getLastUpdate(){ 
		return lastUpdate; 
	} 

	public void setLastUpdate(Date lastUpdate){ 
		this.lastUpdate = lastUpdate; 
	} 

        /**
         * Getter for property desription.
         * @return Value of property desription.
         */
        public String getDescription() {
            return this.description;
        }
        
        /**
         * Setter for property desription.
         * @param desription New value of property desription.
         */
        public void setDescription(String description) {
            this.description = description;
        }
        
}
