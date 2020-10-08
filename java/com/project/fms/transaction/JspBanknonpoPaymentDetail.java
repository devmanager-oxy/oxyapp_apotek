/* 
 * Form Name  	:  JspBanknonpoPaymentDetail.java 
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

public class JspBanknonpoPaymentDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BanknonpoPaymentDetail banknonpoPaymentDetail;

	public static final String JSP_NAME_BANKNONPOPAYMENTDETAIL		=  "JSP_NAME_BANKNONPOPAYMENTDETAIL" ;

	public static final int JSP_BANKNONPO_PAYMENT_ID			=  0 ;
	public static final int JSP_BANKNONPO_PAYMENT_DETAIL_ID			=  1 ;
	public static final int JSP_COA_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_MEMO			=  4 ;
        
        public static final int JSP_FOREIGN_CURRENCY_ID			=  5 ;
        public static final int JSP_FOREIGN_AMOUNT			=  6 ;
        public static final int JSP_BOOKED_RATE			=  7 ;
        
        public static final int JSP_DEPARTMENT_ID			=  8 ;
        public static final int JSP_COA_ID_TEMP			=  9 ;
        public static final int JSP_COA_ID_TYPE			=  10 ;
        
    public static final int JSP_SEGMENT1_ID   		=  11 ;    
    public static final int JSP_SEGMENT2_ID   		=  12 ; 
    public static final int JSP_SEGMENT3_ID   		=  13 ;    
    public static final int JSP_SEGMENT4_ID   		=  14 ;    
    public static final int JSP_SEGMENT5_ID   		=  15 ;   
    public static final int JSP_SEGMENT6_ID   		=  16 ;    
    public static final int JSP_SEGMENT7_ID   		=  17 ;    
    public static final int JSP_SEGMENT8_ID   		=  18 ;    
    public static final int JSP_SEGMENT9_ID   		=  19 ;    
    public static final int JSP_SEGMENT10_ID   		=  20 ;    
    public static final int JSP_SEGMENT11_ID   		=  21 ;    
    public static final int JSP_SEGMENT12_ID   		=  22 ;    
    public static final int JSP_SEGMENT13_ID   		=  23 ;    
    public static final int JSP_SEGMENT14_ID   		=  24 ;    
    public static final int JSP_SEGMENT15_ID   		=  25 ;     
    public static final int JSP_MODULE_ID   		=  26 ; 
    public static final int JSP_COA_ID_ACT   		=  27 ; 	    

	public static String[] colNames = {
		"detailJSP_BANKNONPO_PAYMENT_ID",  "detailJSP_BANKNONPO_PAYMENT_DETAIL_ID",
		"detailJSP_COA_ID",  "detailJSP_AMOUNT",
		"detailJSP_MEMO", "detailJSP_FOREIGN_CURRENCY_ID",
                "detailJSP_FOREIGN_AMOUNT", "detailJSP_BOOKED_RATE",
                "detailJSP_DEPARTMENT_ID", "detailJSP_COA_ID_TEMP", "detailJSP_COA_ID_TYPE",
        
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
        "JSP_MODULE_ID",
        "detailJSP_COA_ID_ACT"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_STRING, TYPE_LONG + ENTRY_REQUIRED,
                TYPE_FLOAT + ENTRY_REQUIRED, TYPE_FLOAT + ENTRY_REQUIRED,
                TYPE_LONG, TYPE_LONG, TYPE_INT,
		
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
        TYPE_LONG
	} ;

	public JspBanknonpoPaymentDetail(){
	}
	public JspBanknonpoPaymentDetail(BanknonpoPaymentDetail banknonpoPaymentDetail){
		this.banknonpoPaymentDetail = banknonpoPaymentDetail;
	}

	public JspBanknonpoPaymentDetail(HttpServletRequest request, BanknonpoPaymentDetail banknonpoPaymentDetail){
		super(new JspBanknonpoPaymentDetail(banknonpoPaymentDetail), request);
		this.banknonpoPaymentDetail = banknonpoPaymentDetail;
	}

	public String getFormName() { return JSP_NAME_BANKNONPOPAYMENTDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BanknonpoPaymentDetail getEntityObject(){ return banknonpoPaymentDetail; }

	public void requestEntityObject(BanknonpoPaymentDetail banknonpoPaymentDetail) {
		try{
			
			System.out.println("\n\n============== jsp bank non po detail =============");
			
			this.requestParam();
			banknonpoPaymentDetail.setBanknonpoPaymentId(getLong(JSP_BANKNONPO_PAYMENT_ID));
			banknonpoPaymentDetail.setCoaId(getLong(JSP_COA_ID));
            banknonpoPaymentDetail.setCoaIdTemp(getLong(JSP_COA_ID_TEMP));
            banknonpoPaymentDetail.setCoaIdAct(getLong(JSP_COA_ID_ACT));
            banknonpoPaymentDetail.setType(getInt(JSP_COA_ID_TYPE));
			banknonpoPaymentDetail.setAmount(getDouble(JSP_AMOUNT));
			banknonpoPaymentDetail.setMemo(getString(JSP_MEMO));
                        
            banknonpoPaymentDetail.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            banknonpoPaymentDetail.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            banknonpoPaymentDetail.setBookedRate(getDouble(JSP_BOOKED_RATE));
            
            banknonpoPaymentDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
                        
            banknonpoPaymentDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            banknonpoPaymentDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            banknonpoPaymentDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            banknonpoPaymentDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            banknonpoPaymentDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            banknonpoPaymentDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            banknonpoPaymentDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            banknonpoPaymentDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            banknonpoPaymentDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            banknonpoPaymentDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            banknonpoPaymentDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            banknonpoPaymentDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            banknonpoPaymentDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            banknonpoPaymentDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            banknonpoPaymentDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));             
            banknonpoPaymentDetail.setModuleId(getLong(JSP_MODULE_ID));             	
                                    
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
