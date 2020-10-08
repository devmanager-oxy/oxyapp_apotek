
package com.project.datasync;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.datasync.*;

public class JspBackupHistory extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BackupHistory backupHistory;

	public static final String JSP_NAME_BACKUPHISTORY		=  "JSP_NAME_BACKUPHISTORY" ;

	public static final int JSP_BACKUP_HISTORY_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_START_DATE			=  2 ;
	public static final int JSP_END_DATE			=  3 ;
	public static final int JSP_OPERATOR			=  4 ;
	public static final int JSP_TYPE			=  5 ;
	public static final int JSP_NOTE			=  6 ;

	public static String[] colNames = {
		"JSP_BACKUP_HISTORY_ID",  "JSP_DATE",
		"JSP_START_DATE",  "JSP_END_DATE",
		"JSP_OPERATOR",  "JSP_TYPE",
		"JSP_NOTE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_DATE,  TYPE_DATE,
		TYPE_LONG,  TYPE_INT,
		TYPE_STRING
	} ;

	public JspBackupHistory(){
	}
	public JspBackupHistory(BackupHistory backupHistory){
		this.backupHistory = backupHistory;
	}

	public JspBackupHistory(HttpServletRequest request, BackupHistory backupHistory){
		super(new JspBackupHistory(backupHistory), request);
		this.backupHistory = backupHistory;
	}

	public String getFormName() { return JSP_NAME_BACKUPHISTORY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BackupHistory getEntityObject(){ return backupHistory; }

	public void requestEntityObject(BackupHistory backupHistory) {
		try{
			this.requestParam();
			//backupHistory.setDate((JSP_DATE));
			backupHistory.setStartDate(getDate(JSP_START_DATE));
			backupHistory.setEndDate(getDate(JSP_END_DATE));
			backupHistory.setOperator(getLong(JSP_OPERATOR));
			backupHistory.setType(getInt(JSP_TYPE));
			backupHistory.setNote(getString(JSP_NOTE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
