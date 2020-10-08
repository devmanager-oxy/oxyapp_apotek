/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Administrator
 */
public class ReturnPayment extends Entity{
    private long sales_id=0;
    private long currency_id=0;
    private double amount = 0;

    public long getSales_id() {
        return sales_id;
    }

    public void setSales_id(long sales_id) {
        this.sales_id = sales_id;
    }

    public long getCurrency_id() {
        return currency_id;
    }

    public void setCurrency_id(long currency_id) {
        this.currency_id = currency_id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    

   
   
}
