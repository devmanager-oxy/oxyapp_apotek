 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
        boolean privAdd=true; boolean privUpdate=true;
        boolean privDelete=true; boolean masterPriv = true;
	boolean masterPrivView = true; boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass ,  long cashCashierId){
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("Opening Date","10%");
		ctrlist.addHeader("Closing Date","10%");
                ctrlist.addHeader("Location","25%");
		ctrlist.addHeader("Cashier Number","10%");
		ctrlist.addHeader("Shift","10%");
		ctrlist.addHeader("Total Opening","15%");
		ctrlist.addHeader("Total Closing","15%");
		ctrlist.addHeader("Status","5%");

		ctrlist.setLinkRow(-1);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		
		ctrlist.setLinkPrefix("javascript:targetPage('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
                    
			CashCashier cashCashier = (CashCashier)objectClass.get(i);
			
			Vector rowx = new Vector();
			if(cashCashierId == cashCashier.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = cashCashier.getDateOpen();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);
                        rowx.add(JSPFormater.formatDate(cashCashier.getDateClosing(), "dd/MM/yy"));
			
                        Shift shift = new Shift();
                        try{
                            shift = DbShift.fetchExc(cashCashier.getShiftId());
                        }catch(Exception e){}
                        
                        CashMaster cashMaster = new CashMaster();
                        try{
                            cashMaster = DbCashMaster.fetchExc(cashCashier.getCashMasterId());
                        }catch(Exception e){}
                        
                        Location loc = new Location();
                        try{
                            loc = DbLocation.fetchExc(cashMaster.getLocationId());
                        }catch(Exception e){}
                        
                        rowx.add(loc.getName());
                        
                        Currency curr = new Currency();
                        try{
                            curr = DbCurrency.fetchExc(cashCashier.getCurrencyIdOpen());
                        }catch(Exception e){}
			
			rowx.add(cashMaster.getCashierNumber() + "");			
			rowx.add(shift.getName());
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(cashCashier.getAmountOpen(),"#,###")+"</div>");
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber((cashCashier.getAmountClosing()),"#,###")+"</div>");
			rowx.add("<div align=\"center\">"+((cashCashier.getStatus()==0) ? "Open" : "Closed")+"</div>");
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(cashCashier.getOID()));
		}
		return ctrlist.draw(index);
	}

%>
<%
int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
int stype = JSPRequestValue.requestInt(request, "sales_type");
long cashMasterId =JSPRequestValue.requestLong(request, "JSP_CASH_MASTER_ID");
long location_id =JSPRequestValue.requestLong(request, "JSP_LOCATION_ID");
long currency_id = JSPRequestValue.requestLong(request, JspCashCashier.colNames[JspCashCashier.JSP_CURRENCY_ID_CLOSING]);
long cashCashierId = JSPRequestValue.requestLong(request, JspCashCashier.colNames[JspCashCashier.JSP_CASH_CASHIER_ID] );

CashCashier cashCashier = new CashCashier();
CashMaster cashMaster = new CashMaster();
Shift shift = new Shift();
Currency curr = new Currency();
if(currency_id!=0){
    try{
        curr= DbCurrency.fetchExc(currency_id);
    }catch(Exception e){}
}
if(cashCashierId !=0){
    try{
        cashCashier= DbCashCashier.fetchExc(cashCashierId);
        shift = DbShift.fetchExc(cashCashier.getShiftId());
    }catch(Exception e){}
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;

String whereClause = "";
String orderClause = "";
CmdCashCashier ctrlCashCashier = new CmdCashCashier(request);
JSPLine ctrLine = new JSPLine();
Vector listCashier = new Vector(1,1);
Vector listCashier2 = new Vector(1,1);
/*switch statement */
listCashier2 = DbCashCashier.list(0, 10, "cash_master_id=" + cashMasterId + " and status=" + DbCashCashier.status_closing, "");
boolean stillOpen = false;

if(listCashier2.size()>0){
    stillOpen=true;
}

iErrCode = ctrlCashCashier.action(iJSPCommand , cashCashierId, user, stillOpen);
/* end switch*/
JspCashCashier jspCashCashier = ctrlCashCashier.getForm();
int vectSize = DbCashCashier.getCount("status=" + DbCashCashier.status_closing);
msgString =  ctrlCashCashier.getMessage();

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCashCashier.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

listCashier = DbCashCashier.list(start,recordToGet, " status=" + DbCashCashier.status_closing , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCashier.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCashier = DbCashCashier.list(start,recordToGet, whereClause , orderClause);
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Oxy-Sales</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

    <%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
    <%}%>

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
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}
function cmdRate(){
        document.frmsales.command.value="<%=JSPCommand.LOAD%>";
        document.frmsales.action="closing.jsp";
        document.frmsales.submit();
}
function cmdLocation(){
        document.frmsales.command.value="<%=JSPCommand.LOAD%>";
        document.frmsales.action="closing.jsp";
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
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}
function cmdSave(){
	document.frmsales.command.value="<%=JSPCommand.SAVE%>";
	document.frmsales.prev_command.value="<%=prevJSPCommand%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdEdit(oidSales, oidProposal){
	document.frmsales.hidden_proposal_id.value=oidProposal;
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
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdBack(){
	document.frmsales.command.value="<%=JSPCommand.BACK%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListFirst(){
	document.frmsales.command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListPrev(){
	document.frmsales.command.value="<%=JSPCommand.PREV%>";
	document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListNext(){
	document.frmsales.command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListLast(){
	document.frmsales.command.value="<%=JSPCommand.LAST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsales.action="closing.jsp?menu_idx=<%=menuIdx%>";
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
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
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
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
                                                              <span class="lvl2">Sales 
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
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="2" height="14">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="8%" height="14">Cashier Location  </td>
                                                                  <td width="38%" height="14"> 
                                                                    <%
																	Vector Vcashier = DbCashCashier.list(0,0, "status=" + DbCashCashier.status_opening, "");
																	%>
                                                                    <select name="<%=JspCashCashier.colNames[JspCashCashier.JSP_CASH_CASHIER_ID]%>" onChange="javascript:cmdLocation()">
                                                                      
                                                                      <%if(Vcashier!=null && Vcashier.size()>0){
																	  for(int i=0; i<Vcashier.size(); i++){
																	  	 CashCashier cs = (CashCashier)Vcashier.get(i);
                                                                                                                                                 CashMaster cm = new CashMaster();
                                                                                                                                                 Location loc = new Location();
                                                                                                                                                 try{
                                                                                                                                                     cm = DbCashMaster.fetchExc(cs.getCashMasterId());
                                                                                                                                                     loc = DbLocation.fetchExc(cm.getLocationId());
                                                                                                                                                     if(cashCashierId==0){
                                                                                                                                                         try{
                                                                                                                                                             shift = DbShift.fetchExc(cs.getShiftId());
                                                                                                                                                             cashCashierId= cs.getOID();
                                                                                                                                                         }catch(Exception e){
                                                                                                                                                             
                                                                                                                                                         }
                                                                                                                                                     }
                                                                                                                                                 }catch(Exception e){
                                                                                                                                                     
                                                                                                                                                 }
                                                                                                                                                 
																	  %>
                                                                      <option value="<%=cs.getOID()%>" <%if(cs.getOID()==cashCashierId){%>selected<%}%>><%=loc.getName() + " " + cm.getCashierNumber()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="54%" height="14">&nbsp;</td>
                                                                  
                                                                </tr>
                                                                                                                             
                                                                
                                                                <tr>
                                                                  <td width="8%" height="14">
                                                                   Shift   </td>
                                                                  <td width="38%" height="14"> 
                                                                    <%= shift.getName()%>
                                                                  </td>
                                                                  <td width="54%" height="14">&nbsp;</td>
                                                                </tr>
                                                                 
                                                                <tr>
                                                                  <td width="8%" height="14">Currency </td>
                                                                  <td width="38%" height="14"> 
                                                                    <%
																	Vector Vcurr = DbCurrency.list(0,0, "", "");
																	%>
                                                                    <select name="<%=JspCashCashier.colNames[JspCashCashier.JSP_CURRENCY_ID_CLOSING]%>" onChange="javascript:cmdRate()">
                                                                     
                                                                      <%if(Vcurr!=null && Vcurr.size()>0){
																	  for(int i=0; i<Vcurr.size(); i++){
																	  	Currency us = (Currency)Vcurr.get(i);
                                                                                                                                                if(currency_id==0){
                                                                                                                                                    curr = (Currency)Vcurr.get(i);
                                                                                                                                                    currency_id = curr.getOID();
                                                                                                                                                            
                                                                                                                                                }
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==currency_id){%>selected<%}%>><%=us.getCurrencyCode()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="54%" height="14">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="8%" height="15">Rate</td>
                                                                  <td width="38%" height="15">
                                                                      <input type="text" class="readOnly" name="<%=JspCashCashier.colNames[JspCashCashier.JSP_RATE_CLOSING]%>" value="<%=curr.getRate()%>" size="15" readOnly>
                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="8%" height="15">Amount</td>
                                                                  <td width="38%" height="15">
                                                                      <input type="text" name="<%=JspCashCashier.colNames[JspCashCashier.JSP_AMOUNT_CLOSING]%>" value="0" size="15">
                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="38%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <% if(Vcashier.size()>0){%>
                                                                <tr> 
                                                                  <td width="8%" height="33"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a></td>
                                                                  <td width="38%" height="33"></td>
                                                                  <td width="54%" height="33">&nbsp;</td>
                                                                </tr>
                                                                <%}%>
                                                                
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="20" valign="middle" colspan="3" class="comment">&nbsp;<b>Opening 
                                                              List</b></td>
                                                          </tr>
                                                          <%
							try{
								//if (listSales.size()>0){
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td class="boxed1"><%= drawList(listCashier,cashCashierId)%></td>
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

