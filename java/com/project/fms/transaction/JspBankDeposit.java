/* 
 * Form Name  	:  JspBankDeposit.java 
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

/* project package */
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.*;


public class JspBankDeposit extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BankDeposit bankDeposit;

	public static final String JSP_NAME_BANKDEPOSIT		=  "JSP_NAME_BANKDEPOSIT" ;

	public static final int JSP_BANK_DEPOSIT_ID		=  0 ;
	public static final int JSP_MEMO			=  1 ;
	public static final int JSP_DATE			=  2 ;
	public static final int JSP_TRANS_DATE			=  3 ;
	public static final int JSP_OPERATOR_ID			=  4 ;
	public static final int JSP_OPERATOR_NAME		=  5 ;
	public static final int JSP_JOURNAL_NUMBER              =  6 ;
	public static final int JSP_JOURNAL_PREFIX		=  7 ;
	public static final int JSP_JOURNAL_COUNTER		=  8 ;
	public static final int JSP_COA_ID			=  9 ;
	public static final int JSP_AMOUNT			=  10 ;
	public static final int JSP_CURRENCY_ID			=  11 ;
        
        public static final int JSP_POSTED_STATUS		=  12 ;
        public static final int JSP_POSTED_BY_ID		=  13 ;
        public static final int JSP_POSTED_DATE			=  14 ;
        public static final int JSP_EFFECTIVE_DATE		=  15 ;
        public static final int JSP_CUSTOMER_ID                 =  16 ;
        
    public static final int JSP_SEGMENT1_ID   		=  17 ;    
    public static final int JSP_SEGMENT2_ID   		=  18 ; 
    public static final int JSP_SEGMENT3_ID   		=  19 ;    
    public static final int JSP_SEGMENT4_ID   		=  20 ;    
    public static final int JSP_SEGMENT5_ID   		=  21 ;   
    public static final int JSP_SEGMENT6_ID   		=  22 ;    
    public static final int JSP_SEGMENT7_ID   		=  23 ;    
    public static final int JSP_SEGMENT8_ID   		=  24 ;    
    public static final int JSP_SEGMENT9_ID   		=  25 ;    
    public static final int JSP_SEGMENT10_ID   		=  26 ;    
    public static final int JSP_SEGMENT11_ID   		=  27 ;    
    public static final int JSP_SEGMENT12_ID   		=  28 ;    
    public static final int JSP_SEGMENT13_ID   		=  29 ;    
    public static final int JSP_SEGMENT14_ID   		=  30 ;    
    public static final int JSP_SEGMENT15_ID   		=  31 ;    
    public static final int JSP_PERIODE_ID   		=  32 ;    
    public static final int JSP_RECEIVE_FROM   		=  33 ; 

	public static String[] colNames = {
		"JSP_BANK_DEPOSIT_ID",  "JSP_MEMO",
		"JSP_DATE",  "JSP_TRANS_DATE",
		"JSP_OPERATOR_ID",  "JSP_OPERATOR_NAME",
		"JSP_JOURNAL_NUMBER",  "JSP_JOURNAL_PREFIX",
		"JSP_JOURNAL_COUNTER",  "JSP_COA_ID",
		"JSP_AMOUNT",  "JSP_CURRENCY_ID",
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
                        "JSP_RECEIVE_FROM"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_DATE,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_INT,  TYPE_LONG,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_LONG,
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

	public JspBankDeposit(){
	}
	public JspBankDeposit(BankDeposit bankDeposit){
		this.bankDeposit = bankDeposit;
	}

	public JspBankDeposit(HttpServletRequest request, BankDeposit bankDeposit){
		super(new JspBankDeposit(bankDeposit), request);
		this.bankDeposit = bankDeposit;
	}

	public String getFormName() { return JSP_NAME_BANKDEPOSIT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BankDeposit getEntityObject(){ return bankDeposit; }

	public void requestEntityObject(BankDeposit bankDeposit) {
		try{
			this.requestParam();
			bankDeposit.setMemo(getString(JSP_MEMO));
			//bankDeposit.setDate(getDate(JSP_DATE));
			bankDeposit.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
			bankDeposit.setOperatorId(getLong(JSP_OPERATOR_ID));
			bankDeposit.setOperatorName(getString(JSP_OPERATOR_NAME));
			//bankDeposit.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			//bankDeposit.setJournalPrefix(getString(JSP_JOURNAL_PREFIX));
			//bankDeposit.setJournalCounter(getInt(JSP_JOURNAL_COUNTER));
			bankDeposit.setCoaId(getLong(JSP_COA_ID));
			bankDeposit.setAmount(getDouble(JSP_AMOUNT));
			bankDeposit.setCurrencyId(getLong(JSP_CURRENCY_ID));
                        
                        bankDeposit.setPostedStatus(getInt(JSP_POSTED_STATUS));
                        bankDeposit.setPostedById(getLong(JSP_POSTED_BY_ID));
                        bankDeposit.setPostedDate(getDate(JSP_POSTED_DATE));
                        bankDeposit.setEffectiveDate(getDate(JSP_EFFECTIVE_DATE));
                        bankDeposit.setCustomerId(getLong(JSP_CUSTOMER_ID));
                        
            bankDeposit.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            bankDeposit.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            bankDeposit.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            bankDeposit.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            bankDeposit.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            bankDeposit.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            bankDeposit.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            bankDeposit.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            bankDeposit.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            bankDeposit.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            bankDeposit.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            bankDeposit.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            bankDeposit.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            bankDeposit.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            bankDeposit.setSegment15Id(getLong(JSP_SEGMENT15_ID));             
            bankDeposit.setPeriodeId(getLong(JSP_PERIODE_ID));    
            bankDeposit.setReceiveFrom(getString(JSP_RECEIVE_FROM));    
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
