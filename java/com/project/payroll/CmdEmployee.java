package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.payroll.*; 
import com.project.general.*; 

public class CmdEmployee extends Control
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}, //{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private Employee employee;
	private DbEmployee pstEmployee;
	private JspEmployee jspEmployee;
	
	public CmdEmployee(HttpServletRequest request){
		msgString = "";
		employee = new Employee();
		try{
			pstEmployee = new DbEmployee(0);
		}catch(Exception e){;}
		jspEmployee = new JspEmployee(request, employee);
	}

	private String getSystemMessage(int msgCode){
		return "";
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	
	public Employee getEmployee() { return employee; } 

	public JspEmployee getForm() { return jspEmployee; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidEmployee){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidEmployee != 0){
					try{
						employee = DbEmployee.fetchExc(oidEmployee);
					}catch(Exception exc){
					}
				}

				jspEmployee.requestEntityObject(employee);
                                
                                Country c = new Country();
                                try{
                                    c = DbCountry.fetchExc(employee.getCountryId());
                                }
                                catch(Exception ex){
                                    
                                }
                                employee.setCountryName(c.getName());
                                
                                c = new Country();
                                try{
                                    c = DbCountry.fetchExc(employee.getNationalityId());
                                }
                                catch(Exception ex){
                                    
                                }
                                employee.setNationalityName(c.getName());

				if(jspEmployee.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(employee.getOID()==0){
					try{
						long oid = pstEmployee.insertExc(this.employee);                                                
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
						return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}else{
					try {
						long oid = pstEmployee.updateExc(this.employee);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidEmployee != 0) {
					try {
						employee = DbEmployee.fetchExc(oidEmployee);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidEmployee != 0) {
					try {
						employee = DbEmployee.fetchExc(oidEmployee);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidEmployee != 0){
					try{
						long oid = DbEmployee.deleteExc(oidEmployee);
						if(oid!=0){
							msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}
}
