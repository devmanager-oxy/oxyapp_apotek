 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>

<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "com.project.fms.master.*" %>

<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%

int iJSPCommand = JSPRequestValue.requestCommand(request);
int srcJenisBarang = JSPRequestValue.requestInt(request, "src_jenis_barang");
int srcTypePinjaman = JSPRequestValue.requestInt(request, "src_type_pinjaman");

if(iJSPCommand!=JSPCommand.SUBMIT){
	srcJenisBarang = -1;
	srcTypePinjaman = -1;
}

int srcOrder = JSPRequestValue.requestInt(request, "src_order");
long srcPeriodId = JSPRequestValue.requestLong(request, "src_period_id");
String srcName = JSPRequestValue.requestString(request, "src_name");
String srcNik = JSPRequestValue.requestString(request, "src_no");

Vector periods = DbPeriode.list(0,0,"", "start_date desc");
if(srcPeriodId==0 && periods!=null && periods.size()>0){
	Periode per = (Periode)periods.get(0);
	srcPeriodId = per.getOID();
}
	
Vector temp = DbBayarPinjaman.getPembayaran(srcTypePinjaman, srcJenisBarang, srcPeriodId, srcName, srcNik, srcOrder);

//object for get value
RptTypeLaporan rptKonstan = new RptTypeLaporan();
Vector vTempDetail = new Vector();
Vector vTemp = new Vector();


%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Simpan Pinjam</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--

function cmdChange(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="rpt_pembayaran.jsp";
	document.form1.submit();
}

function cmdPrintSumrayXLS(){	 
	window.open("<%=printroot%>.report.RptLaporanPiutangSumrayXLS?idx=<%=System.currentTimeMillis()%>");
}

function cmdPrintDetailXLS(){	 
	window.open("<%=printroot%>.report.RptLaporanPiutangDetailXLS?idx=<%=System.currentTimeMillis()%>");
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Laporan Pembayaran Pinjaman<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td> 
                                      <table width="69%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="15%" height="25" nowrap><b>Jenis 
                                            Pinjaman&nbsp;</b></td>
                                          <td width="31%" height="25"> 
                                            <select name="src_jenis_barang" onChange="javascript:cmdChange()">
											  <option value="-1" <%if(srcJenisBarang==-1){%>selected<%}%>>-</option>	
                                              <%for(int i=0; i<DbPinjaman.strJenisBarang.length; i++){%>
                                              <option value="<%=i%>" <%if(i==srcJenisBarang){%>selected<%}%>><%=DbPinjaman.strJenisBarang[i]%></option>
                                              <%}%>
                                            </select>
                                          </td>
                                          <td width="14%" height="25"><b>NIK</b></td>
                                          <td width="40%" height="25"> 
                                            <input type="text" name="src_nik" value="<%=srcNik%>">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="15%" height="20"><b>Pinjaman</b></td>
                                          <td width="31%" height="20"> 
                                            <select name="src_type_pinjaman" onChange="javascript:cmdChange()">
                                              <option value="-1" <%if(srcTypePinjaman==-1){%>selected<%}%>>-</option>
                                              <option value="0" <%if(srcTypePinjaman==0){%>selected<%}%>>Koperasi</option>
                                              <option value="1" <%if(srcTypePinjaman==1){%>selected<%}%>>Bank 
                                              Mandiri</option>
                                            </select>
                                          </td>
                                          <td width="14%" height="20"><b>Nama</b></td>
                                          <td width="40%" height="20"> 
                                            <input type="text" name="src_name" value="<%=srcName%>">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="15%" height="20"><b>Periode</b></td>
                                          <td width="31%" height="20"> 
                                            <select name="src_period_id">
                                              <%if(periods!=null && periods.size()>0){
											for(int i=0; i<periods.size(); i++){
												Periode perx = (Periode)periods.get(i);
											%>
                                              <option value="<%=perx.getOID()%>" <%if(perx.getOID()==srcPeriodId){%>selected<%}%>><%=perx.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td width="14%" height="20" nowrap><b>Urutkan 
                                            Dengan&nbsp; </b></td>
                                          <td width="40%" height="20"> 
                                            <select name="src_order">
                                              <option value="0" <%if(srcOrder==0){%>selected<%}%>>Tanggal</option>
                                              <option value="1" <%if(srcOrder==1){%>selected<%}%>>Nama</option>
                                              <option value="2" <%if(srcOrder==2){%>selected<%}%>>Nik</option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" height="10"> </td>
                                        </tr>
                                        <tr> 
                                          <td width="15%" height="20">&nbsp;</td>
                                          <td width="31%" height="20"> 
                                            <input type="button" name="Button" value="Get Report" onClick="javascript:cmdChange()">
                                          </td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="40%" height="20">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <%
								  
								  double totalAmount = 0;
								  double totalBunga = 0;
								  double totalDenda = 0;
								  double totalPinalti = 0;
								  
								 %>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecell">
                                        <tr> 
                                          <td width="2%" class="tablehdr">No</td>
                                          <td width="8%" class="tablehdr">NIK</td>
                                          <td width="15%" class="tablehdr">Nama</td>
                                          <td width="13%" class="tablehdr">Nomor 
                                            Rekening</td>
                                          <td width="10%" class="tablehdr">Jenis 
                                            Barang </td>
                                          <td width="10%" class="tablehdr">Tgl. 
                                            Pembayaran</td>
                                          <td width="11%" class="tablehdr">No 
                                            Pembayaran</td>
                                          <td width="11%" class="tablehdr">Pokok</td>
                                          <td width="9%" class="tablehdr">Bunga</td>
                                          <td width="7%" class="tablehdr">Denda</td>
                                          <td width="7%" class="tablehdr">Pinalti</td>
                                          <td width="7%" class="tablehdr">Angsuran 
                                            Ke</td>
                                        </tr>
                                        <%
										
											
										if(temp!=null && temp.size()>0){
										
											
										  
										  	for(int i=0; i<temp.size(); i++){
												
												BayarPinjaman bp = (BayarPinjaman)temp.get(i);
												
												Pinjaman p = new Pinjaman();
												try{
													p = DbPinjaman.fetchExc(bp.getPinjamanId());
												}
												catch(Exception e){
													System.out.println(e.toString());
												}
												
												RptLaporanPiutangDetail detail = new RptLaporanPiutangDetail();
												
												//System.out.println("p.getMemberId() : "+p.getMemberId()); 
												
												Member m = new Member();
												try{
													m = DbMember.fetchExc(p.getMemberId());
												}
												catch(Exception e){
													System.out.println(e.toString());
												}
												
												totalAmount = totalAmount + bp.getAmount();
												totalBunga = totalBunga + bp.getBunga();
												totalDenda = totalDenda + bp.getDenda();
												totalPinalti = totalPinalti + bp.getPinalti();
												
												detail.setNik(m.getNoMember());
												detail.setNama(m.getNama());
												detail.setNoRekening(p.getNumber());
												detail.setTanggal(p.getDate());
												detail.setTotalPinjaman(bp.getAmount());
												detail.setTotalAngsuran(bp.getBunga());
												double stSaldo = bp.getAmount();
												detail.setTotalSaldo(stSaldo);
												vTempDetail.add(detail);
												
												if(i%2==0){
										%>
                                        <tr> 
                                          <td width="2%" class="tablecell" height="20"><%=i+1%></td>
                                          <td width="8%" class="tablecell" height="20"> 
                                            <div align="center"><%=m.getNoMember()%></div>
                                          </td>
                                          <td width="15%" class="tablecell" height="20" nowrap><%=m.getNama()%></td>
                                          <td width="13%" class="tablecell" height="20"> 
                                            <div align="center"><%=p.getNumber()%></div>
                                          </td>
                                          <td width="10%" class="tablecell" height="20"> 
                                            <div align="center"><%=DbPinjaman.strJenisBarang[p.getJenisBarang()]%></div>
                                          </td>
                                          <td width="10%" class="tablecell" height="20"> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTanggal(), "dd/MM/yyyy")%></div>
                                          </td>
                                          <td width="11%" class="tablecell" height="20"> 
                                            <div align="center"><%=bp.getNoTransaksi()%></div>
                                          </td>
                                          <td width="11%" class="tablecell" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td width="9%" class="tablecell" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getBunga(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getDenda(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getPinalti(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell" height="20"> 
                                            <div align="center"><%=bp.getCicilanKe()%></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td width="2%" class="tablecell1" height="20"><%=i+1%></td>
                                          <td width="8%" class="tablecell1" height="20"> 
                                            <div align="center"><%=m.getNoMember()%></div>
                                          </td>
                                          <td width="15%" class="tablecell1" height="20" nowrap><%=m.getNama()%></td>
                                          <td width="13%" class="tablecell1" height="20"> 
                                            <div align="center"><%=p.getNumber()%></div>
                                          </td>
                                          <td width="10%" class="tablecell1" height="20"> 
                                            <div align="center"><%=DbPinjaman.strJenisBarang[p.getJenisBarang()]%></div>
                                          </td>
                                          <td width="10%" class="tablecell1" height="20"> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTanggal(), "dd/MM/yyyy")%></div>
                                          </td>
                                          <td width="11%" class="tablecell1" height="20"> 
                                            <div align="center"><%=bp.getNoTransaksi()%></div>
                                          </td>
                                          <td width="11%" class="tablecell1" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td width="9%" class="tablecell1" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getBunga(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell1" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getDenda(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell1" height="20"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getPinalti(), "#,###.##")%></div>
                                          </td>
                                          <td width="7%" class="tablecell1" height="20"> 
                                            <div align="center"><%=bp.getCicilanKe()%></div>
                                          </td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="2%" height="22">&nbsp;</td>
                                          <td width="8%" height="22">&nbsp;</td>
                                          <td width="15%" height="22">&nbsp;</td>
                                          <td width="13%" height="22">&nbsp;</td>
                                          <td width="10%" bgcolor="#E1E1E1" height="22">&nbsp;</td>
                                          <td width="10%" bgcolor="#E1E1E1" height="22">&nbsp;</td>
                                          <td width="11%" bgcolor="#E1E1E1" height="22"><b>T 
                                            O T A L :</b></td>
                                          <td width="11%" bgcolor="#E1E1E1" height="22"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(totalAmount, "#,###.##")%></b></div>
                                          </td>
                                          <td width="9%" bgcolor="#E1E1E1" height="22"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(totalBunga, "#,###.##")%></b></div>
                                          </td>
                                          <td width="7%" bgcolor="#E1E1E1" height="22"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(totalDenda, "#,###.##")%></b></div>
                                          </td>
                                          <td width="7%" bgcolor="#E1E1E1" height="22"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(totalPinalti, "#,###.##")%></b></div>
                                          </td>
                                          <td width="7%" bgcolor="#E1E1E1" height="22">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  
                                  <!--tr> 
                                    <td> 
                                      <table width="30%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          
                                          <td width="9%"><a href="javascript:cmdPrintDetailXLS()"><img src="../images/print2.gif" width="53" height="22" border="0"></a></td>
                                          
                                        </tr>
                                      </table>
                                    </td>
                                  </tr-->
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", vTempDetail);
							session.putValue("SUMRAY", vTemp);
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
