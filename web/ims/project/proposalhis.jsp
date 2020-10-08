
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
<%@ page import = "com.project.ims.*" %>
<%@ page import = "com.project.ims.master.*" %>
<%@ page import = "com.project.ims.production.*" %>
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

if(oidProposal==0){
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
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                        <%if(oidProposal==0){%>
                        New 
                        <%}%>
                        Proposal History<br>
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
                                          <td colspan="4" >&nbsp;
                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <%if(histories!=null && histories.size()>1){%>
                                                <td class="tab" nowrap><b>Proposal 
                                                  History</b></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <%}%>
                                                <td class="tabin" nowrap><a href="proposal.jsp?menu_idx=<%=menuIdx%>&oid=<%=proposal.getOID()%>&hidden_proposal_id=<%=proposal.getOID()%>" class="tablink">Proposal 
                                                  Detail</a></td>
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
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="84%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr">Reg. Date</td>
                                          <td class="tablehdr">Proposal Number</td>
                                          <td class="tablehdr">Reference Number</td>
                                          <td class="tablehdr">Revised Date</td>
                                          <td class="tablehdr">Revised By</td>
                                          <td class="tablehdr">Status</td>
                                        </tr>
                                        <%if(histories!=null && histories.size()>0){
										for(int i=0; i<histories.size(); i++){
											Proposal p = (Proposal)histories.get(i);
											Proposal ref = new Proposal();
											
											try{
												ref = DbProposal.fetchExc(p.getProposalRefId());
											}
											catch(Exception e){
											}
											
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell"><a href="proposal.jsp?hidden_proposal_id=<%=p.getOID()%>&command=<%=JSPCommand.EDIT%>&menu_idx=<%=menuIdx%>"><%=JSPFormater.formatDate(p.getRegDate(), "dd MMMM yyyy")%></a></td>
                                          <td class="tablecell"><%=p.getNumber()%></td>
                                          <td class="tablecell"><%=ref.getNumber()%></td>
                                          <td class="tablecell"> 
                                            <%if(p.getStatus()!=I_Crm.PROPOSAL_STATUS_PROPOSAL){%>
                                            <%=JSPFormater.formatDate(p.getRevisedDate(), "dd MMMM yyyy")%> 
                                            <%}%>
                                          </td>
                                          <td class="tablecell"> 
                                            <%if(p.getStatus()!=I_Crm.PROPOSAL_STATUS_PROPOSAL){
										  		User u = new User();
												try{
													u = DbUser.fetch(p.getRevisedById());
												}
												catch(Exception e){
												}
										  	
										  %>
                                            <%=u.getFullName()%> 
                                            <%}%>
                                          </td>
                                          <td class="tablecell"><%=I_Crm.proposalStatusStr[p.getStatus()]%></td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell1"><a href="proposal.jsp?hidden_proposal_id=<%=p.getOID()%>&command=<%=JSPCommand.EDIT%>&menu_idx=<%=menuIdx%>"><%=JSPFormater.formatDate(p.getRegDate(), "dd MMMM yyyy")%></a></td>
                                          <td class="tablecell1"><%=p.getNumber()%></td>
                                          <td class="tablecell1"><%=ref.getNumber()%></td>
                                          <td class="tablecell1"> 
                                            <%if(p.getStatus()!=I_Crm.PROPOSAL_STATUS_PROPOSAL){%>
                                            <%=JSPFormater.formatDate(p.getRevisedDate(), "dd MMMM yyyy")%> 
                                            <%}%>
                                          </td>
                                          <td class="tablecell1"> 
                                            <%if(p.getStatus()!=I_Crm.PROPOSAL_STATUS_PROPOSAL){
										  		User u = new User();
												try{
													u = DbUser.fetch(p.getRevisedById());
												}
												catch(Exception e){
												}
										  	
										  %>
                                            <%=u.getFullName()%> 
                                            <%}%>
                                          </td>
                                          <td class="tablecell1"><%=I_Crm.proposalStatusStr[p.getStatus()]%></td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3">&nbsp; </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  //cmdClick();
						  //cmdChangeEmp();
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
