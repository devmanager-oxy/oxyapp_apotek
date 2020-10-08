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


public class JspTransactionActivityDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TransactionActivityDetail transactionActivityDetail;

	public static final String JSP_NAME_TRANSACTIONACTIVITYDETAIL		=  "JSP_NAME_TRANSACTIONACTIVITYDETAIL" ;

	public static final int JSP_TRANSACTION_ACTIVITY_DETAIL_ID			=  0 ;
	public static final int JSP_PERCENT			=  1 ;
	public static final int JSP_AMOUNT			=  2 ;
	public static final int JSP_TRANSACTION_ID		=  3 ;
	public static final int JSP_IS_DIRECT			=  4 ;
	public static final int JSP_COA_ID			=  5 ;
	public static final int JSP_TYPE			=  6 ;
	public static final int JSP_MODULE_ID			=  7 ;
	public static final int JSP_DONOR_ID			=  8 ;
        public static final int JSP_MEMO			=  9 ;
        
        public static final int JSP_COA_EXPENSE_CATEGORY_ID                             =  10 ;
        public static final int JSP_COA_NATURE_EXPENSE_CATEGORY_ID			=  11 ;
        
        public static String[] colNames = {
		"JSP_TRANSACTION_ACTIVITY_DETAIL_ID",  
                "JSP_PERCENT",
		"JSP_AMOUNT", 
		"JSP_TRANSACTION_ID",
		"JSP_IS_DIRECT",  
                "JSP_COA_ID",
		"JSP_TYPE",  
		"JSP_MODULE_ID",  
                "JSP_DONOR_ID",
                "JSP_MEMO",
                "JSP_COA_EXPENSE_CATEGORY_ID",
                "JSP_COA_NATURE_EXPENSE_CATEGORY_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_FLOAT,
		TYPE_FLOAT + ENTRY_REQUIRED,  
                TYPE_LONG,
		TYPE_INT,  
                TYPE_LONG,
		TYPE_INT,  
                TYPE_LONG,  
                TYPE_LONG,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG
	} ;

	public JspTransactionActivityDetail(){
	}
	public JspTransactionActivityDetail(TransactionActivityDetail transactionActivityDetail){
		this.transactionActivityDetail = transactionActivityDetail;
	}

	public JspTransactionActivityDetail(HttpServletRequest request, TransactionActivityDetail transactionActivityDetail){
		super(new JspTransactionActivityDetail(transactionActivityDetail), request);
		this.transactionActivityDetail = transactionActivityDetail;
	}

	public String getFormName() { return JSP_NAME_TRANSACTIONACTIVITYDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TransactionActivityDetail getEntityObject(){ return transactionActivityDetail; }

	public void requestEntityObject(TransactionActivityDetail transactionActivityDetail) {
		try{
			this.requestParam();
			transactionActivityDetail.setPercent(getDouble(JSP_PERCENT));
			transactionActivityDetail.setAmount(getDouble(JSP_AMOUNT));
			transactionActivityDetail.setTransactionId(getLong(JSP_TRANSACTION_ID));
			transactionActivityDetail.setIsDirect(getInt(JSP_IS_DIRECT));
			transactionActivityDetail.setCoaId(getLong(JSP_COA_ID));
			transactionActivityDetail.setType(getInt(JSP_TYPE));
			transactionActivityDetail.setModuleId(getLong(JSP_MODULE_ID));
			transactionActivityDetail.setDonorId(getLong(JSP_DONOR_ID));
                        transactionActivityDetail.setMemo(getString(JSP_MEMO));
                        
                        transactionActivityDetail.setCoaExpenseCategoryId(getLong(JSP_COA_EXPENSE_CATEGORY_ID));
                        transactionActivityDetail.setCoaNatureExpenseCategoryId(getLong(JSP_COA_NATURE_EXPENSE_CATEGORY_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
