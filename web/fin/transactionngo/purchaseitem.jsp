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
<%
boolean purchasePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_NEWORDER);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspPurchaseItem frmObject, PurchaseItem objEntity, Vector objectClass,  long purchaseItemId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Purchase Id","14%");
		ctrlist.addHeader("Item Name","14%");
		ctrlist.addHeader("Qty","14%");
		ctrlist.addHeader("Price","14%");
		ctrlist.addHeader("Total Amount","14%");
		ctrlist.addHeader("Discount","14%");
		ctrlist.addHeader("Coa Id","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected CoaId*/
		Vector coaid_value = new Vector(1,1);
		Vector coaid_key = new Vector(1,1);
		coaid_value.add("");
		coaid_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 PurchaseItem purchaseItem = (PurchaseItem)objectClass.get(i);
			 rowx = new Vector();
			 if(purchaseItemId == purchaseItem.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_PURCHASE_ID] +"\" value=\""+purchaseItem.getPurchaseId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_ITEM_NAME] +"\" value=\""+purchaseItem.getItemName()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_QTY] +"\" value=\""+purchaseItem.getQty()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_PRICE] +"\" value=\""+purchaseItem.getPrice()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_AMOUNT] +"\" value=\""+purchaseItem.getTotalAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_DISCOUNT] +"\" value=\""+purchaseItem.getDiscount()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_COA_ID],null, ""+purchaseItem.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(purchaseItem.getOID())+"')\">"+String.valueOf(purchaseItem.getPurchaseId())+"</a>");
				rowx.add(purchaseItem.getItemName());
				rowx.add(String.valueOf(purchaseItem.getQty()));
				rowx.add(String.valueOf(purchaseItem.getPrice()));
				rowx.add(String.valueOf(purchaseItem.getTotalAmount()));
				rowx.add(String.valueOf(purchaseItem.getDiscount()));
				rowx.add(String.valueOf(purchaseItem.getCoaId()));
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_PURCHASE_ID] +"\" value=\""+objEntity.getPurchaseId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_ITEM_NAME] +"\" value=\""+objEntity.getItemName()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_PRICE] +"\" value=\""+objEntity.getPrice()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_AMOUNT] +"\" value=\""+objEntity.getTotalAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_DISCOUNT] +"\" value=\""+objEntity.getDiscount()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_COA_ID],null, ""+objEntity.getCoaId(), coaid_value , coaid_key, "formElemen", ""));

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int iJSPMainCommand = JSPRequestValue.requestInt(request, "main_command");
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchase = JSPRequestValue.requestLong(request, "hidden_purchase_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
long xxx = JSPRequestValue.requestLong(request, "xxx");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPurchase ctrlPurchase = new CmdPurchase(request);
JSPLine ctrLine = new JSPLine();
Vector listPurchase = new Vector(1,1);

/*switch statement */
int iErrCodeMain = ctrlPurchase.action(iJSPMainCommand , oidPurchase);
/* end switch*/
JspPurchase jspPurchase = ctrlPurchase.getForm();

//out.println(jspPurchase.getErrors());

/*count list All Purchase*/
//int vectSize = DbPurchase.getCount(whereClause);

Purchase purchase = ctrlPurchase.getPurchase();
String msgStringMain =  ctrlPurchase.getMessage();

if(oidPurchase==0){
	oidPurchase = purchase.getOID();
}

//out.println("jspPurchase : "+jspPurchase.getErrors());


%>
<%

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}

//out.println("<br>iJSPCommand : "+iJSPCommand);

long oidPurchaseItem = JSPRequestValue.requestLong(request, "hidden_purchase_item_id");

/*variable declaration*/

CmdPurchaseItem ctrlPurchaseItem = new CmdPurchaseItem(request);

Vector listPurchaseItem = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPurchaseItem.action(iJSPCommand , oidPurchaseItem, purchase.getOID());
/* end switch*/
JspPurchaseItem jspPurchaseItem = ctrlPurchaseItem.getForm();

//out.println("jspPurchaseItem : "+jspPurchaseItem.getErrors());

/*count list All PurchaseItem*/
int vectSize = DbPurchaseItem.getCount(whereClause);

PurchaseItem purchaseItem = ctrlPurchaseItem.getPurchaseItem();
msgString =  ctrlPurchaseItem.getMessage();

/* get record to display */
if(purchase.getOID()!=0){
	listPurchaseItem = DbPurchaseItem.list(0,0, "purchase_id="+purchase.getOID() , orderClause);
}

//out.println("<br>jspPurchaseItem : "+jspPurchaseItem.getErrors());
//out.println("<br>listPurchaseItem : "+listPurchaseItem);

//out.println("<br>oidPurchase : "+oidPurchase);
//out.println("<br>oidPurchaseItem : "+oidPurchaseItem);
//out.println("msgString : "+msgString);


Vector vendors = DbVendor.list(0,0, "", "");
Vector currencies = DbCurrency.list(0,0, "", "");
Vector shipAddresses = DbShipAddress.list(0,0, "", "");
Vector terms = DbTermOfPayment.list(0,0, "", "");
Vector types = DbItemType.list(0,0, "", "");

Vector incomeCoas = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_INVENTORY+"' or type='"+I_Project.ACC_LINK_GROUP_NON_INVENTORY+"'", "");//DbCoa.list(0,0, "", "code");

if(iJSPCommand==JSPCommand.PRINT){
	//out.println("xxx : "+xxx);
	//out.println("xxx : "+xxx);
	purchase.setVendorId(xxx);	
	/*if(iErrCode==0 && iErrCodeMain==0){
		iJSPCommand = JSPCommand.ADD;
	}
	else{
		iJSPCommand = JSPCommand.SUBMIT;
	}*/
	iJSPCommand = JSPCommand.ADD;
	recIdx = -1;
	purchaseItem = new PurchaseItem();
}


if(iJSPCommand==JSPCommand.SAVE && iErrCode==0){
	iJSPCommand = JSPCommand.ADD;
	purchaseItem = new PurchaseItem();
	recIdx = -1;
}

String whereDep = "";
//if(isPostableOnly){
//	whereDep = "level="+sysCompany.getDepartmentLevel();
//}
Vector deps = DbDepartment.list(0,0, whereDep, "code");


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!purchasePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdDepartment(){
	var oid = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DEPARTMENT_ID]%>.value;
	<%if(deps!=null && deps.size()>0){
		for(int i=0; i<deps.size(); i++){
			Department d = (Department)deps.get(i);
	%>
			if(oid=='<%=d.getOID()%>'){
				<%if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
					Department d0 = (Department)deps.get(0);
				%>
					alert("Non postable department\nplease select another department");
					document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
				<%}%>
			}
	<%}}%>
}


function cmdSaveDoc(){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.POST%>";
	document.frmpurchaseitem.command.value="<%=JSPCommand.POST%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdPrintJournal(){ 
	window.open("<%=printroot%>.report.RptPurchasePDF?oid=<%=appSessUser.getLoginId()%>&po_id=<%=oidPurchase%>");
}

function cmdNewVendor(){
	window.open("vendor.jsp?command=<%=JSPCommand.ADD%>&return_page=1","addvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
}

function cmdEditVendor(){
	var oid = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VENDOR_ID]%>.value;
	window.open("vendor.jsp?command=<%=JSPCommand.EDIT%>&return_page=1&hidden_vendor_id="+oid,"editvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
}

function cmdUpdateType(){
	/*var type = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_ITEM_TYPE]%>.value;
	if(type=='<%=I_Project.ACC_LINK_GROUP_INVENTORY%>'){
		document.all.invacc.style.display="";
		document.all.noninvacc.style.display="none";
	}
	else{
		if(type=='<%=I_Project.ACC_LINK_GROUP_NON_INVENTORY%>'){
			document.all.invacc.style.display="none";
			document.all.noninvacc.style.display="";
		}		
	}
	*/
}

function cmdVendor(){
	var oid = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VENDOR_ID]%>.value;
	var found = false;
	<%if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor vx = (Vendor)vendors.get(i);
			%>
			if('<%=vx.getOID()%>'==oid){
				found = true;
				document.frmpurchaseitem.vnd_address.value="<%=vx.getAddress()+((vx.getCity().length()>0) ? ", "+ vx.getCity() : "") +((vx.getState().length()>0) ? ", "+ vx.getState() : "") %>";
			}
	<%}}%>		
	if(!found){
		document.frmpurchaseitem.vnd_address.value="";
	}
}

function cmdShip(){
	var oid = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_SHIP_ADDRESS_ID]%>.value;
	var found = false;
	<%if(shipAddresses!=null && shipAddresses.size()>0){
		for(int i=0; i<shipAddresses.size(); i++){
			ShipAddress vx = (ShipAddress)shipAddresses.get(i);
			%>
			if('<%=vx.getOID()%>'==oid){
				found = true;
				document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_SHIP_ADDRESS]%>.value="<%=vx.getAddress()%>";
			}
	<%}}%>		
	if(!found){
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_SHIP_ADDRESS]%>.value="";
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

function cmdUpdatePrice(){

	var qty = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_QTY]%>.value;
	var price = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_PRICE]%>.value;
	var disc = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DISCOUNT]%>.value;
	var totalx = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_TOTAL_AMOUNT]%>.value;
	
	//alert("qty : "+qty+", pricce : "+price+", disc : "+disc+", totalx : "+totalx);
	
	if(qty!=""){
		//alert('in not blank');
		qty = removeChar(qty);	
		qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		if(isNaN(qty)){
			qty = "0.00";
		}
	}
	else{
		qty = "0.00";
	}
	//alert("qty : "+qty);
	
	document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_QTY]%>.value = formatFloat(qty, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	if(price!=""){
		price = removeChar(price);	
		price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		if(isNaN(price)){
			price = "0.00";
		}
	}
	else{
		price = "0.00";
	}
	document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_PRICE]%>.value = formatFloat(price, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 

	if(disc!=""){	
		disc = removeChar(disc);	
		disc = cleanNumberFloat(disc, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		if(isNaN(disc)){
			disc = "0.00";
		}
	}
	else{
		disc = "0.00";
	}
	//alert("qty : "+qty);
	
	document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DISCOUNT]%>.value = formatFloat(disc, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat((parseFloat(qty)*parseFloat(price))-(parseFloat(disc)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	//-------------
	
	var subtotal = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_TOTAL]%>.value;
	subtotal = removeChar(subtotal);	
	subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	totalx = removeChar(totalx);	
	totalx = cleanNumberFloat(totalx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var nowTotal = document.frmpurchaseitem.<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_TOTAL_AMOUNT]%>.value;
	nowTotal = removeChar(nowTotal);	
	nowTotal = cleanNumberFloat(nowTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	subtotal = parseFloat(subtotal) - parseFloat(totalx) + parseFloat(nowTotal);
	
	document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_TOTAL]%>.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	//----------
	
	var discount = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value;
	//discount = discount.trim();
	
	//alert("x"+discount+"x");
	//alert("isNaN(discount) : "+isNaN(discount));
	
	if(discount.length>0 && discount!=" "){
		//alert('panjang');			
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		discount = (subtotal * parseFloat(discount))/100;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT]%>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	else{
		//alert('kosong');
		discount = 0;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value="0.00";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT]%>.value="0.00";
	}
	
	
	var vat = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value;
	
	if(vat.length>0 && vat!=" "){
		vat = removeChar(vat);			
		vat = cleanNumberFloat(vat, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		vat = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		vat = ((subtotal - discount) * parseFloat(vat))/100;		
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	else{
		vat = 0;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value = "0.00";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value = "0.00";//formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	
	
	//------------
	
	var grandTotal = subtotal - discount + vat;
	document.frmpurchaseitem.grand_total.value = formatFloat(grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}


function cmdUpdateDiscount(){

	var subtotal = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_TOTAL]%>.value;
	subtotal = removeChar(subtotal);	
	subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	
	var discount = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value;
	//discount = discount.trim();
	
	//alert("x"+discount+"x");
	//alert("isNaN(discount) : "+isNaN(discount));
	
	if(discount.length>0 && discount!=" "){
		//alert('panjang');			
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		discount = (subtotal * parseFloat(discount))/100;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT]%>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	else{
		//alert('kosong');
		discount = 0;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>.value="0.00";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT]%>.value="0.00";
	}
	
	
	var vat = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value;
	
	if(vat.length>0 && vat!=" "){
		vat = removeChar(vat);			
		vat = cleanNumberFloat(vat, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		vat = document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		vat = ((subtotal - discount) * parseFloat(vat))/100;		
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	else{
		vat = 0;
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value = "0.00";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value = "0.00";//formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	
	
	//------------
	
	var grandTotal = subtotal - discount + vat;
	document.frmpurchaseitem.grand_total.value = formatFloat(grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}

function cmdCheckIt(){
	if(document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT]%>.checked){
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value="0.00";
		//document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.disabled=true;
	}
	else{
		//alert('0');
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.value="0.00";
		document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>.value="0.00";
		//document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>.disabled=true;
	}
	
	//cmdUpdatePrice();
	cmdUpdateDiscount();
} 

function cmdNew(){
	document.frmpurchaseitem.hidden_purchase_item_id.value="0";	
	document.frmpurchaseitem.hidden_purchase_id.value="0";	
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.ADD%>";
	document.frmpurchaseitem.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdAdd(){
	document.frmpurchaseitem.hidden_purchase_item_id.value="0";	
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdAsk(oidPurchaseItem){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchaseitem.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdConfirmDelete(oidPurchaseItem){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchaseitem.command.value="<%=JSPCommand.DELETE%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdSave(){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaseitem.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdEdit(oidPurchaseItem){	
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchaseitem.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdCancel(oidPurchaseItem){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchaseitem.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdBack(){
	document.frmpurchaseitem.main_command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaseitem.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdListFirst(){
	document.frmpurchaseitem.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaseitem.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdListPrev(){
	document.frmpurchaseitem.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaseitem.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdListNext(){
	document.frmpurchaseitem.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaseitem.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

function cmdListLast(){
	document.frmpurchaseitem.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaseitem.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaseitem.action="purchaseitem.jsp";
	document.frmpurchaseitem.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidPurchaseItem){
	document.frmimage.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="purchaseitem.jsp";
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

</script>
<script language="JavaScript">
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/add2.gif','../images/print2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Purchase</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">New Order</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpurchaseitem" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
						  <input type="hidden" name="main_command" value="<%=iJSPMainCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
						  <input type="hidden" name="hidden_purchase_id" value="<%=oidPurchase%>">
                          <input type="hidden" name="hidden_purchase_item_id" value="<%=oidPurchaseItem%>">
						  <input type="hidden" name="<%=jspPurchase.colNames[jspPurchase.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="return_page" value="">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container" > 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="31%">&nbsp;</td>
                                          <td width="32%">&nbsp;</td>
                                          <td width="37%"> 
                                            <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                              : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspPurchase.getErrorMsg(jspPurchase.JSP_OPERATOR_ID) %>&nbsp;</div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="top" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%"><a href="javascript:cmdEditVendor()"><b>VENDOR</b></a></td>
                                          <td colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="13%"> 
                                                  <select name="<%=jspPurchase.colNames[jspPurchase.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                    <option value="0">- Select 
                                                    -</option>
                                                    <%if(vendors!=null && vendors.size()>0){
											  		for(int i=0; i<vendors.size(); i++){
														Vendor vx = (Vendor)vendors.get(i);
											  %>
                                                    <option value="<%=vx.getOID()%>" <%if(vx.getOID()==purchase.getVendorId()){%>selected<%}%>><%=vx.getCode()%> - <%=vx.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                  <%= jspPurchase.getErrorMsg(jspPurchase.JSP_VENDOR_ID) %> </td>
                                                <td width="1%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                <td width="20%"><a href="javascript:cmdNewVendor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new12','','../images/add2.gif',1)"><img src="../images/add.gif" name="new12" width="49" height="22" border="0"></a></td>
                                                <td width="66%"> 
                                                  <input type="hidden" name="xxx" value="<%=xxx%>">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td colspan="3"><b><i> 
                                            <textarea name="vnd_address" cols="50" rows="3" class="readonly" readOnly>Vendor address ..</textarea>
                                            </i></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="5"></td>
                                          <td colspan="3" height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="22">PO Currency</td>
                                          <td width="35%" height="22"> 
                                            <select name="<%=jspPurchase.colNames[jspPurchase.JSP_CURRENCY_ID]%>">
                                              <%if(currencies!=null && currencies.size()>0){
											  		for(int i=0; i<currencies.size(); i++){
														Currency vx = (Currency)currencies.get(i);
											  %>
                                              <option value="<%=vx.getOID()%>" <%if(vx.getOID()==purchase.getCurrencyId()){%>selected<%}%>><%=vx.getCurrencyCode()%></option>
                                              <%}}%>
                                            </select>
                                            <%= jspPurchase.getErrorMsg(jspPurchase.JSP_CURRENCY_ID) %> </td>
                                          <td width="11%" height="22">Purchase 
                                            Number</td>
                                          <td width="44%" height="22"> 
                                            <%
											  int counter = DbPurchase.getNextCounter();
											  String strNumber = DbPurchase.getNextNumber(counter);
											  
											  if(purchase.getOID()!=0){
													strNumber = purchase.getJournalNumber();
											  }
											  
											  %>
                                            <%=strNumber%> 
                                            <input type="hidden" name="<%=JspPurchase.colNames[JspPurchase.JSP_JOURNAL_NUMBER]%>">
                                            <input type="hidden" name="<%=JspPurchase.colNames[JspPurchase.JSP_JOURNAL_COUNTER]%>">
                                            <input type="hidden" name="<%=JspPurchase.colNames[JspPurchase.JSP_JOURNAL_PREFIX]%>">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="22">Deliver 
                                            To</td>
                                          <td width="35%" height="22"><b><i> 
                                            <select name="<%=jspPurchase.colNames[jspPurchase.JSP_SHIP_ADDRESS_ID]%>" onChange="javascript:cmdShip()">
                                              <%if(shipAddresses!=null && shipAddresses.size()>0){
											  		for(int i=0; i<shipAddresses.size(); i++){
														ShipAddress vx = (ShipAddress)shipAddresses.get(i);
											  %>
                                              <option  value="<%=vx.getOID()%>" <%if(vx.getOID()==purchase.getShipAddressId()){%>selected<%}%>><%=vx.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%= jspPurchase.getErrorMsg(jspPurchase.JSP_SHIP_ADDRESS_ID) %> </i></b></td>
                                          <td width="11%" height="22">Transaction 
                                            Date</td>
                                          <td width="44%" height="22"> 
                                            <input name="<%=jspPurchase.colNames[jspPurchase.JSP_TRANS_DATE]%>" value="<%=JSPFormater.formatDate((purchase.getTransDate()==null) ? new Date() : purchase.getTransDate(), "dd/MM/yyyy")%>" size="11" readOnly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpurchaseitem.<%=jspPurchase.colNames[jspPurchase.JSP_TRANS_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            <%= jspPurchase.getErrorMsg(jspPurchase.JSP_TRANS_DATE) %> </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="22">&nbsp;</td>
                                          <td rowspan="2" width="35%" height="22"> 
                                            <textarea name="<%=jspPurchase.colNames[jspPurchase.JSP_SHIP_ADDRESS]%>" cols="50" readonly="readOnly" rows="3" class="readonly"><%=purchase.getShipAddress()%></textarea>
                                          </td>
                                          <td width="11%" height="22">Term Of 
                                            Payment</td>
                                          <td width="44%" valign="top" height="22"><b><i> 
                                            <select name="<%=jspPurchase.colNames[jspPurchase.JSP_TERM_OF_PAYMENT_ID]%>">
                                              <%if(terms!=null && terms.size()>0){
											  		for(int i=0; i<terms.size(); i++){
														TermOfPayment vx = (TermOfPayment)terms.get(i);
											  %>
                                              <option value="<%=vx.getOID()%>" <%if(vx.getOID()==purchase.getTermOfPaymentId()){%>selected<%}%>><%=vx.getDescription()%></option>
                                              <%}}%>
                                            </select>
                                            <%= jspPurchase.getErrorMsg(jspPurchase.JSP_TERM_OF_PAYMENT_ID) %></i></b> </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="22">&nbsp;</td>
                                          <td width="11%" height="22">Apply VAT</td>
                                          <td width="44%" valign="top" height="22"> 
                                            <input type="checkbox" name="<%=jspPurchase.colNames[jspPurchase.JSP_VAT] %>" value="1" <%if(purchase.getVat()==1){%>checked<%}%> onClick="javascript:cmdCheckIt()">
                                            Yes </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="5"></td>
                                          <td colspan="3" height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Memo</td>
                                          <td colspan="3"> 
                                            <textarea name="<%=jspPurchase.colNames[jspPurchase.JSP_MEMO] %>" class="formElemen" cols="120" rows="2"><%= purchase.getMemo() %></textarea>
                                            <%= jspPurchase.getErrorMsg(jspPurchase.JSP_MEMO) %> </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td colspan="3">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td> 
                                                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr > 
                                                      <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                      <td class="tab" nowrap>Item 
                                                        Detail</td>
                                                      <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <!--td class="tabin"><a href="admin.html" class="tablink">Activity</a></td-->
                                                      <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="100%" class="page"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td  class="tablehdr" nowrap width="18%" height="20">Item</td>
                                                            <td class="tablehdr" width="10%" height="20">Quantity</td>
                                                            <td class="tablehdr" width="16%" height="20">@Price</td>
                                                            <td class="tablehdr" width="12%" height="20">Discount</td>
                                                            <td class="tablehdr" width="14%" height="20">Total</td>
                                                          </tr>
                                                          <%if(listPurchaseItem!=null && listPurchaseItem.size()>0){
										for(int i=0; i<listPurchaseItem.size(); i++){
											PurchaseItem crd = (PurchaseItem)listPurchaseItem.get(i);
											
											Coa c = new Coa();
											try{
												c = DbCoa.fetchExc(crd.getCoaId());
											}
											catch(Exception e){
											}
											
									%>
                                                          <%
									
									if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SAVE && iErrCode!=0)) && crd.getOID()==oidPurchaseItem){%>
                                                          <tr> 
                                                            <td class="tablecell" width="18%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_ITEM_NAME]%>" size="40" value="<%=crd.getItemName()%>">
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_ITEM_NAME) %> </div>
                                                            </td>
                                                            <td width="10%" class="tablecell" nowrap> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_QTY]%>" size="5" value="<%=crd.getQty()%>" style="text-align:right" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                                <%= "<br>"+ jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_QTY) %></div>
                                                            </td>
                                                            <td width="16%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_PRICE]%>" size="20" value="<%=JSPFormater.formatNumber(crd.getPrice(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                              </div>
                                                            </td>
                                                            <td width="12%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DISCOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getDiscount(), "#,###.##")%>" style="text-align:right" size="20" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                                <input type="hidden" name="default_debet">
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_DISCOUNT) %> </div>
                                                            </td>
                                                            <td width="14%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_TOTAL_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getTotalAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                <input type="hidden" name="default_credit">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <%}else{%>
                                                          <tr> 
                                                            <td class="tablecell" nowrap width="18%"><a href="javascript:cmdEdit('<%=crd.getOID()%>')"><%=crd.getItemName()%></a></td>
                                                            <td width="10%" class="tablecell"> 
                                                              <div align="right"> 
                                                                <%=crd.getQty()%> </div>
                                                            </td>
                                                            <td width="16%" class="tablecell"> 
                                                              <div align="right"> 
                                                                <%=JSPFormater.formatNumber(crd.getPrice(), "#,###.##")%> </div>
                                                            </td>
                                                            <td width="12%" class="tablecell"> 
                                                              <div align="right"><%=JSPFormater.formatNumber(crd.getDiscount(), "#,###.##")%></div>
                                                            </td>
                                                            <td width="14%" class="tablecell"> 
                                                              <div align="right"><%=JSPFormater.formatNumber(crd.getTotalAmount(),  "#,###.##")%></div>
                                                            </td>
                                                          </tr>
                                                          <%}%>
                                                          <%}}%>
                                                          <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SAVE && (iErrCode!=0 || iErrCodeMain!=0))) && oidPurchaseItem==0){%>
                                                          <tr> 
                                                            <td class="tablecell" width="18%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_ITEM_NAME]%>" size="40" value="<%=purchaseItem.getItemName()%>">
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_ITEM_NAME) %> </div>
                                                            </td>
                                                            <td width="10%" class="tablecell" nowrap> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_QTY]%>" size="5" value="<%=purchaseItem.getQty()%>" style="text-align:right" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                                <%= "<br>"+jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_QTY) %></div>
                                                            </td>
                                                            <td width="16%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_PRICE]%>" size="20" value="<%=JSPFormater.formatNumber(purchaseItem.getPrice(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_PRICE) %> </div>
                                                            </td>
                                                            <td width="12%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_DISCOUNT]%>" value="<%=JSPFormater.formatNumber(purchaseItem.getDiscount(), "#,###.##")%>" style="text-align:right" size="20" onBlur="javascript:cmdUpdatePrice()" onClick="this.select()">
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_DISCOUNT) %> </div>
                                                            </td>
                                                            <td width="14%" class="tablecell"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=jspPurchaseItem.colNames[jspPurchaseItem.JSP_TOTAL_AMOUNT]%>" value="<%=JSPFormater.formatNumber(purchaseItem.getTotalAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                <%= jspPurchaseItem.getErrorMsg(jspPurchaseItem.JSP_TOTAL_AMOUNT) %></div>
                                                            </td>
                                                          </tr>
                                                          <%}%>
                                                          <tr> 
                                                            <td class="tablecell" colspan="3" height="1"></td>
                                                            <td width="12%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                            <td width="14%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" class="boxed4">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" class="boxed4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="69%" valign="middle"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td> 
                                                        <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidPurchaseItem+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPurchaseItem+"')";
									String scancel = "javascript:cmdEdit('"+oidPurchaseItem+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/savenew2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/savenew.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverAddNew("MM_swapImage('add','','"+approot+"/images/add2.gif',1)");
									ctrLine.setAddNewImage("<img src=\""+approot+"/images/add.gif\" name=\"add\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("70");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

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
									
									if(iErrCodeMain!=0){
										iErrCode = iErrCodeMain;
										msgString = msgStringMain;
									}
									
									//out.println("iErrCodeMain : "+iErrCodeMain);
									
									%>
                                                        <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                        <%if(iJSPCommand==JSPCommand.BACK || iJSPCommand==JSPCommand.POST){%>
                                                        <a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/add2.gif',1)"><img src="../images/add.gif" name="print2" width="49" height="22" border="0"></a> 
                                                        <%}%>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="31%" class="boxed1"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="37%" class="tablecell"> 
                                                        <div align="left"><b>&nbsp;TOTAL 
                                                          </b></div>
                                                      </td>
                                                      <td width="25%" class="tablecell">&nbsp;</td>
                                                      <td width="38%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="text" name="<%=jspPurchase.colNames[jspPurchase.JSP_TOTAL]%>" value="<%=JSPFormater.formatNumber(purchase.getTotal(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="37%" class="tablecell"> 
                                                        <div align="left"><b>&nbsp;DISCOUNT 
                                                          </b></div>
                                                      </td>
                                                      <td width="25%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT_PERCENT]%>" value="<%=JSPFormater.formatNumber(purchase.getDiscountPercent(), "#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()">
                                                          % </div>
                                                      </td>
                                                      <td width="38%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="text" name="<%=jspPurchase.colNames[jspPurchase.JSP_DISCOUNT]%>" value="<%=JSPFormater.formatNumber(purchase.getDiscount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="37%" class="tablecell"> 
                                                        <div align="left"><b>&nbsp;VAT 
                                                          </b></div>
                                                      </td>
                                                      <td width="25%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspPurchase.colNames[jspPurchase.JSP_VAT_PERCENT]%>" value="<%=JSPFormater.formatNumber(sysCompany.getGovernmentVat(), "#,###.##")%>" style="text-align:right" size="5"  onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()" class="readonly" readOnly>
                                                          % </div>
                                                      </td>
                                                      <td width="38%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="text" name="<%=jspPurchase.colNames[jspPurchase.JSP_VAT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(purchase.getVatAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="37%" class="tablecell"> 
                                                        <div align="left"><b>&nbsp;GRAND 
                                                          TOTAL </b></div>
                                                      </td>
                                                      <td width="25%" class="tablecell">&nbsp;</td>
                                                      <td width="38%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="text" name="grand_total" value="<%=JSPFormater.formatNumber((purchase.getTotal()-purchase.getDiscount()+purchase.getVatAmount()), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" class="boxed4" height="17">&nbsp;</td>
                                        </tr>
                                        <%if(purchase.getOID()!=0){%>
                                        <tr > 
                                          <td background="../images/line.gif" colspan="4"><img src="../images/line.gif" width="39" height="7"></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="40%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="11%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print3','','../images/print2.gif',1)"><img src="../images/print.gif" name="print3" width="53" height="22" border="0"></a></td>
                                                <td width="4%"><img src="<%=approot%>/images/spacer.gif" width="20" height="10"></td>
                                                <td width="15%"><a href="javascript:cmdNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print111','','../images/new2.gif',1)"><img src="../images/new.gif" name="print111" height="22" border="0"></a></td>
                                                <td width="4%"><img src="<%=approot%>/images/spacer.gif" width="20" height="10"></td>
                                                <td width="15%"><a href="javascript:cmdSaveDoc()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="print1111" border="0"></a></td>
                                                <td width="2%"><img src="<%=approot%>/images/spacer.gif" width="20" height="10"></td>
                                                <td width="49%"><a href="../home.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/close2.gif',1)"><img src="../images/close.gif" name="print1"  border="0"></a></td>
                                                <td width="0%">&nbsp;</td>
                                                <td width="0%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="35%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="35%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                 
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">
							  &nbsp; 
							  <%
							 // out.println("iJSPCommand : "+iJSPCommand);
							  //out.println("iErrCode : "+iErrCode);
							  %></td>
                            </tr>
                          </table>
                          <script language="JavaScript">
							cmdShip();
							cmdVendor();
							<%if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iErrCode!=0){%>
								//alert("in");
								//cmdUpdateType();
							<%}%>
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
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
