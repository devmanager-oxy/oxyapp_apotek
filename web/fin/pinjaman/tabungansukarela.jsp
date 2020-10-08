 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long tabunganSukarelaId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Tanggal","11%");
		ctrlist.addHeader("Debet","11%");
		ctrlist.addHeader("Credit","11%");
		ctrlist.addHeader("Type","11%");
		ctrlist.addHeader("Note","11%");
		ctrlist.addHeader("User Id","11%");
		ctrlist.addHeader("Trans Date","11%");
		ctrlist.addHeader("Period Id","11%");
		ctrlist.addHeader("Post Status","11%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			TabunganSukarela tabunganSukarela = (TabunganSukarela)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(tabunganSukarelaId == tabunganSukarela.getOID())
				 index = i;

			String str_dt_Tanggal = ""; 
			try{
				Date dt_Tanggal = tabunganSukarela.getTanggal();
				if(dt_Tanggal==null){
					dt_Tanggal = new Date();
				}

				str_dt_Tanggal = JSPFormater.formatDate(dt_Tanggal, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Tanggal = ""; }

			rowx.add(str_dt_Tanggal);

			rowx.add(String.valueOf(tabunganSukarela.getJumlah()));

			rowx.add(String.valueOf(tabunganSukarela.getPengali()));

			rowx.add(String.valueOf(tabunganSukarela.getType()));

			rowx.add(tabunganSukarela.getNote());

			rowx.add(String.valueOf(tabunganSukarela.getUserId()));

			String str_dt_TransDate = ""; 
			try{
				Date dt_TransDate = tabunganSukarela.getTransDate();
				if(dt_TransDate==null){
					dt_TransDate = new Date();
				}

				str_dt_TransDate = JSPFormater.formatDate(dt_TransDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_TransDate = ""; }

			rowx.add(str_dt_TransDate);

			rowx.add(String.valueOf(tabunganSukarela.getPeriodId()));

			rowx.add(String.valueOf(tabunganSukarela.getPostStatus()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(tabunganSukarela.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%

long memberId = JSPRequestValue.requestLong(request, "hidden_member_id");

Member member = new Member();
if(memberId!=0){
	try{
		member = DbMember.fetchExc(memberId);
	}
	catch(Exception e){
	}
}

Dinas dinas = new Dinas();
try{
	dinas = DbDinas.fetchExc(member.getDinasId());
}
catch(Exception e){
}

DinasUnit dinasUnit = new DinasUnit();
try{
	dinasUnit = DbDinasUnit.fetchExc(member.getDinasUnitId());
}
catch(Exception e){
}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTabunganSukarela = JSPRequestValue.requestLong(request, "hidden_tabungan_sukarela_id");

//out.println("start : "+start);
if(start<0){
	start = 0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "member_id="+memberId;
String orderClause = "counter";

CmdTabunganSukarela ctrlTabunganSukarela = new CmdTabunganSukarela(request);
JSPLine ctrLine = new JSPLine();
Vector listTabunganSukarela = new Vector(1,1);

/*switch statement */
iErrCode = ctrlTabunganSukarela.action(iJSPCommand , oidTabunganSukarela);
/* end switch*/
JspTabunganSukarela jspTabunganSukarela = ctrlTabunganSukarela.getForm();

/*count list All TabunganSukarela*/
int vectSize = DbTabunganSukarela.getCount(whereClause);

TabunganSukarela tabunganSukarela = ctrlTabunganSukarela.getTabunganSukarela();
msgString =  ctrlTabunganSukarela.getMessage();

//out.println("iJSPCommand : "+iJSPCommand);

if(iJSPCommand==JSPCommand.EDIT){
	iJSPCommand = JSPCommand.LAST;
}

//out.println("<br>iJSPCommand : "+iJSPCommand);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlTabunganSukarela.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listTabunganSukarela = DbTabunganSukarela.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listTabunganSukarela.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listTabunganSukarela = DbTabunganSukarela.list(start,recordToGet, whereClause , orderClause);
}

//out.println("listTabunganSukarela : "+listTabunganSukarela);
//out.println("memberId : "+memberId);

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">


function cmdAdd(){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value="0";
	document.frmtabungansukarela.command.value="<%=JSPCommand.ADD%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

function cmdAsk(oidTabunganSukarela){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value=oidTabunganSukarela;
	document.frmtabungansukarela.command.value="<%=JSPCommand.ASK%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

function cmdConfirmDelete(oidTabunganSukarela){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value=oidTabunganSukarela;
	document.frmtabungansukarela.command.value="<%=JSPCommand.DELETE%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}
function cmdSave(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.SAVE%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
	}

function cmdEdit(oidTabunganSukarela){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value=oidTabunganSukarela;
	document.frmtabungansukarela.command.value="<%=JSPCommand.EDIT%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
	}

function cmdCancel(oidTabunganSukarela){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value=oidTabunganSukarela;
	document.frmtabungansukarela.command.value="<%=JSPCommand.EDIT%>";
	document.frmtabungansukarela.prev_command.value="<%=prevJSPCommand%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

function cmdBack(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.BACK%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
	}

function cmdListFirst(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.FIRST%>";
	document.frmtabungansukarela.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

function cmdListPrev(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.PREV%>";
	document.frmtabungansukarela.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
	}

function cmdListNext(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.NEXT%>";
	document.frmtabungansukarela.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

function cmdListLast(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansukarela.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
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
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif','<%=approot%>/images/ctr_line/BtnNewOn.jpg')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Simpanan Sukarela<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmtabungansukarela" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_tabungan_sukarela_id" value="<%=oidTabunganSukarela%>">
						  <input type="hidden" name="hidden_member_id" value="<%=memberId%>">
						  <input type="hidden" name="<%=jspTabunganSukarela.colNames[JspTabunganSukarela.JSP_MEMBER_ID]%>" value="<%=memberId%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="7%"><b>&nbsp;NIK</b></td>
                                          <td width="24%"><b>: &nbsp;<%=member.getNoMember()%></b></td>
                                          <td width="6%"><b>Dinas</b></td>
                                          <td width="63%"><b>: &nbsp;<%=dinas.getNama()%></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="7%"><b>&nbsp;Nama</b></td>
                                          <td width="24%"><b>: &nbsp;<%=member.getNama()%></b></td>
                                          <td width="6%"><b>Unit </b></td>
                                          <td width="63%"><b>: &nbsp;<%=dinasUnit.getNama()%></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="7%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="6%">&nbsp;</td>
                                          <td width="63%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top">
                                    <td height="22" valign="middle" colspan="3">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="3%">No</td>
                                          <td class="tablehdr" width="9%">Nomor</td>
                                          <td class="tablehdr" width="12%">Tanggal</td>
                                          <td class="tablehdr" width="13%">Debet</td>
                                          <td class="tablehdr" width="13%">Kredit</td>
                                          <td class="tablehdr" width="14%">Saldo</td>
                                          <td class="tablehdr" width="11%">Tipe 
                                            Transaksi</td>
                                          <td class="tablehdr" width="25%">Keterangan</td>
                                        </tr>
                                        <%
										if(listTabunganSukarela!=null && listTabunganSukarela.size()>0){
										for(int i=0; i<listTabunganSukarela.size(); i++){
											TabunganSukarela tb = (TabunganSukarela)listTabunganSukarela.get(i);
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell" width="3%"> 
                                            <div align="right"><%=start+i+1%></div>
                                          </td>
                                          <td class="tablecell" width="9%"> 
                                            <div align="center"><%=tb.getNumber()%></div>
                                          </td>
                                          <td class="tablecell" width="12%"> 
                                            <div align="center"><%=JSPFormater.formatDate(tb.getTransDate(), "dd/MM/yyyy")%></div>
                                          </td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getCredit(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="14%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getSaldo(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="11%"> 
                                            <div align="center"><%=DbTabunganSukarela.strType[tb.getType()]%></div>
                                          </td>
                                          <td class="tablecell" width="25%"><%=tb.getNote()%></td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell1" width="3%"> 
                                            <div align="right"><%=start+i+1%></div>
                                          </td>
                                          <td class="tablecell1" width="9%"> 
                                            <div align="center"><%=tb.getNumber()%></div>
                                          </td>
                                          <td class="tablecell1" width="12%"> 
                                            <div align="center"><%=JSPFormater.formatDate(tb.getTransDate(), "dd/MM/yyyy")%></div>
                                          </td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getCredit(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="14%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getSaldo(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="11%"> 
                                            <div align="center"><%=DbTabunganSukarela.strType[tb.getType()]%></div>
                                          </td>
                                          <td class="tablecell1" width="25%"><%=tb.getNote()%></td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                 
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
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspTabunganSukarela.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">&nbsp;</td>
                                    <td height="21" colspan="2" width="88%" class="comment" valign="top">*)= 
                                      required</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" width="12%">Tanggal Transaksi</td>
                                    <td height="21" colspan="2" width="88%"><%=	JSPDate.drawDateWithStyle(jspTabunganSukarela.colNames[JspTabunganSukarela.JSP_TRANS_DATE], (tabunganSukarela.getTransDate()==null) ? new Date() : tabunganSukarela.getTransDate(), 0,0, "formElemen", "") %> <%= jspTabunganSukarela.getErrorMsg(jspTabunganSukarela.JSP_TRANS_DATE) %> 
                                  <tr align="left"> 
                                    <td height="21" width="12%">Tipe Transaksi</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <% Vector type_value = new Vector(1,1);
										Vector type_key = new Vector(1,1);
										String sel_type = ""+tabunganSukarela.getType();
										for(int i=0; i<DbTabunganSukarela.strType.length; i++){
										   type_key.add(""+i);
										   type_value.add(""+DbTabunganSukarela.strType[i]);
									    }
					   					%>
                                      <%= JSPCombo.draw(jspTabunganSukarela.colNames[JspTabunganSukarela.JSP_TYPE],null, sel_type, type_key, type_value, "", "formElemen") %> 
                                  <tr align="left"> 
                                    <td height="21" width="12%">Jumlah</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspTabunganSukarela.colNames[JspTabunganSukarela.JSP_JUMLAH] %>"  value="<%= tabunganSukarela.getJumlah() %>" class="formElemen" style="text-align:right" onClick="this.select()">
                                      <%= jspTabunganSukarela.getErrorMsg(jspTabunganSukarela.JSP_JUMLAH) %> 
                                  <tr align="left"> 
                                    <td height="21" width="12%">Keterangan</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <textarea name="<%=jspTabunganSukarela.colNames[JspTabunganSukarela.JSP_NOTE] %>" class="formElemen" cols="40" rows="2"><%= tabunganSukarela.getNote() %></textarea>
                                  <tr align="left"> 
                                    <td height="5" colspan="3"></td>
                                  
                                  <tr align="left" bgcolor="#CCCCCC"> 
                                    <td height="25" width="12%"><i><font color="#0000FF">Jika 
                                      Tabungan/Penarikan</font> </i> </td>
                                    <td height="25" colspan="2" width="88%" valign="top">&nbsp; 
                                  <tr align="left" bgcolor="#CCCCCC"> 
                                    <td height="27" width="12%">Disimpan ke/Diambil 
                                      Dari </td>
                                    <td height="27" colspan="2" width="88%"> 
                                      <%
												Vector temp = new Vector();
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													%>
                                      <select name="<%=jspTabunganSukarela.colNames[jspTabunganSukarela.JSP_CASH_BANK_COA_ID] %>">
                                        <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                        <option value="<%=cx.getOID()%>" <%if(tabunganSukarela.getCashBankCoaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                        <%}%>
                                      </select>
                                      <%}%>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="12%">&nbsp;</td>
                                    <td height="8" colspan="2" width="88%" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="3" class="command" valign="top"> 
                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidTabunganSukarela+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidTabunganSukarela+"')";
									String scancel = "javascript:cmdEdit('"+oidTabunganSukarela+"')";
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
                                    <td width="12%">&nbsp;</td>
                                    <td width="88%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="3" valign="top"> 
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
