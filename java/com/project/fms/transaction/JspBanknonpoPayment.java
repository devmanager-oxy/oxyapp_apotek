/* 
 * Form Name  	:  JspBanknonpoPayment.java 
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

public class JspBanknonpoPayment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BanknonpoPayment banknonpoPayment;

	public static final String JSP_NAME_BANKNONPOPAYMENT		=  "JSP_NAME_BANKNONPOPAYMENT" ;

	public static final int JSP_BANKNONPO_PAYMENT_ID	=  0 ;
	public static final int JSP_COA_ID			=  1 ;
	public static final int JSP_JOURNAL_NUMBER		=  2 ;
	public static final int JSP_JOURNAL_COUNTER		=  3 ;
	public static final int JSP_JOURNAL_PREFIX		=  4 ;
	public static final int JSP_DATE			=  5 ;
	public static final int JSP_TRANS_DATE			=  6 ;
	public static final int JSP_MEMO			=  7 ;
	public static final int JSP_OPERATOR_ID			=  8 ;
	public static final int JSP_OPERATOR_NAME		=  9 ;
	public static final int JSP_AMOUNT			=  10 ;
	public static final int JSP_REF_NUMBER			=  11 ;
        public static final int JSP_ACCOUNT_BALANCE		=  12 ;
        public static final int JSP_PAYMENT_METHOD_ID		=  13 ;
        
        public static final int JSP_VENDOR_ID			=  14 ;
        public static final int JSP_INVOICE_NUMBER		=  15 ;
        public static final int JSP_TYPE			=  16 ;
        
        public static final int JSP_POSTED_STATUS		=  17 ;
        public static final int JSP_POSTED_BY_ID		=  18 ;
        public static final int JSP_POSTED_DATE			=  19 ;
        public static final int JSP_EFFECTIVE_DATE		=  20 ;
        public static final int JSP_CUSTOMER_ID                 =  21 ;
        
    public static final int JSP_SEGMENT1_ID   		=  22 ;    
    public static final int JSP_SEGMENT2_ID   		=  23 ; 
    public static final int JSP_SEGMENT3_ID   		=  24 ;    
    public static final int JSP_SEGMENT4_ID   		=  25 ;    
    public static final int JSP_SEGMENT5_ID   		=  26 ;   
    public static final int JSP_SEGMENT6_ID   		=  27 ;    
    public static final int JSP_SEGMENT7_ID   		=  28 ;    
    public static final int JSP_SEGMENT8_ID   		=  29 ;    
    public static final int JSP_SEGMENT9_ID   		=  30 ;    
    public static final int JSP_SEGMENT10_ID   		=  31 ;    
    public static final int JSP_SEGMENT11_ID   		=  32 ;    
    public static final int JSP_SEGMENT12_ID   		=  33 ;    
    public static final int JSP_SEGMENT13_ID   		=  34 ;    
    public static final int JSP_SEGMENT14_ID   		=  35 ;    
    public static final int JSP_SEGMENT15_ID   		=  36 ;   
    
    public static final int JSP_PERIODE_ID   		=  37 ;   
    public static final int JSP_PAYMENT_TO   		=  38 ;   
        
	public static String[] colNames = {
		"JSP_BANKNONPO_PAYMENT_ID",  "JSP_COA_ID",
		"JSP_JOURNAL_NUMBER",  "JSP_JOURNAL_COUNTER",
		"JSP_JOURNAL_PREFIX",  "JSP_DATE",
		"JSP_TRANS_DATE",  "JSP_MEMO",
		"JSP_OPERATOR_ID",  "JSP_OPERATOR_NAME",
		"JSP_AMOUNT",  "JSP_REF_NUMBER",
                "JSP_ACCOUNT_BALANCE", "JSP_PAYMENT_METHOD_ID",
                "JSP_VENDOR_ID", "JSP_INVOICE_NUMBER",
                "JSP_TYPE",
                "JSP_POSTED_STATUS","JSP_POSTED_BY_ID",
                "JSP_POSTED_DATE","JSP_EFFECTIVE_DATE",
                "JSP_CUSTOMER_ID",
        
        "JSP_SEGMENT1_ID",
        "JSP_SEGMENT2_ID",
        "JSP_SEGMENT3_ID",
        "JSP_SEGMENT4_ID",
        "JSP_SEGMENT5_ID",
        "JSP_SEGMENT6_ID",
        "JSP_SEGMENT7_ID",
        "JSP_SEGMENT8_ID",
        "JSP_SEGMENT9_ID",
        "JSP_SEGMENT10_ID",
        "JSP_SEGMENT11_ID",
        "JSP_SEGMENT12_ID",
        "JSP_SEGMENT13_ID",
        "JSP_SEGMENT14_ID",
        "JSP_SEGMENT15_ID",
                "JSP_PERIODE_ID",
                "JSP_PAYMENT_TO"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING,  TYPE_DATE,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_STRING,
                TYPE_FLOAT, TYPE_LONG, 
                TYPE_LONG, TYPE_STRING,
                TYPE_INT,
                TYPE_INT, TYPE_LONG,
                TYPE_DATE, TYPE_DATE,TYPE_LONG,
		
		TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING
	} ;

	public JspBanknonpoPayment(){
	}
	public JspBanknonpoPayment(BanknonpoPayment banknonpoPayment){
		this.banknonpoPayment = banknonpoPayment;
	}

	public JspBanknonpoPayment(HttpServletRequest request, BanknonpoPayment banknonpoPayment){
		super(new JspBanknonpoPayment(banknonpoPayment), request);
		this.banknonpoPayment = banknonpoPayment;
	}

	public String getFormName() { return JSP_NAME_BANKNONPOPAYMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BanknonpoPayment getEntityObject(){ return banknonpoPayment; }

	public void requestEntityObject(BanknonpoPayment banknonpoPayment) {
		try{
			this.requestParam();
			banknonpoPayment.setCoaId(getLong(JSP_COA_ID));
			//banknonpoPayment.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			//banknonpoPayment.setJournalCounter(getInt(JSP_JOURNAL_COUNTER));
			//banknonpoPayment.setJournalPrefix(getString(JSP_JOURNAL_PREFIX));
			//banknonpoPayment.setDate(getDate(JSP_DATE));
			banknonpoPayment.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE),"dd/MM/yyyy"));
			banknonpoPayment.setMemo(getString(JSP_MEMO));
			banknonpoPayment.setOperatorId(getLong(JSP_OPERATOR_ID));
			banknonpoPayment.setOperatorName(getString(JSP_OPERATOR_NAME));
			banknonpoPayment.setAmount(getDouble(JSP_AMOUNT));
			banknonpoPayment.setRefNumber(getString(JSP_REF_NUMBER));
                        banknonpoPayment.setAccountBalance(getDouble(JSP_ACCOUNT_BALANCE));
                        banknonpoPayment.setPaymentMethodId(getLong(JSP_PAYMENT_METHOD_ID));
                        banknonpoPayment.setVendorId(getLong(JSP_VENDOR_ID));
                        banknonpoPayment.setInvoiceNumber(getString(JSP_INVOICE_NUMBER));
                        banknonpoPayment.setType(getInt(JSP_TYPE));
                        
                        banknonpoPayment.setPostedStatus(getInt(JSP_POSTED_STATUS));
                        banknonpoPayment.setPostedById(getLong(JSP_POSTED_BY_ID));
                        banknonpoPayment.setPostedDate(getDate(JSP_POSTED_DATE));
                        banknonpoPayment.setEffectiveDate(getDate(JSP_EFFECTIVE_DATE));
                        banknonpoPayment.setCustomerId(getLong(JSP_CUSTOMER_ID));
                        
            banknonpoPayment.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            banknonpoPayment.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            banknonpoPayment.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            banknonpoPayment.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            banknonpoPayment.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            banknonpoPayment.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            banknonpoPayment.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            banknonpoPayment.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            banknonpoPayment.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            banknonpoPayment.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            banknonpoPayment.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            banknonpoPayment.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            banknonpoPayment.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            banknonpoPayment.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            banknonpoPayment.setSegment15Id(getLong(JSP_SEGMENT15_ID));            
            
            banknonpoPayment.setPeriodeId(getLong(JSP_PERIODE_ID));       
            banknonpoPayment.setPaymentTo(getString(JSP_PAYMENT_TO)); 
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
