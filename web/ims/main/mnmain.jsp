
<%
menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
//out.println(idx1);
%>
<script language="JavaScript">
function cmdChangeMenu(idx){
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;
	
	switch(parseInt(idx)){
	
		case 1 : 
			document.all.cash1.style.display="none";
			document.all.cash2.style.display="";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			////document.all.pr1.style.display="";
			////document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			
		
			document.all.cash.style.display="";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";		
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";
								
			break;
		
		case 2 :
			
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="none";
			document.all.bank2.style.display="";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			
			document.all.cash.style.display="none";
			document.all.bank.style.display="";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";			
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";			
			break;
		
		case 3 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="none";
			document.all.ap2.style.display="";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";			
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";			
			break;	
			
		case 4 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="none";
			document.all.frpt2.style.display="";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";						
			break;
			
		case 5 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="none";
			document.all.drpt2.style.display="";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";						
			break;
					
		case 6 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="none";
			document.all.master2.style.display="";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="";
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";						
			break;
		
		case 7 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="none";
			document.all.dtransfer2.style.display="";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";						
			break;
		//---
		case 8 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";			
			break;	
		
		case 9 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.gl1.style.display="none";
			document.all.gl2.style.display="";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";		
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="";			
			//document.all.pr.style.display="none";	
			document.all.inv.style.display="none";
			break;
		
		case 10 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="none";
			//document.all.pr2.style.display="";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";		
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="";
			document.all.inv.style.display="none";	
			break;
			
		case 11 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.inv1.style.display="none";
			document.all.inv2.style.display="";	
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";		
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";	
			document.all.inv.style.display="";
			break;		
		
		case 0 :
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
		
			document.all.cash.style.display="none";
			document.all.bank.style.display="none";
			document.all.ap.style.display="none";
			document.all.frpt.style.display="none";
			document.all.drpt.style.display="none";
			document.all.master.style.display="none";
			document.all.dtransfer.style.display="none";
			//-			
			//document.all.ar.style.display="none";			
			document.all.gl.style.display="none";			
			//document.all.pr.style.display="none";
			document.all.inv.style.display="none";			
			break;	
	}
}

</script>
<table width="165" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
  </tr>
  <tr id="cash1"> 
    <td class="catmenu"" onClick="javascript:cmdChangeMenu('1')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('1')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('1')">Cash</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="cash2"> 
    <td class="catmenu""> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td>Cash</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="cash"> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="menu1"><a href="<%=approot%>/master/cashacclink.jsp?menu_idx=1">Cash 
            Account List</a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="<%=approot%>/transaction/cashreceivedetail.jsp?menu_idx=1">Receipt</a></td>
        </tr>
        <tr> 
          <td class="menu1">Petty Cash</td>
        </tr>
        <tr> 
          <td class="menu2"><a href="<%=approot%>/transaction/pettycashpaymentdetail.jsp?menu_idx=1">Payment</a></td>
        </tr>
        <tr> 
          <td class="menu2"><a href="<%=approot%>/transaction/pettycashreplenishment.jsp?menu_idx=1">Replenishment</a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="<%=approot%>/transaction/casharchive.jsp?menu_idx=1">Archives</a></td>
        </tr>
        <tr> 
          <td class="menu1">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="bank1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('2')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('2')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('2')">Bank</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="bank2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td>Bank</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="bank"> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="menu1"><a href="<%=approot%>/master/bankacclink.jsp?menu_idx=2">Bank 
            Account List</a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="<%=approot%>/transaction/bankdepositdetail.jsp?menu_idx=2">Deposit</a></td>
        </tr>
        <tr> 
          <td class="menu1">Payment</td>
        </tr>
        <tr> 
          <td class="menu2"><a href="<%=approot%>/transaction/bankpopaymentsrc.jsp?menu_idx=2">Based 
            On PO</a></td>
        </tr>
        <tr> 
          <td class="menu2"><a href="<%=approot%>/transaction/banknonpopaymentdetail.jsp?menu_idx=2">Non 
            PO</a></td>
        </tr>
        <tr> 
          <td class="menu1"><a href="<%=approot%>/transaction/bankarchive.jsp?menu_idx=2">Archives</a></td>
        </tr>
        <tr> 
          <td class="menu1">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="inv1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('3')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('11')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('11')">Account Payable</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="inv2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td>Account Payable</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="inv"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicesrc.jsp?menu_idx=11">New 
            Invoice</a></td>
        </tr>
        <!--tr> 
          <td height="18" width="90%" class="menu1">New Invoice</td>
        </tr-->
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicearchive.jsp?menu_idx=11">Archives</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%"> </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="ap1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('3')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('3')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('3')">Purchases</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="ap2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td>Purchases</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="ap"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="19" width="90%" class="menu1"><a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=3">Purchase 
            Acc. List</a></td>
        </tr>
        <tr> 
          <td height="19" width="90%" class="menu1"><a href="<%=approot%>/general/vendor.jsp?menu_idx=3">Vendor</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/purchaseitem.jsp?menu_idx=3">New 
            Order </a></td>
        </tr>
        <!--tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/ap-proto.jsp?menu_idx=3">New 
            Order Proto --</a></td>
        </tr-->
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/purchasearchive.jsp?menu_idx=3">Archives</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%"> </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="gl1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('9')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('9')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td><a href="javascript:cmdChangeMenu('9')">General Ledger</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="gl2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td>General Ledger</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="gl"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/gldetail.jsp?menu_idx=9">New 
            Journal</a></td>
        </tr>
        <!--tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/journal-proto.jsp?menu_idx=9">New 
            JournaL Proto--</a></td>
        </tr-->
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/glarchive.jsp?menu_idx=9">Archives</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> </td>
        </tr>
      </table>
    </td>
  </tr>
  <%if(1==2){%>
  <tr id="pr1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('10')"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('10')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('10')">Payroll</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="pr2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td nowrap>Payroll</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="pr"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1">Payroll ...</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Archives</td>
        </tr>
        <tr> 
          <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> </td>
        </tr>
      </table>
    </td>
  </tr>
  <%}%>
  <tr id="frpt1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('4')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="86">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('4')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('4')">Financial Report</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="frpt2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="86">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td nowrap>Financial Report</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="frpt"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1">Worksheet</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Balance Sheet</td>
        </tr>
        <tr> 
          <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard.jsp?menu_idx=4">Standard</a></td>
        </tr>
        <tr> 
          <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/profitloss.jsp?menu_idx=4">Profit 
            & Loss</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Cash Flow</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="drpt1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('5')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="81">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('5')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('5')">Donor Report</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="drpt2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="81">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td nowrap>Donor Report</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="drpt"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/summary.jsp?menu_idx=5">Summary 
            Report</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/workplandetail.jsp?menu_idx=5">Workplan 
            Detail</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/expensecategory.jsp?menu_idx=5">Expense 
            Category</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/natureexpensecategory.jsp?menu_idx=5">Detail 
            Exp. Category</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="dtransfer1"> 
    <td class="catmenu" onClick="javascript:cmdChangeMenu('7')"> 
      <table border="0" cellspacing="0" cellpadding="0" width="75">
        <tr> 
          <td><a href="javascript:cmdChangeMenu('7')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('7')">Data Transfer</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="dtransfer2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="75">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td nowrap>Data Transfer</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="dtransfer"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1">Transfer ...</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Archives</td>
        </tr>
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
          <td><a href="javascript:cmdChangeMenu('6')"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="javascript:cmdChangeMenu('6')">Master Maintenance</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="master2"> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="89">
        <tr> 
          <td><img src="<%=approot%>/images/bullet.gif" width="15" height="15" hspace="5" border="0" /></td>
          <td nowrap>Master Maintenance</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="master"> 
    <td> 
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/company.jsp?menu_idx=6">Configuration</a></td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Item Group</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">Item Category</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">UOM</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">Item Master</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">Vendor</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">Department</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">&nbsp;</td>
        </tr>
        <tr>
          <td height="18" width="90%" class="menu1">&nbsp;</td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Accounting</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensecategory.jsp?menu_idx=6">Account 
                  Category</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coanatureexpensecategory.jsp?menu_idx=6">Account 
                  Type</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/periode.jsp?menu_idx=6">Period</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/exchangerate.jsp?menu_idx=6">Bookkeeping 
                  Rate</a> </td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coa.jsp?menu_idx=6">Chart 
                  Of Account</a></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">Activity </td>
        </tr>
        <tr> 
          <td height="18" width="90%" nowrap> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/module.jsp?menu_idx=6">Activity 
                  Data</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coaexpensebudget.jsp?menu_idx=6">Expense 
                  Budget</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donor.jsp?menu_idx=6">Donor</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donorcomponent.jsp?menu_idx=6">Donor 
                  Component </a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/activityperiod.jsp?menu_idx=6">Period</a></td>
              </tr>
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
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/country.jsp?menu_idx=6">Country</a></td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/currency.jsp?menu_idx=6">Currency</a></td>
              </tr>
              <!--tr> 
                <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/itemtype.jsp?menu_idx=6">Item 
                  Type</a> </td>
              </tr-->
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/termofpayment.jsp?menu_idx=6">Term 
                  of Payment</a></td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/shipaddress.jsp?menu_idx=6">Shipping 
                  Address</a> </td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=6">Payment 
                  Method</a> </td>
              </tr>
              <tr> 
                <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/location.jsp?menu_idx=6">Location</a></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="18" width="90%" class="menu1">HRD</td>
        </tr>
        <tr> 
          <td height="18" width="90%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=6">Employee</a> 
                </td>
              </tr>
              <tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/department.jsp?menu_idx=6">Department</a></td>
              </tr>
              <!--tr> 
                <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/section.jsp?menu_idx=6">Section</a></td>
              </tr-->
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
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="102">
        <tr> 
          <td><a href="<%=approot%>/system/sysprop.jsp"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="<%=approot%>/system/sysprop.jsp">System 
            Properties</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td class="catmenu"> 
      <table border="0" cellspacing="0" cellpadding="0" width="55">
        <tr> 
          <td><a href="<%=approot%>/admin/userlist.jsp"><img src="<%=approot%>/images/bullet2.gif" width="15" height="15" hspace="5" border="0" /></a></td>
          <td nowrap><a href="<%=approot%>/admin/userlist.jsp">User 
            Admin</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>
<script language="JavaScript">
	cmdChangeMenu('<%=menuIdx%>');
</script>
