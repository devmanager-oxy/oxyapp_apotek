<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_TERM_PAYMENT);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_TERM_PAYMENT, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_TERM_PAYMENT, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspProjectTerm frmObject, ProjectTerm objEntity, Vector objectClass,  long projectTermId, Project project)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Type","15%");
		jsplist.addHeader("Condition","35%");
		jsplist.addHeader("Status","15%");
		jsplist.addHeader("Due Date","15%");
		jsplist.addHeader("Amount","15%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		for(int i=0; i<I_Crm.termTypeStr.length; i++){
			type_value.add(""+i);
			type_key.add(I_Crm.termTypeStr[i]);
		}
		

		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		//for(int i=0; i<I_Crm.termStatusStr.length; i++){
		//	status_value.add(""+i);
		//	status_key.add(I_Crm.termStatusStr[i]);		
		//}
		status_value.add(""+I_Crm.TERM_STATUS_DRAFT);
		status_key.add(I_Crm.termStatusStr[I_Crm.TERM_STATUS_DRAFT]);
		status_value.add(""+I_Crm.TERM_STATUS_READY_TO_INV);
		status_key.add(I_Crm.termStatusStr[I_Crm.TERM_STATUS_READY_TO_INV]);		

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectTerm objProjectTerm = (ProjectTerm)objectClass.get(i);
			rowx = new Vector();
			if(projectTermId == objProjectTerm.getOID())
				index = i;

			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objProjectTerm.getOID()!=0))){
				if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT && (objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV)){				
					rowx.add("<div align=\"left\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectTerm.getProjectId()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objProjectTerm.getCurrencyId()+"\">"+
							 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectTerm.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE)+"</div>");
					rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+objProjectTerm.getType(), type_value , type_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_TYPE)+"</div>");
					rowx.add("<div align=\"left\"><textarea name=\""+frmObject.colNames[frmObject.JSP_DESCRIPTION] +"\" cols=\"70\" rows=\"3\">"+objProjectTerm.getDescription()+"</textarea>"+ frmObject.getErrorMsg(frmObject.JSP_DESCRIPTION)+"</div>");				
					//if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
					//	rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objProjectTerm.getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS)+"</div>");
					//}else{
						rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_STATUS]+"\" value=\""+objProjectTerm.getStatus()+"\"><div align=\"left\"><input type=\text\" value=\""+I_Crm.termStatusStr[objProjectTerm.getStatus()]+"\" readOnly class=\"readonly\"></div>");
					//}
					if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
						rowx.add("<div align=\"left\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DUE_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectTerm.getDueDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+
								 "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmprojectterm."+frmObject.colNames[frmObject.JSP_DUE_DATE]+");return false;\" ><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"../calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a>"+ frmObject.getErrorMsg(frmObject.JSP_DUE_DATE)+"</div>");
					}else{
						rowx.add("<div align=\"left\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DUE_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectTerm.getDueDate(), "dd/MM/yyyy")+"\" class=\"readonly\" size=\"20\" readonly>"+
								 frmObject.getErrorMsg(frmObject.JSP_DUE_DATE)+"</div>");
					}
					if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
						rowx.add("<div align=\"left\"><input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\">"+
								 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onBlur=\"javascript:checkNumber2()\" onClick=\"this.select()\">"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+"</div>");				
					}else{
						rowx.add("<div align=\"left\"><input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\">"+
								 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\" class=\"readonly\" size=\"25\" onBlur=\"javascript:checkNumber2()\" onClick=\"this.select()\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+"</div>");				
					}
				}else{
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectTerm.getProjectId()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objProjectTerm.getCurrencyId()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectTerm.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE)+
							 "<div align=\"center\">"+String.valueOf(objProjectTerm.getSquence())+"</div>");
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_TYPE] +"\" value=\""+objProjectTerm.getType()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_TYPE)+
							 "<div align=\"left\">"+String.valueOf(I_Crm.termTypeStr[objProjectTerm.getType()])+"</div>");
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DESCRIPTION] +"\" value=\""+objProjectTerm.getDescription()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_DESCRIPTION)+
							 objProjectTerm.getDescription());
					if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
						rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objProjectTerm.getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS)+"</div>");
					}else{
						rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_STATUS]+"\" value=\""+objProjectTerm.getStatus()+"\"><div align=\"left\"><input type=\text\" value=\""+I_Crm.termStatusStr[objProjectTerm.getStatus()]+"\" readOnly class=\"readonly\"></div>");
					}
					if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
						rowx.add("<div align=\"left\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DUE_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectTerm.getDueDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+
								 "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmprojectterm."+frmObject.colNames[frmObject.JSP_DUE_DATE]+");return false;\" ><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"../calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a>"+ frmObject.getErrorMsg(frmObject.JSP_DUE_DATE)+"</div>");
					}else{
						rowx.add("<div align=\"left\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DUE_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectTerm.getDueDate(), "dd/MM/yyyy")+"\" class=\"readonly\" size=\"20\" readonly>"+
								 frmObject.getErrorMsg(frmObject.JSP_DUE_DATE)+"</div>");
					}
					if(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_DRAFT || objProjectTerm.getStatus()==I_Crm.TERM_STATUS_READY_TO_INV){
						rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\">"+
								 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onBlur=\"javascript:checkNumber2()\" onClick=\"this.select()\">"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+
								 "<div align=\"right\">"+JSPFormater.formatNumber(objProjectTerm.getAmount(), "#,###.##")+"</div>");				
					}else{
						rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\">"+
								 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectTerm.getAmount(),"#,###.##")+"\" class=\"readonly\" size=\"25\" onBlur=\"javascript:checkNumber2()\" onClick=\"this.select()\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+
								 "<div align=\"right\">"+JSPFormater.formatNumber(objProjectTerm.getAmount(), "#,###.##")+"</div>");				
					}
				}
			}
			else
			{
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectTerm.getSquence())+"</div>");
				if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
					rowx.add("<div align=\"left\">"+String.valueOf(I_Crm.termTypeStr[objProjectTerm.getType()])+"</div>");					
				}else{
					rowx.add("<div align=\"left\"><a href=\"javascript:cmdEdit('"+String.valueOf(objProjectTerm.getOID())+"')\">"+String.valueOf(I_Crm.termTypeStr[objProjectTerm.getType()])+"</a></div>");
				}
				rowx.add(objProjectTerm.getDescription());
				rowx.add("<div align=\"left\">"+String.valueOf(I_Crm.termStatusStr[objProjectTerm.getStatus()])+"</div>");

				String str_dt_DueDate = ""; 
				try
				{
					Date dt_DueDate = objProjectTerm.getDueDate();
					if(dt_DueDate==null)
					{
						dt_DueDate = new Date();
					}
					str_dt_DueDate = JSPFormater.formatDate(dt_DueDate, "dd MMMM yyyy");
				}
				catch(Exception e){ str_dt_DueDate = ""; }
				rowx.add(str_dt_DueDate);
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objProjectTerm.getAmount(), "#,###.##")+"</div>");
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
			//rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+project.getOID()+"\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+project.getCurrencyId()+"\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objEntity.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
			rowx.add("<div align=\"left\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+project.getOID()+"\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+project.getCurrencyId()+"\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbProjectTerm.getMaxSquence(project.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE)+"</div>");
			rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_TYPE)+"</div>");
			rowx.add("<div align=\"left\"><textarea name=\""+frmObject.colNames[frmObject.JSP_DESCRIPTION] +"\" cols=\"70\" rows=\"3\">"+objEntity.getDescription()+"</textarea>"+ frmObject.getErrorMsg(frmObject.JSP_DESCRIPTION)+"</div>");
			//rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objEntity.getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS)+"</div>");
			rowx.add("<div align=\"left\"><input style=\"text-align:left\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_STATUS] +"\" value=\""+I_Crm.TERM_STATUS_DRAFT+"\" class=\"readonly\" size=\"25\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_STATUS)+"</div>"+		
					 "<div align=\"left\"><input style=\"text-align:left\" type=\"text\" name=\"status\" value=\""+I_Crm.termStatusStr[I_Crm.TERM_STATUS_DRAFT]+"\" class=\"readonly\" size=\"25\" readOnly></div>");		
			rowx.add("<div align=\"left\"><input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DUE_DATE] +"\" value=\""+JSPFormater.formatDate(objEntity.getDueDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly> <a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmprojectterm."+frmObject.colNames[frmObject.JSP_DUE_DATE]+");return false;\" ><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"../calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a>"+ frmObject.getErrorMsg(frmObject.JSP_DUE_DATE)+"</div>");
			rowx.add("<div align=\"left\"><input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onBlur=\"javascript:checkNumber()\" onClick=\"this.select()\">"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+"</div>");		
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectTerm projectTerm = (ProjectTerm)listx.get(i);
				result = result + projectTerm.getAmount();
				System.out.println(projectTerm.getAmount());
			}
		}
		return result;
	}

%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long projectId = JSPRequestValue.requestLong(request, "oid");
	//long proposalId = JSPRequestValue.requestLong(request, "hidden_proposal_id");
	
	//out.println(projectId);
	//Proposal proposal = new Proposal();
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	/*
	try{
		proposal = DbProposal.fetchExc(proposalId);
	}
	catch(Exception e){
	}
	*/
	
	try{ 
		Vector v = DbProject.list(0,0, "project_id="+projectId, "");
		if(v!=null && v.size()>0){
			project = (Project)v.get(0);
			projectId = project.getOID();
		}
	}catch(Exception e){
		System.out.println(e);
	}
	
	try{
		customer = DbCustomer.fetchExc(project.getCustomerId());
	}catch(Exception e){
		System.out.println(e);
	}
	
	try{
		currency = DbCurrency.fetchExc(project.getCurrencyId());
	}catch(Exception e){
		System.out.println(e);
	}



		
	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectTerm = JSPRequestValue.requestLong(request, "hidden_projectterm");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	//String whereClause = "company_id="+systemCompanyId+" and proposal_id="+proposalId;
	//String whereClause = "proposal_id="+proposalId;
	String whereClause = "project_id="+projectId;
	String orderClause = "squence";

	CmdProjectTerm cmdProjectTerm = new CmdProjectTerm(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectTerm = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectTerm.action(iCommand , oidProjectTerm, systemCompanyId);
	iErrCode = cmdProjectTerm.action(iCommand , oidProjectTerm);

	// end switch
	JspProjectTerm jspProjectTerm = cmdProjectTerm.getForm();

	// count list All ProjectTerm
	int vectSize = DbProjectTerm.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectTerm.getErrors());

	ProjectTerm projectTerm = cmdProjectTerm.getProjectTerm();
	msgString =  cmdProjectTerm.getMessage();
	//out.println(msgString);

	// switch list ProjectTerm
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectTerm.generateFindStart(projectTerm.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectTerm.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectTerm = DbProjectTerm.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectTerm.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectTerm = DbProjectTerm.list(start,recordToGet, whereClause , orderClause);
	}
	
	double totalAmount = getTotalDetail(listProjectTerm);
	double totalBalance = project.getAmount()-totalAmount;
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

	<%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
	<%}%>

	function cmdAdd(){
		document.frmprojectterm.hidden_projectterm.value="0";
		document.frmprojectterm.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdAsk(oidProjectTerm){
		document.frmprojectterm.hidden_projectterm.value=oidProjectTerm;
		document.frmprojectterm.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdDelete(oidProjectTerm){
		document.frmprojectterm.hidden_projectterm.value=oidProjectTerm;
		document.frmprojectterm.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdConfirmDelete(oidProjectTerm){
		document.frmprojectterm.hidden_projectterm.value=oidProjectTerm;
		document.frmprojectterm.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdSave(){
		document.frmprojectterm.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
		}

	function cmdEdit(oidProjectTerm){
		<%if(masterPrivUpdate){%>
		document.frmprojectterm.hidden_projectterm.value=oidProjectTerm;
		document.frmprojectterm.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
		<%}%>
		}

	function cmdCancel(oidProjectTerm){
		document.frmprojectterm.hidden_projectterm.value=oidProjectTerm;
		document.frmprojectterm.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectterm.prev_command.value="<%=prevCommand%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdBack(){
		document.frmprojectterm.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectterm.hidden_projectterm.value="0";
		//document.frmprojectterm.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
		}

	function cmdListFirst(){
		document.frmprojectterm.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectterm.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdListPrev(){
		document.frmprojectterm.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectterm.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
		}

	function cmdListNext(){
		document.frmprojectterm.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectterm.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function cmdListLast(){
		document.frmprojectterm.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectterm.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectterm.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectterm.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
	}

	var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
	var usrDigitGroup = "<%=sUserDigitGroup%>";
	var usrDecSymbol = "<%=sUserDecimalSymbol%>";
	
	function checkNumber(){
		var main = ""+<%=project.getAmount()%>;		
		main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		var currTotal = ""+<%=totalAmount%>;
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);			
		var pbalance = ""+<%=totalBalance%>;	
		pbalance = cleanNumberFloat(pbalance, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
		pbalance = Math.round(pbalance*100)/100;	
				
		//new Amount Input
		var newAmount = document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		
		if(parseFloat(newAmount)>parseFloat(pbalance))
		{
			alert("Maximum Amount limit is "+formatFloat(pbalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+" \nsystem will reset the data");
			document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value = formatFloat(pbalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}else{
			document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		}		
	}
	
	function checkNumber2(){
		var editAmount = document.frmprojectterm.EditAmount.value;		
		editAmount = cleanNumberFloat(editAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var main = ""+<%=project.getAmount()%>;		
		main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		var currTotal = ""+<%=totalAmount%>;
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		currtotal = parseFloat(currTotal)-parseFloat(editAmount);
		
		var pbalance = ""+<%=totalBalance%>;		
		pbalance = cleanNumberFloat(pbalance, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		pbalance = parseFloat(pbalance)+parseFloat(editAmount);
		pbalance = Math.round(pbalance*100)/100;
			
		//new Amount Input
		var newAmount = document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		
		if(parseFloat(newAmount)>parseFloat(pbalance))
		{
			alert("Maximum Amount limit is "+formatFloat(pbalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+" \nsystem will reset the data");
			document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value = formatFloat(pbalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}else{
			document.frmprojectterm.<%=jspProjectTerm.colNames[jspProjectTerm.JSP_AMOUNT]%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		}
	}


	//-------------- script control line -------------------
	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

	function MM_findObj(n, d) { //v4.0
		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

	function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
</script>
<!--End Region JavaScript-->
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenupg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagespg/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menupg.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td> 
                                                <!--Begin Region Content-->
                                                <form name="frmprojectterm" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectterm" value="<%=oidProjectTerm%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"><span class="lvl2">Payment 
                                                              Term</span><span class="lvl2"><br>
                                                              </span></font></b></td>
                                                            <td width="40%" height="23"> 
                                                              <%@ include file = "../main/userpreview.jsp" %>
                                                            </td>
                                                          </tr>
                                                          <tr > 
                                                            <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                          <tr > 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                            <%//if(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>&command=<%=JSPCommand.EDIT%>" class="tablink">Project 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <%//}%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Product 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tab" nowrap>Payment 
                                                              Term</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%
															     //if(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){
																 if((totalBalance==0) || (project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT)||(project.getStatus()==I_Crm.PROJECT_STATUS_REJECT)){	
															  %>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Order 
                                                              Confirmation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING || project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Installation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Closing</a></b></td>
                                                            <%}}%>
                                                            <td nowrap class="tabheader"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000">&nbsp; 
                                                              </font></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="4" class="listtitle"></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="4" class="listtitle"></td>
                                                                </tr>
                                                                <%if(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Number</td>
                                                                  <td width="22%"><strong>: 
                                                                    <%=project.getNumber()%></strong></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%">&nbsp;</td>
                                                                </tr>
                                                                <%}%>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Name</td>
                                                                  <td width="22%">: 
                                                                    <%=project.getName()%></td>
                                                                  <td width="8%">Customer</td>
                                                                  <td width="60%">: 
                                                                    <%=customer.getName()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="8%">Start 
                                                                    Date</td>
                                                                  <td width="22%">: 
                                                                    <%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                  <td width="8%">End 
                                                                    Date</td>
                                                                  <td width="60%">: 
                                                                    <%=JSPFormater.formatDate(project.getEndDate(), "dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Status</td>
                                                                  <td width="22%">: 
                                                                    <%=I_Crm.projectStatusStr[project.getStatus()]%></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15"><b><font color="#FF0000" size="2">Project 
                                                                    Amount</font></b></td>
                                                                  <td width="22%"><font color="#FF0000" size="2"><b>: 
                                                                    <%=JSPFormater.formatNumber(project.getAmount(),"#,###.##")%></b></font></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%"> 
                                                                    <%if(totalBalance!=0){%>
                                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0" align="right">
                                                                      <tr> 
                                                                        <td width="77%" nowrap> 
                                                                          <div align="right"><font size="2"><b><font color="#FF0000">Balance</font></b></font></div>
                                                                        </td>
                                                                        <td width="21%" nowrap> 
                                                                          <div align="right"><font color="#FF0000" size="2"><b>&nbsp;&nbsp;: 
                                                                            <%=JSPFormater.formatNumber(totalBalance,"#,###.##")%></b></font></div>
                                                                        </td>
                                                                        <td width="2%">&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Payment 
                                                                    Term</b></td>
                                                                </tr>
                                                                <%
			 try
			 {
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawList(iCommand,jspProjectTerm, projectTerm,listProjectTerm,oidProjectTerm, project)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <% 
			 } catch(Exception exc){}
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="4" class="command" valign="top"> 
                                                                    <span class="command"> 
                                                                    <% 
			 int cmd = 0;
			 if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
			   cmd =iCommand; 
			 else{
			   if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
				 cmd = JSPCommand.FIRST;
			   else 
				 cmd =prevCommand; 
			 } 
		   %>
                                                                    <% 
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
			 jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
			 jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
			 jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");

			 jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
			 jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
			 jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
			 jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
		   %>
                                                                    <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                                    </span> </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="78%">&nbsp;</td>
                                                                        <td width="7%" align="right" class="boxed1"><strong>Total 
                                                                          : </strong></td>
                                                                        <td width="15%" class="boxed1" align="right"><b><%=JSPFormater.formatNumber(totalAmount,"#,###.##")%></b></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%
										
										//out.println("totalBalance : "+totalBalance);
										
										if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && totalBalance>0){// && proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROPOSAL){// && project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                            <td height="8" colspan="2" width="83%">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top" > 
                                                            <td colspan="3" class="command"> 
                                                              <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProjectTerm+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectTerm+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectTerm+"')";
			 jspLine.setBackCaption("Back to List");
			 jspLine.setJSPCommandStyle("buttonlink");
			 jspLine.setDeleteCaption("Delete");

			 jspLine.setOnMouseOut("MM_swapImgRestore()");
			 jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
			 jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

			 //jspLine.setOnMouseOut("MM_swapImgRestore()");
			 jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
			 jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

			 jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
			 jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

			 jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
			 jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");

			 jspLine.setWidthAllJSPCommand("90");
			 jspLine.setErrorStyle("warning");
			 jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
			 jspLine.setQuestionStyle("warning");
			 jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
			 jspLine.setInfoStyle("success");

			 jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

			 if (privDelete)

			 {
			   jspLine.setConfirmDelJSPCommand(sconDelCom);
			   jspLine.setDeleteJSPCommand(scomDel);
			   jspLine.setEditJSPCommand(scancel);
			 }else
			 { 
			   jspLine.setConfirmDelCaption("");
			   jspLine.setDeleteCaption("");
			   jspLine.setEditCaption("");
			 }

			 if(privAdd == false  && privUpdate == false)
			 {
			   jspLine.setSaveCaption("");
			 }

			 if (privAdd == false)
			 {
			   jspLine.setAddCaption("");
			 }
		 
			 if(iCommand==JSPCommand.EDIT){
			 	if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
					jspLine.setDeleteCaption("");
					jspLine.setSaveCaption("");
				}else if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING){
					jspLine.setDeleteCaption("");
				}
			 }
		   %>
                                                              <%
			 if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0)
			 {
		   %>
                                                              <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                              <%
			 }
		   %>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </form>
                                                <!--End Region Content-->
                                              </td>
                                            </tr>
                                            <tr> 
                                              <td>&nbsp;</td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                        <!-- #EndEditable --> </td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footerpg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

