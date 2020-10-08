package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspApprovalDoc extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ApprovalDoc approvalDoc;

	public static final String JSP_NAME_APPROVALDOC		=  "JSP_NAME_APPROVALDOC" ;

	public static final int JSP_APPROVAL_DOC_ID			=  0 ;
	public static final int JSP_APPROVAL_ID			=  1 ;
	public static final int JSP_DOC_ID			=  2 ;
	public static final int JSP_STATUS			=  3 ;
	public static final int JSP_NOTES			=  4 ;
	public static final int JSP_APPROVE_DATE			=  5 ;
	public static final int JSP_EMPLOYEE_ID			=  6 ;
	public static final int JSP_DOC_TYPE			=  7 ;

	public static String[] colNames = {
		"JSP_APPROVAL_DOC_ID",  "JSP_APPROVAL_ID",
		"JSP_DOC_ID",  "JSP_STATUS",
		"JSP_NOTES",  "JSP_APPROVE_DATE",
		"JSP_EMPLOYEE_ID",  "JSP_DOC_TYPE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_INT,
		TYPE_STRING,  TYPE_DATE,
		TYPE_LONG,  TYPE_INT
	} ;

	public JspApprovalDoc(){
	}
	public JspApprovalDoc(ApprovalDoc approvalDoc){
		this.approvalDoc = approvalDoc;
	}

	public JspApprovalDoc(HttpServletRequest request, ApprovalDoc approvalDoc){
		super(new JspApprovalDoc(approvalDoc), request);
		this.approvalDoc = approvalDoc;
	}

	public String getFormName() { return JSP_NAME_APPROVALDOC; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ApprovalDoc getEntityObject(){ return approvalDoc; }

	public void requestEntityObject(ApprovalDoc approvalDoc) {
		try{
			this.requestParam();
			approvalDoc.setApprovalId(getLong(JSP_APPROVAL_ID));
			approvalDoc.setDocId(getLong(JSP_DOC_ID));
			approvalDoc.setStatus(getInt(JSP_STATUS));
			approvalDoc.setNotes(getString(JSP_NOTES));
			approvalDoc.setApproveDate(getDate(JSP_APPROVE_DATE));
			approvalDoc.setEmployeeId(getLong(JSP_EMPLOYEE_ID));
			approvalDoc.setDocType(getInt(JSP_DOC_TYPE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
