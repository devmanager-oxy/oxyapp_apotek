 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
<script language=JavaScript src="/btdc-fin/main/common.js"></script>
 
 
 
 
 
 
 
 
 
 
 
 
 
<!-- Jsp Block -->
 
 
 
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title>Finance System</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';
            
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <script language="JavaScript">
            
            
            <!--
            //=======================================update===========================================================
            
            function cmdSearchJurnal(){
                window.open("/btdc-fin/transaction/s_nom_jurnal.jsp?formName=frmpettycashpaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                
                function cmdDepartment(){
                    var oid = document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value;
         
             if(oid=='1003'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='1002'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='1001'){
                                 
                                 }
         
             if(oid=='504404472719634006'){
                                 
                                 }
         
             if(oid=='504404472719723547'){
                                 
                                 }
         
             if(oid=='504404472719878297'){
                                 
                                 }
         
             if(oid=='504404469310257364'){
                                 
                                 }
         
             if(oid=='504404469310380270'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404469310440098'){
                                 
                                 }
         
             if(oid=='504404469310481692'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404469310526848'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404469310565052'){
                                 
                                 }
         
             if(oid=='504404469310900864'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472720737152'){
                                 
                                 }
         
             if(oid=='504404469311264911'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472721229123'){
                                 
                                 }
         
             if(oid=='504404471038585786'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472721250604'){
                                 
                                 }
         
             if(oid=='504404469311609614'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472721278971'){
                                 
                                 }
         
             if(oid=='504404472752375478'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472752410517'){
                                 
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.detailJSP_DEPARTMENT_ID.value="1003";
                                     
                                 }
         
             if(oid=='504404472752435168'){
                                 
                                 }
         
        }
        
        function cmdPrintJournal(){	 
            window.open("/btdc-fin/servlet/com.project.fms.report.RptPCPaymentPDF?oid=admin&pcPayment_id=0");
            }
            
            function cmdClickIt(){
                document.frmpettycashpaymentdetail.detailJSP_AMOUNT.select();
            }
            
            function cmdGetBalance(){
                
                var x = document.frmpettycashpaymentdetail.JSP_COA_ID.value;
                
         
        }
        
        function cmdFixing(){	
            document.frmpettycashpaymentdetail.command.value="9";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNewJournal(){		
            document.frmpettycashpaymentdetail.command.value="0";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNone(){	
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
            document.frmpettycashpaymentdetail.command.value="0";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();    
        }
        
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
        
        function checkNumber(){
            
            var st = document.frmpettycashpaymentdetail.JSP_AMOUNT.value;		
            var ab = document.frmpettycashpaymentdetail.JSP_ACCOUNT_BALANCE.value;		
            
            result = removeChar(st);
            
            result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            if(parseFloat(result) > parseFloat(ab)){
                
                if(parseFloat(ab)<1){                    
                    result = "0";
                    //result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    alert("No account balance available,\nCan not continue the transaction.");                    
                }else{                    
                result = ab;
                //result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                alert("Transaction amount over the account balance");
            }
        }
        
        document.frmpettycashpaymentdetail.JSP_AMOUNT.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
    }
    
    function checkNumber2(){
        var main = document.frmpettycashpaymentdetail.JSP_AMOUNT.value;		
        main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var currTotal = document.frmpettycashpaymentdetail.total_detail.value;
        currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	        
        var idx = document.frmpettycashpaymentdetail.select_idx.value;
        
        var maxtransaction = document.frmpettycashpaymentdetail.max_pcash_transaction.value;
        maxtransaction = cleanNumberFloat(maxtransaction, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var pbalanace = document.frmpettycashpaymentdetail.pcash_balance.value;
        pbalanace = cleanNumberFloat(pbalanace, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var limit = parseFloat(maxtransaction);
        
        if(limit > parseFloat(pbalanace)){
            //limit = parseFloat(pbalanace);
        }
        
        var st = document.frmpettycashpaymentdetail.detailJSP_AMOUNT.value;		
        result = removeChar(st);	
        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        //add
        if(parseFloat(idx)<0){
            
            var amount = parseFloat(currTotal) + parseFloat(result);
            
            if(amount>limit){//parseFloat(main)){
                alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
              
                result = "0";//parseFloat(limit)-parseFloat(currTotal);
            }
            
            var amount = parseFloat(currTotal) + parseFloat(result);
            
            document.frmpettycashpaymentdetail.JSP_AMOUNT.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }
        //edit
        else{
            var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            if(amount>limit){//parseFloat(main)){
                alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
                result = parseFloat(editAmount);			
                amount = limit;
            }
            
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            document.frmpettycashpaymentdetail.JSP_AMOUNT.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }
        
        document.frmpettycashpaymentdetail.detailJSP_AMOUNT.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
    }
    
    function cmdSubmitCommand(){
        document.frmpettycashpaymentdetail.command.value="4";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdActivity(oid){
        
        alert('Please finish and post this journal before continue to activity data.');
        
    }
    
    function cmdAdd(){
        document.frmpettycashpaymentdetail.select_idx.value="-1";
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
        document.frmpettycashpaymentdetail.command.value="2";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdAsk(idx){
        document.frmpettycashpaymentdetail.select_idx.value=idx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="71";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdConfirmDelete(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="6";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdSave(){
        document.frmpettycashpaymentdetail.command.value="11";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdEdit(idxx){
        document.frmpettycashpaymentdetail.select_idx.value=idxx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="3";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdCancel(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="3";
        document.frmpettycashpaymentdetail.prev_command.value="0";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdBack(){
        document.frmpettycashpaymentdetail.command.value="14";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdListFirst(){
        document.frmpettycashpaymentdetail.command.value="23";
        document.frmpettycashpaymentdetail.prev_command.value="23";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdListPrev(){
        document.frmpettycashpaymentdetail.command.value="21";
        document.frmpettycashpaymentdetail.prev_command.value="21";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdListNext(){
        document.frmpettycashpaymentdetail.command.value="22";
        document.frmpettycashpaymentdetail.prev_command.value="22";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdListLast(){
        document.frmpettycashpaymentdetail.command.value="24";
        document.frmpettycashpaymentdetail.prev_command.value="24";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    //-------------- script form image -------------------
    
    function cmdDelPict(oidPettycashPaymentDetail){
        document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmimage.command.value="9";
        document.frmimage.action="pettycashpaymentdetail.jsp";
        document.frmimage.submit();
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
    //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('/btdc-fin/images/home2.gif','/btdc-fin/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            
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
<body onLoad="MM_preloadImages('/btdc-fin/images/home2.gif','/btdc-fin/images/logout2.gif')">
<!--table width="100%" border="0" cellpadding="0" cellspacing="0">
 
  <tr> 
    <td width="100%"  height="91" align="left" valign="top" bgcolor="#e5efcb"><img src="/btdc-fin/images/logo.gif" width="131" height="90" /></td>
    <td align="left" valign="top" background="/btdc-fin/images/header.jpg" bgcolor="#e5efcb">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="right"><a href="/btdc-fin/home.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','/btdc-fin/images/home2.gif',1)"><img src="/btdc-fin/images/home.gif" name="Image8" width="74" height="22" border="0" id="Image8" /></a><a href="/btdc-fin/index.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image9','','/btdc-fin/images/logout2.gif',1)"><img src="/btdc-fin/images/logout.gif" alt="#" name="Image9" width="80" height="22" border="0" id="Image9" /></a></td>
        </tr>
        <tr> 
          <td><img src="/btdc-fin/images/spacer.gif" width="861" height="1" /></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="5" valign="top" bgcolor="#3d4d1b"><img src="/btdc-fin/images/spacer.gif" width="1" height="1" /></td>
    <td valign="top" bgcolor="#3d4d1b"><img src="/btdc-fin/images/spacer.gif" width="1" height="1" /></td>
  </tr>
</table-->
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr> 
    <td width="526">
      <table border="0" cellspacing="0" cellpadding="0" width="526">
        <tr> 
          <td rowspan="2"><img src="/btdc-fin/images/logo-finance1.jpg" width="216" height="144" /></td>
          <td><img src="/btdc-fin/images/logotxt-finance.gif" width="343" height="94" /></td>
        </tr>
        <tr> 
          <td style="background:url(/btdc-fin/images/head-line.gif) repeat-x"><img src="/btdc-fin/images/head-corner.gif" width="119" height="50" /></td>
        </tr>
      </table>
    </td>
    <td width="100%" valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td valign="top" style="background:url(/btdc-fin/images/head-bg.gif) repeat-x">
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="31" align="right" valign="top" >&nbsp;</td>
                            <td rowspan="2"><img src="../images/logo-kopegtel-----.jpg" width="73" height="74" /></td>
                <td rowspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td align="right" valign="top" >&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td style="background:url(/btdc-fin/images/head-icon-bg.gif) repeat-x">
		    
		   
            <script language="JavaScript">
			function cmdEnterApp(idx){
				//alert("user.getLoginId() : admin");				
				//alert("user.getPassword() : admin");				
				
				if(parseInt(idx)==1){
					window.location="/btdc-fin?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==2){
					window.location="/btdc-crm?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==3){
					window.location="/sipadu-inv/indexsl.jsp?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==4){
					window.location="/sipadu-inv/indexpg.jsp?login_id=admin&pass_wd=admin&command=1";
				}
				if(parseInt(idx)==5){
					window.location="/sipadu-fin/indexsp.jsp?login_id=admin&pass_wd=admin&command=1";
				}
			}
			</script>
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                  <td><a href="/btdc-fin/home.jsp" title="Finance System - Home"><img src="/btdc-fin/images/button-finance2.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td><a href="javascript:cmdEnterApp(2)" title="CRM System"><img src="/btdc-fin/images/button-inventory.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
			
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
 
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(/btdc-fin/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  
 
<script language="JavaScript"> 
 
function cmdHelp(){
	window.open("/btdc-fin/help.htm"); 
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
		
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
						
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
						
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="none";
			document.all.drpt2.style.display="";
			document.all.drpt.style.display="";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
									
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
			
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
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
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
			
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="";
			//document.all.jr2.style.display="none";
			//document.all.jr.style.display="none";
			
						
			break;	
		
		case 19 :
			
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
			
			
			
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			
			
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			
					
			
			
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
			
			
			
			
			
			
			
			
			
			
			//document.all.jr1.style.display="none";
			//document.all.jr2.style.display="";
			//document.all.jr.style.display="";
			
			
			break;
	}
}
 
 
 
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="/btdc-fin/images/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="/btdc-fin/images/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                
                <td height="49"> 
                  <div align="center">Periode Perkiraan : <br>
                    01 Jan 2011 - 31 Jan 2011<br>
                  </div>
                </td>
              </tr>
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="4"></td>
              </tr>
              
              <tr id="cash1"> 
                <td class="menu0"" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Transaksi Tunai</a></td>
              </tr>
              <tr id="cash2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Transaksi Tunai</a></td>
              </tr>
              <tr id="cash"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/cashreceivedetail.jsp?menu_idx=1">Penerimaan Tunai</a></td>
                    </tr>
                    	
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/penerimaan_kasbon.jsp?menu_idx=1">Penerimaan Kasbon</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">Kas Kecil</td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/pettycashpaymentdetail.jsp?menu_idx=1">Pengakuan Biaya</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/cash_receive.jsp?menu_idx=1">Pembayaran Tunai</a></td>
                    </tr>
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/kasbon.jsp?menu_idx=1">Kasbon</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/pettycashreplenishment.jsp?menu_idx=1">Pengisian Kembali</a></td>
                    </tr>
                    
                    
					
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/casharchivepost.jsp?menu_idx=1">Post Jurnal</a></td>
                    </tr>
                    
                    
					
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/casharchive.jsp?menu_idx=1">Arsip</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/master/cashacclink.jsp?menu_idx=1">Setup Perkiraan Tunai</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr id="bank1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Transaksi Bank</a></td>
              </tr>
              <tr id="bank2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Transaksi Bank</a></td>
              </tr>
              <tr id="bank"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/bankdepositdetail.jsp?menu_idx=2">Setoran Bank</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1">Pelunasan</td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/bankpopaymentsrc.jsp?menu_idx=2">Order Pembelian</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/pelunasanbank.jsp?menu_idx=2">pembelian Tunai</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu2"><a href="/btdc-fin/transaction/banknonpopaymentdetail.jsp?menu_idx=2">Pembelian Langsung</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/posting_transaksi_bank.jsp?menu_idx=2">Post Jurnal</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/bankarchive.jsp?menu_idx=2">Arsip</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/master/bankacclink.jsp?menu_idx=2">Setup Perkiraan Bank</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr id="ar1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"><a href="javascript:cmdChangeMenu('14')">Piutang</a> </td>
              </tr>
              <tr id="ar2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Piutang</a></td>
              </tr>
              <tr id="ar"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td height="18" width="90%" class="menu1">Transaksi</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/newarsrc.jsp?menu_idx=14">< %=strARNewInvoice%></a></td>
                                </tr-->
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/paymentsrc.jsp?menu_idx=14">< %=strARPayment%></a></td>
                                </tr-->
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/btdc-fin/ar/aging.jsp?menu_idx=14">Aging Analysis</a></td>
                                </tr>
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/archives.jsp?menu_idx=14">< %=strARArchives%></a></td>
                                </tr-->
                              </table>
                            </td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu1">Data Induk</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/general/bankaccount.jsp?menu_idx=14">< %=strARBankAccount%></a></td>
                                </tr-->
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/general/customer.jsp?menu_idx=14">< %=strARCustomer%></a></td>
                                </tr-->
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="/btdc-fin/master/aracclink.jsp?menu_idx=14">AR Acc. List</a></td>
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
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="inv1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('11')"> <a href="javascript:cmdChangeMenu('11')">Hutang</a> </td>
              </tr>
              <tr id="inv2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Hutang</a></td>
              </tr>
              <tr id="inv"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="#">Daftar Penerimaan Barang</a> </td>
                    </tr>
                    
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="#">Daftar Faktur</a></td>
                    </tr>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1">Purchase Retur</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/transaction/adjusmentlist.jsp?menu_idx=11">Stock 
                        Adjustment</a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="#">Aging Analysis</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="#">Purchase Acc. List</a> </td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              
              
              
              
              
              <tr id="gl1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('9')"> <a href="javascript:cmdChangeMenu('9')">Jurnal</a></td>
              </tr>
              <tr id="gl2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Jurnal</a></td>
              </tr>
              <tr id="gl"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td class="menu1">Jurnal Umum</td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/gldetail.jsp?menu_idx=9">Jurnal Baru</a></td>
                    </tr>
                    
                     <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/glkasbon.jsp?menu_idx=9">Jurnal Kasbon</a></td>
                    </tr>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1"><a href="/btdc-fin/journal/journal-proto.jsp?menu_idx=9">New 
							JournaL Proto--</a></td>
						</tr-->
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/glarchive.jsp?menu_idx=9">Arsip</a></td>
                    </tr>
                    
                    <tr> 
                      <td class="menu1">Jurnal Reversal</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/journalreversal.jsp?menu_idx=9">Jurnal Baru</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/glreverse.jsp?menu_idx=9">Jurnal Pembalikkan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/glreversearchive.jsp?menu_idx=9">Arsip</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">Jurnal Berulang</td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/transaction/akrualarsip.jsp?menu_idx=9">Arsip</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/transaction/posting_gl.jsp?menu_idx=9">Posting Jurnal</a></td>
                    </tr>
					<tr> 
                      <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                      </td>
                    </tr>
					
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
             
              
              
              <tr id="frpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Laporan Keuangan</a></td>
              </tr>
              <tr id="frpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Laporan Keuangan</a></td>
              </tr>
              <tr id="frpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
					<tr> 
                            <td height="18" width="90%" class="menu1"><a href="/btdc-fin/report/rptformat.jsp?menu_idx=4">Setup Laporan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/freport/worksheet.jsp?menu_idx=4">Jurnal Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/freport/glreport.jsp?menu_idx=4">Buku Besar</a></td>
                    </tr>					
					<tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/freport/neraca.jsp?menu_idx=4">Neraca</a></td>
                    </tr>
					<tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/freport/profitloss_rpt.jsp?menu_idx=4">Laba Rugi</a></td>
                    </tr>
					
					<tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/freport/neraca.jsp?menu_idx=4">Penjelasan</a></td>
                    </tr>
					<tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/neraca_penjelasan.jsp?menu_idx=4">Neraca</a></td>
                    </tr>
					<tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/income_penjelasan.jsp?menu_idx=4">Laba Rugi</a></td>
                    </tr>
					<!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/expense_penjelasan.jsp?menu_idx=4">Biaya</a></td>
                    </tr-->
					
					
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Neraca-org</td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/btdc-fin/freport/bsstandard.jsp?menu_idx=4">Standar</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/btdc-fin/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="/btdc-fin/freport/bsmultiple.jsp?menu_idx=4">Multi Periode</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laba Rugi</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/profitloss.jsp?menu_idx=4">Standar</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/profitloss0_v01.jsp?menu_idx=4">Berdasarkan Departemen</a></td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/profitloss1.jsp?menu_idx=4">Berdasarkan Bagian</a></td>
                    </tr>
                    
                    
                    
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laporan Lainnya</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/bsstandard_v02.jsp?menu_idx=4">Neraca</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/bsstandard_v01.jsp?menu_idx=4">Neraca Akhir</a></td>
                    </tr>
                    <!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="< %=approot%>/freport/bsstandard_classv01.jsp?id_class=2&menu_idx=4">< %=strFRNeracaSP%></a></td>
                    </tr-->
                    <!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="< %=approot%>/freport/bsstandard_classv01.jsp?id_class=1&menu_idx=4">< %=strFRNeracaNSP%></a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/portofolio.jsp?menu_idx=4"">Portofolio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/bsdetail_v01.jsp?menu_idx=4">Neraca</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/biaya_v01.jsp?menu_idx=4&pnl_type=0">Biaya</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/pendapatan_v01.jsp?menu_idx=4&pnl_type=1">Pendapatan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/ratio.jsp?menu_idx=4">Analisa Rasio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/iktisarlabarugi.jsp?menu_idx=4">Iktisar Laba Rugi</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/kinerja.jsp?menu_idx=4">Kinerja</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/outstanding_kasbon.jsp?menu_idx=4">Kasbon Outstanding</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laporan Advanced</td>
                    </tr>
                    
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/bsdetail_v01.jsp?menu_idx=4">Neraca</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/rekap_biaya_all.jsp?menu_idx=4">Rekap Biaya Seluruhnya</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="/btdc-fin/freport/biaya_v02.jsp?menu_idx=4">Biaya Operasi Direksi</a></td>
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
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="drpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('5')"> <a href="javascript:cmdChangeMenu('5')">Donor Report</a> </td>
              </tr>
              <tr id="drpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Donor Report</a> </td>
              </tr>
              <tr id="drpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/dreport/summary.jsp?menu_idx=5">Summary</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/dreport/workplandetail.jsp?menu_idx=5">Workplan - Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/dreport/expensecategory.jsp?menu_idx=5">By Category</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/dreport/natureexpensecategory.jsp?menu_idx=5">By Group - Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                      </td>
                    </tr>
                    
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              
              <tr id="master1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')">Data Induk</a></td>
              </tr>
              <tr id="master2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Data Induk</a></td>
              </tr>
              <tr id="master"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="/btdc-fin/master/company.jsp?menu_idx=6">Pengaturan Sistem</a></td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Akuntansi</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/master/coa.jsp?menu_idx=6">Daftar Perkiraan</a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/master/coabudget_edt.jsp?menu_idx=6">Anggaran/Target</a></td>
                          </tr>
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/master/coaportofoliosetup.jsp?menu_idx=6">Portofolio Setup</a> </td>
                          </tr>
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/coaexpensecategory.jsp?menu_idx=6">Kategori Perkiraan</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/coanatureexpensecategory.jsp?menu_idx=6">Pengelompokan Perkiraan</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/general/exchangerate.jsp?menu_idx=6">Kurs Pembukuan</a> </td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/master/periode.jsp?menu_idx=6">Periode</a></td>
                          </tr>
                          
						  
                        </table>
                      </td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Workplan </td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" nowrap> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/module.jsp?menu_idx=6">Data Kerja</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/coaexpensebudget.jsp?menu_idx=6">Alokasi Biaya Kegiatan</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/donor.jsp?menu_idx=6">Daftar Donor</a></td>
                          </tr>
                          
                          <!-- tr> 
								<td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/donorcomponent.jsp?menu_idx=6">Donor 
								  Component </a></td>
							  </tr -->
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/activity/activityperiod.jsp?menu_idx=6">Activity Period</a></td>
                          </tr>
                          
                        </table>
                      </td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Perusahaan</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/payroll/employee.jsp?menu_idx=6">Pengguna</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/payroll/department.jsp?menu_idx=6">Daftar Departemen</a></td>
                          </tr>
                          
                          <!--tr> 
								<td width="80%" height="18" class="menu2"><a href="/btdc-fin/payroll/section.jsp?menu_idx=6">Section</a></td>
							  </tr-->
                        </table>
                      </td>
                    </tr>
                    
                    
                    <tr> 
                      <td height="18" width="90%" class="menu1">Umum</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/general/country.jsp?menu_idx=6">Negara</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="/btdc-fin/general/currency.jsp?menu_idx=6">Mata Uang</a></td>
                          </tr>
                          
                          <!--tr> 
								<td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/itemtype.jsp?menu_idx=6">Item 
								  Type</a> </td>
							  </tr-->
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/termofpayment.jsp?menu_idx=6">Term Pembayaran</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/shipaddress.jsp?menu_idx=6">Alamat Pengiriman</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/paymentmethod.jsp?menu_idx=6">Metode Pembayaran</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/location.jsp?menu_idx=6">Daftar Lokasi</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/kecamatan.jsp?menu_idx=6">Kecamatan</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/desa.jsp?menu_idx=6">Desa</a></td>
                          </tr>
                          
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/master/pekerjaan.jsp?menu_idx=6">Daftar Pekerjaan</a></td>
                          </tr>
                          
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/general/dinas.jsp?menu_idx=6">Dinas</a></td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="/btdc-fin/general/dinasunit.jsp?menu_idx=6">Unit Dinas</a></td>
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
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              
              
              <tr id="closing1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')">Tutup Periode</a></td>
              </tr>
              <tr id="closing2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Tutup Periode</a></td>
              </tr>
              <tr id="closing"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/closing/periode.jsp?menu_idx=13"> 
                        
                        Tutup Bulanan
                        
                        </a></td>
                    </tr>
                    
                    
                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
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
                      <td class="menu1"><a href="/btdc-fin/system/sysprop.jsp?menu_idx=12">Sistem Properti</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/admin/userlist.jsp?menu_idx=12">Daftar Pengguna</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="/btdc-fin/admin/grouplist.jsp?menu_idx=12">Pengelompokan Pengguna</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td class="menu0"><a href="/btdc-fin/logout.jsp">Logout</a></td>
              </tr>
              <tr> 
                <td ><img src="/btdc-fin/images/spacer.gif" width="1" height="2"></td>
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
	cmdChangeMenu('1');
</script>
 
                  <!--  PopCalendar(tag name and id must match) Tags should not be enclosed in tags other than the html body tag. -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="/btdc-fin/calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           
                                           <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23">&nbsp;&nbsp;<font class="lvl1">Kas Kecil</font><font class="tit1">&nbsp;&raquo;&nbsp;<span class="lvl2">Pengakuan Biaya</span></font></td>
                                    <td width="40%" height="23"> 
                                      <table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap>
      <div align="right"><font face="Arial, Helvetica, sans-serif"><b>ADMINISTRATOR , Login : 07/09/2011 00:00:00&nbsp; </b>[ <a href="/btdc-fin/logout.jsp">Logout</a> , <a href="/btdc-fin/updatepwd.jsp">Change  
                            Password</a> ]<b>&nbsp;&nbsp;&nbsp;</b></font></div></td>
  </tr>
</table>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="/btdc-fin/images/line1.gif" ></td>
                                  </tr>
                                </table>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="/btdc-fin/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmpettycashpaymentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="2">
                                                            <input type="hidden" name="vectSize" value="6">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="prev_command" value="0">
                                                            <input type="hidden" name="hidden_pettycash_payment_detail_id" value="0">
                                                            <input type="hidden" name="hidden_pettycash_payment_id" value="0">
                                                            <input type="hidden" name="JSP_OPERATOR_ID" value="504404384818925380">
                                                            <input type="hidden" name="JSP_TYPE" value="0">
                                                            <input type="hidden" name="JSP_STATUS" value="1">
                                                            <input type="hidden" name="select_idx" value="-1">
                                                            <input type="hidden" name="menu_idx" value="1">
                                                            <input type="hidden" name="max_pcash_transaction" value="5000000.0">
                                                            <input type="hidden" name="pcash_balance" value="">
                                                            
                                                            
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="4" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="31%">&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <div align="right">Tanggal : 
                                                    07 September 2011&nbsp;, &nbsp;Operator 
                                                    : admin&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td colspan="2"><b>EDITOR KEGIATAN</b></td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">&nbsp;</td>
                                                <td width="82%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Tahun Angaran</td>
                                                <td width="82%"> 
                                                  <select name="select4">
                                                    <option selected>2011</option>
                                                    <option>2010</option>
                                                    <option>2009</option>
                                                    <option>...</option>
                                                  </select>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Lokasi</td>
                                                <td width="82%"> 
                                                  <select name="select">
                                                    <option>Pusat</option>
                                                    <option selected>Semeru</option>
                                                    <option>Tabanan</option>
                                                    <option>...</option>
                                                  </select>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Jenis Kegiatan</td>
                                                <td width="82%"> 
                                                  <select name="select5">
                                                    <option>-</option>
                                                    <option selected>Majelis</option>
                                                    <option>Misi</option>
                                                    <option>Diakoma</option>
                                                    <option>Pembangunan</option>
                                                  </select>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Bidang</td>
                                                <td width="82%"> 
                                                  <select name="select2">
                                                    <option>-</option>
                                                    <option selected>Kemajelisan</option>
                                                    <option>Ibadah</option>
                                                    <option>Persekutuan - Kms 
                                                    Anak</option>
                                                    <option>...</option>
                                                  </select>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Jenis Aktifitas</td>
                                                <td width="82%"> 
                                                  <select name="select3">
                                                    <option>-</option>
                                                    <option selected>Rutin</option>
                                                    <option>Insidentil</option>
                                                    <option>Inventaris</option>
                                                    <option>Lainnya</option>
                                                  </select>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Nama 
                                                  Kegiatan</td>
                                                <td width="82%"> 
                                                  <textarea name="textfield" cols="70" rows="2"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Sasaran</td>
                                                <td width="82%"> 
                                                  <textarea name="textfield2" cols="70" rows="4"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Hari</td>
                                                <td width="82%"> 
                                                  <textarea name="textarea" cols="70" rows="2"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Tanggal</td>
                                                <td width="82%"> 
                                                  <textarea name="textarea2" cols="70" rows="2"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Waktu</td>
                                                <td width="82%"> 
                                                  <textarea name="textarea3" cols="70" rows="2"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%" valign="top">Keterangan</td>
                                                <td width="82%"> 
                                                  <textarea name="textarea4" cols="70" rows="4"></textarea>
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">&nbsp;</td>
                                                <td width="82%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"><img src="../images/save.gif" width="55" height="22"> 
                                                  <a href="kegiatan.jsp"><img src="../images/back.gif" width="51" height="22" border="0"></a> 
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">&nbsp;</td>
                                                <td width="82%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="8%">Daftar Anggaran</td>
                                                <td width="82%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="5%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">
                                            <table width="50%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="5%" class="tablehdr"> 
                                                  No</td>
                                                <td width="32%" class="tablehdr">Keterangan</td>
                                                <td width="34%" class="tablehdr">Akun 
                                                  Perkiraan </td>
                                                <td width="29%" class="tablehdr">Anggaran</td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell">1</td>
                                                <td width="32%" class="tablecell"><a href="kegiatanedit.jsp">TKP</a></td>
                                                <td width="34%" class="tablecell">510100 
                                                  - TKP (TANDA KASIH PELAYANAN)<br>
                                                </td>
                                                <td width="29%" class="tablecell"> 
                                                  <div align="right">Rp. 10.000.000,-</div>
                                                </td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell">2</td>
                                                <td width="32%" class="tablecell"><a href="kegiatanedit.jsp">Konsumsi</a></td>
                                                <td width="34%" class="tablecell">510500 
                                                  - KONSUMSI<br>
                                                </td>
                                                <td width="29%" class="tablecell"> 
                                                  <div align="right">Rp. 5.000.000,-</div>
                                                </td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell"><font size="1">3</font></td>
                                                <td width="32%" class="tablecell"> 
                                                  <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield3">
                                                    </font></div>
                                                </td>
                                                <td width="34%" class="tablecell"> 
                                                  <div align="center"><font size="1"> 
                                                    <select name="select6">
                                                      <option value="PENGELUARAN">5000 
                                                      - PENGELUARAN</option>
                                                      <option>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5001 - MAJELIS/UMUM</option>
                                                      <option>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5002 - TKP BULANAN</option>
                                                      <option>...</option>
                                                    </select>
                                                    </font></div>
                                                </td>
                                                <td width="29%" class="tablecell"> 
                                                  <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield4">
                                                    </font></div>
                                                </td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell"><font size="1">4</font></td>
                                                <td width="32%" class="tablecell"><font size="1"></font></td>
                                                <td width="34%" class="tablecell"><font size="1"></font></td>
                                                <td width="29%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell"><font size="1">5</font></td>
                                                <td width="32%" class="tablecell"><font size="1"></font></td>
                                                <td width="34%" class="tablecell"><font size="1"></font></td>
                                                <td width="29%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="5%" class="tablecell"><font size="1">6</font></td>
                                                <td width="32%" class="tablecell"><font size="1"></font></td>
                                                <td width="34%" class="tablecell"><font size="1"></font></td>
                                                <td width="29%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr> 
                                                <td width="5%"><font size="1"></font></td>
                                                <td width="32%"><font size="1"></font></td>
                                                <td width="34%"><font size="1"></font></td>
                                                <td width="29%"><font size="1"></font></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><a href="kegiatanedit.jsp"><img src="../images/add.gif" width="49" height="22" border="0"></a></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
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
                            <tr align="left" valign="top" > 
                              <td colspan="4" class="command">&nbsp; </td>
                            </tr>
                          </table>
                                                            
                                                            <script language="JavaScript">
                                                                
                                                                //cmdGetBalance();
                                                                
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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="2" style="background:url(/btdc-fin/images/footerline.gif) repeat-x"><img src="/btdc-fin/images/footerline.gif" width="9" height="9" /></td>
        </tr>
        <tr>
          
    <td height="35" valign="top" style="padding-left:10px; background:url(/btdc-fin/images/footergrad.gif) repeat-x" width="50%">Powered by i-System&reg;, People &amp; Nature Consulting International<br />
      <a href="http://www.pnci-int.com/" target="_blank">www.pnci-int.com</a> 
    </td>
          
    <td align="right" valign="top" style="padding-right:10px; background:url(/btdc-fin/images/footergrad.gif) repeat-x" width="50%">Copyright 
      © 2011 Bali Tourism Development Corporation</td>
        </tr>
      </table>
 
 
<!--table width="100%" border="0" cellpadding="0" cellspacing="0">
  
  <tr>
    <td height="25" align="center" valign="middle" bgcolor="#3D4D1B" class="footer">Copyright(C)2007, All rights reserved.</td>
  </tr>
</table-->
 
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

