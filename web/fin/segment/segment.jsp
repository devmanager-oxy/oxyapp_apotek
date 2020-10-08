
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
    boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT);
    boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_VIEW);
    boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_UPDATE);
    boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_ADD);
    boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspSegment frmObject, Segment objEntity, Vector objectClass,  long segmentId){
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("80%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("No.","10%");
		ctrlist.addHeader("Name","30%");
		ctrlist.addHeader("Type","15%");
		ctrlist.addHeader("Function","15%");		
		ctrlist.addHeader("ID","20%");
		ctrlist.addHeader("Detail","10%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected Type*/
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		for(int i=0; i<DbSegment.strType.length; i++){
			type_value.add(DbSegment.strType[i]);
			type_key.add(DbSegment.strType[i]);
		}

		/* selected Function*/
		Vector function_value = new Vector(1,1);
		Vector function_key = new Vector(1,1);
		for(int i=0; i<DbSegment.strFunction.length; i++){
			function_value.add(DbSegment.strFunction[i]);
			function_key.add(DbSegment.strFunction[i]);
		}

		for (int i = 0; i < objectClass.size(); i++) {
			 Segment segment = (Segment)objectClass.get(i);
			 rowx = new Vector();
			 if(segmentId == segment.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				rowx.add("<div align=\"center\">"+segment.getCount()+"</div>");	
				rowx.add("<div align=\"center\"><input type=\"text\" name=\""+frmObject.colNames[JspSegment.JSP_NAME] +"\" size=\"34\" value=\""+segment.getName()+"\" class=\"formElemen\" ></div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspSegment.JSP_TYPE],null, ""+segment.getType(), type_value , type_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspSegment.JSP_FUNCTION],null, ""+segment.getFunction(), function_value , function_key, "formElemen", "")+"</div>");				
				rowx.add("<div align=\"center\">"+segment.getColumnName()+"</div>");
				rowx.add("");
			}else{
				rowx.add("<div align=\"center\">"+segment.getCount()+"</div></div>");
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(segment.getOID())+"')\">"+segment.getName()+"</a>");
				rowx.add("<div align=\"center\">"+segment.getType()+"</div>");
				rowx.add("<div align=\"center\">"+segment.getFunction()+"</div>");				
				rowx.add("<div align=\"center\">"+segment.getColumnName()+"</div>");
				rowx.add("<div align=\"center\"><a href=\"javascript:cmdDetail('"+segment.getOID()+"')\">Detail</a></div>");
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("");
				rowx.add("<div align=\"center\"><input type=\"text\" name=\""+frmObject.colNames[JspSegment.JSP_NAME] +"\" size=\"34\" value=\""+objEntity.getName()+"\" class=\"formElemen\"></div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspSegment.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspSegment.JSP_FUNCTION],null, ""+objEntity.getFunction(), function_value , function_key, "formElemen", "")+"</div>");				
				rowx.add("");
				rowx.add("");
		}

		lstData.add(rowx);

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSegment = JSPRequestValue.requestLong(request, "hidden_segment_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdSegment ctrlSegment = new CmdSegment(request);
JSPLine ctrLine = new JSPLine();
Vector listSegment = new Vector(1,1);

/*switch statement */
iErrCode = ctrlSegment.action(iJSPCommand , oidSegment);
/* end switch*/
JspSegment jspSegment = ctrlSegment.getForm();

/*count list All Segment*/
int vectSize = DbSegment.getCount(whereClause);

/*switch list Segment*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlSegment.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Segment segment = ctrlSegment.getSegment();
msgString =  ctrlSegment.getMessage();

/* get record to display */
listSegment = DbSegment.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listSegment.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listSegment = DbSegment.list(start,recordToGet, whereClause , orderClause);
}


/*** LANG ***/
String[] langMD = {"Records", "Editor", "Account Group", //0-2
"Account", "Budget", "Transaction", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section"}; //3-11

String[] langNav = {"Masterdata", "Segment", "All"};

if(lang == LANG_ID) {
	String[] langID = {"Daftar", "Editor", "Kelompok Perkiraan",
	"Perkiraan", "Anggaran", "Transaksi", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian"};
	langMD = langID;
	
	String[] navID = {"Data Induk", "Segmen", "Semua"};
	langNav = navID;
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

function cmdDetail(oid){
	document.frmsegment.hidden_segment_id.value=oid;
	document.frmsegment.command.value="<%=JSPCommand.LIST%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segmentdetail.jsp";
	document.frmsegment.submit();
}

function cmdAdd(){
	document.frmsegment.hidden_segment_id.value="0";
	document.frmsegment.command.value="<%=JSPCommand.ADD%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdAsk(oidSegment){
	document.frmsegment.hidden_segment_id.value=oidSegment;
	document.frmsegment.command.value="<%=JSPCommand.ASK%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdConfirmDelete(oidSegment){
	document.frmsegment.hidden_segment_id.value=oidSegment;
	document.frmsegment.command.value="<%=JSPCommand.DELETE%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdSave(){
	document.frmsegment.command.value="<%=JSPCommand.SAVE%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdEdit(oidSegment){
        <%if(privUpdate){%>
	document.frmsegment.hidden_segment_id.value=oidSegment;
	document.frmsegment.command.value="<%=JSPCommand.EDIT%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
         <%}%>
}

function cmdCancel(oidSegment){
	document.frmsegment.hidden_segment_id.value=oidSegment;
	document.frmsegment.command.value="<%=JSPCommand.EDIT%>";
	document.frmsegment.prev_command.value="<%=prevJSPCommand%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdBack(){
	document.frmsegment.command.value="<%=JSPCommand.BACK%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdListFirst(){
	document.frmsegment.command.value="<%=JSPCommand.FIRST%>";
	document.frmsegment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdListPrev(){
	document.frmsegment.command.value="<%=JSPCommand.PREV%>";
	document.frmsegment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdListNext(){
	document.frmsegment.command.value="<%=JSPCommand.NEXT%>";
	document.frmsegment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

function cmdListLast(){
	document.frmsegment.command.value="<%=JSPCommand.LAST%>";
	document.frmsegment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsegment.action="segment.jsp";
	document.frmsegment.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidSegment){
	document.frmimage.hidden_segment_id.value=oidSegment;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="segment.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
					  String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsegment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_segment_id" value="<%=oidSegment%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
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
                                      <%= drawList(iJSPCommand,jspSegment, segment,listSegment,oidSegment)%> </td>
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
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%
								if((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT)&& (jspSegment.errorSize()<1)){
							   if(privAdd){%>
                                  <tr align="left" valign="top"> 
                                    <td> 
                                      <table cellpadding="0" cellspacing="0" border="0">
                                        <tr> 
                                          <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                          <td width="20"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/ctr_line/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/ctr_line/BtnNew.jpg" width="18" height="16" alt="Add new data"></a></td>
                                          <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                          <td height="22" valign="middle" colspan="3" width="951"> 
                                            <a href="javascript:cmdAdd()" class="command">Add New</a></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}
						  			}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
							<%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspSegment.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                            <tr align="left" valign="top"> 
                              <td colspan="3" class="container"> 
                                <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidSegment+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidSegment+"')";
									String scancel = "javascript:cmdEdit('"+oidSegment+"')";
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
							<%}%>
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
