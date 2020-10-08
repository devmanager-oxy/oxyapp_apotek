
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspShipAddress extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ShipAddress shipAddress;

	public static final String JSP_NAME_SHIPADDRESS		=  "JSP_NAME_SHIPADDRESS" ;

	public static final int JSP_SHIP_ADDRESS_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_ADDRESS			=  2 ;

	public static String[] colNames = {
		"JSP_SHIP_ADDRESS_ID",  "JSP_NAME",
		"JSP_ADDRESS"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspShipAddress(){
	}
	public JspShipAddress(ShipAddress shipAddress){
		this.shipAddress = shipAddress;
	}

	public JspShipAddress(HttpServletRequest request, ShipAddress shipAddress){
		super(new JspShipAddress(shipAddress), request);
		this.shipAddress = shipAddress;
	}

	public String getFormName() { return JSP_NAME_SHIPADDRESS; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ShipAddress getEntityObject(){ return shipAddress; }

	public void requestEntityObject(ShipAddress shipAddress) {
		try{
			this.requestParam();
			shipAddress.setName(getString(JSP_NAME));
			shipAddress.setAddress(getString(JSP_ADDRESS));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
