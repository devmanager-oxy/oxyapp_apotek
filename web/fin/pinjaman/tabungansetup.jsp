<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTabunganSetup = JSPRequestValue.requestLong(request, "hidden_tabungan_setup_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdTabunganSetup ctrlTabunganSetup = new CmdTabunganSetup(request);
JSPLine ctrLine = new JSPLine();
Vector listTabunganSetup = new Vector(1,1);

/*switch statement */
iErrCode = ctrlTabunganSetup.action(iJSPCommand , oidTabunganSetup);
/* end switch*/
JspTabunganSetup jspTabunganSetup = ctrlTabunganSetup.getForm();

/*count list All TabunganSetup*/
int vectSize = DbTabunganSetup.getCount(whereClause);

TabunganSetup tabunganSetup = ctrlTabunganSetup.getTabunganSetup();
msgString =  ctrlTabunganSetup.getMessage();

if(oidTabunganSetup==0){
	oidTabunganSetup = tabunganSetup.getOID();
}
/* get record to display */
listTabunganSetup = DbTabunganSetup.list(0,1, "" , orderClause);

if(tabunganSetup.getOID()==0 && listTabunganSetup!=null && listTabunganSetup.size()>0){
	tabunganSetup = (TabunganSetup)listTabunganSetup.get(0);
	oidTabunganSetup = tabunganSetup.getOID();
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">


function cmdAdd(){
	document.frmtabungansetup.hidden_tabungan_setup_id.value="0";
	document.frmtabungansetup.command.value="<%=JSPCommand.ADD%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}

function cmdAsk(oidTabunganSetup){
	document.frmtabungansetup.hidden_tabungan_setup_id.value=oidTabunganSetup;
	document.frmtabungansetup.command.value="<%=JSPCommand.ASK%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}

function cmdConfirmDelete(oidTabunganSetup){
	document.frmtabungansetup.hidden_tabungan_setup_id.value=oidTabunganSetup;
	document.frmtabungansetup.command.value="<%=JSPCommand.DELETE%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}
function cmdSave(){
	document.frmtabungansetup.command.value="<%=JSPCommand.SAVE%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
	}

function cmdEdit(oidTabunganSetup){
	document.frmtabungansetup.hidden_tabungan_setup_id.value=oidTabunganSetup;
	document.frmtabungansetup.command.value="<%=JSPCommand.EDIT%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
	}

function cmdCancel(oidTabunganSetup){
	document.frmtabungansetup.hidden_tabungan_setup_id.value=oidTabunganSetup;
	document.frmtabungansetup.command.value="<%=JSPCommand.EDIT%>";
	document.frmtabungansetup.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}

function cmdBack(){
	document.frmtabungansetup.command.value="<%=JSPCommand.BACK%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
	}

function cmdListFirst(){
	document.frmtabungansetup.command.value="<%=JSPCommand.FIRST%>";
	document.frmtabungansetup.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}

function cmdListPrev(){
	document.frmtabungansetup.command.value="<%=JSPCommand.PREV%>";
	document.frmtabungansetup.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
	}

function cmdListNext(){
	document.frmtabungansetup.command.value="<%=JSPCommand.NEXT%>";
	document.frmtabungansetup.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
}

function cmdListLast(){
	document.frmtabungansetup.command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansetup.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansetup.action="tabungansetup.jsp";
	document.frmtabungansetup.submit();
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
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Setup Simpanan Sukarela<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmtabungansetup" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_tabungan_setup_id" value="<%=oidTabunganSetup%>">
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="14%">&nbsp;</td>
                                          <td height="21" width="86%" class="comment" valign="top"><b>*)= 
                                            required</b></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="14%"><b>Bunga</b></td>
                                          <td height="21" width="86%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="14%">Activate</td>
                                          <td height="21" width="86%"> 
                                            <input type="checkbox" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_BUNGA_ACTIVATE] %>" value="1" <%=(tabunganSetup.getBungaActivate()==1) ? "checked" : ""%>>
                                            Ya 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Percent</td>
                                          <td height="21" width="86%"> 
                                            <input type="text" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_BUNGA_PERCENT] %>"  value="<%= tabunganSetup.getBungaPercent() %>" class="formElemen" size="10">
                                            % * <%= jspTabunganSetup.getErrorMsg(JspTabunganSetup.JSP_BUNGA_PERCENT) %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Type</td>
                                          <td height="21" width="86%"> 
                                            <% Vector bungatype_value = new Vector(1,1);
						Vector bungatype_key = new Vector(1,1);
					 	String sel_bungatype = ""+tabunganSetup.getBungaType();
						for(int i=0; i<DbTabunganSetup.strDuration.length; i++){
						   bungatype_key.add(""+i);
						   bungatype_value.add(""+DbTabunganSetup.strDuration[i]);
					    }
					   
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_BUNGA_TYPE],null, sel_bungatype, bungatype_key, bungatype_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%"><b>Biaya 
                                            Administrasi</b></td>
                                          <td height="21" width="86%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Activate</td>
                                          <td height="21" width="86%"> 
                                            <input type="checkbox" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_ADMIN_ACTIVATE] %>" value="1" <%=(tabunganSetup.getAdminActivate()==1) ? "checked" : ""%>>
                                            Ya 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Jumlah</td>
                                          <td height="21" width="86%"> 
                                            <input type="text" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_ADMIN_AMOUNT] %>"  value="<%= tabunganSetup.getAdminAmount() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Type</td>
                                          <td height="21" width="86%"> 
                                            <% Vector admintype_value = new Vector(1,1);
						Vector admintype_key = new Vector(1,1);
					 	String sel_admintype = ""+tabunganSetup.getAdminType();
						for(int i=0; i<DbTabunganSetup.strDuration.length; i++){
						   admintype_key.add(""+i);
						   admintype_value.add(""+DbTabunganSetup.strDuration[i]);
					    }
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_ADMIN_TYPE],null, sel_admintype, admintype_key, admintype_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%"><b>Service</b></td>
                                          <td height="21" width="86%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Start Hour</td>
                                          <td height="21" width="86%"> 
                                            <% Vector servicestarthour_value = new Vector(1,1);
						Vector servicestarthour_key = new Vector(1,1);
					 	String sel_servicestarthour = ""+tabunganSetup.getServiceStartHour();
						for(int i=0; i<24; i++){
						   servicestarthour_key.add(""+i);
						   servicestarthour_value.add(""+((i<10) ? "0"+i : ""+i));
						}
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_SERVICE_START_HOUR],null, sel_servicestarthour, servicestarthour_key, servicestarthour_value, "", "formElemen") %>: 
                                            <% Vector servicestartminute_value = new Vector(1,1);
						Vector servicestartminute_key = new Vector(1,1);
					 	String sel_servicestartminute = ""+tabunganSetup.getServiceStartMinute();
						for(int i=0; i<60; i++){
						   servicestartminute_key.add(""+i);
						   servicestartminute_value.add(""+((i<10) ? "0"+i : ""+i));
						}
					   
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_SERVICE_START_MINUTE],null, sel_servicestartminute, servicestartminute_key, servicestartminute_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%"><b>Pajak</b></td>
                                          <td height="21" width="86%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Activate</td>
                                          <td height="21" width="86%"> 
                                            <input type="checkbox" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_PAJAK_ACTIVATE] %>" value="1" <%=(tabunganSetup.getPajakActivate()==1) ? "checked" : ""%>>
                                            Ya 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Percent</td>
                                          <td height="21" width="86%"> 
                                            <input type="text" name="<%=jspTabunganSetup.colNames[JspTabunganSetup.JSP_PAJAK_PERCENT] %>"  value="<%= tabunganSetup.getPajakPercent() %>" class="formElemen" size="10">
                                            % 
                                        <tr align="left"> 
                                          <td height="21" width="14%"> Type</td>
                                          <td height="21" width="86%"> 
                                            <% Vector pajaktype_value = new Vector(1,1);
						Vector pajaktype_key = new Vector(1,1);
					 	String sel_pajaktype = ""+tabunganSetup.getPajakType();
						for(int i=0; i<DbTabunganSetup.strDuration.length; i++){
						   pajaktype_key.add(""+i);
						   pajaktype_value.add(""+DbTabunganSetup.strDuration[i]);
					    }
					   
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_PAJAK_TYPE],null, sel_pajaktype, pajaktype_key, pajaktype_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%"><b>Accounting</b></td>
                                          <td height="21" width="86%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="14%">Akun Hutang 
                                            Simpanan </td>
                                          <td height="21" width="86%"> 
                                            <% Vector hutangcoaid_value = new Vector(1,1);
						Vector hutangcoaid_key = new Vector(1,1);
					 	String sel_hutangcoaid = ""+tabunganSetup.getHutangCoaId();
					   
					    String wherex = "";
						if(isPostableOnly){
							wherex = "status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
						}
						Vector tempCoa = DbCoa.list(0,0, wherex, "code");
						
						if(tempCoa!=null && tempCoa.size()>0){
							for(int i=0; i<tempCoa.size(); i++){
								Coa co = (Coa)tempCoa.get(i);
								
								String str = "";
								switch(co.getLevel()){
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
								
								hutangcoaid_value.add(str+co.getCode().trim() + " - " + co.getName().trim());
								hutangcoaid_key.add(String.valueOf(co.getOID()).trim());										
							}
						}
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_HUTANG_COA_ID],null, sel_hutangcoaid, hutangcoaid_key, hutangcoaid_value, "", "formElemen") %> * <%= jspTabunganSetup.getErrorMsg(JspTabunganSetup.JSP_HUTANG_COA_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%">Akun Hutang 
                                            Pajak</td>
                                          <td height="21" width="86%"> 
                                            <% Vector pajakcoaid_value = new Vector(1,1);
						Vector pajakcoaid_key = new Vector(1,1);
					 	String sel_pajakcoaid = ""+tabunganSetup.getPajakCoaId();
					   
					   if(tempCoa!=null && tempCoa.size()>0){
							for(int i=0; i<tempCoa.size(); i++){
								Coa co = (Coa)tempCoa.get(i);
								
								String str = "";
								switch(co.getLevel()){
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
								
								pajakcoaid_value.add(str+co.getCode().trim() + " - " + co.getName().trim());
								pajakcoaid_key.add(String.valueOf(co.getOID()).trim());										
							}
						}
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_PAJAK_COA_ID],null, sel_pajakcoaid, pajakcoaid_key, pajakcoaid_value, "", "formElemen") %> * <%= jspTabunganSetup.getErrorMsg(JspTabunganSetup.JSP_PAJAK_COA_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%">Akun Pendapatan 
                                            Admin</td>
                                          <td height="21" width="86%"> 
                                            <% Vector admincoaid_value = new Vector(1,1);
						Vector admincoaid_key = new Vector(1,1);
					 	String sel_admincoaid = ""+tabunganSetup.getAdminCoaId();
						
						if(tempCoa!=null && tempCoa.size()>0){
							for(int i=0; i<tempCoa.size(); i++){
								Coa co = (Coa)tempCoa.get(i);
								
								String str = "";
								switch(co.getLevel()){
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
								
								admincoaid_value.add(str+co.getCode().trim() + " - " + co.getName().trim());
								admincoaid_key.add(String.valueOf(co.getOID()).trim());										
							}
						}
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_ADMIN_COA_ID],null, sel_admincoaid, admincoaid_key, admincoaid_value, "", "formElemen") %> * <%= jspTabunganSetup.getErrorMsg(JspTabunganSetup.JSP_ADMIN_COA_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="14%">Akun Biaya 
                                            Bunga</td>
                                          <td height="21" width="86%"> 
                                            <% Vector bungacoaid_value = new Vector(1,1);
						Vector bungacoaid_key = new Vector(1,1);
					 	String sel_bungacoaid = ""+tabunganSetup.getBungaCoaId();
						if(tempCoa!=null && tempCoa.size()>0){
							for(int i=0; i<tempCoa.size(); i++){
								Coa co = (Coa)tempCoa.get(i);
								
								String str = "";
								switch(co.getLevel()){
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
								
								bungacoaid_value.add(str+co.getCode().trim() + " - " + co.getName().trim());
								bungacoaid_key.add(String.valueOf(co.getOID()).trim());										
							}
						}
					   
					   
					   %>
                                            <%= JSPCombo.draw(jspTabunganSetup.colNames[JspTabunganSetup.JSP_BUNGA_COA_ID],null, sel_bungacoaid, bungacoaid_key, bungacoaid_value, "", "formElemen") %> * <%= jspTabunganSetup.getErrorMsg(JspTabunganSetup.JSP_BUNGA_COA_ID) %> 
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="14%">&nbsp;</td>
                                          <td height="8" width="86%" valign="top">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="2" class="command" valign="top"> 
                                            <%
											if(oidTabunganSetup==0){
												iJSPCommand = JSPCommand.ADD;
											}
											else{
												iJSPCommand = JSPCommand.EDIT;
											}
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidTabunganSetup+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidTabunganSetup+"')";
									String scancel = "javascript:cmdEdit('"+oidTabunganSetup+"')";
									ctrLine.setBackCaption("");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("");
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
                                          <td width="14%">&nbsp;</td>
                                          <td width="86%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="2" valign="top"> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                      </table>
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>
