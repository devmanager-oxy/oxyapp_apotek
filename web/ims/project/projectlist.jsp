 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION);
	boolean masterPrivView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long projectId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("Date dd/MM/yy","5%");
		ctrlist.addHeader("Project Number","13%");
		ctrlist.addHeader("Name","20%");
		ctrlist.addHeader("Customer","20%");
		ctrlist.addHeader("Amount","10%");
		ctrlist.addHeader("Customer PIC/Phone","10%");
		ctrlist.addHeader("Periode dd/MM/yy","7%");
		ctrlist.addHeader("PIC","10%");
		
		ctrlist.addHeader("Status","5%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		//ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkPrefix("javascript:targetPage('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Project project = (Project)objectClass.get(i);
			
			/*
			Proposal proposal = new Proposal();
			try{
				proposal = DbProposal.fetchExc(project.getProposalId());
			}
			catch(Exception e){
			}
			*/
			
			 Vector rowx = new Vector();
			 if(projectId == project.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = project.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			//rowx.add(project.getNumberPrefix());

			//rowx.add(proposal.getNumber());
			
			//rowx.add(String.valueOf(project.getCounter()));
			rowx.add(project.getNumber());

			rowx.add(project.getName());
			
			Customer customer = new Customer();
			try{
				customer = DbCustomer.fetchExc(project.getCustomerId());
			}
			catch(Exception e){
			}
			rowx.add(customer.getName());
			
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(project.getAmount(),"#,###")+"</div>");

			rowx.add(project.getCustomerPic()+"<br>"+project.getCustomerPicPhone());

			//rowx.add(project.getCustomerPicPhone());
			String str_dt_StartDate = ""; 
			try{
				Date dt_StartDate = project.getStartDate();
				if(dt_StartDate==null){
					dt_StartDate = new Date();
				}

				str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd/MM/yy");
			}catch(Exception e){ str_dt_StartDate = ""; }

			//rowx.add(str_dt_StartDate);
			

			String str_dt_EndDate = ""; 
			try{
				Date dt_EndDate = project.getEndDate();
				if(dt_EndDate==null){
					dt_EndDate = new Date();
				}

				str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd/MM/yy");
			}catch(Exception e){ str_dt_EndDate = ""; }

			rowx.add(str_dt_StartDate+" -<br>"+str_dt_EndDate);
			
			

			//rowx.add(project.getCustomerPicPosition());

			//rowx.add(String.valueOf(project.getUserId()));
			
			Employee em = new Employee();
			try{
				em = DbEmployee.fetchExc(project.getEmployeeId());
			}
			catch(Exception e){
			}

			rowx.add(em.getName());
			
			

			//rowx.add(project.getDescription());

			rowx.add("<div align=\"center\">"+I_Crm.projectStatusStr[project.getStatus()]+"</div>");

			lstData.add(rowx);
			//lstLinkData.add(String.valueOf(project.getOID())+"','"+project.getProposalId());
			lstLinkData.add(String.valueOf(project.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));

long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
String name = JSPRequestValue.requestString(request, "proj_name");
String number = JSPRequestValue.requestString(request, "proj_number");
Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
int status = JSPRequestValue.requestInt(request, "status");
long unitUsahaId = JSPRequestValue.requestLong(request, "src_unit_usaha_id");

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidProject = JSPRequestValue.requestLong(request, "hidden_project_id");

if(iJSPCommand==JSPCommand.NONE){
	chkInvDate = 1;
	status = -1;
}

/*variable declaration*/
int recordToGet = 30;
String msgString = "";
int iErrCode = JSPMessage.NONE;
//String whereClause = "company_id="+systemCompanyId;
String whereClause = "";
String orderClause = "";

//Where Clause
 if(oidCustomer!=0){
	 whereClause = whereClause + " customer_id ="+oidCustomer;
 }
 if(name.length()>0){
  	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " name like '%"+name+"%'";
 }
 if(number.length()>0){
	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " number like '%"+number+"%'";	
 }
 if(chkInvDate==0){
	if (whereClause != "") whereClause = whereClause + " and ";
	//whereClause = whereClause + "start_date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and  end_date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"'";
	whereClause = whereClause + " (date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and  '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"')";
 }
 if(status!=-1){
 	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " status='"+status+"'";
 }
 if(unitUsahaId!=0){
 	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " unit_usaha_id="+unitUsahaId;
 }
 
 
//out.println("whereClause "+whereClause);

CmdProject ctrlProject = new CmdProject(request);
JSPLine ctrLine = new JSPLine();
Vector listProject = new Vector(1,1);

/*switch statement */
iErrCode = ctrlProject.action(iJSPCommand , oidProject, appSessUser.getCompanyOID());
/* end switch*/
JspProject jspProject = ctrlProject.getForm();

/*count list All Project*/
//int vectSize = DbProject.getCountProject(oidCustomer, name, number, invStartDate, invEndDate, chkInvDate, status);;//DbProject.getCount(whereClause);
int vectSize = DbProject.getCount(whereClause);

Project project = ctrlProject.getProject();
msgString =  ctrlProject.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlProject.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//listProject = DbProject.getListProject(start, recordToGet, oidCustomer, name, number, invStartDate, invEndDate, chkInvDate, status);//DbProject.list(start,recordToGet, whereClause , orderClause);
listProject = DbProject.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listProject.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listProject = DbProject.list(start,recordToGet, whereClause , orderClause);
}
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

/*
function targetPage(oidProject, oidProposal){
	<%if(x==1){%>
		window.location="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject+"&hidden_proposal_id="+oidProposal;
	<%}
	else if(x==2){%>
		window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject+"&hidden_proposal_id="+oidProposal;
	<%}
	else if(x==3){%>
		window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject+"&hidden_proposal_id="+oidProposal;
	<%}
	else{%>
		window.location="newproject.jsp?menu_idx=<%=menuIdx%>&hidden_project="+oidProject+"&command=<%=JSPCommand.EDIT%>&hidden_proposal_id="+oidProposal;
	<%}%>
}
*/
function targetPage(oidProject){
	<%if(x==1){%>
		window.location="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject;
	<%}
	else if(x==2){%>
		window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject;
	<%}
	else if(x==3){%>
		window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidProject;
	<%}
	else{%>
		window.location="newproject.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.EDIT%>&oid="+oidProject;
	<%}%>
}

function cmdSearch(){
	document.frmproject.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdAdd(){
	document.frmproject.hidden_project_id.value="0";
	document.frmproject.command.value="<%=JSPCommand.ADD%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdAsk(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=JSPCommand.ASK%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdConfirmDelete(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=JSPCommand.DELETE%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}
function cmdSave(){
	document.frmproject.command.value="<%=JSPCommand.SAVE%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdEdit(oidProject, oidProposal){
	document.frmproject.hidden_proposal_id.value=oidProposal;
	
	alert("oidProposal : "+oidProposal);
	alert("jadi : "+document.frmproject.hidden_proposal_id.value);
	
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.hidden_project.value=oidProject;
	document.frmproject.command.value="<%=JSPCommand.EDIT%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp";
	document.frmproject.submit();
}

function cmdCancel(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=JSPCommand.EDIT%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdBack(){
	document.frmproject.command.value="<%=JSPCommand.BACK%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdListFirst(){
	document.frmproject.command.value="<%=JSPCommand.FIRST%>";
	document.frmproject.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdListPrev(){
	document.frmproject.command.value="<%=JSPCommand.PREV%>";
	document.frmproject.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdListNext(){
	document.frmproject.command.value="<%=JSPCommand.NEXT%>";
	document.frmproject.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdListLast(){
	document.frmproject.command.value="<%=JSPCommand.LAST%>";
	document.frmproject.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmproject.action="projectlist.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
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
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/search2.gif')">
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
                                                <form name="frmproject" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="hidden_project_id" value="<%=oidProject%>">
                                                  <input type="hidden" name="hidden_project" value="<%=oidProject%>">
                                                  <input type="hidden" name="hidden_proposal_id" value="<%=project.getProposalId()%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; <span class="lvl2">Project 
                                                              List <br>
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
													
													<tr align="left" valign="top"> 
                                                      <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="7%">&nbsp;</td>
                                                                  <td width="24%">&nbsp;</td>
                                                                  <td width="8%"><img src="../images/spacer.gif" width="20" height="1"></td>
                                                                  <td width="8%">&nbsp;</td>
                                                                  <td width="15%">&nbsp;</td>
                                                                  <td width="46%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="7%">Customer</td>
                                                                  <td colspan="5"> 
                                                                    <%
											//Vector cust = DbCustomer.list(0,0, "company_id="+systemCompanyId, "");
											Vector cust = DbCustomer.list(0,0, "", "");
											%>
                                                                    <select name="customer_id" onChange="javascript:cmdSearch()">
                                                                      <option value="0">-- 
                                                                      All --</option>
                                                                      <%if(cust!=null && cust.size()>0){
												  for(int i=0; i<cust.size(); i++){
														Customer c = (Customer)cust.get(i);
												%>
                                                                      <option value="<%=c.getOID()%>" <%if(c.getOID()==oidCustomer){%>selected<%}%>><%=c.getCode()+" - "+c.getName()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="7%" height="14" nowrap>Date 
                                                                    Between</td>
                                                                  <td colspan="5" height="14"> 
                                                                    <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate==null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    and 
                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate==null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <input type="checkbox" name="chkInvDate" value="1" <%if(chkInvDate==1){ %>checked<%}%>>
                                                                    Ignored </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="7%" height="14" nowrap>Project 
                                                                    Name</td>
                                                                  <td width="24%" height="14"> 
                                                                    <input type="text" name="proj_name" value="<%=(name==null) ? "" : name%>" size="35">
                                                                  </td>
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td width="8%" height="14" nowrap>Project 
                                                                    Status</td>
                                                                  <td width="15%" height="14"> 
                                                                    <select name="status">
                                                                      <option value="-1">-- 
                                                                      All --</option>
                                                                      <%
												for(int i=0; i<I_Crm.projectStatusStr.length; i++){
												%>
                                                                      <option value="<%=i%>" <%if(i==status){%>selected<%}%>><%=I_Crm.projectStatusStr[i]%></option>
                                                                      <%}%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="46%" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="7%" height="14" nowrap>Project 
                                                                    Number</td>
                                                                  <td width="24%" height="14"> 
                                                                    <input type="text" name="proj_number" value="<%=(number==null) ? "" : number%>" size="35">
                                                                  </td>
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td width="8%" height="14" nowrap>Unit 
                                                                    Usaha </td>
                                                                  <td width="15%" height="15"> 
                                                                    <%
																	Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
																	%>
                                                                    <select name="src_unit_usaha_id">
																	  <option value="0">-- All --</option>
                                                                      <%if(unitUsh!=null && unitUsh.size()>0){
																	  for(int i=0; i<unitUsh.size(); i++){
																	  	UnitUsaha us = (UnitUsaha)unitUsh.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==unitUsahaId){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="46%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                  <td width="7%" height="33">&nbsp;</td>
                                                                  <td width="24%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                  <td width="8%" height="33">&nbsp;</td>
                                                                  <td width="8%" height="33">&nbsp;</td>
                                                                  <td width="15%" height="33">&nbsp;</td>
                                                                  <td width="46%" height="33">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="7%" height="15">&nbsp;</td>
                                                                  <td width="24%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="15%" height="15">&nbsp;</td>
                                                                  <td width="46%" height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="20" valign="middle" colspan="3" class="comment">&nbsp;<b>Project 
                                                              List</b></td>
                                                          </tr>
                                                          <%
							try{
								//if (listProject.size()>0){
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td class="boxed1"><%= drawList(listProject,oidProject)%></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <%  //} 
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
                                                              <% 
											ctrLine.setLocationImg(approot+"/images/ctr_line");
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
                                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="97%">&nbsp;</td>
                                                                </tr>
                                                                <!--tr> 
											<td width="97%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
										  </tr-->
                                                              </table>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp; 
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </form>
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

