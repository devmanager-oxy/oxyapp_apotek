package com.project.ccs.postransaction.memberpoint;

import javax.servlet.http.*;
import com.project.util.jsp.*;
import java.util.*; 

public class JspMemberPoint extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private MemberPoint memberPoint;

	public static final String JSP_NAME_MEMBERPOINT		=  "JSP_NAME_MEMBERPOINT" ;

	public static final int JSP_FIELD_MEMBER_POINT_ID	=  0 ;
	public static final int JSP_FIELD_CUSTOMER_ID		=  1 ;
	public static final int JSP_FIELD_DATE			=  2 ;
	public static final int JSP_FIELD_POINT			=  3 ;
	public static final int JSP_FIELD_IN_OUT		=  4 ;
	public static final int JSP_FIELD_TYPE			=  5 ;
	public static final int JSP_FIELD_POINT_UNIT_VALUE	=  6 ;
	public static final int JSP_FIELD_SALES_ID		=  7 ;
        public static final int JSP_FIELD_GROUP_TYPE		=  8 ;
        public static final int JSP_FIELD_ITEM_GROUP_ID		=  9 ;
        public static final int JSP_POSTED_STATUS		=  10 ;
        public static final int JSP_POSTED_BY_ID		=  11 ;
        public static final int JSP_POSTED_DATE			=  12 ;

	public static String[] colNames = {
		"JSP_FIELD_MEMBER_POINT_ID",  "JSP_FIELD_CUSTOMER_ID",
		"JSP_FIELD_DATE",  "JSP_FIELD_POINT",
		"JSP_FIELD_IN_OUT",  "JSP_FIELD_TYPE",
		"JSP_FIELD_POINT_UNIT_VALUE",  "JSP_FIELD_SALES_ID",
                "JSP_FIELD_GROUP_TYPE", "JSP_FIELD_ITEM_GROUP_ID",
                "JSP_POSTED_STATUS","JSP_POSTED_BY_ID",
                "JSP_POSTED_DATE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_DATE,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_INT,
		TYPE_FLOAT,  TYPE_LONG,
                TYPE_INT, TYPE_LONG,
                TYPE_INT,TYPE_LONG,
                TYPE_DATE
	} ;

	public JspMemberPoint(){
	}
	public JspMemberPoint(MemberPoint memberPoint){
		this.memberPoint = memberPoint;
	}

	public JspMemberPoint(HttpServletRequest request, MemberPoint memberPoint){
		super(new JspMemberPoint(memberPoint), request);
		this.memberPoint = memberPoint;
	}

	public String getFormName() { return JSP_NAME_MEMBERPOINT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public MemberPoint getEntityObject(){ return memberPoint; }

	public void requestEntityObject(MemberPoint memberPoint) {
		try{
			this.requestParam();
			memberPoint.setCustomerId(getLong(JSP_FIELD_CUSTOMER_ID));
			memberPoint.setDate(getDate(JSP_FIELD_DATE));
			memberPoint.setPoint(getDouble(JSP_FIELD_POINT));
			memberPoint.setInOut(getInt(JSP_FIELD_IN_OUT));
			memberPoint.setType(getInt(JSP_FIELD_TYPE));
			memberPoint.setPointUnitValue(getDouble(JSP_FIELD_POINT_UNIT_VALUE));
			memberPoint.setSalesId(getLong(JSP_FIELD_SALES_ID));
                        memberPoint.setgroupType(getInt(JSP_FIELD_GROUP_TYPE));
                        memberPoint.setItemGroupId(getLong(JSP_FIELD_ITEM_GROUP_ID));
                        memberPoint.setPostedStatus(getInt(JSP_POSTED_STATUS));
                        memberPoint.setPostedById(getLong(JSP_POSTED_BY_ID));
                        memberPoint.setPostedDate(getDate(JSP_POSTED_DATE));                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
