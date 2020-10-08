
<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  10/30/2007 5:50:45 PM
	|***********************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long donorOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Code","5%");
		jsplist.addHeader("Donor Name","20%");
		jsplist.addHeader("Address","30%");
		jsplist.addHeader("Phone / Fax","11%");
		jsplist.addHeader("Contact Person","12%");
		jsplist.addHeader("Hp","10%");
		jsplist.addHeader("Description","12%");

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
			Donor objDonor = (Donor)objectClass.get(i);
			Vector rowx = new Vector();
			if(donorOid == objDonor.getOID())
				index = i;
			
			rowx.add(objDonor.getCode());
			rowx.add(objDonor.getName());

			Country c = new Country();
			try{
				c = DbCountry.fetchExc(objDonor.getCountryId());
			}
			catch(Exception e){
				System.out.print(e.toString());
			}
			
			rowx.add(objDonor.getAddress()+((objDonor.getCity().length()>0) ? ", "+objDonor.getCity() : "")+((objDonor.getState().length()>0) ? ", "+objDonor.getState() : "")+((c.getName().length()>0) ? ", "+c.getName() : ""));
						
			rowx.add(objDonor.getPhone()+" / "+((objDonor.getFax().length()>0)? objDonor.getFax() : "-"));
			rowx.add(objDonor.getContactPerson());
			rowx.add(objDonor.getHp());
			rowx.add(objDonor.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objDonor.getOID()));
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
	long oidDonor = JSPRequestValue.requestLong(request, "hidden_donor");

	// variable declaration
	int recordToGet = 20;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdDonor cmdDonor = new CmdDonor(request);
	JSPLine jspLine = new JSPLine();
	Vector listDonor = new Vector(1,1);

	// switch statement
	iErrCode = cmdDonor.action(iCommand , oidDonor);

	// end switch
	JspDonor jspDonor = cmdDonor.getForm();

	// count list All Donor
	int vectSize = DbDonor.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspDonor.getErrors());

	Donor donor = cmdDonor.getDonor();
	msgString =  cmdDonor.getMessage();
	//out.println(msgString);

	// switch list Donor
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbDonor.generateFindStart(donor.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdDonor.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listDonor = DbDonor.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listDonor.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listDonor = DbDonor.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	donor = new Donor();
	//	oidDonor = 0;
	//}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

<%if(!priv || !privView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdAdd(){
		document.frmdonor.hidden_donor.value="0";
		document.frmdonor.command.value="<%=JSPCommand.ADD%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdAsk(oidDonor){
		document.frmdonor.hidden_donor.value=oidDonor;
		document.frmdonor.command.value="<%=JSPCommand.ASK%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdDelete(oidDonor){
		document.frmdonor.hidden_donor.value=oidDonor;
		document.frmdonor.command.value="<%=JSPCommand.ASK%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdConfirmDelete(oidDonor){
		document.frmdonor.hidden_donor.value=oidDonor;
		document.frmdonor.command.value="<%=JSPCommand.DELETE%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdSave(){
		document.frmdonor.command.value="<%=JSPCommand.SAVE%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
		}

	function cmdEdit(oidDonor){
	<%if(privUpdate){%>	
		document.frmdonor.hidden_donor.value=oidDonor;
		document.frmdonor.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	<%}%>
		}
		

	function cmdCancel(oidDonor){
		document.frmdonor.hidden_donor.value=oidDonor;
		document.frmdonor.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonor.prev_command.value="<%=prevCommand%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdBack(){
		document.frmdonor.command.value="<%=JSPCommand.BACK%>";
		//document.frmdonor.hidden_donor.value="0";
		//document.frmdonor.command.value="<%=JSPCommand.ADD%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
		}

	function cmdListFirst(){
		document.frmdonor.command.value="<%=JSPCommand.FIRST%>";
		document.frmdonor.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdListPrev(){
		document.frmdonor.command.value="<%=JSPCommand.PREV%>";
		document.frmdonor.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
		}

	function cmdListNext(){
		document.frmdonor.command.value="<%=JSPCommand.NEXT%>";
		document.frmdonor.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
	}

	function cmdListLast(){
		document.frmdonor.command.value="<%=JSPCommand.LAST%>";
		document.frmdonor.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmdonor.action="donor.jsp";
		document.frmdonor.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" -->
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Donor</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <!--Begin Region Content-->
                        <form name="frmdonor" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_donor" value="<%=oidDonor%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
								if (listDonor.size()>0)
								{
						%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3" class="boxed1"> 
                                            <%=drawList(listDonor,oidDonor, approot, start, recordToGet)%> </td>
                                        </tr>
                                        <%  
								}
							}catch(Exception exc)
							{
							} 
						%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command" valign="top"> 
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
						if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><%if(privUpdate){%><a href="javascript:cmdAdd()" class="command"></a><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a><%}%></td>
                                        </tr>
                                        <%
						}
					%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="top" colspan="3"><br>
                                      <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspDonor.errorSize()>0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Code</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonor.colNames[jspDonor.JSP_CODE] %>"  value="<%= donor.getCode() %>" class="formElemen">
                                            * <%= jspDonor.getErrorMsg(jspDonor.JSP_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Donor 
                                            Name</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonor.colNames[jspDonor.JSP_NAME] %>" type="text" class="formElemen"  value="<%= donor.getName() %>" size="30">
                                            * <%= jspDonor.getErrorMsg(jspDonor.JSP_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Address</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonor.colNames[jspDonor.JSP_ADDRESS] %>" type="text" class="formElemen"  value="<%= donor.getAddress() %>" size="60">
                                            * <%= jspDonor.getErrorMsg(jspDonor.JSP_ADDRESS) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;City</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonor.colNames[jspDonor.JSP_CITY] %>" type="text" class="formElemen"  value="<%= donor.getCity() %>" size="40">
                                            * <%= jspDonor.getErrorMsg(jspDonor.JSP_CITY) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;State</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonor.colNames[jspDonor.JSP_STATE] %>" type="text" class="formElemen"  value="<%= donor.getState() %>" size="40">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Country 
                                            Name</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <select name="<%=jspDonor.colNames[jspDonor.JSP_COUNTRY_ID] %>" onChange="" class="formElemen">
                                              <% 
								Vector temp = new Vector(1,1);
								temp = DbCountry.list(0,0, "", "NAME");								
								long sel_country = donor.getCountryId();
								%>
                                              <option value=""></option>
                                              <%
								if(temp!=null && temp.size()>0){
									for(int i=0; i<temp.size(); i++){
										Country tc = (Country)temp.get(i);
										%>
                                              <option value="<%=tc.getOID()%>" <%if(tc.getOID()==sel_country) {%>selected <% } %> ><%=tc.getName()%></option>
                                              <%									
									}
								}
							%>
                                            </select>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Phone</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonor.colNames[jspDonor.JSP_PHONE] %>"  value="<%= donor.getPhone() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Fax</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonor.colNames[jspDonor.JSP_FAX] %>"  value="<%= donor.getFax() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Contact Person</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonor.colNames[jspDonor.JSP_CONTACT_PERSON] %>"  value="<%= donor.getContactPerson() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Hp</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonor.colNames[jspDonor.JSP_HP] %>"  value="<%= donor.getHp() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Description</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonor.colNames[jspDonor.JSP_DESCRIPTION] %>" type="text" class="formElemen"  value="<%= donor.getDescription() %>" size="60">
                                        <tr align="left"> 
                                          <td height="8" valign="middle" colspan="4">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top"> 
                                            <%
								jspLine.setLocationImg(approot+"/images/ctr_line");
								jspLine.initDefault();
								jspLine.setTableWidth("60%");
								String scomDel = "javascript:cmdAsk('"+oidDonor+"')";
								String sconDelCom = "javascript:cmdConfirmDelete('"+oidDonor+"')";
								String scancel = "javascript:cmdEdit('"+oidDonor+"')";
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
                                            <%= jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> </td>
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
                        <!-- #EndEditable -->
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
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" -->
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
