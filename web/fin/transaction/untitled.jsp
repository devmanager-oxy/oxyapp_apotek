


























<script language=JavaScript src="/sipadu-fin/main/common.js"></script>












<!-- Jsp Block -->


<!--  PopCalendar(tag name and id must match) Tags should not be enclosed in tags other than the html body tag. -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="/sipadu-fin/calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>



<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title>Finance System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">



	function cmdResetStart(){
		document.frmbankarchive.start.value="0";	
	}

	function cmdSearch(){
		document.frmbankarchive.start.value="0";	
		document.frmbankarchive.command.value="11";
		document.frmbankarchive.prev_command.value="0";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditDeposit(oidBankDeposit){
		document.frmbankarchive.hidden_bankarchive.value=oidBankDeposit;
		document.frmbankarchive.action="bankdepositprint.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditpoPayment(oidBankpoPayment){
		document.frmbankarchive.hidden_bankarchive.value=oidBankpoPayment;
		document.frmbankarchive.action="bankpopaymentprint.jsp";
		document.frmbankarchive.submit();
	}
	
	function cmdEditnonpoPayment(oidBanknonpoPayment){
		document.frmbankarchive.hidden_bankarchive.value=oidBanknonpoPayment;
		document.frmbankarchive.action="banknonpopaymentdetailprint.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListFirst(){
		document.frmbankarchive.command.value="23";
		document.frmbankarchive.prev_command.value="23";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListPrev(){
		document.frmbankarchive.command.value="21";
		document.frmbankarchive.prev_command.value="21";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
		}

	function cmdListNext(){
		document.frmbankarchive.command.value="22";
		document.frmbankarchive.prev_command.value="22";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListLast(){
		document.frmbankarchive.command.value="24";
		document.frmbankarchive.prev_command.value="24";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
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
<!--End Region JavaScript-->
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('/sipadu-fin/images/home2.gif','/sipadu-fin/images/logout2.gif','../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" -->
			
<script language="JavaScript">
<!--
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
<body onLoad="MM_preloadImages('/sipadu-fin/images/home2.gif','/sipadu-fin/images/logout2.gif')">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr> 
    <td width="526">
      <table border="0" cellspacing="0" cellpadding="0" width="526">
        <tr> 
          <td rowspan="2"><img src="/sipadu-fin/images/logo-finance1.jpg" width="216" height="144" /></td>
          <td><img src="/sipadu-fin/images/logotxt-finance.gif" width="343" height="94" /></td>
        </tr>
        <tr> 
          <td style="background:url(/sipadu-fin/images/head-line.gif) repeat-x"><img src="/sipadu-fin/images/head-corner.gif" width="119" height="50" /></td>
        </tr>
      </table>
    </td>
    <td width="100%" valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td valign="top" style="background:url(/sipadu-fin/images/head-bg.gif) repeat-x">
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="31" align="right" valign="top" >&nbsp;</td>
                <td rowspan="2"><img src="/sipadu-fin/images/logo-kopegtel.jpg" width="73" height="74" /></td>
                <td rowspan="2"><img src="/sipadu-fin/images/logo-telkom.gif" width="43" height="74" /></td>
              </tr>
              <tr> 
                <td align="right" valign="top" ><img src="/sipadu-fin/images/kopegtel-txt.gif" width="167" height="22" /></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td style="background:url(/sipadu-fin/images/head-icon-bg.gif) repeat-x">
		    
		   
            <script language="JavaScript">
			function cmdEnterApp(idx){
				//alert("user.getLoginId() : admin");				
				//alert("user.getPassword() : admin");				
				
				if(parseInt(idx)==1){
					window.location="http://localhost:8080/sipadu-fin?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==2){
					window.location="http://localhost:8080/sipadu-inv?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==3){
					window.location="http://localhost:8080/sipadu-inv/indexsl.jsp?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==4){
					window.location="http://localhost:8080/sipadu-inv/indexpg.jsp?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==5){
					window.location="http://localhost:8080/sipadu-fin/indexsp.jsp?login_id=admin&pass_wd=admin&command=1";
				}
			}
			</script>
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                <td><img src="/sipadu-fin/images/button-finance2.gif" width="50" height="45" border="0" /></td>
                <td>&nbsp;</td>
                <td><a href="javascript:cmdEnterApp(2)" title="Sipadu Inventory"><img src="/sipadu-fin/images/button-inventory.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td><a href="javascript:cmdEnterApp(3)" title="Sipadu Sales"><img src="/sipadu-fin/images/button-sales.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td><a href="javascript:cmdEnterApp(4)" title="Sipadu Pengadaan"><img src="/sipadu-fin/images/button-pengadaan.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td><a href="javascript:cmdEnterApp(5)" title="Sipadu Simpan Pinjam"><img src="/sipadu-fin/images/button-simpan.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
              </tr>
            </table>
			
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

			<!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(/sipadu-fin/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" -->
				  

<script language="JavaScript">

function cmdHelp(){
	window.open("/sipadu-fin/help.htm");
}

function cmdChangeMenu(idx){
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;
	
	switch(parseInt(idx)){
	
		case 1 : 
			
			
			document.all.cash1.style.display="none";
			document.all.cash2.style.display="";
			document.all.cash.style.display="";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
						
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
					
			
			////document.all.pr1.style.display="";
			////document.all.pr2.style.display="none";
			
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
		
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
		
			break;
		
		case 2 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
						
			document.all.bank1.style.display="none";
			document.all.bank2.style.display="";
			document.all.bank.style.display="";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
						
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
		
		case 3 :
			
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
						
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;	
			
		case 4 :
			
				document.all.cash1.style.display="";
				document.all.cash2.style.display="none";
				document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="none";
			document.all.frpt2.style.display="";
			document.all.frpt.style.display="";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";						
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
			
		case 5 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";						
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
						
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
					
		case 6 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="none";
			document.all.master2.style.display="";
			document.all.master.style.display="";
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";

			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
									
			break;
		
		case 7 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
			document.all.inv.style.display="none";						
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
		//---
		case 8 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;	
		
		case 9 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="none";
			document.all.gl2.style.display="";
			document.all.gl.style.display="";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
					
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
		
		case 10 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="none";
			//document.all.pr2.style.display="";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
					
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
			document.all.inv.style.display="none";	
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
			
		case 11 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
						
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
					
			
			
			document.all.inv1.style.display="none";
			document.all.inv2.style.display="";	
			document.all.inv.style.display="";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;		
		
		case 12 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";						
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
					
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";	
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="none";
			document.all.admin2.style.display="";
			document.all.admin.style.display="";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;	
		
		case 13 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";						
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
					
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";	
			
			
			
			document.all.closing1.style.display="none";
			document.all.closing2.style.display="";
			document.all.closing.style.display="";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
			
			break;
			
		case 14 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="none";
			document.all.ar2.style.display="";
			document.all.ar.style.display="";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
		
		case 15 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="none";
			document.all.akrual2.style.display="";
			document.all.akrual.style.display="";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
		
		case 16 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="none";
			document.all.titip2.style.display="";
			document.all.titip.style.display="";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;						
		
		case 17 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="none";
			document.all.anggota2.style.display="";
			document.all.anggota.style.display="";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
		
		case 18 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="none";
			document.all.bymhd2.style.display="";
			document.all.bymhd.style.display="";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
		
		case 19 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="none";
			document.all.asset2.style.display="";
			document.all.asset.style.display="";
			
						
			break;	
		
		case 20 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="none";
			document.all.dp2.style.display="";
			document.all.dp.style.display="";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;
				
		case 0 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			
			
			
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			
			
			
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			
			
			
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			//--------------------
			
			
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			
			
			
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			
			
			
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			
			
			
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			
			
			
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			
			
			
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			
						
			break;	
	}
}

</script> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="/sipadu-fin/images/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="/sipadu-fin/images/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                
                <td height="49"> 
                  <div align="center">Periode Akunting : <br>
                    01 Dec 2009 - 31 Dec 2009<br>
                  </div>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="4"></td>
              </tr>
              
              <tr id="cash1"> 
                <td class="menu0"" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Cash 
                  Transaction </a></td>
              </tr>
              <tr id="cash2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Cash 
                  Transaction </a></td>
              </tr>
              <tr id="cash"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/transaction/cashreceivedetail.jsp?menu_idx=1">Cash 
                        Receipt</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">Petty Cash</td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/sipadu-fin/transaction/pettycashpaymentdetail.jsp?menu_idx=1">Cash 
                        Payment </a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu2"><a href="/sipadu-fin/transaction/pettycashreplenishment.jsp?menu_idx=1">Replenishment</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/transaction/casharchive.jsp?menu_idx=1">Archives</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/master/cashacclink.jsp?menu_idx=1">Cash 
                        Account Link</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr id="bank1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Bank 
                  Transaction </a></td>
              </tr>
              <tr id="bank2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Bank 
                  Transaction </a></td>
              </tr>
              <tr id="bank"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/transaction/bankdepositdetail.jsp?menu_idx=2">Bank 
                        Deposit</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1">Payment</td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/sipadu-fin/transaction/bankpopaymentsrc.jsp?menu_idx=2">Payment 
                        of PO </a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu2"><a href="/sipadu-fin/transaction/banknonpopaymentdetail.jsp?menu_idx=2">Non 
                        PO Payment</a></td>
                    </tr>
                    
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/transaction/bankarchive.jsp?menu_idx=2">Archives</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/master/bankacclink.jsp?menu_idx=2">Bank 
                        Account Link</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr id="ar1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"><a href="javascript:cmdChangeMenu('14')">Account 
                  Receivable </a> </td>
              </tr>
              <tr id="ar2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Account 
                  Receivable </a></td>
              </tr>
              <tr id="ar"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td height="18" width="90%" class="menu1">Transaction</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/ar/newarsrc.jsp?menu_idx=14">New 
                                    Invoice</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/ar/paymentsrc.jsp?menu_idx=14">Payment</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/ar/aging.jsp?menu_idx=14">Aging 
                                    Analysis</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/ar/archives.jsp?menu_idx=14">Archives</a></td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu1">Master</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/general/bankaccount.jsp?menu_idx=14">Bank 
                                    Account</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/general/customer.jsp?menu_idx=14">Customer</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/sipadu-fin/master/aracclink.jsp?menu_idx=14">AR 
                                    Acc. List</a></td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="inv1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('11')"> <a href="javascript:cmdChangeMenu('11')">Account 
                  Payable </a> </td>
              </tr>
              <tr id="inv2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Account 
                  Payable </a></td>
              </tr>
              <tr id="inv"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/invoicesrc.jsp?menu_idx=11">Incoming 
                        Goods List</a> </td>
                    </tr>
                    
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/invoicearchive.jsp?menu_idx=11">Invoice 
                        List </a></td>
                    </tr>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1">Purchase Retur</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/adjusmentlist.jsp?menu_idx=11">Stock 
                        Adjustment</a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/apaging.jsp?menu_idx=11">Aging 
                        Analysis</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/master/purchaseacclink.jsp?menu_idx=11">Purchase 
                        Acc. List</a> </td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="titip1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('16')"> <a href="javascript:cmdChangeMenu('16')">Titipan</a></td>
              </tr>
              <tr id="titip2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Titipan</a></td>
              </tr>
              <tr id="titip"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/general/penitip.jsp?menu_idx=16">Member/Unit</a></td>
                    </tr>
                    <tr>
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldotitipanmapping.jsp?menu_idx=16">Transaksi 
                        Titipan</a></td>
                    </tr>
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/titipanbaru.jsp?menu_idx=16">New 
                        Deposit</a></td>
                    </tr-->
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/kembalikantitipan.jsp?menu_idx=16">Return 
                        Deposit</a></td>
                    </tr-->
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldotitipan.jsp?menu_idx=16"> 
                        Saldo Titipan</a></td>
                    </tr>
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/titipanarchive.jsp?menu_idx=16">Archives</a></td>
                    </tr-->
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="bymhd1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('18')"> <a href="javascript:cmdChangeMenu('18')">BYMHD</a></td>
              </tr>
              <tr id="bymhd2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">BYMHD</a></td>
              </tr>
              <tr id="bymhd"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/general/penitipbymhd.jsp?menu_idx=18">BYMHD 
                        Uraian </a></td>
                    </tr>
                    <tr>
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldobymhdmapping.jsp?menu_idx=18">Transaksi BYMHD</a></td>
                    </tr>
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/bymhdnew.jsp?menu_idx=18">BYMHD 
                        Baru </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/bymhd.jsp?menu_idx=18">BYMHD 
                        Payment</a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldobymhd.jsp?menu_idx=18">Saldo 
                        BYMHD</a></td>
                    </tr>
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/bymhdarchive.jsp?menu_idx=18">Arsip</a></td>
                    </tr-->
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
			  
              <tr id="dp1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('20')"> <a href="javascript:cmdChangeMenu('20')">Deposit/DP</a></td>
              </tr>
              <tr id="dp2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Deposit/DP</a></td>
              </tr>
              <tr id="dp"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/general/penitipdp.jsp?menu_idx=20">Supplier/Vendor</a></td>
                    </tr>
                    <tr>
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldodepositmapping.jsp?menu_idx=20">Transaksi 
                        Deposit</a></td>
                    </tr>
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/dpbaru.jsp?menu_idx=20">New 
                        DP</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/kembalikandp.jsp?menu_idx=20">Return 
                        DP</a></td>
                    </tr-->
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/saldodp.jsp?menu_idx=20"> 
                        Saldo DP</a></td>
                    </tr>
                    
                    
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/dparchive.jsp?menu_idx=20">Archives</a></td>
                    </tr-->
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="akrual1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('15')"> <a href="javascript:cmdChangeMenu('15')">Accrual 
                  Transaction </a> </td>
              </tr>
              <tr id="akrual2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Accrual 
                  Transaction </a></td>
              </tr>
              <tr id="akrual"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/akrualsetup.jsp?menu_idx=15">Setup 
                        Accrual Transaction</a></td>
                    </tr>
                    
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/akrualproses.jsp?menu_idx=15">Accrual 
                        Process </a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/akrualarsip.jsp?menu_idx=15">Archives</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
			  
              <tr id="asset1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('19')"> <a href="javascript:cmdChangeMenu('19')">Asset Management</a> </td>
              </tr>
              <tr id="asset2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Asset Management</a></td>
              </tr>
              <tr id="asset"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/asset/asset.jsp?menu_idx=19">Asset List</a></td>
                    </tr>
                    
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/asset/assetdepre.jsp?menu_idx=19">Depreciation 
                        Process </a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/asset/assetdepre_archives.jsp?menu_idx=19">Archives</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="anggota1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('17')"> <a href="javascript:cmdChangeMenu('17')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggota2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggota"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Anggota</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/member/scrmember.jsp?menu_idx=17">List 
                        Anggota</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/member/member.jsp?menu_idx=17">Anggota 
                        Baru</a></td>
                    </tr>
                    
                    
                    
                    
                    
                    
                    
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              
              <tr id="gl1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('9')"> <a href="javascript:cmdChangeMenu('9')">General 
                  Journal </a></td>
              </tr>
              <tr id="gl2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">General 
                  Journal </a></td>
              </tr>
              <tr id="gl"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/gldetail.jsp?menu_idx=9">New 
                        Journal</a></td>
                    </tr>
                    
                    <!--tr> 
						  <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/journal/journal-proto.jsp?menu_idx=9">New 
							JournaL Proto--</a></td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/transaction/glarchive.jsp?menu_idx=9">Archives</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="frpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Financial 
                  Report </a></td>
              </tr>
              <tr id="frpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Financial 
                  Report </a
					></td>
              </tr>
              <tr id="frpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/freport/worksheet.jsp?menu_idx=4">Jurnal 
                        Detail </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/freport/glreport.jsp?menu_idx=4">General 
                        Ledger</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Balance Sheet</td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsstandard.jsp?menu_idx=4">Standard</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
                    </tr>                    
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsmultiple.jsp?menu_idx=4">Multiple 
                        Periods</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Profit & Loss</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/profitloss.jsp?menu_idx=4">Standard</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/profitloss0_v01.jsp?menu_idx=4">Departmental 
                        Base</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/profitloss1.jsp?menu_idx=4">Sectional 
                        Base</a></td>
                    </tr>
                    
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/profitlossmultiple.jsp?menu_idx=4">Multiple 
                        Periods</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laporan Keuangan</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsstandard_v01.jsp?menu_idx=4">Neraca 
                        Akhir</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsstandard_classv01.jsp?id_class=2&menu_idx=4">Neraca 
                        SP</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsstandard_classv01.jsp?id_class=1&menu_idx=4">Neraca 
                        NSP</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/portofolio.jsp?menu_idx=4"">Portofolio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/bsdetail_v01.jsp?menu_idx=4">Penjelasan 
                        Neraca</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/biaya_v01.jsp?menu_idx=4&pnl_type=0">Biaya</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/pendapatan_v01.jsp?menu_idx=4&pnl_type=1">Pendapatan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/ratio.jsp?menu_idx=4">Rasio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/iktisarlabarugi.jsp?menu_idx=4">Iktisar 
                        Laba Rugi</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/freport/kinerja.jsp?menu_idx=4">Kinerja</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/transaction/bymhdsaldo.jsp?menu_idx=4">BYMHD</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/transaction/saldotitipan.jsp?menu_idx=4">Titipan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/asset/assetreport.jsp?menu_idx=4">Aktiva 
                        Tetap</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2">&nbsp;</td>
                    </tr>
                    
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              
              
              <tr id="master1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')">Master 
                  Data </a></td>
              </tr>
              <tr id="master2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Master 
                  Data </a></td>
              </tr>
              <tr id="master"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/sipadu-fin/master/company.jsp?menu_idx=6">System 
                        Configuration</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Accounting</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/coa.jsp?menu_idx=6">Chart 
                              of Account</a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/coabudget_edt.jsp?menu_idx=6">Account 
                              Budget/Target </a></td>
                          </tr>
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/coaportofoliosetup.jsp?menu_idx=6">Portofolio 
                              Setup</a> </td>
                          </tr>
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/activity/coaexpensecategory.jsp?menu_idx=6">Account 
                              Category </a></td>
                          </tr>
                          <tr>
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/iktisarsetup.jsp?menu_idx=6">Setup 
                              Iktisar RL</a> </td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/activity/coanatureexpensecategory.jsp?menu_idx=6">Account 
                              Group Aliases</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/general/exchangerate.jsp?menu_idx=6">Bookkeeping 
                              Rate</a> </td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/periode.jsp?menu_idx=6">Period</a></td>
                          </tr>
                          
                        </table>
                      </td>
                    </tr>
                    
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Company</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/payroll/employee.jsp?menu_idx=6">Employee 
                              List as User</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/payroll/department.jsp?menu_idx=6">Department 
                              List </a></td>
                          </tr>
						  <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/master/unitusaha.jsp?menu_idx=6">Unit 
                              Usaha </a></td>
                          </tr>
                          
                          <!--tr> 
								<td width="80%" height="18" class="menu2"><a href="/sipadu-fin/payroll/section.jsp?menu_idx=6">Section</a></td>
							  </tr-->
                        </table>
                      </td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">General</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/general/country.jsp?menu_idx=6">Country</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/sipadu-fin/general/currency.jsp?menu_idx=6">Currency</a></td>
                          </tr>
                          
                          <!--tr> 
								<td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/itemtype.jsp?menu_idx=6">Item 
								  Type</a> </td>
							  </tr-->
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/termofpayment.jsp?menu_idx=6">Term 
                              of Payment</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/shipaddress.jsp?menu_idx=6">Shipping 
                              Address </a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/paymentmethod.jsp?menu_idx=6">Payment 
                              Method</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/location.jsp?menu_idx=6">Location 
                              List </a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/kecamatan.jsp?menu_idx=6">Kecamatan 
                              Area </a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/desa.jsp?menu_idx=6">Desa 
                              Area </a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/master/pekerjaan.jsp?menu_idx=6">Occupation 
                              List </a></td>
                          </tr>
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/general/dinas.jsp?menu_idx=6">Dinas</a></td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/sipadu-fin/general/dinasunit.jsp?menu_idx=6">Dinas 
                              Unit</a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="closing1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')">Close 
                  Period </a></td>
              </tr>
              <tr id="closing2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"> 
                  Close Period</a></td>
              </tr>
              <tr id="closing"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/closing/periode.jsp?menu_idx=13"> 
                        
                        Yearly Closing 
                        
                        </a></td>
                    </tr>
                    
                    
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr id="admin1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('12')"> <a href="javascript:cmdChangeMenu('12')">Administrator</a> 
                </td>
              </tr>
              <tr id="admin2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Administrator</a> 
                </td>
              </tr>
              <tr id="admin"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/system/sysprop.jsp?menu_idx=12">System 
                        Property</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/admin/userlist.jsp?menu_idx=12">User 
                        List</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="/sipadu-fin/admin/grouplist.jsp?menu_idx=12">User 
                        Group </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td class="menu0"><a href="/sipadu-fin/logout.jsp">Logout</a></td>
              </tr>
			  <tr> 
                <td ><img src="/sipadu-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
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
    </td>
  </tr>
</table>
<script language="JavaScript">
	cmdChangeMenu('2');
</script>

				  <!--  PopCalendar(tag name and id must match) Tags should not be enclosed in tags other than the html body tag. -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="/sipadu-fin/calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
            <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  
					  <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><font class="lvl1">Bank</font><font class="tit1">&nbsp;&raquo;&nbsp;<span class="lvl2">Archives</span></font></td>
                                    <td width="40%" height="23"> 
                                      <table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap>
      <div align="right"><font face="Arial, Helvetica, sans-serif"><b>ADMINISTRATOR , Login : 24/02/2010 00:00:00&nbsp; </b>[ <a href="/sipadu-fin/logout.jsp">Logout</a> , <a href="/sipadu-fin/updatepwd.jsp">Change  
                            Password</a> ]<b>&nbsp;&nbsp;&nbsp;</b></font></div></td>
  </tr>
</table>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="/sipadu-fin/images/line1.gif" ></td>
                                  </tr>
                                </table>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="/sipadu-fin/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbankarchive" method ="post" action="">
							<input type="hidden" name="command" value="11">
							<input type="hidden" name="vectSize" value="0">
							<input type="hidden" name="start" value="0">
							<input type="hidden" name="prev_command" value="0">
							<input type="hidden" name="hidden_bankarchive" value="0">
							<input type="hidden" name="menu_idx" value="2">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <!--DWLayoutTable-->
                                  <tr align="left" valign="top"> 
                                    <td width="100%" height="127" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <div align="right">Date : 24 February 2010</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="13%">&nbsp;</td>
                                                <td width="26%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Search for</td>
                                                <td width="26%"> 
                                                  
                                                  <select name="x_search_for" onChange="javascript:cmdSearch()">
                                                    
                                                    <option value="bankdeposit"  selected >Bank 
                                                    Deposit</option>
                                                    
                                                    
                                                    <option value="paymentbaseonpo" >PO 
                                                    Based Payment </option>
                                                    
                                                    
                                                    <option value="paymentnonpo" >Non 
                                                    PO Based Payment </option>
                                                    
                                                  </select>
                                                </td>
                                                <td width="10%">Input Date</td>
                                                <td width="51%">
												
												bankArchive.getStartDate() : Wed Feb 24 00:00:00 SGT 2010
bankArchive.getEndDate() : Wed Feb 24 00:00:00 SGT 2010

												 
                                                  <input name="x_start_date" value="24/02/2010" size="11">
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.x_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="/sipadu-fin/calendar/calbtn.gif" height="19" border="0" alt="start date"></a> 
                                                  &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;&nbsp; 
                                                  <input name="x_end_date" value="24/02/2010" size="11" style="text-align:center">
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.x_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="/sipadu-fin/calendar/calbtn.gif" height="19" border="0" alt="end date"></a>	
                                                  <input name="x_ignore_input_date" type="checkBox" class="formElemen"  value="1" checked>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Journal Number</td>
                                                <td width="26%"> 
                                                  <input type="text" name="x_journal_number"  value="">
                                                </td>
                                                <td width="10%">Transaction Date</td>
                                                <td width="51%"> 
                                                  <input name="x_transaction_date" value="24/02/2010" size="11" style="text-align:center">
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.x_transaction_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="/sipadu-fin/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="x_ignore_transaction_date" type="checkBox" class="formElemen"  value="1" checked>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Periode</td>
                                                <td colspan="3"> 
                                                  
                                                  <select name="x_periode_id"  class="formElemen">
	<option value="" selected ></option>
	<option value="504404419396748520">December 2009</option>
	<option value="504404419388301317">November 2009</option>
	<option value="504404412075768161">Oktober 2009</option>
</select>
 </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  
                                  <tr> 
                                    <td><b><font size="2">&nbsp;Bank Deposit </font></b> 
                                    </td>
                                  </tr>
                                  
                                  <tr> 
                                    <td height="3"></td>
                                  </tr>
                                  
                                  <tr align="left" valign="top"> 
                                    <td align="left" colspan="7" class="boxed1" width="99%"> 
                                      <table width="100%">
                                        <tr align="left" valign="top"> 
                                          <td height="21" align="left" colspan="7" class="tablehdr" width="99%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="25" align="left" colspan="7" class="tablecell" width="99%"> 
                                            
                                            List is empty 
                                            
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="1%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  
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
            <!-- #BeginEditable "footer" --><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="2" style="background:url(/sipadu-fin/images/footerline.gif) repeat-x"><img src="/sipadu-fin/images/footerline.gif" width="9" height="9" /></td>
        </tr>
        <tr>
          
    <td height="35" valign="top" style="padding-left:10px; background:url(/sipadu-fin/images/footergrad.gif) repeat-x"><a href="javascript:cmdEnterApp(1)">Home</a> 
      | <a href="javascript:cmdEnterApp(2)">Inventory</a> | <a href="javascript:cmdEnterApp(3)">Sales</a> 
      | <a href="javascript:cmdEnterApp(4)">Pengadaan</a> | <a href="javascript:cmdEnterApp(5)">Simpan 
      Pinjam</a></td>
          
    <td align="right" valign="top" style="padding-right:10px; background:url(/sipadu-fin/images/footergrad.gif) repeat-x">Copyright 
      © 2009 Kopegtel Denpasar</td>
        </tr>
      </table>


<!--table width="100%" border="0" cellpadding="0" cellspacing="0">
  
  <tr>
    <td height="25" align="center" valign="middle" bgcolor="#3D4D1B" class="footer">Copyright(C)2007, All rights reserved.</td>
  </tr>
</table-->
<!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
