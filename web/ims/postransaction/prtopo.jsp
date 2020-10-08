 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%!
    public int checkPO(Vector vect, long vendorId){
        try{
            if(vect!=null && vect.size()>0){
                    for(int k=0;k<vect.size();k++){
                        Vector list = (Vector)vect.get(k);
                            Purchase po = (Purchase)list.get(0);
                            if(po.getVendorId()==vendorId){
                                    return k;
                                }
                        }
                    return -1;
            }
		}catch(Exception eee){
			return -1;
		}
		return -1;
	}
		
	public String removeComma(String numberx){
	
		
		String result = "";
		for(int ix=0; ix<numberx.length(); ix++){
			String xx = ""+numberx.charAt(ix);
			if(!xx.equals(",")){
				result = result + xx;
			}
		}
		
		return result;
	}	
%>
<!-- Jsp Block -->
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchaseRequest = JSPRequestValue.requestLong(request, "hidden_purchase_request_id");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchaseRequest =0;
}
/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPurchaseRequest ctrlPurchaseRequest = new CmdPurchaseRequest(request);
JSPLine ctrLine = new JSPLine();
iErrCode = ctrlPurchaseRequest.action(JSPCommand.EDIT , oidPurchaseRequest);
JspPurchaseRequest jspPurchaseRequest = ctrlPurchaseRequest.getForm();
PurchaseRequest purchaseRequest = ctrlPurchaseRequest.getPurchaseRequest();
msgString =  ctrlPurchaseRequest.getMessage();
%>
<%
long oidPurchaseRequestItem = JSPRequestValue.requestLong(request, "hidden_purchase_request_item_id");

CmdPurchaseRequestItem ctrlPurchaseRequestItem = new CmdPurchaseRequestItem(request);
int iErrCode2 = ctrlPurchaseRequestItem.action(iJSPCommand , oidPurchaseRequestItem, oidPurchaseRequest);
JspPurchaseRequestItem jspPurchaseRequestItem = ctrlPurchaseRequestItem.getForm();
PurchaseRequestItem purchaseRequestItem = ctrlPurchaseRequestItem.getPurchaseRequestItem();
String msgString2 =  ctrlPurchaseRequestItem.getMessage();

whereClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+oidPurchaseRequest;
orderClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID];
Vector purchReqItems = DbPurchaseRequestItem.list(0,0, whereClause, orderClause);


//simpan ke dalam po
// proses simpan
if(iJSPCommand==JSPCommand.SAVE){
    //Hashtable hashtable = new Hashtable();
    Vector list = new Vector();
    if(purchReqItems.size()>0){
        for(int h=0;h<purchReqItems.size();h++){
            PurchaseRequestItem pr = (PurchaseRequestItem)purchReqItems.get(h);
            
            String[] txtpo = null;
            String[] txtvendor = null;
            String[] txtlastprice = null;
            String[] item_status = null;
            int qtyNew = 0;
            String vendorId = "";
            double lastprice = 0;
            String strLastprice = "";
            String strqty = "";
            String itemStatus = "";
            if(purchReqItems.size()>1){
                txtpo = request.getParameterValues("txtqty_new_po");
                txtvendor = request.getParameterValues("selectvendor");
                txtlastprice = request.getParameterValues("txt_last_price");
                item_status = request.getParameterValues("item_status");
                
                strqty = txtpo[h];
                strLastprice = txtlastprice[h];
                vendorId = txtvendor[h];
                itemStatus = item_status[h];  
            }else{
                strqty = request.getParameter("txtqty_new_po");
                vendorId = request.getParameter("selectvendor");
                strLastprice = request.getParameter("txt_last_price");
                itemStatus = request.getParameter("item_status");
            }
            if(strqty==""){
				strqty="0";
			}
			    
            try{
                qtyNew = Integer.parseInt(strqty);
            }catch(Exception x){
                qtyNew = 0;
            }
            
            Vector listitem = new Vector();
            Vector listmain = new Vector();
            int i = -1;
            if(qtyNew>0){
                System.out.println("werwerwe ");
                if(vendorId.length()>0){
					if(strLastprice==""){
						strLastprice="0";
					}
					
					System.out.println("\n\nstrLastprice : "+strLastprice);
					
					strLastprice = removeComma(strLastprice);
					
					System.out.println("\n\nstrLastprice : "+strLastprice);
					
                    lastprice = Double.parseDouble(strLastprice);
					vendorId = vendorId.substring(vendorId.lastIndexOf("-")+1,vendorId.length()); 
                    i = checkPO(list,Long.parseLong(vendorId));
                    
                    if(i != -1){
                            if(list.size()>0){
                                System.out.println("werwerwe 88888");
                                listmain = (Vector)list.get(i);
                                }else{
                                    listmain = new Vector();
                                }
                        }
                    
                    System.out.println("werwerwe 423423423");
                    if(listmain.size()>0){
                        listitem = (Vector)listmain.get(1);
                    }else{
                        Purchase purchase = new Purchase();
                        purchase.setVendorId(Long.parseLong(vendorId));
                        //purchase.setLocationId(purchaseRequest.getLocationId());
                        purchase.setPurchDate(new Date());
                        int ctr = DbPurchase.getNextCounter();
                        purchase.setCounter(ctr);
						
						String currCode = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
						Currency c = DbCurrency.getCurrencyByCode(currCode);
                        
						purchase.setCurrencyId(c.getOID());
                        purchase.setPrefixNumber(DbPurchase.getNumberPrefix());
                        purchase.setNumber(DbPurchase.getNextNumber(ctr));
                        purchase.setStatus(I_Project.DOC_STATUS_DRAFT);
                                
                        listmain.add(purchase);
                        listmain.add(new Vector());
                        
                        //i = (listmain.size()-1);
                    }                    
                }
                PurchaseItem purchaseItem = new PurchaseItem();
                purchaseItem.setQty(qtyNew);
                purchaseItem.setItemMasterId(pr.getItemMasterId());
                purchaseItem.setAmount(lastprice);
                purchaseItem.setTotalAmount(lastprice * purchaseItem.getQty());
                purchaseItem.setTotalDiscount(0);
                purchaseItem.setUomId(pr.getUomId());
                //purchaseItem.setStatus(I_Project.DOC_STATUS_DRAFT);
                purchaseItem.setDeliveryDate(new Date());
                
                //System.out.println("werwerwe 423423423000000000");
                
                listitem.add(purchaseItem);
                listmain.setElementAt(listitem,1);  
                     
                //System.out.println("werwerwe 42342342300000000088888888888");
                // set to global vector
                if(i !=-1){
                    list.setElementAt(listmain,i);
                    }else{
                        list.add(listmain);
                    }
                
                // update pr item
                try{
                    pr.setProcessQty(pr.getProcessQty() + qtyNew);
                    pr.setItemStatus(Integer.parseInt(itemStatus));                    
                    DbPurchaseRequestItem.updateExc(pr);
                }catch(Exception xx){}
                
                // cek status pr
            }
        }
		
        Vector listresult = new Vector();
	   	if(list.size()>0){
			listresult = SessRequest.insertDataPrToPo(list,appSessUser.getUserOID(),oidPurchaseRequest);
			try{
					session.putValue("sess_result",listresult);
				}catch(Exception xxx){}
				
			response.sendRedirect("purchaseprtopo.jsp?menu_idx=1");
		}
    }
}

//update status item
// proses simpan
if(iJSPCommand==JSPCommand.SUBMIT){
    //Hashtable hashtable = new Hashtable();
    Vector list = new Vector();
    if(purchReqItems.size()>0){
        for(int h=0;h<purchReqItems.size();h++){
            PurchaseRequestItem pr = (PurchaseRequestItem)purchReqItems.get(h);
            
            String[] item_status = null;
            String itemStatus = "";
            if(purchReqItems.size()>1){
                item_status = request.getParameterValues("item_status");
                itemStatus = item_status[h];  
            }else{
                itemStatus = request.getParameter("item_status");
            }
			    
            pr.setItemStatus(Integer.parseInt(itemStatus));
			
			try{
				DbPurchaseRequestItem.updateExc(pr);
			}
			catch(Exception e){
			}
		}	
		
		/*Vector listresult = new Vector();
		if(list.size()>0){
			listresult = SessRequest.insertDataPrToPo(list,appSessUser.getUserOID(),oidPurchaseRequest);
			try{
				session.putValue("sess_result",listresult);
			}catch(Exception xxx){}
				
			response.sendRedirect("purchaseprtopo.jsp?menu_idx=1");
		}
		*/
			
    }
}

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

<!--
<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

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

function calPriceX(a, qty, proc){
	valvdr = document.frmpurchaserequest.selectvendor[a].value;
	//alert("valvdr : "+valvdr);
	lastprice = valvdr.substring(0,valvdr.lastIndexOf("-"));
	//alert("lastprice : "+lastprice);
	lastprice = removeChar(lastprice);
	lastprice = cleanNumberFloat(lastprice, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmpurchaserequest.txt_last_price[a].value=formatFloat(''+parseFloat(lastprice), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	qtynew = document.frmpurchaserequest.txtqty_new_po[a].value;
		
	qtynew = removeChar(qtynew);
	qtynew = cleanNumberFloat(qtynew, sysDecSymbol, usrDigitGroup, usrDecSymbol);

	//alert("qtynew : "+qtynew);
	
	if(qtynew==""){
		qtynew = "0";
	}
	else{
		if(parseFloat(qtynew)>(parseFloat(qty)-parseFloat(proc))){
			alert("the quantity is more than maximum quantity that is allowed, \ndata will be reset to 0(zero) ..");
			qtynew = "0";
		}
	}
	
	document.frmpurchaserequest.txtqty_new_po[a].value = qtynew;
}

function calPrice(a, qty, proc){
    <%
    if(purchReqItems.size()>1){
    %>
		valvdr = document.frmpurchaserequest.selectvendor[a].value;
        //alert(valvdr.substring(valvdr.lastIndexOf("-"),valvdr.length()));
        
		lastprice = valvdr.substring(0,valvdr.lastIndexOf("-"))
        qtynew = document.frmpurchaserequest.txtqty_new_po[a].value;
		
		qtynew = removeChar(qtynew);
		qtynew = cleanNumberFloat(qtynew, sysDecSymbol, usrDigitGroup, usrDecSymbol);

		//alert("qtynew : "+qtynew);
		
		if(qtynew==""){
			qtynew = "0";
		}
		else{
			if(parseFloat(qtynew)>(parseFloat(qty)-parseFloat(proc))){
				alert("the quantity is more than maximum quantity that is allowed, \ndata will be reset to 0(zero) ..");
				qtynew = "0";
			}
		}
		
		document.frmpurchaserequest.txtqty_new_po[a].value = qtynew;
		
		var deptotal = document.frmpurchaserequest.txttotalprice.value;
		var currupdate = document.frmpurchaserequest.txt_last_price[a].value;
		
		//alert("deptotal : "+deptotal);
		//alert("currupdate : "+currupdate);
        
		document.frmpurchaserequest.txt_last_price[a].value = formatFloat(''+(parseFloat(qtynew) * parseFloat(lastprice)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        
		if(document.frmpurchaserequest.txt_last_price[a].value=='NaN'){
            document.frmpurchaserequest.txt_last_price[a].value="0";
		}
        
		totalprice = 0;
		<%
		for(int i=0;i<purchReqItems.size();i++){
			%>
			price = document.frmpurchaserequest.txt_last_price[<%=i%>].value;
			if(price=='NaN' || price=='')
				price="0";
			
			itemStatus = document.frmpurchaserequest.item_status[<%=i%>].value;
			if(itemStatus==<%=DbPurchaseRequestItem.STATUS_PENDING%>){
				totalprice = totalprice + parseFloat(price);
			}
		<%}%>
		
		var endcurrupdate = document.frmpurchaserequest.txt_last_price[a].value;
		
		deptotal = removeChar(deptotal);
		deptotal = cleanNumberFloat(deptotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		currupdate = removeChar(currupdate);
		currupdate = cleanNumberFloat(currupdate, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		endcurrupdate = removeChar(endcurrupdate);
		endcurrupdate = cleanNumberFloat(endcurrupdate, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//document.frmpurchaserequest.txttotalprice.value=formatFloat(''+totalprice, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		document.frmpurchaserequest.txttotalprice.value=formatFloat(''+(parseFloat(deptotal)-parseFloat(currupdate)+parseFloat(endcurrupdate)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            
    <%}else{%>
    
        <%if(purchReqItems.size()==1){%>
            valvdr = document.frmpurchaserequest.selectvendor.value;
            //alert(valvdr.substring(valvdr.lastIndexOf("-")+1,valvdr.length));
            lastprice = valvdr.substring(0,valvdr.lastIndexOf("-"));
            qtynew = document.frmpurchaserequest.txtqty_new_po.value;
            document.frmpurchaserequest.txt_last_price.value = formatFloat(''+(parseFloat(qtynew) * parseFloat(lastprice)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);  
            
            if(document.frmpurchaserequest.txt_last_price.value=='NaN'){                
				document.frmpurchaserequest.txt_last_price.value="0";
			}

			//totalprice = 0;
			itemStatus = document.frmpurchaserequest.item_status.value;
			price = document.frmpurchaserequest.txt_last_price.value;
				if(price=='NaN' || price=='')
					price="0";

			if(itemStatus==<%=DbPurchaseRequestItem.STATUS_PENDING%>){
				document.frmpurchaserequest.txttotalprice.value=formatFloat(''+price, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			}else{
				document.frmpurchaserequest.txttotalprice.value="0";
			}

    <%}}%>
}

function checkNumber(obj){
	var st = obj.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdChangeStatus(obj){
	//if(confirm("This action will update this purchase request item status, all update will be lost, \nare you sure ?")){
		document.frmpurchaserequest.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmpurchaserequest.action="prtopo.jsp";
		document.frmpurchaserequest.submit();
	//}
}

function cmdSave(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaserequest.action="prtopo.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdBack(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdListFirst(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListPrev(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdListNext(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListLast(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
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
//-->

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/cancel2.gif','../images/success.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpurchaserequest" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="<%=JspPurchaseRequestItem.colNames[JspPurchaseRequestItem.JSP_PURCHASE_REQUEST_ID]%>" value="<%=oidPurchaseRequest%>">
                          <input type="hidden" name="hidden_purchase_request_id" value="<%=oidPurchaseRequest%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="hidden_purchase_request_item_id" value="<%=oidPurchaseRequestItem%>">
						  
                          <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" > 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Export 
                                      PR to PO </span>&raquo; <span class="lvl2">Analysis</span></font></b></td>
                                    <td width="40%" height="23"> 
                                      <%@ include file = "../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"> 
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="20" valign="middle" width="11%" nowrap>&nbsp;<strong>Request 
                                            From </strong></td>
                                          <td height="20" valign="middle" width="32%"> 
                                            : 
                                            <%
                                                Department d = new Department();
                                                try{
                                                    d= DbDepartment.fetchExc(purchaseRequest.getDepartmentId());
                                                }catch(Exception e){}
                                              %>
                                            <%=d.getName()%></td>
                                          <td height="20" width="10%"><strong>PR 
                                            Number</strong></td>
                                          <td height="20" width="47%" class="comment"> 
                                            : <%=purchaseRequest.getNumber()%></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="20" valign="middle" width="11%">&nbsp;<strong>PR 
                                            Date</strong></td>
                                          <td height="20" valign="middle" width="32%">: 
                                            <%=JSPFormater.formatDate((purchaseRequest.getDate()==null) ? new Date() : purchaseRequest.getDate(), "dd MMM yyyy")%></td>
                                          <td width="10%" height="20"><strong>PR 
                                            Status</strong></td>
                                          <td width="47%" class="comment" height="20">: 
                                            <%=purchaseRequest.getStatus()%> 
                                        </tr>
                                        <tr align="left"> 
                                          <td height="20" width="11%">&nbsp;<strong>Notes</strong></td>
                                          <td height="20" valign="top" colspan="3">: 
                                            <%=purchaseRequest.getNote()%></td>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top" height="10"></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" class="listgen">
                                              <tr> 
                                                <td width="2%" rowspan="2" class="tablehdr" null>No</td>
                                                <td width="18%" rowspan="2" class="tablehdr" null> 
                                                  Item</td>
                                                <td width="10%" rowspan="2" class="tablehdr" null>Group/Category</td>
                                                <td colspan="4" class="tablehdr" null>Qty</td>
                                                <td width="13%" rowspan="2" class="tablehdr" null>Supplier</td>
                                                <td width="8%" rowspan="2" class="tablehdr" null>@ 
                                                  Last Price </td>
                                              </tr>
                                              <tr valign="top"> 
                                                <td width="11%" class="tablehdr" >Status</td>
                                                <td width="7%" class="tablehdr" >PR</td>
                                                <td width="7%" class="tablehdr" >Proceed</td>
                                                <td width="8%" class="tablehdr" >New 
                                                  PO </td>
                                              </tr>
                                              <%
                                              if(purchReqItems!=null && purchReqItems.size()>0){
                                                for(int k=0;k<purchReqItems.size();k++){
                                                    PurchaseRequestItem pr = (PurchaseRequestItem)purchReqItems.get(k);
                                                    ItemMaster itemMaster = new ItemMaster();
                                                    ItemGroup itemGroup = new ItemGroup();
                                                    ItemCategory itemCategory = new ItemCategory();
                                                    try{
                                                        itemMaster = DbItemMaster.fetchExc(pr.getItemMasterId());
                                                        itemGroup = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                                                        itemCategory = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                                                    }catch(Exception ee){}
                                              %>
                                              <tr> 
                                                <td class="tablecell" >&nbsp;<%=(k+1)%></td>
                                                <td class="tablecell" >&nbsp;<%=itemMaster.getName()%></td>
                                                <td class="tablecell" ><%=itemGroup.getName()%>/<br><%=itemCategory.getName()%></td>
                                                <td class="tablecell" > 
                                                  <div align="center"> 
                                                    <%if(pr.getProcessQty()>0){%>
                                                    <input type="hidden" name="item_status" value="0">
                                                    - 
                                                    <%}else{%>
                                                    <select name="item_status" onChange="javascript:cmdChangeStatus()">
                                                      <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_PENDING){%>
                                                      <option value="0">-</option>
                                                      <option <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_PENDING){%>selected<%}%> value="<%=DbPurchaseRequestItem.STATUS_PENDING%>"><%=DbPurchaseRequestItem.strItemStatus[DbPurchaseRequestItem.STATUS_PENDING]%></option>
                                                      <option <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_REFUSED){%>selected<%}%> value="<%=DbPurchaseRequestItem.STATUS_REFUSED%>"><%=DbPurchaseRequestItem.strItemStatus[DbPurchaseRequestItem.STATUS_REFUSED]%></option>
                                                      <%}else{%>
                                                      <option value="0">-</option>
                                                      <option <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_PENDING){%>selected<%}%> value="<%=DbPurchaseRequestItem.STATUS_PENDING%>"><%=DbPurchaseRequestItem.strItemStatus[DbPurchaseRequestItem.STATUS_PENDING]%></option>
                                                      <option <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_REFUSED){%>selected<%}%> value="<%=DbPurchaseRequestItem.STATUS_REFUSED%>"><%=DbPurchaseRequestItem.strItemStatus[DbPurchaseRequestItem.STATUS_REFUSED]%></option>
                                                      <%}%>
                                                    </select>
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td class="tablecell" > 
                                                  <div align="right">&nbsp;<%=pr.getQty()%></div>
                                                </td>
                                                <td class="tablecell" > 
                                                  <div align="right">&nbsp;<%=pr.getProcessQty()%></div>
                                                </td>
                                                <td class="tablecell" > 
                                                  <div align="center"> 
                                                    <input name="txtqty_new_po" type="text" size="5" onBlur="javascript:calPriceX('<%=k%>','<%=pr.getQty()%>','<%=pr.getProcessQty()%>')" <%if(pr.getItemStatus()==DbPurchaseRequestItem.STATUS_PENDING || pr.getItemStatus()==DbPurchaseRequestItem.STATUS_REFUSED){%>readOnly class="readOnly" value="0"<%}else{%>value="0"<%}%> style="text-align:right" onClick="this.select()">
                                                  </div>
                                                </td>
                                                <td class="tablecell" > 
                                                  <div align="left"> 
                                                    <select name="selectvendor" onChange="javascript:calPriceX('<%=k%>','<%=pr.getQty()%>','<%=pr.getProcessQty()%>')">
                                                      <%
													  		/* -- berdasarkan vendor list --*/
                                                            /*String where = DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+pr.getItemMasterId();
                                                            Vector listVdr = DbVendorItem.list(0,0,where,"");
                                                            if(listVdr!=null && listVdr.size()>0){
                                                                for(int j=0;j<listVdr.size();j++){
                                                                    VendorItem vdrItem = (VendorItem)listVdr.get(j);
                                                                    Vendor vdr = new Vendor();
                                                                    try{
                                                                        vdr = DbVendor.fetchExc(vdrItem.getVendorId());
                                                                    }catch(Exception e){}
															*/
															//String where = DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+pr.getItemMasterId();
                                                            Vector listVdr = DbVendor.list(0,0,"","name");
                                                            if(listVdr!=null && listVdr.size()>0){
                                                                for(int j=0;j<listVdr.size();j++){                                                                    
                                                                    Vendor vdr = (Vendor)listVdr.get(j);
                                                                    PurchaseItem pi = DbPurchaseItem.getLastPurchaseItem(vdr.getOID(), itemMaster.getOID());
																			
                                                        %>
                                                      <option value="<%=pi.getAmount()%>-<%=vdr.getOID()%>" <%if(vdr.getOID()==itemMaster.getDefaultVendorId()){%>selected<%}%>><%=vdr.getName()%></option>
                                                      <%}}%>
                                                    </select>
                                                  </div>
                                                </td>
                                                <td class="tablecell" > 
                                                  <div align="center"> 
                                                    <input name="txt_last_price" type="text" value="0.00" size="20" style="text-align:right" onClick="this.select()" onBlur="javascript:checkNumber(this)">
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}}%>
                                              <tr> 
                                                <td colspan="8" class="rightalign" height="5" ></td>
                                                <td class="rightalign" bgcolor="#CCCCCC" height="5" nowrap > 
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top" height="3" background="../images/line1.gif"></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top"> 
                                            <table width="391" border="0">
                                              <tr> 
                                                <td width="20"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('success','','../images/success.gif',1)"><img src="../images/success.gif" alt="Cancel" name="success" border="0"></a></td>
                                                <%if (!purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>
                                                <td width="104" nowrap><A href="javascript:cmdSave()"><b><u>Export 
                                                  PR to PO</u></b></A></td>
                                                <td width="10"><img src="../images/spacer.gif" width="10" height="8"></td>
                                                <%}%>
                                                <td width="239"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" alt="Cancel" name="cancel211111" height="22" border="0"></a></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" valign="top">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <%
							}catch(Exception e){
								out.println(e.toString());
							}%>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable --> </td>
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

