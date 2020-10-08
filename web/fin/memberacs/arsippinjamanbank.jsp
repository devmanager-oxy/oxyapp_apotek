 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checkmm.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

SrcPinjaman srcPinjaman = new SrcPinjaman();

JspSrcPinjaman jspSrcPinjaman = new JspSrcPinjaman(request, srcPinjaman);
jspSrcPinjaman.requestEntityObject(srcPinjaman);

if(iJSPCommand==JSPCommand.BACK){
	srcPinjaman = (SrcPinjaman)session.getValue("SRC_PINJAMAN");
}

Vector temp = new Vector();
int count = 0;

srcPinjaman.setNoAnggota(loginMember.getNoMember());
srcPinjaman.setIgnoreDate(1);
srcPinjaman.setIgnoreAmount(1);

//if(iJSPCommand == JSPCommand.NONE){
	srcPinjaman.setIgnoreDate(1);
	srcPinjaman.setIgnoreAmount(1);
	srcPinjaman.setStatus(-1);
	srcPinjaman.setJenisPinjaman(-1);
	srcPinjaman.setType(DbPinjaman.TYPE_PINJAMAN_BANK);
//}

//if(iJSPCommand == JSPCommand.LIST){
	temp = SrcPinjaman.getList(0,0, srcPinjaman);
	count = SrcPinjaman.getCount(srcPinjaman);
//}

session.putValue("SRC_PINJAMAN", srcPinjaman);
//out.println("temp : "+temp);
//out.println("<br>count : "+count);


%>
<html >
<!-- #BeginTemplate "/Templates/indexmm.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=spTitle%></title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdSearch(){
	document.form1.command.value="<%=JSPCommand.LIST%>";
	document.form1.action="arsippinjamanbank.jsp";
	document.form1.submit();
}

function cmdEdit(oid, i){
	//alert(i);
	if(parseInt(i)==0){
		document.form1.hidden_pinjaman_id.value=oid;
		document.form1.command.value="<%=JSPCommand.EDIT%>";
		document.form1.action="pinjamanbank.jsp";
		document.form1.submit();
	}
	else{
		document.form1.hidden_pinjaman_id.value=oid;
		document.form1.command.value="<%=JSPCommand.EDIT%>";
		document.form1.action="pinjamanbankanuitas.jsp";
		document.form1.submit();
	}
}

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function checkNumber(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber1(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = result;//formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Arsip Pinjaman Bank<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="hidden_pinjaman_id" value="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspSrcPinjaman.colNames[JspSrcPinjaman.JSP_TYPE]%>" value="<%=DbPinjaman.TYPE_PINJAMAN_BANK%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr>
                                    <td width="10%">&nbsp;</td>
                                    <td width="32%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="10%"><b>NIK</b></td>
                                    <td width="32%">: <%=loginMember.getNoMember()%></td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="10%"><b>Nama Anggota</b></td>
                                    <td width="32%">: <%=loginMember.getNama()%> </td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp;</td>
                                    <td width="32%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="6%">NIK</td>
                                          <td class="tablehdr" width="16%">Nama</td>
                                          <td class="tablehdr" width="9%">Tanggal</td>
                                          <td class="tablehdr" width="14%">Bank</td>
                                          <td class="tablehdr" width="12%">No 
                                            Rekening</td>
                                          <td class="tablehdr" width="8%">Jenis 
                                            Pinjaman</td>
                                          <td class="tablehdr" width="13%">Jenis 
                                            Bunga</td>
                                          <td class="tablehdr" width="13%">Total 
                                            Pinjaman</td>
                                          <td class="tablehdr" width="9%">Status</td>
                                        </tr>
                                        <%if(temp!=null && temp.size()>0){
										for(int i=0;i<temp.size(); i++){
											Pinjaman pinjaman = (Pinjaman)temp.get(i);
											Member member = new Member();
											try{
												member = DbMember.fetchExc(pinjaman.getMemberId());
											}
											catch(Exception e){
											}
											
											Bank bank = new Bank();
											try{
												bank = DbBank.fetchExc(pinjaman.getBankId());
											}
											catch(Exception e){
											}
											
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell" width="6%"><%=member.getNoMember()%></td>
                                          <td class="tablecell" width="16%"><a href="javascript:cmdEdit('<%=pinjaman.getOID()%>','<%=pinjaman.getJenisCicilan()%>')"><%=member.getNama()%></a></td>
                                          <td class="tablecell" width="9%"><%=JSPFormater.formatDate(pinjaman.getDate(), "dd MMMM yyyy")%></td>
                                          <td class="tablecell" width="14%"><%=bank.getName()%></td>
                                          <td class="tablecell" width="12%"><%=pinjaman.getNumber()%></td>
                                          <td class="tablecell" width="8%"><%=DbPinjaman.strJenisBarang[pinjaman.getJenisBarang()]%></td>
                                          <td class="tablecell" width="13%"><%=DbPinjaman.strJenisCicilan[pinjaman.getJenisCicilan()]%></td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(pinjaman.getTotalPinjaman(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="9%"> 
                                            <div align="center"><%=DbPinjaman.strStatus[pinjaman.getStatus()]%></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell1" width="6%"><%=member.getNoMember()%></td>
                                          <td class="tablecell1" width="16%"><a href="javascript:cmdEdit('<%=pinjaman.getOID()%>','<%=pinjaman.getJenisCicilan()%>')"><%=member.getNama()%></a></td>
                                          <td class="tablecell1" width="9%"><%=JSPFormater.formatDate(pinjaman.getDate(), "dd MMMM yyyy")%></td>
                                          <td class="tablecell1" width="14%"><%=bank.getName()%></td>
                                          <td class="tablecell1" width="12%"><%=pinjaman.getNumber()%></td>
                                          <td class="tablecell1" width="8%"><%=DbPinjaman.strJenisBarang[pinjaman.getJenisBarang()]%></td>
                                          <td class="tablecell1" width="13%"><%=DbPinjaman.strJenisCicilan[pinjaman.getJenisCicilan()]%></td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(pinjaman.getTotalPinjaman(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="9%"> 
                                            <div align="center"><%=DbPinjaman.strStatus[pinjaman.getStatus()]%></div>
                                          </td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="6%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp;</td>
                                    <td width="32%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp;</td>
                                    <td width="32%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
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
