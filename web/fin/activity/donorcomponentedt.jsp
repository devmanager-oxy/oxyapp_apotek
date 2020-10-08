<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  10/31/2007 2:55:30 PM
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
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.activity.*" %>
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
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long donorComponentOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("90%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Code","10%");
		jsplist.addHeader("Component Name","30%");
		jsplist.addHeader("Donor Name","20%");
		jsplist.addHeader("Description","30%");
		

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
			DonorComponent objDonorComponent = (DonorComponent)objectClass.get(i);
			Vector rowx = new Vector();
			if(donorComponentOid == objDonorComponent.getOID())
				index = i;

			rowx.add(objDonorComponent.getCode());
			rowx.add(objDonorComponent.getName());
			
			Donor d =  new Donor();
			try 
			{
				d = DbDonor.fetchExc(objDonorComponent.getDonorId());
			} catch (Exception e)
			{
				System.out.println(e);
			}
			rowx.add(d.getName());
			rowx.add(objDonorComponent.getDescription());
			

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objDonorComponent.getOID()));
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
	long oidDonorComponent = JSPRequestValue.requestLong(request, "hidden_donorcomponent");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdDonorComponent cmdDonorComponent = new CmdDonorComponent(request);
	JSPLine jspLine = new JSPLine();
	Vector listDonorComponent = new Vector(1,1);

	// switch statement
	iErrCode = cmdDonorComponent.action(iCommand , oidDonorComponent);

	// end switch
	JspDonorComponent jspDonorComponent = cmdDonorComponent.getForm();

	// count list All DonorComponent
	int vectSize = DbDonorComponent.getCount(whereClause);

	recordToGet = vectSize;

	//out.println(jspDonorComponent.getErrors());

	DonorComponent donorComponent = cmdDonorComponent.getDonorComponent();
	msgString =  cmdDonorComponent.getMessage();
	//out.println(msgString);

	// switch list DonorComponent
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbDonorComponent.generateFindStart(donorComponent.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdDonorComponent.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listDonorComponent = DbDonorComponent.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listDonorComponent.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listDonorComponent = DbDonorComponent.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	donorComponent = new DonorComponent();
	//	oidDonorComponent = 0;
	//}
	Vector temp = new Vector(1,1);
	temp = DbDonor.list(0,0, "", "NAME");								
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
<!--



<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if((iCommand==JSPCommand.DELETE) && iErrCode==0){%>
	window.location="donorcomponent.jsp?menu_idx=<%=menuIdx%>";
<%}%>

	function cmdAdd(){
		document.frmdonorcomponent.hidden_donorcomponent.value="0";
		document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdAsk(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.ASK%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdDelete(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.ASK%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdConfirmDelete(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.DELETE%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdSave(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.SAVE%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdEdit(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
		}
	
	function cmdToEditor(){
		document.frmdonorcomponent.hidden_donorcomponent.value="0";
		document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
}	

	function cmdCancel(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdBack(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.BACK%>";
		//document.frmdonorcomponent.hidden_donorcomponent.value="0";
		//document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdListFirst(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.FIRST%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdListPrev(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.PREV%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdListNext(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.NEXT%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdListLast(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.LAST%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
	}
	
	function cmdChangeDonor(){
	<%
		//if (iCommand != JSPCommand.NONE && iCommand != JSPCommand.BACK && iCommand != JSPCommand.SAVE && iCommand != JSPCommand.DELETE)
		//{
	%>
			var donorCode = document.frmdonorcomponent.<%=jspDonorComponent.colNames[jspDonorComponent.JSP_DONOR_ID]%>.value;				
			<%
				if(temp!=null && temp.size()>0){
					for(int i=0; i<temp.size(); i++)
					{
						Donor tc = (Donor)temp.get(i);
						Country c = new Country();
						try{
							c = DbCountry.fetchExc(tc.getCountryId());
						}
						catch(Exception e){
							System.out.print(e.toString());
						}
			%>
						
						if (donorCode=='<%=tc.getOID()%>')
						{
							document.frmdonorcomponent.donorAddress.value = '<%=tc.getAddress()+((tc.getCity().length()>0) ? ", "+tc.getCity() : "")+((tc.getState().length()>0) ? ", "+tc.getState() : "")+((c.getName().length()>0) ? ", "+c.getName() : "")%>';
							document.frmdonorcomponent.donorPhone.value = '<%=tc.getPhone()+" / "+((tc.getFax().length()>0)? tc.getFax() : "-")%>';
							document.frmdonorcomponent.donorHp.value = '<%=tc.getHp()%>';
							document.frmdonorcomponent.donorDescription.value = '<%=tc.getDescription()%>';
						}
			<%
					}
				}
			%>
	<%
		//}
	%>		
	}

	//-------------- script control line -------------------
//-->
</script>
<!--End Region JavaScript-->
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Donor Company</span></font>";
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
                        <form name="frmdonorcomponent" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_donorcomponent" value="<%=oidDonorComponent%>">
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
                                        <tr align="left" valign="top"> 
                                          <td height="15" valign="middle" colspan="3" class="comment"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                <td class="tabin"> 
                                                  <div align="center">&nbsp;&nbsp;<a href="donorcomponent.jsp?menu_idx=<%=menuIdx%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tab"> 
                                                  <div align="center">&nbsp;&nbsp;Editor&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="12%"></td>
                                          <td height="8" colspan="2" width="88%" class="comment" valign="top"></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" colspan="2" width="88%" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Code</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspDonorComponent.colNames[jspDonorComponent.JSP_CODE] %>"  value="<%= donorComponent.getCode() %>" class="formElemen">
                                            * <%= jspDonorComponent.getErrorMsg(jspDonorComponent.JSP_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Component 
                                            Name</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonorComponent.colNames[jspDonorComponent.JSP_NAME] %>" type="text" class="formElemen"  value="<%= donorComponent.getName() %>" size="40">
                                            * <%= jspDonorComponent.getErrorMsg(jspDonorComponent.JSP_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Donor 
                                            Name</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <select name="<%=jspDonorComponent.colNames[jspDonorComponent.JSP_DONOR_ID] %>" onChange="javascript:cmdChangeDonor()" class="formElemen">
                                              <% 
								long sel_donor = donorComponent.getDonorId();
								%>
                                              <option value=""></option>
                                              <%
								if(temp!=null && temp.size()>0){
									for(int i=0; i<temp.size(); i++){
										Donor tc = (Donor)temp.get(i);
										%>
                                              <option value="<%=tc.getOID()%>" <%if(tc.getOID()==sel_donor) {%>selected <% } %> ><%=tc.getName()%></option>
                                              <%									
									}
								}
							%>
                                            </select>
                                            * <%= jspDonorComponent.getErrorMsg(jspDonorComponent.JSP_DONOR_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;&nbsp;&nbsp;Donor 
                                            Address</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input id="donorAddress" type="text" class="formElemen"  value="" size="80" readonly="">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;&nbsp;&nbsp;Donor 
                                            Phone/Fax</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input id="donorPhone" type="text" class="formElemen"  value="" size="60" readonly="">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;&nbsp;&nbsp;Donor 
                                            Hp</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input id="donorHp" type="text" class="formElemen"  value="" size="60" readonly="">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;&nbsp;&nbsp;Donor 
                                            Description</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input id="donorDescription" type="text" class="formElemen"  value="" size="80" readonly="">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Description</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspDonorComponent.colNames[jspDonorComponent.JSP_DESCRIPTION] %>" type="text" class="formElemen"  value="<%= donorComponent.getDescription() %>" size="60">
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
								String scomDel = "javascript:cmdAsk('"+oidDonorComponent+"')";
								String sconDelCom = "javascript:cmdConfirmDelete('"+oidDonorComponent+"')";
								String scancel = "javascript:cmdEdit('"+oidDonorComponent+"')";
								jspLine.setBackCaption("Cancel");
								//if(iCommand==JSPCommand.ADD)
								//{
									jspLine.setBackCaption("Go To Records");
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
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" >
                                          <td colspan="4" class="command" valign="top">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
                        <script language="JavaScript">
			  	cmdChangeDonor();
			  </script>
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
