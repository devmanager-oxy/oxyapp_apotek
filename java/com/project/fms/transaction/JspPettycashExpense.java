/* 
 * Form Name  	:  JspPettycashExpense.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.*;

public class JspPettycashExpense extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PettycashExpense pettycashExpense;

	public static final String JSP_NAME_PETTYCASHEXPENSE		=  "JSP_NAME_PETTYCASHEXPENSE" ;

	public static final int JSP_PETTYCASH_EXPENSE_ID			=  0 ;
	public static final int JSP_PETTYCASH_REPLENISHMENT_ID			=  1 ;
	public static final int JSP_PETTYCASH_PAYMENT_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;

	public static String[] colNames = {
		"JSP_PETTYCASH_EXPENSE_ID",  "JSP_PETTYCASH_REPLENISHMENT_ID",
		"JSP_PETTYCASH_PAYMENT_ID",  "JSP_AMOUNT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT
	} ;

	public JspPettycashExpense(){
	}
	public JspPettycashExpense(PettycashExpense pettycashExpense){
		this.pettycashExpense = pettycashExpense;
	}

	public JspPettycashExpense(HttpServletRequest request, PettycashExpense pettycashExpense){
		super(new JspPettycashExpense(pettycashExpense), request);
		this.pettycashExpense = pettycashExpense;
	}

	public String getFormName() { return JSP_NAME_PETTYCASHEXPENSE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PettycashExpense getEntityObject(){ return pettycashExpense; }

	public void requestEntityObject(PettycashExpense pettycashExpense) {
		try{
			this.requestParam();
			pettycashExpense.setPettycashReplenishmentId(getLong(JSP_PETTYCASH_REPLENISHMENT_ID));
			pettycashExpense.setPettycashPaymentId(getLong(JSP_PETTYCASH_PAYMENT_ID));
			pettycashExpense.setAmount(getDouble(JSP_AMOUNT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
