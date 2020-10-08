
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspCoa_1 extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Coa coa;

	public static final String JSP_NAME_COA		=  "coa" ;
        
        public static final int JSP_IS_NEED_EXTRA                   = 0;
        public static final int JSP_DEBET_PREFIX_CODE               = 1;
        public static final int JSP_CREDIT_PREFIX_CODE              = 2;        
        
	public static String[] colNames = {		
                "JSP_IS_NEED_EXTRA", "JSP_DEBET_PREFIX_CODE",
                "JSP_CREDIT_PREFIX_CODE"
	} ;

	public static int[] fieldTypes = {		               
                TYPE_INT, TYPE_STRING,
                TYPE_STRING                
	} ;

	public JspCoa_1(){
	}
	public JspCoa_1(Coa coa){
		this.coa = coa;
	}

	public JspCoa_1(HttpServletRequest request, Coa coa){
		super(new JspCoa_1(coa), request);
		this.coa = coa;
	}

	public String getFormName() { return JSP_NAME_COA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Coa getEntityObject(){ return coa; }

	public void requestEntityObject(Coa coa) {
		try{
			this.requestParam();
                        coa.setIsNeedExtra(getInt(JSP_IS_NEED_EXTRA));
                        coa.setDebetPrefixCode(getString(JSP_DEBET_PREFIX_CODE));
                        coa.setCreditPrefixCode(getString(JSP_CREDIT_PREFIX_CODE));                        
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
