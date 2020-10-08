package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.util.*;

public class JspSegmentDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SegmentDetail segmentDetail;

	public static final String JSP_NAME_SEGMENTDETAIL		=  "JSP_NAME_SEGMENTDETAIL" ;

	public static final int JSP_SEGMENT_DETAIL_ID		=  0 ;
	public static final int JSP_SEGMENT_ID			=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_REF_ID			=  3 ;
	public static final int JSP_CODE			=  4 ;
	public static final int JSP_LEVEL			=  5 ;
	public static final int JSP_TYPE			=  6 ;        
        public static final int JSP_LOCATION_ID			=  7 ;
        public static final int JSP_TYPE_SALES_REPORT           =  8 ;        
        public static final int JSP_REF_SEGMENT_DETAIL_ID       =  9 ;
        public static final int JSP_STATUS                      =  10 ;

	public static String[] colNames = {
		"JSP_SEGMENT_DETAIL_ID",  "JSP_SEGMENT_ID",
		"JSP_NAME",  "JSP_REF_ID",
		"JSP_CODE",  "JSP_LEVEL",                
		"JSP_TYPE", "JSP_LOCATION_ID",
                "JSP_TYPE_SALES_REPORT","JSP_REF_SEGMENT_DETAIL_ID",
                "JSP_STATUS"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED, TYPE_INT,
		TYPE_STRING, TYPE_LONG,
                TYPE_INT,TYPE_LONG,
                TYPE_INT
	} ;

	public JspSegmentDetail(){
	}
	public JspSegmentDetail(SegmentDetail segmentDetail){
		this.segmentDetail = segmentDetail;
	}

	public JspSegmentDetail(HttpServletRequest request, SegmentDetail segmentDetail){
		super(new JspSegmentDetail(segmentDetail), request);
		this.segmentDetail = segmentDetail;
	}

	public String getFormName() { return JSP_NAME_SEGMENTDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SegmentDetail getEntityObject(){ return segmentDetail; }

	public void requestEntityObject(SegmentDetail segmentDetail) {
		try{
			this.requestParam();
			segmentDetail.setSegmentId(getLong(JSP_SEGMENT_ID));
			segmentDetail.setName(getString(JSP_NAME));
			segmentDetail.setRefId(getLong(JSP_REF_ID));
			segmentDetail.setCode(getString(JSP_CODE));			
			segmentDetail.setType(getString(JSP_TYPE));
                        segmentDetail.setLocationId(getLong(JSP_LOCATION_ID));
                        segmentDetail.setTypeSalesReport(getInt(JSP_TYPE_SALES_REPORT ));
                        segmentDetail.setRefSegmentDetailId(getLong(JSP_REF_SEGMENT_DETAIL_ID ));
                        segmentDetail.setStatus(getInt(JSP_STATUS));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
