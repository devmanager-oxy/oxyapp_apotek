/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Angga
 */
public class RptSalesRestaurant {
    private Date tanggal =  new Date();
    private Date invStartDate =  new Date();
    private Date invEndDate =  new Date();
    private  double slsRoom;
    private  double nettSls;
    private  double subtotal;
    private  double tax;
    private  double total;
    private long merchantId=0;
    private double totPayCard;

    /**
     * @return the tanggal
     */
    public Date getTanggal() {
        return tanggal;
    }

    /**
     * @param tanggal the tanggal to set
     */
    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    /**
     * @return the invStartDate
     */
    public Date getInvStartDate() {
        return invStartDate;
    }

    /**
     * @param invStartDate the invStartDate to set
     */
    public void setInvStartDate(Date invStartDate) {
        this.invStartDate = invStartDate;
    }

    /**
     * @return the invEndDate
     */
    public Date getInvEndDate() {
        return invEndDate;
    }

    /**
     * @param invEndDate the invEndDate to set
     */
    public void setInvEndDate(Date invEndDate) {
        this.invEndDate = invEndDate;
    }

    /**
     * @return the slsRoom
     */
    public double getSlsRoom() {
        return slsRoom;
    }

    /**
     * @param slsRoom the slsRoom to set
     */
    public void setSlsRoom(double slsRoom) {
        this.slsRoom = slsRoom;
    }

    /**
     * @return the nettSls
     */
    public double getNettSls() {
        return nettSls;
    }

    /**
     * @param nettSls the nettSls to set
     */
    public void setNettSls(double nettSls) {
        this.nettSls = nettSls;
    }

    /**
     * @return the subtotal
     */
    public double getSubtotal() {
        return subtotal;
    }

    /**
     * @param subtotal the subtotal to set
     */
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    /**
     * @return the tax
     */
    public double getTax() {
        return tax;
    }

    /**
     * @param tax the tax to set
     */
    public void setTax(double tax) {
        this.tax = tax;
    }

    /**
     * @return the total
     */
    public double getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(double total) {
        this.total = total;
    }

    /**
     * @return the merchantId
     */
    public long getMerchantId() {
        return merchantId;
    }

    /**
     * @param merchantId the merchantId to set
     */
    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    /**
     * @return the totPayCard
     */
    public double getTotPayCard() {
        return totPayCard;
    }

    /**
     * @param totPayCard the totPayCard to set
     */
    public void setTotPayCard(double totPayCard) {
        this.totPayCard = totPayCard;
    }
}
