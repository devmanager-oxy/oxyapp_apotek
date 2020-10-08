 
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
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
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
		ctrlist.addHeader("Sales Number","10%");
		//ctrlist.addHeader("Name","20%");
		ctrlist.addHeader("Customer","20%");
		ctrlist.addHeader("Total Invoice","10%");
		ctrlist.addHeader("Total Paid","10%");
		ctrlist.addHeader("Balance","10%");
		
		//ctrlist.addHeader("Customer PIC/Phone","10%");
		//ctrlist.addHeader("Periode dd/MM/yy","7%");
		//ctrlist.addHeader("PIC","10%");
		
		ctrlist.addHeader("Status","10%");

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
                        
                        double totalPayment = DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+"=" + sales.getOID());
                        double balance = sales.getAmount() - totalPayment;
                            
                        rowx.add("<div align=\"left\">"+customer.getName()+ "</div>");			    
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(sales.getAmount(),"#,###")+"</div>");			
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(totalPayment,"#,###")+"</div>");
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(balance,"#,###")+"</div>");

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

			rowx.add("<div align=\"center\">"+((sales.getPaymentStatus()==0) ? "fully paid" : "partially paid")+"</div>");

			lstData.add(rowx);
			//lstLinkData.add(String.valueOf(sales.getOID())+"','"+sales.getProposalId());
			lstLinkData.add(String.valueOf(sales.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));

//long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
String name = JSPRequestValue.requestString(request, "proj_name");
String number = JSPRequestValue.requestString(request, "proj_number");
String code_member = JSPRequestValue.requestString(request, "member_code");
Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
int status = JSPRequestValue.requestInt(request, "status");
long locationId = JSPRequestValue.requestLong(request, "src_location_id");

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");

double totalCredit=0;
double totalPaidCus=0;
double totalBalance=0;


if(iJSPCommand==JSPCommand.NONE){
	chkInvDate = 1;
	status = -1;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
//String whereClause = "company_id="+systemCompanyId;
String whereClause = "";
String orderClause = "";

long oidCustomer=0;
if(code_member!=""){
    oidCustomer=DbCustomer.getOidByMemberCode(code_member);
    if(oidCustomer==0){
        whereClause = whereClause + " customer_id ="+oidCustomer;
    }
}
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
	whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"'";
 }
 
 //if(status!=-1){
 // 	if (whereClause != "") whereClause = whereClause + " and ";
 //	whereClause = whereClause + " status='"+status+"'";
 //}
 
 if(locationId!=0){
 	if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " location_id="+locationId;
 }
 
 if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " type="+ DbSales.TYPE_CREDIT;
        
 if (whereClause != "") whereClause = whereClause + " and ";
	whereClause = whereClause + " payment_status="+ DbSales.TYPE_BELUM_LUNAS;
        
 
//out.println("whereClause "+whereClause);

CmdSales ctrlSales = new CmdSales(request);
JSPLine ctrLine = new JSPLine();
Vector listSales = new Vector(1,1);

/*switch statement */
iErrCode = ctrlSales.action(iJSPCommand , oidSales, appSessUser.getCompanyOID(), user);
/* end switch*/
JspSales jspSales = ctrlSales.getForm();

/*count list All Sales*/
//int vectSize = DbSales.getCountSales(oidCustomer, name, number, invStartDate, invEndDate, chkInvDate, status);;//DbSales.getCount(whereClause);
int vectSize = DbSales.getCount(whereClause);

Sales sales = ctrlSales.getSales();
msgString =  ctrlSales.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlSales.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//listSales = DbSales.getListSales(start, recordToGet, oidCustomer, name, number, invStartDate, invEndDate, chkInvDate, status);//DbSales.list(start,recordToGet, whereClause , orderClause);
listSales = DbSales.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listSales.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listSales = DbSales.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
 
<head>
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Oxy-Sales</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
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
function targetPage(oidSales){
	<%if(x==1){%>
		window.location="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.LIST%>&hidden_sales_id="+oidSales;
	<%}
	else if(x==2){%>
		window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
	<%}
	else if(x==3){%>
		window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
	<%}
	else{%>
		window.location="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.LIST%>&hidden_sales_id="+oidSales;
	<%}%>
}

function cmdSearch(){
	document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
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
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdEdit(oidSales, oidProposal){
	document.frmsales.hidden_proposal_id.value=oidProposal;
	
	//alert("oidProposal : "+oidProposal);
	//alert("jadi : "+document.frmsales.hidden_proposal_id.value);
	
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.hidden_sales.value=oidSales;
	
	document.frmsales.command.value="<%=JSPCommand.LIST%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="sales.jsp";
	document.frmsales.submit();
}

function cmdCancel(oidSales){
	document.frmsales.hidden_sales_id.value=oidSales;
	document.frmsales.command.value="<%=JSPCommand.EDIT%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdBack(){
	document.frmsales.command.value="<%=JSPCommand.BACK%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListFirst(){
	document.frmsales.command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListPrev(){
	document.frmsales.command.value="<%=JSPCommand.PREV%>";
	document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListNext(){
	document.frmsales.command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListLast(){
	document.frmsales.command.value="<%=JSPCommand.LAST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsales.action="rptSalesCredit.jsp?menu_idx=<%=menuIdx%>";
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
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" >&nbsp;</td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td>                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
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
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="hidden_sales_id" value="<%=oidSales%>">
                                                  <input type="hidden" name="hidden_sales" value="<%=oidSales%>">
                                                  <input type="hidden" name="hidden_proposal_id" value="<%=sales.getProposalId()%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    
                                                    <tr align="left" valign="top"> 
                                                      <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="2" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="14" nowrap>Date 
                                                                    Between</td>
                                                                  <td colspan="2" height="14"> 
                                                                    <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate==null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    and 
                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate==null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <input type="checkbox" name="chkInvDate" value="1" <%if(chkInvDate==1){ %>checked<%}%>>
                                                                    Ignored </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="14" nowrap>Sales 
                                                                    Number</td>
                                                                  <td width="38%" height="14"> 
                                                                    <input type="text" name="proj_number" value="<%=(number==null) ? "" : number%>" size="35">                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="14" nowrap>Code/Member ID                                                                    </td>
                                                                  <td width="38%" height="14"> 
                                                                    <input type="text" name="member_code" value="<%=(code_member==null) ? "" : code_member%>" size="35">                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="14">Location                                                                     </td>
                                                                  <td width="38%" height="14"> 
                                                                    <%
																	Vector vLoc = DbLocation.list(0,0, "", "name");
																	%>
                                                                    <select name="src_location_id">
                                                                      <option value="0">-- 
                                                                      All --</option>
                                                                      <%if(vLoc!=null && vLoc.size()>0){
																	  for(int i=0; i<vLoc.size(); i++){
																	  	Location us = (Location)vLoc.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==locationId){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>
                                                                    </select>                                                                  </td>
                                                                  <td width="54%" height="14">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="8%" height="33">&nbsp;</td>
                                                                  <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                  <td width="54%" height="33">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="38%" height="15">&nbsp;                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>                                                            </td>
                                                          </tr>
                                                          
                                                          <% if(oidCustomer!=0){%>
                                                          <% Customer cus = new Customer();
                                                            try{
                                                                cus = DbCustomer.fetchExc(oidCustomer);
                                                            }catch(Exception e){
                                                                
                                                            }
                                                          
                                                          %>
                                                           
                                                                <tr align="left" valign="top"> 
                                                                 <td height="20" width="10%" valign="middle" class="comment"><b>Customer Name : <%=cus.getName()%> </b></td>
                                                                </tr>
                                                           
                                                           <%}%>
                                                          <%
							try{
								//if (listSales.size()>0){
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td class="boxed1"><%= drawList(listSales,oidSales)%></td>
                                                                </tr>
                                                              </table>                                                            </td>
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
                                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span>                                                            </td>
                                                          </tr>
                                                          <% 
                                                          double totalPayment=0;
                                                          double balance =0;
                                                          listSales= DbSales.list(0, 0, whereClause, "");
                                                            if(listSales!=null && listSales.size()>0){
                                                                for(int b=0; b<listSales.size(); b++){
                                                                    Sales sal = (Sales)listSales.get(b);
                                                                    totalPayment = DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+"=" + sal.getOID());
                                                                    balance = sal.getAmount() - totalPayment;
                                                                    totalCredit = totalCredit + sal.getAmount();
                                                                    totalPaidCus = totalPaidCus + totalPayment;
                                                                    totalBalance = totalBalance + balance ;
                                                                }
                                                            }
                                                          
                                                          %>
                                                          <tr>
                                                              <td width="50%">&nbsp;</td>
                                                              <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td width="37%" class="tablecell" align="left"><strong>&nbsp;&nbsp;&nbsp;TOTAL INVOICE</strong></td>
                                                                              
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b> </div>                                                                              </td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;TOTAL PAID</strong></td>
                                                                              
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalPaidCus, "#,###.##")%></b> </div>                                                                              </td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;BALANCE</strong></td>
                                                                              
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                <div align="right"><b><%=JSPFormater.formatNumber(totalBalance,"#,###.##")%></b> </div>                                                                              </td>
                                                                            </tr>
                                                                          </table>                                                              </td>    
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
                                                              </table>                                                            </td>
                                                          </tr>
                                                        </table>                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp;                                                      </td>
                                                    </tr>
                                                  </table>
                                                </form>                                              </td>
                                            </tr>
                                          </table>                                        </td>
                                      </tr>
                                    </table>                                  </td>
                                </tr>
                              </table>                            </td>
                          </tr>
                        </table> </td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>                </td>
              </tr>
            </table>          </td>
        </tr>
    </table>    </td>
  </tr>
</table>
</body>
 
</html>

