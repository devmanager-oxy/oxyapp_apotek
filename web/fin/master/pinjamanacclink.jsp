<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  11/5/2007 3:15:01 PM
	|***********************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksp.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK);
boolean bankPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK, AppMenu.PRIV_VIEW);
boolean bankPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK, AppMenu.PRIV_UPDATE);

%>
<!-- Jsp Block -->
<%!
		
	public String drawList(int iCommand, JspAccLink frmObject, AccLink objEntity, Vector objectClass,  long accLinkId, boolean isPostableOnly)
	{	
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("70%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Account Type","25%");
		//jsplist.addHeader("Department Name","25%");
		jsplist.addHeader("Bank Account","25%");
		jsplist.addHeader("Location","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		// Combobox Department
		Vector tempDept = new Vector(1,1);
		tempDept = DbDepartment.list(0,0, "", "NAME");	
		
		Vector dept_value = new Vector(1,1);
		Vector dept_key = new Vector(1,1);
		if(tempDept!=null && tempDept.size()>0){
			for(int i=0; i<tempDept.size(); i++){
				Department dp = (Department)tempDept.get(i);
				dept_key.add(dp.getName().trim());
				dept_value.add(String.valueOf(dp.getOID()).trim());										
			}
		}

		// Combobox COA
		Vector tempCoa = new Vector(1,1);
		/*if (objEntity.getDepartmentId() != 0)
		{
			//tempCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_DEPARTMENT_ID] + " = " + objEntity.getDepartmentId() + " and "+ DbCoa.colNames[DbCoa.COL_STATUS] +" = 'POSTABLE' and "+ DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] +" <> 'Expense'", "CODE");	
			tempCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_DEPARTMENT_ID] + " = " + objEntity.getDepartmentId() + " and "+ DbCoa.colNames[DbCoa.COL_STATUS] +" = 'POSTABLE'", "CODE");	
		} else
		{
			Department dpx = (Department)tempDept.get(0);
			//tempCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_DEPARTMENT_ID] + " = " + dpx.getOID() + " and "+ DbCoa.colNames[DbCoa.COL_STATUS] +" = 'POSTABLE' and "+ DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] +" <> 'Expense'", "CODE");	
			tempCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_DEPARTMENT_ID] + " = " + dpx.getOID() + " and "+ DbCoa.colNames[DbCoa.COL_STATUS] +" = 'POSTABLE'", "CODE");	
		}*/
		//only view postable account in combo				
		String wherex = "";
		if(isPostableOnly){
			wherex = "status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
		}
		tempCoa = DbCoa.list(0,0, wherex, "code");
		
		Vector coa_value = new Vector(1,1);
		Vector coa_key = new Vector(1,1);
		if(tempCoa!=null && tempCoa.size()>0){
			for(int i=0; i<tempCoa.size(); i++){
				Coa co = (Coa)tempCoa.get(i);
				
				String str = "";
				switch(co.getLevel()){
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
				
				coa_key.add(str+co.getCode().trim() + " - " + co.getName().trim());
				coa_value.add(String.valueOf(co.getOID()).trim());										
			}
		}
		
		// Combobox location
		Vector tempLoc = new Vector(1,1);
		tempLoc = DbLocation.list(0,0, "", "NAME");	
		
		Vector loc_value = new Vector(1,1);
		Vector loc_key = new Vector(1,1);
		loc_key.add("");
		loc_value.add("");
		if(tempLoc!=null && tempLoc.size()>0){
			for(int i=0; i<tempLoc.size(); i++){
				Location dp = (Location)tempLoc.get(i);
				loc_key.add(dp.getName().trim());
				loc_value.add(String.valueOf(dp.getOID()).trim());										
			}
		}
		
		// Combobox Type
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		for(int i=0; i<I_Project.pinjamanAccLink.length; i++)
		{
			type_key.add(I_Project.pinjamanAccLink[i]);
			type_value.add(I_Project.pinjamanAccLink[i]);										
		}

		int count = 0;
		for (int i = 0; i < objectClass.size(); i++) 
		{
			count = count + 1;
			AccLink objAccLink = (AccLink)objectClass.get(i);
			rowx = new Vector();
			if(accLinkId == objAccLink.getOID())
				index = i;

			if(index == i && (iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK || (iCommand==JSPCommand.SAVE && frmObject.errorSize() > 0 )))
			{
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+String.valueOf(objEntity.getType()).trim(), type_value , type_key, "formElemen", ""));
				//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_DEPARTMENT_ID],null, ""+String.valueOf(objEntity.getDepartmentId()).trim(), dept_value , dept_key,  "onChange=\"javascript:cmdDept()\"", "formElemen"));
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_COA_ID],null, ""+String.valueOf(objAccLink.getCoaId()).trim(), coa_value , coa_key, "formElemen", "")+frmObject.getErrorMsg(frmObject.JSP_COA_ID));
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_LOCATION_ID],null, ""+String.valueOf(objAccLink.getLocationId()).trim(), loc_value , loc_key, "formElemen", ""));
			}else
			{
				Department d =  new Department();
				try 
				{
					d = DbDepartment.fetchExc(objAccLink.getDepartmentId());
				} catch (Exception e)
				{
					System.out.println(e);
				}
				
				Coa c = new Coa();
				try
				{
					c = DbCoa.fetchExc(objAccLink.getCoaId());
				}
				catch (Exception e)
				{
					System.out.println(e);
				}
				
				Location l = new Location();
				try
				{
					l = DbLocation.fetchExc(objAccLink.getLocationId());
				}
				catch (Exception e)
				{
					System.out.println(e);
				}
				
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objAccLink.getOID())+"')\">"+objAccLink.getType()+"</a>");
				//rowx.add(d.getName());
				rowx.add(String.valueOf(c.getCode()) + " - " + String.valueOf(c.getName()));				
				rowx.add(String.valueOf(l.getName()));	
			} 
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && accLinkId==0))
		{ 
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+String.valueOf(objEntity.getType()).trim(), type_value , type_key, "formElemen", ""));
			//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_DEPARTMENT_ID],null, ""+String.valueOf(objEntity.getDepartmentId()).trim(), dept_value , dept_key, "onChange=\"javascript:cmdDept()\"", "formElemen"));
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_COA_ID],null, ""+String.valueOf(objEntity.getCoaId()).trim(), coa_value , coa_key, "formElemen", "")+frmObject.getErrorMsg(frmObject.JSP_COA_ID));
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_LOCATION_ID],null, ""+String.valueOf(objEntity.getLocationId()).trim(), loc_value , loc_key, "formElemen", ""));
		}
		lstData.add(rowx);
		return jsplist.draw(index);
	}
%>
<%
	String grpType = JSPRequestValue.requestString(request, "groupType");
	System.out.println(grpType);
	int iCommand = JSPRequestValue.requestCommand(request);
	//if(iCommand==JSPCommand.NONE)
	//{
	//	iCommand = JSPCommand.ADD;
	//}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidAccLink = JSPRequestValue.requestLong(request, "hidden_acclink");
	
	if(iCommand==JSPCommand.RESET){
		String accLink = JSPRequestValue.requestString(request, "reset_acclink");
		String group = JSPRequestValue.requestString(request, "reset_group");
		
		DbAccLink.resetData(accLink, group);
	}

	// variable declaration
	int recordToGet = 30;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	if (grpType.equals(""))
		grpType = "All";
	if (grpType.equals("All")){
		
		//whereClause = DbAccLink.colNames[DbAccLink.COL_TYPE] + " <> 'Cash' and "+ DbAccLink.colNames[DbAccLink.COL_TYPE] + " <> 'Petty Cash' and ";
		
		for(int i=0; i<I_Project.pinjamanAccLink.length; i++){
			whereClause = whereClause + " ("+DbAccLink.colNames[DbAccLink.COL_TYPE] + " = '"+ I_Project.pinjamanAccLink[i] + "') or"; 	
		}
		
		whereClause = "("+whereClause.substring(0, whereClause.length()-3)+")";
		
	}else{
		whereClause = DbAccLink.colNames[DbAccLink.COL_TYPE] + " = '"+ grpType + "'"; 
	}
	
	System.out.println(whereClause);
	String orderClause = DbAccLink.colNames[DbAccLink.COL_TYPE];

	CmdAccLink cmdAccLink = new CmdAccLink(request);
	JSPLine jspLine = new JSPLine();
	Vector listAccLink = new Vector(1,1);

	// switch statement
	iErrCode = cmdAccLink.action(iCommand , oidAccLink, user.getOID());//, sysCompany.getOID());

	// end switch
	JspAccLink jspAccLink = cmdAccLink.getForm();

	// count list All AccLink
	int vectSize = DbAccLink.getCount(whereClause);

	recordToGet = vectSize;

	//out.println(jspAccLink.getErrors());

	AccLink accLink = cmdAccLink.getAccLink();
	msgString =  cmdAccLink.getMessage();
	//out.println(msgString);
	
	//System.out.println("--- "+accLink.getType());

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdAccLink.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listAccLink = DbAccLink.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listAccLink.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listAccLink = DbAccLink.list(start,recordToGet, whereClause , orderClause);
	}

	//System.out.println(iCommand);
	//System.out.println(accLink.getOID());
	//System.out.println(oidAccLink);
	if(iCommand==JSPCommand.SUBMIT)
	{
		if(oidAccLink==0)
		{
			iCommand = JSPCommand.ADD;
		}else
		{
			iCommand = JSPCommand.EDIT;
		}
	}
	
%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

	function cmdResetSaja(){
		if(confirm("Warning !! \nthis action will delete previows setup data, and update to the new setup, \nare you seure ?")){
			document.frmacclink.command.value="<%=JSPCommand.RESET%>";
			document.frmacclink.action="pinjamanacclink.jsp";
			document.frmacclink.submit();
		}
	}

<%if(!bankPriv || !bankPrivView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdAdd(){
		document.frmacclink.hidden_acclink.value="0";
		document.frmacclink.command.value="<%=JSPCommand.ADD%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdAsk(oidAccLink){
		document.frmacclink.hidden_acclink.value=oidAccLink;
		document.frmacclink.command.value="<%=JSPCommand.ASK%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdDelete(oidAccLink){
		document.frmacclink.hidden_acclink.value=oidAccLink;
		document.frmacclink.command.value="<%=JSPCommand.ASK%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdConfirmDelete(oidAccLink){
		document.frmacclink.hidden_acclink.value=oidAccLink;
		document.frmacclink.command.value="<%=JSPCommand.DELETE%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdSave(){
		document.frmacclink.command.value="<%=JSPCommand.SAVE%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
		}

	function cmdEdit(oidAccLink){
		<%if(bankPrivUpdate){%>
			document.frmacclink.hidden_acclink.value=oidAccLink;
			document.frmacclink.command.value="<%=JSPCommand.EDIT%>";
			document.frmacclink.prev_command.value="<%=prevCommand%>";
			document.frmacclink.action="pinjamanacclink.jsp";
			document.frmacclink.submit();
		<%}%>
		}

	function cmdCancel(oidAccLink){
		document.frmacclink.hidden_acclink.value=oidAccLink;
		document.frmacclink.command.value="<%=JSPCommand.EDIT%>";
		document.frmacclink.prev_command.value="<%=prevCommand%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdBack(){
		document.frmacclink.command.value="<%=JSPCommand.BACK%>";
		//document.frmacclink.hidden_acclink.value="0";
		//document.frmacclink.command.value="<%=JSPCommand.ADD%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
		}

	function cmdListFirst(){
		document.frmacclink.command.value="<%=JSPCommand.FIRST%>";
		document.frmacclink.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdListPrev(){
		document.frmacclink.command.value="<%=JSPCommand.PREV%>";
		document.frmacclink.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
		}

	function cmdListNext(){
		document.frmacclink.command.value="<%=JSPCommand.NEXT%>";
		document.frmacclink.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function cmdListLast(){
		document.frmacclink.command.value="<%=JSPCommand.LAST%>";
		document.frmacclink.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmacclink.action="pinjamanacclink.jsp";
		document.frmacclink.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input");
			return false;
		}	return true;
	}
	
	function cmdDept(){
		document.frmacclink.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmacclink.submit();
	}
	
	function cmdAccGroup(){
		document.frmacclink.command.value="<%=JSPCommand.BACK%>";
		document.frmacclink.submit();
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
<script language="JavaScript">
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Account Link</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmacclink" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_acclink" value="<%=oidAccLink%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=jspAccLink.colNames[jspAccLink.JSP_USER_ID] %>" value="<%=appSessUser.getUserOID()%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left"> 
                              <td height="8" valign="top" colspan="3"></td>
                            </tr>
                            <tr align="left"> 
                              <td height="8"  colspan="3" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" class="comment" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" class="comment" width="99%">&nbsp;Account 
                                      Type&nbsp;&nbsp;&nbsp;&nbsp; 
                                      <select name="groupType" onChange="javascript:cmdAccGroup()">
                                        <option value="All" <%if(grpType.equals("All")) { %>selected<%}%>>All</option>
                                        <%
							  		for(int i=0; i<I_Project.pinjamanAccLink.length; i++)
									{
							  %>
                                        <option value="<%=I_Project.pinjamanAccLink[i]%>" <%if(I_Project.pinjamanAccLink[i].equals(grpType)) {%>selected<%}%>><%=I_Project.pinjamanAccLink[i]%></option>
                                        <%
							  		}									
							  %>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" width="1%">&nbsp;</td>
                                    <td height="10" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                  </tr>
                                  <%
							try
							{
//								if (listAccLink != null && listAccLink.size()>0)
//								{
						%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%"><%= drawList(iCommand, jspAccLink, accLink, listAccLink, oidAccLink, isPostableOnly)%> 
                                      <%//=drawList(listAccLink,oidAccLink, approot, start, recordToGet)%>
                                    </td>
                                  </tr>
                                  <%  
//								}
							}catch(Exception exc)
							{
							} 
						%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" class="command" width="1%">&nbsp;</td>
                                    <td height="8" align="left" colspan="3" class="command" width="99%"> 
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
                                      <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%						
						if(bankPrivUpdate && (iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0))
						{
					%>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" width="1%">&nbsp;</td>
                                    <td height="10" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%">&nbsp;<a href="javascript:cmdAdd()" class="command"></a><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" width="71" height="22" border="0"></a></td>
                                  </tr>
                                  <%
						}
					%>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" width="1%">&nbsp;</td>
                                    <td height="10" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%"> 
                                      <%
								jspLine.setLocationImg(approot+"/images/ctr_line");
								jspLine.initDefault();
								jspLine.setTableWidth("60%");
								String scomDel = "javascript:cmdAsk('"+oidAccLink+"')";
								String sconDelCom = "javascript:cmdConfirmDelete('"+oidAccLink+"')";
								String scancel = "javascript:cmdEdit('"+oidAccLink+"')";
								jspLine.setBackCaption("Cancel");
								//if(iCommand==JSPCommand.ADD)
								//{
									jspLine.setBackCaption("Back to List");
								//}
								jspLine.setConfirmDelCaption("Yes Delete");
								jspLine.setDeleteCaption("Delete");
								jspLine.setSaveCaption("Save");
								jspLine.setJSPCommandStyle("buttonlink");
								
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
								
								
								jspLine.setWidthAllJSPCommand("70");
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
								}
								else
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
                                      <%if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){%>
                                      <%= jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%"><font color="#FF0000"><i>Quick 
                                      Update, Please be carefull to use this feature 
                                      !</i></font> </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="1%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="99%"> 
                                      <table width="54%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="25%"> 
                                            <select name="reset_acclink">
                                              <%
							  		for(int i=0; i<I_Project.pinjamanAccLink.length; i++)
									{
							  %>
                                              <option value="<%=I_Project.pinjamanAccLink[i]%>" <%if(I_Project.pinjamanAccLink[i].equals(grpType)) {%>selected<%}%>><%=I_Project.pinjamanAccLink[i]%></option>
                                              <%
							  		}									
							  %>
                                            </select>
                                          </td>
                                          <td width="34%"> 
                                            <div align="center">Applay this account 
                                              Group</div>
                                          </td>
                                          <td width="20%"> 
                                            <select name="reset_group">
                                              <%for(int i=0; i<I_Project.accGroup.length; i++){%>
                                              <option value="<%=I_Project.accGroup[i]%>"><%=I_Project.accGroup[i]%></option>
                                              <%}%>
                                            </select>
                                          </td>
                                          <td width="18%"> 
                                            <div align="center"><a href="javascript:cmdResetSaja()">Reset 
                                              The Data</a></div>
                                          </td>
                                          <td width="3%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table>
                        </form>
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

