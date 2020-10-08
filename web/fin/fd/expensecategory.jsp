 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fdms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
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

	public String drawList(int iJSPCommand,JspExpenseCategory frmObject, ExpenseCategory objEntity, Vector objectClass,  long expenseCategoryId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("40%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		//jsplist.addHeader("Code","30%");
		jsplist.addHeader("Name","70%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		
		
		
		for (int i = 0; i < objectClass.size(); i++) {
			 ExpenseCategory expenseCategory = (ExpenseCategory)objectClass.get(i);
			 rowx = new Vector();
			 if(expenseCategoryId == expenseCategory.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"13\" name=\""+frmObject.colNames[JspExpenseCategory.JSP_CODE] +"\" value=\""+expenseCategory.getCode()+"\" class=\"formElemen\">"+"</div>");	
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"32\" name=\""+frmObject.colNames[JspExpenseCategory.JSP_NAME] +"\" value=\""+expenseCategory.getName()+"\" class=\"formElemen\">"+"</div>");
				
			 }else{
				//rowx.add(expenseCategory.getCode());
				rowx.add("<a href=\"javascript:cmdEdit('"+expenseCategory.getOID()+"')\">"+expenseCategory.getName()+"</a>");
			 } 

			 lstData.add(rowx);
		}

		rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				System.out.println("add neh");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"13\" name=\""+frmObject.colNames[JspExpenseCategory.JSP_CODE] +"\" value=\""+objEntity.getCode()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"32\" name=\""+frmObject.colNames[JspExpenseCategory.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");
				System.out.println("add neh");
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidExpenseCategory = JSPRequestValue.requestLong(request, "hidden_share_group_id");

/*variable declaration*/
int recordToGet = 1000;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "name";

CmdExpenseCategory ctrlExpenseCategory = new CmdExpenseCategory(request);
JSPLine jspLine = new JSPLine();
Vector listExpenseCategory = new Vector(1,1);

/*switch statement */
iErrCode = ctrlExpenseCategory.action(iJSPCommand , oidExpenseCategory);
/* end switch*/
JspExpenseCategory jspExpenseCategory = ctrlExpenseCategory.getForm();

/*count list All ExpenseCategory*/
int vectSize = DbExpenseCategory.getCount(whereClause);

/*switch list ExpenseCategory*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlExpenseCategory.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ExpenseCategory expenseCategory = ctrlExpenseCategory.getExpenseCategory();
msgString =  ctrlExpenseCategory.getMessage();

/* get record to display */
listExpenseCategory = DbExpenseCategory.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listExpenseCategory.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listExpenseCategory = DbExpenseCategory.list(start,recordToGet, whereClause , orderClause);
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
	document.frmsharegroup.hidden_share_group_id.value="0";
	document.frmsharegroup.command.value="<%=JSPCommand.ADD%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdAsk(oidExpenseCategory){
	document.frmsharegroup.hidden_share_group_id.value=oidExpenseCategory;
	document.frmsharegroup.command.value="<%=JSPCommand.ASK%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdConfirmDelete(oidExpenseCategory){
	document.frmsharegroup.hidden_share_group_id.value=oidExpenseCategory;
	document.frmsharegroup.command.value="<%=JSPCommand.DELETE%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdSave(){
	document.frmsharegroup.command.value="<%=JSPCommand.SAVE%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdEdit(oidExpenseCategory){
	document.frmsharegroup.hidden_share_group_id.value=oidExpenseCategory;
	document.frmsharegroup.command.value="<%=JSPCommand.EDIT%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdCancel(oidExpenseCategory){
	document.frmsharegroup.hidden_share_group_id.value=oidExpenseCategory;
	document.frmsharegroup.command.value="<%=JSPCommand.EDIT%>";
	document.frmsharegroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdBack(){
	document.frmsharegroup.command.value="<%=JSPCommand.BACK%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdListFirst(){
	document.frmsharegroup.command.value="<%=JSPCommand.FIRST%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdListPrev(){
	document.frmsharegroup.command.value="<%=JSPCommand.PREV%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdListNext(){
	document.frmsharegroup.command.value="<%=JSPCommand.NEXT%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

function cmdListLast(){
	document.frmsharegroup.command.value="<%=JSPCommand.LAST%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsharegroup.action="expensecategory.jsp";
	document.frmsharegroup.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidExpenseCategory){
	document.frmimage.hidden_share_group_id.value=oidExpenseCategory;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="expensecategory.jsp";
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
            <%@ include file = "../main/hmenu.jsp" %>
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
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Expense Category</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsharegroup" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_share_group_id" value="<%=oidExpenseCategory%>">
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
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(iJSPCommand,jspExpenseCategory, expenseCategory,listExpenseCategory,oidExpenseCategory)%> </td>
                                        </tr>
                                        <% 
						  }catch(Exception exc){ 
						  		out.println(exc.toString());
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
                                            <% jspLine.setLocationImg(approot+"/images/ctr_line");
							   	jspLine.initDefault();
								
								jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
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
									jspLine.setLocationImg(approot+"/images/ctr_line");
									jspLine.initDefault();
									jspLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidExpenseCategory+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidExpenseCategory+"')";
									String scancel = "javascript:cmdEdit('"+oidExpenseCategory+"')";
									jspLine.setBackCaption("Back to List");
									jspLine.setJSPCommandStyle("buttonlink");
									
									jspLine.setOnMouseOut("MM_swapImgRestore()");
									jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//jspLine.setOnMouseOut("MM_swapImgRestore()");
									jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									jspLine.setWidthAllJSPCommand("90");
									jspLine.setErrorStyle("warning");
									jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									jspLine.setQuestionStyle("warning");
									jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									jspLine.setInfoStyle("success");
									jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");
									

									if (privDelete){
										jspLine.setConfirmDelJSPCommand(sconDelCom);
										jspLine.setDeleteJSPCommand(scomDel);
										jspLine.setEditJSPCommand(scancel);
									}else{ 
										jspLine.setConfirmDelCaption("");
										jspLine.setDeleteCaption("");
										jspLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										jspLine.setSaveCaption("");
									}

									if (privAdd == false){
										jspLine.setAddCaption("");
									}
									%>
                                      <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
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
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

