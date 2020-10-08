package com.project.fms.master;

/* package java */
import com.project.main.entity.*;

public class SegmentDetail extends Entity {

    private long segmentId = 0;
    private String name = "";
    private long refId = 0;
    private String code = "";
    private int level = 0;
    private String type = "";
    private long locationId = 0;
    private int typeSalesReport = 0;
    private long refSegmentDetailId = 0;
    private int status = 0;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public long getSegmentId() {
        return segmentId;
    }

    public void setSegmentId(long segmentId) {
        this.segmentId = segmentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public int getTypeSalesReport() {
        return typeSalesReport;
    }

    public void setTypeSalesReport(int typeSalesReport) {
        this.typeSalesReport = typeSalesReport;
    }

    public long getRefSegmentDetailId() {
        return refSegmentDetailId;
    }

    public void setRefSegmentDetailId(long refSegmentDetailId) {
        this.refSegmentDetailId = refSegmentDetailId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    
}
