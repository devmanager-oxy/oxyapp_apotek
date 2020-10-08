<% 
/*******************************************************************
 *  eka
 *******************************************************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
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
public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly){	
		
		System.out.println("in recursif : "+coa.getOID());
		
		String result = "";
		if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
			
			System.out.println("not postable ...");
			
			Vector coas = DbCoa.list(0,0, "acc_ref_id="+coa.getOID(), "code");
			
			System.out.println(coas);
			
			if(coas!=null && coas.size()>0){
				for(int i=0; i<coas.size(); i++){
					
					Coa coax = (Coa)coas.get(i);												
					String str = "";
													
					if(!isPostableOnly){
						switch(coax.getLevel()){
							case 1 : 											
								break;
							case 2 : 
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 3 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 4 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 5 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;				
						}
					}
					
					result = result + "<option value=\""+coax.getOID()+"\""+((oid==coax.getOID()) ? "selected" : "")+">"+str+coax.getCode()+" - "+coax.getName()+"</option>";
					
					if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
						result = result + getAccountRecursif(coax, oid, isPostableOnly);
					}
					
					
				}
			}
		}
		
		return result;
	}
%>
<%
boolean purchasePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_NEWORDER);
%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long oidPurchase = JSPRequestValue.requestLong(request, "hidden_purchase_id");

//out.println("oidPurchase : "+oidPurchase);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

Purchase purchase = new Purchase();
try{
	purchase = DbPurchase.fetchExc(oidPurchase);
}
catch(Exception e){
}

Vendor vendor = new Vendor();
try{
	vendor = DbVendor.fetchExc(purchase.getVendorId());
}
catch(Exception e){
}

Vector itemlist = DbPurchaseItem.list(0,0, "purchase_id = "+purchase.getOID(), "");

//out.println(itemlist);

Vector deps = DbDepartment.list(0,0, "", "");

if(iJSPCommand==JSPCommand.SUBMIT){
	
	long coaCreditId = JSPRequestValue.requestLong(request, "coa_credit_id");

	//Vector result = new Vector();
	for(int i=0; i<itemlist.size(); i++){
		//Vector temp = new Vector();
		PurchaseItem pi = (PurchaseItem)itemlist.get(i);
		double discount = pi.getTotalAmount() * purchase.getDiscountPercent()/100;
		double tax = (pi.getTotalAmount() - discount) * purchase.getVatPercent()/100;
		double total = pi.getTotalAmount()-discount+tax;
		
		DbPurchaseItemShare.deleteItemByPurchaseItemId(pi.getOID());
		
		if(deps!=null && deps.size()>0){
			for(int x=0; x<deps.size(); x++){
				Department dep = (Department)deps.get(x);	
				double am = JSPRequestValue.requestDouble(request, pi.getOID()+"_"+dep.getOID());
				if(am>0){
					PurchaseItemShare pis = new PurchaseItemShare();
					pis.setPurchaseId(purchase.getOID());
					pis.setPurchaseItemId(pi.getOID());
					pis.setHotelRoomId(dep.getOID());
					pis.setCoaId(JSPRequestValue.requestLong(request, "select_"+pi.getOID()+"_"+dep.getOID()));
					pis.setAmount(am);
					pis.setTotalAmount(total);
					pis.setCoaCreditId(coaCreditId);
					pis.setDate(new Date());
					//temp.add(pis);
					
					try{
						DbPurchaseItemShare.insertExc(pis);
					}
					catch(Exception e){
					}
				}
			}		
		}
		
		//result.add(temp);
	}
	
	DbPurchaseItemShare.postJournal(purchase);
	
	purchase.setStatus("CLOSED");
	try{
		DbPurchase.updateExc(purchase);	
	}
	catch(Exception e){
	}
	
}

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_HOTEL_POLIO_PAYMENT_DEBET+"'", "");

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--

<%if(iJSPCommand==JSPCommand.SUBMIT){%>
	window.location="purchaseitem_allocinfo.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";


function cmdPostJurnal(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="purchaseitem_alloc.jsp";
	document.form1.submit();
}

function cmdUpdateVal(oid, valx){
	
	//alert("oid :"+oid);
	//alert("oid1 :"+oid1);
	
	var temp = document.form1.temp.value;
	temp = cleanNumberFloat(temp, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	//alert("temp : "+temp);	
	
	var currVal = valx.value;
	currVal = cleanNumberFloat(currVal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("new val : "+currVal);
	
	//total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	//document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) + parseFloat(balidr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	<%
	for(int x = 0; x<itemlist.size(); x++){
		PurchaseItem pi = (PurchaseItem)itemlist.get(x);		
	%>	
		if(oid=='<%=pi.getOID()%>'){
			var subtot = document.form1.sub_total<%=pi.getOID()%>.value;
			subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			
			//alert("subtot before : "+subtot);
			
			subtot = parseFloat(subtot) - parseFloat(temp) + parseFloat(currVal);
			//alert("subtot after : "+subtot);
			document.form1.sub_total<%=pi.getOID()%>.value = formatFloat(subtot, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}
	<%
	}%>
		
}

function cmdClickSaja(valx){
	document.form1.temp.value=valx.value;
}

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><%
					  String navigator = "<font class=\"lvl1\">Purchase</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Cost Allocation</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="temp">
						  <input type="hidden" name="hidden_purchase_id" value="<%=oidPurchase%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Vendor</b></td>
                                    <td width="21%"><%=vendor.getName()%></td>
                                    <td width="7%"><b>Date</b></td>
                                    <td width="61%"><%=JSPFormater.formatDate(purchase.getDate(), "dd/MM/yyyy")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Address</b></td>
                                    <td width="21%"><%=vendor.getAddress()%></td>
                                    <td width="7%"><b>Number</b></td>
                                    <td width="61%"><%=purchase.getJournalNumber()%></td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%" height="14"><b>Amount</b></td>
                                    <td width="21%" height="14"><%=JSPFormater.formatNumber(purchase.getTotal(), "#,###.##")%></td>
                                    <td width="7%" height="14">&nbsp;</td>
                                    <td width="61%" height="14">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Discount (</b><%=purchase.getDiscountPercent()%>%<b>)</b></td>
                                    <td width="21%"><%=JSPFormater.formatNumber(purchase.getDiscount(), "#,###.##")%></td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Tax (</b><%=purchase.getVatPercent()%>%<b>)</b></td>
                                    <td width="21%"><%=JSPFormater.formatNumber(purchase.getVatAmount(), "#,###.##")%></td>
                                    <td width="7%"><b></b></td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Grand Total</b></td>
                                    <td width="21%"><%=JSPFormater.formatNumber(purchase.getTotal()-purchase.getDiscount()+purchase.getVatAmount(), "#,###.##")%></td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%"><b>Payment By</b></td>
                                    <td width="21%"> 
                                      <select name="coa_credit_id">
                                        <%if(accLinks!=null && accLinks.size()>0){
										  for(int i=0; i<accLinks.size(); i++){
										  		AccLink accLink = (AccLink)accLinks.get(i);
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(accLink.getCoaId());
												}
												catch(Exception e){
												}
										  %>
                                        <option <%if(0==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                        <%=getAccountRecursif(coa, 0, true)%> 
                                        <%}}else{%>
                                        <option>select ..</option>
                                        <%}%>
                                      </select>
                                      </td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="17%">Item 
                                            Description</td>
                                          <td class="tablehdr" width="9%">Amount</td>
                                          <td class="tablehdr" width="8%">Discount</td>
                                          <td class="tablehdr" width="7%">Tax</td>
                                          <td class="tablehdr" width="11%">Total 
                                            Amount</td>
                                          <td class="tablehdr" width="48%">Allocation</td>
                                        </tr>
                                        <%if(itemlist!=null && itemlist.size()>0){
											double grandTot = 0;
											for(int i=0; i<itemlist.size(); i++){
												PurchaseItem pi = (PurchaseItem)itemlist.get(i);
												double discount = pi.getTotalAmount() * purchase.getDiscountPercent()/100;
												double tax = (pi.getTotalAmount() - discount) * purchase.getVatPercent()/100;
												double total = pi.getTotalAmount()-discount+tax;
												grandTot = grandTot + total;
										%>
                                        <tr> 
                                          <td class="tablecell" width="17%" valign="top"><%=pi.getItemName()%></td>
                                          <td class="tablecell" width="9%" valign="top"> 
                                            <div align="right"><%=JSPFormater.formatNumber(pi.getTotalAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="8%" valign="top"> 
                                            <div align="right"><%=JSPFormater.formatNumber(discount, "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="7%" valign="top"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tax, "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="11%" valign="top"> 
                                            <div align="right"><%=JSPFormater.formatNumber(total, "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="48%"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td class="tablecell1" width="30%"> 
                                                  <div align="center"><b>Room</b></div>
                                                </td>
                                                <td class="tablecell1" width="17%"> 
                                                  <div align="center"><b>Alloc. 
                                                    Amount</b></div>
                                                </td>
                                                <td class="tablecell1" width="42%"> 
                                                  <div align="center"><b>Cost 
                                                    Account</b></div>
                                                </td>
                                              </tr>
                                              <%if(deps!=null && deps.size()>0){
											  
											  double defaultVal = total/deps.size();
											  defaultVal = Double.parseDouble(JSPFormater.formatNumber(defaultVal, "###.##"));
											  double subTotal = 0;
											  
											  for(int x=0; x<deps.size(); x++){
											  	Department dep = (Department)deps.get(x);
												subTotal = subTotal + defaultVal;
											  %>
                                              <tr> 
                                                <td width="30%"><%=dep.getName()%></td>
                                                <td width="17%"> 
                                                  <input type="text" name="<%=pi.getOID()%>_<%=dep.getOID()%>" size="20" onChange="javascript:cmdUpdateVal('<%=pi.getOID()%>',this)" value="<%=JSPFormater.formatNumber(defaultVal, "#,###.##")%>" style="text-align:right" onClick="javascript:cmdClickSaja(this)">
                                                </td>
                                                <td width="42%"> 
                                                  <%
												Vector coas = DbCoa.list(0,0, "department_id="+dep.getOID()+" and status='POSTABLE' and account_group='expense'", "");
												%>
                                                  <select name="select_<%=pi.getOID()%>_<%=dep.getOID()%>">
                                                    <%if(coas!=null && coas.size()>0){
														for(int xx=0; xx<coas.size(); xx++){
															Coa coa = (Coa)coas.get(xx);
													%>
                                                    <option value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="30%"> 
                                                  <div align="center"><b>Sub Total</b></div>
                                                </td>
                                                <td width="17%"> 
                                                  <input type="text" name="sub_total<%=pi.getOID()%>" size="20" value="<%=JSPFormater.formatNumber(subTotal,"#,###.##")%>" style="text-align:right">
                                                </td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td colspan="6" height="5"></td>
                                        </tr>
                                        <tr bgcolor="#CCCCCC"> 
                                          <td colspan="4"> 
                                            <div align="right"><b>GRAND TOTAL 
                                              : </b></div>
                                          </td>
                                          <td width="11%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(grandTot, "#,###.##")%></div>
                                          </td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="17%"><a href="javascript:cmdPostJurnal()"><img src="../images/post_journal.gif" width="92" height="22" border="0"></a></td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="17%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="17%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="17%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="17%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="17%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="7%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="11%">&nbsp;</td>
                                    <td width="21%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="61%">&nbsp;</td>
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
