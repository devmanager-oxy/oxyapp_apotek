 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
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

	public String drawList(int iJSPCommand,JspCountry frmObject, Country objEntity, Vector objectClass,  long countryId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Country ","30%");
		cmdist.addHeader("Nationality","30%");
		cmdist.addHeader("Continent","20%");
		cmdist.addHeader("Hub","20%");
		//cmdist.addHeader("Description","20%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		Vector rowx = new Vector(1,1);
		cmdist.reset();
		int index = -1;
		
		Vector co = new Vector(1,1);		
		
		CONResultSet crs = null;
		try{
			crs = CONHandler.execQueryResult("select continent from continent order by continent");
			ResultSet rs = crs.getResultSet();
			while(rs.next()){
				co.add(rs.getString(1));
			}
		}
		catch(Exception ex){
		}
		finally{
			CONResultSet.close(crs);
		}
		
		Vector continent_value = new Vector(1,1);
		Vector continent_key = new Vector(1,1);
		for(int x=0; x<co.size(); x++){
			continent_value.add((String)co.get(x));
			continent_key.add((String)co.get(x));
		}

		for (int i = 0; i < objectClass.size(); i++) {
			 Country country = (Country )objectClass.get(i);
			 rowx = new Vector();
			 if(countryId == country.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_NAME] +"\" value=\""+country.getName()+"\" class=\"formElemen\" size=\"20\">");	
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_NATIONALITY] +"\" value=\""+country.getNationality ()+"\" class=\"formElemen\" size=\"20\">");				
				//rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_CONTINENT] +"\" value=\""+country.getContinent()+"\" class=\"formElemen\" size=\"15\">");
				rowx.add(JSPCombo.draw(frmObject.fieldNames[frmObject.JSP_CONTINENT],null, ""+country.getContinent(), continent_value , continent_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_HUB] +"\" value=\""+country.getHub()+"\" class=\"formElemen\" size=\"20\">");
				//rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_DESCRIPTION] +"\" value=\""+country.getDescription()+"\" class=\"formElemen\" size=\"20\">");
				
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(country.getOID())+"')\">"+country.getName()+"</a>");
				rowx.add(country.getNationality ());				
				rowx.add(country.getContinent());
				rowx.add(country.getHub());
				//rowx.add(country.getDescription());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_NAME));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_NATIONALITY] +"\" value=\""+objEntity.getNationality ()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_NATIONALITY));				
				//rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_CONTINENT] +"\" value=\""+objEntity.getContinent()+"\" class=\"formElemen\" size=\"15\">");
				rowx.add(JSPCombo.draw(frmObject.fieldNames[frmObject.JSP_CONTINENT],null, ""+objEntity.getContinent(), continent_value , continent_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_HUB] +"\" value=\""+objEntity.getHub()+"\" class=\"formElemen\" size=\"20\">");
				//rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCountry.JSP_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\" size=\"20\">");

		}

		lstData.add(rowx);

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCountry = JSPRequestValue.requestLong(request, "hidden_country_id");

//out.println(oidCountry);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCountry cmdCountry = new CmdCountry(request);
JSPLine ctrLine = new JSPLine();
Vector listCountry = new Vector(1,1);

/*switch statement */
iErrCode = cmdCountry.action(iJSPCommand , oidCountry);
/* end switch*/
JspCountry jspCountry = cmdCountry.getForm();

/*count list All Country */
int vectSize = DbCountry.getCount(whereClause);

/*switch list Country */
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = cmdCountry.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Country country = cmdCountry.getCountry ();
msgString =  cmdCountry.getMessage();

/* get record to display */
listCountry = DbCountry.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCountry.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCountry = DbCountry.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>POS Back Office</title>
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
function cmdAdd(){
	document.frmcountry.hidden_country_id.value="0";
	document.frmcountry.command.value="<%=JSPCommand.ADD%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdAsk(oidCountry){
	document.frmcountry.hidden_country_id.value=oidCountry;
	document.frmcountry.command.value="<%=JSPCommand.ASK%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdConfirmDelete(oidCountry){
	document.frmcountry.hidden_country_id.value=oidCountry;
	document.frmcountry.command.value="<%=JSPCommand.DELETE%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdSave(){
	document.frmcountry.command.value="<%=JSPCommand.SAVE%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdEdit(oidCountry){
	document.frmcountry.hidden_country_id.value=oidCountry;
	document.frmcountry.command.value="<%=JSPCommand.EDIT%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdCancel(oidCountry){
	document.frmcountry.hidden_country_id.value=oidCountry;
	document.frmcountry.command.value="<%=JSPCommand.EDIT%>";
	document.frmcountry.prev_command.value="<%=prevJSPCommand%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdBack(){
	document.frmcountry.command.value="<%=JSPCommand.BACK%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdListFirst(){
	document.frmcountry.command.value="<%=JSPCommand.FIRST%>";
	document.frmcountry.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdListPrev(){
	document.frmcountry.command.value="<%=JSPCommand.PREV%>";
	document.frmcountry.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdListNext(){
	document.frmcountry.command.value="<%=JSPCommand.NEXT%>";
	document.frmcountry.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

function cmdListLast(){
	document.frmcountry.command.value="<%=JSPCommand.LAST%>";
	document.frmcountry.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcountry.action="country.jsp";
	document.frmcountry.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidCountry){
	document.frmimage.hidden_country_id.value=oidCountry;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="country.jsp";
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcountry" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_country_id" value="<%=oidCountry%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                      Maintenance </font><font class="tit1">&raquo; 
                                      </font><font class="tit1"><span class="lvl2">General 
                                      </span>&raquo;</font> <span class="lvl2">Country</span></b></td>
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
                                          <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"><%= drawList(iJSPCommand,jspCountry, country,listCountry,oidCountry)%></td>
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
                                        <%if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="97%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="97%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top" > 
                                    <td colspan="3" class="command"> 
                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidCountry+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidCountry+"')";
									String scancel = "javascript:cmdEdit('"+oidCountry+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("");
									
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
                                      <%if(iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                      <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                      <%}%>
                                    </td>
                                  </tr>
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
