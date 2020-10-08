<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%//@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.fms.master.*" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL, AppMenu.PRIV_UPDATE);

	//Approval 1
	boolean approvalPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_APPROVED);
	boolean approvalPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_APPROVED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_APPROVED, AppMenu.PRIV_UPDATE);

	//Approval 2
	boolean approvalPriv2 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_CHECKED);
	boolean approvalPrivView2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_CHECKED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_TRAVEL_CHECKED, AppMenu.PRIV_UPDATE);
	
%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long installationId = JSPRequestValue.requestLong(request, "oid");
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
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectInstallationBudget = JSPRequestValue.requestLong(request, "hidden_projectinstallationbudget");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and installation_id="+installationId;
	String whereClause = "installation_id="+installationId;
	String orderClause = "squence";

	//Installation Budget
	JspProjectInstallationBudget jspProjectInstallationBudget = new JspProjectInstallationBudget();
	Vector listProjectInstallationBudget = DbProjectInstallationBudget.list(0,0, whereClause , orderClause);
	
	//Installation Product
	Vector listProjectInstallationProduct = DbProjectInstallationProduct.list(0,0, whereClause , orderClause);
	
	//Installation Resources
	Vector listProjectInstallationResources = DbProjectInstallationResources.list(0,0, whereClause , "");
	ProjectInstallationResources projectInstallationResources = new ProjectInstallationResources();
	if (listProjectInstallationResources.size()>0)
	{
		projectInstallationResources = (ProjectInstallationResources)listProjectInstallationResources.get(0);
	}
	
	//Installation Other Expense
	Vector listProjectInstallationOtherExpense = DbProjectInstallationOtherExpense.list(0,0,whereClause, orderClause);

	//Installation Spareparts
	Vector listProjectInstallationSpareparts = DbProjectInstallationSpareparts.list(0,0, whereClause , "squence");
	
	long oidBudget = 0;
	long oidProduct = 0;
	long oidSpareparts = 0;
	long oidResource = 0;
	long oidExpense = 0;

	if(iCommand==JSPCommand.SAVE){
		//Update Installation Budget
		for (int i = 0; i < listProjectInstallationBudget.size(); i++) 
		{
			ProjectInstallationBudget projInstallationBudget = (ProjectInstallationBudget)listProjectInstallationBudget.get(i);						
			projInstallationBudget.setAmountReal(JSPRequestValue.requestDouble(request, "cost_"+projInstallationBudget.getOID()));
			projInstallationBudget.setReference(JSPRequestValue.requestString(request, "ref_"+projInstallationBudget.getOID()));
			try{
				oidBudget = DbProjectInstallationBudget.updateExc(projInstallationBudget);
			}catch(Exception e){
				System.out.println(e);
			}
		}
		
		//Update Installation Product
		for (int i = 0; i < listProjectInstallationProduct.size(); i++) 
		{
			ProjectInstallationProduct projInstallationProduct = (ProjectInstallationProduct)listProjectInstallationProduct.get(i);						
			projInstallationProduct.setReference(JSPRequestValue.requestString(request, "ref_"+projInstallationProduct.getOID()));
			try{
				oidProduct = DbProjectInstallationProduct.updateExc(projInstallationProduct);
			}catch(Exception e){
				System.out.println(e);
			}
		}
		
		//Update Spareparts
		for (int i = 0; i < listProjectInstallationSpareparts.size(); i++) 
		{
			ProjectInstallationSpareparts projectInstallationSpareparts = (ProjectInstallationSpareparts)listProjectInstallationSpareparts.get(i);						
			projectInstallationSpareparts.setQtyReal(JSPRequestValue.requestDouble(request, "qty_"+projectInstallationSpareparts.getOID()));
			projectInstallationSpareparts.setReference(JSPRequestValue.requestString(request, "refparts_"+projectInstallationSpareparts.getOID()));
			try{
				oidSpareparts = DbProjectInstallationSpareparts.updateExc(projectInstallationSpareparts);
			}catch(Exception e){
				System.out.println(e);
			}
		}
		
		//Update Installation Resources
		projectInstallationResources.setNumOfDayReal(JSPRequestValue.requestDouble(request, "day_"+projectInstallationResources.getOID()));
		projectInstallationResources.setNumOfPeopleReal(JSPRequestValue.requestDouble(request, "people_"+projectInstallationResources.getOID()));
		projectInstallationResources.setReference(JSPRequestValue.requestString(request, "ref_"+projectInstallationResources.getOID()));
		try{
			oidResource =DbProjectInstallationResources.updateExc(projectInstallationResources);
		}catch(Exception e){
			System.out.println(e);
		}		
		
		//Save/Update Installation Other Expense
		DbProjectInstallationOtherExpense.deleteExpenseByInstallation(installationId);
		ProjectInstallationOtherExpense projInstallationOtherExpense = new ProjectInstallationOtherExpense();
		for (int i = 0; i < 5; i++) 
		{
			if(JSPRequestValue.requestString(request, "description_"+i).trim().length()>0){
				try{
					projInstallationOtherExpense = (ProjectInstallationOtherExpense)listProjectInstallationOtherExpense.get(i);						
				}catch(Exception e){
					//System.out.println("err: "+e);
					projInstallationOtherExpense = new ProjectInstallationOtherExpense();
				}	
			
				//Default
				projInstallationOtherExpense.setProjectId(projectId);
				projInstallationOtherExpense.setInstallationId(installationId);
				projInstallationOtherExpense.setCompanyId(systemCompanyId);
				projInstallationOtherExpense.setUserId(appSessUser.getUserOID());
				projInstallationOtherExpense.setDate(new Date());
				projInstallationOtherExpense.setSquence(i+1);
				//Get Data
				projInstallationOtherExpense.setExpenseTypeId(JSPRequestValue.requestLong(request, "type_"+i));			
				projInstallationOtherExpense.setDescription(JSPRequestValue.requestString(request, "description_"+i));
				projInstallationOtherExpense.setAmount(JSPRequestValue.requestDouble(request, "amount_"+i));			
				projInstallationOtherExpense.setReference(JSPRequestValue.requestString(request, "ref_"+i));			
			
				//if(projInstallationOtherExpense.getExpenseTypeId()>0 && projInstallationOtherExpense.getDescription().length()>0 && projInstallationOtherExpense.getAmount()>0 && projInstallationOtherExpense.getOID()>0){
				//	//Update	
				//	try{
				//		oidExpense = DbProjectInstallationOtherExpense.updateExc(projInstallationOtherExpense);
				//	}catch(Exception e){
				//		System.out.println("Update Err: "+e);
				//	}
				//}else{
					//Save
					try{
						oidExpense = DbProjectInstallationOtherExpense.insertExc(projInstallationOtherExpense);
					}catch(Exception e){
						//System.out.println("Save Err: "+e);
					}
				//}
			}
		}
		
		//Update Project Installation
		long settleCoaId = JSPRequestValue.requestLong(request, "account");
		double settleBalance = JSPRequestValue.requestDouble(request, "balance");
		try{
			projInstallation.setCoaId(settleCoaId);
			projInstallation.setSettlementBalance(settleBalance);
			DbProjectInstallation.updateExc(projInstallation);
		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	listProjectInstallationOtherExpense = DbProjectInstallationOtherExpense.list(0,0,whereClause, orderClause);
	
	//Approved	
	int approvedStatus = JSPRequestValue.requestInt(request, "installStatus");
	//out.println("app = "+approvedStatus);
	if(approvedStatus>0 && iCommand==JSPCommand.NONE){
		long oidUpdate = 0;
		try{			
			if(approvedStatus==I_Crm.INSTALL_TRAVEL_STATUS_APPROVED){
				if(approvalPrivUpdate){
					projInstallation.setTravelStatus(approvedStatus);
					projInstallation.setApprovalTravel2(appSessUser.getUserOID());
					projInstallation.setDateApprovalTravel2(new Date());
				}
			}else if(approvedStatus==I_Crm.INSTALL_TRAVEL_STATUS_CHECKED){
				if(approvalPrivUpdate2){
					projInstallation.setTravelStatus(approvedStatus);
					projInstallation.setApprovalTravel3(appSessUser.getUserOID());
					projInstallation.setDateApprovalTravel3(new Date());
				}
			}else if(approvedStatus==I_Crm.INSTALL_TRAVEL_STATUS_CANCEL){
				projInstallation.setTravelStatus(approvedStatus);
				projInstallation.setApprovalTravel2(appSessUser.getUserOID());
				projInstallation.setDateApprovalTravel2(new Date());
				projInstallation.setApprovalTravel3(0);
				projInstallation.setDateApprovalTravel3(new Date());
			}
			oidUpdate = DbProjectInstallation.updateExc(projInstallation);

			if(approvedStatus==I_Crm.INSTALL_TRAVEL_STATUS_CHECKED){
				if(approvalPrivUpdate2){
					//posting journal
					DbProjectInstallationOtherExpense.postJournal(installationId);
				}
			}

		}catch(Exception e){
			System.out.println(e);
		}
	}

	//Revise Travel Report to Draft
	int finish = JSPRequestValue.requestInt(request, "finish");
	if(finish>0 && iCommand==JSPCommand.NONE){
		try{
			projInstallation.setTravelStatus(I_Crm.INSTALL_TRAVEL_STATUS_DRAFT);
			DbProjectInstallation.updateExc(projInstallation);
			projInstallation.setApprovalTravel2(0);
			projInstallation.setDateApprovalTravel2(new Date());
			projInstallation.setApprovalTravel3(0);
			projInstallation.setDateApprovalTravel3(new Date());
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

	function cmdTravelDraft(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationbudget.finish.value="<%=I_Crm.INSTALL_TRAVEL_STATUS_CANCEL%>"; //seharusnya INSTALL_TRAVEL_STATUS_DRAFT ttp krn value 0 maka pakai CAncel
		document.frmprojectinstallationbudget.submit();
	}
	
	function cmdPrint(){	 
		window.open("<%=printroot2%>.report.RptProjectInstallationTravelXLS?oid=<%=installationId%>");
	}

	function cmdApproved(){
		<%if(approvalPrivUpdate || approvalPrivUpdate2){%>
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
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
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdAsk(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdDelete(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdConfirmDelete(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdSave(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdEdit(oidProjectInstallationBudget){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallationBudget){
		document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value=oidProjectInstallationBudget;
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdBack(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallationbudget.hidden_projectinstallationbudget.value="0";
		//document.frmprojectinstallationbudget.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationbudget.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallationbudget.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationbudget.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationbudget.action="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
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

	function checkNumber(oid){
		//new Amount Input
		<%
			for (int i = 0; i < listProjectInstallationBudget.size(); i++) 
			{
				ProjectInstallationBudget projInstallationBudget = (ProjectInstallationBudget)listProjectInstallationBudget.get(i);						
		%>
				if(oid==<%=projInstallationBudget.getOID()%>){
					var newAmount = document.frmprojectinstallationbudget.cost_<%=projInstallationBudget.getOID()%>.value;
					newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							
					document.frmprojectinstallationbudget.cost_<%=projInstallationBudget.getOID()%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
				}
		<%
			}
		%>
	}
		
	function qtyChange(oid){
		//new Amount Input
		<%
			for (int i = 0; i < listProjectInstallationSpareparts.size(); i++) 
			{
				ProjectInstallationSpareparts projectInstallationSpareparts = (ProjectInstallationSpareparts)listProjectInstallationSpareparts.get(i);						
		%>
				if(oid==<%=projectInstallationSpareparts.getOID()%>){
					var maxAmount = ""+<%=projectInstallationSpareparts.getQty()%>;
					//alert(maxAmount);
					maxAmount = cleanNumberFloat(maxAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							
					var newAmount = document.frmprojectinstallationbudget.qty_<%=projectInstallationSpareparts.getOID()%>.value;
					newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							

					document.frmprojectinstallationbudget.return_<%=projectInstallationSpareparts.getOID()%>.value = formatFloat((parseFloat(maxAmount)-parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
				}
		<%
			}
		%>
	}
	
	function checkNumber1(oid){
		//new Amount Input
		<%
			for (int i = 0; i < listProjectInstallationSpareparts.size(); i++) 
			{
				ProjectInstallationSpareparts projectInstallationSpareparts = (ProjectInstallationSpareparts)listProjectInstallationSpareparts.get(i);						
		%>
				if(oid==<%=projectInstallationSpareparts.getOID()%>){
					var maxAmount = ""+<%=projectInstallationSpareparts.getQty()%>;
					//alert(maxAmount);
					maxAmount = cleanNumberFloat(maxAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							
					var newAmount = document.frmprojectinstallationbudget.qty_<%=projectInstallationSpareparts.getOID()%>.value;
					newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							
					if(parseFloat(newAmount)>parseFloat(maxAmount))
					{
						alert("Maximum Qty limit is "+maxAmount+" \nsystem will reset the data")
						document.frmprojectinstallationbudget.qty_<%=projectInstallationSpareparts.getOID()%>.value = formatFloat((parseFloat(maxAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
					}else{
						document.frmprojectinstallationbudget.qty_<%=projectInstallationSpareparts.getOID()%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
					}
				}
		<%
			}
		%>
	}

	function checkNumber2(oid){
		//new Amount Input
		<%
			for (int i = 0; i < 5; i++) 
			{				
		%>
				if(oid==<%=i%>){
					var newAmount = document.frmprojectinstallationbudget.amount_<%=i%>.value;
					newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);							
					document.frmprojectinstallationbudget.amount_<%=i%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
				}
		<%
			}
		%>
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
                                                              &raquo; </font></b><b><font class="tit1"><span class="lvl2">Installation 
                                                              Detail<br>
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
                                                                  <td><b>Travel 
                                                                    Status</b></td>
                                                                  <td><b><%=I_Crm.installTravelStatusStr[projInstallation.getTravelStatus()]%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    <%if(projInstallation.getTravelStatus()==I_Crm.INSTALL_TRAVEL_STATUS_CANCEL){%>
                                                                    <input type="button" onClick="javascript:cmdTravelDraft()" title="Click to update Travel Status => Draft" value="Revised Travel Report">
                                                                    <%}%>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="20" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4"> 
                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                      <tr > 
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                                        <td class="tabin" nowrap><a href="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Budget 
                                                                          Proposed</a></td>
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
                                                                        <td class="tab" nowrap><font color="#000000">Travel 
                                                                          Report</font></td>
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
                                                                <tr> 
                                                                  <td height="16" colspan="4"><b>Budget 
                                                                    Detail :</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"> 
                                                                          <table width="100%" class="listarea" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" class="listgen" cellspacing="1" border="0">
                                                                                  <tr> 
                                                                                    <td width="5%" class="tablehdr" null>No.</td>
                                                                                    <td width="10%" class="tablehdr" null>Type</td>
                                                                                    <td width="30%" class="tablehdr" null>Description</td>
                                                                                    <td width="15%" class="tablehdr" null>Total 
                                                                                      Budget</td>
                                                                                    <td width="10%" class="tablehdr" null>Total 
                                                                                      Actual</td>
                                                                                    <td width="35%" class="tablehdr" null>Reference</td>
                                                                                  </tr>
                                                                                  <%
								double totalBudget = 0;
								double totalActual = 0;
								for (int i = 0; i < listProjectInstallationBudget.size(); i++) 
								{
									ProjectInstallationBudget projInstallationBudget = (ProjectInstallationBudget)listProjectInstallationBudget.get(i);						
									ProjectInstallationBudgetType type  = new ProjectInstallationBudgetType();
									try{
										type = DbProjectInstallationBudgetType.fetchExc(projInstallationBudget.getBudgetTypeId());
									}catch(Exception e){
										System.out.println(e);
									}
									String css = "tablecell";
									if(i%2!=0){
										css = "tablecell1";
									}
									totalBudget = totalBudget + projInstallationBudget.getAmount();
									totalActual = totalActual + projInstallationBudget.getAmountReal();
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=projInstallationBudget.getSquence()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" ><%=type.getDescription()%></td>
                                                                                    <td class="<%=css%>" ><%=projInstallationBudget.getDescription()%></td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="right"><%=JSPFormater.formatNumber(projInstallationBudget.getAmount(),"#,###.##")%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="right"> 
                                                                                        <input style="text-align:right" type="text" name="cost_<%=projInstallationBudget.getOID()%>" value="<%=JSPFormater.formatNumber(projInstallationBudget.getAmountReal(),"#,###.##")%>" size="20" onClick="this.select()" onBlur="checkNumber(<%=projInstallationBudget.getOID()%>)" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>>
                                                                                      </div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="right"> 
                                                                                        <textarea name="ref_<%=projInstallationBudget.getOID()%>" rows="2" cols="60" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projInstallationBudget.getReference()%></textarea>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%
								}
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="tablecell1" height="20" colspan="3" valign="middle"><b> 
                                                                                      <div align="right">Total&nbsp;&nbsp;</div>
                                                                                      </b></td>
                                                                                    <td class="tablecell1" valign="middle"><b> 
                                                                                      <div align="right"><%=JSPFormater.formatNumber(totalBudget,"#,###.##")%></div>
                                                                                      </b></td>
                                                                                    <td class="tablecell1" valign="middle"><b> 
                                                                                      <div align="right"><%=JSPFormater.formatNumber(totalActual,"#,###.##")%></div>
                                                                                      </b></td>
                                                                                    <td class="tablecell1" ></td>
                                                                                  </tr>
                                                                                  <tr valign="top"> 
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
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"><b>Product 
                                                                    Detail :</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"> 
                                                                          <table width="100%" class="listarea" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" class="listgen" cellspacing="1" border="0">
                                                                                  <tr> 
                                                                                    <td width="5%" class="tablehdr" null>No.</td>
                                                                                    <td width="25%" class="tablehdr" null>Product</td>
                                                                                    <td width="15%" class="tablehdr" null>Category</td>
                                                                                    <td width="9%" class="tablehdr" null>Qty</td>
                                                                                    <td width="8%" class="tablehdr" null>UOM</td>
                                                                                    <td width="15%" class="tablehdr" null>Location 
                                                                                      Detail</td>
                                                                                    <td width="30%" class="tablehdr" null>Reference</td>
                                                                                  </tr>
                                                                                  <%
								for (int i = 0; i < listProjectInstallationProduct.size(); i++) 
								{
									ProjectInstallationProduct projInstallationProduct = (ProjectInstallationProduct)listProjectInstallationProduct.get(i);						
									ProjectProductDetail colCombo3  = new ProjectProductDetail();
									try{
										colCombo3 = DbProjectProductDetail.fetchExc(projInstallationProduct.getProjectProductDetailId());
									}catch(Exception e) {}
									//Category
									ItemMaster colCombo2  = new ItemMaster();
									try{
										colCombo2 = DbItemMaster.fetchExc(colCombo3.getProductMasterId());
									}catch(Exception e) {
										System.out.println(e);
									}
									Uom uom = new Uom();
									try{
										uom = DbUom.fetchExc(colCombo2.getUomSalesId());
									}catch(Exception e){
										System.out.println(e);
									}			
									ItemCategory subCategory = new ItemCategory();
									try{
										subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
									}catch(Exception e) {
										System.out.println();
									}
									ItemGroup category = new ItemGroup();
									try{
										category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
									}catch(Exception e) {
										System.out.println(e);
									}
									String css = "tablecell";
									if(i%2!=0){
										css = "tablecell1";
									}
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=projInstallationProduct.getSquence()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" ><%=colCombo2.getName()%></td>
                                                                                    <td class="<%=css%>" ><%=category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()%></td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=projInstallationProduct.getQty()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=uom.getUnit()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" ><%=projInstallationProduct.getLocationDetail()%></td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="right"> 
                                                                                        <textarea name="ref_<%=projInstallationProduct.getOID()%>" rows="2" cols="60" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projInstallationProduct.getReference()%></textarea>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%
								}
							%>
                                                                                  <tr valign="top"> 
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
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"><b>Spareparts 
                                                                    Detail :</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"> 
                                                                          <table width="100%" class="listarea" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" class="listgen" cellspacing="1" border="0">
                                                                                  <tr> 
                                                                                    <td width="5%" class="tablehdr" rowspan="2" null>No.</td>
                                                                                    <td width="22%" class="tablehdr" rowspan="2" null>Spareparts</td>
                                                                                    <td width="35%" class="tablehdr" colspan="3" null>Qty</td>
                                                                                    <td width="8%" class="tablehdr" rowspan="2" null>UOM</td>
                                                                                    <td width="30%" class="tablehdr" rowspan="2" null>Reference</td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="10%" class="tablehdr" null>Spare</td>
                                                                                    <td width="10%" class="tablehdr" null>Used</td>
                                                                                    <td width="10%" class="tablehdr" null>Return</td>
                                                                                  </tr>
                                                                                  <%
								for (int i = 0; i < listProjectInstallationSpareparts.size(); i++) 
								{
									ProjectInstallationSpareparts projectInstallationSpareparts = (ProjectInstallationSpareparts)listProjectInstallationSpareparts.get(i);						
									ItemMaster colCombo2  = new ItemMaster();
									try{
										colCombo2 = DbItemMaster.fetchExc(projectInstallationSpareparts.getProjectProductDetailId());
									}catch(Exception e) {
										System.out.println(e);
									}
									Uom uom = new Uom();
									try{
										uom = DbUom.fetchExc(colCombo2.getUomSalesId());
									}catch(Exception e){
										System.out.println(e);
									}		
									String css = "tablecell";
									if(i%2!=0){
										css = "tablecell1";
									}
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=projectInstallationSpareparts.getSquence()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" ><%=colCombo2.getName()%></td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=projectInstallationSpareparts.getQty()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <input style="text-align:right" type="text" name="qty_<%=projectInstallationSpareparts.getOID()%>" value="<%=JSPFormater.formatNumber(projectInstallationSpareparts.getQtyReal(),"#,###.##")%>" size="20" onClick="this.select()" onBlur="checkNumber1(<%=projectInstallationSpareparts.getOID()%>);qtyChange(<%=projectInstallationSpareparts.getOID()%>)" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <input style="text-align:right" type="text" name="return_<%=projectInstallationSpareparts.getOID()%>" value="<%=JSPFormater.formatNumber((projectInstallationSpareparts.getQty()-projectInstallationSpareparts.getQtyReal()),"#,###.##")%>" size="20" onClick="this.select()" onBlur="qtyChange(<%=projectInstallationSpareparts.getOID()%>)" class="readonly" readonly>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="center"><%=uom.getUnit()%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>" > 
                                                                                      <div align="right"> 
                                                                                        <textarea name="refparts_<%=projectInstallationSpareparts.getOID()%>" rows="2" cols="60" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projectInstallationSpareparts.getReference()%></textarea>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%
								}
							%>
                                                                                  <tr valign="top"> 
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
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"><b>Resource 
                                                                    Detail :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4">Description 
                                                                    &nbsp;&nbsp;:&nbsp; 
                                                                    <%=projectInstallationResources.getDescription()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4">Equipment 
                                                                    &nbsp;&nbsp;&nbsp;:&nbsp; 
                                                                    <%=projectInstallationResources.getEquipment()%></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"> 
                                                                          <table width="100%" class="listarea" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" class="listgen" cellspacing="1" border="0">
                                                                                  <tr> 
                                                                                    <td width="20%" class="tablehdr" null>Item</td>
                                                                                    <td width="15%" class="tablehdr" null>Proposed</td>
                                                                                    <td width="15%" class="tablehdr" null>Actual</td>
                                                                                  </tr>
                                                                                  <tr valign="top"> 
                                                                                    <td class="tablecell" >&nbsp;&nbsp;Num 
                                                                                      of 
                                                                                      Days</td>
                                                                                    <td class="tablecell" > 
                                                                                      <div align="center"><%=projectInstallationResources.getNumOfDay()%></div>
                                                                                    </td>
                                                                                    <td class="tablecell" > 
                                                                                      <input style="text-align:right" type="text" name="day_<%=projectInstallationResources.getOID()%>" value="<%=projectInstallationResources.getNumOfDayReal()%>" size="30" onClick="this.select()" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr valign="top"> 
                                                                                    <td class="tablecell1" >&nbsp;&nbsp;Num 
                                                                                      of 
                                                                                      People</td>
                                                                                    <td class="tablecell1" > 
                                                                                      <div align="center"><%=projectInstallationResources.getNumOfPeople()%></div>
                                                                                    </td>
                                                                                    <td class="tablecell1" > 
                                                                                      <input style="text-align:right" type="text" name="people_<%=projectInstallationResources.getOID()%>" value="<%=projectInstallationResources.getNumOfPeopleReal()%>" size="30" onClick="this.select()" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr valign="top"> 
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
                                                                <tr> 
                                                                  <td height="3" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4">Reference 
                                                                    &nbsp;&nbsp;&nbsp;:&nbsp; 
                                                                    <textarea name="ref_<%=projectInstallationResources.getOID()%>" rows="3" cols="87" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projectInstallationResources.getReference()%></textarea>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"><b>Other 
                                                                    Expense :</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"> 
                                                                          <table width="100%" class="listarea" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" class="listgen" cellspacing="1" border="0">
                                                                                  <tr> 
                                                                                    <td width="5%" class="tablehdr" null>No.</td>
                                                                                    <td width="15%" class="tablehdr" null>Expense 
                                                                                      Type</td>
                                                                                    <td width="30%" class="tablehdr" null>Description</td>
                                                                                    <td width="15%" class="tablehdr" null>Amount</td>
                                                                                    <td width="30%" class="tablehdr" null>Reference</td>
                                                                                  </tr>
                                                                                  <%
								double totalExpense = 0;
								ProjectInstallationOtherExpense projInstallationOtherExpense = new ProjectInstallationOtherExpense();
								for (int i = 0; i < 5; i++) 
								{
									try{
										projInstallationOtherExpense = (ProjectInstallationOtherExpense)listProjectInstallationOtherExpense.get(i);						
									}catch(Exception e){
										System.out.println();
										projInstallationOtherExpense = new ProjectInstallationOtherExpense();
									}
									//Load Expense Type	
									Vector vProjectInstallationExpenseType = DbProjectInstallationExpenseType.list(0,0, "company_id="+systemCompanyId, "");
									Vector ProjectInstallationExpenseType_value = new Vector(1,1);
									Vector ProjectInstallationExpenseType_key = new Vector(1,1);
									
									if(vProjectInstallationExpenseType!=null && vProjectInstallationExpenseType.size()>0)
									{
										for(int ix=0; ix<vProjectInstallationExpenseType.size(); ix++)
										{
											ProjectInstallationExpenseType c = (ProjectInstallationExpenseType)vProjectInstallationExpenseType.get(ix);
											ProjectInstallationExpenseType_key.add(c.getDescription().trim());
											ProjectInstallationExpenseType_value.add(""+c.getOID());
										}
									}

									String css = "tablecell";
									if(i%2!=0){
										css = "tablecell1";
									}
									totalExpense = totalExpense + projInstallationOtherExpense.getAmount();
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="<%=css%>"> 
                                                                                      <div align="center"><%=i+1%></div>
                                                                                    </td>
                                                                                    <td class="<%=css%>"> 
                                                                                      <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){
									  		ProjectInstallationExpenseType expenseType = new ProjectInstallationExpenseType();
											try{
												expenseType = DbProjectInstallationExpenseType.fetchExc(projInstallationOtherExpense.getExpenseTypeId());
											}catch (Exception e){
												System.out.println();
											}
									  %>
                                                                                      <input type="text" name="type" value="<%=expenseType.getDescription()%>" size="30" class="readonly" readonly>
                                                                                      <input type="hidden" name="type_<%=i%>" value="<%=projInstallationOtherExpense.getExpenseTypeId()%>" size="30" readonly>
                                                                                      <%}else{%>
                                                                                      <%= JSPCombo.draw("type_"+i,null, ""+projInstallationOtherExpense.getExpenseTypeId(), ProjectInstallationExpenseType_value , ProjectInstallationExpenseType_key, "formElemen", "") %> 
                                                                                      <%}%>
                                                                                    </td>
                                                                                    <td class="<%=css%>"> 
                                                                                      <textarea name="description_<%=i%>" rows="2" cols="60" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projInstallationOtherExpense.getDescription()%></textarea>
                                                                                    </td>
                                                                                    <td class="<%=css%>"> 
                                                                                      <div align="right"> 
                                                                                        <input style="text-align:right" type="text" name="amount_<%=i%>" value="<%=JSPFormater.formatNumber(projInstallationOtherExpense.getAmount(),"#,###.##")%>" size="30" onClick="this.select()" onBlur="checkNumber2(<%=i%>)" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>>
                                                                                      </div>
                                                                                    </td>
                                                                                    <td class="<%=css%>"> 
                                                                                      <div align="right"> 
                                                                                        <textarea name="ref_<%=i%>" rows="2" cols="60" <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_DRAFT){%> class="readonly" readonly <%}%>><%=projInstallationOtherExpense.getReference()%></textarea>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%
								}
							%>
                                                                                  <tr valign="top"> 
                                                                                    <td class="tablecell1" height="20" colspan="3" valign="middle"><b> 
                                                                                      <div align="right">Total&nbsp;&nbsp;</div>
                                                                                      </b></td>
                                                                                    <td class="tablecell1" valign="middle"><b> 
                                                                                      <div align="right"><%=JSPFormater.formatNumber(totalExpense,"#,###.##")%></div>
                                                                                      </b></td>
                                                                                    <td class="tablecell1" ></td>
                                                                                  </tr>
                                                                                  <tr valign="top"> 
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
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <%
				if(oidBudget > 0 && oidProduct > 0 && oidResource > 0){
			%>
                                                                <tr> 
                                                                  <td height="16" colspan="4"> 
                                                                    <table width="100%">
                                                                      <tr> 
                                                                        <td> 
                                                                          <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                            <tr> 
                                                                              <td width="20"><img src="<%=approot%>/images/success.gif" width="20" height="20"></td>
                                                                              <td width="200" nowrap>Data 
                                                                                has 
                                                                                been 
                                                                                updated</td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <%	}	%>
                                                                <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_TRAVEL_STATUS_CHECKED){%>
                                                                <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_TRAVEL_STATUS_CHECKED && projInstallation.getTravelStatus()!=I_Crm.INSTALL_TRAVEL_STATUS_CANCEL){%>
                                                                <tr align="left" > 
                                                                  <td colspan="4" valign="top"> 
                                                                    <table width="100%">
                                                                      <tr> 
                                                                        <td> 
                                                                          <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                            <tr> 
                                                                              <%if(projInstallation.getTravelStatus()==I_Crm.INSTALL_TRAVEL_STATUS_DRAFT){%>
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_TRAVEL_STATUS_APPROVED%>" checked>
                                                                                <%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_APPROVED]%></td>
                                                                              <%}else if(projInstallation.getTravelStatus()==I_Crm.INSTALL_TRAVEL_STATUS_APPROVED){%>
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_TRAVEL_STATUS_CHECKED%>" checked>
                                                                                <%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_CHECKED]%></td>
                                                                              <%}%>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.INSTALL_TRAVEL_STATUS_CANCEL%>">
                                                                                <%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_CANCEL]%></td>
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
                                                                <%}}}%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"> 
                                                                          <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                          <%if(projInstallation.getTravelStatus()==I_Crm.INSTALL_TRAVEL_STATUS_DRAFT){%>
                                                                          <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" width="55" height="22" border="0"></a> 
                                                                          &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                          <%}}%>
                                                                          <%if(listProjectInstallationBudget.size()>0){%>
                                                                          <a href="javascript:cmdPrint()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new23','','../images/print2.gif',1)"><img src="../images/print.gif" name="new23" width="53" height="22" border="0"></a> 
                                                                          &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                          <%}%>
                                                                          <a href="javascript:cmdBackToList()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/back2.gif',1)"><img src="../images/back.gif" name="new22" width="51" height="22" border="0"></a> 
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
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
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_DRAFT]%> 
                                                                    by</i></td>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%
							User u = new User();
							try{
								u = DbUser.fetch(projInstallation.getApprovalTravel1());
							}
							catch(Exception e){
							}
						  %>
                                                                      <%=u.getLoginId()%></i></div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell"> 
                                                                    <%if(projInstallation.getApprovalTravel1()!=0){%>
                                                                    <div align="center"><i><%=JSPFormater.formatDate(projInstallation.getDateApprovalTravel1(), "dd MMMM yy")%></i></div>
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_TRAVEL_STATUS_CANCEL){%>
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_APPROVED]%> 
                                                                    by</i></td>
                                                                  <%}else{%>
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_CANCEL]%> 
                                                                    by</i></td>
                                                                  <%}%>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%
							 u = new User();
							try{
								u = DbUser.fetch(projInstallation.getApprovalTravel2());
							}
							catch(Exception e){
							}
						  %>
                                                                      <%=u.getLoginId()%></i></div>
                                                                  </td>
                                                                  <td width="33%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <i> 
                                                                      <%if(projInstallation.getApprovalTravel2()!=0){%>
                                                                      <%=JSPFormater.formatDate(projInstallation.getDateApprovalTravel2(), "dd MMMM yy")%> 
                                                                      <%}%>
                                                                      </i></div>
                                                                  </td>
                                                                </tr>
                                                                <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_TRAVEL_STATUS_CANCEL){%>
                                                                <tr> 
                                                                  <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.installTravelStatusStr[I_Crm.INSTALL_TRAVEL_STATUS_CHECKED]%> 
                                                                    by</i> </td>
                                                                  <td width="34%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <div align="center"> 
                                                                        <i> 
                                                                        <%
								u = new User();
								try{
									u = DbUser.fetch(projInstallation.getApprovalTravel3());
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
                                                                        <%if(projInstallation.getApprovalTravel3()!=0){%>
                                                                        <%=JSPFormater.formatDate(projInstallation.getDateApprovalTravel3(), "dd MMMM yy")%> 
                                                                        <%}%>
                                                                        </i></div>
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                              </table>
                                                            </td>
                                                            <%
				double totalBalance = totalBudget-totalActual-totalExpense;
				String strBalance = "";
				if(totalBalance>=0){
					strBalance = JSPFormater.formatNumber(totalBalance,"#,###.##");
				}else{
					strBalance = "("+JSPFormater.formatNumber(totalBalance*-1,"#,###.##")+")";
				}
			%>
                                                            <td valign="top"> 
                                                              <%if(approvalPrivUpdate2){%>
                                                              <%if(totalBalance!=0){%>
                                                              <table width="86%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td height="20" class="tablecell1">&nbsp;&nbsp;<b><u>Settlement 
                                                                    to :</u></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <%if(totalBalance>0){%>
                                                                  <td class="tablecell">&nbsp;&nbsp;Company, 
                                                                    &nbsp;&nbsp;Amount 
                                                                    &nbsp;&nbsp;<b><%=currency.getCurrencyCode()%>. 
                                                                    <%=strBalance%></b>&nbsp;&nbsp; 
                                                                    to account&nbsp;&nbsp; 
                                                                    <%}else{%>
                                                                  <td class="tablecell">&nbsp;&nbsp;Employee, 
                                                                    &nbsp;&nbsp;Amount 
                                                                    &nbsp;&nbsp;<b><%=currency.getCurrencyCode()%>. 
                                                                    <%=strBalance%></b>&nbsp;&nbsp; 
                                                                    by account&nbsp;&nbsp; 
                                                                    <%}%>
                                                                    <%if(projInstallation.getTravelStatus()!=I_Crm.INSTALL_BUGDET_STATUS_ISSUED){%>
                                                                    <select name="account">
                                                                      <%
								Vector accLinksDebet = DbAccLink.list(0,0, "(type='"+I_Project.ACC_LINK_GROUP_CASH+"' or type='"+I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_DEBET+"') and (location_id="+sysCompany.getSystemLocation()+" or location_id="+0+")", "");
								if(accLinksDebet!=null && accLinksDebet.size()>0){
									for(int i=0; i<accLinksDebet.size(); i++){
										AccLink accLink = (AccLink)accLinksDebet.get(i);
										Coa coa = new Coa();
										try{
											coa = DbCoa.fetchExc(accLink.getCoaId());
										}catch(Exception e){
											System.out.println(e);
										}
						  %>
                                                                      <option <%if(projInstallation.getCoaId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                                                      <%	}	}%>
                                                                    </select>
                                                                    <%}else{
					  		Coa coa = new Coa();
							try{
								coa = DbCoa.fetchExc(projInstallation.getCoaId());
							}catch(Exception e){
								System.out.println(e); 
							}
					  %>
                                                                    <input type="text" size="50" name="account_name" value="<%=coa.getCode()+" - "+coa.getName()%>" class="readonly" readonly>
                                                                    <input type="hidden" name="account" value="<%=coa.getOID()%>" class="readonly" readonly>
                                                                    <%}%>
                                                                    <input type="hidden" name="balance" value="<%=totalBalance%>" class="readonly" readonly>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}}%>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" width="31%">&nbsp;</td>
                                                            <td height="8" colspan="2">&nbsp; 
                                                            </td>
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

