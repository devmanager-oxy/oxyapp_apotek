 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
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

	public String drawList(Vector objectClass ,  long salesmanId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("Code","10%");
		ctrlist.addHeader("Name","25%");
		ctrlist.addHeader("Address","25%");
		ctrlist.addHeader("City","10%");
		ctrlist.addHeader("Telp","10%");
		ctrlist.addHeader("Country","20%");
		//ctrlist.addHeader("Awal","9%");
		//ctrlist.addHeader("Keluar","9%");
		//ctrlist.addHeader("Masuk","9%");
		//ctrlist.addHeader("Komisi","9%");
		//ctrlist.addHeader("Kdwil","9%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Salesman salesman = (Salesman)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(salesmanId == salesman.getOID())
				 index = i;

			rowx.add(salesman.getKdsales());

			rowx.add(salesman.getNmsales());

			rowx.add(salesman.getAlamat());

			rowx.add(salesman.getKota());

			rowx.add(salesman.getTelp());

			rowx.add(salesman.getNegara());

			//rowx.add(String.valueOf(salesman.getAwal()));

			//rowx.add(String.valueOf(salesman.getKeluar()));

			//rowx.add(String.valueOf(salesman.getMasuk()));

			//rowx.add(String.valueOf(salesman.getKomisi()));

			//rowx.add(salesman.getKdwil());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(salesman.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSalesman = JSPRequestValue.requestLong(request, "hidden_salesman_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdSalesman ctrlSalesman = new CmdSalesman(request);
JSPLine ctrLine = new JSPLine();
Vector listSalesman = new Vector(1,1);

/*switch statement */
iErrCode = ctrlSalesman.action(iJSPCommand , oidSalesman);
/* end switch*/
JspSalesman jspSalesman = ctrlSalesman.getForm();

/*count list All Salesman*/
int vectSize = DbSalesman.getCount(whereClause);

Salesman salesman = ctrlSalesman.getSalesman();
msgString =  ctrlSalesman.getMessage();

/*switch list Salesman*/
if(oidSalesman==0){
	oidSalesman = salesman.getOID();
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlSalesman.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listSalesman = DbSalesman.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listSalesman.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listSalesman = DbSalesman.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">


function cmdAdd(){
	document.frmsalesman.hidden_salesman_id.value="0";
	document.frmsalesman.command.value="<%=JSPCommand.ADD%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}

function cmdAsk(oidSalesman){
	document.frmsalesman.hidden_salesman_id.value=oidSalesman;
	document.frmsalesman.command.value="<%=JSPCommand.ASK%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}

function cmdConfirmDelete(oidSalesman){
	document.frmsalesman.hidden_salesman_id.value=oidSalesman;
	document.frmsalesman.command.value="<%=JSPCommand.DELETE%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}
function cmdSave(){
	document.frmsalesman.command.value="<%=JSPCommand.SAVE%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
	}

function cmdEdit(oidSalesman){
	document.frmsalesman.hidden_salesman_id.value=oidSalesman;
	document.frmsalesman.command.value="<%=JSPCommand.EDIT%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
	}

function cmdCancel(oidSalesman){
	document.frmsalesman.hidden_salesman_id.value=oidSalesman;
	document.frmsalesman.command.value="<%=JSPCommand.EDIT%>";
	document.frmsalesman.prev_command.value="<%=prevJSPCommand%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}

function cmdBack(){
	document.frmsalesman.command.value="<%=JSPCommand.BACK%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
	}

function cmdListFirst(){
	document.frmsalesman.command.value="<%=JSPCommand.FIRST%>";
	document.frmsalesman.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}

function cmdListPrev(){
	document.frmsalesman.command.value="<%=JSPCommand.PREV%>";
	document.frmsalesman.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
	}

function cmdListNext(){
	document.frmsalesman.command.value="<%=JSPCommand.NEXT%>";
	document.frmsalesman.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
}

function cmdListLast(){
	document.frmsalesman.command.value="<%=JSPCommand.LAST%>";
	document.frmsalesman.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsalesman.action="salesman.jsp";
	document.frmsalesman.submit();
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsalesman" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_salesman_id" value="<%=oidSalesman%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                              <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                  Maintenance </font><font class="tit1">&raquo; 
                                                  </font><font class="tit1"><span class="lvl2">POS</span> 
                                                  &raquo;</font> <span class="lvl2">Guide 
                                                  List</span></b></td>
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
                                          <td height="5" valign="middle" colspan="3" class="comment"></td>
                                        </tr>
                                        <%
							try{
								if (listSalesman.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listSalesman,oidSalesman)%> </td>
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
                                        <tr align="left" valign="top">
                                          <td height="5" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspSalesman.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                                          <td height="21" colspan="2" width="91%" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Code</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_KDSALES] %>"  value="<%= salesman.getKdsales() %>" class="formElemen" size="20">
                                            * <%= jspSalesman.getErrorMsg(JspSalesman.JSP_KDSALES) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Name</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_NMSALES] %>"  value="<%= salesman.getNmsales() %>" class="formElemen" size="40">
                                            * <%= jspSalesman.getErrorMsg(JspSalesman.JSP_NMSALES) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Addres</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_ALAMAT] %>"  value="<%= salesman.getAlamat() %>" class="formElemen" size="40">
                                            * <%= jspSalesman.getErrorMsg(JspSalesman.JSP_ALAMAT) %> 
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;City</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_KOTA] %>"  value="<%= salesman.getKota() %>" class="formElemen" size="40">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Telp</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_TELP] %>"  value="<%= salesman.getTelp() %>" class="formElemen" size="20">
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;Country</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <% Vector negara_value = new Vector(1,1);
						Vector negara_key = new Vector(1,1);
						Vector countries = DbCountry.list(0,0,"", "");
					 	String sel_negara = ""+salesman.getNegara();
						if(countries!=null && countries.size()>0){
							for(int i=0; i<countries.size(); i++){
								Country c = (Country)countries.get(i);
							   negara_key.add(c.getName());
							   negara_value.add(c.getName());
					   		}
					    }
					   %>
                                            <%= JSPCombo.draw(jspSalesman.colNames[jspSalesman.JSP_NEGARA],null, sel_negara, negara_key, negara_value, "", "formElemen") %> 
                                            <!--tr align="left"> 
                                          <td height="21" width="17%">&nbsp;Start</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_AWAL] %>"  value="<%= salesman.getAwal() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="17%">&nbsp;In</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_MASUK] %>"  value="<%= salesman.getMasuk() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="17%">&nbsp;Out</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_KELUAR] %>"  value="<%= salesman.getKeluar() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="17%">&nbsp;Commission</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_KOMISI] %>"  value="<%= salesman.getKomisi() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="17%">&nbsp;Area Code</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspSalesman.colNames[JspSalesman.JSP_KDWIL] %>"  value="<%= salesman.getKdwil() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="17%">&nbsp;</td>
                                          <td height="8" colspan="2" width="83%" valign="top">&nbsp; 
                                          </td>
                                  </tr-->
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidSalesman+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidSalesman+"')";
									String scancel = "javascript:cmdEdit('"+oidSalesman+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

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
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr> 
                                          <td width="9%">&nbsp;</td>
                                          <td width="91%">&nbsp;</td>
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
