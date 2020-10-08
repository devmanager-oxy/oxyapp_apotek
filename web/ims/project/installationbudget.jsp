<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.Company" %>
<%@ page import = "com.project.general.DbCompany" %>
<%@ page import = "com.project.general.JspCompany" %>
<%@ page import = "com.project.general.CmdCompany" %>
<%@ page import = "com.project.general.Location" %>
<%@ page import = "com.project.general.DbLocation" %>
<%@ page import = "com.project.general.JspLocation" %>
<%@ page import = "com.project.general.CmdLocation" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET, AppMenu.PRIV_UPDATE);
	
	//Approval 1
	boolean approvalPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED);
	boolean approvalPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED, AppMenu.PRIV_UPDATE);

	//Approval 2
	boolean approvalPriv2 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED);
	boolean approvalPrivView2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED, AppMenu.PRIV_UPDATE);
	
	//Approval 3 Finish Install
	boolean approvalPriv3 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH);
	boolean approvalPrivView3 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate3 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH, AppMenu.PRIV_UPDATE);

%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspProjectInstallationBudget frmObject, ProjectInstallationBudget objEntity, Vector objectClass,  long projectInstallationBudgetId, ProjectInstallation objEntity1, long companyId, long userId)
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
		jsplist.addHeader("Description","35%");
		jsplist.addHeader("Qty","10%");
		jsplist.addHeader("Unit Cost","15%");
		jsplist.addHeader("Amount","20%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		Vector vProjectInstallationBudgetType = DbProjectInstallationBudgetType.list(0,0, "", "description");
		Vector ProjectInstallationBudgetType_value = new Vector(1,1);
		Vector ProjectInstallationBudgetType_key = new Vector(1,1);
		if(vProjectInstallationBudgetType!=null && vProjectInstallationBudgetType.size()>0)
		{
			for(int i=0; i<vProjectInstallationBudgetType.size(); i++)
			{
				ProjectInstallationBudgetType c = (ProjectInstallationBudgetType)vProjectInstallationBudgetType.get(i);
				ProjectInstallationBudgetType_key.add(c.getDescription().trim());
				ProjectInstallationBudgetType_value.add(""+c.getOID());
			}
		}

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectInstallationBudget objProjectInstallationBudget = (ProjectInstallationBudget)objectClass.get(i);
			rowx = new Vector();
			if(projectInstallationBudgetId == objProjectInstallationBudget.getOID())
				index = i;

			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objProjectInstallationBudget.getOID()!=0))){
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectInstallationBudget.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_BUDGET_TYPE_ID],null, ""+objProjectInstallationBudget.getBudgetTypeId(), ProjectInstallationBudgetType_value , ProjectInstallationBudgetType_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_BUDGET_TYPE_ID));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DESCRIPTION] +"\" value=\""+objProjectInstallationBudget.getDescription()+"\" class=\"formElemen\" size=\"60\">"+ frmObject.getErrorMsg(frmObject.JSP_DESCRIPTION));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objProjectInstallationBudget.getQty()+"\" class=\"formElemen\" size=\"10\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
				rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_UNIT_COST] +"\" value=\""+JSPFormater.formatNumber(objProjectInstallationBudget.getUnitCost(),"#,####.##")+"\" class=\"formElemen\" size=\"20\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber()\">"+ frmObject.getErrorMsg(frmObject.JSP_UNIT_COST));
				rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectInstallationBudget.getAmount(),"#,####.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectInstallationBudget.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objProjectInstallationBudget.getInstallationId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectInstallationBudget.getDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));
			}
			else
			{
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationBudget.getSquence())+"</div>");
				ProjectInstallationBudgetType colCombo3  = new ProjectInstallationBudgetType();
				try{
				colCombo3 = DbProjectInstallationBudgetType.fetchExc(objProjectInstallationBudget.getBudgetTypeId());
				}catch(Exception e) {}
				if(objEntity1.getBudgetStatus()==I_Crm.INSTALL_BUGDET_STATUS_DRAFT){
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectInstallationBudget.getOID())+"')\">"+colCombo3.getDescription()+"</a>");
				}else{
					rowx.add(colCombo3.getDescription());
				}
				rowx.add(objProjectInstallationBudget.getDescription());
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationBudget.getQty())+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objProjectInstallationBudget.getUnitCost(),"#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objProjectInstallationBudget.getAmount(),"#,###.##")+"</div>");
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
			rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbProjectInstallationBudget.getMaxSquence(objEntity1.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_BUDGET_TYPE_ID],null, ""+objEntity.getBudgetTypeId(), ProjectInstallationBudgetType_value , ProjectInstallationBudgetType_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_BUDGET_TYPE_ID));
			rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\" size=\"60\">"+ frmObject.getErrorMsg(frmObject.JSP_DESCRIPTION));
			rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"10\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
			rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_UNIT_COST] +"\" value=\""+JSPFormater.formatNumber(objEntity.getUnitCost(),"#,###.##")+"\" class=\"formElemen\" size=\"20\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber()\">"+ frmObject.getErrorMsg(frmObject.JSP_UNIT_COST));
			rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objEntity1.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objEntity1.getOID()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(new Date(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectInstallationBudget projectInstallationBudget = (ProjectInstallationBudget)listx.get(i);
				result = result + (projectInstallationBudget.getUnitCost()*projectInstallationBudget.getQty());
			}
		}
		return result;
	}
	
	public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly){	
		
		System.out.println("in recursif : "+coa.getOID());
		
		String result = "";
		if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
			
			System.out.println("not postable ...");
			
			Vector coas = DbCoa.list(0,0, "acc_ref_id="+coa.getOID(), "code");
			
			System.out.println(coas);
			
			if(coas!=null && coas.size()>0){
				for(int i=0; i<coas.size(); i++){
					
					Coa coax = (Coa)coas.get(i);												
					String str = "";
													
					if(!isPostableOnly){
						switch(coax.getLevel()){
							case 1 : 											
								break;
							case 2 : 
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 3 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 4 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 5 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;				
						}
					}
					
					result = result + "<option value=\""+coax.getOID()+"\""+((oid==coax.getOID()) ? "selected" : "")+">"+str+coax.getCode()+" - "+coax.getName()+"</option>";
					
					if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
						result = result + getAccountRecursif(coax, oid, isPostableOnly);
					}
					
					
				}
			}
		}
		
		return result;
	}

%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long installationId = JSPRequestValue.requestLong(request, "oid");
	//long oidProposal = JSPRequestValue.requestLong(request, "hidden_proposal_id");
	//load Instalation 
	
	ProjectInstallation projInstallation = new ProjectInstallation();
	try{
		projInstallation = DbProjectInstallation.fetchExc(installationId);
	}catch(Exception e){
		System.out.println(e);
	}
	
	//Load Employee
	Employee emp = new Employee();
	try{
		emp = DbEmployee.fetchExc(projInstallation.getEmployeeId());
	}catch(Exception e){
		System.out.println(e);
	}
	
	long projectId = projInstallation.getProjectId();	
	//out.println(projectId);
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	
	try{ 
		project = DbProject.fetchExc(projectId);
		//oidProposal = project.getProposalId();
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
	long oidProjectInstallationBudget = JSPRequestValue.requestLong(request, "hidden_projectinstallationbudget");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "installation_id="+installationId;
	String orderClause = "squence";

	System.out.println(whereClause);
	
	CmdProjectInstallationBudget cmdProjectInstallationBudget = new CmdProjectInstallationBudget(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectInstallationBudget = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectInstallationBudget.action(iCommand , oidProjectInstallationBudget, systemCompanyId);
	iErrCode = cmdProjectInstallationBudget.action(iCommand , oidProjectInstallationBudget);

	// end switch
	JspProjectInstallationBudget jspProjectInstallationBudget = cmdProjectInstallationBudget.getForm();

	// count list All ProjectInstallationBudget
	int vectSize = DbProjectInstallationBudget.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectInstallationBudget.getErrors());

	ProjectInstallationBudget projectInstallationBudget = cmdProjectInstallationBudget.getProjectInstallationBudget();
	msgString =  cmdProjectInstallationBudget.getMessage();
	//out.println(msgString);

	// switch list ProjectInstallationBudget
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectInstallationBudget.generateFindStart(projectInstallationBudget.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectInstallationBudget.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectInstallationBudget = DbProjectInstallationBudget.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectInstallationBudget.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectInstallationBudget = DbProjectInstallationBudget.list(start,recordToGet, whereClause , orderClause);
	}
	
	double totalAmount = getTotalDetail(listProjectInstallationBudget);
	
	//Approved
	int approvedStatus = JSPRequestValue.requestInt(request, "installStatus");
	long bankCoaId = JSPRequestValue.requestLong(request, "account");

	//out.println("app = "+approvedStatus);
	if(approvedStatus>0 && iCommand==JSPCommand.NONE){
		long oidUpdate = 0;
		try{			
			if(approvedStatus==I_Crm.INSTALL_BUGDET_STATUS_APPROVED){
				if(approvalPrivUpdate){
					projInstallation.setBudgetStatus(approvedStatus);
					projInstallation.setApproval2(appSessUser.getUserOID());
					projInstallation.setDateApproval2(new Date());
				}
			}else if(approvedStatus==I_Crm.INSTALL_BUGDET_STATUS_ISSUED){
				if(approvalPrivUpdate2){
					projInstallation.setCoaBankBudget(bankCoaId);
					projInstallation.setBudgetStatus(approvedStatus);
					projInstallation.setApproval3(appSessUser.getUserOID());
					projInstallation.setDateApproval3(new Date());
					projInstallation.setStatus(I_Crm.INSTALL_STATUS_IN_PROGRESS);					
				}
			}else if(approvedStatus==I_Crm.INSTALL_BUGDET_STATUS_AMEND){
				projInstallation.setBudgetStatus(approvedStatus);
				projInstallation.setApproval2(appSessUser.getUserOID());
				projInstallation.setDateApproval2(new Date());
				projInstallation.setApproval3(0);
				projInstallation.setDateApproval3(new Date());
				projInstallation.setStatus(I_Crm.INSTALL_STATUS_CANCEL);
			}			
			oidUpdate = DbProjectInstallation.updateExc(projInstallation);

			if(approvedStatus==I_Crm.INSTALL_BUGDET_STATUS_ISSUED){
				if(approvalPrivUpdate2){			
					//posting journal
					DbProjectInstallationBudget.postJournal(installationId);
				}
			}
		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	int finish = JSPRequestValue.requestInt(request, "finish");
	if(finish>0 && iCommand==JSPCommand.NONE){
		try{
			projInstallation.setStatus(I_Crm.INSTALL_STATUS_FINISH);
			DbProjectInstallation.updateExc(projInstallation);
		}catch(Exception e){
			System.out.println(e);
		}	
	}
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

	function cmdInstallFinish(){
		<%if(approvalPrivUpdate3){%>
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationbudget.finish.value="<%=I_Crm.INSTALL_STATUS_FINISH%>";
		document.frmprojectinstallationbudget.submit();
		<%}%>
	}

	function cmdPrintCheck(){	 
		window.open("<%=printroot2%>.report.RptProjectInstallationCheckXLS?oid=<%=installationId%>");
	}

	function cmdApproved(){
		<%if(approvalPrivUpdate || approvalPrivUpdate2){%>
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";		
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		<%}%>
		}

	function cmdBackToList(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationbudget.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdAdd(){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value="0";
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdAsk(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdDelete(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdConfirmDelete(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdSave(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdEdit(oidProjectInstallationBudget){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdBack(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value="0";
		//document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationbudget.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
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
		//new Amount Input
		var newAmount = document.frmprojectinstallationbudget.<%=jspProjectInstallationBudget.colNames[jspProjectInstallationBudget.JSP_UNIT_COST]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				

		//new qty Input
		var newQty = document.frmprojectinstallationbudget.<%=jspProjectInstallationBudget.colNames[jspProjectInstallationBudget.JSP_QTY]%>.value;
		newQty = cleanNumberFloat(newQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		
		document.frmprojectinstallationbudget.<%=jspProjectInstallationBudget.colNames[jspProjectInstallationBudget.JSP_AMOUNT]%>.value = formatFloat((parseFloat(newAmount)*parseFloat(newQty)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		document.frmprojectinstallationbudget.<%=jspProjectInstallationBudget.colNames[jspProjectInstallationBudget.JSP_UNIT_COST]%>.value = formatFloat(parseFloat(newAmount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
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
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/process2.gif')">
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
                                                <form name="frmprojectinstallationbudget" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallationbudget" value="<%=oidProjectInstallationBudget%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="approved" value="">
                                                  <input type="hidden" name="finish" value="">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"> 
                                                              <span class="lvl2"> 
                                                              </span><span class="lvl2"> 
                                                              Installation Detail 
                                                              </span><span class="lvl2"><br>
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
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>" class="tablink">Project 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Product 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Payment 
                                                              Term</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Order 
                                                              Confirmation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tab" nowrap>Installation</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Closing</a></b></td>
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
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Number</b></td>
                                                                  <td width="22%"><strong><%=project.getNumber()%></strong></td>
                                                                  <td width="10%"><b>Customer</b></td>
                                                                  <td width="58%"><%=customer.getName()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Name</b></td>
                                                                  <td width="22%"><%=project.getName()%></td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%"><%=project.getCustomerAddress()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="8%"><b>Start 
                                                                    Date</b></td>
                                                                  <td width="22%"><%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                  <td width="10%"><b>End 
                                                                    Date</b></td>
                                                                  <td width="58%"><%=JSPFormater.formatDate(project.getEndDate(), "dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Status</b></td>
                                                                  <td width="22%"><b><%=I_Crm.projectStatusStr[project.getStatus()]%></b></td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="8" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15" colspan="4"><b><u>Installation</u></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Location</b></td>
                                                                  <td colspan="3"><b><%=projInstallation.getLocation()%></b> 
                                                                    ( <%=projInstallation.getAddress()%> 
                                                                    )</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>PIC</b></td>
                                                                  <td colspan="3"><%=emp.getEmpNum()%> 
                                                                    / <%=emp.getName()%> 
                                                                    ( <%=projInstallation.getPicPosition()%> 
                                                                    )</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Date</b></td>
                                                                  <td colspan="3"><%=JSPFormater.formatDate(projInstallation.getStartDate(),"dd MMMM yyyy")%> 
                                                                    - <%=JSPFormater.formatDate(projInstallation.getEndDate(),"dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <%
				long duration = DateCalc.dayDifference(projInstallation.getStartDate(), projInstallation.getEndDate());
				String Duration = "";
				if (duration>0) {
					Duration = duration +"  days";
				}else{
					Duration = duration + "  day";
				}
			%>
                                                                <tr> 
                                                                  <td height="15"><b>Duration</b></td>
                                                                  <td><%=Duration%></td>
                                                                  <td></td>
                                                                  <td></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Status</b></td>
                                                                  <td><b><%=I_Crm.installStatusStr[projInstallation.getStatus()]%></b></td>
                                                                  <td><b>Budget 
                                                                    Status</b></td>
                                                                  <td><b><%=I_Crm.installBudgetStatusStr[projInstallation.getBudgetStatus()]%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    <%if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_IN_PROGRESS){%>
                                                                    <input type="button" onClick="javascript:cmdInstallFinish()" title="Click to update Installation Status => Finish" value="Installation Finish">
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="8" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4"> 
                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                      <tr > 
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                                        <td class="tab" nowrap><font color="#000000">Budget 
                                                                          Proposed</font></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <td class="tabin" nowrap> 
                                                                          <a href="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Product</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <td nowrap class="tabheader"></td>
                                                                        <td class="tabin" nowrap><a href="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Resources 
                                                                          & Spareparts</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH){%>
                                                                        <td class="tabin" nowrap><a href="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Travel 
                                                                          Report</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%}%>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <%
			 try
			 {
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawList(iCommand,jspProjectInstallationBudget, projectInstallationBudget,listProjectInstallationBudget,oidProjectInstallationBudget, projInstallation, systemCompanyId, appSessUser.getUserOID())%></td>
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
                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="78%">&nbsp;</td>
                                                                        <td width="7%" align="right" class="boxed1"><strong>Total 
                                                                          : </strong></td>
                                                                        <td width="15%" class="boxed1" align="right"><b><%=JSPFormater.formatNumber(totalAmount,"#,###.##")%></b></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0){%>
                                                                <%if(listProjectInstallationBudget.size()>0){%>
                                                                <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_ISSUED){%>
                                                                <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_ISSUED && projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_AMEND){%>
                                                                <tr align="left" > 
                                                                  <td colspan="4" valign="top"> 
                                                                    <table width="100%">
                                                                      <tr> 
                                                                        <td> 
                                                                          <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                            <tr> 
                                                                              <%if(projInstallation.getBudgetStatus()==I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%>
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_BUGDET_STATUS_APPROVED%>" checked>
                                                                                <%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_APPROVED]%></td>
                                                                              <%}else if(projInstallation.getBudgetStatus()==I_Crm.INSTALL_BUGDET_STATUS_APPROVED){%>
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_BUGDET_STATUS_ISSUED%>" checked>
                                                                                <%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_ISSUED]%></td>
                                                                              <%}%>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_BUGDET_STATUS_AMEND%>">
                                                                                <%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_AMEND]%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="150" nowrap><a href="javascript:cmdApproved()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new29','','../images/process2.gif',1)"><img src="../images/process.gif" name="new29" border="0"></a></td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%}}}}%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"> 
                                                                          <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                          <%if(projInstallation.getBudgetStatus()==I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%>
                                                                          <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                          &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                          <%}}%>
                                                                          <%if(listProjectInstallationBudget.size()>0){%>
                                                                          <a href="javascript:cmdPrintCheck()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new23','','../images/printcheck2.gif',1)"><img src="../images/printcheck.gif" name="new23" width="155" height="22" border="0"></a> 
                                                                          &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                          <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_ISSUED){%>
                                                                          <%}}%>
                                                                          <a href="javascript:cmdBackToList()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/back2.gif',1)"><img src="../images/back.gif" name="new22" width="51" height="22" border="0"></a> 
                                                                        </td>
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
			 String scomDel = "javascript:cmdAsk('"+oidProjectInstallationBudget+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectInstallationBudget+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectInstallationBudget+"')";
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
			 if(iCommand==JSPCommand.EDIT && project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){
				jspLine.setDeleteCaption("");
				jspLine.setSaveCaption("");
			 }else {
			 	if(projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_DRAFT) {
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
                                                          <%if(listProjectInstallationBudget.size()>0){%>
                                                          <tr align="left" valign="top"> 
                                                            <td width="31%" height="1">&nbsp; 
                                                            </td>
                                                            <td width="6%"></td>
                                                            <td width="63%"></td>
                                                          </tr>
                                                          <tr align="left" > 
                                                            <td colspan="2" valign="top"> 
                                                              <table width="86%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="33%" height="20" class="tablecell1">&nbsp;&nbsp;<b><u>Approval 
                                                                    History</u></b></td>
                                                                  <td width="34%" class="tablecell1"> 
                                                                    <div align="center"><b><u>User</u></b></div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell1"> 
                                                                    <div align="center"><b><u>Date</u></b></div>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_DRAFT]%> 
                                                                    by</i></td>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%
						User u = new User();
						try{
							u = DbUser.fetch(projInstallation.getApproval1());
						}
						catch(Exception e){
						}
					  %>
                                                                      <%=u.getLoginId()%></i></div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell"> 
                                                                    <%if(projInstallation.getApproval1()!=0){%>
                                                                    <div align="center"><i><%=JSPFormater.formatDate(projInstallation.getDateApproval1(), "dd MMMM yy")%></i></div>
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_AMEND){%>
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_APPROVED]%> 
                                                                    by</i></td>
                                                                  <%}else{%>
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_AMEND]%> 
                                                                    by</i></td>
                                                                  <%}%>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%
						 u = new User();
						try{
							u = DbUser.fetch(projInstallation.getApproval2());
						}
						catch(Exception e){
						}
					  %>
                                                                      <%=u.getLoginId()%></i></div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%if(projInstallation.getApproval2()!=0){%>
                                                                      <%=JSPFormater.formatDate(projInstallation.getDateApproval2(), "dd MMMM yy")%> 
                                                                      <%}%>
                                                                      </i></div>
                                                                  </td>
                                                                </tr>
                                                                <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_AMEND){%>
                                                                <tr> 
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installBudgetStatusStr[I_Crm.INSTALL_BUGDET_STATUS_ISSUED]%> 
                                                                    by</i> </td>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <div align="center"> 
                                                                        <i> 
                                                                        <%
							u = new User();
							try{
								u = DbUser.fetch(projInstallation.getApproval3());
							}
							catch(Exception e){
							}
						%>
                                                                        <%=u.getLoginId()%></i></div>
                                                                    </div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <div align="center"> 
                                                                        <i> 
                                                                        <%if(projInstallation.getApproval3()!=0){%>
                                                                        <%=JSPFormater.formatDate(projInstallation.getDateApproval3(), "dd MMMM yy")%> 
                                                                        <%}%>
                                                                        </i></div>
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                              </table>
                                                            </td>
                                                            <td valign="top"> 
                                                              <%if(approvalPrivUpdate2){%>
                                                              <table width="86%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td height="20" class="tablecell1">&nbsp;&nbsp;<b><u>Bank 
                                                                    Account :</u></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td class="tablecell">&nbsp; 
                                                                    <%if(projInstallation.getBudgetStatus()!=I_Crm.INSTALL_BUGDET_STATUS_ISSUED){%>
                                                                    <select name="account">
                                                                      <%
																			Vector accLinksDebet = DbAccLink.list(0,0, "(type='"+I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT+"') and (location_id="+sysCompany.getSystemLocation()+" or location_id="+0+")", "");
																			if(accLinksDebet!=null && accLinksDebet.size()>0){
																				for(int i=0; i<accLinksDebet.size(); i++){
																					AccLink accLink = (AccLink)accLinksDebet.get(i);
																					Coa coa = new Coa();
																					try{
																						coa = DbCoa.fetchExc(accLink.getCoaId());
																					}catch(Exception e){
																						System.out.println("err >> "+e.toString());
																					}
																					
																					System.out.println("acclink Id = "+accLink.getCoaId());
																					System.out.println("coa Id = "+coa.getOID());
																					System.out.println("coa name = "+coa.getName());
																	  %>
                                                                      <option <%if(projInstallation.getCoaBankBudget()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
																	  <%=getAccountRecursif(coa, projInstallation.getCoaBankBudget(), false)%> 
                                                                      <%	}	}%>
                                                                    </select>
                                                                    <%}else{
																			Coa coa = new Coa();
																			try{
																				coa = DbCoa.fetchExc(projInstallation.getCoaBankBudget());
																			}catch(Exception e){
																				System.out.println(e); 
																			}
																	  %>
                                                                    <input type="text" size="50" name="account_name" value="<%=coa.getCode()+" - "+coa.getName()%>" class="readonly" readonly>
                                                                    <input type="hidden" name="account" value="<%=coa.getOID()%>" class="readonly" readonly>
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                          <%}%>
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

