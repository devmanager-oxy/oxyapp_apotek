<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long journalId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Journal Type","9%");
		ctrlist.addHeader("Date","9%");
		ctrlist.addHeader("Pic By","9%");
		ctrlist.addHeader("Currency","9%");
		ctrlist.addHeader("Memo","9%");
		ctrlist.addHeader("Pic From","9%");
		ctrlist.addHeader("User By Id","9%");
		ctrlist.addHeader("User From Id","9%");
		ctrlist.addHeader("Amount","9%");
		ctrlist.addHeader("Reff No","9%");
		ctrlist.addHeader("Voucher Number","9%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Journal journal = (Journal)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(journalId == journal.getOID())
				 index = i;

			rowx.add(journal.getJournalType());

			String str_dt_Date = ""; 
			try{
				Date dt_Date = journal.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(journal.getPicBy());

			rowx.add(journal.getCurrency());

			rowx.add(journal.getMemo());

			rowx.add(journal.getPicFrom());

			rowx.add(String.valueOf(journal.getUserById()));

			rowx.add(String.valueOf(journal.getUserFromId()));

			rowx.add(String.valueOf(journal.getAmount()));

			rowx.add(journal.getReffNo());

			rowx.add(journal.getVoucherNumber());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(journal.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidJournal = JSPRequestValue.requestLong(request, "hidden_journal_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdJournal ctrlJournal = new CmdJournal(request);
JSPLine ctrLine = new JSPLine();
Vector listJournal = new Vector(1,1);

/*switch statement */
iErrCode = ctrlJournal.action(iJSPCommand , oidJournal);
/* end switch*/
JspJournal jspJournal = ctrlJournal.getForm();

/*count list All Journal*/
int vectSize = DbJournal.getCount(whereClause);

Journal journal = ctrlJournal.getJournal();
msgString =  ctrlJournal.getMessage();



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlJournal.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listJournal = DbJournal.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listJournal.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listJournal = DbJournal.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<title>finance--</title>
              <script language="JavaScript">


function cmdAdd(){
	document.frmjournal.hidden_journal_id.value="0";
	document.frmjournal.command.value="<%=JSPCommand.ADD%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}

function cmdAsk(oidJournal){
	document.frmjournal.hidden_journal_id.value=oidJournal;
	document.frmjournal.command.value="<%=JSPCommand.ASK%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}

function cmdConfirmDelete(oidJournal){
	document.frmjournal.hidden_journal_id.value=oidJournal;
	document.frmjournal.command.value="<%=JSPCommand.DELETE%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}
function cmdSave(){
	document.frmjournal.command.value="<%=JSPCommand.SAVE%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
	}

function cmdEdit(oidJournal){
	document.frmjournal.hidden_journal_id.value=oidJournal;
	document.frmjournal.command.value="<%=JSPCommand.EDIT%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
	}

function cmdCancel(oidJournal){
	document.frmjournal.hidden_journal_id.value=oidJournal;
	document.frmjournal.command.value="<%=JSPCommand.EDIT%>";
	document.frmjournal.prev_command.value="<%=prevJSPCommand%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}

function cmdBack(){
	document.frmjournal.command.value="<%=JSPCommand.BACK%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
	}

function cmdListFirst(){
	document.frmjournal.command.value="<%=JSPCommand.FIRST%>";
	document.frmjournal.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}

function cmdListPrev(){
	document.frmjournal.command.value="<%=JSPCommand.PREV%>";
	document.frmjournal.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
	}

function cmdListNext(){
	document.frmjournal.command.value="<%=JSPCommand.NEXT%>";
	document.frmjournal.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
}

function cmdListLast(){
	document.frmjournal.command.value="<%=JSPCommand.LAST%>";
	document.frmjournal.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmjournal.action="journal.jsp";
	document.frmjournal.submit();
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash </span> &raquo; 
                        <span class="level1">Petty Cash</span> &raquo; <span class="level2">Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frmjournal" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_journal_id" value="<%=oidJournal%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3">&nbsp; </td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Journal 
                            List </td>
                        </tr>
                        <%
							try{
								if (listJournal.size()>0){
							%>
                        <tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3"> <%= drawList(listJournal,oidJournal)%> </td>
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
                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspJournal.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="middle" width="17%">&nbsp;</td>
                          <td height="21" colspan="2" width="83%" class="comment">*)= 
                            required</td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Date</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_DATE] %>"  value="<%= journal.getDate() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Pic By</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_PIC_BY] %>"  value="<%= journal.getPicBy() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Currency</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_CURRENCY] %>"  value="<%= journal.getCurrency() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Memo</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_MEMO] %>"  value="<%= journal.getMemo() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Pic From</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_PIC_FROM] %>"  value="<%= journal.getPicFrom() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">User By Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_USER_BY_ID] %>"  value="<%= journal.getUserById() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">User From Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_USER_FROM_ID] %>"  value="<%= journal.getUserFromId() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Periode Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_PERIODE_ID] %>"  value="<%= journal.getPeriodeId() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Status</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_STATUS] %>"  value="<%= journal.getStatus() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Amount</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_AMOUNT] %>"  value="<%= journal.getAmount() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Reff No</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_REFF_NO] %>"  value="<%= journal.getReffNo() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Voucher Number</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_VOUCHER_NUMBER] %>"  value="<%= journal.getVoucherNumber() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Voucher Counter</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_VOUCHER_COUNTER] %>"  value="<%= journal.getVoucherCounter() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Voucher Date</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_VOUCHER_DATE] %>"  value="<%= journal.getVoucherDate() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Exchange Rate</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_EXCHANGE_RATE] %>"  value="<%= journal.getExchangeRate() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">User Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_USER_ID] %>"  value="<%= journal.getUserId() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Journal Type</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_JOURNAL_TYPE] %>"  value="<%= journal.getJournalType() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Ap Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_AP_ID] %>"  value="<%= journal.getApId() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Arap Payment 
                            Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_ARAP_PAYMENT_ID] %>"  value="<%= journal.getArapPaymentId() %>" class="formElemen">
                        <tr align="left" valign="top"> 
                          <td height="21" valign="top" width="17%">Ar Id</td>
                          <td height="21" colspan="2" width="83%"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_AR_ID] %>"  value="<%= journal.getArId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidJournal+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidJournal+"')";
									String scancel = "javascript:cmdEdit('"+oidJournal+"')";
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
