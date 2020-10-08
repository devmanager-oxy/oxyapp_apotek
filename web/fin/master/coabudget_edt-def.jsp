 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
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
<%
boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA);
boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA, AppMenu.PRIV_VIEW);
boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long coaId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("50%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Code","20%");
		ctrlist.addHeader("Name","20%");
		ctrlist.addHeader("Level","20%");
		ctrlist.addHeader("Department Name","20%");
		ctrlist.addHeader("Section Name","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Coa coa = (Coa)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(coaId == coa.getOID())
				 index = i;

			rowx.add(coa.getCode());

			rowx.add(coa.getName());

			rowx.add(String.valueOf(coa.getLevel()));

			rowx.add(coa.getDepartmentName());

			rowx.add(coa.getSectionName());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(coa.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
String grpType = JSPRequestValue.requestString(request, "groupType");
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
String accGroup = JSPRequestValue.requestString(request, "acc_group");
if(iJSPCommand==JSPCommand.NONE && grpType.length()==0){
	grpType = I_Project.accGroup[0];
}
/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";//account_group='"+accGroup+"'";
if (grpType.equals(""))
	grpType = "All";
if (grpType.equals("All"))
	whereClause = "";
else
	whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " = '"+ grpType + "'"; 
String orderClause = "code";



CmdCoa ctrlCoa = new CmdCoa(request);
JSPLine ctrLine = new JSPLine();
Vector listCoa = new Vector(1,1);

/*switch statement */

iErrCode = ctrlCoa.action(iJSPCommand , oidCoa, 0, 0, 0, sysCompany.getOID());
/* end switch*/
JspCoa jspCoa = ctrlCoa.getForm();

/*count list All Coa*/
int vectSize = DbCoa.getCount(whereClause);
recordToGet = vectSize;

Coa coa = ctrlCoa.getCoa();
msgString =  ctrlCoa.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCoa.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCoa = DbCoa.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCoa.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCoa = DbCoa.list(start,recordToGet, whereClause , orderClause);
}

//out.println("listCoa : "+listCoa);
Date dt = new Date();
int yearx = JSPRequestValue.requestInt(request, "budget_year");
if(yearx!=0){
	yearx = yearx - 1900;
	dt.setYear(yearx);
}

//out.println("dt :"+dt);

Vector v = DbPeriode.getAllPeriodInYear(dt);

//out.println(v);

//saving data to db
if(iJSPCommand==JSPCommand.SAVE && listCoa!=null && listCoa.size()>0 && v!=null && v.size()>0){
	for(int i=0; i<listCoa.size(); i++){		
		Coa coax = (Coa)listCoa.get(i);		
		for(int x=0; x<v.size(); x++){
			Periode px = (Periode)v.get(x);			
			double amn = JSPRequestValue.requestDouble(request, "bgt_"+coax.getOID()+"_"+px.getOID());
			
			//out.println("<br>coa : "+coax.getOID()+", periode : "+px.getOID()+", amn : "+amn);
			
			long oid = DbCoaBudget.processBudget(coax.getOID(), px.getOID(), amn);			
			//out.println("oidBusget : "+oid);
		}		
	}	
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!masterPriv || !masterPrivView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function checkNumber(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	cmdTotal();
}


function cmdAdd(){
	document.frmcoa.hidden_coa_id.value="0";
	document.frmcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function cmdAsk(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.ASK%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function cmdConfirmDelete(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}
function cmdSave(){
	document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
	}

function cmdEdit(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coaedt.jsp";
	document.frmcoa.submit();
	}

function cmdToEditor(){
	//alert(document.frmcoa.menu_index.value);
	document.frmcoa.hidden_coa_id.value=0;
	document.frmcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coaedt.jsp";
	document.frmcoa.submit();
}	

function cmdCancel(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function cmdBack(){
	document.frmcoa.command.value="<%=JSPCommand.BACK%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
	}

function cmdListFirst(){
	document.frmcoa.command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function cmdListPrev(){
	document.frmcoa.command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
	}

function cmdListNext(){
	document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function cmdListLast(){
	document.frmcoa.command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.action="coabudget_edt.jsp";
	document.frmcoa.submit();
}

function printXLS(){	 
	window.open("<%=printroot%>.report.RptCoaFlatXLS");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  				
}

function cmdAccGroup(){
	document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/printxls2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Budgeting</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcoa" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="15" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tab"> 
                                            <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin"> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Editor</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  
								  
								  
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                        <tr> 
                                          <td width="23%" height="41">Account 
                                            Group&nbsp;&nbsp;&nbsp;&nbsp; 
                                            <select name="groupType" onChange="javascript:cmdAccGroup()">
                                              <option value="All" <%if(grpType.equals("All")) { %>selected<%}%>>All</option>
                                              <%for(int i=0; i<I_Project.accGroup.length; i++){%>
                                              <option value="<%=I_Project.accGroup[i]%>" <%if(I_Project.accGroup[i].equals(grpType)){%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                              <%}%>
                                            </select>
                                          </td>
                                          <td height="41" colspan="<%=v.size()%>">Budget/Target 
                                            Year&nbsp;&nbsp;&nbsp;&nbsp; 
                                            <%
											int curryear = (new Date()).getYear() + 1900;
											%>	
											 
                                            <select name="budget_year" onChange="javascript:cmdAccGroup()">
                                              <option value="<%=curryear%>" <%if(yearx==(curryear-1900)){%>selected<%}%>><%=curryear%></option>
											  <option value="<%=curryear-1%>" <%if(yearx==(curryear-1-1900)){%>selected<%}%>><%=curryear-1%></option>
											  <option value="<%=curryear-2%>" <%if(yearx==(curryear-2-1900)){%>selected<%}%>><%=curryear-2%></option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="23%" class="tablehdr" height="22"> 
                                            <div align="center"><b><font color="#FFFFFF">Account</font></b></div>
                                          </td>
										  <%if(v!=null && v.size()>0){
										  for(int x=0; x<v.size(); x++){
										  	Periode px = (Periode)v.get(x);
										  %>
                                          <td class="tablehdr" height="22"><%=JSPFormater.formatDate(px.getStartDate(), "MMM yyyy")%> 
                                          </td>
										  <%}}%>
                                        </tr>
                                        <%if(listCoa!=null && listCoa.size()>0){								
							  	for(int i=0; i<listCoa.size(); i++){
									coa = (Coa)listCoa.get(i);
									String str = "";
									switch(coa.getLevel()){
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
									
									String cssString = "tablecell";
									if(i%2!=0){
										cssString = "tablecell1";
									}
									
									
							  %>
                                        <tr> 
                                          <td width="23%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=str+"<a href=\"javascript:cmdEdit('"+coa.getOID()+"')\">"+coa.getCode()+" - "+coa.getName()+"</a>"%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
										  <%if(v!=null && v.size()>0){
										  for(int x=0; x<v.size(); x++){
										  	Periode px = (Periode)v.get(x);
											
											CoaBudget cBudget = DbCoaBudget.getBudget(coa.getOID(), px.getOID());
											
										  %>
                                          <td class="<%=cssString%>"> 
                                            <%if(!coa.getStatus().equals("HEADER")){%>
                                            <div align="center"> 
                                              <input type="text" name="bgt_<%=coa.getOID()+"_"+px.getOID()%>" size="15" value="<%=(cBudget.getAmount()==0) ? "" : JSPFormater.formatNumber(cBudget.getAmount(), "#,###")%>" onClick="this.select()" onBlur="javascript:checkNumber(this)" style="text-align:right">
                                            </div>
                                            <%}%>
                                          </td>
										  <%}}%>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="23%" class="tablecell">&nbsp;</td>										  
                                          <td class="tablecell" colspan="<%=v.size()%>">&nbsp;</td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td width="23%">&nbsp;</td>
                                          <td colspan="<%=v.size()%>">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="23%">&nbsp; </td>
                                          <td colspan="<%=v.size()%>">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <%
							try{
								if (listCoa.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="0" valign="middle" colspan="3"> 
                                      <%//= drawList(listCoa,oidCoa)%>
                                    </td>
                                  </tr>
                                  <%  } 
						  }catch(Exception exc){ 
						  		out.println(exc.toString());
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
                                    <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdSave()" class="command"><u>SAVE 
                                      BUDGET </u></a></td>
                        </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <%if(false){//listCoa!=null && listCoa.size()>0){%>
                                <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="71">
                                      <%if(masterPrivUpdate){%>
                                      <%}else{%>
                                      <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" width="120" height="22" border="0"></a> 
                                      <%}%>
                                    </td>
                                    <td width="45">&nbsp;</td>
                                    <td width="76">
                                      <%if(masterPrivUpdate){%>
                                      <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" width="120" height="22" border="0">
                                      <%}%>
                                      </a></td>
                                    <td width="176">&nbsp;</td>
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
