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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
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
	
	long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_casharchive");
	
	CashReceive cashReceive = new CashReceive();
	try{
		cashReceive = DbCashReceive.fetchExc(oidCashReceive);
	}
	catch(Exception e){
	}
	
	Vendor vnd = new Vendor();
	try{
		vnd = DbVendor.fetchExc(cashReceive.getCustomerId());
	}
	catch(Exception e){
	}
	
	Coa coa = new Coa();
	try{
		coa = DbCoa.fetchExc(cashReceive.getCoaId());
	}
	catch(Exception e){}															

	Employee em = new Employee();
	try{
		em = DbEmployee.fetchExc(cashReceive.getReceiveFromId());
	}
	catch(Exception e){}									

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!cashPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBymhdPDF?oid=<%=appSessUser.getLoginId()%>&crd_id=<%=oidCashReceive%>");
}

function cmdBack(){
	window.history.back();
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
					  String navigator = "<font class=\"lvl1\">BYMHD</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">BYMHD Detail</span></font>";
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
                          <input type="hidden" name="hidden_casharchive" value="<%=oidCashReceive%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" width="1%">&nbsp;</td>
                                    <td height="8" valign="top" colspan="3" width="99%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="37%" nowrap> 
                                                  <div align="right">Date : <%=JSPFormater.formatDate(cashReceive.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : 
                                                    <%
													User u = new User();
													try{
														u = DbUser.fetch(cashReceive.getOperatorId());
													}
													catch(Exception e){
													}
													%>
                                                    <%=u.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <!--tr> 
                                                <td width="10%">Uraian</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=vnd.getCode()+" - "+vnd.getName()%></td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" height="10"></td>
                                              </tr-->
                                              <tr> 
                                                <td width="10%"> 
                                                  
                                                  Dialokasikan Dari Akun 
                                                  
                                                </td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                                <td width="12%">Nomor Jurnal</td>
                                                <td width="42%"><%=cashReceive.getJournalNumber()%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Petugas 
                                                  
                                                </td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=em.getEmpNum()+ " - "+em.getName()%></td>
                                                <td width="12%">Tanggal Transaksi</td>
                                                <td width="42%"><%=JSPFormater.formatDate(cashReceive.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Jumlah <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%></td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Memo</td>
                                                <td width="3%">&nbsp;</td>
                                                <td colspan="3"><%=cashReceive.getMemo()%></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" width="1%" class="comment">&nbsp;</td>
                                    <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td>
                                  </tr>
                            <%
								try{
							%>
                                  <tr align="left" valign="top"> 
                                    <td  valign="middle" width="1%">&nbsp;</td>
                                    <td  valign="middle" colspan="3" width="99%"> 
                                      <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td class="boxed1"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr>
                                                <td rowspan="2"  class="tablehdr" nowrap width="20%">Uraian</td>
                                                <td rowspan="2"  class="tablehdr" nowrap width="20%">Akun 
                                                  Hutang - Keterangan</td>
                                                <td colspan="2" class="tablehdr" nowrap>Mata 
                                                  Uang</td>
                                                <td rowspan="2" class="tablehdr" width="10%">Booked 
                                                  Rate</td>
                                                <td rowspan="2" class="tablehdr" width="15%">Jumlah 
                                                  <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr" width="40%">Keterangan</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%" class="tablehdr">Kode</td>
                                                <td width="13%" class="tablehdr">Jumlah</td>
                                              </tr>
                                              <%
											  		Vector vectorList = DbCashReceiveDetail.list(0, DbCashReceiveDetail.getCount("")," cash_receive_id = "+ oidCashReceive,"");
													for(int i=0; i<vectorList.size(); i++)
													{
														CashReceiveDetail crd = (CashReceiveDetail)vectorList.get(i);
														Coa coax = new Coa();
														try{
															coax = DbCoa.fetchExc(crd.getCoaId());
														}
														catch(Exception e){
														}
														
														String cssName = "tablecell";
														if(i%2!=0){
															cssName = "tablecell1";
														}
														
														Currency xc = new Currency();
														try{
															xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
														}
														catch(Exception e){
														}
											  %>
                                              <tr>
                                                <td class="<%=cssName%>">
												<%
														Vendor vndxc = new Vendor();
														try{
															vndxc = DbVendor.fetchExc(crd.getCustomerId());
														}
														catch(Exception e){
														}
												%>
												<%=vndxc.getCode()+" - "+vndxc.getName()%>
												</td>
                                                <td class="<%=cssName%>"><%=coax.getCode()+" - "+coax.getName()%></td>
                                                <td class="<%=cssName%>"><%=xc.getCurrencyCode()%></td>
                                                <td class="<%=cssName%>">
                                                  <div align="right"><%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%></div>
                                                </td>
                                                <td class="<%=cssName%>">
                                                  <div align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%></div>
                                                </td>
                                                <td class="<%=cssName%>">
                                                  <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                </td>
                                                <td class="<%=cssName%>">
                                                  <div align="left"><%=crd.getMemo()%></div>
                                                </td>
                                              </tr>
                                              <%
											  		}
											  %>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp; </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                           <% 
						  		}catch(Exception exc){}
						   %>
                                  <tr align="left" valign="top"> 
									<td  valign="middle" width="1%">&nbsp;</td>
                                    <td valign="middle" colspan="3"> 
									   <table width="99%" border="0" cellspacing="0" cellpadding="0">
										<tr> 
										  <td colspan="2" height="5"></td>
										</tr>
										<tr> 
										  <td width="78%"> 
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
												  <div align="right"><%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%></div>
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
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table>
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
