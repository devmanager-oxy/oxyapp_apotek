/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy Andika
 */
public class PaymentSimulation extends Entity{
    
    private long salesDataId;
    private int typePayment;
    private String name = "";
    private double saldo;
    private double bunga;
    private double amount;
    private double totalAmount;
    private Date dueDate;
    private long customerId;
    private int statusGen;
    private int status;
    private long userId;
    private int payment;
    
    public long getSalesDataId() {
        return salesDataId;
    }

    public void setSalesDataId(long salesDataId) {
        this.salesDataId = salesDataId;
    }

    public int getTypePayment() {
        return typePayment;
    }

    public void setTypePayment(int typePayment) {
        this.typePayment = typePayment;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public double getBunga() {
        return bunga;
    }

    public void setBunga(double bunga) {
        this.bunga = bunga;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public int getStatusGen() {
        return statusGen;
    }

    public void setStatusGen(int statusGen) {
        this.statusGen = statusGen;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getPayment() {
        return payment;
    }

    public void setPayment(int payment) {
        this.payment = payment;
    }
    

}
