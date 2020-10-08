/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;

/**
 *
 * @author Roy Andika
 */
import com.project.main.entity.*;

public class FloorPictures extends Entity{
    private long floorId;
    private String floorPic = "";

    public long getFloorId() {
        return floorId;
    }

    public void setFloorId(long floorId) {
        this.floorId = floorId;
    }

    public String getFloorPic() {
        return floorPic;
    }

    public void setFloorPic(String floorPic) {
        this.floorPic = floorPic;
    }

}
