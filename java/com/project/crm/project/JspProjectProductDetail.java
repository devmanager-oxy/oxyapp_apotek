/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/7/2008 8:34:41 PM
\***********************************/

package com.project.crm.project;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspProjectProductDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

	private ProjectProductDetail projectProductDetail;

	public static final  String JSP_NAME_PROJECT_PRODUCT_DETAIL = "project_product_detail";

	public static final  int JSP_PROJECT_PRODUCT_DETAIL_ID = 0;
	public static final  int JSP_PROJECT_ID = 1;
	public static final  int JSP_CATEGORY_ID = 2;
	public static final  int JSP_ITEM_DESCRIPTION = 3;
	public static final  int JSP_SQUENCE = 4;
	public static final  int JSP_AMOUNT = 5;
	public static final  int JSP_STATUS = 6;
	public static final  int JSP_CURRENCY_ID = 7;
	public static final  int JSP_COMPANY_ID = 8;

	public static final  String[] colNames = {
		"x_project_product_detail_id",
		"x_project_id",
		"x_category_id",
		"x_item_description",
		"x_squence",
		"x_amount",
		"x_status",
		"x_currency_id",
		"x_company_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,
		TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG
	};

	public JspProjectProductDetail(){
	}

	public JspProjectProductDetail(ProjectProductDetail projectProductDetail) {
		this.projectProductDetail = projectProductDetail;
	}

	public JspProjectProductDetail(HttpServletRequest request, ProjectProductDetail projectProductDetail)
	{
		super(new JspProjectProductDetail(projectProductDetail), request);
		this.projectProductDetail = projectProductDetail;
	}

	public String getFormName() { return JSP_NAME_PROJECT_PRODUCT_DETAIL; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public ProjectProductDetail getEntityObject(){ return projectProductDetail; }

	public void requestEntityObject(ProjectProductDetail projectProductDetail) {
		try{
			this.requestParam();

			projectProductDetail.setProjectId(getLong(JSP_PROJECT_ID));
			projectProductDetail.setCategoryId(getLong(JSP_CATEGORY_ID));
			projectProductDetail.setItemDescription(getString(JSP_ITEM_DESCRIPTION));
			projectProductDetail.setSquence(getInt(JSP_SQUENCE));
			projectProductDetail.setAmount(getDouble(JSP_AMOUNT));
			projectProductDetail.setStatus(getInt(JSP_STATUS));
			projectProductDetail.setCurrencyId(getLong(JSP_CURRENCY_ID));
			projectProductDetail.setCompanyId(getLong(JSP_COMPANY_ID));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
