
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class PurchaseItemShare extends Entity { 
    
    /**
     * Holds value of property purchaseId.
     */
    private long purchaseId;
    
    /**
     * Holds value of property purchaseItemId.
     */
    private long purchaseItemId;
    
    /**
     * Holds value of property roomClassId.
     */
    private long roomClassId;
    
    /**
     * Holds value of property hotelRoomId.
     */
    private long hotelRoomId;
    
    /**
     * Holds value of property percent.
     */
    private double percent;
    
    /**
     * Holds value of property amount.
     */
    private double amount;
    
    /**
     * Holds value of property coaId.
     */
    private long coaId;
    
    /**
     * Holds value of property date.
     */
    private Date date;
    
    /**
     * Holds value of property totalAmount.
     */
    private double totalAmount;
    
    /**
     * Holds value of property userId.
     */
    private long userId;
    
    /**
     * Holds value of property coaCreditId.
     */
    private long coaCreditId;
    
    /**
     * Getter for property purchaseId.
     * @return Value of property purchaseId.
     */
    public long getPurchaseId() {
        return this.purchaseId;
    }
    
    /**
     * Setter for property purchaseId.
     * @param purchaseId New value of property purchaseId.
     */
    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
    }
    
    /**
     * Getter for property purchaseItemId.
     * @return Value of property purchaseItemId.
     */
    public long getPurchaseItemId() {
        return this.purchaseItemId;
    }
    
    /**
     * Setter for property purchaseItemId.
     * @param purchaseItemId New value of property purchaseItemId.
     */
    public void setPurchaseItemId(long purchaseItemId) {
        this.purchaseItemId = purchaseItemId;
    }
    
    /**
     * Getter for property roomClassId.
     * @return Value of property roomClassId.
     */
    public long getRoomClassId() {
        return this.roomClassId;
    }
    
    /**
     * Setter for property roomClassId.
     * @param roomClassId New value of property roomClassId.
     */
    public void setRoomClassId(long roomClassId) {
        this.roomClassId = roomClassId;
    }
    
    /**
     * Getter for property hotelRoomId.
     * @return Value of property hotelRoomId.
     */
    public long getHotelRoomId() {
        return this.hotelRoomId;
    }
    
    /**
     * Setter for property hotelRoomId.
     * @param hotelRoomId New value of property hotelRoomId.
     */
    public void setHotelRoomId(long hotelRoomId) {
        this.hotelRoomId = hotelRoomId;
    }
    
    /**
     * Getter for property percent.
     * @return Value of property percent.
     */
    public double getPercent() {
        return this.percent;
    }
    
    /**
     * Setter for property percent.
     * @param percent New value of property percent.
     */
    public void setPercent(double percent) {
        this.percent = percent;
    }
    
    /**
     * Getter for property amount.
     * @return Value of property amount.
     */
    public double getAmount() {
        return this.amount;
    }
    
    /**
     * Setter for property amount.
     * @param amount New value of property amount.
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    /**
     * Getter for property coaId.
     * @return Value of property coaId.
     */
    public long getCoaId() {
        return this.coaId;
    }
    
    /**
     * Setter for property coaId.
     * @param coaId New value of property coaId.
     */
    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }
    
    /**
     * Getter for property date.
     * @return Value of property date.
     */
    public Date getDate() {
        return this.date;
    }
    
    /**
     * Setter for property date.
     * @param date New value of property date.
     */
    public void setDate(Date date) {
        this.date = date;
    }
    
    /**
     * Getter for property totalAmount.
     * @return Value of property totalAmount.
     */
    public double getTotalAmount() {
        return this.totalAmount;
    }
    
    /**
     * Setter for property totalAmount.
     * @param totalAmount New value of property totalAmount.
     */
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    /**
     * Getter for property userId.
     * @return Value of property userId.
     */
    public long getUserId() {
        return this.userId;
    }
    
    /**
     * Setter for property userId.
     * @param userId New value of property userId.
     */
    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    /**
     * Getter for property coaCreditId.
     * @return Value of property coaCreditId.
     */
    public long getCoaCreditId() {
        return this.coaCreditId;
    }
    
    /**
     * Setter for property coaCreditId.
     * @param coaCreditId New value of property coaCreditId.
     */
    public void setCoaCreditId(long coaCreditId) {
        this.coaCreditId = coaCreditId;
    }
    
}
