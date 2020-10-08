
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%//@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public Vector drawList(int iJSPCommand,JspPurchaseItem frmObject, 
                PurchaseItem objEntity, Vector objectClass, 
                long purchaseItemId, String approot, long oidVendor,
				int iErrCode2, String status)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No","5%"); 
		jsplist.addHeader("Group/Category/Code - Name","35%");
		jsplist.addHeader("Price","10%");
		jsplist.addHeader("Qty","7%");		
		jsplist.addHeader("Discount","10%");
		jsplist.addHeader("Total","10%");
		jsplist.addHeader("Unit","7%");
		jsplist.addHeader("Delivery Date","16%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected ItemGroupId*/
        whereCls = DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+"="+oidVendor;
		//Vector vect_master = DbItemMaster.list(0,0, whereCls, "");
        Vector vectVendMaster = QrVendorItem.getVendorItems(oidVendor);//DbVendorItem.list(0, 0, whereCls, "");
		
		//System.out.println("vectVendMaster :: "+vectVendMaster);
		
		Vector vect_value = new Vector(1,1);
		Vector vect_key = new Vector(1,1);
		if(vectVendMaster!=null && vectVendMaster.size()>0){
			for(int i=0; i<vectVendMaster.size(); i++){
				Vector v = (Vector)vectVendMaster.get(i);
			
				//VendorItem ig = (VendorItem)vectVendMaster.get(i);
				ItemMaster im = (ItemMaster)v.get(0);
				ItemGroup ig = (ItemGroup)v.get(1);
				ItemCategory ic = (ItemCategory)v.get(2);
				//ItemMaster im = (ItemMaster)v.get(0);
				try{
					//im = DbItemMaster.fetchExc(ig.getItemMasterId());
					vect_key.add(ig.getName()+"/ "+ic.getName()+"/ "+im.getCode()+" - "+im.getName());
					vect_value.add(""+im.getOID());
				}catch(Exception e){}
			}
		}
		
		//System.out.println("vect_key : "+vect_key);
		//System.out.println("vect_value : "+vect_value);
		
		Vector temp = new Vector();

		/* selected ItemGroupId*/
		Vector units = DbUom.list(0,0, "", "");
		Vector uom_value = new Vector(1,1);
		Vector uom_key = new Vector(1,1);
		if(units!=null && units.size()>0){
			for(int i=0; i<units.size(); i++){
				Uom uom = (Uom)units.get(i);
				uom_key.add(""+uom.getUnit());
				uom_value.add(""+uom.getOID());
			}
		}

        for (int i = 0; i < objectClass.size(); i++) {
			 PurchaseItem purchaseItem = (PurchaseItem)objectClass.get(i);
			 
			 SessPurchaseOrderL prOL = new SessPurchaseOrderL();
			 
			 rowx = new Vector();
			 if(purchaseItemId == purchaseItem.getOID())
			 	 index = i; 

			 if(iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK ||  (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && purchaseItemId==0))){
					
					//------------			
					rowx.add("<div align=\"center\">"+(i+1)+"</div>");	
					if(vectVendMaster!=null && vectVendMaster.size()>0){
						rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID)+"</div>");                                
					}
					else{
						rowx.add("<font color=\"red\">No purchase item available for vendor</font>");
					}
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_AMOUNT] +"\" value=\""+purchaseItem.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_QTY] +"\" value=\""+purchaseItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+purchaseItem.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_AMOUNT] +"\" value=\""+purchaseItem.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div><input type=\"hidden\" name=\"temp_item_amount\" value=\""+purchaseItem.getTotalAmount()+"\">");
					//rowx.add("<div align=\"right\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
					rowx.add("<div align=\"center\"><input name=\""+JspPurchaseItem.colNames[JspPurchaseItem.JSP_DELIVERY_DATE]+"\" value=\""+JSPFormater.formatDate((purchaseItem.getDeliveryDate()==null) ? new Date() : purchaseItem.getDeliveryDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
								"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmpurchase."+JspPurchaseItem.colNames[JspPurchaseItem.JSP_DELIVERY_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");

			 }else{
				ItemMaster itemMaster = new ItemMaster();
				ItemGroup ig = new ItemGroup();
				ItemCategory ic = new ItemCategory();
				try{
					itemMaster = DbItemMaster.fetchExc(purchaseItem.getItemMasterId());
					ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
					ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
				}catch(Exception e){}
                                
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(purchaseItem.getUomId());
				}catch(Exception e){}
				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				if(status!=null && status.equals(I_Project.DOC_STATUS_DRAFT)){		
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(purchaseItem.getOID())+"')\">"+ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName()+"</a>");
					   prOL.setGroup(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				else{
					rowx.add(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
					   prOL.setGroup(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(purchaseItem.getAmount(), "#,###.##")+"</div>");
					prOL.setPrice(purchaseItem.getAmount());
				rowx.add("<div align=\"center\">"+purchaseItem.getQty()+"</div>");
					prOL.setQty(purchaseItem.getQty());
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(purchaseItem.getTotalDiscount(), "#,###.##")+"</div>");
					prOL.setDiscount(purchaseItem.getTotalDiscount());
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(purchaseItem.getTotalAmount(), "#,###.##")+"</div>");
					prOL.setTotal(purchaseItem.getTotalAmount());
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");
					prOL.setUnit(uom.getUnit());
                rowx.add("<div align=\"center\">"+JSPFormater.formatDate(purchaseItem.getDeliveryDate(), "dd/MM/yyyy")+"</div>");
					prOL.setDeliveryDate(purchaseItem.getDeliveryDate());
			 } 

			lstData.add(rowx);
			temp.add(prOL);
		}

		 rowx = new Vector();

		if(iJSPCommand != JSPCommand.POST && (iJSPCommand == JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && purchaseItemId==0))){ 
				rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
				if(vectVendMaster!=null && vectVendMaster.size()>0){
					rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID)+"</div>");                                
				}
				else{
					rowx.add("<font color=\"red\">No purchase item available for vendor</font>");
				}
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_AMOUNT)+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+objEntity.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspPurchaseItem.JSP_TOTAL_AMOUNT] +"\" value=\""+objEntity.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div>");
				//rowx.add("<div align=\"right\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
				rowx.add("<div align=\"center\"><input name=\""+JspPurchaseItem.colNames[JspPurchaseItem.JSP_DELIVERY_DATE]+"\" value=\""+JSPFormater.formatDate((objEntity.getDeliveryDate()==null) ? new Date() : objEntity.getDeliveryDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
							"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmpurchase."+JspPurchaseItem.colNames[JspPurchaseItem.JSP_DELIVERY_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
		}


		lstData.add(rowx);

		//return jsplist.draw(index);
		
		Vector v = new Vector();
		v.add(jsplist.draw(index));
		v.add(temp);
		return v;
	}
%>
	
<%

	if(session.getValue("PURCHASE_TITTLE")!=null){
		session.removeValue("PURCHASE_TITTLE");
	}
	
	if(session.getValue("PURCHASE_DETAIL")!=null){
		session.removeValue("PURCHASE_DETAIL");
	}


int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchase = JSPRequestValue.requestLong(request, "hidden_purchase_id");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchase =0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

SessPurchaseOrder prOrder = new SessPurchaseOrder();

CmdPurchase cmdPurchase = new CmdPurchase(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdPurchase.action(iJSPCommand , oidPurchase);
JspPurchase jspPurchase = cmdPurchase.getForm();
Purchase purchase = cmdPurchase.getPurchase();
msgString =  cmdPurchase.getMessage();
        
if(oidPurchase==0){
    oidPurchase = purchase.getOID();
	purchase.setStatus(I_Project.DOC_STATUS_DRAFT);
}

whereClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+"="+oidPurchase;
orderClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID];
Vector purchReqItems = DbPurchaseItem.list(0,0, whereClause, orderClause);

%>	
	
<%
//int iJSPCommand = JSPRequestValue.requestCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
//long oidPurchase = JSPRequestValue.requestLong(request, "hidden_purchase_id");
long oidPurchaseItem = JSPRequestValue.requestLong(request, "hidden_purchase_item_id");

/*variable declaration*/
//int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";
//System.out.println("jaskjhdfajkshdfjkhasjkdf : "+oidPurchase);
//Purchase purchase = new Purchase();
//try{
//        purchase = DbPurchase.fetchExc(oidPurchase);
//    }catch(Exception e){}

//System.out.println("jaskjhdfajkshdfjkhasjkdf ************ ");

CmdPurchaseItem cmdPurchaseItem = new CmdPurchaseItem(request);
//JSPLine ctrLine = new JSPLine();
iErrCode2 = cmdPurchaseItem.action(iJSPCommand , oidPurchaseItem, oidPurchase);
JspPurchaseItem jspPurchaseItem = cmdPurchaseItem.getForm();
PurchaseItem purchaseItem = cmdPurchaseItem.getPurchaseItem();
msgString2 =  cmdPurchaseItem.getMessage();

whereClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+"="+oidPurchase;
orderClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID];
Vector purchItems = DbPurchaseItem.list(0,0, whereClause, orderClause);
Vector vendors = DbVendor.list(0,0, "", "name");

if(purchase.getVendorId()==0){
	if(vendors!=null && vendors.size()>0){
		Vendor vx = (Vendor)vendors.get(0);
		purchase.setVendorId(vx.getOID());
	}
}

//out.println("purchase.setVendorId : "+purchase.getVendorId());

Vector vendorItems = QrVendorItem.getVendorItems(purchase.getVendorId());//DbVendorItem.list(0, 0, whereCls, "");


if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchaseItem = 0;
	purchaseItem = new PurchaseItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidPurchaseItem = 0;
	purchaseItem = new PurchaseItem();
}

if((iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0) || iJSPCommand==JSPCommand.LOAD){
//delete item, load purchase
	try{
		purchase = DbPurchase.fetchExc(oidPurchase);
	}
	catch(Exception e){
	}
}

double subTotal = DbPurchaseItem.getTotalPurchaseAmount(oidPurchase);

//out.println("subTotal : "+subTotal);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--
function cmdPrintPdf(){
	//window.open();
	window.open("<%=printroot%>.report.RptPurchaseOrderPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
}

<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

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

function parserMaster(){
    var str = document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_ITEM_MASTER_ID]%>.value;
	<%if(vendorItems!=null && vendorItems.size()>0){
		for(int i=0; i<vendorItems.size(); i++){
			Vector v = (Vector)vendorItems.get(i);				
			ItemMaster imx = (ItemMaster)v.get(0);
			Uom uom = (Uom)v.get(3);
			VendorItem vix = (VendorItem)v.get(4);
	%>
			if('<%=imx.getOID()%>'==str){
				document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_AMOUNT]%>.value = formatFloat('<%=vix.getLastPrice()%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
				document.frmpurchase.unit_code.value="<%=uom.getUnit()%>";
			}
	<%}}%>
    
	calculateSubTotal();
	
}

function calculateSubTotal(){
	var amount = document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_AMOUNT]%>.value;
	var qty = document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_QTY]%>.value;
	var discount = document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_TOTAL_DISCOUNT]%>.value;
	
	amount = removeChar(amount);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_QTY]%>.value = qty;
	
	discount = removeChar(discount);
	discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
	document.frmpurchase.<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var subtot = document.frmpurchase.sub_tot.value;
	subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("amount : "+amount);
	//alert("subtot : "+subtot);
	//alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
	
	<%
	//add
	if(oidPurchaseItem==0){%>
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	else{%>
		var tempAmount = document.frmpurchase.temp_item_amount.value;
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	%>
	
	calculateAmount();
}


function cmdVatEdit(){
	var vat = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_INCLUDE_TAX]%>.value;
	if(parseInt(vat)==0){
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>.value="0.0";				
	}else{
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
	}
	
	calculateAmount();
}

function calculateAmount(){
	
	var vat = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_INCLUDE_TAX]%>.value;
	var taxPercent = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>.value;
	taxPercent = removeChar(taxPercent);
	taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var discPercent = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_DISCOUNT_PERCENT]%>.value;	
	discPercent = removeChar(discPercent);
	discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var subTotal = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_AMOUNT]%>.value;
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
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>.value="0.0";		
		//document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_TAX]%>.value="0.00";		
		totalTax = 0;
	}else{
		document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
		totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
	}
	
	//alert("subTotal :"+subTotal);
	//alert("totalDiscount :"+totalDiscount);
	//alert("totalTax :"+totalTax);
	
	var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
	
	//alert("grandTotal :"+grandTotal);
	
	document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmpurchase.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}

function cmdClosedReason(){
	var st = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdVendor(){
	<%if(purchase.getOID()!=0 && purchItems!=null && purchItems.size()>0){%>
		if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all purchase item based on vendor item master. ')){
			document.frmpurchase.command.value="<%=JSPCommand.LOAD%>";
			document.frmpurchase.action="purchaseitem.jsp";
			document.frmpurchase.submit();
		}
	<%}else{%>
			document.frmpurchase.command.value="<%=JSPCommand.LOAD%>";
			document.frmpurchase.action="purchaseitem.jsp";
			document.frmpurchase.submit();
		//cmdVendorChange();
	<%}%>
}

function cmdToRecord(){
	document.frmpurchase.command.value="<%=JSPCommand.NONE%>";
	document.frmpurchase.action="purchaselist.jsp";
	document.frmpurchase.submit();
}

function cmdVendorChange(){
	var oid = document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_VENDOR_ID]%>.value;
	<%
	if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor v = (Vendor)vendors.get(i);
			%>
			if('<%=v.getOID()%>'==oid){
				document.frmpurchase.vnd_address.value="<%=v.getAddress()%>";
			}
			<%
		}
	}
	%>
	
}


function cmdCloseDoc(){
	document.frmpurchase.action="<%=approot%>/home.jsp";
	document.frmpurchase.submit();
}

function cmdAskDoc(){
	document.frmpurchase.hidden_purchase_request_item_id.value="0";
	document.frmpurchase.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdDeleteDoc(){
	document.frmpurchase.hidden_purchase_request_item_id.value="0";
	document.frmpurchase.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdCancelDoc(){
	document.frmpurchase.hidden_purchase_request_item_id.value="0";
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdSaveDoc(){
	document.frmpurchase.command.value="<%=JSPCommand.POST%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdAdd(){
	document.frmpurchase.hidden_purchase_item_id.value="0";
	document.frmpurchase.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdAsk(oidPurchaseItem){
	document.frmpurchase.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchase.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdAskMain(oidPurchase){
	document.frmpurchase.hidden_purchase_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
}

function cmdConfirmDelete(oidPurchaseItem){
	document.frmpurchase.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchase.command.value="<%=JSPCommand.DELETE%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}
function cmdSaveMain(){
	document.frmpurchase.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
	}

function cmdSave(){
	document.frmpurchase.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}

function cmdEdit(oidPurchase){
	document.frmpurchase.hidden_purchase_item_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}

function cmdCancel(oidPurchase){
	document.frmpurchase.hidden_purchase_item_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdBack(){
	document.frmpurchase.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}

function cmdListFirst(){
	document.frmpurchase.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdListPrev(){
	document.frmpurchase.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}

function cmdListNext(){
	document.frmpurchase.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdListLast(){
	document.frmpurchase.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpurchase" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspPurchase.colNames[JspPurchase.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_purchase_item_id" value="<%=oidPurchaseItem%>">
                          <input type="hidden" name="hidden_purchase_id" value="<%=oidPurchase%>">
                          <input type="hidden" name="<%=JspPurchaseItem.colNames[JspPurchaseItem.JSP_PURCHASE_ID]%>" value="<%=oidPurchase%>">
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
                                            <span class="lvl2">Purchase Order</span></font></b></td>
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
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Purchase 
                                              Order&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
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
                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                    <%if(purchase.getOID()==0){%>
                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                    <%}else{
													User us = new User();
													try{
														us = DbUser.fetch(purchase.getUserId());
													}
													catch(Exception e){
													}
													%>
                                                    Prepared By : <%=us.getLoginId()%> 
                                                    <%}%>
                                                    </i>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="26" width="12%">&nbsp;&nbsp;Vendor</td>
                                                <td height="26" width="27%"> 
                                                  <select name="<%=JspPurchase.colNames[JspPurchase.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                    <%      
											  if(vendors!=null && vendors.size()>0){
											  	for(int i=0; i<vendors.size(); i++){
											  		Vendor d = (Vendor)vendors.get(i);
														if(purchase.getVendorId()==d.getOID()){
															prOrder.setVendor(d.getCode()+" - "+d.getName());
															prOrder.setAddress(d.getAddress());
														}
														
													%>
                                                    <option value="<%=d.getOID()%>" <%if(purchase.getVendorId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                  <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly"></textarea>
                                                </td>
                                                <td height="26" width="9%">&nbsp;</td>
                                                <td height="26" colspan="2" width="52%" class="comment">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Address</td>
                                                <td height="21" width="27%">&nbsp; </td>
                                                <td width="9%">Deliver To </td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <select name="<%=JspPurchase.colNames[JspPurchase.JSP_LOCATION_ID]%>">
                                                    <%                                          
													Vector locations = DbLocation.list(0,0, DbLocation.colNames[DbLocation.COL_TYPE]+"='"+DbLocation.TYPE_WAREHOUSE+"'", "code");
													  if(locations!=null && locations.size()>0){
														for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
																if(purchase.getLocationId()==d.getOID()){
																	prOrder.setDeliverTo(d.getCode()+" - "+d.getName());
																}
															%>
                                                    <option value="<%=d.getOID()%>" <%if(purchase.getLocationId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;PO 
                                                  Number</td>
                                                <td height="21" width="27%">
                                                  <%
												  String number = "";
												  if(purchase.getOID()==0){
													  int ctr = DbPurchase.getNextCounter();
													  number = DbPurchase.getNextNumber(ctr);
													  prOrder.setPoNumber(number);
												  }
												  else{
													  number = purchase.getNumber();
													  prOrder.setPoNumber(number);
												  }
												  %>
                                                  <%=number%> </td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%">
                                                  <%
                                              Vector currs = DbCurrency.list(0, 0, "", "");
                                              Vector exchange_value = new Vector(1,1);
                                                    Vector exchange_key = new Vector(1,1);
                                                    String sel_exchange = ""+purchase.getCurrencyId();
                                                  if(currs!=null && currs.size()>0){
                                                        for(int i=0; i<currs.size(); i++){
                                                            Currency d = (Currency)currs.get(i);
                                                            exchange_key.add(""+d.getOID());
                                                            exchange_value.add(d.getCurrencyCode());
                                                        }
                                                  }          
                                              %>
                                                  <%//= JSPCombo.draw(JspPurchase.colNames[JspPurchase.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="<%=JspPurchase.colNames[JspPurchase.JSP_PURCH_DATE]%>" value="<%=JSPFormater.formatDate((purchase.getPurchDate()==null) ? new Date() : purchase.getPurchDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpurchase.<%=JspPurchase.colNames[JspPurchase.JSP_PURCH_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%prOrder.setDate(purchase.getPurchDate());%>
												</td>
                                                <td width="9%">Status</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <%
											if(purchase.getStatus()==null){
												//out.println("status = null, set to draft");
												purchase.setStatus(I_Project.DOC_STATUS_DRAFT);
											}	
											%>
                                                  <input type="text" class="readOnly" name="stt" value="<%=(purchase.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((purchase.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : purchase.getStatus())%>" size="15" readOnly>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Payment 
                                                  Type </td>
                                                <td height="21" width="27%"> 
                                                  <% 
                                                Vector payment_value = new Vector(1,1);
												Vector payment_key = new Vector(1,1);
												String sel_payment = ""+purchase.getPaymentType();
												prOrder.setPaymentType(""+purchase.getPaymentType());
                                                payment_key.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_key.add(I_Project.PAYMENT_TYPE_CREDIT);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CREDIT);
					   							%>
                                                  <%= JSPCombo.draw(JspPurchase.colNames[JspPurchase.JSP_PAYMENT_TYPE],null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                                <td width="9%">Applay VAT</td>
                                                <td width="52%" colspan="2" class="comment"> 
                                                  <% 
                                                Vector include_value = new Vector(1,1);
												Vector include_key = new Vector(1,1);
												String sel_include = ""+purchase.getIncluceTax();
												prOrder.setApplayVat(purchase.getIncluceTax());
                                                include_value.add(DbPurchase.strIncludeTax[DbPurchase.INCLUDE_TAX_NO]);
                                                include_key.add(""+DbPurchase.INCLUDE_TAX_NO);
                                                include_value.add(DbPurchase.strIncludeTax[DbPurchase.INCLUDE_TAX_YES]);
                                                include_key.add(""+DbPurchase.INCLUDE_TAX_YES);
					   							%>
                                                  <%= JSPCombo.draw(JspPurchase.colNames[JspPurchase.JSP_INCLUDE_TAX],null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %> </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="<%=JspPurchase.colNames[JspPurchase.JSP_NOTE]%>" cols="120" rows="2"><%=purchase.getNote()%></textarea>
                                                </td>
												<%prOrder.setNotes(purchase.getNote());%>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">
												&nbsp;
												<%
													Vector x = drawList(iJSPCommand,jspPurchaseItem, purchaseItem, purchItems, oidPurchaseItem, approot, purchase.getVendorId(), iErrCode2, purchase.getStatus());
													String strString = (String)x.get(0);
													Vector rptObj = (Vector)x.get(1);
												%>
												<%=strString%>
												<% session.putValue("PURCHASE_DETAIL",rptObj);%>
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
                                                        <%if(purchase.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>
                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                          <%
														if(	iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || 
															(iJSPCommand==JSPCommand.EDIT && oidPurchaseItem!=0) || 
															iJSPCommand==JSPCommand.ASK	|| iErrCode2!=0){%>
                                                          <tr> 
                                                            <td> 
                                                              <%      
                                                               ctrLine = new JSPLine();
																ctrLine.setLocationImg(approot+"/images/ctr_line");
																ctrLine.initDefault();
																ctrLine.setTableWidth("80%");
																String scomDel = "javascript:cmdAsk('"+oidPurchaseItem+"')";
																String sconDelCom = "javascript:cmdConfirmDelete('"+oidPurchaseItem+"')";
																String scancel = "javascript:cmdBack('"+oidPurchaseItem+"')";
																ctrLine.setBackCaption("Back to List");
																ctrLine.setJSPCommandStyle("buttonlink");
																ctrLine.setDeleteCaption("Delete");
																
																	ctrLine.setOnMouseOut("MM_swapImgRestore()");
																ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','"+approot+"/images/save2.gif',1)");
																ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");
																
																//ctrLine.setOnMouseOut("MM_swapImgRestore()");
																ctrLine.setOnMouseOverBack("MM_swapImage('back_item','','"+approot+"/images/cancel2.gif',1)");
																ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back_item\" height=\"22\" border=\"0\">");
																
																ctrLine.setOnMouseOverDelete("MM_swapImage('delete_item','','"+approot+"/images/delete2.gif',1)");
																ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete_item\" height=\"22\" border=\"0\">");
																
																ctrLine.setOnMouseOverEdit("MM_swapImage('edit_item','','"+approot+"/images/cancel2.gif',1)");
																ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit_item\" height=\"22\" border=\"0\">");
																
																
																ctrLine.setWidthAllJSPCommand("90");
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
																if((iJSPCommand ==JSPCommand.DELETE)||(iJSPCommand==JSPCommand.SAVE)&&(iErrCode==0)){
																	ctrLine.setAddCaption("");
																	ctrLine.setCancelCaption("");
																	ctrLine.setBackCaption("");
																	msgString = "Data is Saved";
																}
																 
																if(vendorItems==null || vendorItems.size()==0){
																	ctrLine.setSaveCaption("");
																}
																
																if(iJSPCommand==JSPCommand.LOAD){
																	if(oidPurchaseItem==0){
																		iJSPCommand=JSPCommand.ADD;
																	}
																	else{
																		iJSPCommand=JSPCommand.EDIT;
																	}
																} 
																									
																%>
                                                              <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                          </tr>
                                                          <%}else{%>
                                                          <tr> 
                                                            <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                          </tr>
                                                          <%}%>
                                                        </table>
                                                        <%}%>
                                                      </td>
                                                      <td width="55%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Sub 
                                                                Total</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <input type="hidden" name="sub_tot" value="<%=subTotal%>">
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                              </div>
															  <%prOrder.setSubTotal(subTotal);%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Discount</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input name="<%=JspPurchase.colNames[JspPurchase.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=purchase.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()">
                                                                % </div>
																<%prOrder.setDiscount1(purchase.getDiscountPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspPurchase.colNames[JspPurchase.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(purchase.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                              </div>
															  <%prOrder.setDiscount2(purchase.getDiscountTotal());%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>VAT</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>" size="5" value="<%=purchase.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                                                                % </div>
																<%prOrder.setVat1(purchase.getTaxPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspPurchase.colNames[JspPurchase.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(purchase.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                              </div>
															  <%prOrder.setVat2(purchase.getTotalTax());%>
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
                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(purchase.getTotalAmount()+purchase.getTotalTax()+purchase.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                              </div>
															  <%prOrder.setGrandTotal(purchase.getTotalAmount()+purchase.getTotalTax()+purchase.getDiscountTotal());%>
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
                                              <%if(purchase.getOID()!=0){%>
                                              <tr> 
                                                <td colspan="5" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                              </tr>
                                              <%}%>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td colspan="4"> 
                                                        <%if(purchase.getOID()!=0){%>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%if( (!purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0)){%>
                                                          <tr> 
                                                            <td width="12%"><b>Set 
                                                              Status to</b> </td>
                                                            <td width="14%"> 
                                                              <select name="<%=JspPurchase.colNames[JspPurchase.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if( purchase.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                <%if(posApprove1Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if( purchase.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                <%}%>
                                                                <%if(posApprove2Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if( purchase.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                <%}%>
                                                                <%if(posApprove4Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if( purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
                                                                <%}%>
                                                              </select>
                                                            </td>
                                                            <td width="74%">&nbsp; </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%}%>
                                                        </table>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="closingreason">
                                                          <tr> 
                                                            <td width="12%"><b>Close 
                                                              Reason</b></td>
                                                            <td width="88%"> 
                                                              <%if( (!purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0)){%>
                                                              <textarea name="<%=JspPurchase.colNames[JspPurchase.JSP_CLOSED_REASON]%>" cols="50"><%=(purchase.getClosedReason()==null) ? "" : purchase.getClosedReason()%></textarea>
                                                              * <%=jspPurchase.getErrorMsg(JspPurchase.JSP_CLOSED_REASON)%> 
                                                              <%}else{%>
                                                              <i><%=(purchase.getClosedReason()==null) ? "" : purchase.getClosedReason()%> </i> 
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="88%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                        <%}%>
                                                      </td>
                                                    </tr>
                                                    <%if(iJSPCommand==JSPCommand.SUBMIT){%>
                                                    <tr> 
                                                      <td colspan="3">Are you 
                                                        sure to delete document 
                                                        ?</td>
                                                      <td width="862">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="149"><a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                      <td width="102"><a href="javascript:cmdCancelDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                      <td width="97">&nbsp;</td>
                                                      <td width="862">&nbsp;</td>
                                                    </tr>
                                                    <%}else{
															if(purchase.getOID()!=0){
													%>
                                                    <tr> 
                                                      <td colspan="4" class="errfont"><%=msgString%></td>
                                                    </tr>
                                                    <%		}%>
                                                    <%if(vendorItems!=null && vendorItems.size()>0){
														if(purchase.getOID()!=0){
													%>
                                                    <tr> 
                                                      <%if( !purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0){%>
                                                      <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                      <td width="102" > 
                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                      </td>
                                                      <%}%>
                                                      <td width="97"> 
                                                        <div align="left"><a href="javascript:cmdPrintPdf()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                      </td>
                                                    </tr>
                                                    <%}}else{%>
                                                    <tr> 
                                                      <td colspan="2" nowrap> 
                                                        <div align="left"><font color="#FF0000"><i>No 
                                                          purchase item for vendor</i></font></div>
                                                      </td>
                                                      <td width="97"> 
                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211112" border="0"></a></div>
                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"></div>
                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <%}%>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <%if(purchase.getOID()!=0){%>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><b><u>Document 
                                                        History</u></b></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"><b><u>User</u></b></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><b><u>Date</u></b></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Prepared 
                                                        By</i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%
												User u = new User();
												try{
													u = DbUser.fetch(purchase.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i><%=JSPFormater.formatDate(purchase.getPurchDate(), "dd MMMM yy")%></i></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Approved 
                                                        by</i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%
												 u = new User();
												try{
													u = DbUser.fetch(purchase.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%if(purchase.getApproval1()!=0){%>
                                                          <%=JSPFormater.formatDate(purchase.getApproval1Date(), "dd MMMM yy")%> 
                                                          <%}%>
                                                          </i></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Check 
                                                        by</i> </td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <div align="center"> 
                                                            <i> 
                                                            <%
												u = new User();
												try{
													u = DbUser.fetch(purchase.getApproval2());
												}
												catch(Exception e){
												}
												%>
                                                            <%=u.getLoginId()%></i></div>
                                                        </div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <div align="center"> 
                                                            <i> 
                                                            <%if(purchase.getApproval2()!=0){%>
                                                            <%=JSPFormater.formatDate(purchase.getApproval2Date(), "dd MMMM yy")%> 
                                                            <%}%>
                                                            </i></div>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Closed 
                                                        By</i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <div align="center"> 
                                                            <i> 
                                                            <%
												u = new User();
												try{
													u = DbUser.fetch(purchase.getApproval3());
												}
												catch(Exception e){
												}
												%>
                                                            <%=u.getLoginId()%></i></div>
                                                        </div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <div align="center"> 
                                                            <i> 
                                                            <%if(purchase.getApproval3()!=0){%>
                                                            <%=JSPFormater.formatDate(purchase.getApproval3Date(), "dd MMMM yy")%> 
                                                            <%}%>
                                                            </i></div>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
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
						  	cmdVendorChange();
							<%
							if(vendorItems!=null && vendorItems.size()>0){
							if(iErrCode2==0 &&(purchase.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && purchaseItem.getOID()!=0) || iErrCode!=0))){%>
                            	parserMaster();
							<%}
							}%>
                          </script>
                          <script language="JavaScript">
						    <%if(purchase.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && purchaseItem.getOID()!=0) || iErrCode!=0)){%>
									//alert('in here');
									//cmdChangeItem();																		
							<%}							
							if(purchase.getOID()!=0 && !purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>
									cmdClosedReason();
							<%}%>
							</script>
							
							<%
								session.putValue("PURCHASE_TITTLE",prOrder);
							%>
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
