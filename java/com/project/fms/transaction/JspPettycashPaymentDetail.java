/* 
 * Form Name  	:  JspPettycashPaymentDetail.java 
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

public class JspPettycashPaymentDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PettycashPaymentDetail  pettycashPaymentDetail;

	public static final String JSP_NAME_PETTYCASHPAYMENTDETAIL		=  "JSP_NAME_PETTYCASHPAYMENTDETAIL" ;

	public static final int JSP_PETTYCASH_PAYMENT_ID	=  0 ;
	public static final int JSP_PETTYCASH_PAYMENT_DETAIL_ID	=  1 ;
	public static final int JSP_COA_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_MEMO			=  4 ;
        public static final int JSP_DEPARTMENT_ID		=  5 ;
        public static final int JSP_TYPE                        =  6 ;
        
    public static final int JSP_SEGMENT1_ID   		=  7 ;    
    public static final int JSP_SEGMENT2_ID   		=  8 ; 
    public static final int JSP_SEGMENT3_ID   		=  9 ;    
    public static final int JSP_SEGMENT4_ID   		=  10 ;    
    public static final int JSP_SEGMENT5_ID   		=  11 ;   
    public static final int JSP_SEGMENT6_ID   		=  12 ;    
    public static final int JSP_SEGMENT7_ID   		=  13 ;    
    public static final int JSP_SEGMENT8_ID   		=  14 ;    
    public static final int JSP_SEGMENT9_ID   		=  15 ;    
    public static final int JSP_SEGMENT10_ID   		=  16 ;    
    public static final int JSP_SEGMENT11_ID   		=  17 ;    
    public static final int JSP_SEGMENT12_ID   		=  18 ;    
    public static final int JSP_SEGMENT13_ID   		=  19 ;    
    public static final int JSP_SEGMENT14_ID   		=  20 ;    
    public static final int JSP_SEGMENT15_ID   		=  21 ;  
    	
    public static final int JSP_MODULE_ID   		=  22 ;  
    public static final int JSP_CREDIT_AMOUNT   		=  23 ;  	

	public static String[] colNames = {
		"detailJSP_PETTYCASH_PAYMENT_ID",  
                "detailJSP_PETTYCASH_PAYMENT_DETAIL_ID",
		"detailJSP_COA_ID",  
                "detailJSP_AMOUNT",
		"detailJSP_MEMO", 
                "detailJSP_DEPARTMENT_ID",
                "detailJSP_TYPE",
               
        "JSP_SEGMENT1_ID_DETAIL",
        "JSP_SEGMENT2_ID_DETAIL",
        "JSP_SEGMENT3_ID_DETAIL",
        "JSP_SEGMENT4_ID_DETAIL",
        "JSP_SEGMENT5_ID_DETAIL",
        "JSP_SEGMENT6_ID_DETAIL",
        "JSP_SEGMENT7_ID_DETAIL",
        "JSP_SEGMENT8_ID_DETAIL",
        "JSP_SEGMENT9_ID_DETAIL",
        "JSP_SEGMENT10_ID_DETAIL",
        "JSP_SEGMENT11_ID_DETAIL",
        "JSP_SEGMENT12_ID_DETAIL",
        "JSP_SEGMENT13_ID_DETAIL",
        "JSP_SEGMENT14_ID_DETAIL",
        "JSP_SEGMENT15_ID_DETAIL",
        
        "JSP_MODULE_ID",
        "JSP_CREDIT_AMOUNT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_FLOAT,
		TYPE_STRING, TYPE_LONG,
                TYPE_INT,
		
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
        TYPE_FLOAT  
	} ;

	public JspPettycashPaymentDetail(){
	}
	public JspPettycashPaymentDetail(PettycashPaymentDetail pettycashPaymentDetail){
		this.pettycashPaymentDetail = pettycashPaymentDetail;
	}

	public JspPettycashPaymentDetail(HttpServletRequest request, PettycashPaymentDetail pettycashPaymentDetail){
		super(new JspPettycashPaymentDetail(pettycashPaymentDetail), request);
		this.pettycashPaymentDetail = pettycashPaymentDetail;
	}

	public String getFormName() { return JSP_NAME_PETTYCASHPAYMENTDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PettycashPaymentDetail getEntityObject(){ return pettycashPaymentDetail; }

	public void requestEntityObject(PettycashPaymentDetail pettycashPaymentDetail) {
		try{
			this.requestParam();
			pettycashPaymentDetail.setPettycashPaymentId(getLong(JSP_PETTYCASH_PAYMENT_ID));
			pettycashPaymentDetail.setCoaId(getLong(JSP_COA_ID));
			pettycashPaymentDetail.setAmount(getDouble(JSP_AMOUNT));
			pettycashPaymentDetail.setMemo(getString(JSP_MEMO));
            pettycashPaymentDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
            pettycashPaymentDetail.setType(getInt(JSP_TYPE));
                        
            pettycashPaymentDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            pettycashPaymentDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            pettycashPaymentDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            pettycashPaymentDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            pettycashPaymentDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            pettycashPaymentDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            pettycashPaymentDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            pettycashPaymentDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            pettycashPaymentDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            pettycashPaymentDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            pettycashPaymentDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            pettycashPaymentDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            pettycashPaymentDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            pettycashPaymentDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            pettycashPaymentDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            
            pettycashPaymentDetail.setModuleId(getLong(JSP_MODULE_ID));
            pettycashPaymentDetail.setCreditAmount(getDouble(JSP_CREDIT_AMOUNT));
            
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
