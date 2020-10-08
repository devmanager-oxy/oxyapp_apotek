<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.payroll.*" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_DETAIL);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_DETAIL, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_DETAIL, AppMenu.PRIV_UPDATE);
%>
<%!
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
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long projectId = JSPRequestValue.requestLong(request, "oid");	
	int iCommand = JSPRequestValue.requestCommand(request);
	
	/*
	if(iCommand==JSPCommand.NONE)
	{
		iCommand = JSPCommand.EDIT;
	}
	*/

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProject = JSPRequestValue.requestLong(request, "oid");
	//long oidProposal = JSPRequestValue.requestLong(request, "hidden_proposal_id");
	long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
	
	//out.println("oidProposal : "+oidProposal);
	/*
	Proposal proposal = new Proposal();
	try{
		proposal = DbProposal.fetchExc(oidProposal);
	}
	catch(Exception e){
	}
	*/
	
	Project project = new Project();
	try{
		Vector v = DbProject.list(0,0, "project_id="+oidProject, "");
		if(v!=null && v.size()>0){
			project = (Project)v.get(0);
			oidProject = project.getOID();
		}
	}
	catch(Exception e){
	}

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId;
	String whereClause = "project_id="+project.getOID();
	String orderClause = "";

	CmdProject cmdProject = new CmdProject(request);
	JSPLine jspLine = new JSPLine();
	Vector listProject = new Vector(1,1);
	
	iErrCode = cmdProject.action(iCommand , oidProject, sysCompany.getOID());
	//iErrCode = cmdProject.action(iCommand , oidProject);
	JspProject jspProject = cmdProject.getForm();

	// count list All Project
	int vectSize = DbProject.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProject.getErrors());

	project = cmdProject.getProject();	
	msgString =  cmdProject.getMessage();

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProject.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProject = DbProject.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProject.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProject = DbProject.list(start,recordToGet, whereClause , orderClause);
	}

	 boolean save = false;
	 boolean edit = false;
	
	//for get value customer
	oidProject = project.getOID();
	oidCustomer = project.getCustomerId();//JSPRequestValue.requestLong(request, jspProject.colNames[JspProject.JSP_CUSTOMER_ID]);
	Customer csm = new Customer();
	try{
		csm = DbCustomer.fetchExc(oidCustomer);
	}catch(Exception e){
		System.out.println();
	}
	
	//save 
	/*
	if(iCommand==JSPCommand.SAVE && iErrCode==0){
	
	
	//simpan terlebih dahulu data customer beru data projectnya
	CmdCustomer cmdCustomer = new CmdCustomer(request);
	Vector listCustomer = new Vector(1,1);
	
	//iErrCode = cmdCustomer.action(iCommand , oidCustomer, systemCompanyId);
	iErrCode = cmdCustomer.action(iCommand , oidCustomer);
	//JspProject jspProject = cmdProject.getForm();
		
			
		
		if(proposal.getStatus()!=I_Crm.PROPOSAL_STATUS_PROJECT){
			try{
				proposal.setRevisedDate(new Date());
				proposal.setRevisedById(user.getOID());
				proposal.setStatus(I_Crm.PROPOSAL_STATUS_PROJECT);
				DbProposal.updateExc(proposal);
			}
			catch(Exception e){
			}
		}
	
		Vector vProjConfirm = DbProjectOrderConfirmation.list(0,0,"project_id="+oidProject,"");		
		ProjectOrderConfirmation projConfirm = new ProjectOrderConfirmation();
		try{
			projConfirm = (ProjectOrderConfirmation)vProjConfirm.get(0);		
		}catch(Exception e){
			System.out.println(e);
		}
		if(projConfirm.getOID()>0){
			projConfirm.setStatus(I_Crm.CONFIRM_STATUS_DRAFT);
			try{
				DbProjectOrderConfirmation.updateExc(projConfirm);
			}catch(Exception e){
				System.out.println(e);
			}
		}		
	}
	*/
	
	//================================= end ==================================
	
	//Vector currencies = DbCurrency.list(0,0,"company_id="+systemCompanyId, "");
	Vector currencies = DbCurrency.list(0,0,"", "");
	ExchangeRate eRate = DbExchangeRate.getStandardRate(sysCompany.getOID());
	
	/*
	Customer cs = new Customer();		
	//Vector vCustomer = DbCustomer.list(0,0, "company_id="+systemCompanyId, "");		
	Vector vCustomer = DbCustomer.list(0,0, "", "");
	Vector Customer_value = new Vector(1,1);
	Vector Customer_key = new Vector(1,1);
	if(vCustomer!=null && vCustomer.size()>0)
	{
		for(int i=0; i<vCustomer.size(); i++)
		{
			//cs = (Customer)vCustomer.get(0);
			//tidak dipakai karena customer dipilih sebelum masuk project
			Customer c = (Customer)vCustomer.get(i);
			Customer_key.add(c.getName().trim());
			Customer_value.add(""+c.getOID());
		}
	}
	*/

	Vector vEmployee = DbEmployee.list(0,0, "", "");
	Vector Employee_value = new Vector(1,1);
	Vector Employee_key = new Vector(1,1);
	if(vEmployee!=null && vEmployee.size()>0)
	{
		for(int i=0; i<vEmployee.size(); i++)
		{
			Employee c = (Employee)vEmployee.get(i);
			Employee_key.add(c.getEmpNum() +" / "+c.getName().trim());
			Employee_value.add(""+c.getOID());
		}
	}


	//Vector vCurrency = DbCurrency.list(0,0, "company_id="+systemCompanyId, "");
	Vector vCurrency = DbCurrency.list(0,0, "", "");
	Vector Currency_value = new Vector(1,1);
	Vector Currency_key = new Vector(1,1);
	if(vCurrency!=null && vCurrency.size()>0)
	{
		for(int i=0; i<vCurrency.size(); i++)
		{
			Currency c = (Currency)vCurrency.get(i);
			Currency_key.add(c.getCurrencyCode().trim());
			Currency_value.add(""+c.getOID());
		}
	}
	
	Vector status_value = new Vector(1,1);
	Vector status_key = new Vector(1,1);
	status_value.add(""+I_Crm.PROJECT_STATUS_DRAFT);
	status_key.add(I_Crm.projectStatusStr[I_Crm.PROJECT_STATUS_DRAFT]);
	status_value.add(""+I_Crm.PROJECT_STATUS_AMEND);
	status_key.add(I_Crm.projectStatusStr[I_Crm.PROJECT_STATUS_AMEND]);
	
	Vector listProjectTerm = DbProjectTerm.list(0,0,"project_id="+projectId,"squence");
		
	double totalAmount = getTotalDetail(listProjectTerm);
	double totalBalance = project.getAmount()-totalAmount;
	
	//out.println("amount ="+JSPFormater.formatNumber(totalAmount, "#,###.##"));
	//out.println("balance ="+JSPFormater.formatNumber(totalBalance, "#,###.##"));
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

	function srcCustomer(){
		window.open("customerpglist.jsp","customerpglist","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
    }

	<%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
	<%}%>

	var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
	var usrDigitGroup = "<%=sUserDigitGroup%>";
	var usrDecSymbol = "<%=sUserDecimalSymbol%>";

	function cmdUpdateExchange(){
		var idCurr = document.frmproject.<%=jspProject.colNames[JspProject.JSP_CURRENCY_ID]%>.value;
	
		<%if(currencies!=null && currencies.size()>0){
			for(int i=0; i<currencies.size(); i++){
				Currency cx = (Currency)currencies.get(i);
		%>
				if(idCurr=='<%=cx.getOID()%>'){
					<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
						document.frmproject.<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE]%>.value="<%=eRate.getValueIdr()%>";
					<%}
					else if(cx.getCurrencyCode().equals(USDCODE)){%>
						document.frmproject.<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
					<%}
					else if(cx.getCurrencyCode().equals(EURCODE)){%>
						document.frmproject.<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
					<%}%>
				}	
			<%}
			}%>

		var famount = document.frmproject.<%=jspProject.colNames[jspProject.JSP_AMOUNT]%>.value;
		
		//famount = removeChar(famount);
		famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var fbooked = document.frmproject.<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE]%>.value;
		fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
		if(!isNaN(famount)){
			document.frmproject.<%=jspProject.colNames[jspProject.JSP_EXCHANGE_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			document.frmproject.<%=jspProject.colNames[jspProject.JSP_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		}
		//checkNumber2();
	}
	
	function checkNumber(){
		var number = document.frmproject.<%=jspProject.colNames[jspProject.JSP_AMOUNT] %>.value;
		number = cleanNumberFloat(number, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		document.frmproject.<%=jspProject.colNames[jspProject.JSP_AMOUNT] %>.value = formatFloat((parseFloat(number)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}

	function cmdAdd(){
		document.frmproject.oid.value="0";
		document.frmproject.command.value="<%=JSPCommand.ADD%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdAsk(oidProject){
		document.frmproject.oid.value=oidProject;
		document.frmproject.command.value="<%=JSPCommand.ASK%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdDelete(oidProject){
		document.frmproject.oid.value=oidProject;
		document.frmproject.command.value="<%=JSPCommand.ASK%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdConfirmDelete(oidProject){
		document.frmproject.oid.value=oidProject;
		document.frmproject.command.value="<%=JSPCommand.DELETE%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}
/*
	function cmdSave(){
		<%if(project.getStatus()!=I_Crm.PROPOSAL_STATUS_PROJECT){%>
			//if(confirm("Are you sure to save this project ?\nthis action will update proposal status to PROJECT\nand will lock proposal for update!")){
			if(confirm("Are you sure to save this project ?")){
				document.frmproject.command.value="<%=JSPCommand.SAVE%>";
				document.frmproject.prev_command.value="<%=prevCommand%>";
				document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
				document.frmproject.submit();
			}
		<%}else{%>
				document.frmproject.command.value="<%=JSPCommand.SAVE%>";
				document.frmproject.prev_command.value="<%=prevCommand%>";
				document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
				document.frmproject.submit();
		<%}%>
	}
	
*/
	function cmdSave(){
		document.frmproject.command.value="<%=JSPCommand.SAVE%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdEdit(oidProject){
		<%if(masterPrivUpdate){%>
		document.frmproject.oid.value=oidProject;
		document.frmproject.command.value="<%=JSPCommand.EDIT%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
		<%}%>
		}

	function cmdCancel(oidProject){
		document.frmproject.oid.value=oidProject;
		document.frmproject.command.value="<%=JSPCommand.EDIT%>";
		document.frmproject.prev_command.value="<%=prevCommand%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdBack(){
		document.frmproject.command.value="<%=JSPCommand.BACK%>";
		//document.frmproject.oid.value="0";
		//document.frmproject.command.value="<%=JSPCommand.ADD%>";
		//document.frmproject.action="newproject.jsp";
		document.frmproject.action="../homepg.jsp";
		document.frmproject.submit();
		}

	function cmdListFirst(){
		document.frmproject.command.value="<%=JSPCommand.FIRST%>";
		document.frmproject.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdListPrev(){
		document.frmproject.command.value="<%=JSPCommand.PREV%>";
		document.frmproject.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
		}

	function cmdListNext(){
		document.frmproject.command.value="<%=JSPCommand.NEXT%>";
		document.frmproject.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function cmdListLast(){
		document.frmproject.command.value="<%=JSPCommand.LAST%>";
		document.frmproject.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
		document.frmproject.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
	}
	
	function loadCustomer(){		
		document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmproject.submit();
	}
	
	function newCustomer(){
		window.open("newcustomer.jsp","stockreport","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
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
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif')">
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
                                                <form name="frmproject" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="oid" value="<%=oidProject%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"> 
                                                              <span class="level1"> 
                                                              <%if(oidProject==0){%>
                                                              </span><span class="lvl2"> 
                                                              New </span> &raquo; 
                                                              <%}%>
                                                              <span class="lvl2"> 
                                                              Project Detail<br>
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
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tab" nowrap>Project 
                                                              Detail</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            </td>
                                                            <%
																if(project.getOID()>0)
																{
															%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Product 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%
															  	if((project.getAmount()!=0)||(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT)||(project.getStatus()==I_Crm.PROJECT_STATUS_REJECT)){																 
															  %>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Payment 
                                                              Term</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if((totalBalance==0)||(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT)||(project.getStatus()==I_Crm.PROJECT_STATUS_REJECT)){%>
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
                                                            <% }}}} %>
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
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="3"><br>
                                                              <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspProject.errorSize()>=0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr align="left"> 
                                                                  <td height="10" colspan="5"></td>
                                                                </tr>
                                                                <td height="5" colspan="5"></td>
                                                                <%if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){%>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Unit 
                                                                    Usaha </td>
                                                                  <td height="21" colspan="4"> 
                                                                    <%
																	Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
																	%>
                                                                    <select name="<%=jspProject.colNames[jspProject.JSP_UNIT_USAHA_ID] %>">
                                                                      <%if(unitUsh!=null && unitUsh.size()>0){
																	  for(int i=0; i<unitUsh.size(); i++){
																	  	UnitUsaha us = (UnitUsaha)unitUsh.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==project.getUnitUsahaId()){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                <tr align="left"> 
                                                                  <td height="5" colspan="5"></td>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Number</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <%
																		int counter = DbProject.getNextCounter(sysCompany.getOID());
																		String strNumber = DbProject.getNextNumber(counter, sysCompany.getOID());
																		
																		//if(project.getOID()!=0 && project.getNumber()!=null && project.getNumber().length()>0){
																		if(project.getNumber()!=null && project.getNumber().length()>0){
																			strNumber = project.getNumber();
																		}									  
																	
																	%>
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_NUMBER] %>"  value="<%=strNumber%>" size="30" >
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_NUMBER) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Date</td>
                                                                  <td height="21" colspan="2"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_DATE]%>" value="<%=JSPFormater.formatDate((project.getDate()==null) ? new Date() : project.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.<%=jspProject.colNames[jspProject.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_DATE) %> 
                                                                  <td height="21" width="9%" nowrap>&nbsp;Project 
                                                                    Status</td>
                                                                  <td height="21" width="49%"> 
                                                                    : <b><%=I_Crm.projectStatusStr[project.getStatus()]%> 
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_STATUS]%>" value="<%=I_Crm.PROJECT_STATUS_DRAFT%>" class="readonly" readonly>
                                                                    </b> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Name</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_NAME] %>"  value="<%= project.getName() %>" class="formElemen" size="40">
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_NAME) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Customer</td>
                                                                  <td height="21" width="23%" nowrap> 
                                                                    <input type="hidden" name="<%=jspProject.colNames[JspProject.JSP_CUSTOMER_ID]%>"  value="<%=project.getCustomerId()%>" class="formElemen">
                                                                    <input type="text" name="customer_name" value="<%=csm.getName()%>" size="40" >
                                                                  <td height="21" width="9%"> 
                                                                    <%if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){//iCommand==JSPCommand.ADD){%>
                                                                    <a href="javascript:srcCustomer()"><img src="../images/search.gif" width="59" height="21" border="0"></a> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td height="21" width="9%">&nbsp;Sales 
                                                                    Person</td>
                                                                  <td height="21" width="49%"> 
                                                                    <%= JSPCombo.draw(jspProject.colNames[JspProject.JSP_EMPLOYEE_ID],null, ""+project.getEmployeeId(), Employee_value , Employee_key, "formElemen", "") %> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_EMPLOYEE_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Address</td>
                                                                  <td height="21" width="23%"> 
                                                                    <textarea name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_ADDRESS] %>" cols="40" rows="3" ><%= csm.getAddress()+", \n"+csm.getCity()+", "+csm.getState()+" - "+csm.getCountryName()  %></textarea>
                                                                  <td height="21" width="9%">&nbsp;</td>
                                                                  <td height="21" width="9%">&nbsp;Phone/Mobile</td>
                                                                  <td height="21" width="49%"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_EMPLOYEE_HP] %>"  value="<%= project.getEmployeeHp() %>" class="formElemen" size="30">
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_EMPLOYEE_HP) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Contact 
                                                                    Person</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC] %>"  value="<%= project.getCustomerPic() %>" class="formElemen" size="40">
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_CUSTOMER_PIC) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Position</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC_POSITION] %>"  value="<%=project.getCustomerPicPosition()%>" class="formElemen" size="40">
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_CUSTOMER_PIC_POSITION) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Phone/Mobile</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC_PHONE] %>"  value="<%= project.getCustomerPicPhone() %>" class="formElemen" size="40">
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_CUSTOMER_PIC_PHONE) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Start 
                                                                    Date</td>
                                                                  <td height="21" colspan="2"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((project.getStartDate()==null) ? new Date() : project.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.<%=jspProject.colNames[jspProject.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_START_DATE) %> 
                                                                  <td height="21" width="9%">&nbsp;End 
                                                                    Date</td>
                                                                  <td height="21" width="49%"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((project.getEndDate()==null) ? new Date() : project.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.<%=jspProject.colNames[jspProject.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_END_DATE) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Currency</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <%= JSPCombo.draw(jspProject.colNames[JspProject.JSP_CURRENCY_ID],null, ""+project.getCurrencyId(), Currency_value , Currency_key, "onChange=\"javascript:cmdUpdateExchange()\"", "formElemen") %> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_CURRENCY_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4">&nbsp; 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%"><b><font size="2">&nbsp;Total 
                                                                    Amount</font></b></td>
                                                                  <td height="21" colspan="4"> 
                                                                    <b><font size="2">: 
                                                                    <%=JSPFormater.formatNumber(project.getAmount(),"#,###.##") %> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_AMOUNT) %> 
                                                                    </font></b> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr> 
                                                                  <td colspan="5"><b><i>Project 
                                                                    Description</i></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="5"> 
                                                                    <textarea name="<%=jspProject.colNames[jspProject.JSP_DESCRIPTION] %>" cols="130" rows="6" class="formElemen"><%= project.getDescription() %></textarea>
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_DESCRIPTION) %> 
                                                                  </td>
                                                                </tr>
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_USER_ID] %>"  value="<%=appSessUser.getUserOID() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_STATUS] %>"  value="<%= project.getStatus() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT_PERCENT] %>"  value="<%= project.getDiscountPercent() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT_AMOUNT] %>"  value="<%= project.getDiscountAmount() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT] %>"  value="<%= project.getDiscount() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_VAT] %>"  value="<%= project.getVat() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_MANUAL_DATE] %>"  value="<%=JSPFormater.formatDate((project.getManualDate()==null) ? new Date() : project.getManualDate(), "dd/MM/yyyy")%>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_WARRANTY_DATE] %>"  value="<%=JSPFormater.formatDate((project.getWarrantyDate()==null) ? new Date() : project.getWarrantyDate(), "dd/MM/yyyy")%>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE] %>"  value="<%= project.getBookingRate() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_EXCHANGE_AMOUNT] %>"  value="<%= project.getExchangeAmount() %>" class="formElemen">
                                                                <%}else{%>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Unit 
                                                                    Usaha </td>
                                                                  <td height="21" colspan="4"> 
                                                                    <strong> 
                                                                    <%
																  UnitUsaha us = new UnitUsaha();
																  try{
																  	us = DbUnitUsaha.fetchExc(project.getUnitUsahaId());
																  }
																  catch(Exception e){
																  } 
																  %>
                                                                    <%=us.getName().toUpperCase()%></strong> 
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_UNIT_USAHA_ID] %>"  value="<%=project.getUnitUsahaId()%>" class="formElemen" size="30" readonly>
                                                                  </td>
                                                                </tr>
                                                                <tr align="left"> 
                                                                  <td height="5" colspan="5"> 
                                                                   </td>
                                                                </tr>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Number</td>
                                                                  <td height="21" colspan="4"><strong><%=project.getNumber()%></strong> 
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_NUMBER] %>"  value="<%=project.getNumber()%>" class="formElemen" size="30" readonly>
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_NUMBER_PREFIX] %>"  value="<%= project.getNumberPrefix() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_COUNTER] %>"  value="<%= project.getCounter() %>" class="formElemen">
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Date</td>
                                                                  <td height="21" width="23%"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_DATE]%>" value="<%=JSPFormater.formatDate((project.getDate()==null) ? new Date() : project.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" class="readonly" readOnly>
                                                                  <td height="21" width="9%">&nbsp;</td>
                                                                  <td height="21" width="9%">&nbsp;Project 
                                                                    Status</td>
                                                                  <td height="21" width="49%"> 
                                                                    : 
                                                                    <%if(project.getStatus()==I_Crm.PROJECT_STATUS_AMEND){%>
                                                                    <%= JSPCombo.draw(jspProject.colNames[JspProject.JSP_STATUS],null, ""+project.getStatus(), status_value , status_key, "formElemen", "") %> 
                                                                    <%= jspProject.getErrorMsg(jspProject.JSP_STATUS) %> 
                                                                    <%}else{%>
                                                                    <input name="status" type="text" value="<%=I_Crm.projectStatusStr[project.getStatus()]%>" class="readonly" readonly>
                                                                    <%}%>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Name</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_NAME] %>"  value="<%= project.getName() %>" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Customer</td>
                                                                  <td height="21" width="23%"> 
                                                                    <%
								Customer cust = new Customer();
								try{
									cust = DbCustomer.fetchExc(project.getCustomerId());
								}catch(Exception e){
									System.out.println(e);
								}
							%>
                                                                    <input type="text" name="customer"  value="<%=cust.getName()%>" class="readonly" size="40" readonly>
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_ID] %>"  value="<%=cust.getOID()%>" class="readonly" size="40" readonly>
                                                                  <td height="21" width="9%">&nbsp;</td>
                                                                  <td height="21" width="9%">&nbsp;Sales 
                                                                    Person</td>
                                                                  <td height="21" width="49%"> 
                                                                    <%
								Employee emp = new Employee();
								try{
									emp = DbEmployee.fetchExc(project.getEmployeeId());
								}catch(Exception e){
									System.out.println(e);
								}
							%>
                                                                    <input type="text" name="employee"  value="<%=emp.getName()%>" class="readonly" size="40" readonly>
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_EMPLOYEE_ID] %>"  value="<%=emp.getOID()%>" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Address</td>
                                                                  <td height="21" width="23%"> 
                                                                    <textarea name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_ADDRESS] %>" cols="40" rows="3" class="readonly" readonly><%= cust.getAddress()+", \n"+cust.getCity()+", "+cust.getState()+" - "+cust.getCountryName()  %></textarea>
                                                                  <td height="21" width="9%">&nbsp;</td>
                                                                  <td height="21" width="9%">&nbsp;Phone/Mobile</td>
                                                                  <td height="21" width="49%"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_EMPLOYEE_HP] %>"  value="<%= project.getEmployeeHp() %>" class="readonly" size="30" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Contact 
                                                                    Person</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC] %>"  value="<%= project.getCustomerPic() %>" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Position</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC_POSITION] %>"  value="<%= project.getCustomerPicPosition() %>" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Phone/Mobile</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input type="text" name="<%=jspProject.colNames[jspProject.JSP_CUSTOMER_PIC_PHONE] %>"  value="<%= project.getCustomerPicPhone() %>" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Start 
                                                                    Date</td>
                                                                  <td height="21" width="23%"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((project.getStartDate()==null) ? new Date() : project.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" class="readonly" readOnly>
                                                                  <td height="21" width="9%">&nbsp;</td>
                                                                  <td height="21" width="9%">&nbsp;End 
                                                                    Date</td>
                                                                  <td height="21" width="49%"> 
                                                                    <input name="<%=jspProject.colNames[jspProject.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((project.getEndDate()==null) ? new Date() : project.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" class="readonly" readOnly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Project 
                                                                    Currency</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <%
								Currency curr = new Currency();
								try{
									curr = DbCurrency.fetchExc(project.getCurrencyId());
								}catch (Exception e){
									System.out.println(e);
								}
							%>
                                                                    <input type="text" name="currency"  value="<%=curr.getCurrencyCode()%>" class="readonly" size="11" readonly>
                                                                    <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_CURRENCY_ID] %>"  value="<%=curr.getOID()%>" class="readonly" size="11" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Total 
                                                                    Amount</td>
                                                                  <td height="21" colspan="4"> 
                                                                    <input style="text-align:right" type="text" name="<%=jspProject.colNames[jspProject.JSP_AMOUNT] %>"  value="<%=JSPFormater.formatNumber(project.getAmount(),"#,###.##") %>" onClick="this.select()" class="readonly" size="40" readonly>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;</td>
                                                                  <td height="21" colspan="4"> 
                                                                <tr> 
                                                                  <td colspan="5"><b><i>Project 
                                                                    Description</i></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="5"> 
                                                                    <textarea name="<%=jspProject.colNames[jspProject.JSP_DESCRIPTION] %>" cols="130" rows="6" class="readonly" readonly><%= project.getDescription() %></textarea>
                                                                  </td>
                                                                </tr>
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_USER_ID] %>"  value="<%=appSessUser.getUserOID() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_STATUS] %>"  value="<%= project.getStatus() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT_PERCENT] %>"  value="<%= project.getDiscountPercent() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT_AMOUNT] %>"  value="<%= project.getDiscountAmount() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_DISCOUNT] %>"  value="<%= project.getDiscount() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_VAT] %>"  value="<%= project.getVat() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_MANUAL_DATE] %>"  value="<%=JSPFormater.formatDate((project.getManualDate()==null) ? new Date() : project.getManualDate(), "dd/MM/yyyy")%>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_WARRANTY_DATE] %>"  value="<%=JSPFormater.formatDate((project.getWarrantyDate()==null) ? new Date() : project.getWarrantyDate(), "dd/MM/yyyy")%>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_BOOKING_RATE] %>"  value="<%= project.getBookingRate() %>" class="formElemen">
                                                                <input type="hidden" name="<%=jspProject.colNames[jspProject.JSP_EXCHANGE_AMOUNT] %>"  value="<%= project.getExchangeAmount() %>" class="formElemen">
                                                                <%}%>
                                                                <tr align="left"> 
                                                                  <td height="8" valign="middle" colspan="5">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="5" class="command" valign="top"> 
                                                                    <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProject+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProject+"')";
			 String scancel = "javascript:cmdEdit('"+oidProject+"')";
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
			 
			 if((project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT || project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE) && jspProject.errorSize()==0)
			 {
				 jspLine.setSaveCaption("");
			 }

		     jspLine.setAddCaption("");			
			 jspLine.setDeleteCaption(""); 

		   %>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
						<%
							if (oidCustomer==0) 
							{
								if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){
						%>
								//loadCustomer();
						<%
								}
							}
						%>						
					</script>
                                                  <script language="JavaScript">
						<%if(iErrCode!=0 || iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT){%>
							//cmdUpdateExchange();
						<%}%>
					</script>
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
