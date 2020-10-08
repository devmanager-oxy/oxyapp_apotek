<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.payroll.*" %>
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

	public String drawList(int iJSPCommand,JspSection frmObject, Section objEntity, Vector objectClass,  long sectionId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Section","20%");
		cmdist.addHeader("Department","20%");
		cmdist.addHeader("Description","40%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		Vector rowx = new Vector(1,1);
		cmdist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected DepartmentId*/
		Vector deps = DbDepartment.list(0,0, "", "name");
		Vector departmentid_value = new Vector(1,1);
		Vector departmentid_key = new Vector(1,1);
		if(deps!=null && deps.size()>0){
			for(int i=0; i<deps.size(); i++){
				Department d = (Department)deps.get(i);
				departmentid_value.add(""+d.getOID());
				departmentid_key.add(""+d.getName());
			}
		}

		for (int i = 0; i < objectClass.size(); i++) {
			 Section section = (Section)objectClass.get(i);
			 rowx = new Vector();
			 if(sectionId == section.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspSection.JSP_NAME] +"\" value=\""+section.getName()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspSection.JSP_DEPARTMENT_ID],null, ""+section.getDepartmentId(), departmentid_value , departmentid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspSection.JSP_DESCRIPTION] +"\" value=\""+section.getDescription()+"\" class=\"formElemen\" size=\"45\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(section.getOID())+"')\">"+section.getName()+"</a>");
				Department d = new Department();
				try{
					d = DbDepartment.fetchExc(section.getDepartmentId());
				}
				catch(Exception e){
				}
				rowx.add(d.getName());
				rowx.add(section.getDescription());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspSection.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspSection.JSP_DEPARTMENT_ID],null, ""+objEntity.getDepartmentId(), departmentid_value , departmentid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspSection.JSP_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\" size=\"45\">");

		}

		lstData.add(rowx);

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSection = JSPRequestValue.requestLong(request, "hidden_section_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "department_id";

CmdSection ctrlSection = new CmdSection(request);
JSPLine ctrLine = new JSPLine();
Vector listSection = new Vector(1,1);

/*switch statement */
iErrCode = ctrlSection.action(iJSPCommand , oidSection);
/* end switch*/
JspSection jspSection = ctrlSection.getForm();

/*count list All Section*/
int vectSize = DbSection.getCount(whereClause);

/*switch list Section*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlSection.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Section section = ctrlSection.getSection();
msgString =  ctrlSection.getMessage();

/* get record to display */
listSection = DbSection.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listSection.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listSection = DbSection.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmsection.hidden_section_id.value="0";
	document.frmsection.command.value="<%=JSPCommand.ADD%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdAsk(oidSection){
	document.frmsection.hidden_section_id.value=oidSection;
	document.frmsection.command.value="<%=JSPCommand.ASK%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdConfirmDelete(oidSection){
	document.frmsection.hidden_section_id.value=oidSection;
	document.frmsection.command.value="<%=JSPCommand.DELETE%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdSave(){
	document.frmsection.command.value="<%=JSPCommand.SAVE%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdEdit(oidSection){
	document.frmsection.hidden_section_id.value=oidSection;
	document.frmsection.command.value="<%=JSPCommand.EDIT%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdCancel(oidSection){
	document.frmsection.hidden_section_id.value=oidSection;
	document.frmsection.command.value="<%=JSPCommand.EDIT%>";
	document.frmsection.prev_command.value="<%=prevJSPCommand%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdBack(){
	document.frmsection.command.value="<%=JSPCommand.BACK%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdListFirst(){
	document.frmsection.command.value="<%=JSPCommand.FIRST%>";
	document.frmsection.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdListPrev(){
	document.frmsection.command.value="<%=JSPCommand.PREV%>";
	document.frmsection.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdListNext(){
	document.frmsection.command.value="<%=JSPCommand.NEXT%>";
	document.frmsection.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

function cmdListLast(){
	document.frmsection.command.value="<%=JSPCommand.LAST%>";
	document.frmsection.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsection.action="section.jsp";
	document.frmsection.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidSection){
	document.frmimage.hidden_section_id.value=oidSection;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="section.jsp";
	document.frmimage.submit();
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Master 
                        Maintenance </span> &raquo; <span class="level1">HRD</span> 
                        &raquo; <span class="level2">Section<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsection" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_section_id" value="<%=oidSection%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                  <%
							try{
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td class="boxed1"><%= drawList(iJSPCommand,jspSection, section,listSection,oidSection)%></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <% 
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
                                  <tr align="left" valign="top">
                                    <td height="13" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <%if(iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                  <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                  </tr>
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command"> 
                                <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidSection+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidSection+"')";
									String scancel = "javascript:cmdEdit('"+oidSection+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("Delete");
									
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
                                <%if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                <%}%>
                              </td>
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
