 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
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
iErrCode = ctrlCoa.action(iJSPCommand , oidCoa, 0, 0);
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

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- #BeginTemplate "/Templates/clean.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title>Account Chart List  - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdAdd(){
	document.frmcoa.hidden_coa_id.value="0";
	document.frmcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}

function cmdAsk(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.ASK%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}

function cmdConfirmDelete(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}
function cmdSave(){
	document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
	}

function cmdEdit(oidCoa, code, name, depid, secid, type){
		self.opener.frmjournal.coa_name.value=code+" - "+name;		
		self.opener.frmjournal.<%=JspJournalDetail.colNames[JspJournalDetail.JSP_COA_ID]%>.value=oidCoa;		
		self.opener.frmjournal.<%=JspJournalDetail.colNames[JspJournalDetail.JSP_DEPARTMENT_ID]%>.value=depid;
		self.opener.frmjournal.<%=JspJournalDetail.colNames[JspJournalDetail.JSP_SECTION_ID]%>.value=secid;
		
		if(type=='<%=I_Project.ACC_GROUP_EXPENSE%>'){
			self.opener.act.style.display="";
		}
		else{
			self.opener.act.style.display="none";
		}
		self.close();	
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
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}

function cmdBack(){
	document.frmcoa.command.value="<%=JSPCommand.BACK%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
	}

function cmdListFirst(){
	document.frmcoa.command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}

function cmdListPrev(){
	document.frmcoa.command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
	}

function cmdListNext(){
	document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.action="coa.jsp";
	document.frmcoa.submit();
}

function cmdListLast(){
	document.frmcoa.command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.action="coa.jsp";
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
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
<center>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr> 
      <td valign="top"> 
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
          <!--DWLayoutTable-->
          <tr> 
            <td width="7" valign="top"  height="40"><img src="<%=approot%>/images/spacer.gif" width="3" height="1"></td>
            <td height="40" valign="top" > <!-- #BeginEditable "content" --> 
              <form name="frmcoa" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3"></td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="14" valign="middle" colspan="3" class="comment"><i>Please 
                            select one of the account in the list.</i></td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3" class="comment">Account 
                            Group&nbsp;&nbsp;&nbsp;&nbsp; 
                            <select name="groupType" onChange="javascript:cmdAccGroup()">
                              <option value="All" <%if(grpType.equals("All")) { %>selected<%}%>>All</option>
                              <%for(int i=0; i<I_Project.accGroup.length; i++){%>
                              <option value="<%=I_Project.accGroup[i]%>" <%if(I_Project.accGroup[i].equals(grpType)){%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                              <%}%>
                            </select>
                          </td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3"> 
                            <table width="95%" border="0" cellpadding="1" height="20" cellspacing="1">
                              <tr> 
                                <td width="38%" class="tablehdr"> 
                                  <div align="center"><b><font color="#FFFFFF">Account</font></b></div>
                                </td>
                                <td width="19%" class="tablehdr">Account Group</td>
                                <td width="24%" class="tablehdr">Department</td>
                                <td width="19%" class="tablehdr">Acc. Type</td>
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
							  %>
                              <tr> 
                                <td width="38%" class="tablecell" nowrap>
								<%if(coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){%>
								<%=str+"<a href=\"javascript:cmdEdit('"+coa.getOID()+"','"+coa.getCode()+"','"+coa.getName()+"','"+coa.getDepartmentId()+"','"+coa.getSectionId()+"','"+coa.getAccountGroup()+"')\">"+coa.getCode()+" - "+coa.getName()+"</a>"%>
								<%}else{%>
								<%=str+coa.getCode()+" - "+coa.getName()%>
								<%}%></td>
                                <td width="19%" class="tablecell" nowrap><%=coa.getAccountGroup()%></td>
                                <td width="24%" class="tablecell" nowrap> 
                                  <%
								Department d = new Department();
								try{	
									d = DbDepartment.fetchExc(coa.getDepartmentId());
								}
								catch(Exception e){
								}
								out.println(d.getName());
								%>
                                </td>
                                <td width="19%" class="tablecell" nowrap> 
                                  <div align="center"><%=coa.getStatus()%></div>
                                </td>
                              </tr>
                              <%}}%>
                              <tr> 
                                <td width="38%" class="tablecell">&nbsp;</td>
                                <td width="19%" class="tablecell">&nbsp;</td>
                                <td width="24%" class="tablecell">&nbsp;</td>
                                <td width="19%" class="tablecell">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <%
							try{
								if (listCoa.size()>0){
							%>
                        <tr align="left" valign="top"> 
                          <td height="0" valign="middle" colspan="3">&nbsp; </td>
                        </tr>
                        <%  } 
						  }catch(Exception exc){ 
						  		out.println(exc.toString());
						  }%>
                        <!--tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                            New</u></a></td>
                        </tr-->
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                  </tr>
                </table>
				
				<script language="JavaScript">
				window.focus();				
				</script>
              </form>
            
              <!-- #EndEditable --></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="1" valign="top"><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
    </tr>
  </table>
</center>
</body>
<!-- #EndTemplate -->
</html>
