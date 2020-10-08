 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
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

	public String drawList(int iJSPCommand,JspMerk frmObject, Merk objEntity, Vector objectClass,  long merkId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("50%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("Name","33%");
		

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		
		for (int i = 0; i < objectClass.size(); i++) {
			 Merk merk = (Merk)objectClass.get(i);
			 rowx = new Vector();
			 if(merkId == merk.getOID())
				 index = i; 

			if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				rowx.add("<div align=\"left\">"+"<input type=\"text\" size=\"75\" name=\""+frmObject.colNames[JspMerk.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");
				
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(merk.getOID())+"')\">"+merk.getName()+"</a>");

				/*String str_dt_StartTime = ""; 
				try{
					Date dt_StartTime = shift.getStartTime();
					if(dt_StartTime==null){
						dt_StartTime = new Date();
					}

				str_dt_StartTime = JSPFormater.formatDate(dt_StartTime, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_StartTime = ""; }*/
				//rowx.add(((shift.getStartHours()<10) ? "0"+shift.getStartHours() : ""+shift.getStartHours())   +" : "+((shift.getStartMinutes()<10) ? "0"+shift.getStartMinutes() : ""+shift.getStartMinutes()));

				/*String str_dt_EndTime = ""; 
				try{
					Date dt_EndTime = shift.getEndTime();
					if(dt_EndTime==null){
						dt_EndTime = new Date();
					}

				str_dt_EndTime = JSPFormater.formatDate(dt_EndTime, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_EndTime = ""; }*/
				
				//rowx.add(shift.getEndHours()+" : "+shift.getEndMinutes());
				//rowx.add(((shift.getEndHours()<10) ? "0"+shift.getEndHours() : ""+shift.getEndHours())   +" : "+((shift.getEndMinutes()<10) ? "0"+shift.getEndMinutes() : ""+shift.getEndMinutes()));
				
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<div align=\"left\">"+"<input type=\"text\" size=\"75\" name=\""+frmObject.colNames[JspMerk.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" name=\""+frmObject.colNames[JspShift.JSP_START_TIME] +"\" value=\""+objEntity.getStartTime()+"\" class=\"formElemen\">"+"</div>");
				//Date startDate = (objEntity.getStartTime()==null) ? new Date() : objEntity.getStartTime();
				//rowx.add("<div align=\"center\">"+startHour+getHourOptions(objEntity.getStartHours())+ending+" : "+startMinutes+getMinutesOptions(objEntity.getStartMinutes())+ending+"</div>");
				//Date endDate = (objEntity.getEndTime()==null) ? new Date() : objEntity.getEndTime();
				//rowx.add("<div align=\"center\">"+"<input type=\"text\" name=\""+frmObject.colNames[JspShift.JSP_END_TIME] +"\" value=\""+objEntity.getEndTime()+"\" class=\"formElemen\">"+"</div>");
				//rowx.add("<div align=\"center\">"+endHour+getHourOptions(objEntity.getEndHours())+ending+" : "+endMinutes+getMinutesOptions(objEntity.getEndMinutes())+ending+"</div>");

		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}
	
	
	
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidMerk = JSPRequestValue.requestLong(request, "hidden_merk_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdMerk cmdMerk = new CmdMerk(request);
JSPLine ctrLine = new JSPLine();
Vector listMerk = new Vector(1,1);

/*switch statement */
iErrCode = cmdMerk.action(iJSPCommand , oidMerk);
/* end switch*/
JspMerk jspMerk = cmdMerk.getForm();

/*count list All Shift*/
int vectSize = DbMerk.getCount(whereClause);

/*switch list Shift*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = cmdMerk.actionList(iJSPCommand, start, vectSize, recordToGet);
} 
/* end switch list*/

Merk merk = cmdMerk.getMerk();
msgString =  cmdMerk.getMessage();

/* get record to display */
listMerk = DbMerk.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listMerk.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listMerk = DbMerk.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Oxy-Retail System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">


function cmdAdd(){
	document.frmshift.hidden_merk_id.value="0";
	document.frmshift.command.value="<%=JSPCommand.ADD%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdAsk(oidMerk){
	document.frmshift.hidden_merk_id.value=oidMerk;
	document.frmshift.command.value="<%=JSPCommand.ASK%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdConfirmDelete(oidMerk){
	document.frmshift.hidden_merk_id.value=oidMerk;
	document.frmshift.command.value="<%=JSPCommand.DELETE%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdSave(){
	document.frmshift.command.value="<%=JSPCommand.SAVE%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdEdit(oidMerk){
	document.frmshift.hidden_merk_id.value=oidMerk;
	document.frmshift.command.value="<%=JSPCommand.EDIT%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdCancel(oidShift){
	document.frmshift.hidden_shift_id.value=oidShift;
	document.frmshift.command.value="<%=JSPCommand.EDIT%>";
	document.frmshift.prev_command.value="<%=prevJSPCommand%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdBack(){
	document.frmshift.command.value="<%=JSPCommand.BACK%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdListFirst(){
	document.frmshift.command.value="<%=JSPCommand.FIRST%>";
	document.frmshift.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdListPrev(){
	document.frmshift.command.value="<%=JSPCommand.PREV%>";
	document.frmshift.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdListNext(){
	document.frmshift.command.value="<%=JSPCommand.NEXT%>";
	document.frmshift.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

function cmdListLast(){
	document.frmshift.command.value="<%=JSPCommand.LAST%>";
	document.frmshift.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmshift.action="merk.jsp";
	document.frmshift.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidShift){
	document.frmimage.hidden_shift_id.value=oidShift;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="merk.jsp";
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
                        <form name="frmshift" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_merk_id" value="<%=oidMerk%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                  &raquo;</font> <span class="lvl2">Merk
                                                   </span></b></td>
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
                                          <td height="5" valign="middle" colspan="3">
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(iJSPCommand,jspMerk, merk,listMerk,oidMerk)%> </td>
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
                                          <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                        </tr><tr align="left" valign="top"> 
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
									String scomDel = "javascript:cmdAsk('"+oidMerk+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidMerk+"')";
									String scancel = "javascript:cmdEdit('"+oidMerk+"')";
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
                          </table></td>
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
