/* 
 * Form Name  	:  JspPurchaseItemShare.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.*;

public class JspPurchaseItemShare extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PurchaseItemShare purchaseItemShare;

	public static final String JSP_NAME_PURCHASEITEM		=  "JSP_NAME_PURCHASEITEM" ;

	public static final  int JSP_PURCHASE_ITEM_SHARE_ID = 0;
	public static final  int JSP_PURCHASE_ITEM_ID = 1;
	public static final  int JSP_PERCENT = 2;
	public static final  int JSP_AMOUNT = 3;
	public static final  int JSP_COA_ID = 4;
	public static final  int JSP_DATE = 5;
	public static final  int JSP_TOTAL_AMOUNT = 6;
	public static final  int JSP_PURCHASE_ID = 7;
	public static final  int JSP_USER_ID = 8;        
        public static final  int JSP_ROOM_CLASS_ID = 9;        
        public static final  int JSP_HOTEL_ROOM_ID = 10;
        

	public static String[] colNames = {
		"jsp_purchase_item_share_id",		
		"jsp_purchase_item_id",
		"jsp_percent",
		"jsp_amount",
                "jsp_coa_id",
		"jsp_date",
		"jsp_total_amount",
		"jsp_purchase_id",
		"jsp_user_id",
		"jsp_room_class_id",
                "jsp_hotel_room_id"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	} ;

	public JspPurchaseItemShare(){
	}
	public JspPurchaseItemShare(PurchaseItemShare purchaseItemShare){
		this.purchaseItemShare = purchaseItemShare;
	}

	public JspPurchaseItemShare(HttpServletRequest request, PurchaseItemShare purchaseItemShare){
		super(new JspPurchaseItemShare(purchaseItemShare), request);
		this.purchaseItemShare = purchaseItemShare;
	}

	public String getFormName() { return JSP_NAME_PURCHASEITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PurchaseItemShare getEntityObject(){ return purchaseItemShare; }

	public void requestEntityObject(PurchaseItemShare purchaseItemShare) {
		try{
			this.requestParam();
			//purchaseItemShare.setOIPurchaseItemId(pstPurchaseItemShare.getlong(JSP_PURCHASE_ITEM_ID));
                        purchaseItemShare.setPurchaseItemId(getLong(JSP_PURCHASE_ITEM_ID));
			purchaseItemShare.setPercent(getDouble(JSP_PERCENT));
			purchaseItemShare.setAmount(getDouble(JSP_AMOUNT));
			purchaseItemShare.setCoaId(getLong(JSP_COA_ID));
			purchaseItemShare.setDate(getDate(JSP_DATE));
			purchaseItemShare.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
			purchaseItemShare.setPurchaseId(getLong(JSP_PURCHASE_ID));
			purchaseItemShare.setUserId(getLong(JSP_USER_ID));
			purchaseItemShare.setRoomClassId(getLong(JSP_ROOM_CLASS_ID));                        
                        purchaseItemShare.setHotelRoomId(getLong(JSP_HOTEL_ROOM_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
