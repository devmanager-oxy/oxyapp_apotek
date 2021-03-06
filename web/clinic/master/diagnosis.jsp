 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.clinic.master.*" %>
<%@ page import = "com.project.clinic.*" %>
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

	public String drawList(int iJSPCommand,JspDiagnosis frmObject, Diagnosis objEntity, Vector objectClass,  long diagnosisId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("40%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr"); 
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Kode","30%");
		ctrlist.addHeader("Diagnosa","70%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 Diagnosis diagnosis = (Diagnosis)objectClass.get(i);
			 rowx = new Vector();
			 if(diagnosisId == diagnosis.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDiagnosis.JSP_FIELD_CODE] +"\" value=\""+diagnosis.getCode()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDiagnosis.JSP_FIELD_NAME] +"\" value=\""+diagnosis.getName()+"\" class=\"formElemen\" size=\"35\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(diagnosis.getOID())+"')\">"+diagnosis.getCode()+"</a>");
				rowx.add(diagnosis.getName());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDiagnosis.JSP_FIELD_CODE] +"\" value=\""+objEntity.getCode()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDiagnosis.JSP_FIELD_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\" size=\"35\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidDiagnosis = JSPRequestValue.requestLong(request, "hidden_diagnosis_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdDiagnosis ctrlDiagnosis = new CmdDiagnosis(request);
JSPLine ctrLine = new JSPLine();
Vector listDiagnosis = new Vector(1,1);

/*switch statement */
iErrCode = ctrlDiagnosis.action(iJSPCommand , oidDiagnosis);
/* end switch*/
JspDiagnosis jspDiagnosis = ctrlDiagnosis.getForm();

/*count list All Diagnosis*/
int vectSize = DbDiagnosis.getCount(whereClause);

/*switch list Diagnosis*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlDiagnosis.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Diagnosis diagnosis = ctrlDiagnosis.getDiagnosis();
msgString =  ctrlDiagnosis.getMessage();

/* get record to display */
listDiagnosis = DbDiagnosis.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDiagnosis.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listDiagnosis = DbDiagnosis.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
                        <script language="JavaScript">


function cmdAdd(){
	document.frmdiagnosis.hidden_diagnosis_id.value="0";
	document.frmdiagnosis.command.value="<%=JSPCommand.ADD%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdAsk(oidDiagnosis){
	document.frmdiagnosis.hidden_diagnosis_id.value=oidDiagnosis;
	document.frmdiagnosis.command.value="<%=JSPCommand.ASK%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdConfirmDelete(oidDiagnosis){
	document.frmdiagnosis.hidden_diagnosis_id.value=oidDiagnosis;
	document.frmdiagnosis.command.value="<%=JSPCommand.DELETE%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdSave(){
	document.frmdiagnosis.command.value="<%=JSPCommand.SAVE%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdEdit(oidDiagnosis){
	document.frmdiagnosis.hidden_diagnosis_id.value=oidDiagnosis;
	document.frmdiagnosis.command.value="<%=JSPCommand.EDIT%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdCancel(oidDiagnosis){
	document.frmdiagnosis.hidden_diagnosis_id.value=oidDiagnosis;
	document.frmdiagnosis.command.value="<%=JSPCommand.EDIT%>";
	document.frmdiagnosis.prev_command.value="<%=prevJSPCommand%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdBack(){
	document.frmdiagnosis.command.value="<%=JSPCommand.BACK%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdListFirst(){
	document.frmdiagnosis.command.value="<%=JSPCommand.FIRST%>";
	document.frmdiagnosis.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdListPrev(){
	document.frmdiagnosis.command.value="<%=JSPCommand.PREV%>";
	document.frmdiagnosis.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdListNext(){
	document.frmdiagnosis.command.value="<%=JSPCommand.NEXT%>";
	document.frmdiagnosis.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

function cmdListLast(){
	document.frmdiagnosis.command.value="<%=JSPCommand.LAST%>";
	document.frmdiagnosis.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmdiagnosis.action="diagnosis.jsp";
	document.frmdiagnosis.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidDiagnosis){
	document.frmimage.hidden_diagnosis_id.value=oidDiagnosis;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="diagnosis.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmdiagnosis" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_diagnosis_id" value="<%=oidDiagnosis%>">
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
                                                  </font><font class="tit1">&raquo; 
                                                  </font> <span class="lvl2">Daftar 
                                                  Diagnosa</span></b></td>
                                                <td width="40%" height="23"> 
                                                  <%@ include file = "../main/userpreview.jsp" %>
                                                </td>
                                              </tr>
                                              <tr > 
                                                <td colspan="2" height="3" background="<%=approot%>/imagessl/line1.gif" ></td>
                                              </tr>
                                            </table>
                                          </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                  <%
							try{
							%>
                                  <tr align="left" valign="top">  
                                    <td height="22" valign="middle" colspan="3"> 
                                      <%= drawList(iJSPCommand,jspDiagnosis, diagnosis,listDiagnosis,oidDiagnosis)%> </td>
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
                                      <% ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iJSPCommand!=JSPCommand.SAVE)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../imagessl/new2.gif',1)"><img src="../imagessl/new.gif" name="new21" width="71" height="22" border="0"></a></td>
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
									ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("40%");
									String scomDel = "javascript:cmdAsk('"+oidDiagnosis+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidDiagnosis+"')";
									String scancel = "javascript:cmdEdit('"+oidDiagnosis+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");

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
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
