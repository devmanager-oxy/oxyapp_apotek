 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
boolean privAdd=true; boolean privUpdate=true; boolean privDelete=true;
%>

<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidRptFormatDetailCoa = JSPRequestValue.requestLong(request, "hidden_rpt_format_detail_coa_id");
long oidRptFormatDetail = JSPRequestValue.requestLong(request, "hidden_rpt_format_detail_id");
int checkOnly = JSPRequestValue.requestInt(request, "check_only");
int selectUntil = JSPRequestValue.requestInt(request, "select_until");
long departmentId = JSPRequestValue.requestLong(request, "department_id");
String accGroup = JSPRequestValue.requestString(request, "acc_group");

Vector departments = DbDepartment.list(0,0, "", "code");

if(selectUntil==0){
	selectUntil = 1;
}

if(checkOnly==1){
	selectUntil = 5;
}

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

String where = "";
if(selectUntil>0){
	
	for(int x=0; x<selectUntil; x++){
		where = where + "level="+(x+1)+" or ";
	}		
	where = "("+where.substring(0,where.length()-3)+")";
}

if(accGroup!=null && accGroup.length()>0){
	if(where.length()>0) where = where + " and ";
	where = where +" account_group='"+accGroup+"'";
}

Vector coas = DbCoa.list(0,0, where, "code");

if(iJSPCommand==JSPCommand.SAVE && coas!=null && coas.size()>0){
	Vector checkeds = new Vector();
	for(int i=0; i<coas.size(); i++){	
		Coa coax = (Coa)coas.get(i);
		int chk = JSPRequestValue.requestInt(request, "chk_"+coax.getOID());
		if(chk==1){
			RptFormatDetailCoa rfd = new RptFormatDetailCoa();
			rfd.setDepId(departmentId);
			rfd.setCoaId(coax.getOID());
			rfd.setIsMinus(JSPRequestValue.requestInt(request, "operator_"+coax.getOID()));
			rfd.setRptFormatDetailId(oidRptFormatDetail);
			checkeds.add(rfd);
		}
	}
	
	DbRptFormatDetailCoa.updateList(oidRptFormatDetail, checkeds);
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
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdSelect(coaid, coaname){                
	self.opener.document.frmgl.coa_txt.value = coaname;
	self.opener.document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>.value = coaid;           
	self.close();
}

function cmdChangeList(){
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();	
}

function cmdAdd(){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value="0";
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdAsk(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.ASK%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdConfirmDelete(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.DELETE%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}
function cmdSave(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.SAVE%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdEdit(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdCancel(oidRptFormatDetailCoa){
	document.frmrptformatdetailcoa.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdBack(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.BACK%>";
	document.frmrptformatdetailcoa.action="rptformatdetail.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdListFirst(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.FIRST%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdListPrev(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.PREV%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
	}

function cmdListNext(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.NEXT%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

function cmdListLast(){
	document.frmrptformatdetailcoa.command.value="<%=JSPCommand.LAST%>";
	document.frmrptformatdetailcoa.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmrptformatdetailcoa.action="coalist.jsp";
	document.frmrptformatdetailcoa.submit();
}

//-------------- script control line -------------------
//-->
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
                    <tr> 
                      <td class="title">&nbsp; </td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td> 
                        <form name="frmrptformatdetailcoa" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_rpt_format_detail_coa_id" value="<%=oidRptFormatDetailCoa%>">
                          <input type="hidden" name="hidden_rpt_format_detail_id" value="<%=oidRptFormatDetail%>">
                          <input type="hidden" name="hidden_rpt_format_id" value="<%=format.getOID()%>">
                          <input type="hidden" name="<%=jspRptFormatDetailCoa.colNames[JspRptFormatDetailCoa.JSP_RPT_FORMAT_DETAIL_ID] %>" value="<%=oidRptFormatDetail%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="90%" border="0" cellspacing="1" cellpadding="1">
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="8%" nowrap>Level Sampai&nbsp;&nbsp;</td>
                                                <td width="14%" nowrap> 
                                                  <select name="select_until">
                                                    <option value="1" <%if(selectUntil==1){%>selected<%}%>>1</option>
                                                    <option value="2" <%if(selectUntil==2){%>selected<%}%>>2</option>
                                                    <option value="3" <%if(selectUntil==3){%>selected<%}%>>3</option>
                                                    <option value="4" <%if(selectUntil==4){%>selected<%}%>>4</option>
                                                    <option value="5"  <%if(selectUntil==5){%>selected<%}%>>5</option>
                                                  </select>
                                                </td>
                                                <td width="11%" nowrap>Group</td>
                                                <td width="11%" nowrap> 
                                                  <select name="acc_group">
                                                    <option value="">-</option>
                                                    <%for(int i=0; i<I_Project.accGroup.length; i++){%>
                                                    <option value="<%=I_Project.accGroup[i]%>" <%if(accGroup.equals(I_Project.accGroup[i])){%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                    <%}%>
                                                  </select>
                                                  &nbsp;&nbsp;&nbsp; </td>
                                                <td width="11%" nowrap>&nbsp; 
                                                  <input type="button" name="Button" value="Search" onClick="cmdChangeList()">
                                                </td>
                                                <td width="67%" nowrap> 
                                                  <div align="left"> </div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%" nowrap class="tablehdr">Code 
                                            - Description</td>
                                          <td height="22" valign="middle" width="6%" nowrap class="tablehdr">Status</td>
                                          <td height="22" valign="middle" width="6%" nowrap class="tablehdr">Level</td>
                                        </tr>
                                        <% 
											
										   Vector coaid_value = new Vector(1,1);
										   Vector coaid_key = new Vector(1,1);
										   String sel_coaid = ""+rptFormatDetailCoa.getCoaId();
										   
										   
										   
										   String str = "";
										   
										   if(coas!=null && coas.size()>0){
											   for(int x=0; x<coas.size(); x++){
													
													Coa coax = (Coa)coas.get(x);	
											   
											   		str = "&nbsp;&nbsp;";
													
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
													
													
													int count = 0;//DbRptFormatDetailCoa.getCount("rpt_format_detail_id="+oidRptFormatDetail+" and coa_id="+coax.getOID());	
													Vector temp = DbRptFormatDetailCoa.list(0,1, "rpt_format_detail_id="+oidRptFormatDetail+" and coa_id="+coax.getOID(), "");	
													RptFormatDetailCoa rfd = new RptFormatDetailCoa();
													if(temp!=null && temp.size()>0){
														count = 1;
														rfd = (RptFormatDetailCoa)temp.get(0);
													}
													
													Department dept = new Department();
													if(rfd.getDepId()!=0){													
														try{
															dept = DbDepartment.fetchExc(rfd.getDepId());
														}
														catch(Exception e){
														}
													}
													
													if(checkOnly!=1){
													
													if(coax.getStatus().equals("HEADER")){
											  
													   %>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"><b><font size="1"><%=str+coax.getCode()+ " - "+coax.getName()%></font></b></td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getStatus()%></b></font></div>
                                          </td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getLevel()%></b></font></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"><font size="1"><a href="javascript:cmdSelect('<%=coax.getOID()%>','<%=coax.getCode()+" - "+coax.getName()%>')"><%=str+coax.getCode()+ " - "+coax.getName()%></a></font></td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getStatus()%></b></font></div>
                                          </td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"><font size="1"><%=coax.getLevel()%></font></div>
                                          </td>
                                        </tr>
                                        <%}
													}else if(count>0){
													
													if(coax.getStatus().equals("HEADER")){
											  
													   %>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"><b><font size="1"><%=str+coax.getCode()+ " - "+coax.getName()%></font></b></td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getStatus()%></b></font></div>
                                          </td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell1<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getLevel()%></b></font></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"><font size="1"><a href="javascript:cmdSelect('<%=coax.getOID()%>','<%=coax.getCode()+" - "+coax.getName()%>')"><%=str+coax.getCode()+ " - "+coax.getName()%></a></font></td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"><font size="1"><b><%=coax.getStatus()%></b></font></div>
                                          </td>
                                          <td height="22" valign="middle" width="6%" nowrap class="<%if(count>0){%>tablecellselect<%}else{%>tablecell<%}%>"> 
                                            <div align="center"><font size="1"><%=coax.getLevel()%></font></div>
                                          </td>
                                        </tr>
                                        <%}
													}
										 	}
										}%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" width="36%" class="command">&nbsp;</td>
                                          <td height="8" align="left" width="6%" class="command">&nbsp;</td>
                                          <td height="8" align="left" width="6%" class="command">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" width="36%">&nbsp;</td>
                                          <td height="22" valign="middle" width="6%">&nbsp;</td>
                                          <td height="22" valign="middle" width="6%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
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
          <td height="25">&nbsp; </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script language="JavaScript">
window.focus();
</script>
</body>
</html>
