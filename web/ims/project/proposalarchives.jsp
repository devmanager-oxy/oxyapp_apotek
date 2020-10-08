 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%

int pageType = JSPRequestValue.requestInt(request, "page_type");

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

JSPLine ctrLine = new JSPLine();

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;

String cusName = JSPRequestValue.requestString(request, "src_cus_name");
String propNumber = JSPRequestValue.requestString(request, "src_prop_number");
String subject = JSPRequestValue.requestString(request, "src_subject");
int ignore = JSPRequestValue.requestInt(request, "src_ignore");
String strStartDate = JSPRequestValue.requestString(request, "src_start_date");
String strEndDate = JSPRequestValue.requestString(request, "src_end_date");
int status = JSPRequestValue.requestInt(request, "src_status");

Date startDate = new Date();
if(strStartDate.length()>0){
	startDate = JSPFormater.formatDate(strStartDate, "dd/MM/yyyy");
}
Date endDate = new Date();
if(strEndDate.length()>0){
	endDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
}


if(iJSPCommand==JSPCommand.NONE){
	ignore = 1;
	status  = -1;
}

int vectSize = DbProposal.getCountProposal(cusName, propNumber, subject, ignore, startDate, endDate, status);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
  		Control c = new Control();
		start = c.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

if(pageType==1){
	status = I_Crm.PROPOSAL_STATUS_PROPOSAL;
}

Vector proposals = DbProposal.getProposal(start, recordToGet, cusName, propNumber, subject, ignore, startDate, endDate, status);

//out.println(proposals);
//out.println("pageType : "+pageType);

%>



<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="proposalarchives.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="proposalarchives.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="proposalarchives.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="proposalarchives.jsp";
	document.frmcustomer.submit();
}

function cmdSearch(){
	document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcustomer.action="proposalarchives.jsp";
	document.frmcustomer.submit();
}

function cmdEdit(oid){
	document.frmcustomer.hidden_proposal_id.value=oid;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.action="proposal.jsp";
	document.frmcustomer.submit();
}

function cmdAdd(){
	document.frmcustomer.hidden_proposal_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.NONE%>";
	document.frmcustomer.action="proposal.jsp";
	document.frmcustomer.submit();
}

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/search2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Marketing</span> 
                        &raquo; <span class="level1">Proposal</span> &raquo; <span class="level2"><%if(pageType==0){%>Archives<%}else{%>Proposal to Project<%}%><br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="frmcustomer" name="frmcustomer" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_proposal_id" value="">
						  <input type="hidden" name="page_type" value="<%=pageType%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="80%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="14%">&nbsp;</td>
                                    <td width="31%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="45%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="14%">&nbsp;Customer</td>
                                    <td width="31%"> 
                                      <input type="text" name="src_cus_name" size="40" value="<%=cusName%>">
                                    </td>
                                    <td width="10%"><%if(pageType==0){%>Status<%}%></td>
                                    <td width="45%">
									<%if(pageType==0){%> 
                                      <select name="src_status">
                                        <option value="-1" <%if(status==-1){%>selected<%}%>>ALL</option>
                                        <%for(int i=0; i<I_Crm.proposalStatusStr.length; i++){%>
                                        <option value="<%=i%>" <%if(status==i){%>selected<%}%>><%=I_Crm.proposalStatusStr[i]%></option>
                                        <%}%>
                                      </select>
									  <%}%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%">&nbsp;Proposal Number</td>
                                    <td width="31%"> 
                                      <input type="text" name="src_prop_name" value="<%=propNumber%>">
                                    </td>
                                    <td width="10%">Proposal Date</td>
                                    <td nowrap width="45%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="31%" nowrap> 
                                            <input name="src_start_date" value="<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                          </td>
                                          <td width="10%" nowrap> 
                                            <div align="center">And</div>
                                          </td>
                                          <td width="30%" nowrap> 
                                            <input name="src_end_date" value="<%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                          </td>
                                          <td width="7%" nowrap> 
                                            <input type="checkbox" name="src_ignore" value="1" <%if(ignore==1){%>checked<%}%>>
                                          </td>
                                          <td width="22%" nowrap>Ignore </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%">&nbsp;Keywords/Subject</td>
                                    <td width="31%"> 
                                      <input type="text" name="src_subject" size="40" value="<%=subject%>">
                                    </td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="45%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search2.gif',1)"><img src="../images/search.gif" name="new21"  border="0"></a></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr > 
                                    <td colspan="3" height="3" background="../images/line1.gif"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="7%">Proposal 
                                          </td>
                                          <td class="tablehdr" width="13%">Number</td>
                                          <td class="tablehdr" width="13%">Ref. 
                                            Number </td>
                                          <td class="tablehdr" width="16%">Subject</td>
                                          <td class="tablehdr" width="10%">Project 
                                            Name </td>
                                          <td class="tablehdr" width="13%">Address</td>
                                          <td class="tablehdr" width="10%">Customer</td>
                                          <td class="tablehdr" width="11%">Phone/Fax/HP</td>
                                          <td class="tablehdr" width="7%">Status</td>
                                        </tr>
                                        <%
										if(proposals!=null && proposals.size()>0){
											for(int i=0; i<proposals.size(); i++){
												Proposal p = (Proposal)proposals.get(i);
												
												Proposal refProposal = new Proposal();
												try{
													refProposal = DbProposal.fetchExc(p.getProposalRefId());
												}
												catch(Exception e){
												}
												
												if(i%2==0){
												
										%>
                                        <tr valign="top"> 
                                          <td width="7%" class="tablecell" nowrap><a href="javascript:cmdEdit('<%=p.getOID()%>')"><%=JSPFormater.formatDate(p.getDate(), "dd MMMM yyyy")%></a></td>
                                          <td width="13%" class="tablecell"><%=p.getNumber()%></td>
                                          <td width="13%" class="tablecell"><%=(p.getProposalRefId()==0) ? "-" : refProposal.getNumber()%></td>
                                          <td width="16%" class="tablecell"><%=p.getSubjectIndo()+" / "+p.getSubjectEng()%></td>
                                          <td width="10%" class="tablecell"><%=p.getProjectName()%></td>
                                          <td width="13%" class="tablecell"><%=p.getAddress()%></td>
                                          <td width="10%" class="tablecell"><%=p.getYth()+"/"+p.getYth1()%></td>
                                          <td width="11%" class="tablecell"><%=p.getYthPhone()%></td>
                                          <td width="7%" class="tablecell"> 
                                            <div align="center"><%=I_Crm.proposalStatusStr[p.getStatus()]%> </div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr valign="top"> 
                                          <td width="7%" class="tablecell1"><a href="javascript:cmdEdit('<%=p.getOID()%>')"><%=JSPFormater.formatDate(p.getDate(), "dd MMMM yyyy")%></a></td>
                                          <td width="13%" class="tablecell1"><%=p.getNumber()%></td>
                                          <td width="13%" class="tablecell1"><%=(p.getProposalRefId()==0) ? "-" : refProposal.getNumber()%></td>
                                          <td width="16%" class="tablecell1"><%=p.getSubjectIndo()+" / "+p.getSubjectEng()%></td>
                                          <td width="10%" class="tablecell1"><%=p.getProjectName()%></td>
                                          <td width="13%" class="tablecell1"><%=p.getAddress()%></td>
                                          <td width="10%" class="tablecell1"><%=p.getYth()+"/"+p.getYth1()%></td>
                                          <td width="11%" class="tablecell1"><%=p.getYthPhone()%></td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="center"><%=I_Crm.proposalStatusStr[p.getStatus()]%></div>
                                          </td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td colspan="9" height="5"> </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td><span class="command"> 
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
								
											
											ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
											ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
											ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
											ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
											
											ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
											ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
											ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
											ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span></td>
                                        </tr>
                                        <tr> 
                                          <td height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/new2.gif',1)"><img src="../images/new.gif" name="new211"  border="0"></a></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
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
