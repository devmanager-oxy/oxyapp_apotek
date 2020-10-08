package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.admin.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class JspUserPriv extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private UserPriv userPriv;

	public static final String JSP_NAME_USERPRIV		=  "JSP_NAME_USERPRIV" ;

	public static final int JSP_PRIV_ID			=  0 ;
	public static final int JSP_MN_1			=  1 ;
	public static final int JSP_MN_2			=  2 ;
	public static final int JSP_CMD_ADD			=  3 ;
	public static final int JSP_CMD_EDIT			=  4 ;
	public static final int JSP_CMD_VIEW			=  5 ;
	public static final int JSP_CMD_DELETE			=  6 ;
	public static final int JSP_GROUP_ID			=  7 ;
	public static final int JSP_USER_ID			=  8 ;

	public static String[] colNames = {
		"JSP_PRIV_ID",  "JSP_MN_1",
		"JSP_MN_2",  "JSP_CMD_ADD",
		"JSP_CMD_EDIT",  "JSP_CMD_VIEW",
		"JSP_CMD_DELETE",  "JSP_GROUP_ID",
		"JSP_USER_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_INT,
		TYPE_INT,  TYPE_INT,
		TYPE_INT,  TYPE_INT,
		TYPE_INT,  TYPE_LONG,
		TYPE_LONG
	} ;

	public JspUserPriv(){
	}
	public JspUserPriv(UserPriv userPriv){
		this.userPriv = userPriv;
	}

	public JspUserPriv(HttpServletRequest request, UserPriv userPriv){
		super(new JspUserPriv(userPriv), request);
		this.userPriv = userPriv;
	}

	public String getFormName() { return JSP_NAME_USERPRIV; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public UserPriv getEntityObject(){ return userPriv; }

	public void requestEntityObject(UserPriv userPriv) {
		try{
			this.requestParam();
			userPriv.setMn1(getInt(JSP_MN_1));
			userPriv.setMn2(getInt(JSP_MN_2));
			userPriv.setCmdAdd(getInt(JSP_CMD_ADD));
			userPriv.setCmdEdit(getInt(JSP_CMD_EDIT));
			userPriv.setCmdView(getInt(JSP_CMD_VIEW));
			userPriv.setCmdDelete(getInt(JSP_CMD_DELETE));
			userPriv.setGroupId(getLong(JSP_GROUP_ID));
			userPriv.setUserId(getLong(JSP_USER_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
