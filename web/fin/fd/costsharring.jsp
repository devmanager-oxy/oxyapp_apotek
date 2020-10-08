 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fdms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
int recordToGet = 25;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "status=0";
String orderClause = "";
int start = JSPRequestValue.requestInt(request,"start");
CmdPettycashPayment ctrlPettycashPayment = new CmdPettycashPayment(request);
JSPLine ctrLine = new JSPLine();
Vector listPettycashPayment = new Vector(1,1);

//out.println(start);

int vectSize = DbPettycashPayment.getCount(whereClause);

if(iJSPCommand==JSPCommand.SAVE){	
	
	listPettycashPayment = DbPettycashPayment.list(start, recordToGet, whereClause, "trans_date");	
	if(listPettycashPayment!=null && listPettycashPayment.size()>0){
	    for(int i=0; i<listPettycashPayment.size(); i++){
			
			PettycashPayment pp = (PettycashPayment)listPettycashPayment.get(i);
			Vector details = new Vector();
			int isProceed = JSPRequestValue.requestInt(request, "chk_"+pp.getOID());
			if(isProceed==1){
				Vector allocs = DbShareAllocation.list(0,0, "share_category_id="+pp.getShareCategoryId(), "");
				if(allocs!=null && allocs.size()>0){
					for(int x=0; x<allocs.size(); x++){
						ShareAllocation sa = (ShareAllocation)allocs.get(x);
						long coaId = JSPRequestValue.requestLong(request, "coa_"+pp.getOID()+""+sa.getOID());
						String memo = JSPRequestValue.requestString(request, "memo_"+pp.getOID()+""+sa.getOID());
						try{
							PettycashPaymentDetail pd = new PettycashPaymentDetail();
							pd.setPettycashPaymentId(pp.getOID());
							pd.setDepartmentId(sa.getDepartmentId());
							pd.setCoaId(coaId);
							pd.setMemo(memo);
							pd.setAmount(pp.getAmount()*sa.getAllShare()/100);
							DbPettycashPaymentDetail.insertExc(pd);
							details.add(pd);
						}
						catch(Exception e){
						}
					}
				}
								
				try{
					DbPettycashPayment.postJournal(pp, details);
					pp.setStatus(1);
					DbPettycashPayment.updateExc(pp);
				}
				catch(Exception e){
				}
			}
					
		}
	}
}


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPettycashPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

//out.println("start : "+start);

listPettycashPayment = DbPettycashPayment.list(start, recordToGet, whereClause, "trans_date");




%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--

function cmdPostJurnal(){
	document.all.cmd.style.display="none";
	document.all.proceed.style.display="";
	document.frmsharegroup.command.value="<%=JSPCommand.SAVE%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.SAVE%>";
	document.frmsharegroup.action="costsharring.jsp";
	document.frmsharegroup.submit();
}

function cmdListFirst(){
	document.frmsharegroup.command.value="<%=JSPCommand.FIRST%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsharegroup.action="costsharring.jsp";
	document.frmsharegroup.submit();
}

function cmdListPrev(){
	document.frmsharegroup.command.value="<%=JSPCommand.PREV%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsharegroup.action="costsharring.jsp";
	document.frmsharegroup.submit();
}

function cmdListNext(){
	document.frmsharegroup.command.value="<%=JSPCommand.NEXT%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsharegroup.action="costsharring.jsp";
	document.frmsharegroup.submit();
}

function cmdListLast(){
	document.frmsharegroup.command.value="<%=JSPCommand.LAST%>";
	document.frmsharegroup.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsharegroup.action="costsharring.jsp";
	document.frmsharegroup.submit();
}

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Purchase</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Cost Sharing</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="frmsharegroup" name="frmsharegroup" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="prev_command">
						  <input type="hidden" name="start" value="<%=start%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container" height="27"><b>Pending posted 
                                purchase transaction</b></td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="4%" height="19"><b>No</b></td>
                                    <td width="10%" height="19"><b>Date</b></td>
                                    <td width="13%" height="19"><b>Number</b></td>
                                    <td width="22%" height="19"><b>Category</b></td>
                                    <td width="20%" height="19"><b>Description</b></td>
                                    <td width="11%" height="19"><b>Cost Group</b></td>
                                    <td width="9%" height="19"><b>Allocation</b></td>
                                    <td width="11%" height="19"><b>Amount</b></td>
                                  </tr>
                                  <%if(listPettycashPayment!=null && listPettycashPayment.size()>0){
								  for(int i=0; i<listPettycashPayment.size(); i++){
								  	PettycashPayment pp = (PettycashPayment)listPettycashPayment.get(i);
									ExpenseCategory ec = new ExpenseCategory();
									ShareGroup sg = new ShareGroup();
									ShareCategory sc = new ShareCategory();
									try{
										ec = DbExpenseCategory.fetchExc(pp.getExpenseCategoryId());
									}
									catch(Exception e){
									}
									
									try{
										sc = DbShareCategory.fetchExc(pp.getShareCategoryId());
										sg = DbShareGroup.fetchExc(sc.getShareGroupId());
									}
									catch(Exception e){
									}
									
									Vector allocs = DbShareAllocation.list(0,0, "share_category_id="+sc.getOID(), "");
									
								  %>
                                  <tr> 
                                    <td width="4%"><%=start+(i+1)%></td>
                                    <td width="10%"><%=JSPFormater.formatDate(pp.getTransDate(), "dd/MM/yyyy")%></td>
                                    <td width="13%"><%=pp.getJournalNumber()%></td>
                                    <td width="22%"><%=ec.getName()%></td>
                                    <td width="20%"><%=pp.getMemo()%></td>
                                    <td width="11%"><%=sg.getName()%></td>
                                    <td width="9%"><%=sc.getName()%></td>
                                    <td width="11%"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="4%" valign="top"> 
                                      <input type="checkbox" name="chk_<%=pp.getOID()%>" value="1" checked>
                                    </td>
                                    <td colspan="7"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#EBEBEB">
                                        <tr> 
                                          <td width="12%"><i><b><font size="1">Department</font></b></i></td>
                                          <td width="9%"><i><b><font size="1">Allocation</font></b></i></td>
                                          <td width="41%"><i><b><font size="1">Expense 
                                            Account</font></b></i></td>
                                          <td width="15%"><i><b><font size="1">Amount</font></b></i></td>
                                          <td width="23%"><i><b><font size="1">Memo</font></b></i></td>
                                        </tr>
                                        <%if(allocs!=null && allocs.size()>0){
										for(int x=0; x<allocs.size(); x++){
											ShareAllocation sa = (ShareAllocation)allocs.get(x);
											Department d = new Department();
											try{
												d = DbDepartment.fetchExc(sa.getDepartmentId());
											}
											catch(Exception e){
											}
											
											Vector coas = DbCoa.list(0,0, "department_id="+d.getOID()+" and account_group='expense' and status='POSTABLE'", "code");
										%>
                                        <tr> 
                                          <td width="12%"><%=d.getName()%></td>
                                          <td width="9%"><%=sa.getAllShare()%> %</td>
                                          <td width="41%"> 
                                            <select name="coa_<%=pp.getOID()+""+sa.getOID()%>">
                                              <%if(coas!=null && coas.size()>0){
												for(int z=0; z<coas.size(); z++){
													Coa coa = (Coa)coas.get(z);
											%>
                                              <option value="<%=coa.getOID()%>"><%=coa.getCode()+"-"+coa.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td width="15%"> 
                                            <input type="text" name="textfield2" value="<%=JSPFormater.formatNumber(pp.getAmount()*sa.getAllShare()/100, "#,###.##")%>" class="readonly" readonly style="text-align:right">
                                          </td>
                                          <td width="23%"> 
                                            <input type="text" name="memo_<%=pp.getOID()+""+sa.getOID()%>" size="30">
                                          </td>
                                        </tr>
                                        <%}}%>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="41%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="23%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="4%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="22%">&nbsp;</td>
                                    <td width="20%">&nbsp;</td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="11%">&nbsp;</td>
                                  </tr>
                                  <%}}%>
                                </table>
                              </td>
                            </tr>
							<%if(listPettycashPayment!=null && listPettycashPayment.size()>0){%>
                            <tr> 
                              <td class="container"><span class="command"> 
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
                            <tr id="proceed"> 
                              <td class="container"><font color="#FF0000">please 
                                wait ....</font></td>
                            </tr>
                            <tr id="cmd"> 
                              <td class="container"><a href="javascript:cmdPostJurnal()"><img src="../images/post_journal.gif" width="92" height="22" border="0"></a></td>
                            </tr>
							<%}%>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
						  <%if(listPettycashPayment!=null && listPettycashPayment.size()>0){%>
						  	<script language="JavaScript">
							document.all.cmd.style.display="";
							document.all.proceed.style.display="none";
							</script>
							<%}%>
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
