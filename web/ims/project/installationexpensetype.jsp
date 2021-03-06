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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_EXPENSE_TYPE);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_EXPENSE_TYPE, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_EXPENSE_TYPE, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long projectInstallationExpenseTypeOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Description","70%");
		jsplist.addHeader("Account Code","30%");
		//jsplist.addHeader("Account Code 2","1%");
		//jsplist.addHeader("Account Code 3","1%");
		//jsplist.addHeader("Company Id","1%");
		//jsplist.addHeader("Reference","1%");
		//jsplist.addHeader("Amount","1%");

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
			ProjectInstallationExpenseType objProjectInstallationExpenseType = (ProjectInstallationExpenseType)objectClass.get(i);
			Vector rowx = new Vector();
			if(projectInstallationExpenseTypeOid == objProjectInstallationExpenseType.getOID())
				index = i;

				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectInstallationExpenseType.getOID())+"')\">"+objProjectInstallationExpenseType.getDescription()+"</a>");
				rowx.add(objProjectInstallationExpenseType.getAccountCode1());
				//rowx.add(objProjectInstallationExpenseType.getAccountCode2());
				//rowx.add(objProjectInstallationExpenseType.getAccountCode3());
				//rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationExpenseType.getCompanyId())+"</div>");
				//rowx.add(objProjectInstallationExpenseType.getReference());
				//rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationExpenseType.getAmount())+"</div>");
			lstData.add(rowx);
		}
		return jsplist.draw(index);
	}
%>
<%
	int iCommand = JSPRequestValue.requestCommand(request);
	//if(iCommand==JSPCommand.NONE)
	//{
	//	iCommand = JSPCommand.ADD;
	//}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectInstallationExpenseType = JSPRequestValue.requestLong(request, "hidden_projectinstallationexpensetype");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdProjectInstallationExpenseType cmdProjectInstallationExpenseType = new CmdProjectInstallationExpenseType(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectInstallationExpenseType = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectInstallationExpenseType.action(iCommand , oidProjectInstallationExpenseType, systemCompanyId);
	iErrCode = cmdProjectInstallationExpenseType.action(iCommand , oidProjectInstallationExpenseType);

	// end switch
	JspProjectInstallationExpenseType jspProjectInstallationExpenseType = cmdProjectInstallationExpenseType.getForm();

	// count list All ProjectInstallationExpenseType
	int vectSize = DbProjectInstallationExpenseType.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectInstallationExpenseType.getErrors());

	ProjectInstallationExpenseType projectInstallationExpenseType = cmdProjectInstallationExpenseType.getProjectInstallationExpenseType();
	msgString =  cmdProjectInstallationExpenseType.getMessage();
	//out.println(msgString);

	// switch list ProjectInstallationExpenseType
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectInstallationExpenseType.generateFindStart(projectInstallationExpenseType.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectInstallationExpenseType.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectInstallationExpenseType = DbProjectInstallationExpenseType.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectInstallationExpenseType.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectInstallationExpenseType = DbProjectInstallationExpenseType.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	projectInstallationExpenseType = new ProjectInstallationExpenseType();
	//	oidProjectInstallationExpenseType = 0;
	//}
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

	<%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
	<%}%>

	function cmdAdd(){
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value="0";
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdAsk(oidProjectInstallationExpenseType){
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value=oidProjectInstallationExpenseType;
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdDelete(oidProjectInstallationExpenseType){
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value=oidProjectInstallationExpenseType;
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdConfirmDelete(oidProjectInstallationExpenseType){
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value=oidProjectInstallationExpenseType;
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdSave(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
		}

	function cmdEdit(oidProjectInstallationExpenseType){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value=oidProjectInstallationExpenseType;
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallationExpenseType){
		document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value=oidProjectInstallationExpenseType;
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdBack(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallationexpensetype.hidden_projectinstallationexpensetype.value="0";
		//document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallationexpensetype.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationexpensetype.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationexpensetype.action="installationexpensetype.jsp?menu_idx=<%=menuIdx%>";
		document.frmprojectinstallationexpensetype.submit();
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
                                                <form name="frmprojectinstallationexpensetype" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallationexpensetype" value="<%=oidProjectInstallationExpenseType%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; <span class="lvl2">Installation 
                                                              Expense Type<br>
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
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="3"></td>
                                                                </tr>
                                                                <%
							 try
							 {
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
                                                                    <table width="60%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%=drawList(listProjectInstallationExpenseType,oidProjectInstallationExpenseType, approot, start, recordToGet)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <% 
							 } catch(Exception exc){}
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="3" class="command"> 
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
							  if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0)
							  {
							%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
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
                                                              <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspProjectInstallationExpenseType.errorSize()>0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <%
%>
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Description</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_DESCRIPTION] %>"  value="<%= projectInstallationExpenseType.getDescription() %>" class="formElemen" size="50">
                                                                    <%= jspProjectInstallationExpenseType.getErrorMsg(jspProjectInstallationExpenseType.JSP_DESCRIPTION) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Account 
                                                                    Code</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_ACCOUNT_CODE_1] %>"  value="<%= projectInstallationExpenseType.getAccountCode1() %>" class="formElemen">
                                                                    <%= jspProjectInstallationExpenseType.getErrorMsg(jspProjectInstallationExpenseType.JSP_ACCOUNT_CODE_1) %> 
                                                                    <!--
						  <tr align="left">
							<td height="21" width="9%">&nbsp;Account Code 2</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_ACCOUNT_CODE_2] %>"  value="<%= projectInstallationExpenseType.getAccountCode2() %>" class="formElemen">
						  <tr align="left">
							<td height="21" width="9%">&nbsp;Account Code 3</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_ACCOUNT_CODE_3] %>"  value="<%= projectInstallationExpenseType.getAccountCode3() %>" class="formElemen">
						  <tr align="left">
							<td height="21" width="9%">&nbsp;Company Id</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_COMPANY_ID] %>"  value="<%= projectInstallationExpenseType.getCompanyId() %>" class="formElemen">
						  <tr align="left">
							<td height="21" width="9%">&nbsp;Reference</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_REFERENCE] %>"  value="<%= projectInstallationExpenseType.getReference() %>" class="formElemen">
						  <tr align="left">
							<td height="21" width="9%">&nbsp;Amount</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspProjectInstallationExpenseType.colNames[jspProjectInstallationExpenseType.JSP_AMOUNT] %>"  value="<%= projectInstallationExpenseType.getAmount() %>" class="formElemen">
					-->
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
			 String scomDel = "javascript:cmdAsk('"+oidProjectInstallationExpenseType+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectInstallationExpenseType+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectInstallationExpenseType+"')";
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

