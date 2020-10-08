/* 
 * Form Name  	:  JspBankpoPaymentDetail.java 
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
import com.project.util.*;

public class JspBankpoPaymentDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BankpoPaymentDetail bankpoPaymentDetail;

	public static final String JSP_NAME_BANKPOPAYMENTDETAIL		=  "JSP_NAME_BANKPOPAYMENTDETAIL" ;

	public static final int JSP_BANKPO_PAYMENT_ID		=  0 ;
	public static final int JSP_BANKPO_PAYMENT_DETAIL_ID	=  1 ;
	public static final int JSP_COA_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_MEMO			=  4 ;
	public static final int JSP_PURCHASE_ID			=  5 ;
	public static final int JSP_CURRENCY_ID			=  6 ;
	public static final int JSP_BOOKED_RATE			=  7 ;
	public static final int JSP_PO_AMOUNT			=  8 ;
	public static final int JSP_PAYMENT_AMOUNT		=  9 ;        
        public static final int JSP_DEPARTMENT_ID		=  10 ;  
        public static final int JSP_MODULE_ID			=  11 ;     	
        public static final int JSP_SEGMENT1_ID   		=  12 ;    
        public static final int JSP_SEGMENT2_ID   		=  13 ; 
        public static final int JSP_SEGMENT3_ID   		=  14 ;    
        public static final int JSP_SEGMENT4_ID   		=  15 ;    
        public static final int JSP_SEGMENT5_ID   		=  16 ;   
        public static final int JSP_SEGMENT6_ID   		=  17 ;    
        public static final int JSP_SEGMENT7_ID   		=  18 ;    
        public static final int JSP_SEGMENT8_ID   		=  19 ;    
        public static final int JSP_SEGMENT9_ID   		=  20 ;    
        public static final int JSP_SEGMENT10_ID   		=  21 ;    
        public static final int JSP_SEGMENT11_ID   		=  22 ;    
        public static final int JSP_SEGMENT12_ID   		=  23 ;    
        public static final int JSP_SEGMENT13_ID   		=  24 ;    
        public static final int JSP_SEGMENT14_ID   		=  25 ;    
        public static final int JSP_SEGMENT15_ID   		=  26 ;     	 	
        public static final int JSP_DEDUCTION   		=  27 ;   
        public static final int JSP_ARAP_MEMO_ID   		=  28 ;   
        public static final int JSP_VENDOR_ID   		=  29 ;   
    	     

	public static String[] colNames = {
		"detailJSP_BANKPO_PAYMENT_ID",  "detailJSP_BANKPO_PAYMENT_DETAIL_ID",
		"detailJSP_COA_ID",  "detailJSP_AMOUNT",
		"detailJSP_MEMO",  "detailJSP_PURCHASE_ID",
		"detailJSP_CURRENCY_ID",  "detailJSP_BOOKED_RATE",
		"detailJSP_PO_AMOUNT",  "detailJSP_PAYMENT_AMOUNT",
                "DJSP_DEPARTMENT_ID", "JSP_MODULE_ID",
                "JSP_SEGMENT1_DETAIL_ID",
                "JSP_SEGMENT2_DETAIL_ID",
                "JSP_SEGMENT3_DETAIL_ID",
                "JSP_SEGMENT4_DETAIL_ID",
                "JSP_SEGMENT5_DETAIL_ID",
                "JSP_SEGMENT6_DETAIL_ID",
                "JSP_SEGMENT7_DETAIL_ID",
                "JSP_SEGMENT8_DETAIL_ID",
                "JSP_SEGMENT9_DETAIL_ID",
                "JSP_SEGMENT10_DETAIL_ID",
                "JSP_SEGMENT11_DETAIL_ID",
                "JSP_SEGMENT12_DETAIL_ID",
                "JSP_SEGMENT13_DETAIL_ID",
                "JSP_SEGMENT14_DETAIL_ID",
                "JSP_SEGMENT15_DETAIL_ID",
                "JSP_DEDUCTION",
                "detailJSP_ARAP_MEMO_ID",
                "detailJSP_VENDOR_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_LONG,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
                TYPE_LONG + ENTRY_REQUIRED,
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
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG
	} ;

	public JspBankpoPaymentDetail(){
	}
	public JspBankpoPaymentDetail(BankpoPaymentDetail bankpoPaymentDetail){
		this.bankpoPaymentDetail = bankpoPaymentDetail;
	}

	public JspBankpoPaymentDetail(HttpServletRequest request, BankpoPaymentDetail bankpoPaymentDetail){
		super(new JspBankpoPaymentDetail(bankpoPaymentDetail), request);
		this.bankpoPaymentDetail = bankpoPaymentDetail;
	}

	public String getFormName() { return JSP_NAME_BANKPOPAYMENTDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BankpoPaymentDetail getEntityObject(){ return bankpoPaymentDetail; }

	public void requestEntityObject(BankpoPaymentDetail bankpoPaymentDetail) {
		try{
			this.requestParam();
			bankpoPaymentDetail.setBankpoPaymentId(getLong(JSP_BANKPO_PAYMENT_ID));
			bankpoPaymentDetail.setCoaId(getLong(JSP_COA_ID));			
			bankpoPaymentDetail.setMemo(getString(JSP_MEMO));			
			bankpoPaymentDetail.setBookedRate(getDouble(JSP_BOOKED_RATE));			
			bankpoPaymentDetail.setPaymentAmount(getDouble(JSP_PAYMENT_AMOUNT));                        
                        bankpoPaymentDetail.setModuleId(getLong(JSP_MODULE_ID));            
                        bankpoPaymentDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
                        bankpoPaymentDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
                        bankpoPaymentDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
                        bankpoPaymentDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
                        bankpoPaymentDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
                        bankpoPaymentDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
                        bankpoPaymentDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
                        bankpoPaymentDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
                        bankpoPaymentDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
                        bankpoPaymentDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
                        bankpoPaymentDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
                        bankpoPaymentDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
                        bankpoPaymentDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
                        bankpoPaymentDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
                        bankpoPaymentDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));   
                        bankpoPaymentDetail.setDeduction(getDouble(JSP_DEDUCTION));   
                        bankpoPaymentDetail.setArapMemoId(getLong(JSP_ARAP_MEMO_ID));   
                        bankpoPaymentDetail.setVendorId(getLong(JSP_VENDOR_ID));
            
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
