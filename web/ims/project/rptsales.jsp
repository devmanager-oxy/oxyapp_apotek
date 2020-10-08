 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "java.util.Date" %>
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
<%
int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
long itemGroupId = JSPRequestValue.requestLong(request, "x_project_type");

//out.println("itemGroupId : "+itemGroupId);

long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
String name = JSPRequestValue.requestString(request, "proj_name");
String number = JSPRequestValue.requestString(request, "proj_number");
Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
int status = JSPRequestValue.requestInt(request, "status");
long unitUsahaId = JSPRequestValue.requestLong(request, "src_unit_usaha_id");
int srcGroup = JSPRequestValue.requestInt(request, "src_group");

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSales = JSPRequestValue.requestLong(request, "hidden_project_id");

//Company
Company company = new Company();
try{
	company = DbCompany.getCompany();
}catch(Exception e){
	System.out.println(e);
}

//Vat
double percentVat = company.getGovernmentVat();

//if(iJSPCommand==JSPCommand.NONE){
//	itemGroupId = -1;
//}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
//String whereClause = "company_id="+systemCompanyId;
String whereClause = "";
String orderClause = "";

if(invStartDate==null){
	invStartDate = new Date();
}

if(invEndDate==null){
	invEndDate = new Date();
}

//------------------ where ---------------------------
if(chkInvDate==0){
	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + "p.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and  p.date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"'";
}
 
if(unitUsahaId!=0){
	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " p.unit_usaha_id="+unitUsahaId;
}

if(itemGroupId!=0){
	if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + " im.item_group_id="+itemGroupId;
}

String sql = "select distinct p.* from crm_project p "+		
		" inner join crm_project_product_detail pd on p.project_id=pd.project_id "+
		" inner join pos_item_master im on im.item_master_id = pd.product_master_id ";
		if(whereClause!= ""){
			sql = sql + " where "+whereClause;
		}
		sql = sql + " order by p.date";


//out.println("<br>whereClause : "+whereClause);
//out.println("<br>sql : "+sql);

//Vector listSales = DbSales.getSalesReport(invStartDate, invEndDate, unitUsahaId);//, itemGroupId);
Vector listSales = new Vector();//DbSales.list(0,0, whereClause, "date, unit_usaha_id, number");//getSalesReport(invStartDate, invEndDate, unitUsahaId);//, itemGroupId);

CONResultSet crs = null;
try{
	crs = CONHandler.execQueryResult(sql);
	ResultSet rs = crs.getResultSet();
	while(rs.next()){
		Project pd = new Project();
		DbProject.resultToObject(rs, pd);
		listSales.add(pd);
	}
}
catch(Exception e){
}
finally{
	CONResultSet.close(crs);
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
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
function targetPage(oidSales, oidProposal){
	<%if(x==1){%>
		window.location="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales+"&hidden_proposal_id="+oidProposal;
	<%}
	else if(x==2){%>
		window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales+"&hidden_proposal_id="+oidProposal;
	<%}
	else if(x==3){%>
		window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales+"&hidden_proposal_id="+oidProposal;
	<%}
	else{%>
		window.location="newproject.jsp?menu_idx=<%=menuIdx%>&hidden_project="+oidSales+"&command=<%=JSPCommand.EDIT%>&hidden_proposal_id="+oidProposal;
	<%}%>
}
*/
function targetPage(oidSales){
	<%if(x==1){%>
		window.location="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
	<%}
	else if(x==2){%>
		window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
	<%}
	else if(x==3){%>
		window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
	<%}
	else{%>
		window.location="project.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.LIST%>&hidden_project_id="+oidSales;
	<%}%>
}

function cmdSearch(){
	document.frmproject.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdAdd(){
	document.frmproject.hidden_project_id.value="0";
	document.frmproject.command.value="<%=JSPCommand.ADD%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdAsk(oidSales){
	document.frmproject.hidden_project_id.value=oidSales;
	document.frmproject.command.value="<%=JSPCommand.ASK%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdConfirmDelete(oidSales){
	document.frmproject.hidden_project_id.value=oidSales;
	document.frmproject.command.value="<%=JSPCommand.DELETE%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="newproject.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}
function cmdSave(){
	document.frmproject.command.value="<%=JSPCommand.SAVE%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdEdit(oidSales, oidProposal){
	document.frmproject.hidden_proposal_id.value=oidProposal;
	
	//alert("oidProposal : "+oidProposal);
	//alert("jadi : "+document.frmproject.hidden_proposal_id.value);
	
	document.frmproject.hidden_project_id.value=oidSales;
	document.frmproject.hidden_project.value=oidSales;
	//document.frmproject.command.value="<%=JSPCommand.EDIT%>";
	document.frmproject.command.value="<%=JSPCommand.LIST%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdCancel(oidSales){
	document.frmproject.hidden_project_id.value=oidSales;
	document.frmproject.command.value="<%=JSPCommand.EDIT%>";
	document.frmproject.prev_command.value="<%=prevJSPCommand%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdBack(){
	document.frmproject.command.value="<%=JSPCommand.BACK%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdListFirst(){
	document.frmproject.command.value="<%=JSPCommand.FIRST%>";
	document.frmproject.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdListPrev(){
	document.frmproject.command.value="<%=JSPCommand.PREV%>";
	document.frmproject.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
	}

function cmdListNext(){
	document.frmproject.command.value="<%=JSPCommand.NEXT%>";
	document.frmproject.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmproject.submit();
}

function cmdListLast(){
	document.frmproject.command.value="<%=JSPCommand.LAST%>";
	document.frmproject.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmproject.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
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
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              </font><font class="tit1">&raquo; 
                                                              <span class="lvl2">Credit 
                                                              Sales Report<br>
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
                                                                  <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="3" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Date 
                                                                    Between</td>
                                                                  <td colspan="3" height="14"> 
                                                                    <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate==null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    and 
                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate==null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproject.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Unit 
                                                                    Usaha </td>
                                                                  <td width="33%" height="14"> 
                                                                    <%
																	Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
																	%>
                                                                    <select name="src_unit_usaha_id">
                                                                      <option value="0">-- 
                                                                      All --</option>
                                                                      <%if(unitUsh!=null && unitUsh.size()>0){
																	  for(int i=0; i<unitUsh.size(); i++){
																	  	UnitUsaha us = (UnitUsaha)unitUsh.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==unitUsahaId){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td width="49%" height="14" nowrap>&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14">Item 
                                                                    Group</td>
                                                                  <td width="33%" height="14"> 
                                                                    <%
																	Vector itemGrp = DbItemGroup.list(0,0, "", "name");
																	%>
                                                                    <select name="x_project_type">
                                                                      <option value="0" <%if(itemGroupId==0){%>selected<%}%>>-- 
                                                                      All --</option>
																	  <%
																	  if(itemGrp!=null && itemGrp.size()>0){
																	  for(int i=0; i<itemGrp.size(); i++){
																	  	ItemGroup ig = (ItemGroup)itemGrp.get(i);
																	  %>
                                                                      <option value="<%=ig.getOID()%>" <%if(itemGroupId==ig.getOID()){%>selected<%}%>><%=ig.getName()%></option>
																	  <%}}%>                                                                      
                                                                    </select>
                                                                  </td>
                                                                  <td width="8%" height="14">&nbsp;</td>
                                                                  <td width="49%" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="33">&nbsp;</td>
                                                                  <td width="33%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                  <td width="8%" height="33">&nbsp;</td>
                                                                  <td width="49%" height="33">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="33%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="49%" height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="20" valign="middle" colspan="3" class="comment">&nbsp;<b>Sales 
                                                              Report</b></td>
                                                          </tr>
                                                          <%
							try{
								//if (listSales.size()>0){
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td class="boxed1"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                      <tr> 
                                                                        <td class="tablehdr" width="2%">No</td>
                                                                        <td class="tablehdr" width="5%">Date</td>
                                                                        <td class="tablehdr" width="7%">Sales 
                                                                          No. 
                                                                        </td>
                                                                        <td class="tablehdr" width="17%">Description</td>
                                                                        <td class="tablehdr" width="11%">Group</td>
                                                                        <td class="tablehdr" width="11%">Customer</td>
                                                                        <td class="tablehdr" width="4%">Qty</td>
                                                                        <td class="tablehdr" width="6%">Price</td>
                                                                        <td class="tablehdr" width="7%">Amount</td>
                                                                        <td class="tablehdr" width="6%">Discount</td>
                                                                        <td class="tablehdr" width="6%">PPN</td>
                                                                        <td class="tablehdr" width="6%">Kwitansi</td>
                                                                        <td class="tablehdr" width="6%">HPP</td>
                                                                        <td class="tablehdr" width="6%">Laba</td>
                                                                      </tr>
                                                                      <%
																	  
																	  double totalQty = 0;
																	  double totalAmount = 0;
																	  double totalDiscount = 0;
																	  double totalVat = 0;
																	  double grandTotal = 0;
																	  double totallaba = 0;
																	  double totalhpp = 0;
																	  
																	  long tempSalesId = 0;
																	  
																	  //out.println("listSales : "+listSales);
																	  
																	  if(listSales!=null && listSales.size()>0){
																	  		for(int i=0; i<listSales.size(); i++){
																				
																				//RptSales rps = (RptSales)listSales.get(i);
																				Project project = (Project)listSales.get(i);
																				
																				//out.println("ok : "+ok);
																				
																				Vector temp = DbProjectProductDetail.list(0,0, "project_id="+project.getOID(), "");
																				
																				Customer cus = new Customer();
																				try{
																					cus = DbCustomer.fetchExc(project.getCustomerId());
																				}
																				catch(Exception e){
																				}
																				
																				double vatAmount = 0;
																				if(project.getVat()==1){
																					vatAmount = (project.getAmount()-project.getDiscountAmount())*(percentVat/100);
																				}																				
																		
																		if(temp!=null && temp.size()>0){
																			for(int xx=0; xx<temp.size(); xx++){	
																				ProjectProductDetail sd = (ProjectProductDetail)temp.get(xx);
																				ItemMaster im = new ItemMaster();
																				try{
																					im = DbItemMaster.fetchExc(sd.getProductMasterId());
																				}
																				catch(Exception e){
																				}
																				
																				ItemGroup ig = new ItemGroup();
																				try{
																					ig = DbItemGroup.fetchExc(im.getItemGroupId());
																				}
																				catch(Exception e){
																				}
																				
																				totalAmount = totalAmount + sd.getTotal();
																				totalhpp = totalhpp + (sd.getCogs()*sd.getQty());
																				totallaba = totallaba + (sd.getTotal()-project.getDiscountAmount()-(sd.getCogs()*sd.getQty()));
																				if(temp.size()==1){
																					totalDiscount = totalDiscount + project.getDiscountAmount();
																					totalVat = totalVat + vatAmount;
																					grandTotal = grandTotal + (project.getAmount()-project.getDiscountAmount()+vatAmount);
																				}
																				
																	  %>
                                                                      <tr> 
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="2%"> 
                                                                          <div align="center"><font size="1"><%=(xx==0) ? ""+(i+1) : ""%></font></div>
                                                                        </td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="5%"><font size="1"><%=(xx==0) ? JSPFormater.formatDate(project.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"><font size="1"><%=(xx==0) ? project.getNumber() : ""%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="17%"><font size="1"><%=im.getName()%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="11%"><font size="1"><%=ig.getName()%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="11%"><font size="1"><%=(xx==0 && cus.getOID()!=0) ? cus.getName() : ""%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="4%"> 
                                                                          <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                        </td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"><font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getTotal(), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(project.getDiscountAmount(), "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(vatAmount, "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(project.getAmount()-project.getDiscountAmount()+vatAmount, "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getCogs()*sd.getQty(), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getTotal()-project.getDiscountAmount()-(sd.getCogs()*sd.getQty()), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                      </tr>
                                                                      <%}%>
                                                                      <%if(temp.size()>1){
																	  
																					totalDiscount = totalDiscount + project.getDiscountAmount();
																					totalVat = totalVat + vatAmount;
																					grandTotal = grandTotal + (project.getAmount()-project.getDiscountAmount()+vatAmount);
																	  %>
                                                                      <tr> 
                                                                        <td height="2" width="2%">&nbsp;</td>
                                                                        <td height="2" width="5%">&nbsp;</td>
                                                                        <td height="2" width="7%">&nbsp;</td>
                                                                        <td height="2" width="17%">&nbsp;</td>
                                                                        <td height="2" width="11%">&nbsp;</td>
                                                                        <td height="2" width="11%">&nbsp;</td>
                                                                        <td height="2" width="4%">&nbsp;</td>
                                                                        <td height="2" width="6%">&nbsp;</td>
                                                                        <td height="2" class="tablecell1" width="7%"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(project.getAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(project.getDiscountAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(vatAmount, "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(project.getAmount()-project.getDiscountAmount()+vatAmount, "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1" width="6%">&nbsp;</td>
                                                                        <td height="2" class="tablecell1" width="6%">&nbsp;</td>
                                                                      </tr>
                                                                      <%}%>
                                                                      <tr> 
                                                                        <td colspan="14" height="2"></td>
                                                                      </tr>
                                                                      <%}
																	  }}%>
                                                                      <tr> 
                                                                        <td colspan="14" height="5"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="2%" height="19">&nbsp;</td>
                                                                        <td width="5%" height="19">&nbsp;</td>
                                                                        <td width="7%" height="19">&nbsp;</td>
                                                                        <td width="17%" height="19">&nbsp;</td>
                                                                        <td width="11%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="center"><font color="#FFFFFF" size="1"><b>T 
                                                                            O 
                                                                            T 
                                                                            A 
                                                                            L</b></font></div>
                                                                        </td>
                                                                        <td width="11%" height="19" bgcolor="#3366CC">&nbsp;</td>
                                                                        <td width="4%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="center"><font size="1"><b><font color="#FFFFFF"><%=totalQty%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                        <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalAmount, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalDiscount, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalhpp, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totallaba, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="2%">&nbsp;</td>
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="17%">&nbsp;</td>
                                                                        <td width="11%">&nbsp;</td>
                                                                        <td width="11%">&nbsp;</td>
                                                                        <td width="4%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td class="boxed1"><img src="../images/printxls.gif" width="120" height="22"></td>
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
                                                              </span> </td>
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

