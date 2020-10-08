 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%@ include file="paramsp.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%!
public boolean checkCoa(Coa coa, String[] strs){
	for(int i=0; i<strs.length; i++){
		if(coa.getCode().equals(strs[i])){
			return true;
		}
	}
	return false;
}
%>
<!-- Jsp Block -->
<%

	int iErrCode = JSPMessage.ERR_NONE;
	String errMsg = "";
	String whereClause = "";
	String orderClause = "";
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request,"start");

	//out.println("<br>iJSPCommand : "+iJSPCommand);
	
	
	long memberId = JSPRequestValue.requestLong(request, "hidden_member_id");
	long pinjamanId = JSPRequestValue.requestLong(request, "hidden_pinjaman_id");
	long pinjamanDetailId = JSPRequestValue.requestLong(request, "hidden_pinjaman_detail_id");
	long oidBayarPinjaman = JSPRequestValue.requestLong(request, "hidden_bayar_pinjaman_id");
	int bayarType = JSPRequestValue.requestInt(request, "hidden_bayar_type");
	
	//out.println("memberId : "+memberId);
	//out.println("<br>pinjamanId : "+pinjamanId);
	//out.println("<br>pinjamanDetailId : "+pinjamanDetailId);
	//out.println("<br>oidBayarPinjaman : "+oidBayarPinjaman);
	
	if(iJSPCommand==JSPCommand.EDIT){
		Vector temp = DbBayarPinjaman.list(0,0, "pinjaman_detail_id="+pinjamanDetailId, "");
		if(temp!=null && temp.size()>0){
			BayarPinjaman x = (BayarPinjaman)temp.get(0);
			oidBayarPinjaman = x.getOID();
		}
	}
	
	Pinjaman pinjaman = new Pinjaman();
	PinjamanDetail pd = new PinjamanDetail();
	Member member = new Member();
	
	try{
		pinjaman = DbPinjaman.fetchExc(pinjamanId);
	}
	catch(Exception e){
	}
	
	Bank bank = new Bank();
	try{
		bank = DbBank.fetchExc(pinjaman.getBankId());
	}
	catch(Exception e){
	}
	
	try{
		pd = DbPinjamanDetail.fetchExc(pinjamanDetailId);
	}
	catch(Exception e){
		out.println("exception e : ");
	}
	
	try{
		member = DbMember.fetchExc(pinjaman.getMemberId());
		memberId = pinjaman.getMemberId();
	}
	catch(Exception e){
	}
	

	CmdBayarPinjaman ctrlBayarPinjaman = new CmdBayarPinjaman(request);
	
	JSPLine ctrLine = new JSPLine();

	iErrCode = ctrlBayarPinjaman.action(iJSPCommand , oidBayarPinjaman);

	errMsg = ctrlBayarPinjaman.getMessage();
	JspBayarPinjaman jspBayarPinjaman = ctrlBayarPinjaman.getForm();
	BayarPinjaman bayarPinjaman = ctrlBayarPinjaman.getBayarPinjaman();
	oidBayarPinjaman = bayarPinjaman.getOID();

	if(iJSPCommand==JSPCommand.ADD){
		//out.println("pd.getCicilanKe() : "+pd.getCicilanKe());
		//out.println("pd.getAmount() : "+pd.getAmount());
		//out.println("pd.getBunga() : "+pd.getBunga());
	
		bayarPinjaman.setCicilanKe(pd.getCicilanKe());
		bayarPinjaman.setAmount(pd.getAmount());
		bayarPinjaman.setBunga(pd.getBunga());
	}
	
	if(iJSPCommand==JSPCommand.SAVE && bayarPinjaman.getOID()!=0 && iErrCode==0){
		if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
			DbBayarPinjaman.postJournal(pinjaman, bayarPinjaman);
		}else{		
			DbBayarPinjaman.postJournalPaymenKop(pinjaman, bayarPinjaman);
		}
	}

%>
<!-- End of Jsp Block -->
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

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
		
		cmdTotal();
	}
	
	function checkNumber1(obj){
		var st = obj.value;
		
		result = removeChar(st);
		
		result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		cmdTotal1();
		
	}
	
	function cmdTotal(){
		var pokok = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_AMOUNT]%>.value;
		pokok = cleanNumberFloat(pokok, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var bungaBulanan = document.frm_bayarpinjaman.bunga_bulanan.value;
		
		var bunga;
		<%if(pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP){%>
			bunga = parseFloat(pokok) * (parseFloat(bungaBulanan)/100);
			document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_BUNGA]%>.value = formatFloat(""+bunga, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		<%}else{%>		
			bunga = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_BUNGA]%>.value;
			bunga = cleanNumberFloat(bunga, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		<%}%>
		
		//alert(bunga);
		
		var denda = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_DENDA]%>.value;
		denda = cleanNumberFloat(denda, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		<%if(pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP){%>
			total = parseFloat(pokok) + bunga + parseFloat(denda);
		<%}else{%>
			total = parseFloat(pokok) + parseFloat(bunga) + parseFloat(denda);
		<%}%>
		
		document.frm_bayarpinjaman.total.value = formatFloat(""+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	}
	
	function cmdTotal1(){
		var pokok = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_AMOUNT]%>.value;
		pokok = cleanNumberFloat(pokok, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var bunga;
			bunga = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_BUNGA]%>.value;
			bunga = cleanNumberFloat(bunga, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert(bunga);
		
		var denda = document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_DENDA]%>.value;
		denda = cleanNumberFloat(denda, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
			total = parseFloat(pokok) + parseFloat(bunga) + parseFloat(denda);
		
		document.frm_bayarpinjaman.total.value = formatFloat(""+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	}

	function cmdAdd(){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.ADD%>";
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit();
	} 
	function cmdCancel(){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.CANCEL%>";
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit();
	} 

	function cmdEdit(oid){ 
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.EDIT%>";
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit(); 
	} 

	function cmdSave(){
		if(confirm("Proses ini tidak bisa dibatalkan, anda yakin melakukan proses ini ? ")){
			document.frm_bayarpinjaman.command.value="<%=JSPCommand.SAVE%>"; 
			document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
			document.frm_bayarpinjaman.submit();
		}
	}

	function cmdAsk(oid){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.ASK%>"; 
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit();
	} 

	function cmdConfirmDelete(oid){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.DELETE%>";
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp"; 
		document.frm_bayarpinjaman.submit();
	}  

	function cmdBack(){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.EDIT%>";
		<%if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI){%> 
			document.frm_bayarpinjaman.action="pinjaman.jsp";
		<%}else{
			if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){		
				if(pinjaman.getJenisCicilan()==0){		
				%>
					document.frm_bayarpinjaman.action="pinjamanbank.jsp";
				<%}else{%>
					document.frm_bayarpinjaman.action="pinjamanbankanuitas_view.jsp";
				<%}
			}else{%>	
				document.frm_bayarpinjaman.action="pinjamankopbankanuitas.jsp";
		<%}}%>
		document.frm_bayarpinjaman.submit();
	}

//-------------- script form image -------------------

	function cmdDelPic(oid){
		document.frm_bayarpinjaman.command.value="<%=JSPCommand.POST%>"; 
		document.frm_bayarpinjaman.action="bayarpinjaman.jsp";
		document.frm_bayarpinjaman.submit();
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
<script type="text/javascript">
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
                        <span class="level2">Angsuran Pinjaman 
                        <%if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI){%>
                        Koperasi 
                        <%}else{%>
                        Bank 
                        <%}%>
                        <br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_bayarpinjaman" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="hidden_member_id" value="<%=memberId%>">
                          <input type="hidden" name="hidden_pinjaman_id" value="<%=pinjamanId%>">
                          <input type="hidden" name="hidden_bayar_type" value="<%=bayarType%>">
                          <input type="hidden" name="hidden_pinjaman_detail_id" value="<%=pinjamanDetailId%>">
                          <input type="hidden" name="hidden_bayar_pinjaman_id" value="<%=oidBayarPinjaman%>">
                          <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_PINJAMAN_ID]%>" value="<%=pinjamanId%>">
                          <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_PINJAMAN_DETAIL_ID]%>" value="<%=pinjamanDetailId%>">
                          <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_MEMBER_ID]%>" value="<%=memberId%>">
                          <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_TYPE]%>" value="<%=DbBayarPinjaman.TYPE_ANGSURAN%>">
						  <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_TYPE_PINJAMAN]%>" value="<%=pinjaman.getType()%>">
                          <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_USER_ID]%>" value="<%=(bayarPinjaman.getOID()==0) ? user.getOID() : bayarPinjaman.getUserId()%>">
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" width="11%">&nbsp;</td>
                                    <td height="21" width="20%">&nbsp; 
                                    <td height="21" width="13%">&nbsp; 
                                    <td height="21" width="56%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" width="11%"> 
                                      <%if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){%>
                                      Peminjam 
                                      <%}else{%>
                                      Anggota 
                                      <%}%>
                                    </td>
                                    <td height="21" width="20%"> 
                                      <%if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){%>
                                      KOPERASI 
                                      <%}else{%>
                                      <%=member.getNoMember()+" / "+member.getNama()%> 
                                      <%}%>
                                    <td height="21" width="13%">Nomor Rekening 
                                      Pinjaman 
                                    <td height="21" width="56%"> <%= pinjaman.getNumber() %> 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Tanggal</td>
                                    <td height="21" width="20%"> <%=JSPFormater.formatDate((pinjaman.getDate()==null) ? new Date() : pinjaman.getDate(), "dd/MM/yyyy")%> 
                                    <td height="21" width="13%">Bunga Pinjaman 
                                    <td height="21" width="56%"><%= (pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP) ? pinjaman.getBunga() : pd.getBungaKoperasiPercent() %> % /bulan <input type="hidden" name="bunga_bulanan" value="<%= (pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP) ? pinjaman.getBunga() : pd.getBungaKoperasiPercent() %>">
                                  <tr align="left"> 
                                    <td height="21" width="11%">Total Pinjaman</td>
                                    <td height="21" width="20%"> <%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %> 
                                    <td height="21" width="13%"><%=(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "" : "Bank"%> 
                                    <td height="21" width="56%"><%=(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "" : bank.getName()%> 
                                  <tr align="left" > 
                                    <td colspan="4" valign="top">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" cellspacing="1" cellpadding="1" >
                                  <tr align="left"> 
                                    <td width="11%"  >Tanggal</td>
                                    <td  width="20%"> 
                                      <input name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_TANGGAL]%>" value="<%=JSPFormater.formatDate((bayarPinjaman.getTanggal()==null) ? new Date() : bayarPinjaman.getTanggal(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frm_bayarpinjaman.<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_TANGGAL]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_TANGGAL)%></td>
                                    <td  width="13%">No Transaksi</td>
                                    <td  width="56%"> 
                                      <%
									  int cnt = DbBayarPinjaman.getNextCounter(pinjaman.getType());
									  String num = DbBayarPinjaman.getNextNumber(cnt, pinjaman.getType());
									  if(bayarPinjaman.getOID()!=0){
									  		num = bayarPinjaman.getNoTransaksi();
									  }
									  %>
                                      <input type="text" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_NO_TRANSAKSI]%>" value="<%=num%>" class="formElemen" readonly>
                                      <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_NO_TRANSAKSI)%></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="11%"  >Cicilan Ke</td>
                                    <td  width="20%"> 
                                      <input type="text" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_CICILAN_KE]%>" value="<%=bayarPinjaman.getCicilanKe()%>" class="formElemen" readonly style="text-align:right">
                                      * <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_CICILAN_KE)%></td>
                                    <td  width="13%">&nbsp;</td>
                                    <td  width="56%">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="11%"  >Pokok Pinjaman</td>
                                    <td  width="20%"> 
                                      <input type="text" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(bayarPinjaman.getAmount(),"#,###.##")%>" class="formElemen" style="text-align:right"  onBlur="javascript:checkNumber(this)" onClick="this.select()" <%if(pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP){%><%}%>>
                                      * <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_AMOUNT)%></td>
                                    <td  width="13%" bgcolor="#F5F5F5"> 
                                      <div align="center"><b>Detail Journal </b></div>
                                    </td>
                                    <td  width="56%">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr>
                                          <td height="23" bgcolor="#990000"> 
                                            <div align="center"><b><font color="#FFFFFF"> 
                                              ANGSURAN <%=DbPinjaman.strJenisBarang[pinjaman.getJenisBarang()]%></font></b></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="11%"  >Bunga</td>
                                    <td  width="20%"> 
                                      <input type="text" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_BUNGA]%>" value="<%=JSPFormater.formatNumber(bayarPinjaman.getBunga(),"#,###.##")%>" class="formElemen" onBlur="javascript:checkNumber1(this)" style="text-align:right" onClick="this.select()" <%if(pinjaman.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_TETAP){%><%}%>>
                                      * <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_BUNGA)%></td>
                                    <td colspan="2" rowspan="6" valign="top"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%" height="21"><b>Keterangan</b></td>
                                          <td width="85%" height="21"><b>Debet</b></td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%"> Pokok Diterima Pada 
                                          </td>
                                          <td width="85%" nowrap> 
                                            <%
											Vector temp = new Vector();
											if(bayarPinjaman.getOID()==0){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_POKOK_DEBET_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
																
																boolean coaOK = false;
																switch(pinjaman.getJenisBarang()){
																	case DbPinjaman.JENIS_BARANG_CASH :
																		coaOK = checkCoa(cx, debetPokokCash);
																		break;
																	case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																		coaOK = checkCoa(cx, debetPokokElektro);
																		break;
																	case DbPinjaman.JENIS_BARANG_KENDARAAN :
																		coaOK = checkCoa(cx, debetPokokMotor);
																		break;																			
																}
																
																if(coaOK){ 
														  %>
													  			<option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaPokokDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
													  		<%	}
													  }%>
													</select>
													<%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_POKOK_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaPokokDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%" nowrap> Bunga Diterima 
                                            Pada </td>
                                          <td width="85%"> 
                                            <%
											if(bayarPinjaman.getOID()==0){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_BUNGA_DEBET_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
																
																boolean coaOK = false;
																switch(pinjaman.getJenisBarang()){
																	case DbPinjaman.JENIS_BARANG_CASH :
																		coaOK = checkCoa(cx, debetBungaCash);
																		break;
																	case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																		coaOK = checkCoa(cx, debetBungaElektro);
																		break;
																	case DbPinjaman.JENIS_BARANG_KENDARAAN :
																		coaOK = checkCoa(cx, debetBungaMotor);
																		break;																			
																}
																
																if(coaOK){ 
														  %>
                                              <option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaBungaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_BUNGA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaBungaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
												%>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%"> Denda Diterima Pada 
                                          </td>
                                          <td width="85%"> 
                                            <%	
										  if(bayarPinjaman.getOID()==0){
										  
											temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_DEBET+"'", "");											
											if(temp!=null && temp.size()>0){
												if(temp.size()>0){
												%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_DENDA_DEBET_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
													  		AccLink al = (AccLink)temp.get(i);
															Coa cx = new Coa();
															try{
																cx = DbCoa.fetchExc(al.getCoaId());
															}
															catch(Exception e){
															}
															
															boolean coaOK = false;
															switch(pinjaman.getJenisBarang()){
																case DbPinjaman.JENIS_BARANG_CASH :
																	coaOK = checkCoa(cx, debetDendaCash);
																	break;
																case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																	coaOK = checkCoa(cx, debetDendaElektro);
																	break;
																case DbPinjaman.JENIS_BARANG_KENDARAAN :
																	coaOK = checkCoa(cx, debetDendaMotor);
																	break;																			
															}
															
															if(coaOK){ 
													  %>
                                              <option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaDendaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%}else{
													AccLink al = new AccLink();													
													al = (AccLink)temp.get(0);
													Coa cx = new Coa();
													try{
														cx = DbCoa.fetchExc(al.getCoaId());
													}
													catch(Exception e){
													}
												%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_DENDA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											
										}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaDendaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%">&nbsp;</td>
                                          <td width="85%"><b>Kredit</b></td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%" nowrap> Pihutang (AR)</td>
                                          <td width="85%"> 
                                            <%
											if(bayarPinjaman.getOID()==0){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_POKOK_CREDIT_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
																
																boolean coaOK = false;
																switch(pinjaman.getJenisBarang()){
																	case DbPinjaman.JENIS_BARANG_CASH :
																		//0=cash, 1=bank
																		if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI){
																			coaOK = checkCoa(cx, creditPihutangCash);
																		}else if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_BANK){
																			coaOK = checkCoa(cx, creditPihutangCashMandiri);
																		}
																		break;
																	case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																		coaOK = checkCoa(cx, creditPihutangElektro);
																		break;
																	case DbPinjaman.JENIS_BARANG_KENDARAAN :
																		coaOK = checkCoa(cx, creditPihutangMotor);
																		break;																			
																}
																
																if(coaOK){ 
														  %>
                                              <option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaPokokCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_POKOK_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaPokokCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%">Pendapatan Bunga </td>
                                          <td width="85%"> 
                                            <%
											if(bayarPinjaman.getOID()==0){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_BUNGA_CREDIT_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
																
																boolean coaOK = false;
																switch(pinjaman.getJenisBarang()){
																	case DbPinjaman.JENIS_BARANG_CASH :
																		coaOK = checkCoa(cx, creditBungaIncomeCash);
																		break;
																	case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																		coaOK = checkCoa(cx, creditBungaIncomeElektro);
																		break;
																	case DbPinjaman.JENIS_BARANG_KENDARAAN :
																		coaOK = checkCoa(cx, creditBungaIncomeMotor);
																		break;																			
																}
																
																if(coaOK){
														  %>
                                              <option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaBungaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_BUNGA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaBungaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}%>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#E1E1E1"> 
                                          <td width="15%">Pendapatan Denda</td>
                                          <td width="85%"> 
                                            <%
											if(bayarPinjaman.getOID()==0){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                            <select name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_DENDA_CREDIT_ID] %>">
                                              <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
																
																boolean coaOK = false;
																switch(pinjaman.getJenisBarang()){
																	case DbPinjaman.JENIS_BARANG_CASH :
																		coaOK = checkCoa(cx, creditDendaIncomeCash);
																		break;
																	case DbPinjaman.JENIS_BARANG_ELEKTRONIK :
																		coaOK = checkCoa(cx, creditDendaIncomeElektro);
																		break;
																	case DbPinjaman.JENIS_BARANG_KENDARAAN :
																		coaOK = checkCoa(cx, creditDendaIncomeMotor);
																		break;																			
																}
																
																if(coaOK){
														  %>
                                              <option value="<%=cx.getOID()%>" <%if(bayarPinjaman.getCoaDendaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                            <input type="hidden" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_COA_DENDA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                            <%=cx.getCode()+" - "+cx.getName()%> 
                                            <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(bayarPinjaman.getCoaDendaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="15%">&nbsp;</td>
                                          <td width="85%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="15%">&nbsp;</td>
                                          <td width="85%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="11%"  >Denda</td>
                                    <td  width="20%"> 
                                      <input type="text" name="<%=JspBayarPinjaman.colNames[JspBayarPinjaman.JSP_DENDA]%>" value="<%=JSPFormater.formatNumber(bayarPinjaman.getDenda(),"#,###.##")%>" class="formElemen" style="text-align:right" onBlur="javascript:checkNumber1(this)" onClick="this.select()">
                                      <%=jspBayarPinjaman.getErrorMsg(JspBayarPinjaman.JSP_DENDA)%></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2" nowrap> 
                                      <hr width="90%" align="left">
                                      + </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">TOTAL</td>
                                    <td width="20%"> 
                                      <input type="text" name="total" value="" class="formElemen" style="text-align:right" onBlur="javascript:checkNumber1(this)" readonly>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="20%">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="2"> 
                                      <%
							ctrLine.setLocationImg(approot+"/images/ctr_line");
							ctrLine.initDefault();
							ctrLine.setTableWidth("100%");
							String scomDel = "javascript:cmdAsk('"+oidBayarPinjaman+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidBayarPinjaman+"')";
							String scancel = "javascript:cmdEdit('"+oidBayarPinjaman+"')";
							ctrLine.setBackCaption("Kembali");
								ctrLine.setDeleteCaption("");
								ctrLine.setSaveCaption("Post Jurnal");
								ctrLine.setAddCaption("");
							ctrLine.setJSPCommandStyle("buttonlink");

							if (privDelete){
								ctrLine.setConfirmDelJSPCommand(sconDelCom);
								ctrLine.setDeleteJSPCommand(scomDel);
								ctrLine.setEditJSPCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								ctrLine.setSaveCaption("");
							}

							if (privAdd == false){
								ctrLine.setAddCaption("");
							}
							
							if(bayarPinjaman.getOID()!=0){
								ctrLine.setSaveCaption("");
							}
							
							%>
                                      <%= ctrLine.drawImage(iJSPCommand, iErrCode, errMsg)%> </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp;</td>
                            </tr>
                          </table>
                          <script language="JavaScript">						  
						  	cmdTotal1();
						  </script>
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
