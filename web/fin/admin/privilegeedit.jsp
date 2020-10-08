 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_ADD));
boolean privView=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_DELETE));
%>
<!-- JSP Block -->
<%!



public String drawListPrivObj(Vector objectClass)
{
	String temp = "";
	String regdatestr = "";

	JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		//ctrlist.setAreaWidth("20%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
	ctrlist.addHeader("Module","20%");
	ctrlist.addHeader("Module Group 1","20%");
	ctrlist.addHeader("Module Group 2","20%");	
	ctrlist.addHeader("authorization ","30%");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();

	Vector lstLinkData 	= ctrlist.getLinkData();					
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	for (int i = 0; i < objectClass.size(); i++) {
		try{
			 PrivilegeObj appPrivObj = (PrivilegeObj) objectClass.get(i);
	
			 Vector rowx = new Vector();
			 int a = appPrivObj.getCode();
			 if(a<0){
			 	a = a * (-1);
			 }
			 
			 /*rowx.add(ObjInfo.getTitleObject(appPrivObj.getCode()));
			 rowx.add(ObjInfo.getTitleGroup1(appPrivObj.getCode()));
			 rowx.add(ObjInfo.getTitleGroup2(appPrivObj.getCode()));
			 */
			 
			 rowx.add(ObjInfo.getTitleObject(a));
			 rowx.add(ObjInfo.getTitleGroup1(a));
			 rowx.add(ObjInfo.getTitleGroup2(a));
			 
			 
			 Vector cmdInts = appPrivObj.getCommands();
			 String cmdStr = new String("");
			 for(int ic=0;ic< cmdInts.size() ; ic++){
				cmdStr =cmdStr + ObjInfo.getStrCommand(((Integer)cmdInts.get(ic)).intValue())+", ";
			 }
			 if(cmdStr.length()>0)
				cmdStr = cmdStr.substring(0, cmdStr.length()-2);
			 
			 rowx.add(cmdStr);
			 
			 lstData.add(rowx);
			 lstLinkData.add(String.valueOf(appPrivObj.getOID()));
		 }
		 catch(Exception e){
		 	System.out.println(e.toString());	
		 }
	}						

	return ctrlist.draw();
}

%>
<%
 
/* VARIABLE DECLARATION */

int recordToGet = 5;
String order = " " + DbPrivilegeObj.colNames[DbPrivilegeObj.COL_CODE];

Vector listPrivObj = new Vector(1,1);


/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start"); 
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
if(listJSPCommand==JSPCommand.NONE)
	listJSPCommand = JSPCommand.FIRST;
long appPrivOID = JSPRequestValue.requestLong(request,"appriv_oid");
long appPrivObjOID = JSPRequestValue.requestLong(request,"apprivobj_oid");

CmdPrivilegeObj ctrlPrivObj = new CmdPrivilegeObj(request);
JspPrivilegeObj frmPrivObj = ctrlPrivObj.getForm();
String cmdIdxString[] = request.getParameterValues("cmd_assigned");

  
/* GET OBJECT */ 
Priv appPriv = DbPriv.fetch(appPrivOID);
int iErrCode = ctrlPrivObj.action(iJSPCommand, appPrivObjOID);
PrivilegeObj appPrivObj= ctrlPrivObj.getPrivObj(); 
int vectSize = DbPrivilegeObj.getCountByPrivOID_GroupByObj(appPrivOID); 

//out.println("iErrCode : "+iErrCode);


/* GET Modules Access */
int appObjG1 = JSPRequestValue.requestInt(request,JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G1_IDX]);
int appObjG2 = JSPRequestValue.requestInt(request,JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G2_IDX]);
int appObjIdx = JSPRequestValue.requestInt(request,JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]);

if(iJSPCommand == JSPCommand.EDIT){  
  appObjG1 =(ObjInfo.getIdxGroup1(appPrivObj.getCode()));
  appObjG2 =(ObjInfo.getIdxGroup2(appPrivObj.getCode()));
  appObjIdx =(ObjInfo.getIdxObject(appPrivObj.getCode())); 
   System.out.println(" IDX "+ appObjG1+ " "+ appObjG2+ " "+ appObjIdx +" " + appPrivObj.getCommands());
  appObjG1 = appObjG1<0 ? 0 : appObjG1;
  appObjG2 = appObjG2<0 ? 0 : appObjG2;
  appObjIdx = appObjIdx<0 ? 0 : appObjIdx;
}

String msgString = ctrlPrivObj.getMessage();

//out.println("msgString : "+msgString);
//out.println("iJSPCommand : "+iJSPCommand);

start=ctrlPrivObj.actionList(listJSPCommand,start,vectSize,recordToGet);
order=	DbPrivilegeObj.colNames[DbPrivilegeObj.COL_CODE];	
listPrivObj = DbPrivilegeObj.listWithCmd_ByPrivOID_GroupByObj(start,recordToGet, appPrivOID , order);

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmList.command.value="<%=JSPCommand.ADD%>"; 
	document.frmList.list_command.value="<%=JSPCommand.LIST%>";
	document.frmList.submit();	
}

function cmdEdit(oid){
	document.frmList.command.value="<%=JSPCommand.EDIT%>"; 
	document.frmList.apprivobj_oid.value=oid;
	document.frmList.list_command.value="<%=JSPCommand.LIST%>";
	document.frmList.submit();	
}

function cmdSave(){
	document.frmEdit.command.value="<%=JSPCommand.SAVE%>"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

function gotoManagementMenu(){
	document.frmList.action="<%=approot%>/management/main_man.jsp";
	document.frmList.submit();
}


<% if(privDelete) {%>
function cmdCancel(){
	document.frmEdit.command.value="<%=JSPCommand.EDIT%>"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

function cmdAsk(oid){
	document.frmEdit.command.value="<%=JSPCommand.ASK%>"; 
	document.frmEdit.apprivobj_oid.value=oid;
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

function cmdDelete(oid){
	document.frmEdit.apprivobj_oid.value=oid;
	document.frmEdit.command.value="<%=JSPCommand.DELETE%>"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

<%}%>
function changeG1(){
	document.frmEdit.command.value="<%=iJSPCommand%>"; 
	document.frmEdit.<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G2_IDX]%>.value="0"; 
	document.frmEdit.<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]%>.value="0"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

function changeG2(){
	document.frmEdit.command.value="<%=iJSPCommand%>"; 
	document.frmEdit.<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]%>.value="0"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}

function changeModule(){
	document.frmEdit.command.value="<%=iJSPCommand%>"; 
	document.frmEdit.list_command.value="<%=JSPCommand.LIST%>";
	document.frmEdit.submit();	
}


function first(){
	document.frmList.list_command.value="<%=JSPCommand.FIRST%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function prev(){
	document.frmList.list_command.value="<%=JSPCommand.PREV%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function next(){
	document.frmList.list_command.value="<%=JSPCommand.NEXT%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}
function last(){
	document.frmList.list_command.value="<%=JSPCommand.LAST%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function goPrivilege(){
	document.frmList.command.value="<%=JSPCommand.BACK%>";
	document.frmList.action="privilegelist.jsp";
	document.frmList.submit();
}

function cmdBack(){
	document.frmEdit.command.value="<%=JSPCommand.BACK%>";
	document.frmEdit.action="privilegeedit.jsp";
	document.frmEdit.submit();
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
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/new2.gif','<%=approot%>/images/ctr_line/back_f2.jpg')">
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Administrator</span> 
                        &raquo; <span class="level1">User Admin</span> &raquo; 
                        <span class="level2">Priviledge<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%">
                          <tr> 
                            <td colspan="2" valign="top" height="110"> 
                              <form name="frmList" method="post" action="privilegeedit.jsp">
                                <table width="100%">
                                  <tr> 
                                    <td width="167" nowrap>Privilege Name</td>
                                    <td width="679" nowrap>&nbsp;<%=appPriv.getPrivName()%> </td>
                                  </tr>
                                  <tr> 
                                    <td width="167">Description </td>
                                    <td width="679" nowrap>&nbsp;<%=appPriv.getDescr()%></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                  <% if(listPrivObj != null && listPrivObj.size()>0){%>
                                  <tr> 
                                    <td colspan="2"><b>Access List</b></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"> 
                                      <%//System.out.println("==>1");
						//out.println(listPrivObj);
						%>
                                      <%=drawListPrivObj(listPrivObj)%> 
                                      <%//System.out.println("==>2");%>
                                    </td>
                                  </tr>
                                  <% }else{%>
                                  <tr> 
                                    <td colspan="2" class="msgquestion">No Access 
                                      available </td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td colspan="2" class="command"> 
                                      <% JSPLine ctrLine = new JSPLine(); 
						  //out.println(listJSPCommand);
						  %>
                                      <%=ctrLine.drawMeListLimit(listJSPCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2" class="command"> 
                                      <% if(iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.DELETE || iJSPCommand == JSPCommand.BACK ||
							 iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV || iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST ){%>
                                      <table width="38%" border="0" cellspacing="1" cellpadding="2">
                                        <% if(privAdd && privUpdate){%>
                                        <tr> 
                                          <td width="21%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100111','','<%=approot%>/images/new2.gif',1)"><img name="Image100111" border="0" src="../images/new.gif" height="22" alt="Add New Privilege"></a></td>
                                          <td nowrap width="79%"><a href="javascript:cmdAdd()" class="command">Add 
                                            New Module Access</a></td>
                                          <td width="21%" colspan="2">&nbsp;</td>
                                        </tr>
                                        <% }%>
                                        <tr> 
                                          <td><a href="javascript:gotoManagementMenu()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('G1','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="G1" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Managemnt Menu"></a></td>
                                          <td nowrap><a href="javascript:gotoManagementMenu()">Back 
                                            To Management Menu</a></td>
                                          <td><a href="javascript:goPrivilege()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('G2','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="G2" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Privilege List"></a></td>
                                          <td nowrap><a href="javascript:goPrivilege()">Back 
                                            To Privilege List</a></td>
                                        </tr>
                                      </table>
                                      <%}%>
                                      <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                                      <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                                      <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                      <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G1_IDX]%>" value="<%=appObjG1%>">
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G2_IDX]%>" value="<%=appObjG2%>">
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]%>" value="<%=appObjIdx%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                    </td>
                                  </tr>
                                </table>
                              </form>
                            </td>
                          </tr>
                          <%if(((iJSPCommand==JSPCommand.SAVE)&&(iErrCode!=JSPMessage.NONE))||(iJSPCommand==JSPCommand.ADD)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                          <tr> 
                            <td colspan="2" valign="top"> 
                              <form name="frmEdit" method="post" action="">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="167">Grou<a name="go"></a>p 1 
                                      <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_PRIV_ID]%>" value="<%=appPrivOID%>">
                                      <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                                      <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                      <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                    </td>
                                    <td width="679" nowrap> 
                                      <% if (iJSPCommand==JSPCommand.ADD) {
						  
						 // out.println(ObjInfo.titleG1);
						  %>
                                      <select name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G1_IDX]%>" class="elemenForm" onChange="javascript:changeG1()">
                                        <% for(int ig1=0;ig1< ObjInfo.titleG1.length; ig1++){
                        String select = (appObjG1 == ig1) ? "selected" : "";
						  try{
                        %>
                                        <option value="<%=ig1%>" <%=select%>><%=ObjInfo.titleG1[ig1]%></option>
                                        <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G1 exc"+exc);
							  }
							
							}%>
                                      </select>
                                      <% } else { %>
                                      <%=ObjInfo.titleG1[appObjG1]%> 
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G1_IDX]%>" value="<%=appObjG1%>">
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="167">Group 2</td>
                                    <td width="679" nowrap> 
                                      <% if (iJSPCommand==JSPCommand.ADD) {
						  %>
                                      <select name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G2_IDX]%>" onChange="javascript:changeG2()">
                                        <% for(int ig2=0;ig2< ObjInfo.titleG2[appObjG1].length; ig2++){
                        String select = (appObjG2 == ig2) ? "selected" : "";
						  try{
                        %>
                                        <option value="<%=ig2%>" <%=select%>><%=ObjInfo.titleG2[appObjG1][ig2]%></option>
                                        <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G2 exc"+exc);
							  }
							
							}%>
                                      </select>
                                      <% } else { %>
                                      <%=ObjInfo.titleG2[appObjG1][appObjG2]%> 
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_G2_IDX]%>" value="<%=appObjG2%>">
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="167"> Module</td>
                                    <td width="679" nowrap> 
                                      <% if (iJSPCommand==JSPCommand.ADD) {
						  %>
                                      <select name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]%>" onChange="javascript:changeModule()">
                                        <% for(int iobj=0;iobj< ObjInfo.objectTitles[appObjG1][appObjG2].length; iobj++){
                        String select = (appObjIdx == iobj) ? "selected" : "";
						  try{
                        %>
                                        <option value="<%=iobj%>" <%=select%>><%=ObjInfo.objectTitles[appObjG1][appObjG2][iobj]%></option>
                                        <%
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. Object exc"+exc);
							  }
							 }%>
                                      </select>
                                      <% } else { %>
                                      <%=ObjInfo.objectTitles[appObjG1][appObjG2][appObjIdx]%> 
                                      <input type="hidden" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_OBJ_IDX]%>" value="<%=appObjIdx%>">
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="167">Authorization</td>
                                    <td width="679" nowrap> 
                                      <% 
						  
						  for(int id=0;id< ObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx].length; id++){
                            int iCmd= ObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx][id];
                            String checked = appPrivObj.existCommand(iCmd) ? "checked" : "";
                        %>
                                      <input type="checkbox" name="<%=JspPrivilegeObj.colNames[JspPrivilegeObj.JSP_COMMANDS]%>" value="<%=iCmd%>" <%=checked%>>
                                      <%=ObjInfo.strCommand[iCmd]%> &nbsp;&nbsp;&nbsp;&nbsp; 
                                      <% }%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="167">&nbsp;</td>
                                    <td width="679" nowrap>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"> 
                                      <%
							ctrLine.setLocationImg(approot+"/images/ctr_line");
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+appPrivObjOID+"')";
							String sconDelCom = "javascript:cmdDelete('"+appPrivObjOID+"')";
							String scancel = "javascript:cmdCancel('"+appPrivObjOID+"')";
							ctrLine.setBackCaption("Back to Module Access List");
							ctrLine.setJSPCommandStyle("buttonlink");
							ctrLine.setSaveCaption("Save Module Access");
							ctrLine.setDeleteCaption("Delete Module Access");
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
                                    <td colspan="2"> </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </form>
                            </td>
                          </tr>
                          <% } %>
                        </table>
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
