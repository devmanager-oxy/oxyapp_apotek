/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/6/2008 3:12:12 PM
\***********************************/

package com.project.crm.project;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspProjectTerm extends JSPHandler implements I_JSPInterface, I_JSPType {

	private ProjectTerm projectTerm;

	public static final  String JSP_NAME_PROJECT_TERM = "project_term";

	public static final  int JSP_PROJECT_TERM_ID = 0;
	public static final  int JSP_PROJECT_ID = 1;
	public static final  int JSP_SQUENCE = 2;
	public static final  int JSP_TYPE = 3;
	public static final  int JSP_DESCRIPTION = 4;
	public static final  int JSP_STATUS = 5;
	public static final  int JSP_AMOUNT = 6;
	public static final  int JSP_CURRENCY_ID = 7;
	public static final  int JSP_COMPANY_ID = 8;
	public static final  int JSP_DUE_DATE = 9;

	public static final  String[] colNames = {
		"x_project_term_id",
		"x_project_id",
		"x_squence",
		"x_type",
		"x_description",
		"x_status",
		"x_amount",
		"x_currency_id",
		"x_company_id",
		"x_due_date"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_INT,
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,
		TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED
	};

	public JspProjectTerm(){
	}

	public JspProjectTerm(ProjectTerm projectTerm) {
		this.projectTerm = projectTerm;
	}

	public JspProjectTerm(HttpServletRequest request, ProjectTerm projectTerm)
	{
		super(new JspProjectTerm(projectTerm), request);
		this.projectTerm = projectTerm;
	}

	public String getFormName() { return JSP_NAME_PROJECT_TERM; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public ProjectTerm getEntityObject(){ return projectTerm; }

	public void requestEntityObject(ProjectTerm projectTerm) {
		try{
			this.requestParam();

			projectTerm.setProjectId(getLong(JSP_PROJECT_ID));
			projectTerm.setSquence(getInt(JSP_SQUENCE));
			projectTerm.setType(getInt(JSP_TYPE));
			projectTerm.setDescription(getString(JSP_DESCRIPTION));
			projectTerm.setStatus(getInt(JSP_STATUS));
			projectTerm.setAmount(getDouble(JSP_AMOUNT));
			projectTerm.setCurrencyId(getLong(JSP_CURRENCY_ID));
			projectTerm.setCompanyId(getLong(JSP_COMPANY_ID));
			projectTerm.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE),"dd/MM/yyyy"));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
