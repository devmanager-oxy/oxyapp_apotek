 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checkmm.jsp"%>
<%

int iJSPCommand = JSPRequestValue.requestCommand(request);
String str = DbSystemProperty.getValueByName("COA_MINIMARKET");
StringTokenizer strTok = new StringTokenizer(str, ",");
Vector ttps = new Vector();
while(strTok.hasMoreTokens()){
	ttps.add(DbCoa.getCoaByCode((String)strTok.nextToken()));
}

long vendorId = JSPRequestValue.requestLong(request, "vendor_id");
Member vendor = new Member();
try{
	vendor = DbMember.fetchExc(vendorId);
}
catch(Exception e){
}
//out.println("vendorId : "+vendorId);

long oidAccount = JSPRequestValue.requestLong(request, "account_id");

Vector vnds = DbMember.list(0,0, "","no_member, nama"); 

String where = "";
if(oidAccount!=0){
	where = "coa_id="+oidAccount+" and ";
}

//Vector uFTrans = DbGlDetail.getUnfinishTransaction(oidAccount, ttps);
Vector uFTrans = new Vector();
if(vendorId!=0){
	uFTrans = DbGlDetail.list(0,0, where+"customer_id="+vendorId, "gl_id");//DbGlDetail.getUnfinishTransaction(oidAccount, ttps);
}

if(iJSPCommand==JSPCommand.SAVE){
	if(uFTrans!=null && uFTrans.size()>0){
		for(int i=0; i<uFTrans.size(); i++){
			//Vector xTemp = (Vector)uFTrans.get(i);
			//GlDetail gd = (GlDetail)xTemp.get(1);
			GlDetail gd = (GlDetail)uFTrans.get(i);
			long oidCus = JSPRequestValue.requestLong(request, "customer_id_"+gd.getOID());
			if(oidCus!=0){
				gd.setCustomerId(oidCus);
				gd.setStatusTransaction(1);
				try{
					DbGlDetail.updateExc(gd);
				}
				catch(Exception e){
				}
			}
		}
	}
	
	if(vendorId!=0){
		uFTrans = DbGlDetail.list(0,0, where+"customer_id="+vendorId, "gl_id");//DbGlDetail.getUnfinishTransaction(oidAccount, ttps);
	}
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexmm.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--



function cmdChange(){
	document.form1.action="saldominimarketaudit.jsp";
	document.form1.submit();
}

function cmdSave(){
	document.form1.action="saldominimarketaudit.jsp";
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.submit();
}


function cmdPrintDeposit(){	 
	window.open("<%=printroot%>.report.RptSaldoDepositXLS?idx=<%=System.currentTimeMillis()%>");
}

<!--

//-->//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenumm.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menumm.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --> 
                        <span class="level1">Simpan 
                        Pinjam</span> &raquo; <span class="level2">Daftar Pinjaman 
                        Minimarket<br>
                        </span>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="vendor_id" value="<%=vendorId%>">
                          <input type="hidden" name="account_id" value="<%=oidAccount%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">Anggota</td>
                                    <td width="91%"><b>&nbsp; <%=vendor.getNama()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="9%">&nbsp;</td>
                                    <td width="91%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="12%" class="tablehdr">Trans. 
                                            Date </td>
                                          <td width="17%" class="tablehdr">Debet</td>
                                          <td width="16%" class="tablehdr">Credit</td>
                                          <td width="55%" class="tablehdr">Description</td>
                                        </tr>
                                        <%
										 double tTotal = 0;
										 double tDebet = 0;
										 double tCredit = 0;
										 
										 if(uFTrans!=null && uFTrans.size()>0){
											for(int i=0; i<uFTrans.size(); i++){
												//Vector temp = (Vector)uFTrans.get(i);
												GlDetail gd = (GlDetail)uFTrans.get(i);
												
												//out.println(gd.getGlId());
												
												Gl gl = new Gl();
												try{
													gl = DbGl.fetchExc(gd.getGlId());
												}
												catch(Exception e){
												}
												
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(gd.getCoaId());
												}
												catch(Exception e){
												}
												
												tDebet = tDebet + gd.getDebet();
												tCredit = tCredit + gd.getCredit();
												
												tTotal =  tTotal + (gd.getDebet() - gd.getCredit()); 
												
												if(i%2==0){
										%>
                                        <tr> 
                                          <td width="12%" class="tablecell"> 
                                            <div align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></div>
                                          </td>
                                          <td width="17%" class="tablecell"> 
                                            <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td width="16%" class="tablecell"> 
                                            <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
                                          </td>
                                          <td width="55%" class="tablecell"><%=gl.getMemo()+" - "+gd.getMemo()%></td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td width="12%" class="tablecell1"> 
                                            <div align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></div>
                                          </td>
                                          <td width="17%" class="tablecell1"> 
                                            <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##")%></div>
                                          </td>
                                          <td width="16%" class="tablecell1"> 
                                            <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
                                          </td>
                                          <td width="55%" class="tablecell1"><%=gl.getMemo()+" - "+gd.getMemo()%></td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="12%" height="25"> 
                                            <div align="right"><b>T O T A L : 
                                              </b></div>
                                          </td>
                                          <td width="17%" height="25"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(tDebet, "#,###")%></b></div>
                                          </td>
                                          <td width="16%" height="25"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(tCredit, "#,###")%></b></div>
                                          </td>
                                          <td width="55%" height="25">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%" height="26"> 
                                            <div align="right"><b>S A L D O : 
                                              </b></div>
                                          </td>
                                          <td width="17%" height="26"> 
                                            <div align="right"><b></b></div>
                                          </td>
                                          <td width="16%" height="26"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(tTotal, "#,###")%></b></div>
                                          </td>
                                          <td width="55%" height="26">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="55%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="55%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="55%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="55%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="55%">&nbsp;</td>
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
            <%@ include file="../main/footermm.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
