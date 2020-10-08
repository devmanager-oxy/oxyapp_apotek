package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.costing.*;
import java.util.Date;
import com.project.main.entity.*;

public class PromotionLocation extends Entity {
    
    private long promotionId;
    private long locationId;
    private String locationName="";

    public long getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(long promotionId) {
        this.promotionId = promotionId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    
    
    

    
}
