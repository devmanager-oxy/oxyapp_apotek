 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
<script language=JavaScript src="/btdc-fin/main/common.js"></script>
 
 
 
 
 
 
 
 
 
 
 
 
 
<!-- Jsp Block -->
 
 
 
<html >
<head>
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
                
				
				function cmdGoBack(keg){
					//self.opener.document.<%//=formName%>.<%//=txt_Id%>.value = glOid;	
					self.opener.document.frmpettycashpaymentdetail.kegiatan.value=keg;
					self.close();					
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
</head>
<body onLoad="MM_preloadImages('/btdc-fin/images/home2.gif','/btdc-fin/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title">&nbsp; </td>
                    </tr>
                    <!--tr> 
                      <td><img src="/btdc-fin/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                    <tr> 
                      <td> 
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
                                                <td width="12%" nowrap>Lokasi</td>
                                                <td width="78%"> 
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
                                                <td width="12%" nowrap>Jenis Kegiatan</td>
                                                <td width="78%"> 
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
                                                <td width="12%" nowrap>Bidang</td>
                                                <td width="78%"> 
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
                                                <td width="12%" nowrap>Jenis Aktifitas</td>
                                                <td width="78%"> 
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
                                                <td width="12%">&nbsp;</td>
                                                <td width="78%"><img src="../images/search.gif" width="59" height="21"></td>
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
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="3%" class="tablehdr"> 
                                                  No</td>
                                                <td width="10%" class="tablehdr">Kode</td>
                                                <td width="13%" class="tablehdr">Kegiatan</td>
                                                <td width="22%" class="tablehdr">Sasaran</td>
                                                <td width="7%" class="tablehdr">Total 
                                                  Anggaran </td>
                                                <td width="7%" class="tablehdr">Total 
                                                  Pemakaian</td>
                                                <td width="7%" class="tablehdr">Saldo</td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">1</font></td>
                                                <td width="10%" class="tablecell">11.011190.0001</td>
                                                <td width="13%" class="tablecell"><a href="javascript:cmdGoBack('Persekutuan pengerja')"><font size="1">Persekutuan 
                                                  pengerja </font></a></td>
                                                <td width="22%" class="tablecell"><font size="1">1. 
                                                  Mengucapkan syukur atas pelayanan 
                                                  yang sudah dikakukan<br>
                                                  2. Mohon pimpinan Tuhan untuk 
                                                  pelayanan yang akan datang<br>
                                                  3. Belajar Firman Tuhan yang 
                                                  dapat menuntun pelayana yang 
                                                  berkenan<br>
                                                  4. Menjalin &amp; Mempererat 
                                                  hunganan antar sesama pengurus</font></td>
                                                <td width="7%" class="tablecell"><font size="1">Rp. 
                                                  15.000.000,- </font></td>
                                                <td width="7%" class="tablecell"><font size="1">Rp. 
                                                  5.000.000,- </font></td>
                                                <td width="7%" class="tablecell"><font size="1">Rp. 
                                                  10.000.000,- <br>
                                                  </font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">2</font></td>
                                                <td width="10%" class="tablecell">11.011190.0002</td>
                                                <td width="13%" class="tablecell"><a href="javascript:cmdGoBack('Rapat Pleno Majelis')"><font size="1">Rapat 
                                                  Pleno Majelis</font></a></td>
                                                <td width="22%" class="tablecell"><font size="1">Aktivitas 
                                                  pelayanan gereja yang bisa terlaksana 
                                                  dengan lancar dan teratur</font></td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell">&nbsp;</td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">3</font></td>
                                                <td width="10%" class="tablecell">&nbsp;</td>
                                                <td width="13%" class="tablecell"><font size="1"></font></td>
                                                <td width="22%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell">&nbsp;</td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">4</font></td>
                                                <td width="10%" class="tablecell">&nbsp;</td>
                                                <td width="13%" class="tablecell"><font size="1"></font></td>
                                                <td width="22%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell">&nbsp;</td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">5</font></td>
                                                <td width="10%" class="tablecell">&nbsp;</td>
                                                <td width="13%" class="tablecell"><font size="1"></font></td>
                                                <td width="22%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell">&nbsp;</td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="3%" class="tablecell"><font size="1">6</font></td>
                                                <td width="10%" class="tablecell">&nbsp;</td>
                                                <td width="13%" class="tablecell"><font size="1"></font></td>
                                                <td width="22%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                                <td width="7%" class="tablecell">&nbsp;</td>
                                                <td width="7%" class="tablecell"><font size="1"></font></td>
                                              </tr>
                                              <tr> 
                                                <td width="3%"><font size="1"></font></td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="13%"><font size="1"></font></td>
                                                <td width="22%"><font size="1"></font></td>
                                                <td width="7%"><font size="1"></font></td>
                                                <td width="7%">&nbsp;</td>
                                                <td width="7%"><font size="1"></font></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <p>&nbsp;</p>
                                          </td>
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
            <!--table width="100%" border="0" cellpadding="0" cellspacing="0">
  
  <tr>
    <td height="25" align="center" valign="middle" bgcolor="#3D4D1B" class="footer">Copyright(C)2007, All rights reserved.</td>
  </tr>
</table-->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

