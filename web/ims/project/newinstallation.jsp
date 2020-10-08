<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.general.*" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long projectInstallationOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No","3%");
		jsplist.addHeader("Location","12%");
		jsplist.addHeader("Address","24%");
		jsplist.addHeader("Start Date","8%");
		jsplist.addHeader("End Date","8%");
		jsplist.addHeader("Duration","6%");
		jsplist.addHeader("Contact Person","10%");
		jsplist.addHeader("Installation Status","8%");		
		jsplist.addHeader("Budget Status","8%");
		jsplist.addHeader("Travel Status","8%");
		jsplist.addHeader("Link","6%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		int loopInt = 0;
		if(CONHandler.CONSVR_TYPE==CONHandler.CONSVR_MSSQL)
		{
			if((start + recordToGet)> objectClass.size())
			{
				loopInt = recordToGet - ((start + recordToGet) - objectClass.size());
			}
			else
			{
				loopInt = recordToGet;
			}
		}
		else
		{
			start = 0;
			loopInt = objectClass.size();
		}

		int count = 0;
		for(int i=start; (i<objectClass.size() && count<loopInt); i++)
		{
			count = count + 1;
			ProjectInstallation objProjectInstallation = (ProjectInstallation)objectClass.get(i);
			Vector rowx = new Vector();
			if(projectInstallationOid == objProjectInstallation.getOID())
				index = i;
				rowx.add("<div align=\"center\">"+count+"</div>");
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectInstallation.getOID())+"')\">"+objProjectInstallation.getLocation()+"</a>");
				Country country = new Country();
				try{
					country = DbCountry.fetchExc(objProjectInstallation.getCountryId());
				}catch(Exception e){
					System.out.println(e);
				}
				rowx.add(objProjectInstallation.getAddress()+"\n "+objProjectInstallation.getCity()+", "+objProjectInstallation.getState()+"-"+country.getName());
				String str_dt_StartDate = ""; 
				Date dt_StartDate = new Date();
				try
				{
					dt_StartDate = objProjectInstallation.getStartDate();
					if(dt_StartDate==null)
					{
						dt_StartDate = new Date();
					}
					str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMM yyyy");
				}
				catch(Exception e){ str_dt_StartDate = ""; }
				rowx.add(str_dt_StartDate);

				String str_dt_EndDate = ""; 
				Date dt_EndDate = new Date();
				try
				{
					dt_EndDate = objProjectInstallation.getEndDate();
					if(dt_EndDate==null)
					{
						dt_EndDate = new Date();
					}
					str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMM yyyy");
				}
				catch(Exception e){ str_dt_EndDate = ""; }
				rowx.add(str_dt_EndDate);
				
				long duration = DateCalc.dayDifference(dt_StartDate, dt_EndDate);
				String Duration = "";
				if (duration>0) {
					Duration = duration +" days";
				}else{
					Duration = duration + " day";
				}
				rowx.add("<div align=\"center\">"+Duration+"</div>");				
				
				Employee colCombo3  = new Employee();
				try{
				colCombo3 = DbEmployee.fetchExc(objProjectInstallation.getEmployeeId());
				}catch(Exception e) {}
				//rowx.add(colCombo3.getEmpNum()+" / "+colCombo3.getName());
				rowx.add(colCombo3.getEmpNum()+" <br> "+colCombo3.getName());

				rowx.add("<div align=\"center\">"+String.valueOf(I_Crm.installStatusStr[objProjectInstallation.getStatus()])+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(I_Crm.installBudgetStatusStr[objProjectInstallation.getBudgetStatus()])+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(I_Crm.installTravelStatusStr[objProjectInstallation.getTravelStatus()])+"</div>");
				rowx.add("<div align=\"center\"><a href=\"javascript:cmdDetail('"+String.valueOf(objProjectInstallation.getOID())+"')\">[detail]</a></div>");
			lstData.add(rowx);
		}
		return jsplist.draw(index);
	}
%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long projectId = JSPRequestValue.requestLong(request, "oid");
	long oidProposal = JSPRequestValue.requestLong(request, "hidden_proposal_id");
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
	//if(iCommand==JSPCommand.NONE)
	//{
	//	iCommand = JSPCommand.ADD;
	//}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectInstallation = JSPRequestValue.requestLong(request, "hidden_projectinstallation");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	String whereClause = "project_id="+projectId;
	String orderClause = "";

	CmdProjectInstallation cmdProjectInstallation = new CmdProjectInstallation(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectInstallation = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectInstallation.action(iCommand , oidProjectInstallation, systemCompanyId);
	iErrCode = cmdProjectInstallation.action(iCommand , oidProjectInstallation);

	// end switch
	JspProjectInstallation jspProjectInstallation = cmdProjectInstallation.getForm();

	// count list All ProjectInstallation
	int vectSize = DbProjectInstallation.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectInstallation.getErrors());

	ProjectInstallation projectInstallation = cmdProjectInstallation.getProjectInstallation();
	msgString =  cmdProjectInstallation.getMessage();
	//out.println(msgString);

	// switch list ProjectInstallation
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectInstallation.generateFindStart(projectInstallation.getOID(),recordToGet, whereClause);
	//}
	
	if(iCommand==JSPCommand.SAVE){
		if(projectInstallation.getOID()>0){
			if(projectInstallation.getBudgetStatus()==I_Crm.INSTALL_BUGDET_STATUS_AMEND && projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){
				projectInstallation.setBudgetStatus(I_Crm.INSTALL_BUGDET_STATUS_DRAFT);
				projectInstallation.setApproval2(0);
				projectInstallation.setDateApproval2(new Date());
				try{
					DbProjectInstallation.updateExc(projectInstallation);
				}catch(Exception e){
					System.out.println(e);
				}
			}
		}		
	}


	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectInstallation.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectInstallation = DbProjectInstallation.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectInstallation.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectInstallation = DbProjectInstallation.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	projectInstallation = new ProjectInstallation();
	//	oidProjectInstallation = 0;
	//}
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
	
	<%if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){%>
		window.location="<%=approot%>/project/projectlist.jsp?target_page=2&menu_idx=<%=menuIdx%>";
	<%}%>
	
	function cmdDetail(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		<%if(CRM_INSTALL_PRODUCT_ONLY){%>
		document.frmprojectinstallation.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid="+oidProjectInstallation;
		<%}else{%>
		document.frmprojectinstallation.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid="+oidProjectInstallation;
		<%}%>
		document.frmprojectinstallation.submit();
	}

	function cmdAdd(){
		document.frmprojectinstallation.hidden_projectinstallation.value="0";
		document.frmprojectinstallation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdAsk(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdDelete(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdConfirmDelete(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdSave(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdEdit(oidProjectInstallation){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdBack(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallation.hidden_projectinstallation.value="0";
		//document.frmprojectinstallation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallation.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
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
                                                <form name="frmprojectinstallation" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallation" value="<%=oidProjectInstallation%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="hidden_proposal_id" value="<%=oidProposal%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"> 
                                                              <span class="lvl2">Installation<br>
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
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>&command=<%=JSPCommand.EDIT%>" class="tablink">Project 
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
                                                                  <td width="8%"><b>Customer</b></td>
                                                                  <td width="60%"><%=customer.getName()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Name</b></td>
                                                                  <td width="22%"><%=project.getName()%></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%"><%=project.getCustomerAddress()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Amount</b></td>
                                                                  <td width="22%"><b><%=currency.getCurrencyCode()%>. 
                                                                    <%=JSPFormater.formatNumber(project.getAmount(),"#,###.##")%></b></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="60%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="8%"><b>Start 
                                                                    Date</b></td>
                                                                  <td width="22%"><%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                  <td width="8%"><b>End 
                                                                    Date</b></td>
                                                                  <td width="60%"><%=JSPFormater.formatDate(project.getEndDate(), "dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Status</b></td>
                                                                  <td width="22%"><b><%=I_Crm.projectStatusStr[project.getStatus()]%></b></td>
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
                                                                  <td colspan="4" height="25"><b>Installation 
                                                                    Detail</b></td>
                                                                </tr>
                                                                <%
							 try
							 {
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%=drawList(listProjectInstallation,oidProjectInstallation, approot, start, recordToGet)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <% 
							 } catch(Exception exc){}
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="4" class="command"> 
                                                                    <span class="command"> 
                                                                    <% 
							 int cmd = 0;
							 if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
								cmd = iCommand; 
							 else
							 {
								if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
									cmd = JSPCommand.FIRST;
								else 
									cmd = prevCommand; 
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
                                                                <%
							  if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE)
							  {
							%>
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
                                                                <%
							  }
							%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="3"><br>
                                                              <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspProjectInstallation.errorSize()>0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <%
		Vector vEmployee = DbEmployee.list(0,0, "", "");
		Vector Employee_value = new Vector(1,1);
		Vector Employee_key = new Vector(1,1);
		if(vEmployee!=null && vEmployee.size()>0)
		{
			for(int i=0; i<vEmployee.size(); i++)
			{
				Employee c = (Employee)vEmployee.get(i);
				Employee_key.add(c.getEmpNum()+" / "+c.getName().trim());
				Employee_value.add(""+c.getOID());
			}
		}

		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		status_value.add(""+I_Crm.INSTALL_STATUS_DRAFT);
		status_key.add(I_Crm.installStatusStr[I_Crm.INSTALL_STATUS_DRAFT]);
		status_value.add(""+I_Crm.INSTALL_STATUS_CANCEL);
		status_key.add(I_Crm.installStatusStr[I_Crm.INSTALL_STATUS_CANCEL]);

		
		Vector vCountry = DbCountry.list(0,0, "", "");
		Vector Country_value = new Vector(1,1);
		Vector Country_key = new Vector(1,1);
		if(vCountry!=null && vCountry.size()>0)
		{
			for(int i=0; i<vCountry.size(); i++)
			{
				Country c = (Country)vCountry.get(i);
				Country_key.add(c.getName().trim());
				Country_value.add(""+c.getOID());
			}
		}
		
%>
                                                                <%	
				String read = "";
				if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){
				}else{
					read = "readonly";
				}
			%>
                                                                <tr align="left"> 
                                                                  <td height="21" colspan="4" width="10%">&nbsp;<strong>Installation 
                                                                    Location :</strong></td>
                                                                <tr align="left"> 
                                                                  <td height="21" width="10%">&nbsp;Name</td>
                                                                  <td height="21" width="20%">&nbsp; 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_LOCATION] %>"  value="<%= projectInstallation.getLocation() %>" class="<%=read%>" size="40" <%=read%>>
                                                                  <td height="21" width="8%"><%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_LOCATION) %> 
                                                                  <td height="21" width="62%"> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Address</td>
                                                                  <td height="21" colspan="3">&nbsp; 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_ADDRESS] %>"  value="<%= projectInstallation.getAddress() %>" class="<%=read%>" size="80" <%=read%>>
                                                                    <%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_ADDRESS) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;City</td>
                                                                  <td height="21" colspan="3">&nbsp; 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_CITY] %>"  value="<%=(projectInstallation.getCity()==null)?"":projectInstallation.getCity()%>" class="<%=read%>" <%=read%>>
                                                                    <%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_CITY) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Province</td>
                                                                  <td height="21" colspan="3">&nbsp; 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_STATE] %>"  value="<%= projectInstallation.getState() %>" class="<%=read%>" <%=read%>>
                                                                    <%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_STATE) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Country 
                                                                    Id</td>
                                                                  <td height="21" colspan="3"> 
                                                                    &nbsp; 
                                                                    <%if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){%>
                                                                    <%= JSPCombo.draw(jspProjectInstallation.colNames[JspProjectInstallation.JSP_COUNTRY_ID],null, ""+projectInstallation.getCountryId(), Country_value , Country_key, "formElemen", "") %> 
                                                                    <%}else{
								Country c = new Country();
								try{
									c = DbCountry.fetchExc(projectInstallation.getCountryId());
								}catch(Exception e){
									System.out.println(e);
								}
							%>
                                                                    <input type="text" name="country"  value="<%=c.getName()%>" size="35" class="<%=read%>" <%=read%>>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_COUNTRY_ID] %>"  value="<%= projectInstallation.getCountryId() %>" class="<%=read%>" <%=read%>>
                                                                    <%}%>
                                                                    <%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_COUNTRY_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Zip 
                                                                    Code</td>
                                                                  <td height="21" colspan="3">&nbsp; 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_ZIP_CODE] %>"  value="<%= projectInstallation.getZipCode() %>" class="<%=read%>" <%=read%>>
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Start 
                                                                    Date</td>
                                                                  <td height="21">&nbsp; 
                                                                    <%//= JSPDate.drawDateWithStyle(jspProjectInstallation.colNames[jspProjectInstallation.JSP_START_DATE], (projectInstallation.getStartDate()==null) ? new Date() : projectInstallation.getStartDate(), 5,-10, "formElemen", "") %>
                                                                    <input name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((projectInstallation.getStartDate()==null) ? new Date() : projectInstallation.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" class="<%=read%>" readOnly>
                                                                    <%if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){%>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmprojectinstallation.<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%}%>
                                                                  <td height="21">End 
                                                                    Date 
                                                                  <td height="21"> 
                                                                    <%//= JSPDate.drawDateWithStyle(jspProjectInstallation.colNames[jspProjectInstallation.JSP_END_DATE], (projectInstallation.getEndDate()==null) ? new Date() : projectInstallation.getEndDate(), 5,-10, "formElemen", "") %>
                                                                    <input name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((projectInstallation.getEndDate()==null) ? new Date() : projectInstallation.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" class="<%=read%>" readOnly>
                                                                    <%if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){%>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmprojectinstallation.<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%}%>
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Contact 
                                                                    Person</td>
                                                                  <td height="21">&nbsp; 
                                                                    <%if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_DRAFT){%>
                                                                    <%= JSPCombo.draw(jspProjectInstallation.colNames[JspProjectInstallation.JSP_EMPLOYEE_ID],null, ""+projectInstallation.getEmployeeId(), Employee_value , Employee_key, "formElemen", "") %> 
                                                                    <%}else{
								Employee em = new Employee();
								try{
									em = DbEmployee.fetchExc(projectInstallation.getEmployeeId());
								}catch(Exception e){
									System.out.println(e);
								}
							%>
                                                                    <input type="text" name="emloyee"  value="<%=em.getEmpNum()+" / "+em.getName()%>" size="35" class="<%=read%>" <%=read%>>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_EMPLOYEE_ID] %>"  value="<%= projectInstallation.getEmployeeId() %>" class="<%=read%>" <%=read%>>
                                                                    <%}%>
                                                                  <td height="21">Position 
                                                                  <td height="21"> 
                                                                    <input type="text" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_PIC_POSITION] %>"  value="<%= projectInstallation.getPicPosition() %>" class="<%=read%>" <%=read%>>
                                                                    <%= jspProjectInstallation.getErrorMsg(jspProjectInstallation.JSP_PIC_POSITION) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Status</td>
                                                                  <td height="21">&nbsp; 
                                                                    <%if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_CANCEL) {%>
                                                                    <%= JSPCombo.draw(jspProjectInstallation.colNames[jspProjectInstallation.JSP_STATUS],null, ""+projectInstallation.getStatus(), status_value , status_key, "formElemen", "") %> 
                                                                    <%}else{%>
                                                                    <input type="text" name="status"  value="<%= I_Crm.installStatusStr[projectInstallation.getStatus()] %>" class="readonly" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_STATUS] %>"  value="<%= projectInstallation.getStatus() %>" class="readonly" readOnly>
                                                                    <%}%>
                                                                  <td height="21" colspan="2"> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Description</td>
                                                                  <td height="21" colspan="3">&nbsp; 
                                                                    <textarea name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DESCRIPTION] %>" cols="130" rows="6" class="<%=read%>" <%=read%>><%= projectInstallation.getDescription() %></textarea>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_USER_ID] %>"  value="<%=appSessUser.getUserOID()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_PROJECT_ID] %>"  value="<%=projectId%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDate()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_BUDGET_STATUS] %>"  value="<%= projectInstallation.getBudgetStatus() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_1] %>"  value="<%=appSessUser.getUserOID()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_1]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApproval1()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_2] %>"  value="<%=projectInstallation.getApproval2()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_2]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApproval2()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_3] %>"  value="<%=projectInstallation.getApproval3()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_3]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApproval3()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <%//Installation Travel Report Approve List%>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_TRAVEL_1] %>"  value="<%=appSessUser.getUserOID()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_TRAVEL_1]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApprovalTravel1()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_TRAVEL_2] %>"  value="<%=projectInstallation.getApprovalTravel2()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_TRAVEL_2]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApprovalTravel2()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_APPROVAL_TRAVEL_3] %>"  value="<%=projectInstallation.getApprovalTravel3()%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_DATE_APPROVAL_TRAVEL_3]%>" value="<%=JSPFormater.formatDate((projectInstallation.getDateApprovalTravel3()==null) ? new Date() : projectInstallation.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_TRAVEL_STATUS] %>"  value="<%= projectInstallation.getTravelStatus() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_COA_ID] %>"  value="<%= projectInstallation.getCoaId() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallation.colNames[jspProjectInstallation.JSP_SETTLEMENT_BALANCE] %>"  value="<%= projectInstallation.getSettlementBalance() %>" class="formElemen">
                                                                <tr align="left"> 
                                                                  <td height="8" valign="middle" colspan="4">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="4" class="command" valign="top"> 
                                                                    <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProjectInstallation+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectInstallation+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectInstallation+"')";
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
			 }else if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_IN_PROGRESS || projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH) {
				jspLine.setDeleteCaption("");
				jspLine.setSaveCaption("");
			 }else if(projectInstallation.getStatus()==I_Crm.INSTALL_STATUS_CANCEL) {
				jspLine.setDeleteCaption("");
			 }
	 
		   %>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
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

