/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy Andika
 */
public class JspKasOpname extends JSPHandler implements I_JSPInterface, I_JSPType {

        private KasOpname kasOpname;

	public static final String JSP_KAS_OPNAME		=  "JSP_KAS_OPNAME" ;

	public static final int JSP_KAS_OPNAME_ID		=  0 ;
	public static final int JSP_CURRENCY_ID			=  1 ;
	public static final int JSP_AMOUNT			=  2 ;
        public static final int JSP_QTY                         =  3 ;
        public static final int JSP_TYPE			=  4 ;
        public static final int JSP_MEMO			=  5 ;
        public static final int JSP_DATE_TRANSACTION		=  6 ;

	public static String[] colNames = {
		"JSP_KAS_OPNAME_ID",  
                "JSP_CURRENCY_ID",
		"JSP_AMOUNT",
                "JSP_QTY",
                "JSP_MEMO",
                "JSP_DATE_TRANSACTION"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG + ENTRY_REQUIRED,  
                TYPE_LONG,
		TYPE_FLOAT,
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING
	};

	public JspKasOpname(){
	}
	public JspKasOpname(KasOpname kasOpname){
		this.kasOpname = kasOpname;
	}

	public JspKasOpname(HttpServletRequest request, KasOpname kasOpname){
		super(new JspKasOpname(kasOpname), request);
		this.kasOpname = kasOpname;
	}

	public String getFormName() { return JSP_KAS_OPNAME; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public KasOpname getEntityObject(){ return kasOpname; }

	public void requestEntityObject(KasOpname kasOpname) {
		try{
			this.requestParam();
                        
			kasOpname.setCurrencyId(getLong(JSP_CURRENCY_ID));
			kasOpname.setAmount(getDouble(JSP_AMOUNT));
                        kasOpname.setQty(getInt(JSP_QTY));
                        kasOpname.setType(getInt(JSP_TYPE));
                        kasOpname.setMemo(getString(JSP_MEMO));
                        kasOpname.setDateTransaction(JSPFormater.formatDate(getString(JSP_DATE_TRANSACTION), "dd/MM/yyyy"));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
