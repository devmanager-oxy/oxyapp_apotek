 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
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

	public String drawList(int iJSPCommand,JspItemGroup frmObject, ItemGroup objEntity, Vector objectClass,  long itemGroupId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("90%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("Type","20%");
		jsplist.addHeader("Code","10%");
		jsplist.addHeader("Name","25%");
		jsplist.addHeader("Sales Account","10%");
		jsplist.addHeader("COGS Account","10%");
		jsplist.addHeader("Inv. Account","10%");
		jsplist.addHeader("Image","15%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		
		
		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		
		status_value.add(""+I_Ccs.TYPE_CATEGORY_ASSET);
		status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_ASSET]);
		

		for (int i = 0; i < objectClass.size(); i++) {
			 ItemGroup itemGroup = (ItemGroup)objectClass.get(i);
			 rowx = new Vector();
			 if(itemGroupId == itemGroup.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+itemGroup.getType(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_TYPE));
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_CODE] +"\" value=\""+itemGroup.getCode()+"\" class=\"formElemen\">"+"</div>");	
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"32\" name=\""+frmObject.colNames[JspItemGroup.JSP_NAME] +"\" value=\""+itemGroup.getName()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES] +"\" value=\""+itemGroup.getAccountSales()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COGS] +"\" value=\""+itemGroup.getAccountCogs()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_INV] +"\" value=\""+itemGroup.getAccountInv()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"15\" name=\""+frmObject.colNames[JspItemGroup.JSP_IMAGE_NAME] +"\" value=\""+itemGroup.getImageName()+"\" class=\"formElemen\">"+"</div>");
				
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(itemGroup.getOID())+"')\">"+I_Ccs.strCategoryType[itemGroup.getType()]+"</a>");
				rowx.add(itemGroup.getCode());
				rowx.add(itemGroup.getName());
				rowx.add(itemGroup.getAccountSales());
				rowx.add(itemGroup.getAccountCogs());
				rowx.add(itemGroup.getAccountInv());
				rowx.add(itemGroup.getImageName());

			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE],null, ""+objEntity.getType(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_TYPE));
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_CODE] +"\" value=\""+objEntity.getCode()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"32\" name=\""+frmObject.colNames[JspItemGroup.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES] +"\" value=\""+objEntity.getAccountSales()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COGS] +"\" value=\""+((objEntity.getAccountCogs()==null) ? "" : objEntity.getAccountCogs())+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"13\" name=\""+frmObject.colNames[JspItemGroup.JSP_ACCOUNT_INV] +"\" value=\""+objEntity.getAccountInv()+"\" class=\"formElemen\">"+"</div>");
				rowx.add("<div align=\"center\">"+"<input type=\"text\"  size=\"15\" name=\""+frmObject.colNames[JspItemGroup.JSP_IMAGE_NAME] +"\" value=\""+objEntity.getImageName()+"\" class=\"formElemen\">"+"</div>");

		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidItemGroup = JSPRequestValue.requestLong(request, "hidden_item_group_id");

/*variable declaration*/
int recordToGet = 1000;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "code";


//whereClause = "type="+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+" or type="+I_Ccs.TYPE_CATEGORY_CIVIL_WORK+" or type="+I_Ccs.TYPE_CATEGORY_ASSET;
whereClause = "type="+I_Ccs.TYPE_CATEGORY_ASSET;

CmdItemGroup ctrlItemGroup = new CmdItemGroup(request);
JSPLine jspLine = new JSPLine();
Vector listItemGroup = new Vector(1,1);

/*switch statement */
iErrCode = ctrlItemGroup.action(iJSPCommand , oidItemGroup);
/* end switch*/
JspItemGroup jspItemGroup = ctrlItemGroup.getForm();

/*count list All ItemGroup*/
int vectSize = DbItemGroup.getCount(whereClause);

/*switch list ItemGroup*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlItemGroup.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ItemGroup itemGroup = ctrlItemGroup.getItemGroup();
msgString =  ctrlItemGroup.getMessage();

/* get record to display */
listItemGroup = DbItemGroup.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listItemGroup.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listItemGroup = DbItemGroup.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">


function cmdAdd(){
	document.frmitemgroup.hidden_item_group_id.value="0";
	document.frmitemgroup.command.value="<%=JSPCommand.ADD%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdAsk(oidItemGroup){
	document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
	document.frmitemgroup.command.value="<%=JSPCommand.ASK%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdConfirmDelete(oidItemGroup){
	document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
	document.frmitemgroup.command.value="<%=JSPCommand.DELETE%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdSave(){
	document.frmitemgroup.command.value="<%=JSPCommand.SAVE%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdEdit(oidItemGroup){
	document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
	document.frmitemgroup.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdCancel(oidItemGroup){
	document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
	document.frmitemgroup.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdBack(){
	document.frmitemgroup.command.value="<%=JSPCommand.BACK%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdListFirst(){
	document.frmitemgroup.command.value="<%=JSPCommand.FIRST%>";
	document.frmitemgroup.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdListPrev(){
	document.frmitemgroup.command.value="<%=JSPCommand.PREV%>";
	document.frmitemgroup.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdListNext(){
	document.frmitemgroup.command.value="<%=JSPCommand.NEXT%>";
	document.frmitemgroup.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

function cmdListLast(){
	document.frmitemgroup.command.value="<%=JSPCommand.LAST%>";
	document.frmitemgroup.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmitemgroup.action="assetgroup.jsp";
	document.frmitemgroup.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidItemGroup){
	document.frmimage.hidden_item_group_id.value=oidItemGroup;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="assetgroup.jsp";
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
            <%@ include file = "../main/hmenu.jsp" %>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmitemgroup" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_item_group_id" value="<%=oidItemGroup%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                      Maintenance </font><font class="tit1">&raquo; 
                                      </font><span class="lvl2">Asset Category</span></b></td>
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
                                            <%= drawList(iJSPCommand,jspItemGroup, itemGroup,listItemGroup,oidItemGroup)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidItemGroup+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidItemGroup+"')";
									String scancel = "javascript:cmdEdit('"+oidItemGroup+"')";
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
                        </span><!-- #EndEditable -->
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
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
