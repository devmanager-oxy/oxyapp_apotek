


















<script language=JavaScript src="/ccs/main/common.js"></script>
<script language="JavaScript">
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








<script language="JavaScript">

</script>

<!-- Jsp Block -->

	
	
	

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--



var sysDecSymbol = ".";
var usrDigitGroup = ",";
var usrDecSymbol = ".";

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

function calcPrice(obj, a){
    
	qty = obj.value;
	alert("qty : "+qty);
	alert("a : "+a);
	
	price = document.frmreceive.itm_JSP_AMOUNT[a].value;
	discount = document.frmreceive.itm_JSP_TOTAL_DISCOUNT[a].value;
	alert("qty : "+qty);
	alert("price : "+price);
	alert("discount : "+discount);
	
	/*qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	price = removeChar(price);
	price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	discount = removeChar(discount);
	discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	alert("qty : "+qty);
	alert("price : "+price);
	alert("discount : "+discount);
	
	var subtotal = (parseFloat(price) - parseFloat(discount)) * parseFloat(qty);
	var currTotal = document.frmreceive.JSP_USER_ID[a].value;
	currTotal = removeChar(currTotal);
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	document.frmreceive.JSP_USER_ID[a].value = formatFloat(''+subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	var total = document.frmreceive.JSP_TOTAL_AMOUNT.value;
	total = removeChar(total);
	total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	total = parseFloat(total) - parseFloat(currTotal) + subtotal;
	
	document.frmreceive.JSP_TOTAL_AMOUNT.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	*/
	
}

function parserMaster(){
    var str = document.frmreceive.itm_JSP_ITEM_MASTER_ID.value;
	
    
	calculateSubTotal();
	
}

function calculateSubTotal(){
	var amount = document.frmreceive.itm_JSP_AMOUNT.value;
	var qty = document.frmreceive.itm_JSP_QTY.value;
	var discount = document.frmreceive.itm_JSP_TOTAL_DISCOUNT.value;
	
	amount = removeChar(amount);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.itm_JSP_AMOUNT.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.itm_JSP_QTY.value = qty;
	
	discount = removeChar(discount);
	discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.itm_JSP_TOTAL_DISCOUNT.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
	document.frmreceive.itm_JSP_TOTAL_AMOUNT.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var subtot = document.frmreceive.sub_tot.value;
	subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("amount : "+amount);
	//alert("subtot : "+subtot);
	//alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
	
	
		document.frmreceive.JSP_TOTAL_AMOUNT.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	
	calculateAmount();
}


function cmdVatEdit(){
	var vat = document.frmreceive.JSP_INCLUDE_TAX.value;
	if(parseInt(vat)==0){
		document.frmreceive.JSP_TAX_PERCENT.value="0.0";				
	}else{
		document.frmreceive.JSP_TAX_PERCENT.value="10.0";		
	}
	
	calculateAmount();
}

function calculateAmount(){
	
	var vat = document.frmreceive.JSP_INCLUDE_TAX.value;
	var taxPercent = document.frmreceive.JSP_TAX_PERCENT.value;
	taxPercent = removeChar(taxPercent);
	taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var discPercent = document.frmreceive.JSP_DISCOUNT_PERCENT.value;	
	discPercent = removeChar(discPercent);
	discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var subTotal = document.frmreceive.JSP_TOTAL_AMOUNT.value;
	subTotal = removeChar(subTotal);
	subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	//alert("********* calculate grand session *******");
	//alert("subTotal :"+subTotal);
	
	var totalDiscount = 0;
	if(parseFloat(discPercent)>0){
		totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
	}
	
	var totalTax = 0;
	
	if(parseInt(vat)==0){
		document.frmreceive.JSP_TAX_PERCENT.value="0.0";		
		//document.frmreceive.JSP_TOTAL_TAX.value="0.00";		
		totalTax = 0;
	}else{
		document.frmreceive.JSP_TAX_PERCENT.value="10.0";		
		totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
	}
	
	//alert("subTotal :"+subTotal);
	//alert("totalDiscount :"+totalDiscount);
	//alert("totalTax :"+totalTax);
	
	var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
	
	//alert("grandTotal :"+grandTotal);
	
	document.frmreceive.JSP_TOTAL_TAX.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmreceive.JSP_DISCOUNT_TOTAL.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmreceive.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}

function cmdClosedReason(){
	var st = document.frmreceive.JSP_STATUS.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdVendor(){
	
			document.frmreceive.command.value="34";
			document.frmreceive.action="receiveitem.jsp";
			document.frmreceive.submit();
		//cmdVendorChange();
	
}

function cmdToRecord(){
	document.frmreceive.command.value="0";
	document.frmreceive.action="receivelist.jsp";
	document.frmreceive.submit();
}

function cmdVendorChange(){
	var oid = document.frmreceive.JSP_VENDOR_ID.value;
	
			if('1004'==oid){
				document.frmreceive.vnd_address.value="Jl Kunti Perum Seminyak Asri39";
			}
			
			if('1009'==oid){
				document.frmreceive.vnd_address.value="Jl Imam Bonjol";
			}
			
			if('1010'==oid){
				document.frmreceive.vnd_address.value="Jl Sunia Negara No 29 Psgr";
			}
			
			if('1008'==oid){
				document.frmreceive.vnd_address.value="Jl. Raya Kuta No 8 Kuta Badung";
			}
			
			if('1011'==oid){
				document.frmreceive.vnd_address.value="Jl Mataram gg kelapa 2x";
			}
			
			if('1014'==oid){
				document.frmreceive.vnd_address.value="Jl. Ikan Tuna I no 2 Benoa";
			}
			
			if('1018'==oid){
				document.frmreceive.vnd_address.value="Jl. Gatot Subroto Barat";
			}
			
			if('1012'==oid){
				document.frmreceive.vnd_address.value="JL. By Pass Ngurah Rai Tuban";
			}
			
			if('1013'==oid){
				document.frmreceive.vnd_address.value="Jl By Pass Ngurah Rai (suwung)";
			}
			
			if('1007'==oid){
				document.frmreceive.vnd_address.value="Jl Imam Bonjol";
			}
			
			if('1015'==oid){
				document.frmreceive.vnd_address.value="Sunset Road";
			}
			
			if('1001'==oid){
				document.frmreceive.vnd_address.value="Jl Dewi Sri Kuta Badung";
			}
			
			if('1003'==oid){
				document.frmreceive.vnd_address.value="Jl Raya Benoa Gg Rajawali 9 Ps";
			}
			
			if('1002'==oid){
				document.frmreceive.vnd_address.value="Jl By Pass Ngurah Rai";
			}
			
			if('1006'==oid){
				document.frmreceive.vnd_address.value="Jl. Raya Kuta Central Parkir";
			}
			
			if('1016'==oid){
				document.frmreceive.vnd_address.value="Pasar Ikan Kedonganan";
			}
			
			if('1017'==oid){
				document.frmreceive.vnd_address.value="Jl Pasar Kuta";
			}
			
	
}


function cmdCloseDoc(){
	document.frmreceive.action="/ccs/home.jsp";
	document.frmreceive.submit();
}

function cmdAskDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="11";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdDeleteDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="41";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdCancelDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="3";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdSaveDoc(){
	document.frmreceive.command.value="9";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdAdd(){
	document.frmreceive.hidden_receive_item_id.value="0";
	document.frmreceive.command.value="2";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdAsk(oidReceiveItem){
	document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
	document.frmreceive.command.value="71";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdAskMain(oidReceive){
	document.frmreceive.hidden_receive_id.value=oidReceive;
	document.frmreceive.command.value="71";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receive.jsp";
	document.frmreceive.submit();
}

function cmdConfirmDelete(oidReceiveItem){
	document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
	document.frmreceive.command.value="6";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}
function cmdSaveMain(){
	document.frmreceive.command.value="4";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receive.jsp";
	document.frmreceive.submit();
	}

function cmdSave(){
	document.frmreceive.command.value="4";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdEdit(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="3";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdCancel(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="3";
	document.frmreceive.prev_command.value="0";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdBack(){
	document.frmreceive.command.value="14";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdListFirst(){
	document.frmreceive.command.value="23";
	document.frmreceive.prev_command.value="23";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdListPrev(){
	document.frmreceive.command.value="21";
	document.frmreceive.prev_command.value="21";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdListNext(){
	document.frmreceive.command.value="22";
	document.frmreceive.prev_command.value="22";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdListLast(){
	document.frmreceive.command.value="24";
	document.frmreceive.prev_command.value="24";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
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

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//-->
</script>
               
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('/ccs/images/home2.gif','/ccs/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
             
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr> 
    <td width="100%"  height="91" align="left" valign="middle" background="/ccs/images/hbg.jpg" > 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="215"><img src="/ccs/images/h1.jpg" width="215" height="88"></td>
          <td width="62%">&nbsp;</td>
          <td width="1%">&nbsp;</td>
        </tr>
      </table>
    </td>
    <td width="648" align="left" valign="top" background="/ccs/images/h2.jpg" bgcolor="#e5efcb"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td><img src="/ccs/images/spacer.gif" width="648" height="1" /></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="5" valign="top" bgcolor="#3d4d1b"><img src="/ccs/images/spacer.gif" width="1" height="1" /></td>
    <td valign="top" bgcolor="#3d4d1b"><img src="/ccs/images/spacer.gif" width="1" height="1" /></td>
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
                <td width="165" height="100%" valign="top" background="/ccs/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  

<script language="JavaScript">

function cmdHelp(){
	window.open("/ccs/help.htm");
}

function cmdLogout(){
	window.location="/ccs/logout.jsp";
}

function cmdChangeMenu(idx){
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;
	
	switch(parseInt(idx)){
	
		case 1 : 
			
			
			document.all.cash1.style.display="none";
			document.all.cash2.style.display="";
			document.all.cash.style.display="";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
						
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
					
			
			////document.all.pr1.style.display="";
			////document.all.pr2.style.display="none";
			
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";
			//document.all.inv.style.display="none";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
		
			//-			
			//document.all.ar.style.display="none";			
			
			//document.all.pr.style.display="none";
			
								
			break;
		
		case 2 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
						
			//document.all.bank1.style.display="none";
			//document.all.bank2.style.display="";
			//document.all.bank.style.display="";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
						
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
						
			break;
		
		case 3 :
			
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="none";
			//document.all.ap2.style.display="";
			//document.all.ap.style.display="";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
						
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";			
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;	
			
		case 4 :
			
				document.all.cash1.style.display="";
				document.all.cash2.style.display="none";
				document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="none";
			//document.all.frpt2.style.display="";
			//document.all.frpt.style.display="";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";						
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
			
		case 5 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";						
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
						
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
					
		case 6 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="none";
			document.all.master2.style.display="";
			document.all.master.style.display="";
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
									
			break;
		
		case 7 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="none";
			document.all.dtransfer2.style.display="";
			document.all.dtransfer.style.display="";
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";	
			//document.all.inv.style.display="none";						
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
		//---
		case 8 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";			
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;	
		
		case 9 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="none";
			//document.all.gl2.style.display="";
			//document.all.gl.style.display="";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
					
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";			
			//document.all.inv.style.display="none";			
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
		
		case 10 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="none";
			//document.all.pr2.style.display="";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
					
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";	
			//document.all.inv.style.display="none";	
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
			
		case 11 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
						
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
					
			
			
			//document.all.inv1.style.display="none";
			//document.all.inv2.style.display="";	
			//document.all.inv.style.display="";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;		
		
		case 12 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";						
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
					
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";
			//document.all.inv.style.display="none";	
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
			
			
			document.all.admin1.style.display="none";
			document.all.admin2.style.display="";
			document.all.admin.style.display="";
			
			
			break;	
		
		case 13 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";						
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
					
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";
			//document.all.inv.style.display="none";	
			
			
			
			//document.all.closing1.style.display="none";
			//document.all.closing2.style.display="";
			//document.all.closing.style.display="";
			
			
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
			
			break;
			
		case 14 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="none";
			document.all.ar2.style.display="";
			document.all.ar.style.display="";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";
			//document.all.inv.style.display="none";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
						
			break;				
		
		case 0 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			
			
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			
			
			//document.all.bank1.style.display="";
			//document.all.bank2.style.display="none";
			//document.all.bank.style.display="none";
			
			
			//document.all.ap1.style.display="";
			//document.all.ap2.style.display="none";		
			//document.all.ap.style.display="none";
			
			
			//document.all.gl1.style.display="";
			//document.all.gl2.style.display="none";
			//document.all.gl.style.display="none";			
			
			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			
			//document.all.frpt1.style.display="";
			//document.all.frpt2.style.display="none";
			//document.all.frpt.style.display="none";
			
			
			
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			
			
			
			//document.all.inv1.style.display="";
			//document.all.inv2.style.display="none";
			//document.all.inv.style.display="none";
			
			
			
			//document.all.closing1.style.display="";
			//document.all.closing2.style.display="none";
			//document.all.closing.style.display="none";
			
		
			
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			
						
			break;	
	}
}

</script>
<table width="165" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><img src="/ccs/images/spacer.gif" width="1" height="1" /></td>
  </tr>
  <tr> 
    
    <td class="catmenu" height="35"> 
      <div align="center"> 
        Friday<br>

        December 12, 2008</div>
    </td>
  </tr>
  <tr> 
    <td class="catmenu"" onClick="javascript:cmdChangeMenu('1')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="/ccs/home.jsp?menu_idx=0"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="/ccs/home.jsp?menu_idx=0">Home</a></td>
        </tr>
      </table>
    </td>
  </tr>
  
  <tr id="cash1"> 
    <td class="catmenu"" onClick="javascript:cmdChangeMenu('1')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('1')"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('1')">Transaction</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="cash2"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('0')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('0')"><img src="/ccs/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('0')">Transaction</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="cash"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1">Purchase Request</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/purchaserequestitem.jsp?menu_idx=1">New 
                  PR </a></td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/postransaction/prpending.jsp?menu_idx=1">List 
                  Pending PR</a></td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/postransaction/purchaserequestlist.jsp?menu_idx=1&start=0">Archives</a></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Puchase Order</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/prtoposearch.jsp?menu_idx=1">Export 
                  PR to PO </a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/purchaseitem.jsp?menu_idx=1">Direct 
                  PO</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/purchaselist.jsp?menu_idx=1&start=0">Archives</a></td>
              </tr>
              <!--tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/section.jsp?menu_idx=6">Section</a></td>
              </tr-->
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Incoming Goods</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/pobasesearch.jsp?menu_idx=1">Incoming 
                  Goods (PO)</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2">&nbsp;</td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2">&nbsp;</td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/pobasesearch-proto.jsp">Incoming 
                  Goods (PO)-proto</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="poretursearch-proto.jsp">PO 
                  Retur</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/receiveitem.jsp?menu_idx=1">Direct 
                  Incoming</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/receivelist.jsp?menu_idx=1">Archives</a></td>
              </tr>
              <!--tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/section.jsp?menu_idx=6">Section</a></td>
              </tr-->
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Stock Transfer</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/pobasesearch-proto.jsp">Transfer 
                  Item </a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/postransaction/receivelist.jsp?menu_idx=1">Archives</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu1">Stock Opname</td>
              </tr>
              <!--tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/section.jsp?menu_idx=6">Section</a></td>
              </tr-->
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2">Opname</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2">Archives</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Stock Adjustment</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2">Adjustment</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2">Archives</td>
        </tr>
        <tr> 
          <td height="18" width="90%">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  
  
  <tr id="ar1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('14')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('14')"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('14')">Report</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="ar2"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('0')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('0')"><img src="/ccs/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('0')">Report</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="ar"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        
        <tr> 
          <td height="18" width="90%" class="menu1">Menu List &amp; Stock</td>
        </tr>
        
        <tr> 
          <td height="18" width="90%" class="menu1">Supplier Report</td>
        </tr>
        
        <!--tr> 
          <td height="18" width="90%" class="menu1">New Invoice</td>
        </tr-->
        
        <tr> 
          <td height="18" width="90%" class="menu1">Purchase Report</td>
        </tr>
        
        <tr> 
          <td height="18" width="90%" class="menu1">Giro Report</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Sales Report</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Guide Report</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">AR Report</td>
        </tr>
        <tr> 
          <td height="18" width="90%"></td>
        </tr>
      </table>
    </td>
  </tr>
  
  
  
  
  
  
  
  
  <tr id="dtransfer1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('7')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="75">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('7')"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('7')">Data Synchronization</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="dtransfer2"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('0')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="75">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('0')"><img src="/ccs/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('0')">Data Synchronization</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="dtransfer"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        
        <tr> 
          <td height="18" width="90%" class="menu1">Backup</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/datasync/backupcheck.jsp?menu_idx=7">Transfer 
                  To File</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/datasync/maintain.jsp?menu_idx=7">Maintenance</a></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="/ccs/datasync/upload.jsp?menu_idx=7">Upload</a></td>
        </tr>
        <!--tr>
          <td height="18" width="90%" class="menu1"><a href="/ccs/datasync/backuphistory.jsp?menu_idx=7"">History</a></td>
        </tr-->
        <tr> 
          <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> </td>
        </tr>
        
      </table>
    </td>
  </tr>
  
  
  <tr id="master1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('6')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="89">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('6')"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('6')">Master Maintenance</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="master2"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('0')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="89">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('0')"><img src="/ccs/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('0')">Master Maintenance</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="master"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="/ccs/general/company.jsp?menu_idx=6">Configuration</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">POS Master</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/itemmaster.jsp?menu_idx=6">Menu 
            &amp; Stock</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/itemgroup.jsp?menu_idx=6">Category</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/itemcategory.jsp?menu_idx=6">Sub 
            Category </a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/uom.jsp?menu_idx=6">Unit</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/waiter.jsp?menu_idx=6">Waitres</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/waitertable.jsp?menu_idx=6">Table</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/posmaster/shift.jsp?menu_idx=6">Shift</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/general/location.jsp?menu_idx=6">Location</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/general/vendor.jsp?menu_idx=6">Supplier</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/general/salesman.jsp?menu_idx=6">Guide</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu2"><a href="/ccs/general/bank.jsp?menu_idx=6">Bank</a></td>
        </tr>
        <tr> 
          <td width="80%" height="18" class="menu2"><a href="/ccs/general/country.jsp?menu_idx=6">Country</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">HR Master</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/employee.jsp?menu_idx=6">Employee</a> 
                </td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/department.jsp?menu_idx=6">Department</a></td>
              </tr>
              <!--tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/payroll/section.jsp?menu_idx=6">Section</a></td>
              </tr-->
            </table>
          </td>
        </tr>
        <!--tr> 
          <td height="18" width="90%" class="menu1">General Master</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/general/country.jsp?menu_idx=6">Country</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="/ccs/general/currency.jsp?menu_idx=6">Currency</a></td>
              </tr>
              
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/general/termofpayment.jsp?menu_idx=6">Term 
                  of Payment</a></td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/general/shipaddress.jsp?menu_idx=6">Shipping 
                  Address</a> </td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/general/paymentmethod.jsp?menu_idx=6">Payment 
                  Method</a> </td>
              </tr>
              
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="/ccs/general/exchangerate.jsp">Excange 
                  Rate</a></td>
              </tr>
              
            </table>
          </td>
        </tr-->
        <tr> 
          <td height="18" width="90%">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  
  
  
  <tr id="admin1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('12')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="102">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('12')"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('12')">Administrator</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="admin2"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('0')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="102">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('0')"><img src="/ccs/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('0')">Administrator</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="admin"> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="menu1"><a href="/ccs/system/sysprop.jsp?menu_idx=12">System 
            Properties</a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="/ccs/admin/userlist.jsp?menu_idx=12">User 
            List </a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="/ccs/admin/grouplist.jsp?menu_idx=12">User 
            Group</a></td>
        </tr>
        <tr> 
          <td class="menu1">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  
  <tr> 
    <td class="catmenu" onClick="javascript:cmdHelp()"> 
      <table border="0" cellspacing="0" cellpadding="0" width="47">
        <tr> 
          <td width="25"><a href="javascript:cmdHelp()"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap width="22"><a href="javascript:cmdHelp()">Help</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td class="catmenu" onClick="javascript:cmdLogout()"> 
      <table border="0" cellspacing="0" cellpadding="0" width="47">
        <tr> 
          <td width="25"><a href="/ccs/logout.jsp"><img src="/ccs/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap width="22"><a href="/ccs/logout.jsp">Logout</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td class="catmenu" height="3"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>
<script language="JavaScript">
	cmdChangeMenu('1');
</script>

				  <!--  PopCalendar(tag name and id must match) Tags should not be enclosed in tags other than the html body tag. -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="/ccs/calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmreceive" method ="post" action="">
                          <input type="hidden" name="command" value="2">
                          <input type="hidden" name="start" value="0">
                          <input type="hidden" name="prev_command" value="0">
                          <input type="hidden" name="JSP_USER_ID" value="101">
                          <input type="hidden" name="hidden_receive_item_id" value="0">
                          <input type="hidden" name="hidden_receive_id" value="0">
                          <input type="hidden" name="itm_JSP_RECEIVE_ID" value="0">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                            </font><font class="tit1">&raquo; 
                                            <span class="lvl2">Incoming Goods 
                                            </span>&raquo; <span class="lvl2">PO 
                                            Base Incoming Goods</span></font></b></td>
                                          <td width="40%" height="23"> 
                                             
                          <table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap>
      <div align="right"><font face="Arial, Helvetica, sans-serif"><b>ADMINISTRATOR , Login : 12/12/2008 23:05:16&nbsp; </b>[ <a href="/ccs/logout.jsp">Logout</a> , <a href="/ccs/admin/userupdatepasswd.jsp?menu_idx=4">Change 
                            Password</a> ]<b>&nbsp;</b></font></div></td>
  </tr>
</table>

                        
                                          </td>
                                        </tr>
                                        <tr > 
                                          <td colspan="2" height="3" background="/ccs/images/line1.gif" ></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="/ccs/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="/ccs/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;Incoming 
                                              Goods &nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="/ccs/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="/ccs/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              <tr align="left"> 
                                                <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                <td height="21" valign="middle" width="27%">&nbsp;</td>
                                                <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                <td height="21" colspan="2" width="52%" class="comment" valign="top"> 
                                                  <div align="right"><i>Date : 
                                                    12/12/2008, 
                                                    
                                                    Operator : admin&nbsp; 
                                                    
                                                    </i>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="12%">&nbsp;&nbsp;PO 
                                                  Number </td>
                                                <td height="15" width="27%"> 
                                                  <input type="hidden" name="JSP_PURCHASE_ID" value="504404386333762411">
                                                  <input type="text" name="textfield" class="readonly" value="PO12080001" readOnly>
                                                </td>
                                                <td height="15" width="9%">&nbsp;</td>
                                                <td height="15" colspan="2" width="52%" class="comment">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="12%">&nbsp;&nbsp;PO 
                                                  Date</td>
                                                <td height="15" width="27%"> 
                                                  <input type="text" name="textfield2" class="readOnly" readonly value="01/12/2008">
                                                </td>
                                                <td height="15" width="9%">&nbsp;</td>
                                                <td height="15" colspan="2" width="52%" class="comment">&nbsp;</td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>
                                                <td height="20" width="27%"> 
                                                  
                                                  <input type="hidden" name="JSP_VENDOR_ID" value="1001">
                                                  <input type="text" name="textfield" value="Megah Food Tradding Cv" size="40" readOnly class="readonly">
                                                </td>
                                                <td height="20" width="9%">Receive 
                                                  In</td>
                                                <td height="20" colspan="2" width="52%" class="comment"> 
                                                  <select name="JSP_LOCATION_ID">
                                                    
                                                    <option value="504404363671633567" >WH1 - Warehouse</option>
                                                    
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="12%">&nbsp;&nbsp;Address</td>
                                                <td height="20" width="27%"> 
                                                  <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly">Jl Dewi Sri Kuta Badung</textarea>
                                                </td>
                                                <td width="9%" height="20">Doc 
                                                  Number</td>
                                                <td colspan="2" class="comment" width="52%" height="20"> 
                                                  
                                                  IN12080001 </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;</td>
                                                <td height="21" width="27%"> 
                                                  
                                                  
                                                </td>
                                                <td width="9%">Status</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  
                                                  <input type="text" class="readOnly" name="stt" value="DRAFT" size="15" readOnly>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="JSP_DATE" value="12/12/2008" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.JSP_DATE);return false;" ><img class="PopcalTrigger" align="absmiddle" src="/ccs/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                                <td width="9%">Applay VAT</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  
                                                  <select name="JSP_INCLUDE_TAX" onChange="javascript:cmdVatEdit()" class="formElemen">
	<option value="0"selected>No</option>
	<option value="1">Yes</option>
</select>
 </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Payment 
                                                  Type </td>
                                                <td height="21" width="27%"> 
                                                  
                                                  <select name="JSP_PAYMENT_TYPE"  class="formElemen">
	<option value="Cash">Cash</option>
	<option value="Credit">Credit</option>
</select>
 </td>
                                                <td width="9%">Term Of Payment</td>
                                                <td width="52%" colspan="2" class="comment"> 
                                                  <input name="JSP_DUE_DATE" value="12/12/2008" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.JSP_DUE_DATE);return false;" ><img class="PopcalTrigger" align="absmiddle" src="/ccs/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="JSP_NOTE" cols="100" rows="2"></textarea>
                                                </td>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp; 
                                                  
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2" width="30%">Group/Category/Code 
                                                        - Name</td>
                                                      <td class="tablehdr" colspan="3" height="16">Quantity</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">@Price</td>
                                                      <td class="tablehdr" rowspan="2" width="12%">Discount</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">Total</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Unit</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="7%" height="18">PO</td>
                                                      <td class="tablehdr" width="9%" height="18">Prev. 
                                                        Receive</td>
                                                      <td class="tablehdr" width="7%" height="18">Receive</td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                      <td width="30%" class="tablecell1"> 
                                                        <input type="hidden" name="itm_JSP_ITEM_MASTER_ID" value="504404363751144989">
                                                        <input type="hidden" name="ITM_JSP_PURCHASE_ITEM_ID" value="504404386333762442">
                                                        FOOD/Appetizer/Buah Segar</td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center">5.0</div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"></div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_QTY" size="5" style="text-align:center" onKeyUp="javascript:calcPrice(this, '0')">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_AMOUNT" size="20" class="readonly" readonly style="text-align:right" value="500,000.00">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_TOTAL_DISCOUNT" size="20" class="readonly" readonly style="text-align:right" value="0.00">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_TOTAL_AMOUNT" size="20" class="readonly" readonly style="text-align:right" value="">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="itm_JSP_UOM_ID" value="504404363693058755">
                                                          Kg</div>
                                                      </td>
                                                    </tr>
													<tr> 
                                                      <td width="30%" class="tablecell1"> 
                                                        <input type="hidden" name="itm_JSP_ITEM_MASTER_ID" value="504404363751144989">
                                                        <input type="hidden" name="ITM_JSP_PURCHASE_ITEM_ID" value="504404386333762442">
                                                        FOOD/Appetizer/Buah Segar</td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center">5.0</div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"></div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_QTY" size="5" style="text-align:center" onKeyUp="javascript:calcPrice(this, '0')">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_AMOUNT" size="20" class="readonly" readonly style="text-align:right" value="500,000.00">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_TOTAL_DISCOUNT" size="20" class="readonly" readonly style="text-align:right" value="0.00">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="itm_JSP_TOTAL_AMOUNT" size="20" class="readonly" readonly style="text-align:right" value="">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="itm_JSP_UOM_ID" value="504404363693058755">
                                                          Kg</div>
                                                      </td>
                                                    </tr>
                                                    
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="45%" valign="middle"> 
                                                        
                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                          
                                                          <tr> 
                                                            <td> 
                                                              
                                                               </td>
                                                          </tr>
                                                          
                                                        </table>
                                                        
                                                      </td>
                                                      <td width="55%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Sub 
                                                                Total</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <input type="hidden" name="sub_tot" value="0.0">
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="JSP_TOTAL_AMOUNT" readOnly class="readOnly" value="0.00" style="text-align:right">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Discount</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input name="JSP_DISCOUNT_PERCENT" type="text" value="0.0" size="5" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()">
                                                                % </div>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="JSP_DISCOUNT_TOTAL" readOnly class="readOnly" value="0.00" style="text-align:right">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>VAT</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="JSP_TAX_PERCENT" size="5" value="0.0" readOnly class="readOnly" style="text-align:center">
                                                                % </div>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="JSP_TOTAL_TAX" readOnly class="readOnly" value="0.00" style="text-align:right">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Grand 
                                                                Total</b></div>
                                                            </td>
                                                            <td width="17%">&nbsp;</td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="0.00" style="text-align:right">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%">&nbsp;</td>
                                                            <td width="17%">&nbsp;</td>
                                                            <td width="23%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td colspan="4"> 
                                                        
                                                      </td>
                                                    </tr>
                                                    
                                                    
                                                    <tr> 
                                                      
                                                      <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                      <td width="102" > 
                                                        <div align="left">
														
														<a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a>
														
														</div>
                                                      </td>
                                                      
                                                      <td width="97"> 
                                                        <div align="left">
														
														</div>
                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left">
														
														</div>
                                                      </td>
                                                    </tr>
                                                    
                                                    
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  //	cmdVendorChange();
							
                            //	parserMaster();
							
                          </script>
                          <script language="JavaScript">
						    
									//alert('in here');
									//cmdChangeItem();																		
							
							</script>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr>
    <td height="25" align="center" valign="middle" bgcolor="#576F26" class="footer">Copyright(C)2007 
      Athena Team, All rights reserved.</td>
  </tr>
</table>

            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
