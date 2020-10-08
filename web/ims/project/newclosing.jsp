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
<%@ page import = "com.project.ccs.posmaster.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.general.*" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_CLOSING);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_CLOSING, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_CLOSING, AppMenu.PRIV_UPDATE);

	//Approval 1
	boolean approvalPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_CLOSING_APPROVED);
	boolean approvalPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_CLOSING_APPROVED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_CLOSING_APPROVED, AppMenu.PRIV_UPDATE);

%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long projectId = JSPRequestValue.requestLong(request, "oid");
	long oidProposal = 0;
	//out.println(projectId);
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	try{ 
		project = DbProject.fetchExc(projectId);
		oidProposal =  project.getProposalId();
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
	long oidProjectInstallation = JSPRequestValue.requestLong(request, "hidden_projectinstallation");
	
	//get Project Update
	int manualStatus = JSPRequestValue.requestInt(request, "manual_status");
	int warrantyStatus = JSPRequestValue.requestInt(request, "warranty_status");
	Date manualDate = (JSPRequestValue.requestString(request, "manual_date")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "manual_date"), "dd/MM/yyyy");
	Date warrantyDate = (JSPRequestValue.requestString(request, "warranty_date")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "warranty_date"), "dd/MM/yyyy");
	String manualReceive = JSPRequestValue.requestString(request, "manual_receive");
	String warrantyReceive = JSPRequestValue.requestString(request, "warranty_receive");
	String noteClosing = JSPRequestValue.requestString(request, "note_closing");

	//Update Project
	if(iCommand==JSPCommand.SAVE){
		project.setManualStatus(manualStatus);
		project.setWarrantyStatus(warrantyStatus);
		project.setManualDate(manualDate);
		project.setWarrantyDate(warrantyDate);
		project.setManualReceive(manualReceive);
		project.setWarrantyReceive(warrantyReceive);
		project.setNoteClosing(noteClosing);
		try{
			DbProject.updateExc(project);
		}catch(Exception e){
			System.out.println();
		}
	}
	
	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	String whereClause = "project_id="+projectId;
	String orderClause = "squence";

	// get recort Project Term Payment
	Vector listProjectTerm = DbProjectTerm.list(0,0, whereClause, orderClause);
	
	// get recort Project Product Detail
	Vector listProjectProductDetail = DbProjectProductDetail.list(0,0, whereClause, orderClause);
	
	//Close Project
	int finish = JSPRequestValue.requestInt(request, "finish");
	if(finish==I_Crm.PROJECT_STATUS_CLOSE && iCommand==JSPCommand.NONE){
		project.setStatus(I_Crm.PROJECT_STATUS_CLOSE);
		try{
			DbProject.updateExc(project);
		}catch(Exception e){
			System.out.println();
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

	<%if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){%>
		window.location="<%=approot%>/project/projectlist.jsp?target_page=3&menu_idx=<%=menuIdx%>";
	<%}%>

	function cmdClosing(){
		<%if(approvalPrivUpdate){%>
		if(confirm('Are you sure to do this action ?\nThis command could not be repeated. All data will be locked for additional new details')){
			document.frmprojectinstallation.command.value="<%=JSPCommand.NONE%>";
			document.frmprojectinstallation.finish.value="<%=I_Crm.PROJECT_STATUS_CLOSE%>";
			document.frmprojectinstallation.submit();
		}
		<%}%>
	}

	function cmdDetail(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid="+oidProjectInstallation;
		document.frmprojectinstallation.submit();
		}

	function cmdAdd(){
		document.frmprojectinstallation.hidden_projectinstallation.value="0";
		document.frmprojectinstallation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdAsk(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdDelete(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdConfirmDelete(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdSave(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdEdit(oidProjectInstallation){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallation){
		document.frmprojectinstallation.hidden_projectinstallation.value=oidProjectInstallation;
		document.frmprojectinstallation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallation.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdBack(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallation.hidden_projectinstallation.value="0";
		//document.frmprojectinstallation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallation.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallation.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallation.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallation.action="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
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
//-->
</script>
<!--End Region JavaScript-->
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/savebig2.gif')">
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
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallation" value="<%=oidProjectInstallation%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="finish" value="">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"><span class="lvl2">Closing<br>
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
                                                            <td class="tabin" nowrap><a href="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Installation</a></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tab" nowrap> 
                                                              <b>Closing</b></td>
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
                                                                <tr align="left"> 
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
                                                                  <td colspan="2" height="15"><b><u>Project 
                                                                    Closing Parameter</u></b></td>
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
                                                                  <td colspan="4" height="25"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="49%" height="20"><b>Product 
                                                                          &amp; 
                                                                          Installation 
                                                                          Detail</b></td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="46%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="49%" valign="top"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td class="boxed1"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                  <tr> 
                                                                                    <td class="tablehdr" width="49%">Product</td>
                                                                                    <td class="tablehdr" width="17%">Order</td>
                                                                                    <td class="tablehdr" width="18%">Installed</td>
                                                                                    <td class="tablehdr" width="16%">Completed</td>
                                                                                  </tr>
                                                                                  <%
															double qtyProduct = 0;
															double qtyInstall = 0;
															double qtyTotalProduct = 0;
															double qtyTotalInstall = 0;
															for (int i = 0; i < listProjectProductDetail.size(); i++) 
															{
																ProjectProductDetail objProjectProductDetail = (ProjectProductDetail)listProjectProductDetail.get(i);
																ItemMaster colCombo2  = new ItemMaster();
																try{
																	colCombo2 = DbItemMaster.fetchExc(objProjectProductDetail.getProductMasterId());
																}catch(Exception e) {
																	System.out.println(e);
																}
																qtyProduct = DbProjectInstallationProduct.getMaxQtyProduct(0,objProjectProductDetail.getOID());
																qtyTotalProduct = qtyTotalProduct + qtyProduct;																
																qtyInstall = DbProjectInstallationProduct.getMaxQtyInstallTravel(0,objProjectProductDetail.getOID());
																qtyTotalInstall = qtyTotalInstall + qtyInstall;
														%>
                                                                                  <tr> 
                                                                                    <td width="49%" class="tablecell"><%=colCombo2.getName()%></td>
                                                                                    <td width="17%" class="tablecell"> 
                                                                                      <div align="center"><%=qtyProduct%></div>
                                                                                    </td>
                                                                                    <td width="18%" class="tablecell"> 
                                                                                      <div align="center"><%=qtyInstall%></div>
                                                                                    </td>
                                                                                    <td width="16%" class="tablecell"> 
                                                                                      <div align="center"><%=(qtyProduct==qtyInstall)?"Yes":"No"%></div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%	}%>
                                                                                  <tr bgcolor="#CCCCCC"> 
                                                                                    <td width="49%" height="20"><b>T 
                                                                                      O 
                                                                                      T 
                                                                                      A 
                                                                                      L 
                                                                                      :</b></td>
                                                                                    <td width="17%" height="20"> 
                                                                                      <div align="center"><b><%=qtyTotalProduct%></b></div>
                                                                                    </td>
                                                                                    <td width="18%" height="20"> 
                                                                                      <div align="center"><b><%=qtyTotalInstall%></b></div>
                                                                                    </td>
                                                                                    <td width="16%" height="20"> 
                                                                                      <div align="center"><b><%=(qtyTotalProduct==qtyTotalInstall)?"Yes":"No"%></b></div>
                                                                                    </td>
                                                                                  </tr>
                                                                                </table>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="46%" valign="top"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td class="boxed1"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                  <tr> 
                                                                                    <td width="19%" class="tablehdr">&nbsp;</td>
                                                                                    <td width="18%" class="tablehdr">Delivered</td>
                                                                                    <td width="26%" class="tablehdr">Date</td>
                                                                                    <td width="37%" class="tablehdr">Receive 
                                                                                      By 
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="19%" class="tablecell">Manual 
                                                                                      Book</td>
                                                                                    <td width="18%" class="tablecell" align="center"><input type="checkbox" name="manual_status" value="1" <%if(project.getManualStatus()==1){%> checked <%}%> <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> disabled <%}%>>Yes 
                                                                                    </td>
                                                                                    <td width="26%" class="tablecell"> 
                                                                                      <div align="center"> 
                                                                                        <input name="manual_date" value="<%=JSPFormater.formatDate((project.getManualDate()==null) ? new Date() : project.getManualDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> class="readonly" <%}%> readOnly>
                                                                                        <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmprojectinstallation.manual_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                        <%}%>
                                                                                      </div>
                                                                                    </td>
                                                                                    <td width="37%" class="tablecell"> 
                                                                                      <div align="center"> 
                                                                                        <input type="text" name="manual_receive" size="35" value="<%=project.getManualReceive()%>" <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> class="readonly" readonly <%}%>>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="19%" class="tablecell1">Warranty 
                                                                                      Book 
                                                                                    </td>
                                                                                    <td width="18%" class="tablecell1" align="center"><input type="checkbox" name="warranty_status" value="1" <%if(project.getWarrantyStatus()==1){%> checked <%}%> <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> disabled <%}%>>Yes 
                                                                                    </td>
                                                                                    <td width="26%" class="tablecell1"> 
                                                                                      <div align="center"> 
                                                                                        <input name="warranty_date" value="<%=JSPFormater.formatDate((project.getWarrantyDate()==null) ? new Date() : project.getWarrantyDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> class="readonly" <%}%> readOnly>
                                                                                        <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmprojectinstallation.warranty_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                        <%}%>
                                                                                      </div>
                                                                                    </td>
                                                                                    <td width="37%" class="tablecell1"> 
                                                                                      <div align="center"> 
                                                                                        <input type="text" name="warranty_receive" value="<%=project.getWarrantyReceive()%>" size="35" <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> class="readonly" readonly <%}%>>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                </table>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="49%" height="8"></td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="46%"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="49%" height="20"><span class="command"><b>Project 
                                                                          Payment</b> 
                                                                          </span></td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="46%"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td rowspan="2" valign="top"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td class="boxed1"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                  <tr> 
                                                                                    <td class="tablehdr" width="22%">Type</td>
                                                                                    <td class="tablehdr" width="62%">Condition</td>
                                                                                    <td class="tablehdr" width="16%">Completed</td>
                                                                                  </tr>
                                                                                  <%
															boolean paymentStatus = true;
															for (int i = 0; i < listProjectTerm.size(); i++) 
															{
																ProjectTerm objProjectTerm = (ProjectTerm)listProjectTerm.get(i);
																if(objProjectTerm.getStatus()!=I_Crm.TERM_STATUS_FULL_PAID){
																	paymentStatus = false;
																}
														%>
                                                                                  <tr> 
                                                                                    <td class="tablecell"><%=I_Crm.termTypeStr[objProjectTerm.getType()]%></td>
                                                                                    <td class="tablecell"><%=objProjectTerm.getDescription()%></td>
                                                                                    <td class="tablecell"> 
                                                                                      <div align="center"><%=(objProjectTerm.getStatus()==I_Crm.TERM_STATUS_FULL_PAID)?"Yes":"No"%></div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <%	}%>
                                                                                  <tr bgcolor="#CCCCCC"> 
                                                                                    <td height="20">&nbsp;</td>
                                                                                    <td height="20">&nbsp;</td>
                                                                                    <td height="20"></td>
                                                                                  </tr>
                                                                                </table>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="46%" valign="top"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td> 
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                  <tr> 
                                                                                    <td width="100%"><b>Note</b></td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="100%"> 
                                                                                      <div align="left"> 
                                                                                        <textarea name="note_closing" cols="100" rows="4" <%if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%> class="readonly" readonly <%}%>><%=project.getNoteClosing()%></textarea>
                                                                                      </div>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="100%" height="8"></td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="100%"><b>Closing 
                                                                                      Message</b></td>
                                                                                  </tr>
                                                                                  <tr> 
                                                                                    <td width="100%"> 
                                                                                      <div align="left"> 
                                                                                        <textarea name="closing_message" cols="100" rows="5" class="readonly" readonly><%=(qtyTotalProduct==qtyTotalInstall)?"Product Installataion => Completed\n":"Product Installataion => Incompleted\n"%><%=(paymentStatus==true)?"Payment => Completed\n":"Payment => Incompleted\n"%><%=(project.getManualStatus()==1)?"Manual book => Delivered\n":"Manual book => Not Delivered\n"%><%=(project.getWarrantyStatus()==1)?"Warranty book => Delivered\n":"Warranty book => Not Delivered\n"%></textarea>
                                                                                      </div>
                                                                                    </td>
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
                                                                <tr align="left"> 
                                                                  <td align="left" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                      <tr valign="bottom"> 
                                                                        <td width="70%"> 
                                                                          <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                          <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new20','','../images/savebig2.gif',1)"><img src="../images/savebig.gif" name="new20" width="115" height="50" border="0"></a> 
                                                                          <%}%>
                                                                          <a href="../download/warranty_form.doc"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/warranty2.gif',1)"><img src="../images/warranty.gif" name="new21" width="170" height="50" border="0"></a> 
                                                                          <a href="../download/manual_form.doc"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/manual2.gif',1)"><img src="../images/manual.gif" name="new22" width="170" height="50" border="0"></a> 
                                                                          <a href="../download/acceptance_form.doc"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new23','','../images/accept2.gif',1)"><img src="../images/accept.gif" name="new23" width="170" height="50" border="0"></a> 
                                                                        </td>
                                                                        <td width="30%" align="right"> 
                                                                          <div align="right"> 
                                                                            <%if(qtyTotalProduct==qtyTotalInstall && paymentStatus==true && project.getManualStatus()==1 && project.getWarrantyStatus()==1){%>
                                                                            <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                            <a href="javascript:cmdClosing()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new19','','../images/closeproject2.gif',1)"><img src="../images/closeproject.gif" name="new19" width="150" height="150" border="0"></a> 
                                                                            <%}	}%>
                                                                          </div>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="3">&nbsp;</td>
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

