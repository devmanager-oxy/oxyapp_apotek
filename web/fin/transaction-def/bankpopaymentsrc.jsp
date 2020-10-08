<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%//@ page import = "com.project.fms.transaction.InvoiceSrc" %>
<%//@ page import = "com.project.fms.transaction.InvoiceSrc" %>

<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.Purchase" %>
<%@ page import = "com.project.ccs.postransaction.purchase.DbPurchase" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long vendorId = JSPRequestValue.requestLong(request, "vendorid");
String vndInvNumber = JSPRequestValue.requestString(request, "vndinvnumber");
String poNumber = JSPRequestValue.requestString(request, "ponumber");
int overDue = JSPRequestValue.requestInt(request, "overdue");
Date dueDate = new Date();
if(JSPRequestValue.requestString(request, "duedate").length()>0){
	dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "duedate"), "dd/MM/yyyy");
}

InvoiceSrc invSrc = new InvoiceSrc();
invSrc.setVendorId(vendorId);
invSrc.setPoNumber(poNumber);
invSrc.setVndInvNumber(vndInvNumber);
invSrc.setDueDate(dueDate);
invSrc.setOverDue(overDue);

if(iJSPCommand==JSPCommand.NONE){
	overDue = 1;
}

if(iJSPCommand==JSPCommand.BACK){
	invSrc = (InvoiceSrc)session.getValue("SRC_POPAY");
}

String where = "";
if(vendorId!=0){
	where = "vendor_id="+vendorId;
}


Vector listDatas = new Vector();
if(iJSPCommand!=JSPCommand.NONE){
	listDatas = QrInvoice.searchForInvoice(invSrc);
}


//out.println("listDatas : "+listDatas);

session.putValue("SRC_POPAY", invSrc);

Vendor vendor = new Vendor();
try{
	vendor = DbVendor.fetchExc(vendorId);
}
catch(Exception e){
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
<!--
<%if(!bankPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
function cmdPayment(oid){
	document.frmap.hidden_vendor_id.value=oid;
	document.frmap.command.value="<%=JSPCommand.NONE%>";
	document.frmap.action="bankpopayment.jsp";
	document.frmap.submit();
}

function cmdSearch(){
	document.frmap.command.value="<%=JSPCommand.FIRST%>";
	document.frmap.action="bankpopaymentsrc.jsp";
	document.frmap.submit();
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><%
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">PO Payment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%> 
                       <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmap" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="command">
						  <input type="hidden" name="hidden_vendor_id">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="2" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="24" valign="middle" colspan="3" class="comment">&nbsp;<b>Search 
                                      for Open Invoice</b></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="top" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="11%" nowrap>Vendor</td>
                                          <td width="19%" nowrap> 
                                            <%
												  Vector vnds = DbVendor.list(0,0, "", "");
												  %>
                                            <select name="vendorid" onChange="javascript:cmdSearch()">
                                              <option value="0">All</option>
                                              <%if(vnds!=null && vnds.size()>0){
														for(int i=0; i<vnds.size(); i++){
															Vendor v = (Vendor)vnds.get(i);
													%>
                                              <option value="<%=v.getOID()%>" <%if(vendorId==v.getOID()){%>selected<%}%>><%=v.getCode()+" - "+v.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td width="7%" nowrap>&nbsp;</td>
                                          <td width="16%" nowrap>&nbsp; </td>
                                          <td width="8%" nowrap>&nbsp;</td>
                                          <td width="39%" nowrap>&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td height="5" width="11%" nowrap>Vendor 
                                            Invoice Number</td>
                                          <td height="5" width="19%" nowrap> 
                                            <input type="text" name="vndinvnumber" value="<%=vndInvNumber%>" size="25">
                                          </td>
                                          <td height="5" width="7%" nowrap>Due 
                                            Date</td>
                                          <td height="5" width="16%" nowrap> 
                                            <input name="duedate" value="<%=JSPFormater.formatDate(dueDate, "dd/MM/yyyy")%>" size="11" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.duedate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                          <td height="5" width="8%" nowrap>Include 
                                            Over Due</td>
                                          <td height="5" width="39%" nowrap> 
                                            <input type="checkbox" name="overdue" value="1" <%if(overDue==1){%>checked<%}%>>
                                            Yes </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6" height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6" height="5"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6" height="5">&nbsp;</td>
                                        </tr>
                                        <%if(vendorId!=0){%>
                                        <tr> 
                                          <td colspan="6" height="5">&nbsp;<b>Vendor 
                                            &nbsp;:&nbsp; 
                                            <%if(listDatas!=null && listDatas.size()>0){%>
                                            <a href="javascript:cmdPayment('<%=vendorId%>')"><%=vendor.getCode().toUpperCase()%>/<%=vendor.getName().toUpperCase()%></a> 
                                            <%}else{%>
                                            <%=vendor.getCode().toUpperCase()%>/<%=vendor.getName().toUpperCase()%> 
                                            <%}%>
                                            </b></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td colspan="6" height="5" class="boxed1"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td class="tablehdr" width="8%" height="19">Status</td>
                                                <td class="tablehdr" width="16%" height="19">Vendor</td>
                                                <td class="tablehdr" width="19%" height="19">Vendor 
                                                  Invoice Number</td>
                                                <td class="tablehdr" width="7%" height="19">Currency</td>
                                                <td class="tablehdr" width="17%" height="19">Amount</td>
                                                <td class="tablehdr" width="19%" height="19">Payment</td>
                                                <td  class="tablehdr" width="14%" height="19">Due 
                                                  Date</td>
                                              </tr>
                                              <%
											  
											  //System.out.println("listDatas : "+listDatas);
											  
											  if(listDatas!=null && listDatas.size()>0){
											  	for(int i=0; i<listDatas.size(); i++){
											  		Vector v = (Vector)listDatas.get(i);
													Vendor vnd = (Vendor)v.get(0);
													Vector tempInv = (Vector)v.get(1);
													
													//Invoice inv = (Invoice)v.get(1);
											  %>
                                              <%if(vendorId==0){%>
                                              <tr> 
                                                <td class="tablecell" width="8%" height="20">&nbsp; 
                                                </td>
                                                <td class="tablecell" width="16%" height="20"> 
                                                  <div align="center"><a href="javascript:cmdPayment('<%=vnd.getOID()%>')"><b><%=vnd.getCode()+" - "+vnd.getName()%></b></a></div>
                                                </td>
                                                <td class="tablecell" width="19%" height="20"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td class="tablecell" width="7%" height="20">&nbsp;</td>
                                                <td class="tablecell" width="17%" height="20">&nbsp;</td>
                                                <td class="tablecell" width="19%" height="20">&nbsp;</td>
                                                <td class="tablecell" width="14%" height="20"> 
                                                  <div align="center"></div>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%
											  
											  //out.println("tempInv : "+tempInv);
											  
											  if(tempInv!=null && tempInv.size()>0){
											  		for(int ix=0; ix<tempInv.size(); ix++){
														Vector vx = (Vector)tempInv.get(ix);
														
														//out.println("vx : "+vx);
														
														Purchase pur = new Purchase();//(Purchase)vx.get(0);
														Receive inv = (Receive)vx.get(1);
														
														String cssClass = "tablecell1";
														
														if(inv.getDueDate().before(new Date())){
															cssClass = "readonly";
														}
														
														if(inv.getPurchaseId()!=0){
															try{
																pur = DbPurchase.fetchExc(inv.getPurchaseId());
															}
															catch(Exception e){
															}
														}
												
											  %>
                                              <tr> 
                                                <td width="8%" bgcolor="#F2F2F2" class="<%=cssClass%>"> 
                                                  <div align="center"> 
                                                    <%
												if(inv.getDueDate().before(new Date())){
												%>
                                                    <b><font color="#FF0000">OVER 
                                                    DUE</font></b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="16%"> 
                                                  <div align="center"><%=(inv.getPurchaseId()==0) ? "DIRECT" : pur.getNumber()+"/"+JSPFormater.formatDate(pur.getPurchDate(), "dd-MM-yyyy")%></div>
                                                </td>
                                                <td width="19%" > 
                                                  <div align="center"><%=inv.getInvoiceNumber()+"/"+JSPFormater.formatDate(inv.getDate(), "dd-MM-yyyy")%></div>
                                                </td>
                                                <td width="7%"> 
                                                  <div align="center"> 
                                                    <%
												  Currency c = new Currency();
												  try{
												  	c = DbCurrency.fetchExc(inv.getCurrencyId());
												  }
												  catch(Exception e){
												  }%>
                                                    <%=c.getCurrencyCode()%></div>
                                                </td>
                                                <td width="17%" > 
                                                  <div align="right"><%=JSPFormater.formatNumber(inv.getTotalAmount()-inv.getDiscountTotal()+inv.getTotalTax(), "#,###.##")%></div>
                                                </td>
                                                <td width="19%" > 
                                                  <div align="right"> 
                                                    <%
													double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoice(inv.getOID());
												%>
                                                    <%=JSPFormater.formatNumber(balanceTotal, "#,###.##")%> </div>
                                                </td>
                                                <td width="14%" > 
                                                  <div align="center"><%=JSPFormater.formatDate(inv.getDueDate(), "dd-MM-yyyy")%></div>
                                                </td>
                                              </tr>
                                              <%}
											  %>
											  <tr> 
                                                <td  colspan="7" height="10">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td  colspan="7" background="../images/line1.gif" height="3">
                                                </td>
                                              </tr>
											  <tr> 
                                                <td  colspan="7" height="5">
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%
											  
											  	}//
											  
											  }//if
											  else{
											  	if(iJSPCommand!=JSPCommand.NONE){
											  %>
                                              <tr> 
                                                <td class="tablecell" colspan="7" height="21"> 
                                                  <div align="left">&nbsp;<font color="#FF0000">Record 
                                                    is empty</font></div>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td class="tablecell" colspan="7" height="21">Please 
                                                  click on search button to find 
                                                  your data</td>
                                              </tr>
                                              <%}}
											  %>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6" height="5">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6" height="5">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  <%if(iJSPCommand==JSPCommand.NONE){%>
						  cmdSearch();
						  <%}%>
						  </script>
                        </form>
                        <!-- #EndEditable -->
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
