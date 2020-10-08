 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
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

	public String drawList(Vector objectClass ,  long rptFormatDetailCoaId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Rpt Format Detail Id","50%");
		ctrlist.addHeader("Coa Id","50%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			RptFormatDetailCoa rptFormatDetailCoa = (RptFormatDetailCoa)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(rptFormatDetailCoaId == rptFormatDetailCoa.getOID())
				 index = i;

			rowx.add(String.valueOf(rptFormatDetailCoa.getRptFormatDetailId()));

			rowx.add(String.valueOf(rptFormatDetailCoa.getCoaId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(rptFormatDetailCoa.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidRptFormatDetailCoa = JSPRequestValue.requestLong(request, "hidden_rpt_format_detail_coa_id");
long oidRptFormatDetail = JSPRequestValue.requestLong(request, "hidden_rpt_format_detail_id");

RptFormatDetail formatDetail = new RptFormatDetail();
RptFormat format = new RptFormat();
try{
	formatDetail = DbRptFormatDetail.fetchExc(oidRptFormatDetail);
	format = DbRptFormat.fetchExc(formatDetail.getRptFormatId());
}
catch(Exception e){
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdRptFormatDetailCoa ctrlRptFormatDetailCoa = new CmdRptFormatDetailCoa(request);
JSPLine ctrLine = new JSPLine();
Vector listRptFormatDetailCoa = new Vector(1,1);

/*switch statement */
iErrCode = ctrlRptFormatDetailCoa.action(iJSPCommand , oidRptFormatDetailCoa);
/* end switch*/
JspRptFormatDetailCoa jspRptFormatDetailCoa = ctrlRptFormatDetailCoa.getForm();

/*count list All RptFormatDetailCoa*/
int vectSize = DbRptFormatDetailCoa.getCount(whereClause);

RptFormatDetailCoa rptFormatDetailCoa = ctrlRptFormatDetailCoa.getRptFormatDetailCoa();
msgString =  ctrlRptFormatDetailCoa.getMessage();

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlRptFormatDetailCoa.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listRptFormatDetailCoa = DbRptFormatDetailCoa.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listRptFormatDetailCoa.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listRptFormatDetailCoa = DbRptFormatDetailCoa.list(start,recordToGet, whereClause , orderClause);
}

/*** LANG ***/
String[] langMD = {"COA List", "Description", "COA", //0-2
"Type", "required", "Squence", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section"}; //3-11

String[] langNav = {"Masterdata", "Report Setup", "All"};

if(lang == LANG_ID) {
	String[] langID = {"Daftar Perkiraan", "Uraian", "Perkiraan",
	"Tipe", "harap diisi", "No Urut Tampilan", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian"};
	langMD = langID;
	
	String[] navID = {"Data Induk", "Setup Laporan", "Semua"};
	langNav = navID;
}

%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<title>sia-btdc--</title>
<script language="JavaScript">

function cmdAdd(){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value="0";
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdAsk(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.ASK%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdConfirmDelete(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.DELETE%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}
function cmdSave(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.SAVE%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdEdit(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdCancel(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdBack(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.BACK%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdListFirst(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.FIRST%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdListPrev(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.PREV%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdListNext(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.NEXT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdListLast(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.LAST%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmrptformatdetailcoa.action="rptformatdetailcoa.jsp";
	document.frmrptformatdetailcoa.submit();
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
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td> 
                        <form name="frmrptformatdetailcoa" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_rpt_format_detail_coa_id" value="<%=oidRptFormatDetailCoa%>">
                          <input type="hidden" name="hidden_rpt_format_detail_id" value="<%=oidRptFormatDetail%>">
                          <input type="hidden" name="<%=jspRptFormatDetailCoa.colNames[JspRptFormatDetailCoa.JSP_RPT_FORMAT_DETAIL_ID] %>" value="<%=oidRptFormatDetail%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" width="24%">&nbsp;</td>
                                          <td height="8" valign="middle" width="3%">&nbsp;</td>
                                          <td height="8" valign="middle" colspan="3" width="73%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="5"><font color="#990000"><b>Nama 
                                            Laporan :&nbsp;<%=format.getName()%></b></font></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="5"><font color="#990000"><b>Nama 
                                            Uraian :&nbsp;<%=formatDetail.getDescription()%></b></font></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" width="24%">&nbsp;</td>
                                          <td height="8" valign="middle" width="3%">&nbsp;</td>
                                          <td height="8" valign="middle" colspan="3" width="73%">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" width="24%" class="comment"><b><%=langMD[0]%></b></td>
                                          <td height="14" valign="middle" class="comment" width="3%">&nbsp;</td>
                                          <td height="14" valign="middle" colspan="3" class="comment" width="73%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="24%" nowrap class="tablehdr">Code 
                                            - Description</td>
                                          <td height="22" valign="middle" width="3%" class="tablehdr">Level</td>
                                          <td height="22" valign="middle" colspan="3" width="73%" class="tablehdr">Select</td>
                                        </tr>
                                        <% 
											
										   Vector coaid_value = new Vector(1,1);
										   Vector coaid_key = new Vector(1,1);
										   String sel_coaid = ""+rptFormatDetailCoa.getCoaId();
										   
										   Vector coas = DbCoa.list(0,0, "", "code");
										   String str = "";
										   
										   if(coas!=null && coas.size()>0){
											   for(int x=0; x<coas.size(); x++){
													
													Coa coax = (Coa)coas.get(x);	
											   
													switch(coax.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
													}
													
													
													int count = DbRptFormatDetailCoa.getCount("rpt_format_detail_id="+oidRptFormatDetail+" and coa_id="+coax.getOID());	
													
													if(coax.getStatus().equals("HEADER")){
											  
										   %>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="24%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"><b><%=str+coax.getCode()+ " "+coax.getName()%>&nbsp;&nbsp;</b></td>
                                          <td height="22" valign="middle" width="3%" class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"><b><%=coax.getLevel()%></b></div>
                                          </td>
                                          <td height="22" valign="middle" colspan="3" width="73%" class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"> 
                                              <input type="checkbox" name="chk_<%=coax.getOID()%>" value="1" <%if(count>0){%>checked<%}%>>
                                            </div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="24%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"><%=str+coax.getCode()+ " "+coax.getName()%>&nbsp;&nbsp;</td>
                                          <td height="22" valign="middle" width="3%" class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"><%=coax.getLevel()%></div>
                                          </td>
                                          <td height="22" valign="middle" colspan="3" width="73%" class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"> 
                                              <input type="checkbox" name="chk_<%=coax.getOID()%>" value="1" <%if(count>0){%>checked<%}%>>
                                            </div>
                                          </td>
                                        </tr>
                                        <%}
										 	}
										}%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" width="24%" class="command">&nbsp;</td>
                                          <td height="8" align="left" class="command" width="3%">&nbsp;</td>
                                          <td height="8" align="left" colspan="3" class="command" width="73%"> 
                                            <span class="command"> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="24%">&nbsp;</td>
                                          <td height="22" valign="middle" width="3%">&nbsp;</td>
                                          <td height="22" valign="middle" colspan="3" width="73%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25">&nbsp; </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
