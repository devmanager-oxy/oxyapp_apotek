<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  12/3/2007 10:03:08 AM
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
	public String drawList(Vector objectClass, long itemTypeOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("20%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Description","20%");

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
			ItemType objItemType = (ItemType)objectClass.get(i);
			Vector rowx = new Vector();
			if(itemTypeOid == objItemType.getOID())
				index = i;

			rowx.add(objItemType.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objItemType.getOID()));
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
	long oidItemType = JSPRequestValue.requestLong(request, "hidden_itemtype");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdItemType cmdItemType = new CmdItemType(request);
	JSPLine jspLine = new JSPLine();
	Vector listItemType = new Vector(1,1);

	// switch statement
	iErrCode = cmdItemType.action(iCommand , oidItemType);

	// end switch
	JspItemType jspItemType = cmdItemType.getForm();

	// count list All ItemType
	int vectSize = DbItemType.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspItemType.getErrors());

	ItemType itemType = cmdItemType.getItemType();
	msgString =  cmdItemType.getMessage();
	//out.println(msgString);

	// switch list ItemType
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbItemType.generateFindStart(itemType.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdItemType.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listItemType = DbItemType.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listItemType.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listItemType = DbItemType.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	itemType = new ItemType();
	//	oidItemType = 0;
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
<!--



<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdAdd(){
		document.frmitemtype.hidden_itemtype.value="0";
		document.frmitemtype.command.value="<%=JSPCommand.ADD%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdAsk(oidItemType){
		document.frmitemtype.hidden_itemtype.value=oidItemType;
		document.frmitemtype.command.value="<%=JSPCommand.ASK%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdDelete(oidItemType){
		document.frmitemtype.hidden_itemtype.value=oidItemType;
		document.frmitemtype.command.value="<%=JSPCommand.ASK%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdConfirmDelete(oidItemType){
		document.frmitemtype.hidden_itemtype.value=oidItemType;
		document.frmitemtype.command.value="<%=JSPCommand.DELETE%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdSave(){
		document.frmitemtype.command.value="<%=JSPCommand.SAVE%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
		}

	function cmdEdit(oidItemType){
		document.frmitemtype.hidden_itemtype.value=oidItemType;
		document.frmitemtype.command.value="<%=JSPCommand.EDIT%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
		}

	function cmdCancel(oidItemType){
		document.frmitemtype.hidden_itemtype.value=oidItemType;
		document.frmitemtype.command.value="<%=JSPCommand.EDIT%>";
		document.frmitemtype.prev_command.value="<%=prevCommand%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdBack(){
		document.frmitemtype.command.value="<%=JSPCommand.BACK%>";
		//document.frmitemtype.hidden_itemtype.value="0";
		//document.frmitemtype.command.value="<%=JSPCommand.ADD%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
		}

	function cmdListFirst(){
		document.frmitemtype.command.value="<%=JSPCommand.FIRST%>";
		document.frmitemtype.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdListPrev(){
		document.frmitemtype.command.value="<%=JSPCommand.PREV%>";
		document.frmitemtype.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
		}

	function cmdListNext(){
		document.frmitemtype.command.value="<%=JSPCommand.NEXT%>";
		document.frmitemtype.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
	}

	function cmdListLast(){
		document.frmitemtype.command.value="<%=JSPCommand.LAST%>";
		document.frmitemtype.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmitemtype.action="itemtype.jsp";
		document.frmitemtype.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --><%@ include file="../main/hmenu.jsp"%><!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%><!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Item Type</span></font>";
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
				  <form name="frmitemtype" method ="post" action="">
					<input type="hidden" name="command" value="<%=iCommand%>">
					<input type="hidden" name="vectSize" value="<%=vectSize%>">
					<input type="hidden" name="start" value="<%=start%>">
					<input type="hidden" name="prev_command" value="<%=prevCommand%>">
					<input type="hidden" name="hidden_itemtype" value="<%=oidItemType%>">
					<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr align="left"> 
					  <td height="8" valign="top" colspan="3"></td>
					</tr>
					<tr align="left"> 
					  <td height="8"  colspan="3" valign="top"> 
						        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <%
							try
							{
								if (listItemType != null && listItemType.size()>0)
								{
						%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <%=drawList(listItemType,oidItemType, approot, start, recordToGet)%> </td>
                                  </tr>
                                  <%  
								}
							}catch(Exception exc)
							{
							} 
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
									jspLine.setLocationImg(approot+"/images/ctr_line");
									jspLine.initDefault();
								%>
                                      <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%
						if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                                      New</u></a></td>
                                  </tr>
                                  <%
						}
					%>
                                </table>
					  </td>
					  <td width="2%" height="8" valign="top">&nbsp;</td>
					</tr>
					<tr align="left"> 
					  <td height="8" valign="top" colspan="3"><br> 
						<%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspItemType.errorSize()>0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
						<table width="100%" border="0" cellspacing="1" cellpadding="0">

						  <tr align="left">
							<td height="21" width="9%">&nbsp;Description</td>
							<td height="21" width="1%">&nbsp;
							<td height="21" colspan="2" width="90%"> 
							<input type="text" name="<%=jspItemType.colNames[jspItemType.JSP_DESCRIPTION] %>"  value="<%= itemType.getDescription() %>" class="formElemen" size="50">
							* <%= jspItemType.getErrorMsg(jspItemType.JSP_DESCRIPTION) %> 

						  <tr align="left"> 
							<td height="8" valign="middle" colspan="4">&nbsp; </td>
						  </tr>
						  <tr align="left" > 
							<td colspan="4" class="command" valign="top"> 
							<%
								jspLine.setLocationImg(approot+"/images/ctr_line");
								jspLine.initDefault();
								jspLine.setTableWidth("60%");
								String scomDel = "javascript:cmdAsk('"+oidItemType+"')";
								String sconDelCom = "javascript:cmdConfirmDelete('"+oidItemType+"')";
								String scancel = "javascript:cmdEdit('"+oidItemType+"')";
								jspLine.setBackCaption("Cancel");
								//if(iCommand==JSPCommand.ADD)
								//{
									jspLine.setBackCaption("Back to List");
								//}
								jspLine.setConfirmDelCaption("Yes Delete");
								jspLine.setDeleteCaption("Delete");
								jspLine.setSaveCaption("Save");
								jspLine.setJSPCommandStyle("buttonlink");

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
							<%= jspLine.drawImage(iCommand, iErrCode, msgString)%> 
							</td>
						  </tr>
						</table>
						<%}%>
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
            <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
