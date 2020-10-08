
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%@ include file = "../main/proposaltxt.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long proposalId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Intro Letter Id","12%");
		ctrlist.addHeader("Customer Request Id","12%");
		ctrlist.addHeader("Number","12%");
		ctrlist.addHeader("Subject Indo","12%");
		ctrlist.addHeader("Number Prefix","12%");
		ctrlist.addHeader("Counter","12%");
		ctrlist.addHeader("Subject Eng","12%");
		ctrlist.addHeader("Project Name","12%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Proposal proposal = (Proposal)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(proposalId == proposal.getOID())
				 index = i;

			rowx.add(String.valueOf(proposal.getIntroLetterId()));

			rowx.add(String.valueOf(proposal.getCustomerRequestId()));

			rowx.add(proposal.getNumber());

			rowx.add(proposal.getSubjectIndo());

			rowx.add(proposal.getNumberPrefix());

			rowx.add(String.valueOf(proposal.getCounter()));

			rowx.add(proposal.getSubjectEng());

			rowx.add(proposal.getProjectName());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(proposal.getOID()));
		}

		return ctrlist.drawList(index);
	}
	
	public Proposal getDefaultValue(Proposal proposal){
		
		return proposal;
	}

%>
<%


int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidProposal = JSPRequestValue.requestLong(request, "hidden_proposal_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

if(iJSPCommand==JSPCommand.NONE){
	if(oidProposal==0){
		iJSPCommand=JSPCommand.NONE;
	}
	else{
		iJSPCommand=JSPCommand.EDIT;
	}
}

Vector employees = DbEmployee.list(0,0, "", "");
											
CmdProposal ctrlProposal = new CmdProposal(request);
JSPLine ctrLine = new JSPLine();
Vector listProposal = new Vector(1,1);

/*switch statement */
iErrCode = ctrlProposal.action(iJSPCommand , oidProposal, user.getOID());
/* end switch*/
JspProposal jspProposal = ctrlProposal.getForm();

//out.println(jspProposal.getErrors());

/*count list All Proposal*/
int vectSize = DbProposal.getCount(whereClause);

Proposal proposal = ctrlProposal.getProposal();
msgString =  ctrlProposal.getMessage();

if(oidProposal==0 || iJSPCommand==JSPCommand.APPROVE){
	oidProposal = proposal.getOID();
}

//out.println("masuk");

if(iJSPCommand==JSPCommand.NONE){
	if(oidProposal==0){
		iJSPCommand = JSPCommand.ADD;
		
		proposal.setHeadAddress(propTxt_headAddr);
		proposal.setSubjectIndo(propTxt_halIndo);		
		proposal.setGreatingIndo(propTxt_prakataIndo);
		proposal.setGreatingContentIndo(propTxt_prakataContentIndo);		
		proposal.setProjectName(propTxt_projectName);
		proposal.setYth(propTxt_yth1);
		proposal.setYth1(propTxt_yth2);
		proposal.setDetail1HeadIndo(propTxt_detail1HeaderIndo);
		proposal.setDetail1Content1Indo(propTxt_detail1ContentIndo);
		proposal.setDetail2HeaderIndo(propTxt_detail2HeaderIndo);
		proposal.setDetail2Content1Indo(propTxt_detail2ContentIndo);
		proposal.setDetail3HeaderIndo(propTxt_detail3HeaderIndo);
		proposal.setDetail3Content1Indo(propTxt_detail3ContentIndo);
		proposal.setDetail4HeaderIndo(propTxt_detail4HeaderIndo);
		proposal.setDetail4Content1Indo(propTxt_detail4ContentIndo);
		proposal.setDetail5HeaderIndo(propTxt_detail5HeaderIndo);		
		proposal.setPaymentHeaderIndo(propTxt_detail6HeaderIndo);
		proposal.setPaymentContent1Indo(propTxt_detail6ContentIndo);
		proposal.setPaymentContent1Percent(propTxt_detail6Percent);
		proposal.setClosingTextIndo(propTxt_footerIndo);
		proposal.setApproveAddress(propTxt_headAddr);
		proposal.setApproveRegards(propTxt_headRegardsIndo);
		proposal.setApproveByPosition(propTxt_headRegardsPosition);
		
		proposal.setBankName(propTxt_BankInfoName);
		proposal.setBankNumber(propTxt_BankInfoAccountNumber);
		proposal.setBankHolder(propTxt_BankInfoAccountName);
		
		//out.println("masuk1");
	}
	else{
		iJSPCommand = JSPCommand.EDIT;
	}
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlProposal.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 


CustomerRequest cr = new CustomerRequest();
IntroLetter il = new IntroLetter();
Customer cus = new Customer();
try{
	cus = DbCustomer.fetchExc(proposal.getCustomerId());
}
catch(Exception e){
	System.out.println("exc : "+e.toString());
}
try{	
	il = DbIntroLetter.fetchExc(proposal.getIntroLetterId());
}
catch(Exception e){
	System.out.println("exc : "+e.toString());
}
try{	
	cr = DbCustomerRequest.fetchExc(proposal.getCustomerRequestId());
}
catch(Exception e){
	System.out.println("exc : "+e.toString());
}


listProposal = DbProposal.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listProposal.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listProposal = DbProposal.list(start,recordToGet, whereClause , orderClause);
}

Project project = new Project();
if(proposal.getOID()!=0){
	Vector v = DbProject.list(0,0,"proposal_id="+proposal.getOID(), "");
	if(v!=null && v.size()>0){
		project = (Project)v.get(0);
	}
}

//out.println("appSessUser.getCompanyOID() : "+appSessUser.getCompanyOID());
//out.println("proposal.getOID() " +proposal.getOID());
Vector histories = DbProposal.getProposalRef(proposal);
//out.println(histories);
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<title>crm-proposal</title>
<script language="JavaScript">
<!--

function srcProduct(){
	<%if(oidProposal==0){%>					
		alert("Please, save your proposal data before add proposal product list");
	<%}else{%>
		window.open("productlistnew.jsp?oidIntro=0&proposal_id=<%=oidProposal%>","stock_report","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");	
	<%}%>	
}

function edtProduct(){					
	window.open("productlistnew.jsp?oidIntro=<%=0%>&proposal_id=<%=oidProposal%>","stock_report","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");	
}

function cmdChangeEmp(){
	var oid = document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_APPROVE_BY_ID] %>.value;
	<%if(employees!=null && employees.size()>0){
		for(int i=0; i<employees.size(); i++){
			Employee e = (Employee)employees.get(i);
	%>
			if(oid=="<%=e.getOID()%>"){
				document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_APPROVE_BY_POSITION] %>.value="<%=e.getPosition()%>";
			}
	<%}}%>
}


function cmdProjectDeal(){
	if(confirm("Are you sure to update this proposal to project ?\nThis action is not recoverable, proposal will be locked from any update.")){
		document.frmproposal.command.value="<%=JSPCommand.EDIT%>";
		document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
		document.frmproposal.action="<%=approot%>/project/newproject.jsp";
		document.frmproposal.submit();
	}
}

function revisedProposal(){
	if(confirm("Are you sure to revise this proposal ?\nThis action is not recoverable, this proposal will be locked, \nand a new copy of this proposal will be generated.")){
		document.frmproposal.command.value="<%=JSPCommand.APPROVE%>";
		document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
		document.frmproposal.action="<%=approot%>/project/proposal.jsp";
		document.frmproposal.submit();
	}
}

function cmdPrint(){
	//window.open("<%=printroot%>.report.RptProposalXLS?oid=<%=oidProposal%>&proposal_type=0&company_id=<%=appSessUser.getCompanyOID()%>&whenx=<%=System.currentTimeMillis()%>");//customerlist.jsp?page_target=1","cusiletterlist","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
	window.open("<%=printroot%>.report.RptProposalIndo_PDF?oid=<%=oidProposal%>&imageroot=<%=imageroot%>&proposal_type=0&company_id=<%=appSessUser.getCompanyOID()%>&whenx=<%=System.currentTimeMillis()%>");//customerlist.jsp?page_target=1","cusiletterlist","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
}

function srcCustomer(){
	window.open("customerlist.jsp?page_target=1","cusiletterlist","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
}

function srcIletter(){
	window.open("proposaliletterlist.jsp","iletterlist","scrollbars=yes,height=600,width=800,status=no,toolbar=no,menubar=no,location=no");
}

function cmdClick(){
	
	var x = document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_DIRECT_PROPOSAL]%>.value;
	
	if(parseInt(x)==1){//document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_DIRECT_PROPOSAL]%>.checked){
		document.all.hide1.style.display="none";
		document.all.hide2.style.display="none";
		document.all.hide3.style.display="";
	}
	else{
		document.all.hide1.style.display="";
		document.all.hide2.style.display="";
		document.all.hide3.style.display="none";
	}
	
}

function cmdEng(oid){
	document.frmproposal.command.value="<%=JSPCommand.NONE%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposaleng.jsp";
	document.frmproposal.submit();
}

function cmdAdd(){
	document.frmproposal.hidden_proposal_id.value="0";
	document.frmproposal.command.value="<%=JSPCommand.ADD%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}

function cmdAsk(oidProposal){
	document.frmproposal.hidden_proposal_id.value=oidProposal;
	document.frmproposal.command.value="<%=JSPCommand.ASK%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}

function cmdConfirmDelete(oidProposal){
	document.frmproposal.hidden_proposal_id.value=oidProposal;
	document.frmproposal.command.value="<%=JSPCommand.DELETE%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}
function cmdSave(){
	document.frmproposal.command.value="<%=JSPCommand.SAVE%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
	}

function cmdEdit(oidProposal){
	document.frmproposal.hidden_proposal_id.value=oidProposal;
	document.frmproposal.command.value="<%=JSPCommand.EDIT%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
	}

function cmdCancel(oidProposal){
	document.frmproposal.hidden_proposal_id.value=oidProposal;
	document.frmproposal.command.value="<%=JSPCommand.EDIT%>";
	document.frmproposal.prev_command.value="<%=prevJSPCommand%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}

function cmdBack(){
	document.frmproposal.command.value="<%=JSPCommand.BACK%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
	}

function cmdListFirst(){
	document.frmproposal.command.value="<%=JSPCommand.FIRST%>";
	document.frmproposal.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}

function cmdListPrev(){
	document.frmproposal.command.value="<%=JSPCommand.PREV%>";
	document.frmproposal.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
	}

function cmdListNext(){
	document.frmproposal.command.value="<%=JSPCommand.NEXT%>";
	document.frmproposal.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
}

function cmdListLast(){
	document.frmproposal.command.value="<%=JSPCommand.LAST%>";
	document.frmproposal.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmproposal.action="proposal.jsp";
	document.frmproposal.submit();
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
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/printdoc2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Project</span><span class="level1"></span> 
                        &raquo; <span class="level2"> 
                        <%if(oidProposal==0){%>New <%}%>
                        Proposal Detail<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmproposal" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_proposal_id" value="<%=oidProposal%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="<%=JspProposal.colNames[JspProposal.JSP_COMPANY_ID]%>" value="<%=sysCompany.getOID()%>">
						  <input type="hidden" name="<%=JspProposal.colNames[JspProposal.JSP_USER_ID]%>" value="<%=user.getOID()%>">
						  <input type="hidden" name="page_target" value="1">
						  <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4" >&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <%if(histories!=null && histories.size()>1){%>
                                                <td class="tabin" nowrap><a href="proposalhis.jsp?menu_idx=<%=menuIdx%>&oid=<%=proposal.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink"><b>Proposal 
                                                  History</b></a></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <%}%>
                                                <td class="tab" nowrap>Proposal 
                                                  Detail</td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                <td class="tabin" nowrap><b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=proposal.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Project 
                                                  Detail</a></b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <%}
												
												if(proposal.getOID()>0)	{%>
                                                <td class="tabin" nowrap> <b><a href="newproductdetail.jsp?menu_idx=<%=menuIdx%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Product 
                                                  Detail</a></b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                <td class="tabin" nowrap> <b><a href="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=proposal.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Payment 
                                                  Term</a></b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <%}
												
												if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){
												%>
                                                <td class="tabin" nowrap> <b><a href="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Order 
                                                  Confirmation</a></b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                  <%if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING || project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%>
                                                <td class="tabin" nowrap> <b><a href="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Installation</a></b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                <td class="tabin" nowrap> <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Closing</a></b></td>
                                                <%	}
												}%>
                                                <td nowrap class="tabheader"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000">&nbsp; 
                                                  </font></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="9%">&nbsp;</td>
                                          <td width="31%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="49%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr id="hide1"> 
                                                <td width="23%">Introduction Letter 
                                                </td>
                                                <td width="77%"> 
                                                  <table width="87%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="36%" nowrap> 
                                                        <input type="hidden" name="<%=jspProposal.colNames[JspProposal.JSP_INTRO_LETTER_ID] %>"  value="<%= proposal.getIntroLetterId() %>" class="formElemen">
                                                        <input type="text" name="intro_letter" class="readOnly" value="<%=il.getNumber()%>" readonly>
                                                      </td>
                                                      <td width="64%" nowrap><img src="../images/spacer.gif" width="8" height="8"> 
                                                        <%if(proposal.getStatus()!=I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                        <a href="javascript:srcIletter()"><img src="../images/search.gif" width="59" height="21" border="0"> 
                                                        <%}%>
                                                        </a></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr id="hide2"> 
                                                <td width="23%" nowrap>Customer 
                                                  Request<img src="../images/spacer.gif" width="8" height="8"></td>
                                                <td width="77%"> 
                                                  <input type="hidden" name="<%=jspProposal.colNames[JspProposal.JSP_CUSTOMER_REQUEST_ID] %>"  value="<%= proposal.getCustomerRequestId() %>" class="formElemen">
                                                  <input type="text" name="customer_request" class="readOnly" value="<%=cr.getRequestNumber()%>" readonly>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="23%">Customer </td>
                                                <td width="77%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td nowrap> 
                                                        <input type="hidden" name="<%=jspProposal.colNames[JspProposal.JSP_CUSTOMER_ID] %>"  value="<%= proposal.getCustomerId() %>" class="formElemen">
                                                        <input type="text" name="customer_name" class="readOnly" value="<%=cus.getSalutation()+" "+((cus.getType()==0) ? cus.getName() : (cus.getName()+" "+cus.getMiddleName()+", "+cus.getLastName()))%>" readonly size="50">
                                                        * <%= jspProposal.getErrorMsg(JspProposal.JSP_CUSTOMER_ID) %> </td>
                                                      <td nowrap id="hide3"><a href="javascript:srcCustomer()"><img src="../images/spacer.gif" width="5" height="1" border="0"><img src="../images/search.gif" width="59" height="21" border="0"></a></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="23%">Address</td>
                                                <td width="77%"> 
                                                  <textarea name="customer_address" class="readOnly" readonly="readonly" cols="50" rows="2"><%=cus.getAddress()%></textarea>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td colspan="2" valign="top"> 
                                            <table width="50%" border="0" cellspacing="1" cellpadding="1">
                                              <!--tr> 
                                                <td width="18%"> 
                                                  <div align="right"><img src="../images/spacer.gif" width="10" height="8"> 
                                                    Direct Proposal<img src="../images/spacer.gif" width="10" height="8"> 
                                                  </div>
                                                </td>
                                                <td width="82%"> 
                                                  <%if(proposal.getStatus()!=I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                  <input type="checkbox" name="<%=jspProposal.colNames[JspProposal.JSP_DIRECT_PROPOSAL] %>" value="1" onClick="javascript:cmdClick()" <%if(proposal.getDirectProposal()==1){%>checked<%}%>>
                                                  Yes 
                                                  <%}else{%>
                                                  <input type="hidden" name="<%=jspProposal.colNames[JspProposal.JSP_DIRECT_PROPOSAL] %>" value="<%=proposal.getDirectProposal()%>">
                                                  <%=(proposal.getDirectProposal()==1) ? "YES" : "NO"%> 
                                                  <%}%>
                                                </td>
                                              </tr-->
                                              <tr> 
                                                <td colspan="2" height="78">
                                                  <input type="hidden" name="<%=jspProposal.colNames[JspProposal.JSP_DIRECT_PROPOSAL] %>" value="0">
                                                  <%if(proposal.getOID()!=0){%>
                                                  <table width="99%" border="0" cellspacing="0" cellpadding="0" height="41">
                                                    <tr> 
                                                      <td width="10%" height="5"></td>
                                                      <td width="29%" height="5"></td>
                                                      <td width="61%" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="29%"><b>Doc. 
                                                        Status :</b><b></b></td>
                                                      <td width="61%"> 
                                                        <div align="left"><b><font size="4"><%=I_Crm.proposalStatusStr[proposal.getStatus()]%></font></b></div>
                                                      </td>
                                                    </tr>
                                                    <tr bgcolor="#CCCCCC"> 
                                                      <td colspan="3" height="3"></td>
                                                    </tr>
                                                  </table>
                                                  <%}else{%>
                                                  &nbsp; 
                                                  <%}%>
                                                </td>
                                              </tr>
                                            </table>
                                            <%if(proposal.getOID()!=0 && proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROPOSAL){%>
                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="28%"> 
                                                  <div align="center"><a href="javascript:revisedProposal()"><img src="../images/revised.gif" width="50" height="41" border="0"></a></div>
                                                </td>
                                                <td width="35%"><a href="javascript:cmdProjectDeal()"><img src="../images/approve.gif" width="50" height="43" border="0"></a></td>
                                              </tr>
                                              <tr> 
                                                <td width="28%"> 
                                                  <div align="center"><a href="javascript:revisedProposal()"><u>Revise 
                                                    Proposal</u></a></div>
                                                </td>
                                                <td width="35%"><a href="javascript:cmdProjectDeal()"><u>Set 
                                                  as Project</u></a></td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="9%">&nbsp;</td>
                                          <td width="31%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="49%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                          <td class="tab" nowrap><img src="../images/spacer.gif" width="10" height="1">Bahasa<img src="../images/spacer.gif" width="10" height="1"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                          <td class="tabin" nowrap> <b><img src="../images/spacer.gif" width="10" height="1"><a href="javascript:cmdEng()" class="tablink">English</a><img src="../images/spacer.gif" width="10" height="1"></b></td>
                                          <td nowrap class="tabheader"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000">&nbsp; 
                                            </font></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <%if(proposal.getProposalRefId()!=0){
											
											Proposal oriproposal = new Proposal();
											try{
												oriproposal = DbProposal.fetchExc(proposal.getProposalRefId());
											}
											catch(Exception e){
											}
											
											User propU = new User();
											try{
												propU = DbUser.fetch(oriproposal.getRevisedById());
											}
											catch(Exception e){
											}
											
										%>
                                        <tr align="left"> 
                                          <td height="21" width="11%" bgcolor="#EEEEEE"><b>Original 
                                            Proposal</b></td>
                                          <td height="21" width="32%">&nbsp; 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" colspan="2" bgcolor="#EEEEEE"><a href="proposal.jsp?hidden_proposal_id=<%=oriproposal.getOID()%>&command=<%=JSPCommand.EDIT%>">Number 
                                            : <%=oriproposal.getNumber()%>, Revised Date : <%=JSPFormater.formatDate(oriproposal.getRevisedDate(), "dd MMMM yyyy")%>, Revised By : <%=propU.getFullName()%></a> </td>
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <tr align="left"> 
                                          <td height="21" width="11%">&nbsp;</td>
                                          <td height="21" width="32%">&nbsp; 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nomor</td>
                                          <td height="21" width="32%" nowrap> 
                                            <%
											int cnt = DbProposal.getNextCounter(systemCompanyId);
											String strAbc = proposal.getNumber();
											if(strAbc==null || strAbc.length()==0){
												strAbc = DbProposal.getNextNumber(cnt, systemCompanyId);
											}											 
											%>
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_NUMBER] %>"  value="<%=strAbc%>" class="formElemen" size="60">
                                            * <%= jspProposal.getErrorMsg(JspProposal.JSP_NUMBER) %> 
                                          <td height="21" width="12%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_HEAD_ADDRESS] %>"  value="<%= proposal.getHeadAddress() %>" class="formElemen">
                                          <td height="21" width="45%"> 
                                            <input name="<%=jspProposal.colNames[JspProposal.JSP_DATE] %>" value="<%=JSPFormater.formatDate((proposal.getDate()==null)?new Date():proposal.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Hal</td>
                                          <td height="21" width="32%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_SUBJECT_INDO] %>"  value="<%= (proposal.getSubjectIndo()==null || proposal.getSubjectIndo().length()==0) ? "Proposal Penawaran Produk" : proposal.getSubjectIndo()%>" class="formElemen" size="60">
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">&nbsp;</td>
                                          <td height="21" width="32%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_SUBJECT1_INDO] %>"  value="<%= (proposal.getSubject1Indo()==null || proposal.getSubject1Indo().length()==0) ? "BIO SAVE System" : proposal.getSubject1Indo()%>" class="formElemen" size="60">
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Project 
                                          </td>
                                          <td height="21" width="32%" nowrap> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_PROJECT_NAME] %>"  value="<%= proposal.getProjectName() %>" class="formElemen" size="60">
                                            * <%= jspProposal.getErrorMsg(JspProposal.JSP_PROJECT_NAME) %> 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Alamat Project</td>
                                          <td height="21" width="32%" nowrap> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_ADDRESS] %>"  value="<%= proposal.getAddress() %>" class="formElemen" size="60">
                                            * <%= jspProposal.getErrorMsg(JspProposal.JSP_ADDRESS) %> 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nama Perusahaan</td>
                                          <td height="21" width="32%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="comname"  value="<%= cus.getSalutation()+" "+cus.getName()%>" class="formElemen" size="60">
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nama</td>
                                          <td height="21" width="32%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_YTH1] %>"  value="<%= proposal.getYth1() %>" class="formElemen" size="60">
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Jabatan</td>
                                          <td height="21" width="32%" nowrap> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_YTH] %>"  value="<%= proposal.getYth() %>" class="formElemen" size="60">
                                            * <%= jspProposal.getErrorMsg(JspProposal.JSP_YTH) %> 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Alamat</td>
                                          <td height="21" width="32%" nowrap> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_YTH_ADDRESS] %>"  value="<%= proposal.getYthAddress() %>" class="formElemen" size="60">
                                            * <%= jspProposal.getErrorMsg(JspProposal.JSP_YTH_ADDRESS) %> 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Telephone/Fax/HP</td>
                                          <td height="21" width="32%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_YTH_PHONE] %>"  value="<%= proposal.getYthPhone() %>" class="formElemen" size="60">
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%">&nbsp;</td>
                                          <td height="21" width="32%">&nbsp; 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_GREATING_INDO] %>"  value="<%= proposal.getGreatingIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <textarea <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_GREATING_CONTENT_INDO] %>" class="formElemen" rows="3" cols="150"><%= proposal.getGreatingContentIndo() %></textarea>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_HEAD_INDO] %>"  value="<%= proposal.getDetail1HeadIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT1_NO] %>"  value="1" class="readonly" style="text-align:center" readonly size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT1_INDO] %>"  value="<%= proposal.getDetail1Content1Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT2_NO] %>"  value="2" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT2_INDO] %>"  value="<%= proposal.getDetail1Content2Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT3_NO] %>"  value="3" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT3_INDO] %>"  value="<%= proposal.getDetail1Content3Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT4_NO] %>"  value="4" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT4_INDO] %>"  value="<%= proposal.getDetail1Content4Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT5_NO] %>"  value="5" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL1_CONTENT5_INDO] %>"  value="<%= proposal.getDetail1Content5Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_HEADER_INDO] %>"  value="<%= proposal.getDetail2HeaderIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT1_NO] %>"  value="1" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT1_INDO] %>"  value="<%= proposal.getDetail2Content1Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT2_NO] %>"  value="2" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT2_INDO] %>"  value="<%= proposal.getDetail2Content2Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT3_NO] %>"  value="3" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT3_INDO] %>"  value="<%= proposal.getDetail2Content3Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT4_NO] %>"  value="4" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT4_INDO] %>"  value="<%= proposal.getDetail2Content4Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT5_NO] %>"  value="5" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL2_CONTENT5_INDO] %>"  value="<%= proposal.getDetail2Content5Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_HEADER_INDO] %>"  value="<%= proposal.getDetail3HeaderIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT1_NO] %>"  value="1" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT1_INDO] %>"  value="<%= proposal.getDetail3Content1Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT2_NO] %>"  value="2" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT2_INDO] %>"  value="<%= proposal.getDetail3Content2Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT3_NO] %>"  value="3" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT3_INDO] %>"  value="<%= proposal.getDetail3Content3Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT4_NO] %>"  value="4" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT4_INDO] %>"  value="<%= proposal.getDetail3Content4Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT5_NO] %>"  value="5" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL3_CONTENT5_INDO] %>"  value="<%= proposal.getDetail3Content5Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_HEADER_INDO] %>"  value="<%= proposal.getDetail4HeaderIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT1_NO] %>"  value="1" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT1_INDO] %>"  value="<%= proposal.getDetail4Content1Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT2_NO] %>"  value="2" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT2_INDO] %>"  value="<%= proposal.getDetail4Content2Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT3_NO] %>"  value="3" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT3_INDO] %>"  value="<%= proposal.getDetail4Content3Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT4_NO] %>"  value="4" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT4_INDO] %>"  value="<%= proposal.getDetail4Content4Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT5_NO] %>"  value="5" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT5_INDO] %>"  value="<%= proposal.getDetail4Content5Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT6_NO] %>"  value="6" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT6_INDO] %>"  value="<%= proposal.getDetail4Content6Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT7_NO] %>"  value="7" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL4_CONTENT7_INDO] %>"  value="<%= proposal.getDetail4Content7Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4"></td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_HEADER_INDO] %>"  value="<%= (proposal.getDetail5HeaderIndo().length()==0) ? "Other" : proposal.getDetail5HeaderIndo() %>" size="60">
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT1_NO] %>"  value="1" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT1_INDO] %>"  value="<%= proposal.getDetail5Content1Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT2_NO] %>"  value="2" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT2_INDO] %>"  value="<%= proposal.getDetail5Content2Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT3_NO] %>"  value="3" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT3_INDO] %>"  value="<%= proposal.getDetail5Content3Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT4_NO] %>"  value="4" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT4_INDO] %>"  value="<%= proposal.getDetail5Content4Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"> 
                                                  <input type="text" name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT5_NO] %>"  value="5" class="readonly" style="text-align:center" readonly  size="5">
                                                </td>
                                                <td width="97%"> <img src="../images/spacer.gif" width="3" height="8"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_DETAIL5_CONTENT5_INDO] %>"  value="<%= proposal.getDetail5Content5Indo() %>" class="formElemen" size="140">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="5" colspan="4">&nbsp;</td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4"> 
                                            <textarea <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_CLOSING_TEXT_INDO] %>" class="formElemen" cols="150" rows="3"><%= proposal.getClosingTextIndo() %></textarea>
                                          </td>
                                        <tr align="left"> 
                                          <td height="21" width="11%">&nbsp;</td>
                                          <td height="21" width="32%">&nbsp; 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="87" colspan="2" rowspan="4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="20%">Informasi transfer 
                                                </td>
                                                <td width="80%"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_BANK_NAME] %>"  value="<%= proposal.getBankName() %>" class="formElemen" size="35">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="20%"> Nomor rekening 
                                                </td>
                                                <td width="80%"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_BANK_NUMBER] %>"  value="<%= proposal.getBankNumber() %>" class="formElemen" size="35">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="20%"> Atas nama </td>
                                                <td width="80%"> 
                                                  <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_BANK_HOLDER] %>"  value="<%= proposal.getBankHolder() %>" class="formElemen" size="35">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td height="21" width="12%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_APPROVE_ADDRESS] %>"  value="<%= proposal.getApproveAddress() %>" class="formElemen">
                                          <td height="21" width="45%"> 
                                            <input name="<%=jspProposal.colNames[JspProposal.JSP_APPROVE_DATE] %>" value="<%=JSPFormater.formatDate((proposal.getApproveDate()==null)?new Date():proposal.getApproveDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmproposal.<%=jspProposal.colNames[JspProposal.JSP_APPROVE_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                        <tr align="left"> 
                                          <td height="21" width="12%"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_APPROVE_REGARDS] %>"  value="<%= proposal.getApproveRegards() %>" class="formElemen">
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp; 
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%"> 
                                            <select name="<%=jspProposal.colNames[JspProposal.JSP_APPROVE_BY_ID] %>" onChange="javascript:cmdChangeEmp()">
                                              <%
											if(employees!=null && employees.size()>0){
												for(int i=0; i<employees.size(); i++){
													Employee e = (Employee)employees.get(i);
											
											%>
                                              <option value="<%=e.getOID()%>" <%if(proposal.getApproveById()==e.getOID()){%>selected<%}%>><%=e.getName()%></option>
                                              <%}}%>
                                            </select>
                                          <td height="21" width="45%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" colspan="2">&nbsp;</td>
                                          <td height="21" colspan="2"> 
                                            <input type="text" <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>class="readonly" readonly<%}%> name="<%=jspProposal.colNames[JspProposal.JSP_APPROVE_BY_POSITION] %>"  value="<%= proposal.getApproveByPosition() %>" class="readonly" readonly size="30">
                                        <tr align="left"> 
                                          <td height="8" valign="middle" colspan="2">&nbsp; 
                                          </td>
                                          <td height="8" width="12%" valign="top">&nbsp;</td>
                                          <td height="8" width="45%" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top"> 
                                            <%
									 ctrLine.setLocationImg(approot+"/images/ctr_line");
									 ctrLine.initDefault();
									 ctrLine.setTableWidth("80%");
									 String scomDel = "javascript:cmdAsk('"+oidProposal+"')";
									 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProposal+"')";
									 String scancel = "javascript:cmdEdit('"+oidProposal+"')";
									 ctrLine.setBackCaption("Back to List");
									 ctrLine.setJSPCommandStyle("buttonlink");
									 ctrLine.setDeleteCaption("Delete");
									 ctrLine.setAddCaption("");
						
									 ctrLine.setOnMouseOut("MM_swapImgRestore()");
									 ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									 ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									 //ctrLine.setOnMouseOut("MM_swapImgRestore()");
									 ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									 ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
						
									 ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									 ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
						
									 ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									 ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									 
									 ctrLine.setOnMouseOverAddNew("MM_swapImage('new','','"+approot+"/images/new2.gif',1)");
									 ctrLine.setAddNewImage("<img src=\""+approot+"/images/new.gif\" name=\"new\" height=\"22\" border=\"0\">");
						
									 ctrLine.setWidthAllJSPCommand("90");
									 ctrLine.setErrorStyle("warning");
									 ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									 ctrLine.setQuestionStyle("warning");
									 ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									 ctrLine.setInfoStyle("success");
						
									 ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");
									 
									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}

									if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT || proposal.getStatus()==I_Crm.PROPOSAL_STATUS_REVISED || (privAdd == false  && privUpdate == false)){
										ctrLine.setSaveCaption("");
										ctrLine.setDeleteCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									%>
                                            <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROPOSAL){
												if(iJSPCommand==JSPCommand.APPROVE && iErrCode==0){
													iJSPCommand = JSPCommand.EDIT;
												}
											%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                            <%}else{%>
                                            <b> &nbsp;&nbsp;<font color="#009900">Proposal 
                                            have been 
                                            <%if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_REVISED){%>
                                            REVISED 
                                            <%}else if(proposal.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                            submitted to PROJECT 
                                            <%}%>
                                            </font><br>
                                            </b> 
                                            <%}%>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" height="5"></td>
                                        </tr>
                                        <%if(proposal.getOID()!=0){%>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top"> 
                                            <div align="left"> 
                                              <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                <tr> 
                                                  <td width="11%"><a href="javascript:cmdPrint()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/printdoc2.gif',1)"><img src="../images/printdoc.gif" name="new2" border="0" height="22"></a></td>
                                                  <td width="89%">&nbsp;</td>
                                                </tr>
                                              </table>
                                            </div>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  cmdClick();
						  cmdChangeEmp();
						  </script>
						  <%}
						  catch(Exception e){
						  	out.println(e.toString());
						  }%>
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
