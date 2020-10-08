package com.project.fms.reportform;

import java.util.*; 
import java.sql.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
//import com.project.general.*;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.I_Project;
import com.project.general.*;
import com.project.system.*;
import com.project.util.lang.*;

public class CmdRptFormatDetailCoa extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private RptFormatDetailCoa rptFormatDetailCoa;
	private DbRptFormatDetailCoa pstRptFormatDetailCoa;
	private JspRptFormatDetailCoa jspRptFormatDetailCoa;
	int language = LANGUAGE_DEFAULT;

	public CmdRptFormatDetailCoa(HttpServletRequest request){
		msgString = "";
		rptFormatDetailCoa = new RptFormatDetailCoa();
		try{
			pstRptFormatDetailCoa = new DbRptFormatDetailCoa(0);
		}catch(Exception e){;}
		jspRptFormatDetailCoa = new JspRptFormatDetailCoa(request, rptFormatDetailCoa);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspRptFormatDetailCoa.addError(jspRptFormatDetailCoa.JSP_FIELD_rpt_format_detail_coa_id, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR]; 
		}
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage(){ return language; }

	public void setLanguage(int language){ this.language = language; }

	public RptFormatDetailCoa getRptFormatDetailCoa() { return rptFormatDetailCoa; } 

	public JspRptFormatDetailCoa getForm() { return jspRptFormatDetailCoa; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidRptFormatDetailCoa){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidRptFormatDetailCoa != 0){
					try{
						rptFormatDetailCoa = DbRptFormatDetailCoa.fetchExc(oidRptFormatDetailCoa);
					}catch(Exception exc){
					}
				}

				jspRptFormatDetailCoa.requestEntityObject(rptFormatDetailCoa);
				
				rptFormatDetailCoa = setOrganizationLevel(rptFormatDetailCoa);

				if(jspRptFormatDetailCoa.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(rptFormatDetailCoa.getOID()==0){
					try{
						long oid = pstRptFormatDetailCoa.insertExc(this.rptFormatDetailCoa);
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
						long oid = pstRptFormatDetailCoa.updateExc(this.rptFormatDetailCoa);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidRptFormatDetailCoa != 0) {
					try {
						rptFormatDetailCoa = DbRptFormatDetailCoa.fetchExc(oidRptFormatDetailCoa);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidRptFormatDetailCoa != 0) {
					try {
						rptFormatDetailCoa = DbRptFormatDetailCoa.fetchExc(oidRptFormatDetailCoa);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidRptFormatDetailCoa != 0){
					try{
						long oid = DbRptFormatDetailCoa.deleteExc(oidRptFormatDetailCoa);
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
	
	
	public static RptFormatDetailCoa setOrganizationLevel(RptFormatDetailCoa rptFormatDetailCoa){
        	
    	Department dep = new Department();
    	try{
    		dep = DbDepartment.fetchExc(rptFormatDetailCoa.getDepId());
    	}
    	catch(Exception e){
    	
    	}
    	
    	switch(dep.getLevel()){
    		case 1 :        			
    			//rptFormatDetailCoa.setJobId(dep.getOID());        			
    			//rptFormatDetailCoa.setSectionId(dep.getOID());
    			//rptFormatDetailCoa.setDepartmentId(dep.getOID());
    			//rptFormatDetailCoa.setDivisionId(dep.getOID());
    			//rptFormatDetailCoa.setDirectorateId(dep.getOID());        			
    			rptFormatDetailCoa.setDepLevel5Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel4Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel3Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel2Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel1Id(dep.getOID());
    			        			
    			break;
    		case 2 :
    			//rptFormatDetailCoa.setJobId(department.getOID());        			
    			///rptFormatDetailCoa.setSectionId(department.getOID());
    			//rptFormatDetailCoa.setDepartmentId(department.getOID());
    			//rptFormatDetailCoa.setDivisionId(department.getOID());
    			//rptFormatDetailCoa.setDirectorateId(department.getRefId()); 
    			rptFormatDetailCoa.setDepLevel5Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel4Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel3Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel2Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel1Id(dep.getRefId());
    			break;
    		case 3 :
    			//rptFormatDetailCoa.setJobId(department.getOID());        			
    			//rptFormatDetailCoa.setSectionId(department.getOID());
    			//rptFormatDetailCoa.setDepartmentId(department.getOID());
    			//rptFormatDetailCoa.setDivisionId(department.getRefId());        			
    			rptFormatDetailCoa.setDepLevel5Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel4Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel3Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel2Id(dep.getRefId());
    			try{
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel1Id(dep.getRefId());
    			}
    			catch(Exception e){
    			}        		    
    			break;
    		case 4 :
    			//rptFormatDetailCoa.setCoaLevel7Id(coa.getOID());
    			//rptFormatDetailCoa.setCoaLevel6Id(coa.getOID());
    			//rptFormatDetailCoa.setCoaLevel5Id(coa.getOID());        			
    			//rptFormatDetailCoa.setCoaLevel4Id(coa.getOID());
    			//rptFormatDetailCoa.setCoaLevel3Id(coa.getAccRefId());
    			rptFormatDetailCoa.setDepLevel5Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel4Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel3Id(dep.getRefId());
    			try{
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel2Id(dep.getRefId());
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel1Id(dep.getRefId());
    			}
    			catch(Exception e){
    			} 
    			break;
    		case 5 :
    			rptFormatDetailCoa.setDepLevel5Id(dep.getOID());
    			rptFormatDetailCoa.setDepLevel4Id(dep.getRefId());
    			try{
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel3Id(dep.getRefId());
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel2Id(dep.getRefId());
    				dep = DbDepartment.fetchExc(dep.getRefId());
    				rptFormatDetailCoa.setDepLevel1Id(dep.getRefId());
    			}
    			catch(Exception e){
    			}
    			break;
    						
    	}
    	
    	return rptFormatDetailCoa;
    	
    }
	
}
