<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  12/3/2007 10:21:42 AM
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
	public String drawList(Vector objectClass, long termOfPaymentOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Description","30%");
		jsplist.addHeader("Due","10%");
		jsplist.addHeader("Qty Disc","10%");
		jsplist.addHeader("Disc Percent","10%");

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
			TermOfPayment objTermOfPayment = (TermOfPayment)objectClass.get(i);
			Vector rowx = new Vector();
			if(termOfPaymentOid == objTermOfPayment.getOID())
				index = i;

			rowx.add(objTermOfPayment.getDescription());
			rowx.add("<div align=\"right\">"+String.valueOf(objTermOfPayment.getDue())+"</div>");
			//rowx.add((objTermOfPayment.getDue()==1) ? "Yes" : "No");
			rowx.add("<div align=\"right\">"+String.valueOf(objTermOfPayment.getQtyDisc())+"</div>");
			//rowx.add((objTermOfPayment.getQtyDisc()==1) ? "Yes" : "No");
			rowx.add("<div align=\"right\">"+String.valueOf(objTermOfPayment.getDiscPercent())+"</div>");
			//rowx.add((objTermOfPayment.getDiscPercent()==1) ? "Yes" : "No");

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objTermOfPayment.getOID()));
		}
		return jsplist.draw(index);
	}
%>
<%
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	//if(iJSPCommand==JSPCommand.NONE)
	//{
	//	iJSPCommand = JSPCommand.ADD;
	//}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidTermOfPayment = JSPRequestValue.requestLong(request, "hidden_termofpayment");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdTermOfPayment cmdTermOfPayment = new CmdTermOfPayment(request);
	JSPLine jspLine = new JSPLine();
	Vector listTermOfPayment = new Vector(1,1);

	// switch statement
	iErrCode = cmdTermOfPayment.action(iJSPCommand , oidTermOfPayment);

	// end switch
	JspTermOfPayment jspTermOfPayment = cmdTermOfPayment.getForm();

	// count list All TermOfPayment
	int vectSize = DbTermOfPayment.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspTermOfPayment.getErrors());

	TermOfPayment termOfPayment = cmdTermOfPayment.getTermOfPayment();
	msgString =  cmdTermOfPayment.getMessage();
	//out.println(msgString);

	// switch list TermOfPayment
	//if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbTermOfPayment.generateFindStart(termOfPayment.getOID(),recordToGet, whereClause);
	//}

	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
	{
		start = cmdTermOfPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listTermOfPayment = DbTermOfPayment.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listTermOfPayment.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iJSPCommand = JSPCommand.FIRST;
			prevJSPCommand = JSPCommand.FIRST; 
		}
		listTermOfPayment = DbTermOfPayment.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iJSPCommand = JSPCommand.ADD;
	//	termOfPayment = new TermOfPayment();
	//	oidTermOfPayment = 0;
	//}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>POS Back Office</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

	function cmdAdd(){
		document.frmtermofpayment.hidden_termofpayment.value="0";
		document.frmtermofpayment.command.value="<%=JSPCommand.ADD%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdAsk(oidTermOfPayment){
		document.frmtermofpayment.hidden_termofpayment.value=oidTermOfPayment;
		document.frmtermofpayment.command.value="<%=JSPCommand.ASK%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdDelete(oidTermOfPayment){
		document.frmtermofpayment.hidden_termofpayment.value=oidTermOfPayment;
		document.frmtermofpayment.command.value="<%=JSPCommand.ASK%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdConfirmDelete(oidTermOfPayment){
		document.frmtermofpayment.hidden_termofpayment.value=oidTermOfPayment;
		document.frmtermofpayment.command.value="<%=JSPCommand.DELETE%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdSave(){
		document.frmtermofpayment.command.value="<%=JSPCommand.SAVE%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
		}

	function cmdEdit(oidTermOfPayment){
		document.frmtermofpayment.hidden_termofpayment.value=oidTermOfPayment;
		document.frmtermofpayment.command.value="<%=JSPCommand.EDIT%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
		}

	function cmdCancel(oidTermOfPayment){
		document.frmtermofpayment.hidden_termofpayment.value=oidTermOfPayment;
		document.frmtermofpayment.command.value="<%=JSPCommand.EDIT%>";
		document.frmtermofpayment.prev_command.value="<%=prevJSPCommand%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdBack(){
		document.frmtermofpayment.command.value="<%=JSPCommand.BACK%>";
		//document.frmtermofpayment.hidden_termofpayment.value="0";
		//document.frmtermofpayment.command.value="<%=JSPCommand.ADD%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
		}

	function cmdListFirst(){
		document.frmtermofpayment.command.value="<%=JSPCommand.FIRST%>";
		document.frmtermofpayment.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdListPrev(){
		document.frmtermofpayment.command.value="<%=JSPCommand.PREV%>";
		document.frmtermofpayment.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
		}

	function cmdListNext(){
		document.frmtermofpayment.command.value="<%=JSPCommand.NEXT%>";
		document.frmtermofpayment.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
	}

	function cmdListLast(){
		document.frmtermofpayment.command.value="<%=JSPCommand.LAST%>";
		document.frmtermofpayment.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmtermofpayment.action="termofpayment.jsp";
		document.frmtermofpayment.submit();
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <!--Begin Region Content-->
                        <form name="frmtermofpayment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_termofpayment" value="<%=oidTermOfPayment%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                            Maintenance </font><font class="tit1">&raquo; 
                                            </font><font class="tit1"><span class="lvl2">General 
                                            </span>&raquo;</font> <span class="lvl2">Term 
                                            Of Payment</span></b></td>
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
                                  <tr align="left"> 
                                    <td height="8" valign="top" colspan="3"></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8"  colspan="3" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <%
							try
							{
								if (listTermOfPayment != null && listTermOfPayment.size()>0)
								{
						%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"><%=drawList(listTermOfPayment,oidTermOfPayment, approot, start, recordToGet)%></td>
                                              </tr>
                                            </table>
                                          </td>
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
									if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) 
										cmd = iJSPCommand; 
									else
									{
										if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
											cmd = JSPCommand.FIRST;
										else 
											cmd = prevJSPCommand; 
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
                                        <tr align="left" valign="top"> 
                                          <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
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
                                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspTermOfPayment.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Description</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspTermOfPayment.colNames[jspTermOfPayment.JSP_DESCRIPTION] %>"  value="<%= termOfPayment.getDescription() %>" class="formElemen" size="60">
                                            * <%= jspTermOfPayment.getErrorMsg(jspTermOfPayment.JSP_DESCRIPTION) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Due</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input  onKeyPress="return check(event)" type="text" name="<%=jspTermOfPayment.colNames[jspTermOfPayment.JSP_DUE] %>"  value="<%= termOfPayment.getDue() %>" class="formElemen" style="text-align:right" size="10">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Quantity 
                                            Discount</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input  onKeyPress="return check(event)" type="text" name="<%=jspTermOfPayment.colNames[jspTermOfPayment.JSP_QTY_DISC] %>"  value="<%= termOfPayment.getQtyDisc() %>" class="formElemen" style="text-align:right" size="10">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Discount 
                                            Percent</td>
                                          <td height="21" width="1%">&nbsp; 
                                          <td height="21" colspan="2" width="90%"> 
                                            <input  onKeyPress="return check(event)" type="text" name="<%=jspTermOfPayment.colNames[jspTermOfPayment.JSP_DISC_PERCENT] %>"  value="<%= termOfPayment.getDiscPercent() %>" class="formElemen" style="text-align:right" size="10">
                                        <tr align="left"> 
                                          <td height="8" valign="middle" colspan="4">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top"> 
                                            <%
								jspLine.setLocationImg(approot+"/images/ctr_line");
								jspLine.initDefault();
								jspLine.setTableWidth("50%");
								String scomDel = "javascript:cmdAsk('"+oidTermOfPayment+"')";
								String sconDelCom = "javascript:cmdConfirmDelete('"+oidTermOfPayment+"')";
								String scancel = "javascript:cmdEdit('"+oidTermOfPayment+"')";
								jspLine.setBackCaption("Cancel");
								//if(iJSPCommand==JSPCommand.ADD)
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
                                            <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
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
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
