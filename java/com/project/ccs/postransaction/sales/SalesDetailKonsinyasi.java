/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;
import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy
 */
public class SalesDetailKonsinyasi extends Entity {

    private long salesId = 0;
    private long salesDetailId = 0;
    private long vendorId = 0;
    private Date createDate;
    private long createId = 0;
    private long referensiId = 0;

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public long getSalesDetailId() {
        return salesDetailId;
    }

    public void setSalesDetailId(long salesDetailId) {
        this.salesDetailId = salesDetailId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public long getCreateId() {
        return createId;
    }

    public void setCreateId(long createId) {
        this.createId = createId;
    }

    public long getReferensiId() {
        return referensiId;
    }

    public void setReferensiId(long referensiId) {
        this.referensiId = referensiId;
    }
}
