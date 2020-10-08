<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|  Karya kami mohon jangan dibajak  |
	|                                   |
	|  10/30/2008 11:07:36 AM
	|***********************************/
%>
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.I_Project" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES);
	boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES, AppMenu.PRIV_UPDATE);
%>
<%
//jsp content
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	
	long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
	String inv_number = JSPRequestValue.requestString(request, "inv_number");
	String proj_number = JSPRequestValue.requestString(request, "proj_number");
	Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
	Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
	Date startDueDate = (JSPRequestValue.requestString(request, "startDueDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "startDueDate"), "dd/MM/yyyy");
	Date endDueDate = (JSPRequestValue.requestString(request, "endDueDate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "endDueDate"), "dd/MM/yyyy");
	
	int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
	int chkDueDate = JSPRequestValue.requestInt(request, "chkDueDate");
	int chkOverdue = JSPRequestValue.requestInt(request, "chkOverdue");
	
	long oidUnitUsaha = JSPRequestValue.requestLong(request, "unit_usaha_id");
	
	if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.BACK){
		chkInvDate = 1;
		chkDueDate = 1;
		chkOverdue = 1;
	}
	
	String whereClause = "";
	String orderClause = "";
	
	if(oidCustomer!=0){
		whereClause = "a.customer_id="+oidCustomer;
	}
	if(inv_number.length()>0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "a.invoice_number like '%"+inv_number+"%'";
	}	
	if(proj_number.length()>0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "b.number like '%"+proj_number+"%'";
	}	
	if(chkInvDate==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "a.date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") +"'";
	}	
	if(chkDueDate==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "a.due_date between '" + JSPFormater.formatDate(startDueDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDueDate, "yyyy-MM-dd") +"'";
	}	
	if(chkOverdue==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "a.due_date >= '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "'";
	}	
	if(oidUnitUsaha!=0){
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "b.unit_usaha_id ="+oidUnitUsaha;
	}

	//Vector vInvList = QrAR.listArchives(whereClause, orderClause, systemCompanyId);
	Vector vInvList = QrAR.listArchives(whereClause, orderClause);
	//DbARInvoice.list(0, 0, whereClause, OrderClause);

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

<%if(!masterPriv || !masterPrivView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdSearch(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="archives.jsp";
	document.form1.submit();
}

function cmdInvoice(idProj, idPt){
	document.form1.command.value="<%=JSPCommand.ADD%>";
	document.form1.hidden_project_id.value=idProj;
	document.form1.hidden_project_term_id.value=idPt;
	document.form1.action="arinvoicedisplay.jsp";
	document.form1.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Account Receivable</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Invoice Archives</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					 <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
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
                                              <td> 
                                                <form id="form1" name="form1" method="post" action="">
                                                  <input type="hidden" name="command">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td colspan="4">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="10%" nowrap>Customer</td>
                                                            <td width="20%" nowrap> 
                                                              <%
									//Vector cust = DbCustomer.list(0,0, "company_id="+systemCompanyId, "");
									Vector cust = DbCustomer.list(0,0, "", "name");
									%>
                                                              <select name="customer_id" onChange="javascript:cmdSearch()">
                                                                <option value="0">-- 
                                                                All --</option>
                                                                <%if(cust!=null && cust.size()>0){
										  for(int i=0; i<cust.size(); i++){
												Customer c = (Customer)cust.get(i);
										%>
                                                                <option value="<%=c.getOID()%>" <%if(c.getOID()==oidCustomer){%>selected<%}%>><%=c.getName()%></option>
                                                                <%}}%>
                                                              </select>
                                                            </td>
                                                            <td width="10%" nowrap>&nbsp;</td>
                                                            <td width="60%" nowrap>&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td nowrap>Invoice 
                                                              Date between</td>
                                                            <td nowrap colspan="3"> 
                                                              <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate==null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                              and 
                                                              <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate==null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                              <input type="checkbox" name="chkInvDate" value="1" <%if(chkInvDate==1){ %>checked<%}%>>
                                                              Ignored</td>
                                                          </tr>
                                                          <tr> 
                                                            <td nowrap>Invoice 
                                                              Number</td>
                                                            <td nowrap> 
                                                              <input type="text" name="inv_number" value="<%=(inv_number==null) ? "" : inv_number%>" size="35">
                                                            </td>
                                                            <td nowrap>Due Date 
                                                              between</td>
                                                            <td nowrap> 
                                                              <input name="startDueDate" value="<%=JSPFormater.formatDate((startDueDate==null) ? new Date() : startDueDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.startDueDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                              and 
                                                              <input name="endDueDate" value="<%=JSPFormater.formatDate((endDueDate==null) ? new Date() : endDueDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.endDueDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                              <input type="checkbox" name="chkDueDate" value="1" <%if(chkDueDate==1){ %>checked<%}%>>
                                                              Ignored </td>
                                                          </tr>
                                                          <tr> 
                                                            <td nowrap>Project 
                                                              Number</td>
                                                            <td nowrap> 
                                                              <input type="text" name="proj_number" value="<%=(proj_number==null) ? "" : proj_number%>" size="35">
                                                            </td>
                                                            <td nowrap>Overdue</td>
                                                            <td nowrap> 
                                                              <input type="checkbox" name="chkOverdue" value="1" <%if(chkOverdue==1){ %>checked<%}%>>
                                                              Include Overdue</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>Unit Usaha</td>
                                                            <td> 
                                                              <%
																	Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
																	%>
                                                              <select name="unit_usaha_id">
                                                                <option value="0">-- 
                                                                All --</option>
                                                                <%if(unitUsh!=null && unitUsh.size()>0){
																	  for(int i=0; i<unitUsh.size(); i++){
																	  	UnitUsaha us = (UnitUsaha)unitUsh.get(i);
																	  %>
                                                                <option value="<%=us.getOID()%>" <%if(us.getOID()==oidUnitUsaha){%>selected<%}%>><%=us.getName()%></option>
                                                                <%}}%>
                                                              </select>
                                                            </td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                            </td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="4" class="boxed1"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td class="tablehdr" width="3%">No</td>
                                                                  <td class="tablehdr" width="20%">Customer</td>
                                                                  <td class="tablehdr" width="8%">Invoice 
                                                                    Number</td>
                                                                  <td class="tablehdr" width="12%">Project 
                                                                    Number</td>
                                                                  <td class="tablehdr" width="10%">Unit 
                                                                    Usaha </td>
                                                                  <td class="tablehdr" width="10%">Due 
                                                                    Date</td>
                                                                  <td class="tablehdr" width="5%">Currency</td>
                                                                  <td class="tablehdr" width="12%">Invoice 
                                                                    Amount </td>
                                                                  <td class="tablehdr" width="8%">Payment</td>
                                                                  <td class="tablehdr" width="8%">Status</td>
                                                                </tr>
                                                                <%
										if(vInvList!=null && vInvList.size()>0)
										{
											for(int i=0; i<vInvList.size(); i++)
											{			
												ARInvoice arInv = (ARInvoice)vInvList.get(i);							
												//Load Currency
												Currency curr = new Currency();
												try{
													curr = DbCurrency.fetchExc(arInv.getCurrencyId());
												}catch(Exception e){
													System.out.println(e);
												}
												//Load Customer
												Customer customer =  new Customer();
												try{
													customer = DbCustomer.fetchExc(arInv.getCustomerId());
												}catch (Exception e){
													System.out.println(e);
												}
												//Load Project
												Project proj = new Project();
												if(arInv.getSalesSource()==0){
													try{
														proj = DbProject.fetchExc(arInv.getProjectId());
													}catch (Exception e){
														System.out.println(e);
													}
												}
												//Load Project
												Sales sales = new Sales();
												if(arInv.getSalesSource()==1){
													try{
														sales = DbSales.fetchExc(arInv.getProjectId());
													}catch (Exception e){
														System.out.println(e);
													}
												}
												
												UnitUsaha uu = new UnitUsaha();												
												try{
													if(arInv.getSalesSource()==0){
														uu = DbUnitUsaha.fetchExc(proj.getUnitUsahaId());
													}
													else{
														uu = DbUnitUsaha.fetchExc(sales.getUnitUsahaId());
													}
												}catch (Exception e){
													System.out.println(e);
												}
												
												//Load Invoice Detail
												Vector vArDetail = new Vector(1,1);
												ARInvoiceDetail arInvDetail = new ARInvoiceDetail();
												try{
													vArDetail = DbARInvoiceDetail.list(0,0,"ar_invoice_id="+arInv.getOID(),"");
												}catch (Exception e){
													System.out.println();
												}
												if(vArDetail!=null && vArDetail.size()>0){
													arInvDetail = (ARInvoiceDetail)vArDetail.get(0);
												}
												//Load Payment Detail
												ArPayment arPay = new ArPayment();
												try{
												}catch (Exception e){
													System.out.println(e);
												}												
												
												//Load Class
												String tableClass = "tablecell1";
												if(i%2!=0){
													tableClass = "tablecell";											
												}
									%>
                                                                <tr> 
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="center"><%=i+1%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <a href="invoicepaymentdisplay.jsp?oid=<%=arInv.getOID()%>"><%=customer.getName()%></a> 
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="center"><%=arInv.getInvoiceNumber()%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="left">
																	<%if(arInv.getSalesSource()==0){%>
																		<%=proj.getNumber()%>
																	<%}else{%>
																		<%=sales.getNumber()%>
																	<%}%>
																	</div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"><%=uu.getName()%></td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="center"><%=JSPFormater.formatDate(arInv.getDueDate(),"dd MMMM yyyy")%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="center"><%=curr.getCurrencyCode()%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="right">
																	<%if(arInv.getSalesSource()==0){%>
																	<%=JSPFormater.formatNumber(arInvDetail.getTotalAmount()-proj.getPphAmount(),"#,###.##")%>
																	<%}else{%>
																	<%=JSPFormater.formatNumber(arInvDetail.getTotalAmount()-sales.getPphAmount(),"#,###.##")%>
																	<%}%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(DbArPayment.getTotalInvoicePayment(arInv.getOID()), "#,###.##")%></div>
                                                                  </td>
                                                                  <td height="14" class="<%=tableClass%>"> 
                                                                    <div align="center"><%=I_Project.invStatusStr[arInv.getStatus()]%></div>
                                                                  </td>
                                                                </tr>
                                                                <%
											}
										}
									%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td height="15">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp;</td>
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
                              </table>
                            </td>
                          </tr>
                        </table>
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

