 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DATA);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long moduleId, boolean isOpen)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Delete","3%");
		cmdist.addHeader("Code","3%");
		cmdist.addHeader("Description","22%");
		cmdist.addHeader("Level","3%");
		cmdist.addHeader("Output and Deliverable","22%");
		cmdist.addHeader("Performance Indicator","22%");
		cmdist.addHeader("Assumtion and Risk","22%");
			
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Module module = (Module)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(moduleId == module.getOID())
				 index = i;

			rowx.add("<div align=\"center\"><input type=\"checkbox\" name=\"chk_"+module.getOID()+"\" value=\"1\"></div>");
			rowx.add(module.getCode());
			rowx.add(module.getDescription());
			rowx.add("<div align=\"center\">"+module.getLevel()+"</div>");
			rowx.add(module.getOutputDeliver());
			rowx.add(module.getPerformIndicator());
			rowx.add(module.getAssumRisk());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(module.getOID()));
		}

		return cmdist.draw(index);
	}	

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");
long activityPeriodId  = JSPRequestValue.requestLong(request, "activity_period_id");

ActivityPeriod apx = DbActivityPeriod.getOpenPeriod();

if(activityPeriodId==0){
	activityPeriodId = apx.getOID();
}

boolean isOpen = true;
if(activityPeriodId!=apx.getOID()){
	isOpen = false;
}

//out.println("activityPeriodId : "+activityPeriodId);

/*variable declaration*/
int recordToGet = 100;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "activity_period_id = "+activityPeriodId;
String orderClause = "code";

CmdModule cmdModule = new CmdModule(request);
JSPLine ctrLine = new JSPLine();
Vector listModule = new Vector(1,1);

/* get record to display */
//listModule = DbModule.list(start,recordToGet, whereClause , orderClause);
if(session.getValue("CLOSE_MODULE")!=null){
	listModule = (Vector)session.getValue("CLOSE_MODULE");
}

/*switch statement */
iErrCode = cmdModule.action(iJSPCommand , oidModule);
/* end switch*/
JspModule jspModule = cmdModule.getForm();


	Vector vBPD = new Vector();
	
	//out.println(listModule.size());
	if(listModule!=null && listModule.size()>0){		
		for(int i=0; i<listModule.size(); i++){			
			Module pi = (Module)listModule.get(i);
			int chk = JSPRequestValue.requestInt(request, "chk_"+pi.getOID());		
			//out.println(chk);
			if(chk==0){													
				vBPD.add(pi);
			}
		}
	}
	session.putValue("CLOSE_MODULE", vBPD);

	
/*count list All Module*/
//int vectSize = DbModule.getCount(whereClause);
int vectSize = vBPD.size();
recordToGet = vectSize;

Module module = cmdModule.getModule();
msgString =  cmdModule.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = cmdModule.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listModule.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listModule = DbModule.list(start,recordToGet, whereClause , orderClause);
}
*/
System.out.println(listModule.size());

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iJSPCommand==JSPCommand.SAVE){%>
	window.location="closeactivityperiod.jsp?command=<%=JSPCommand.ADD%>";
<%}%>


function cmdSubmitCommand(){
	document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdChangePeriod(){
	document.frmmodule.command.value="<%=JSPCommand.LIST%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdAdd(){
	document.frmmodule.hidden_module_id.value="0";
	document.frmmodule.command.value="<%=JSPCommand.ADD%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="moduledt.jsp";
	document.frmmodule.submit();
}

function cmdAsk(oidModule){
	document.frmmodule.hidden_module_id.value=oidModule;
	document.frmmodule.command.value="<%=JSPCommand.ASK%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdConfirmDelete(oidModule){
	document.frmmodule.hidden_module_id.value=oidModule;
	document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}
function cmdSave(){
	document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
	}

function cmdEdit(oidModule){
	//document.frmmodule.hidden_module_id.value=oidModule;
	//document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
	//document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	//document.frmmodule.action="moduledt.jsp";
	//document.frmmodule.submit();
	}

function cmdCancel(oidModule){
	document.frmmodule.hidden_module_id.value=oidModule;
	document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdBack(){
	document.frmmodule.command.value="<%=JSPCommand.BACK%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
	}

function cmdListFirst(){
	document.frmmodule.command.value="<%=JSPCommand.FIRST%>";
	document.frmmodule.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdListPrev(){
	document.frmmodule.command.value="<%=JSPCommand.PREV%>";
	document.frmmodule.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
	}

function cmdListNext(){
	document.frmmodule.command.value="<%=JSPCommand.NEXT%>";
	document.frmmodule.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdListLast(){
	document.frmmodule.command.value="<%=JSPCommand.LAST%>";
	document.frmmodule.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmmodule.action="module.jsp";
	document.frmmodule.submit();
}

function cmdToEditor(){
	//alert(document.frmcoa.menu_index.value);
	document.frmmodule.hidden_module_id.value=0;
	document.frmmodule.command.value="<%=JSPCommand.ADD%>";
	document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
	document.frmmodule.action="moduledt.jsp";
	document.frmmodule.submit();
}	

function printXLS(){	 
	window.open("<%=printroot%>.report.RptModuleFlatXLS");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  								
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/saveclose2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data Synchronization 
                        </span> &raquo; <span class="level1">Activity Closing</span> 
                        &raquo; <span class="level2">Activity List<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmmodule" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>                                        
                                        <tr align="left" valign="top">
                                          <td height="10" valign="middle" colspan="3"><b>Activity Period : <%=apx.getName()%></b></td>
                                        </tr>
										<tr align="left" valign="top">
                                          <td height="10" valign="middle" colspan="3"></td>
                                        </tr>
                                        <%
							try{
								if (listModule.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3" class="page"> 
                                            <%= drawList(vBPD,oidModule, isOpen)%> </td>
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
                                        <!--tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                            New</u></a></td>
                        </tr-->
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if (listModule!=null && listModule.size()>0){%>
                                      <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="71">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="76">&nbsp;</td>
                                          <td width="176">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="71">
										  <%if(isOpen){%>
										  <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/saveclose2.gif',1)"><img src="../images/saveclose.gif" name="post" width="121" height="22" border="0"></a>
										  <%}else{%>
										  &nbsp;
										  <%}%>
										  </td>
                                          <td width="45">&nbsp;</td>
                                          <td width="76"></td>
                                          <td width="176">&nbsp;</td>
                                        </tr>
                                      </table>
                                      <%}%>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
