 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long waitresId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("60%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("Code","15%");
		jsplist.addHeader("Name","35%");		
		//jsplist.addHeader("Login Id","25%");
		//jsplist.addHeader("Password","16%");
		//jsplist.addHeader("Status","16%");
		jsplist.addHeader("Level","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Waiter waiter = (Waiter)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(waitresId == waiter.getOID())
				 index = i;

			rowx.add(waiter.getCode());

			rowx.add(waiter.getName());


			//rowx.add(waiter.getLoginId());

			//rowx.add(waiter.getPassword());

			//rowx.add(waiter.getStatus());

			rowx.add(String.valueOf(DbWaiter.strLevel[waiter.getLevel()]));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(waiter.getOID()));
		}

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidWaiter = JSPRequestValue.requestLong(request, "hidden_waitres_id");

long oidLocation = JSPRequestValue.requestLong(request, JspWaiter.colNames[JspWaiter.JSP_LOCATION_ID]);
Vector locations = DbLocation.list(0,0,"type='Store'","");
if(oidLocation==0 && locations!=null && locations.size()>0){
	Location l = (Location)locations.get(0);
	oidLocation = l.getOID();
}

Location loc = new Location();
try{
	loc = DbLocation.fetchExc(oidLocation);
}
catch(Exception e){
}


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "location_id="+oidLocation;
String orderClause = "";

CmdWaiter ctrlWaiter = new CmdWaiter(request);
JSPLine ctrLine = new JSPLine();
Vector listWaiter = new Vector(1,1);

/*switch statement */
iErrCode = ctrlWaiter.action(iJSPCommand , oidWaiter);
/* end switch*/
JspWaiter jspWaiter = ctrlWaiter.getForm();

/*count list All Waiter*/
int vectSize = DbWaiter.getCount(whereClause);

Waiter waiter = ctrlWaiter.getWaiter();
msgString =  ctrlWaiter.getMessage();

if(iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK){
	waiter.setConfirmPwd(waiter.getPassword());
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlWaiter.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listWaiter = DbWaiter.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listWaiter.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listWaiter = DbWaiter.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Retail System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">

function cmdChange(){
	document.frmwaiter.hidden_waitres_id.value="0";
	document.frmwaiter.command.value="<%=JSPCommand.LIST%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdAdd(){
	document.frmwaiter.hidden_waitres_id.value="0";
	document.frmwaiter.command.value="<%=JSPCommand.ADD%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdAsk(oidWaiter){
	document.frmwaiter.hidden_waitres_id.value=oidWaiter;
	document.frmwaiter.command.value="<%=JSPCommand.ASK%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdConfirmDelete(oidWaiter){
	document.frmwaiter.hidden_waitres_id.value=oidWaiter;
	document.frmwaiter.command.value="<%=JSPCommand.DELETE%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}
function cmdSave(){
	document.frmwaiter.command.value="<%=JSPCommand.SAVE%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
	}

function cmdEdit(oidWaiter){
	document.frmwaiter.hidden_waitres_id.value=oidWaiter;
	document.frmwaiter.command.value="<%=JSPCommand.EDIT%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
	}

function cmdCancel(oidWaiter){
	document.frmwaiter.hidden_waitres_id.value=oidWaiter;
	document.frmwaiter.command.value="<%=JSPCommand.EDIT%>";
	document.frmwaiter.prev_command.value="<%=prevJSPCommand%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdBack(){
	document.frmwaiter.command.value="<%=JSPCommand.BACK%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
	}

function cmdListFirst(){
	document.frmwaiter.command.value="<%=JSPCommand.FIRST%>";
	document.frmwaiter.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdListPrev(){
	document.frmwaiter.command.value="<%=JSPCommand.PREV%>";
	document.frmwaiter.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
	}

function cmdListNext(){
	document.frmwaiter.command.value="<%=JSPCommand.NEXT%>";
	document.frmwaiter.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
}

function cmdListLast(){
	document.frmwaiter.command.value="<%=JSPCommand.LAST%>";
	document.frmwaiter.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmwaiter.action="waiter.jsp";
	document.frmwaiter.submit();
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
                        <form name="frmwaiter" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_waitres_id" value="<%=oidWaiter%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                              <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                  Maintenance </font><font class="tit1">&raquo; 
                                                  </font><font class="tit1"><span class="lvl2">POS</span> 
                                                  &raquo;</font> <span class="lvl2">Waiters</span></b></td>
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
                                        <tr align="left" valign="top"> 
                                          <td height="5" valign="middle" colspan="3"> 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="9%">&nbsp;<b>Store/Outlet</b></td>
                                                <td width="91%"> 
                                                  <select name="<%=jspWaiter.colNames[JspWaiter.JSP_LOCATION_ID] %>" onChange="javascript:cmdChange()">
                                                    <%if(locations!=null && locations.size()>0){
													for(int i=0; i<locations.size(); i++){
														Location l = (Location)locations.get(i);
													%>
                                                    <option value="<%=l.getOID()%>" <%if(l.getOID()==oidLocation){%>selected<%}%>><%=l.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                          <td height="5" valign="middle" colspan="3"></td>
                                        </tr>
                                        <%
							try{
								if (listWaiter.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listWaiter,oidWaiter)%> </td>
                                        </tr>
                                        <%  }else{%>
										<tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <font color="#FF0000">&nbsp;data is empty 
                                            ..</font></td>
                                        </tr>
										<%}
						  }catch(Exception exc){ 
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                            <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="5" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%//if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspWaiter.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
								<%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE && iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="90%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="90%" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left">
                                          <td height="21" width="10%"><b>&nbsp;Location</b></td>
                                          <td height="21" colspan="2" width="90%"><b><%=loc.getName()%> </b>
                                        <tr align="left"> 
                                          <td height="21" width="10%">&nbsp;Code</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspWaiter.colNames[JspWaiter.JSP_CODE] %>"  value="<%= waiter.getCode() %>" class="formElemen" maxlength="5" size="10">
                                            * <%= jspWaiter.getErrorMsg(JspWaiter.JSP_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">&nbsp;Name</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspWaiter.colNames[JspWaiter.JSP_NAME] %>"  value="<%= waiter.getName() %>" class="formElemen" size="35">
                                            * <%= jspWaiter.getErrorMsg(JspWaiter.JSP_NAME) %> 
                                        
                                        <tr align="left"> 
                                          <td height="21" width="10%">&nbsp;Level</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <select name="<%=jspWaiter.colNames[JspWaiter.JSP_LEVEL] %>">
                                              <%for(int i=0; i<DbWaiter.strLevel.length; i++){%>
                                              <option value="<%=waiter.getLevel()%>" <%if(waiter.getLevel()==i){%>selected<%}%>><%=DbWaiter.strLevel[i]%></option>
                                              <%}%>
                                            </select>
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="10%">&nbsp;</td>
                                          <td height="8" colspan="2" width="90%" valign="top">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidWaiter+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidWaiter+"')";
									String scancel = "javascript:cmdEdit('"+oidWaiter+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");
										
										ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										ctrLine.setSaveCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="90%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" valign="top"> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                      </table>
                                <%}%>
                              </td>
                            </tr>
                          </table></td>
  </tr>
</table>
                          
                        </form>
                         
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
