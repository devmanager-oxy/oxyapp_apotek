<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
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
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

String periodName = JSPRequestValue.requestString(request, "period_name");
Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
Date tolerance = JSPFormater.formatDate(JSPRequestValue.requestString(request, "tolerance"), "dd/MM/yyyy");

String result = "";

if(iJSPCommand==JSPCommand.SAVE){
	Periode ap = new Periode();
	ap.setName(periodName);
	ap.setStartDate(startDate);
	ap.setEndDate(endDate);
	ap.setInputTolerance(tolerance);
	
	try{
		result = DbPeriode.closePeriod(ap,isYearlyClose);
	}catch(Exception e){
		System.out.println(e);
	}
}

if(iJSPCommand==JSPCommand.NONE){
	Periode openPeriod = DbPeriode.getOpenPeriod();
	//out.println(openPeriod.getOID());
	startDate = openPeriod.getStartDate();
	startDate.setMonth(startDate.getMonth()+1);
	startDate.setDate(1);
	endDate = (Date)startDate.clone();
	endDate.setMonth(endDate.getMonth()+1);
	endDate.setDate(endDate.getDate()-1);
	
	tolerance = (Date)endDate.clone();
	tolerance.setDate(tolerance.getDate()+10);
	
	periodName = JSPFormater.formatDate(startDate, "MMMM yyyy");
	
}
//out.println("<br>startDatex : "+startDate);
//out.println("<br>endDatex : "+endDate);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!closingPeriodPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iJSPCommand==JSPCommand.SAVE && result.length()==0){%>
	window.location="../incomplete/periode.jsp";
<%}%>

function cmdSave(){
	document.all.closecmd.style.display="none";
	document.all.closemsg.style.display="";
	document.frmactivityperiod.command.value="<%=JSPCommand.SAVE%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="closeperiod.jsp";
	document.frmactivityperiod.submit();
}

function cmdBack(){
	document.frmactivityperiod.command.value="<%=JSPCommand.BACK%>";
	document.frmactivityperiod.action="../master/periode.jsp";
	document.frmactivityperiod.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/saveclose2.gif','../images/cancel2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data Synchronization</span> &raquo; <span class="level2"><%if(!isYearlyClose){%>Monthly Closing<%}else{%>Yearly Closing<%}%><br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmactivityperiod" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
                              <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td colspan="2"><font color="#FF0000">p</font><font color="#FF0000">lease 
                                                  click &quot; Save &amp; Close 
                                                  &quot; button to complete closing 
                                                  period process.</font></td>
                                              </tr>
                                              <tr> 
                                                <td width="17%">&nbsp;</td>
                                                <td width="83%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="17%"><i><font color="#006600">Setup 
                                                  new period</font></i> </td>
                                                <td width="83%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="17%">Period Name</td>
                                                <td width="83%"> 
                                                  <input type="text" name="period_name" value="<%=periodName%>" size="50">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="17%">Start Date</td>
                                                <td width="83%"> 
                                                  <input name="start_date" value="<%=JSPFormater.formatDate((startDate==null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly class="readonly">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="17%">End Date</td>
                                                <td width="83%"> 
                                                  <input name="end_date" value="<%=JSPFormater.formatDate((endDate==null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly class="readonly">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="17%">Input Tolerance</td>
                                                <td width="83%"> 
                                                  <input name="tolerance" value="<%=JSPFormater.formatDate((tolerance==null) ? new Date() : tolerance, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmactivityperiod.tolerance);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <% 
						  }catch(Exception exc){ 
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="24" valign="middle" colspan="3">
<%if(result.length()>0){%>
                                            <font color="#FF0000"><%=result%></font>
<%}%></td>
                                        </tr>
                                        
                                        <tr id="closecmd" align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="14%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/saveclose2.gif',1)"><img src="../images/saveclose.gif" name="new21" border="0"></a></td>
                                                <td width="85%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="new211" border="0" width="63" height="22"></a></td>
                                                <td width="1%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
										<tr id="closemsg" align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <font color="#006600">Closing period 
                                            process in progress, please wait .... 
                                            </font></td>
                                        </tr>
                                        
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%"> </td>
                            </tr>
                            <tr align="left" valign="top" > 
                                    <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table></td>
  </tr>
</table>
                       <script language="JavaScript">
					   	document.all.closecmd.style.display="";
						document.all.closemsg.style.display="none";
					   </script>
   
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
