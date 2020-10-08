 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fdms.master.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
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

	public Vector drawList(int iJSPCommand,JspShareAllocation frmObject, ShareAllocation objEntity, Vector objectClass,  long shareAllocationId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("60%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		//jsplist.addHeader("Group","20%");
		jsplist.addHeader("Department","20%");
		jsplist.addHeader("Allocation %","25%");
		//jsplist.addHeader("Type","10%");
		//jsplist.addHeader("Account Code","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";
		
		/* selected ItemGroupId*/
		Vector iDep = DbDepartment.list(0,0, "", "name");
		Vector sharegroupid_value = new Vector(1,1);
		Vector sharegroupid_key = new Vector(1,1);
		if(iDep!=null && iDep.size()>0){
			for(int i=0; i<iDep.size(); i++){
				Department ig = (Department)iDep.get(i);
				sharegroupid_key.add(""+ig.getName());
				sharegroupid_value.add(""+ig.getOID());
			}
		}

		Vector temp = new Vector();
		double totalPercent = 0;
		

		for (int i = 0; i < objectClass.size(); i++) {
			 ShareAllocation shareAllocation = (ShareAllocation)objectClass.get(i);
			 rowx = new Vector();
			 if(shareAllocationId == shareAllocation.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspShareAllocation.JSP_DEPARTMENT_ID],null, ""+shareAllocation.getDepartmentId(), sharegroupid_value , sharegroupid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspShareAllocation.JSP_ALL_SHARE] +"\" value=\""+shareAllocation.getAllShare()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"45\" name=\""+frmObject.colNames[JspShareAllocation.JSP_NAME] +"\" value=\""+shareAllocation.getName()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspShareAllocation.JSP_GROUP_TYPE],null, ""+shareAllocation.getGroupType(), type_value , type_key, "formElemen", "")+"</div>");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" name=\""+frmObject.colNames[JspShareAllocation.JSP_ACCOUNT_CODE] +"\" value=\""+shareAllocation.getAccountCode()+"\" class=\"formElemen\">"+"</div>");
			}else{
				
				Department igg = new Department();
				try{
					igg = DbDepartment.fetchExc(shareAllocation.getDepartmentId());
				}
				catch(Exception e){
				}
				
				
				totalPercent = totalPercent + Double.parseDouble(JSPFormater.formatNumber(shareAllocation.getAllShare(), "###.##"));
			
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(shareAllocation.getOID())+"')\">"+igg.getName()+"</a>");
				rowx.add(""+shareAllocation.getAllShare());
				//rowx.add(shareAllocation.getName());
				//rowx.add("<div align=\"center\">"+((shareAllocation.getGroupType()==0) ? "-" : ((shareAllocation.getGroupType()==1) ? "Group Share" : "Share All"))+"</div>");
				//rowx.add(shareAllocation.getAccountCode());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspShareAllocation.JSP_DEPARTMENT_ID],null, ""+objEntity.getDepartmentId(), sharegroupid_value , sharegroupid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspShareAllocation.JSP_ALL_SHARE] +"\" value=\""+objEntity.getAllShare()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"45\" name=\""+frmObject.colNames[JspShareAllocation.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspShareAllocation.JSP_GROUP_TYPE],null, ""+objEntity.getGroupType(), type_value , type_key, "formElemen", "")+"</div>");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" name=\""+frmObject.colNames[JspShareAllocation.JSP_ACCOUNT_CODE] +"\" value=\""+objEntity.getAccountCode()+"\" class=\"formElemen\">"+"</div>");

		}

		lstData.add(rowx);

		//return jsplist.draw(index);
		
		temp.add(jsplist.draw(index));
		temp.add(""+totalPercent);
		
		return temp;
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidShareAllocation = JSPRequestValue.requestLong(request, "hidden_share_allocation_id");
long oidShareCategory = JSPRequestValue.requestLong(request, JspShareCategory.colNames[JspShareCategory.JSP_SHARE_CATEGORY_ID]);

Vector allocCats = DbShareCategory.list(0,0,"","code");
if(oidShareCategory==0 && allocCats!=null && allocCats.size()>0){
	ShareCategory sc = (ShareCategory)allocCats.get(0);
	oidShareCategory = sc.getOID();
}

//out.println(allocCats);

/*variable declaration*/
int recordToGet = 1000;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "share_category_id="+oidShareCategory;
String orderClause = "";//DbShareAllocation.colNames[DbShareAllocation.COL_SHARE_GROUP_ID];

CmdShareAllocation ctrlShareAllocation = new CmdShareAllocation(request);
JSPLine ctrLine = new JSPLine();
Vector listShareAllocation = new Vector(1,1);

/*switch statement */
iErrCode = ctrlShareAllocation.action(iJSPCommand , oidShareAllocation);
/* end switch*/
JspShareAllocation jspShareAllocation = ctrlShareAllocation.getForm();

/*count list All ShareAllocation*/
int vectSize = DbShareAllocation.getCount(whereClause);

/*switch list ShareAllocation*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlShareAllocation.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ShareAllocation shareAllocation = ctrlShareAllocation.getShareAllocation();
msgString =  ctrlShareAllocation.getMessage();

/* get record to display */
listShareAllocation = DbShareAllocation.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listShareAllocation.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listShareAllocation = DbShareAllocation.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
function cmdAdd(){
	document.frmsharecategory.hidden_share_allocation_id.value="0";
	document.frmsharecategory.command.value="<%=JSPCommand.ADD%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdAsk(oidShareAllocation){
	document.frmsharecategory.hidden_share_allocation_id.value=oidShareAllocation;
	document.frmsharecategory.command.value="<%=JSPCommand.ASK%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdConfirmDelete(oidShareAllocation){
	document.frmsharecategory.hidden_share_allocation_id.value=oidShareAllocation;
	document.frmsharecategory.command.value="<%=JSPCommand.DELETE%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdSave(){
	document.frmsharecategory.command.value="<%=JSPCommand.SAVE%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdEdit(oidShareAllocation){
	document.frmsharecategory.hidden_share_allocation_id.value=oidShareAllocation;
	document.frmsharecategory.command.value="<%=JSPCommand.EDIT%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdCancel(oidShareAllocation){
	document.frmsharecategory.hidden_share_allocation_id.value=oidShareAllocation;
	document.frmsharecategory.command.value="<%=JSPCommand.EDIT%>";
	document.frmsharecategory.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdChange(){
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdBack(){
	document.frmsharecategory.command.value="<%=JSPCommand.BACK%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdListFirst(){
	document.frmsharecategory.command.value="<%=JSPCommand.FIRST%>";
	document.frmsharecategory.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdListPrev(){
	document.frmsharecategory.command.value="<%=JSPCommand.PREV%>";
	document.frmsharecategory.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdListNext(){
	document.frmsharecategory.command.value="<%=JSPCommand.NEXT%>";
	document.frmsharecategory.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

function cmdListLast(){
	document.frmsharecategory.command.value="<%=JSPCommand.LAST%>";
	document.frmsharecategory.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsharecategory.action="sharealloc.jsp";
	document.frmsharecategory.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidShareAllocation){
	document.frmimage.hidden_share_allocation_id.value=oidShareAllocation;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="sharealloc.jsp";
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
                      <td class="title"><!-- #BeginEditable "title" --><%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Share Allocation</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsharecategory" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_share_allocation_id" value="<%=oidShareAllocation%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="5" valign="middle" colspan="3"> 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                          <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">
                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="20%">Allocation Category</td>
                                                <td width="80%"> 
                                                  <select name="<%=JspShareCategory.colNames[JspShareCategory.JSP_SHARE_CATEGORY_ID]%>" onChange="javascript:cmdChange()">
												  	<%if(allocCats!=null && allocCats.size()>0){
													for(int i=0; i<allocCats.size(); i++){
														ShareCategory sc = (ShareCategory)allocCats.get(i);
													%>
                                                    <option value="<%=sc.getOID()%>" <%if(sc.getOID()==oidShareCategory){%>selected<%}%>><%=sc.getName()%></option>
													<%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr>
                                                <td width="20%">&nbsp;</td>
                                                <td width="80%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <% Vector xTemp = drawList(iJSPCommand,jspShareAllocation, shareAllocation,listShareAllocation,oidShareAllocation);%> 
											<%=(String)xTemp.get(0)%>
											</td>
                                        </tr>
										<tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><b><font color="#FF0000">TOTAL 
                                            PERCENTAGE = <%=JSPFormater.formatNumber(Double.parseDouble((String)xTemp.get(1)), "###.##")%></font></b> 
                                        </tr>
										<tr align="left" valign="top"> 
                                          <td height="3" valign="middle" colspan="3"></td>
                                        </tr>
										
                                        <% 
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
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                  </tr>
                                  <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE && iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                  <tr align="left" valign="top" > 
                                    <td colspan="3" class="command"> 
                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidShareAllocation+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidShareAllocation+"')";
									String scancel = "javascript:cmdEdit('"+oidShareAllocation+"')";
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
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable --> </td>
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

