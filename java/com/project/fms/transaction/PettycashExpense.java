
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

public class PettycashExpense extends Entity { 

	private long pettycashReplenishmentId;
	private long pettycashPaymentId;
	private double amount;

	public long getPettycashReplenishmentId(){ 
		return pettycashReplenishmentId; 
	} 

	public void setPettycashReplenishmentId(long pettycashReplenishmentId){ 
		this.pettycashReplenishmentId = pettycashReplenishmentId; 
	} 

	public long getPettycashPaymentId(){ 
		return pettycashPaymentId; 
	} 

	public void setPettycashPaymentId(long pettycashPaymentId){ 
		this.pettycashPaymentId = pettycashPaymentId; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

}
