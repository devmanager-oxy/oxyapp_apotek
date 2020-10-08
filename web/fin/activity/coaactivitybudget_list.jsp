<% 
/* 
 * Page Name  		:  coaactivitybudget_list.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package finance -->
<%@ page import = "com.dimata.finance.entity.activity.*" %>
<%@ page import = "com.dimata.finance.form.activity.*" %>
<%@ page import = "com.dimata.finance.entity.admin.*" %>
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

	public String drawList(Vector objectClass ){
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Type","20%");
		ctrlist.addHeader("Coa Id","20%");
		ctrlist.addHeader("Admin Percent","20%");
		ctrlist.addHeader("Logistic Percent","20%");
		ctrlist.addHeader("Memo","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();

		for (int i = 0; i < objectClass.size(); i++) {
			CoaActivityBudget coaActivityBudget = (CoaActivityBudget)objectClass.get(i);
			Vector rowx = new Vector();

			rowx.add(coaActivityBudget.getType());

			rowx.add(String.valueOf(coaActivityBudget.getCoaId()));

			rowx.add(String.valueOf(coaActivityBudget.getAdminPercent()));

			rowx.add(String.valueOf(coaActivityBudget.getLogisticPercent()));

			rowx.add(coaActivityBudget.getMemo());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(coaActivityBudget.getOID()));
		}

		return ctrlist.draw();
	}

%>

<%

	ControlLine ctrLine = new ControlLine();
	CtrlCoaActivityBudget ctrlCoaActivityBudget = new CtrlCoaActivityBudget(request);
	long oidCoaActivityBudget = FRMQueryString.requestLong(request, "hidden_coa_activity_budget_id");

	int iErrCode = FRMMessage.ERR_NONE;
	String msgStr = "";
	int iCommand = FRMQueryString.requestCommand(request);
	int start = FRMQueryString.requestInt(request, "start");
	int recordToGet = 5;
	int vectSize = 0;
	String whereClause = "";

	//out.println("iCommand : "+iCommand);
	//out.println("<br>start : "+start);
	//out.println("<br>recordToGet : "+recordToGet);

	vectSize = PstCoaActivityBudget.getCount(whereClause);

	if((iCommand!=Command.FIRST)&&(iCommand!=Command.NEXT)&&(iCommand!=Command.PREV)&&(iCommand!=Command.LIST)){
		start = PstCoaActivityBudget.generateFindStart(  oidCoaActivityBudget,recordToGet, whereClause)
	}

	//out.println("vectSize : "+vectSize);

	ctrlCoaActivityBudget.action(iCommand , oidCoaActivityBudget);

	if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||(iCommand==Command.LAST)||(iCommand==Command.LIST))

		start = ctrlCoaActivityBudget.actionList(iCommand, start, vectSize, recordToGet);

	Vector records = PstCoaActivityBudget.listAll();

%>

<!-- End of Jsp Block -->

<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">

	function cmdAdd(){
		document.frm_coaactivitybudget.command.value="<%=Command.ADD%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdEdit(oid){
		document.frm_coaactivitybudget.command.value="<%=Command.EDIT%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdListFirst(){
		document.frm_coaactivitybudget.command.value="<%=Command.FIRST%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_list.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdListPrev(){
		document.frm_coaactivitybudget.command.value="<%=Command.PREV%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_list.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdListNext(){
		document.frm_coaactivitybudget.command.value="<%=Command.NEXT%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_list.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdListLast(){
		document.frm_coaactivitybudget.command.value="<%=Command.LAST%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_list.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdBack(){
		document.frm_coaactivitybudget.command.value="<%=Command.BACK%>";
		document.frm_coaactivitybudget.action="srccoaactivitybudget.jsp";
		document.frm_coaactivitybudget.submit();
	}

</script>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
	<tr>
		<td colspan="2" height="25" class="toptitle">
			<div align="center">Header Title</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="topmenu" height="20">
			<!-- #BeginEditable "menu_main" --><%@ include file = "../main/menumain.jsp" %><!-- #EndEditable --> </td>
	</tr>
	<tr>
		<td width="88%" valign="top" align="left">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="20" class="contenttitle" >
					<!-- #BeginEditable "contenttitle" -->
					Content Title .......
					<!-- #EndEditable -->
					</td>
				</tr>
				<tr>
					<td valign="top">
					<!-- #BeginEditable "content" -->

					<form name="frm_coaactivitybudget" method="post" action="">
					<input type="hidden" name="command" value="">
					<input type="hidden" name="start" value="<%=start%>">
					<input type="hidden" name="hidden_coa_activity_budget_id" value="<%=oidCoaActivityBudget%>">
					<table border="0" width="100%">
						<tr><td height="8">
							<hr>
						</td></tr>
						<tr>
							<td height="8" width="100%" class="comment">...Table Title Name....</td>
						</tr>
					</table>
					<%if((records!=null)&&(records.size()>0)){%>
						<%=drawList(records)%>
					<%}
					else{
					%>
						<span class="comment"><br>&nbsp;Records is empty ...</span>
					<%}%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table width="100%" cellspacing="0" cellpadding="3">
									<tr>
										<td>
											<% ctrLine.setLocationImg(approot+"/images/ctr_line");
												ctrLine.initDefault();
											%>
											<%=ctrLine.drawImageListLimit(iCommand,vectSize,start,recordToGet)%></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="46%">&nbsp;</td>
						</tr>
						<tr>
							<td width="46%" nowrap align="left" class="command">&nbsp;
								<a href="javascript:cmdAdd()">Add New</a> | 
								<a href="javascript:cmdBack()">Back to search</a>
							</td>
						</tr>
					</table>
					</form>

					<!-- #EndEditable -->
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" height="20" class="footer">
			<div align="center"> copyright Bali Information Technologies 2002</div>
		</td>
	</tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
