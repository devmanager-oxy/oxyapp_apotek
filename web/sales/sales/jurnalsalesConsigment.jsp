 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksl.jsp" %>
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

	public String drawList(Vector objectClass ,  long salesId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("Date dd/MM/yy","5%");
		ctrlist.addHeader("Sales Number","13%");
		//ctrlist.addHeader("Name","20%");
		//ctrlist.addHeader("Customer","20%");
		ctrlist.addHeader("Amount","10%");
		ctrlist.addHeader("Discount","10%");
		ctrlist.addHeader("Vat","10%");
		ctrlist.addHeader("Total Amount","10%");
		//ctrlist.addHeader("Customer PIC/Phone","10%");
		//ctrlist.addHeader("Periode dd/MM/yy","7%");
		//ctrlist.addHeader("PIC","10%");
		
		//ctrlist.addHeader("Status","5%");

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
			Sales sales = (Sales)objectClass.get(i);
			
			/*
			Proposal proposal = new Proposal();
			try{
				proposal = DbProposal.fetchExc(sales.getProposalId());
			}
			catch(Exception e){
			}
			*/
			
			 Vector rowx = new Vector();
			 if(salesId == sales.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = sales.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			//rowx.add(sales.getNumberPrefix());

			//rowx.add(proposal.getNumber());
			
			//rowx.add(String.valueOf(sales.getCounter()));
			rowx.add(sales.getNumber());

			//rowx.add(sales.getName());
			
			Customer customer = new Customer();
			try{
				customer = DbCustomer.fetchExc(sales.getCustomerId());
			}
			catch(Exception e){
			}
			//rowx.add(customer.getName());
			
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(sales.getAmount(),"#,###")+"</div>");			
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(sales.getDiscountAmount(),"#,###")+"</div>");
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(sales.getVatAmount(),"#,###")+"</div>");
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount(),"#,###")+"</div>");

			//rowx.add(sales.getCustomerPic()+"<br>"+sales.getCustomerPicPhone());

			//rowx.add(sales.getCustomerPicPhone());
			String str_dt_StartDate = ""; 
			try{
				Date dt_StartDate = sales.getStartDate();
				if(dt_StartDate==null){
					dt_StartDate = new Date();
				}

				str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd/MM/yy");
			}catch(Exception e){ str_dt_StartDate = ""; }

			//rowx.add(str_dt_StartDate);
			

			String str_dt_EndDate = ""; 
			try{
				Date dt_EndDate = sales.getEndDate();
				if(dt_EndDate==null){
					dt_EndDate = new Date();
				}

				str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd/MM/yy");
			}catch(Exception e){ str_dt_EndDate = ""; }

			//rowx.add(str_dt_StartDate+" -<br>"+str_dt_EndDate);
			
			

			//rowx.add(sales.getCustomerPicPosition());

			//rowx.add(String.valueOf(sales.getUserId()));
			
			Employee em = new Employee();
			try{
				em = DbEmployee.fetchExc(sales.getEmployeeId());
			}
			catch(Exception e){
			}

			//rowx.add(em.getName());
			
			

			//rowx.add(sales.getDescription());

			//rowx.add("<div align=\"center\">"+I_Crm.projectStatusStr[sales.getStatus()]+"</div>");

			lstData.add(rowx);
			//lstLinkData.add(String.valueOf(sales.getOID())+"','"+sales.getProposalId());
			lstLinkData.add(String.valueOf(sales.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
int salesType = JSPRequestValue.requestInt(request, "sales_type");

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
long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");

if(iJSPCommand==JSPCommand.NONE){
	salesType = -1;
}

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
	whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"'";
}
 
if(unitUsahaId!=0){
	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " unit_usaha_id="+unitUsahaId;
}

if(salesType!=-1){
	if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + " type="+salesType;
}

if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " status=0";

if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " sales_type=" + DbSales.TYPE_CONSIGMENT;
//out.println("whereClause : "+whereClause);

//Vector listSales = DbSales.getSalesReport(invStartDate, invEndDate, unitUsahaId);//, salesType);
Vector listSales = DbSales.list(0,0, whereClause, "date, unit_usaha_id, number");//getSalesReport(invStartDate, invEndDate, unitUsahaId);//, salesType);

if(iJSPCommand==JSPCommand.POST){
	Vector temp = new Vector();
	if(listSales!=null && listSales.size()>0){
		for(int i=0; i<listSales.size(); i++){
			Sales sales = (Sales)listSales.get(i);
			int xxx = JSPRequestValue.requestInt(request, "sale_"+sales.getOID());
			if(xxx==1){
				temp.add(sales);
			}
		}
		
		if(temp!=null && temp.size()>0){
			DbSales.postJournal(temp);
		}
	}
	
	listSales = DbSales.list(0,0, whereClause, "date, unit_usaha_id, number");//getSalesReport(invStartDate, invEndDate, unitUsahaId);//, salesType);
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
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
		window.location="newsales.jsp?menu_idx=<%=menuIdx%>&hidden_sales="+oidSales+"&command=<%=JSPCommand.EDIT%>&hidden_proposal_id="+oidProposal;
	<%}%>
}
*/

function cmdPostJournal(){
	document.frmsales.command.value="<%=JSPCommand.POST%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

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
		window.location="sales.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.LIST%>&hidden_sales_id="+oidSales;
	<%}%>
}

function cmdSearch(){
	document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdAdd(){
	document.frmsales.hidden_sales_id.value="0";
	document.frmsales.command.value="<%=JSPCommand.ADD%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdAsk(oidSales){
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.command.value="<%=JSPCommand.ASK%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdConfirmDelete(oidSales){
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.command.value="<%=JSPCommand.DELETE%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}
function cmdSave(){
	document.frmsales.command.value="<%=JSPCommand.SAVE%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdEdit(oidSales, oidProposal){
	document.frmsales.hidden_proposal_id.value=oidProposal;
	
	//alert("oidProposal : "+oidProposal);
	//alert("jadi : "+document.frmsales.hidden_proposal_id.value);
	
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.hidden_sales.value=oidSales;
	//document.frmsales.command.value="<%=JSPCommand.EDIT%>";
	document.frmsales.command.value="<%=JSPCommand.LIST%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="sales.jsp";
	document.frmsales.submit();
}

function cmdCancel(oidSales){
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.command.value="<%=JSPCommand.EDIT%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdBack(){
	document.frmsales.command.value="<%=JSPCommand.BACK%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListFirst(){
	document.frmsales.command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListPrev(){
	document.frmsales.command.value="<%=JSPCommand.PREV%>";
	document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListNext(){
	document.frmsales.command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListLast(){
	document.frmsales.command.value="<%=JSPCommand.LAST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsales.action="jurnalsalesConsigment.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenuconsigment.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menuconsigment.jsp"%>
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
                                                <form name="frmsales" method ="post" action="">
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
                                                              <span class="lvl2">Post 
                                                              Journal Sales Consigment<br>
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
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    and 
                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate==null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
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
                                                                  <td width="10%" height="14">Sales 
                                                                    Type </td>
                                                                  <td width="33%" height="14"> 
                                                                    <select name="sales_type">
																	  <option value="-1" <%if(salesType==-1){%>selected<%}%>>-- All --</option>	
                                                                      <option value="0" <%if(salesType==0){%>selected<%}%>>CASH</option>
                                                                      <option value="1" <%if(salesType==1){%>selected<%}%>>CREDIT</option>
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
                                                                        <td class="tablehdr" width="6%">Date</td>
                                                                        <td class="tablehdr" width="6%">Sales 
                                                                          No. 
                                                                        </td>
                                                                        <td class="tablehdr" width="17%">Description</td>
                                                                        <td class="tablehdr" width="15%">Group</td>
                                                                        <td class="tablehdr" width="3%">Qty</td>
                                                                        <td class="tablehdr" width="7%">Price</td>
                                                                        <td class="tablehdr" width="7%">Amount</td>
                                                                        <td class="tablehdr" width="7%">Discount</td>
                                                                        <td class="tablehdr" width="7%">PPN</td>
                                                                        <td class="tablehdr" width="8%">Kwitansi</td>
                                                                        <td class="tablehdr" width="7%">HPP</td>
                                                                        <td class="tablehdr" width="8%">Laba</td>
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
																				Sales sales = (Sales)listSales.get(i);
																				
																				//out.println("ok : "+ok);
																				
																				Vector temp = DbSalesDetail.list(0,0, "sales_id="+sales.getOID(), "");
																				
																				//totalQty = totalQty + rps.getQty();
																				//totalAmount = totalAmount + rps.getAmount();
																				//totalDiscount = totalDiscount + rps.getDiscount();
																				//totalVat = totalVat + rps.getVat();
																				//grandTotal = grandTotal + rps.getAmount() - rps.getDiscount() + rps.getVat();
																		
																		if(temp!=null && temp.size()>0){
																			for(int xx=0; xx<temp.size(); xx++){	
																				SalesDetail sd = (SalesDetail)temp.get(xx);
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
																				totallaba = totallaba + (sd.getTotal()-sales.getDiscountAmount()-(sd.getCogs()*sd.getQty()));
																				if(temp.size()==1){
																					totalDiscount = totalDiscount + sales.getDiscountAmount();
																					totalVat = totalVat + sales.getVatAmount();
																					grandTotal = grandTotal + (sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount());
																				}
																				
																	  %>
                                                                      <tr> 
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="2%">
																		  <%if(xx==0){%> 
                                                                          <div align="center"><font size="1"> 
                                                                            <input type="checkbox" name="sale_<%=sales.getOID()%>" value="1" checked>
                                                                            </font></div>
																		  <%}%>	
                                                                        </td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"><font size="1"><%=(xx==0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="6%"><font size="1"><%=(xx==0) ? sales.getNumber() : ""%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="17%" nowrap><font size="1"><%=im.getName()%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="15%"><font size="1"><%=ig.getName()%></font></td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="3%"> 
                                                                          <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                        </td>
                                                                        <td <%if(1==0){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"> 
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
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(sales.getDiscountAmount(), "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(sales.getVatAmount(), "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="8%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=(temp.size()==1) ? JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount(), "#,###") : ""%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="7%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getCogs()*sd.getQty(), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                        <td <%if(temp.size()==1){%>class="tablecell1"<%}else{%>class="tablecell"<%}%> width="8%"> 
                                                                          <div align="right"> 
                                                                            <font size="1"> 
                                                                            <%=JSPFormater.formatNumber(sd.getTotal()-sales.getDiscountAmount()-(sd.getCogs()*sd.getQty()), "#,###")%> 
                                                                            </font></div>
                                                                        </td>
                                                                      </tr>
                                                                      <%}%>
                                                                      <%if(temp.size()>1){
																	  
																					totalDiscount = totalDiscount + sales.getDiscountAmount();
																					totalVat = totalVat + sales.getVatAmount();
																					grandTotal = grandTotal + (sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount());
																	  %>
                                                                      <tr> 
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2">&nbsp;</td>
                                                                        <td height="2" class="tablecell1"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getDiscountAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1"> 
                                                                          <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount(), "#,###")%></font></div>
                                                                        </td>
                                                                        <td height="2" class="tablecell1">&nbsp;</td>
                                                                        <td height="2" class="tablecell1">&nbsp;</td>
                                                                      </tr>
                                                                      <%}%>
                                                                      <tr> 
                                                                        <td colspan="13" height="2"></td>
                                                                      </tr>
                                                                      <%}
																	  }}%>
                                                                      <tr> 
                                                                        <td colspan="13" height="5"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="2%" height="19">&nbsp;</td>
                                                                        <td width="6%" height="19">&nbsp;</td>
                                                                        <td width="6%" height="19">&nbsp;</td>
                                                                        <td width="17%" height="19">&nbsp;</td>
                                                                        <td width="15%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="center"><font color="#FFFFFF" size="1"><b>T 
                                                                            O 
                                                                            T 
                                                                            A 
                                                                            L</b></font></div>
                                                                        </td>
                                                                        <td width="3%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="center"><font size="1"><b><font color="#FFFFFF"><%=totalQty%></font></b></font></div>
                                                                        </td>
                                                                        <td width="7%" height="19" bgcolor="#9b7934"><font size="1"></font></td>
                                                                        <td width="7%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalAmount, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="7%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalDiscount, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="7%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="8%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="7%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalhpp, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                        <td width="8%" height="19" bgcolor="#9b7934"> 
                                                                          <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totallaba, "#,###")%></font></b></font></div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="2%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="6%">&nbsp;</td>
                                                                        <td width="17%">&nbsp;</td>
                                                                        <td width="15%">&nbsp;</td>
                                                                        <td width="3%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="8%">&nbsp;</td>
                                                                        <td width="7%">&nbsp;</td>
                                                                        <td width="8%">&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td class="boxed1"><a href="javascript:cmdPostJournal()"><img src="../images/post_journal.gif" width="92" height="22" border="0"></a></td>
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
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

