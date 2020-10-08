 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
if(session.getValue("KONSTAN")!=null){
	session.removeValue("KONSTAN");
}

if(session.getValue("DETAIL")!=null){
	session.removeValue("DETAIL");
}

String str = DbSystemProperty.getValueByName("COA_BYMHD");
StringTokenizer strTok = new StringTokenizer(str, ",");
Vector ttps = new Vector();
while(strTok.hasMoreTokens()){
	ttps.add(DbCoa.getCoaByCode((String)strTok.nextToken()));
}

long oidCus = JSPRequestValue.requestLong(request, "customer_id");
long oidAccount = JSPRequestValue.requestLong(request, "account_id");

Vector temp = DbGlDetail.getSaldoTransaction(oidCus, oidAccount, ttps);//DbCashReceive.getSaldoTitipan(oidCus, oidAccount);
Vector vnds = DbVendor.list(0,0, "type="+DbVendor.VENDOR_TYPE_BYMHD,""); 

RptSaldoHD rptKonstan = new RptSaldoHD();

Periode periodeAbc = DbPeriode.getOpenPeriod();

rptKonstan.setPeriode(periodeAbc.getName());
rptKonstan.setName("SALDO BYMHD");

if(oidAccount!=0){
	Coa coa = new Coa();
	try{
		coa = DbCoa.fetchExc(oidAccount);
	}
	catch(Exception e){
	}
	rptKonstan.setAccount(coa.getCode()+" - "+coa.getName());
}
else{
	rptKonstan.setAccount("-");
}

Vector objReport = new Vector();



%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdDetail(oid){
	document.form1.command.value="<%=JSPCommand.LIST%>";
	document.form1.vendor_id.value=oid;
	document.form1.action="saldobymhdaudit.jsp";
	document.form1.submit();
}

function cmdChange(){
	document.form1.action="saldobymhd.jsp";
	document.form1.submit();
}

function cmdPrintDeposit(){	 
	window.open("<%=printroot%>.report.RptSaldoBYMHDXLS?idx=<%=System.currentTimeMillis()%>");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">BYMHD</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Saldo</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="vendor_id" value="">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">Uraian</td>
                                    <td width="91%"> 
                                      <select name="customer_id" onChange="javascript:cmdChange()">
                                        <option value="0">semua ...</option>
                                        <%
											if(oidCus==0){
												rptKonstan.setUnit("-");//semua ...");
											}
										%>
                                        <%if(vnds!=null && vnds.size()>0){
											for(int i=0; i<vnds.size(); i++){
												Vendor v = (Vendor)vnds.get(i);
												if(oidCus==v.getOID()){
													rptKonstan.setUnit(""+v.getCode()+" - "+v.getName());
												}
										%>
                                        <option value="<%=v.getOID()%>" <%if(oidCus==v.getOID()){%>selected<%}%>><%=v.getCode()+" - "+v.getName()%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="9%">Account </td>
                                    <td width="91%"> 
                                      <select name="account_id" onChange="javascript:cmdChange()">
                                        <option value="0">semua ..</option>
                                        <%if(ttps!=null && ttps.size()>0){
											for(int x=0; x<ttps.size(); x++){
												Coa coax = (Coa)ttps.get(x);
												
												
												
										%>
                                        <option value="<%=coax.getOID()%>" <%if(oidAccount==coax.getOID()){%>selected<%}%>><%=coax.getCode()+" - "+coax.getName()%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"> 
                                      <table width="65%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="64%" class="tablehdr">Uraian</td>
                                          <td width="24%" class="tablehdr">Saldo 
                                            BYHMD</td>
                                          <td width="12%" class="tablehdr">&nbsp;</td>
                                        </tr>
                                        <%
										 double tTotal = 0;
										 if(temp!=null && temp.size()>0){
											for(int i=0; i<temp.size(); i++){
												GlDetail cr = (GlDetail)temp.get(i);
												
												RptSaldoHDL detail = new RptSaldoHDL();
												
												Vendor v = new Vendor();
												try{
													v = DbVendor.fetchExc(cr.getCustomerId());
												}
												catch(Exception e){
												}
												
												detail.setUnitBYMHD(""+v.getCode()+" - "+v.getName());
												detail.setSaldoBYMHD(cr.getDebet());
												objReport.add(detail);
												
											    tTotal = tTotal + cr.getDebet();
												
												if(i%2==0){
										%>
                                        <tr> 
                                          <td width="64%" class="tablecell" nowrap><%=v.getCode()+" - "+v.getName()%></td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=JSPFormater.formatNumber(cr.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td width="12%" class="tablecell"> 
                                            <div align="center"><a href="javascript:cmdDetail('<%=v.getOID()%>')">Detail</a></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td width="64%" class="tablecell1" nowrap><%=v.getCode()+" - "+v.getName()%></td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><%=JSPFormater.formatNumber(cr.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td width="12%" class="tablecell1"> 
                                            <div align="center"><a href="javascript:cmdDetail('<%=v.getOID()%>')">Detail</a></div>
                                          </td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%"> 
                                            <%if(temp!=null && temp.size()>0){%>
                                            <a href="javascript:cmdPrintDeposit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/print2.gif',1)"><img src="../images/print.gif" name="print1" width="53" height="22" border="0"></a> 
                                            <%}%>
                                          </td>
                                          <td width="24%"> 
                                            <%if(temp!=null && temp.size()>0){%>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td width="21%"><b>T O T A L</b></td>
                                                <td width="79%"> 
                                                  <div align="right"> 
                                                    <%
													    rptKonstan.setTotalTitipan(tTotal);
												     %>
                                                    <b><%=JSPFormater.formatNumber(tTotal, "#,###.##")%></b> </div>
                                                </td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="64%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", objReport);
						%>
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
