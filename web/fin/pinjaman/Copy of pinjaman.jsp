 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
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

	public String drawList(Vector objectClass ,  long pinjamanId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Number","8%");
		ctrlist.addHeader("Date","8%");
		ctrlist.addHeader("Note","8%");
		ctrlist.addHeader("Total Pinjaman","8%");
		ctrlist.addHeader("Bunga","8%");
		ctrlist.addHeader("Status","8%");
		ctrlist.addHeader("User Id","8%");
		ctrlist.addHeader("Biaya Administrasi","8%");
		ctrlist.addHeader("Jenis Barang","8%");
		ctrlist.addHeader("Detail Jenis Barang","8%");
		ctrlist.addHeader("Bank Id","8%");
		ctrlist.addHeader("Lama Cicilan","8%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Pinjaman pinjaman = (Pinjaman)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(pinjamanId == pinjaman.getOID())
				 index = i;

			rowx.add(pinjaman.getNumber());

			String str_dt_Date = ""; 
			try{
				Date dt_Date = pinjaman.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(pinjaman.getNote());

			rowx.add(String.valueOf(pinjaman.getTotalPinjaman()));

			rowx.add(String.valueOf(pinjaman.getBunga()));

			rowx.add(String.valueOf(pinjaman.getStatus()));

			rowx.add(String.valueOf(pinjaman.getUserId()));

			rowx.add(String.valueOf(pinjaman.getBiayaAdministrasi()));

			rowx.add(String.valueOf(pinjaman.getJenisBarang()));

			rowx.add(pinjaman.getDetailJenisBarang());

			rowx.add(String.valueOf(pinjaman.getBankId()));

			rowx.add(String.valueOf(pinjaman.getLamaCicilan()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(pinjaman.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPinjaman = JSPRequestValue.requestLong(request, "hidden_pinjaman_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPinjaman ctrlPinjaman = new CmdPinjaman(request);
JSPLine ctrLine = new JSPLine();
Vector listPinjaman = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPinjaman.action(iJSPCommand , oidPinjaman);
/* end switch*/
JspPinjaman jspPinjaman = ctrlPinjaman.getForm();

/*count list All Pinjaman*/
int vectSize = DbPinjaman.getCount(whereClause);

Pinjaman pinjaman = ctrlPinjaman.getPinjaman();
msgString =  ctrlPinjaman.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPinjaman.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPinjaman = DbPinjaman.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPinjaman.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPinjaman = DbPinjaman.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">
function cmdAdd(){
	document.frmpinjaman.hidden_pinjaman_id.value="0";
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdAsk(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.ASK%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdConfirmDelete(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.DELETE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}
function cmdSave(){
	document.frmpinjaman.command.value="<%=JSPCommand.SAVE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdEdit(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdCancel(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdBack(){
	document.frmpinjaman.command.value="<%=JSPCommand.BACK%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListFirst(){
	document.frmpinjaman.command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListPrev(){
	document.frmpinjaman.command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListNext(){
	document.frmpinjaman.command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListLast(){
	document.frmpinjaman.command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash 
                        </span> &raquo; <span class="level1">Petty Cash</span> 
                        &raquo; <span class="level2">Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpinjaman" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_pinjaman_id" value="<%=oidPinjaman%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <hr>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Pinjaman 
                                      List </td>
                                  </tr>
                                  <%
							try{
								if (listPinjaman.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <%= drawList(listPinjaman,oidPinjaman)%> </td>
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
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()" class="command">Add 
                                      New</a></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspPinjaman.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="17%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%" class="comment">*)= 
                                      required</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Member 
                                      Id</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_MEMBER_ID] %>"  value="<%= pinjaman.getMemberId() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Counter</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_COUNTER] %>"  value="<%= pinjaman.getCounter() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Prefix 
                                      Number</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_PREFIX_NUMBER] %>"  value="<%= pinjaman.getPrefixNumber() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Number</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_NUMBER] %>"  value="<%= pinjaman.getNumber() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Date</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_DATE] %>"  value="<%= pinjaman.getDate() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Note</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_NOTE] %>"  value="<%= pinjaman.getNote() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Total 
                                      Pinjaman</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TOTAL_PINJAMAN] %>"  value="<%= pinjaman.getTotalPinjaman() %>" class="formElemen">
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TOTAL_PINJAMAN) %> 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Bunga</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BUNGA] %>"  value="<%= pinjaman.getBunga() %>" class="formElemen">
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_BUNGA) %> 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Status</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_STATUS] %>"  value="<%= pinjaman.getStatus() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">User 
                                      Id</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_USER_ID] %>"  value="<%= pinjaman.getUserId() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Biaya 
                                      Administrasi</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BIAYA_ADMINISTRASI] %>"  value="<%= pinjaman.getBiayaAdministrasi() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Jenis 
                                      Barang</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_JENIS_BARANG] %>"  value="<%= pinjaman.getJenisBarang() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Detail 
                                      Jenis Barang</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_DETAIL_JENIS_BARANG] %>"  value="<%= pinjaman.getDetailJenisBarang() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Lama 
                                      Cicilan</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_LAMA_CICILAN] %>"  value="<%= pinjaman.getLamaCicilan() %>" class="formElemen">
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_LAMA_CICILAN) %> 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Type</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TYPE] %>"  value="<%= pinjaman.getType() %>" class="formElemen">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">Bank 
                                      Id</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BANK_ID] %>"  value="<%= pinjaman.getBankId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidPinjaman+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPinjaman+"')";
									String scancel = "javascript:cmdEdit('"+oidPinjaman+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
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
                                    <td width="13%">&nbsp;</td>
                                    <td width="87%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top" > 
                                    <td colspan="3">
                                      <div align="left"></div>
                                    </td>
                                  </tr>
                                </table>
                                <%}%>
                              </td>
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
