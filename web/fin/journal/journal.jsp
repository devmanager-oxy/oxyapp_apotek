<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
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


int nextCounter = DbJournal.getNextVoucherCounter(new Date());
String nextVcoucher = DbJournal.getNextVoucherNumber(new Date(), nextCounter);

%>

<%
//int iJSPCommand = JSPRequestValue.requestCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidJournalDetail = JSPRequestValue.requestLong(request, "hidden_journal_detail_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdJournalDetail ctrlJournalDetail = new CmdJournalDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listJournalDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlJournalDetail.action(iJSPCommand , oidJournalDetail);
/* end switch*/
JspJournalDetail jspJournalDetail = ctrlJournalDetail.getForm();

/*count list All JournalDetail*/
vectSize = DbJournalDetail.getCount(whereClause);

JournalDetail journalDetail = ctrlJournalDetail.getJournalDetail();
msgString =  ctrlJournalDetail.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlJournalDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listJournalDetail = DbJournalDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listJournalDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 //prevCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listJournalDetail = DbJournalDetail.list(start,recordToGet, whereClause , orderClause);
}
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
              <script language="JavaScript">

function cmdOpenAccount(){
	window.open("<%=approot%>/journal/coalist.jsp","coalist","addressbar=no, scrollbars=yes,height=400,width=600, menubar=no,toolbar=no,location=no,");
}


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
			  <%@ include file="../calendar/calendarframe.jsp"%>
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
				<input type="hidden" name="hidden_journal_detail_id" value="<%=oidJournalDetail%>">
				
				
				<input type="hidden" name="<%=JspJournalDetail.colNames[JspJournalDetail.JSP_COA_ID]%>" size="25">
				<input type="hidden" name="<%=JspJournalDetail.colNames[JspJournalDetail.JSP_DEPARTMENT_ID]%>" size="25"> 
				<input type="hidden" name="<%=JspJournalDetail.colNames[JspJournalDetail.JSP_SECTION_ID]%>" size="25">
				
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top">
                    <td height="8"  colspan="3"></td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="27%"><b><u>General Ledger &gt; New Journal</u></b> 
                          </td>
                          <td width="73%">Voucher No : <%=nextVcoucher%> 
                            <input type="hidden" name="<%=jspJournal.colNames[jspJournal.JSP_VOUCHER_COUNTER] %>"  value="<%= nextCounter %>" class="formElemen">
                            <input type="hidden" name="<%=jspJournal.colNames[jspJournal.JSP_VOUCHER_NUMBER] %>"  value="<%= nextVcoucher %>" class="formElemen">
                            , &nbsp;&nbsp;Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%> 
                            <input type="hidden" name="<%=jspJournal.colNames[jspJournal.JSP_VOUCHER_DATE] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen">
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" colspan="3"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr align="left"> 
                          <td height="10" valign="middle" width="9%"></td>
                          <td height="10" colspan="2" width="91%" class="comment" valign="top"></td>
                        </tr>
                        <tr align="left"> 
                          <td height="21" width="9%">Journal #</td>
                          <td height="21" colspan="2" width="91%" valign="top"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_REFF_NO] %>"  value="<%= journal.getReffNo() %>" class="formElemen" size="20">
                        <tr align="left"> 
                          <td height="21" width="9%">Date</td>
                          <td height="21" colspan="2" width="91%" valign="top"> 
                            <input name="<%=jspJournal.colNames[JspJournal.JSP_DATE] %>" value="<%=JSPFormater.formatDate((journal.getDate()==null) ? new Date() : journal.getDate(), "dd/MM/yyyy")%>" size="11">
                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmjournal.<%=jspJournal.colNames[JspJournal.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                        <tr align="left"> 
                          <td height="21" width="9%">Memo</td>
                          <td height="21" colspan="2" width="91%" valign="top"> 
                            <input type="text" name="<%=jspJournal.colNames[JspJournal.JSP_MEMO] %>"  value="<%= journal.getMemo() %>" class="formElemen" size="60">
                        <tr align="left"> 
                          <td height="21" colspan="3" class="boxed4"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td colspan="5" height="5"></td>
                              </tr>
                              <tr> 
                                <td width="102">&nbsp;<u><b>Account Detail</b></u></td>
                                <td width="292">&nbsp;</td>
                                <td width="59">&nbsp;</td>
                                <td width="229">&nbsp;</td>
                                <td width="193">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td colspan="5"> 
                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    <tr> 
                                      <td class="tablehdr" width="26%" height="16"> 
                                        Account</td>
                                      <td class="tablehdr" width="18%" height="16">Activity</td>
                                      <td class="tablehdr" width="17%" height="16">Debet</td>
                                      <td class="tablehdr" width="17%" height="16">Credit</td>
                                      <td class="tablehdr" width="22%" height="16">Memo</td>
                                    </tr>
                                    <tr> 
                                      <td class="tablecell" width="26%"> 
                                        <input type="text" name="coa_name" size="30" readOnly>
                                        <a href="javascript:cmdOpenAccount()" title="clik to browse chart of account list">Find</a></td>
                                      <td class="tablecell" width="18%"> 
                                        <table id="act" cellpadding="0" cellspacing="0">
                                          <tr> 
                                            <td > 
                                              <%
											  Vector modules = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_A+"' or level='"+I_Project.ACTIVITY_CODE_SA+"'", "code");
											  %>
                                              <select name="select2">
                                                <option value="0">- None -</option>
                                                <%if(modules!=null && modules.size()>0){
													for(int i=0; i<modules.size(); i++){
														Module module = (Module)modules.get(i);
														String str = module.getDescription();
														if(str.length()>40){
															str = str.substring(0, 40)+"...";
														}
												%>
                                                <option value="<%=module.getOID()%>"><%=module.getCode()+" - "+str%></option>
                                                <%}}%>
                                              </select>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td class="tablecell" width="17%"> 
                                        <div align="center"><a href="javascript:cmdOtherCurr()" title="click to applay other currency for debet position">Rp.</a> 
                                          <input type="text" name="textfield33" size="20" style="text-align:right">
                                        </div>
                                      </td>
                                      <td class="tablecell" width="17%"> 
                                        <div align="center"><a href="javascript:cmsOtherCurr()" title="click to applay other currency for credit position">Rp.</a> 
                                          <input type="text" name="textfield3" size="20" style="text-align:right">
                                        </div>
                                      </td>
                                      <td class="tablecell" width="22%"> 
                                        <div align="center"> 
                                          <input type="text" name="textfield323" size="30">
                                        </div>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="26%" class="tablecell"> 
                                        <%
													//check for activity
													Vector coas = new Vector();
													if(includeActivity){
													
													}else{													
												  		coas = DbCoa.list(0,0, "account_group<>'"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'", "code");
												    }
												  %>
                                        <select name="select5">
                                          <%if(coas!=null && coas.size()>0){
													for(int i=0; i<coas.size(); i++){
														Coa coa = (Coa)coas.get(i);
												%>
                                          <option value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                          <%}}%>
                                        </select>
                                      </td>
                                      <td width="18%" class="tablecell">&nbsp;</td>
                                      <td width="17%" class="tablecell"> 
                                        <div align="center"> 
                                          <input type="text" name="textfield32" size="20">
                                        </div>
                                      </td>
                                      <td width="17%" class="tablecell">&nbsp;</td>
                                      <td width="22%" class="tablecell">&nbsp;</td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr> 
                                <td width="102">&nbsp;</td>
                                <td width="292">&nbsp;</td>
                                <td width="59">&nbsp;</td>
                                <td width="229">&nbsp;</td>
                                <td width="193">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        <tr align="left"> 
                          <td height="8" valign="middle" width="9%">&nbsp;</td>
                          <td height="8" colspan="2" width="91%" valign="top">&nbsp; 
                          </td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" class="command" valign="top"> 
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
                          <td width="9%">&nbsp;</td>
                          <td width="91%">&nbsp;</td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" valign="top"> 
                            <div align="left"></div>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
				<script language="JavaScript">
					document.all.act.style.display="none";
				</script>
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
