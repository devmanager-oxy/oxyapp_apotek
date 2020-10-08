<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
%>
<!-- Jsp Block -->
<%!	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				CashReceiveDetail crd = (CashReceiveDetail)listx.get(i);
				result = result + crd.getAmount();
			}
		}
		return result;
	}
%>
<%
	//main
	
	long oidPettycashReplenishment = JSPRequestValue.requestLong(request, "hidden_casharchive");
	//out.println("aaaa ="+oidCashPayment+"=aaax");
	PettycashReplenishment pettycashReplenishment = new PettycashReplenishment();
	try{		
		pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
	}
	catch(Exception e){
		//System.out.println("xx "+e);
	}															

	Coa coa = new Coa();
	try{
		coa = DbCoa.fetchExc(pettycashReplenishment.getReplaceCoaId());
	}
	catch(Exception e){}		
	
	Coa coay = new Coa();
	try{
		coay = DbCoa.fetchExc(pettycashReplenishment.getReplaceFromCoaId());
	}
	catch(Exception e){}
	
	double total = 0;													
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
<%if(!cashPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================
function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptPCReplenishmentPDF?oid=<%=appSessUser.getLoginId()%>&pcReplenishment_id=<%=oidPettycashReplenishment%>");
}

function cmdBack(){
	window.history.back();
}
//-->

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/back2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Petty Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Replenishment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcasharchive" method ="post" action="">
                          <input type="hidden" name="hidden_casharchive" value="<%=oidPettycashReplenishment%>">
						  <%
						  		try
								{
						  %>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" width="100%" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="77%">&nbsp;</td>
                                          <td width="23%" nowrap>
											  <div align="right">Date : <%=JSPFormater.formatDate(pettycashReplenishment.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
												: 
												<%
												User u = new User();
												try{
													u = DbUser.fetch(pettycashReplenishment.getOperatorId());
												}
												catch(Exception e){
												}
												%>
												<%=u.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="15%" nowrap>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" nowrap height="22">Replenishment for Account</td>
                                                <td height="22"><%=coa.getCode()+ " - "+coa.getName()%></td>
                                                <td height="22">Journal Number</td>
                                                <td height="22"> <%=pettycashReplenishment.getJournalNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="22">From Account</td>
                                                <td width="27%" height="22"><%=coay.getCode()+ " - "+coay.getName()%></td>
                                                <td width="11%" height="22">Transaction Date</td>
                                                <td width="47%" height="22"> <%=JSPFormater.formatDate((pettycashReplenishment.getTransDate()==null) ? new Date() : pettycashReplenishment.getTransDate(), "dd/MM/yyyy")%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="22">Memo</td>
                                                <td colspan="3" height="22"> <%= pettycashReplenishment.getMemo() %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="8"></td>
                                                <td width="27%" height="8"></td>
                                                <td width="11%" height="8"></td>
                                                <td width="47%" height="8"></td>
                                              </tr>
                                              <tr> 
                                                <td width="15%">&nbsp;</td>
                                                <td width="27%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="47%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">
                                                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr > 
                                                      <td class="tabheader" width="1%"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                      <td class="tab" width="11%"> 
                                                        <div align="center">Disbursement</div>
                                                      </td>
                                                      <td class="tabheader" width="25%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td width="63%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" class="page"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="13%" class="tablehdr"><div align="center">Number</div></td>
                                                      <td width="14%" class="tablehdr"><div align="center">Transaction Date</div></td>
                                                      <td width="60%" class="tablehdr"><div align="center">Memo</div></td>
                                                      <td width="13%" class="tablehdr"><div align="center">Amount(<%=baseCurrency.getCurrencyCode()%>)</div></td>
                                                    </tr>

											<%
												Vector openPaymants = DbPettycashExpense.list(0,0, "pettycash_replenishment_id="+pettycashReplenishment.getOID(), "");//getOpenPayment(oidReplaceCoa);
												for(int i=0; i<openPaymants.size(); i++)
												{
													PettycashExpense pe = (PettycashExpense)openPaymants.get(i);
													PettycashPayment pp = new PettycashPayment();
													Vector x = DbPettycashPayment.list(0,0, "pettycash_payment_id="+pe.getPettycashPaymentId(), "");
													if(x!=null && x.size()>0){
														pp = (PettycashPayment)x.get(0);
													}
													
													String cssName = "tablecell";
													if(i%2!=0){
														cssName = "tablecell1";
													}
													
													total = total + pp.getAmount();
										  	%>
                                                    <tr> 
                                                      <td width="13%" class="<%=cssName%>"><%=pp.getJournalNumber()%>&nbsp;</td>
                                                      <td width="14%" class="<%=cssName%>"><div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMMM yyyy")%></div></td>
                                                      <td width="60%" class="<%=cssName%>"><div align="left"><%=pp.getMemo()%></div></td>
                                                      <td width="13%" class="<%=cssName%>"><div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div></td>
                                                    </tr>
                                            <%
												}
											%>
                                                  </table>
                                                </td>
                                              </tr>   
                                            </table>
                                          </td>
                                        </tr> 
										<tr> 
										  <td colspan="2" height="5"></td>
										</tr>                                       
                                        <tr> 
                                          <td width="77%">&nbsp;</td>
                                          <td width="23%">&nbsp;</td>
                                        </tr>
										<tr> 
										  <td width="77%"> 
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr> 
												<td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/print2.gif',1)"><img src="../images/print.gif" name="print1" width="53" height="22" border="0"></a></td>
												<td width="3%">&nbsp;</td>
												<td width="9%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
												<td width="83%">&nbsp;</td>
											  </tr>
											</table>
										  </td>
										  <td class="boxed1" width="22%"> 
											<table width="100%" border="0" cellspacing="1" cellpadding="1">
											  <tr> 
												<td width="36%"> 
												  <div align="left"><b>Total 
													<%=baseCurrency.getCurrencyCode()%> : 
													</b></div>
												</td>
												<td width="64%"> 
												  <div align="right"><b><%= JSPFormater.formatNumber(total, "#,###.##") %></b></div>
												</td>
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
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" width="100%">&nbsp; 
                              </td>
                            </tr>
                          </table>
						  <%
						  		}catch(Exception e){}
						  %>
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
