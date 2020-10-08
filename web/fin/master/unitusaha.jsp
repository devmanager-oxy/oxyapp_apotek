
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
	
	boolean privAdd 	= true; 
	boolean privUpdate	= true; 
	boolean privDelete	= true; 
        boolean cashPriv        = true;
        boolean cashPrivView    = true; 
        boolean cashPrivUpdate  = true; 
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long unitUsahaId){
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Code","12%");
		ctrlist.addHeader("Name","12%");
		ctrlist.addHeader("Coa AR","12%");
		ctrlist.addHeader("Coa AP","12%");
		ctrlist.addHeader("Coa PPN","12%");
		ctrlist.addHeader("Coa PPH","12%");
		ctrlist.addHeader("Coa Discount","12%");
		ctrlist.addHeader("Project Location","12%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			UnitUsaha unitUsaha = (UnitUsaha)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(unitUsahaId == unitUsaha.getOID())
				 index = i;

			rowx.add(unitUsaha.getCode());

			rowx.add(unitUsaha.getName());

			Coa coa = new Coa();
			try{
				coa = DbCoa.fetchExc(unitUsaha.getCoaArId());
			}
			catch(Exception e){
			}

			rowx.add(coa.getCode()+" - "+coa.getName());

			coa = new Coa();
			try{
				coa = DbCoa.fetchExc(unitUsaha.getCoaApId());
			}
			catch(Exception e){
			}

			rowx.add(coa.getCode()+" - "+coa.getName());

			coa = new Coa();
			try{
				coa = DbCoa.fetchExc(unitUsaha.getCoaPpnId());
			}
			catch(Exception e){
			}

			rowx.add(coa.getCode()+" - "+coa.getName());

			coa = new Coa();
			try{
				coa = DbCoa.fetchExc(unitUsaha.getCoaPphId());
			}
			catch(Exception e){
			}

			rowx.add(coa.getCode()+" - "+coa.getName());

			coa = new Coa();
			try{
				coa = DbCoa.fetchExc(unitUsaha.getCoaDiscountId());
			}
			catch(Exception e){
			}

			rowx.add(coa.getCode()+" - "+coa.getName());

			Location loc = new Location();
			try{
				loc = DbLocation.fetchExc(unitUsaha.getLocationId());
			}
			catch(Exception e){
			}

			rowx.add(loc.getName());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(unitUsaha.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidUnitUsaha = JSPRequestValue.requestLong(request, "hidden_unit_usaha_id");

/*variable declaration*/
int recordToGet = 1000;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdUnitUsaha ctrlUnitUsaha = new CmdUnitUsaha(request);
JSPLine ctrLine = new JSPLine();
Vector listUnitUsaha = new Vector(1,1);

/*switch statement */
iErrCode = ctrlUnitUsaha.action(iJSPCommand , oidUnitUsaha);
/* end switch*/
JspUnitUsaha jspUnitUsaha = ctrlUnitUsaha.getForm();

/*count list All UnitUsaha*/
int vectSize = DbUnitUsaha.getCount(whereClause);

UnitUsaha unitUsaha = ctrlUnitUsaha.getUnitUsaha();
msgString =  ctrlUnitUsaha.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlUnitUsaha.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listUnitUsaha = DbUnitUsaha.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listUnitUsaha.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listUnitUsaha = DbUnitUsaha.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdAdd(){
	document.frmunitusaha.hidden_unit_usaha_id.value="0";
	document.frmunitusaha.command.value="<%=JSPCommand.ADD%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}

function cmdAsk(oidUnitUsaha){
	document.frmunitusaha.hidden_unit_usaha_id.value=oidUnitUsaha;
	document.frmunitusaha.command.value="<%=JSPCommand.ASK%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}

function cmdConfirmDelete(oidUnitUsaha){
	document.frmunitusaha.hidden_unit_usaha_id.value=oidUnitUsaha;
	document.frmunitusaha.command.value="<%=JSPCommand.DELETE%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}
function cmdSave(){
	document.frmunitusaha.command.value="<%=JSPCommand.SAVE%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
	}

function cmdEdit(oidUnitUsaha){
	document.frmunitusaha.hidden_unit_usaha_id.value=oidUnitUsaha;
	document.frmunitusaha.command.value="<%=JSPCommand.EDIT%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
	}

function cmdCancel(oidUnitUsaha){
	document.frmunitusaha.hidden_unit_usaha_id.value=oidUnitUsaha;
	document.frmunitusaha.command.value="<%=JSPCommand.EDIT%>";
	document.frmunitusaha.prev_command.value="<%=prevJSPCommand%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}

function cmdBack(){
	document.frmunitusaha.command.value="<%=JSPCommand.BACK%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
	}

function cmdListFirst(){
	document.frmunitusaha.command.value="<%=JSPCommand.FIRST%>";
	document.frmunitusaha.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}

function cmdListPrev(){
	document.frmunitusaha.command.value="<%=JSPCommand.PREV%>";
	document.frmunitusaha.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
	}

function cmdListNext(){
	document.frmunitusaha.command.value="<%=JSPCommand.NEXT%>";
	document.frmunitusaha.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
}

function cmdListLast(){
	document.frmunitusaha.command.value="<%=JSPCommand.LAST%>";
	document.frmunitusaha.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmunitusaha.action="unitusaha.jsp";
	document.frmunitusaha.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --> 
                        <%
					  String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Unit Usaha</span></font>";
					  %>
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmunitusaha" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_unit_usaha_id" value="<%=oidUnitUsaha%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp; 
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listUnitUsaha.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listUnitUsaha,oidUnitUsaha)%> </td>
                                        </tr>
                                        <%  } 
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
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()" class="command">Add 
                                            New</a></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspUnitUsaha.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="89%" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Code</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspUnitUsaha.colNames[JspUnitUsaha.JSP_CODE] %>"  value="<%= unitUsaha.getCode() %>" class="formElemen" size="25">
                                            * <%= jspUnitUsaha.getErrorMsg(JspUnitUsaha.JSP_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Unit Usaha</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspUnitUsaha.colNames[JspUnitUsaha.JSP_NAME] %>"  value="<%= unitUsaha.getName() %>" class="formElemen" size="50">
                                            * <%= jspUnitUsaha.getErrorMsg(JspUnitUsaha.JSP_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Coa AR</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% 
											
											Vector coas = DbCoa.list(0,0,"", "code");											
											
											Vector coaarid_value = new Vector(1,1);
											Vector coaarid_key = new Vector(1,1);
											String sel_coaarid = ""+unitUsaha.getCoaArId();
											coaarid_value.add("- ");
										    coaarid_key.add("0");
											
											if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													
													String str = "";
													
													switch(coa.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}

												    coaarid_key.add(""+coa.getOID());
												    coaarid_value.add(str + coa.getCode()+" - "+coa.getName());
										   		}
											}
										   %>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_COA_AR_ID],null, sel_coaarid, coaarid_key, coaarid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Coa AP</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% 
											Vector coaapid_value = new Vector(1,1);
											Vector coaapid_key = new Vector(1,1);
											String sel_coaapid = ""+unitUsaha.getCoaApId();	
											
											coaapid_value.add("- ");
											coaapid_key.add("0");
												
											if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													
													String str = "";
													
													switch(coa.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}

												    coaapid_key.add(""+coa.getOID());
												    coaapid_value.add(str + coa.getCode()+" - "+coa.getName());
										   		}
											}
												
											   
					   						%>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_COA_AP_ID],null, sel_coaapid, coaapid_key, coaapid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Coa PPN</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% 
											Vector coappnid_value = new Vector(1,1);
											Vector coappnid_key = new Vector(1,1);
											String sel_coappnid = ""+unitUsaha.getCoaPpnId();
											coappnid_value.add("- ");
											coappnid_key.add("0");
												
											if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													
													String str = "";
													
													switch(coa.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}

												    coappnid_key.add(""+coa.getOID());
												    coappnid_value.add(str + coa.getCode()+" - "+coa.getName());
										   		}
											}
										   
										   %>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_COA_PPN_ID],null, sel_coappnid, coappnid_key, coappnid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Coa PPH</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector coapphid_value = new Vector(1,1);
											Vector coapphid_key = new Vector(1,1);
											String sel_coapphid = ""+unitUsaha.getCoaPphId();
											coapphid_value.add("- ");
											coapphid_key.add("0");
												
											if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													
													String str = "";
													
													switch(coa.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}

												    coapphid_key.add(""+coa.getOID());
												    coapphid_value.add(str + coa.getCode()+" - "+coa.getName());
										   		}
											}
										  
										   %>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_COA_PPH_ID],null, sel_coapphid, coapphid_key, coapphid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Coa Discount</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector coadiscountid_value = new Vector(1,1);
											Vector coadiscountid_key = new Vector(1,1);
											String sel_coadiscountid = ""+unitUsaha.getCoaDiscountId();
										   
										   coadiscountid_value.add("- ");
											coadiscountid_key.add("0");
												
											if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													
													String str = "";
													
													switch(coa.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}

												    coadiscountid_key.add(""+coa.getOID());
												    coadiscountid_value.add(str + coa.getCode()+" - "+coa.getName());
										   		}
											}
										  
										   
										   %>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_COA_DISCOUNT_ID],null, sel_coadiscountid, coadiscountid_key, coadiscountid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Project 
                                            Location</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% 
											
											Vector loc = DbLocation.list(0,0,"", "");
											
											Vector locationid_value = new Vector(1,1);
											Vector locationid_key = new Vector(1,1);
											String sel_locationid = ""+unitUsaha.getLocationId();
											
											locationid_value.add("- ");
											locationid_key.add("0");
												
											if(loc!=null && loc.size()>0){
												for(int i=0; i<loc.size(); i++){
													Location location = (Location)loc.get(i);
												    locationid_key.add(""+location.getOID());
												    locationid_value.add(location.getName());
										   		}
											}
										
										   %>
                                            <%= JSPCombo.draw(jspUnitUsaha.colNames[JspUnitUsaha.JSP_LOCATION_ID],null, sel_locationid, locationid_key, locationid_value, "", "formElemen") %> 
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
									String scomDel = "javascript:cmdAsk('"+oidUnitUsaha+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidUnitUsaha+"')";
									String scancel = "javascript:cmdEdit('"+oidUnitUsaha+"')";
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
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>
