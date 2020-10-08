<% 
/* 
 * Page Name  		:  bayarpinjaman_list.jsp
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

<!--package sipadu -->
<%@ page import = "com.dimata.sipadu.entity.pinjaman.*" %>
<%@ page import = "com.dimata.sipadu.form.pinjaman.*" %>
<%@ page import = "com.dimata.sipadu.entity.admin.*" %>
<%@ include file = "::...error, can't generate level, level = 0..::main/javainit.jsp" %>

<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "::...error, can't generate level, level = 0..::main/checkuser.jsp" %>
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
		ctrlist.addHeader("Tanggal","10%");
		ctrlist.addHeader("Amount","10%");
		ctrlist.addHeader("Bunga","10%");
		ctrlist.addHeader("Denda","10%");
		ctrlist.addHeader("Status","10%");
		ctrlist.addHeader("Type","10%");
		ctrlist.addHeader("Cicilan Ke","10%");
		ctrlist.addHeader("Pinalti","10%");
		ctrlist.addHeader("Counter","10%");
		ctrlist.addHeader("Prefix Number","10%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();

		for (int i = 0; i < objectClass.size(); i++) {
			BayarPinjaman bayarPinjaman = (BayarPinjaman)objectClass.get(i);
			Vector rowx = new Vector();

			String str_dt_Tanggal = ""; 
			try{
				Date dt_Tanggal = bayarPinjaman.getTanggal();
				if(dt_Tanggal==null){
					dt_Tanggal = new Date();
				}

				str_dt_Tanggal = Formater.formatDate(dt_Tanggal, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Tanggal = ""; }

			rowx.add(str_dt_Tanggal);

			rowx.add(String.valueOf(bayarPinjaman.getAmount()));

			rowx.add(String.valueOf(bayarPinjaman.getBunga()));

			rowx.add(String.valueOf(bayarPinjaman.getDenda()));

			rowx.add(String.valueOf(bayarPinjaman.getStatus()));

			rowx.add(String.valueOf(bayarPinjaman.getType()));

			rowx.add(String.valueOf(bayarPinjaman.getCicilanKe()));

			rowx.add(String.valueOf(bayarPinjaman.getPinalti()));

			rowx.add(String.valueOf(bayarPinjaman.getCounter()));

			rowx.add(bayarPinjaman.getPrefixNumber());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(bayarPinjaman.getOID()));
		}

		return ctrlist.draw();
	}

%>

<%

	ControlLine ctrLine = new ControlLine();
	CtrlBayarPinjaman ctrlBayarPinjaman = new CtrlBayarPinjaman(request);
	long var_member_id = FRMQueryString.requestLong(request, "hidden_member_id");
	long var_pinjaman_id = FRMQueryString.requestLong(request, "hidden_pinjaman_id");
	long var_pinjaman_detail_id = FRMQueryString.requestLong(request, "hidden_pinjaman_detail_id");
	long oidBayarPinjaman = FRMQueryString.requestLong(request, "hidden_bayar_pinjaman_id");

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

	vectSize = PstBayarPinjaman.getCount(whereClause);

	if((iCommand!=Command.FIRST)&&(iCommand!=Command.NEXT)&&(iCommand!=Command.PREV)&&(iCommand!=Command.LIST)){
		start = PstBayarPinjaman.generateFindStart(  oidBayarPinjaman, oidBayarPinjaman, oidBayarPinjaman, oidBayarPinjaman,recordToGet, whereClause)
	}

	//out.println("vectSize : "+vectSize);

	ctrlBayarPinjaman.action(iCommand , oidBayarPinjaman);

	if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||(iCommand==Command.LAST)||(iCommand==Command.LIST))

		start = ctrlBayarPinjaman.actionList(iCommand, start, vectSize, recordToGet);

	Vector records = PstBayarPinjaman.listAll();

%>

<!-- End of Jsp Block -->

<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>sipadu--</title>
<script language="JavaScript">

	function cmdAdd(){
		document.frm_bayarpinjaman.command.value="<%=Command.ADD%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_edit.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdEdit(oid){
		document.frm_bayarpinjaman.command.value="<%=Command.EDIT%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_edit.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdListFirst(){
		document.frm_bayarpinjaman.command.value="<%=Command.FIRST%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_list.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdListPrev(){
		document.frm_bayarpinjaman.command.value="<%=Command.PREV%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_list.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdListNext(){
		document.frm_bayarpinjaman.command.value="<%=Command.NEXT%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_list.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdListLast(){
		document.frm_bayarpinjaman.command.value="<%=Command.LAST%>";
		document.frm_bayarpinjaman.action="bayarpinjaman_list.jsp";
		document.frm_bayarpinjaman.submit();
	}

	function cmdBack(){
		document.frm_bayarpinjaman.command.value="<%=Command.BACK%>";
		document.frm_bayarpinjaman.action="srcbayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit();
	}

</script>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="::...error, can't generate level, level = 0..::style/main.css" type="text/css">
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
			<!-- #BeginEditable "menu_main" --><%@ include file = "::...error, can't generate level, level = 0..::main/menumain.jsp" %><!-- #EndEditable --> </td>
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

					<form name="frm_bayarpinjaman" method="post" action="">
					<input type="hidden" name="command" value="">
					<input type="hidden" name="start" value="<%=start%>">
					<input type="hidden" name="hidden_member_id" value="<%=var_member_id%>">
					<input type="hidden" name="hidden_pinjaman_id" value="<%=var_pinjaman_id%>">
					<input type="hidden" name="hidden_pinjaman_detail_id" value="<%=var_pinjaman_detail_id%>">
					<input type="hidden" name="hidden_bayar_pinjaman_id" value="<%=oidBayarPinjaman%>">
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
