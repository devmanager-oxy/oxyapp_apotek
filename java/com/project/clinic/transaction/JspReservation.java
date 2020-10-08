package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspReservation extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Reservation reservation;

	public static final String JSP_NAME_RESERVATION		=  "JSP_NAME_RESERVATION" ;

	public static final int JSP_FIELD_RESERVATION_ID			=  0 ;
	public static final int JSP_FIELD_REG_DATE			=  1 ;
	public static final int JSP_FIELD_PATIENT_ID			=  2 ;
	public static final int JSP_FIELD_QUEUE_NUMBER			=  3 ;
	public static final int JSP_FIELD_DOCTOR_ID			=  4 ;
	public static final int JSP_FIELD_QUEUE_TIME			=  5 ;
	public static final int JSP_FIELD_STATUS			=  6 ;
	public static final int JSP_FIELD_DESCRIPTION			=  7 ;
	public static final int JSP_FIELD_ADMIN_ID			=  8 ;
        public static final int JSP_FIELD_QUEUE_TIME_hh			=  9 ;
        public static final int JSP_FIELD_QUEUE_TIME_mm			=  10 ;

	public static String[] colNames = {
		"JSP_FIELD_RESERVATION_ID",  "JSP_FIELD_REG_DATE",
		"JSP_FIELD_PATIENT_ID",  "JSP_FIELD_QUEUE_NUMBER",
		"JSP_FIELD_DOCTOR_ID",  "JSP_FIELD_QUEUE_TIME",
		"JSP_FIELD_STATUS",  "JSP_FIELD_DESCRIPTION",
		"JSP_FIELD_ADMIN_ID", "JSP_FIELD_QUEUE_TIME_hh",
                "JSP_FIELD_QUEUE_TIME_mm"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_INT + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_DATE,
		TYPE_INT,  TYPE_STRING,
		TYPE_LONG + ENTRY_REQUIRED, TYPE_INT,
                TYPE_INT
	} ;

	public JspReservation(){
	}
	public JspReservation(Reservation reservation){
		this.reservation = reservation;
	}

	public JspReservation(HttpServletRequest request, Reservation reservation){
		super(new JspReservation(reservation), request);
		this.reservation = reservation;
	}

	public String getFormName() { return JSP_NAME_RESERVATION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Reservation getEntityObject(){ return reservation; }

	public void requestEntityObject(Reservation reservation) {
		try{
			this.requestParam();
			reservation.setRegDate(JSPFormater.formatDate(getString(JSP_FIELD_REG_DATE),"dd/MM/yyyy"));
			reservation.setPatientId(getLong(JSP_FIELD_PATIENT_ID));
			reservation.setQueueNumber(getInt(JSP_FIELD_QUEUE_NUMBER));
			reservation.setDoctorId(getLong(JSP_FIELD_DOCTOR_ID));
                        
                        int hh = getInt(JSP_FIELD_QUEUE_TIME_hh);
                        int mm = getInt(JSP_FIELD_QUEUE_TIME_mm);
                        
                        Date dt = new Date();
                        dt.setHours(hh);
                        dt.setMinutes(mm);
                        
			reservation.setQueueTime(dt);//getDate(JSP_FIELD_QUEUE_TIME));
			reservation.setStatus(getInt(JSP_FIELD_STATUS));
			reservation.setDescription(getString(JSP_FIELD_DESCRIPTION));
			reservation.setAdminId(getLong(JSP_FIELD_ADMIN_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
