package com.project.ccs.postransaction.memberpoint;

import com.project.util.JSPFormater;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import java.util.*; 

public class JspMemberPointSetup extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private MemberPointSetup memberPointSetup;

	public static final String JSP_NAME_MEMBERPOINTSETUP		=  "JSP_NAME_MEMBERPOINTSETUP" ;

	public static final int JSP_FIELD_MEMBER_POINT_SETUP_ID			=  0 ;
	public static final int JSP_FIELD_GROUP_TYPE			=  1 ;
	public static final int JSP_FIELD_AMOUNT			=  2 ;
	public static final int JSP_FIELD_POINT			=  3 ;
	public static final int JSP_FIELD_USER_ID			=  4 ;
	public static final int JSP_FIELD_DATE			=  5 ;
	public static final int JSP_FIELD_LAST_UPDATE_DATE			=  6 ;
	public static final int JSP_FIELD_STATUS			=  7 ;
	public static final int JSP_FIELD_POINT_UNIT_VALUE			=  8 ;
	public static final int JSP_FIELD_START_DATE			=  9 ;
	public static final int JSP_FIELD_END_DATE			=  10 ;
	public static final int JSP_FIELD_AMOUNT_ROUNDING			=  11 ;
	public static final int JSP_FIELD_MIN_ROUDING			=  12 ;
        public static final int JSP_FIELD_ITEM_GROUP_ID			=  13 ;
        
	public static String[] colNames = {
		"JSP_FIELD_MEMBER_POINT_SETUP_ID",  "JSP_FIELD_GROUP_TYPE",
		"JSP_FIELD_AMOUNT",  "JSP_FIELD_POINT",
		"JSP_FIELD_USER_ID",  "JSP_FIELD_DATE",
		"JSP_FIELD_LAST_UPDATE_DATE",  "JSP_FIELD_STATUS",
		"JSP_FIELD_POINT_UNIT_VALUE",  "JSP_FIELD_START_DATE",
		"JSP_FIELD_END_DATE",  "JSP_FIELD_AMOUNT_ROUNDING",
		"JSP_FIELD_MIN_ROUDING", "JSP_FIELD_ITEM_GROUP_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_INT,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_DATE,
		TYPE_DATE,  TYPE_INT,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_FLOAT, TYPE_LONG
	} ;

	public JspMemberPointSetup(){
	}
	public JspMemberPointSetup(MemberPointSetup memberPointSetup){
		this.memberPointSetup = memberPointSetup;
	}

	public JspMemberPointSetup(HttpServletRequest request, MemberPointSetup memberPointSetup){
		super(new JspMemberPointSetup(memberPointSetup), request);
		this.memberPointSetup = memberPointSetup;
	}

	public String getFormName() { return JSP_NAME_MEMBERPOINTSETUP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public MemberPointSetup getEntityObject(){ return memberPointSetup; }

	public void requestEntityObject(MemberPointSetup memberPointSetup) {
		try{
			this.requestParam();
			memberPointSetup.setGroupType(getInt(JSP_FIELD_GROUP_TYPE));
			memberPointSetup.setAmount(getDouble(JSP_FIELD_AMOUNT));
			memberPointSetup.setPoint(getDouble(JSP_FIELD_POINT));
			//memberPointSetup.setUserId(getLong(JSP_FIELD_USER_ID));
			//memberPointSetup.setDate(getDate(JSP_FIELD_DATE));
			//memberPointSetup.setLastUpdateDate(getDate(JSP_FIELD_LAST_UPDATE_DATE));
			memberPointSetup.setStatus(getInt(JSP_FIELD_STATUS));
			memberPointSetup.setPointUnitValue(getDouble(JSP_FIELD_POINT_UNIT_VALUE));
			memberPointSetup.setStartDate(JSPFormater.formatDate(getString(JSP_FIELD_START_DATE),"dd/MM/yyyy"));
			memberPointSetup.setEndDate(JSPFormater.formatDate(getString(JSP_FIELD_END_DATE),"dd/MM/yyyy"));
			memberPointSetup.setAmountRounding(getInt(JSP_FIELD_AMOUNT_ROUNDING));
			memberPointSetup.setMinRouding(getDouble(JSP_FIELD_MIN_ROUDING));
                        memberPointSetup.setItemGroupId(getLong(JSP_FIELD_ITEM_GROUP_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
