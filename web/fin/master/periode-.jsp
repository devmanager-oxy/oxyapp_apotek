 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
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

	public String drawList(Vector objectClass ,  long periodeId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Name","20%");
		cmdist.addHeader("Start Date","20%");
		cmdist.addHeader("End Date","20%");
		cmdist.addHeader("Input Tolerance","20%");
		cmdist.addHeader("Status","20%");

		cmdist.setLinkRow(-1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Periode periode = (Periode)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(periodeId == periode.getOID())
				 index = i;

			rowx.add(periode.getName());

			String str_dt_StartDate = ""; 
			try{
				Date dt_StartDate = periode.getStartDate();
				if(dt_StartDate==null){
					dt_StartDate = new Date();
				}

				str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_StartDate = ""; }

			rowx.add(str_dt_StartDate);

			String str_dt_EndDate = ""; 
			try{
				Date dt_EndDate = periode.getEndDate();
				if(dt_EndDate==null){
					dt_EndDate = new Date();
				}

				str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_EndDate = ""; }

			rowx.add(str_dt_EndDate);

			String str_dt_InputTolerance = ""; 
			try{
				Date dt_InputTolerance = periode.getInputTolerance();
				if(dt_InputTolerance==null){
					dt_InputTolerance = new Date();
				}

				str_dt_InputTolerance = JSPFormater.formatDate(dt_InputTolerance, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_InputTolerance = ""; }

			rowx.add(str_dt_InputTolerance);

			rowx.add("<div align=\"center\">"+periode.getStatus()+"</div>");

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(periode.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPeriode = JSPRequestValue.requestLong(request, "hidden_periode_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPeriode ctrlPeriode = new CmdPeriode(request);
JSPLine ctrLine = new JSPLine();
Vector listPeriode = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPeriode.action(iJSPCommand , oidPeriode);
/* end switch*/
JspPeriode jspPeriode = ctrlPeriode.getForm();

/*count list All Periode*/
int vectSize = DbPeriode.getCount(whereClause);

Periode periode = ctrlPeriode.getPeriode();
msgString =  ctrlPeriode.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPeriode.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPeriode = DbPeriode.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPeriode.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPeriode = DbPeriode.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdAdd(){
	document.frmperiode.hidden_periode_id.value="0";
	document.frmperiode.command.value="<%=JSPCommand.ADD%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdAsk(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.ASK%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdConfirmDelete(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.DELETE%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}
function cmdSave(){
	document.frmperiode.command.value="<%=JSPCommand.SAVE%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
	}

function cmdEdit(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
	}

function cmdCancel(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdBack(){
	document.frmperiode.command.value="<%=JSPCommand.BACK%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
	}

function cmdListFirst(){
	document.frmperiode.command.value="<%=JSPCommand.FIRST%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdListPrev(){
	document.frmperiode.command.value="<%=JSPCommand.PREV%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
	}

function cmdListNext(){
	document.frmperiode.command.value="<%=JSPCommand.NEXT%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdListLast(){
	document.frmperiode.command.value="<%=JSPCommand.LAST%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmperiode.action="periode.jsp";
	document.frmperiode.submit();
}

function cmdClose(){
	if(confirm('Are you sure to do this action ?\nthis action is undoable, all transaction in the previews period will be locked for update')){
		//document.frmperiode.command.value="<%=JSPCommand.LAST%>";
		//document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
		//document.frmperiode.action="periode.jsp";
		//document.frmperiode.submit();
		alert('sorry, close period is under construction ...');
	}
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Master 
                        Maintenance </span> &raquo; <span class="level1">Accounting</span> 
                        &raquo; <span class="level2">Period<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmperiode" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_periode_id" value="<%=oidPeriode%>"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3" class="comment"></td>
                                  </tr>
                                  <%
							try{
								if (listPeriode.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"><%= drawList(listPeriode,oidPeriode)%></td>
                                              </tr>
                                            </table>
                                          </td>
                                  </tr>
                                  <%  } 
						  }catch(Exception exc){ 
						  }%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command" valign="top"> 
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
                                  <%if((listPeriode==null || listPeriode.size()<1) && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                  </tr>
                                  <%}else{%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdClose()" class="command"><u>Close 
                                      Current Period</u></a> </td>
                                  </tr>
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspPeriode.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                    <td height="21" colspan="2" width="89%" class="comment" valign="top">*)= 
                                      required</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;&nbsp;Name</td>
                                    <td height="21" colspan="2" width="89%"> 
                                      <input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_NAME] %>"  value="<%= periode.getName() %>" class="formElemen">
                                      * <%= jspPeriode.getErrorMsg(JspPeriode.JSP_NAME) %> 
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;&nbsp;Start 
                                      Date</td>
                                    <td height="21" colspan="2" width="89%"> 
                                      <input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_START_DATE] %>"  value="<%= JSPFormater.formatDate(periode.getStartDate(),"dd/MM/yyyy") %>" class="formElemen">
                                      * <%= jspPeriode.getErrorMsg(JspPeriode.JSP_START_DATE) %> (dd/MM/yyyy) 
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;&nbsp;End 
                                      Date</td>
                                    <td height="21" colspan="2" width="89%"> 
                                      <input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_END_DATE] %>"  value="<%= JSPFormater.formatDate(periode.getEndDate(),"dd/MM/yyyy") %>" class="formElemen">
                                      * <%= jspPeriode.getErrorMsg(JspPeriode.JSP_END_DATE) %> (dd/MM/yyyy) 
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;&nbsp;Input 
                                      Tolerance</td>
                                    <td height="21" colspan="2" width="89%"> 
                                      <input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_INPUT_TOLERANCE] %>"  value="<%= JSPFormater.formatDate(periode.getInputTolerance(),"dd/MM/yyyy") %>" class="formElemen">
                                      (dd/MM/yyyy) 
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;&nbsp;Status</td>
                                    <td height="21" colspan="2" width="89%"> 
                                      <input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_STATUS] %>"  value="<%= I_Project.ACCOUNTING_PERIOD_STATUS_OPEN %>" class="formElemen" readOnly>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                    <td height="21" colspan="2" width="89%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="11%">&nbsp;</td>
                                    <td height="8" colspan="2" width="89%" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="3" class="command" valign="top"> 
                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidPeriode+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPeriode+"')";
									String scancel = "javascript:cmdEdit('"+oidPeriode+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
                                      <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="89%">&nbsp;</td>
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
