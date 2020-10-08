
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
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

	public Vector drawList(int iJSPCommand,JspOpnameItem frmObject, 
                OpnameItem objEntity, Vector objectClass, 
                long opnameItemId, String approot, long oidFromLocationId,
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
		jsplist.addHeader("Group/Category/Code - Name","50%");
		// jsplist.addHeader("Price","10%");
		jsplist.addHeader("Qty System","5%");		
		jsplist.addHeader("Qty Real","5%");
		// jsplist.addHeader("Total","10%");
		jsplist.addHeader("Unit","5%");

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
        Vector vectVendMaster = DbStock.getStock(oidFromLocationId);
		
		Vector vect_value = new Vector(1,1);
		Vector vect_key = new Vector(1,1);
		if(vectVendMaster!=null && vectVendMaster.size()>0){
			for(int i=0; i<vectVendMaster.size(); i++){
				Stock stock = (Stock)vectVendMaster.get(i);
				try{
					vect_key.add(stock.getItemCode()+" - "+stock.getItemName());
					vect_value.add(""+stock.getItemMasterId());
				}catch(Exception e){}
			}
		}
		
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
			 OpnameItem opnameItem = (OpnameItem)objectClass.get(i);
			 
			 //SessOpnameOrderL prOL = new SessOpnameOrderL();
			 
			 rowx = new Vector();
			 if(opnameItemId == opnameItem.getOID())
			 	 index = i; 

			 if(iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK ||  (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && opnameItemId==0))){
					rowx.add("<div align=\"center\">"+(i+1)+"</div>");	
					if(vectVendMaster!=null && vectVendMaster.size()>0){
						rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspOpnameItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID)+"</div>");                                
					}
					else{
						rowx.add("<font color=\"red\">No item stock for opname</font>");
					}
					//rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspOpnameItem.JSP_PRICE] +"\" value=\""+opnameItem.getPrice()+"\" class=\"formElemen\" style=\"text-align:right\">"+frmObject.getErrorMsg(frmObject.JSP_PRICE)+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspOpnameItem.JSP_QTY_SYSTEM] +"\" value=\""+opnameItem.getQtySystem()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY_REAL)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspOpnameItem.JSP_QTY_REAL] +"\" value=\""+opnameItem.getQtyReal()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
					//rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspOpnameItem.JSP_AMOUNT] +"\" value=\""+opnameItem.getAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div><input type=\"hidden\" name=\"temp_item_amount\" value=\""+opnameItem.getAmount()+"\">");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");

			 }else{
				ItemMaster itemMaster = new ItemMaster();
				ItemGroup ig = new ItemGroup();
				ItemCategory ic = new ItemCategory();
				try{
					//System.out.println("sdasdfdsfdsfsdf");
					itemMaster = DbItemMaster.fetchExc(opnameItem.getItemMasterId());
					//System.out.println("sdasdfdsfdsfsdf 11111111111111");
					
					ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
					ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
				}catch(Exception e){}
                                
				/*Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(opnameItem.getUomId());
				}catch(Exception e){}*/
				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				if(status!=null && status.equals(I_Project.DOC_STATUS_DRAFT)){		
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(opnameItem.getOID())+"')\">"+ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName()+"</a>");
					   //prOL.setGroup(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				else{
					rowx.add(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
					//prOL.setGroup(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				rowx.add("<div align=\"center\">"+opnameItem.getQtySystem()+"</div>");
				rowx.add("<div align=\"center\">"+opnameItem.getQtyReal()+"</div>");
				
				Uom uom = new Uom(); 
				try{
					uom = DbUom.fetchExc(itemMaster.getUomStockId());
				}catch(Exception e){}
				
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");
			 } 

			lstData.add(rowx);
			//temp.add(prOL);
		}

		 rowx = new Vector();

		if(iJSPCommand != JSPCommand.POST && (iJSPCommand == JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && opnameItemId==0))){ 
				rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
				if(vectVendMaster!=null && vectVendMaster.size()>0){
					rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspOpnameItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID)+"</div>");                                
				}
				else{
					rowx.add("<font color=\"red\">No item stock for opname</font>");
				}
				//rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspOpnameItem.JSP_PRICE] +"\" value=\""+objEntity.getPrice()+"\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_PRICE)+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspOpnameItem.JSP_QTY_SYSTEM] +"\" value=\""+((objEntity.getQtySystem()==0) ? 1 : objEntity.getQtySystem())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY_SYSTEM)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[JspOpnameItem.JSP_QTY_REAL] +"\" value=\""+objEntity.getQtyReal()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
				//rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspOpnameItem.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div>");
				//rowx.add("<div align=\"right\">"+JSPCombo.draw(frmObject.colNames[JspOpnameItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
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

	if(session.getValue("TRANSFER_TITTLE")!=null){
		session.removeValue("TRANSFER_TITTLE");
	}

	if(session.getValue("TRANSFER_DETAIL")!=null){
		session.removeValue("TRANSFER_DETAIL");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "hidden_opname_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidOpname = 0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

//SessOpnameOrder prOrder = new SessOpnameOrder();

CmdOpname cmdOpname = new CmdOpname(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdOpname.action(iJSPCommand , oidOpname);
JspOpname jspOpname = cmdOpname.getForm();
Opname opname = cmdOpname.getOpname();
msgString =  cmdOpname.getMessage();
        
if(oidOpname==0){
    oidOpname = opname.getOID();
	opname.setStatus(I_Project.DOC_STATUS_DRAFT);
}

whereClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID]+"="+oidOpname;
orderClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID];
Vector purchReqItems = DbOpnameItem.list(0,0, whereClause, orderClause);
System.out.println("oidOpname : "+oidOpname);

%>	
	
<%
long oidOpnameItem = JSPRequestValue.requestLong(request, "hidden_opname_item_id");

/*variable declaration*/
//int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;

CmdOpnameItem cmdOpnameItem = new CmdOpnameItem(request);
//JSPLine ctrLine = new JSPLine();
iErrCode2 = cmdOpnameItem.action(iJSPCommand , oidOpnameItem, oidOpname);
JspOpnameItem jspOpnameItem = cmdOpnameItem.getForm();
OpnameItem opnameItem = cmdOpnameItem.getOpnameItem();
msgString2 =  cmdOpnameItem.getMessage();

whereClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID]+"="+oidOpname;
orderClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID];
Vector purchItems = DbOpnameItem.list(0,0, whereClause, orderClause);
Vector vendors = new Vector(); // DbVendor.list(0,0, "", "name");
System.out.println("oidOpname : "+oidOpname);
Vector stockItems = DbStock.getStock(opname.getLocationId());

if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidOpnameItem = 0;
	opnameItem = new OpnameItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidOpnameItem = 0;
	opnameItem = new OpnameItem();
}

System.out.println("oidOpname2 : "+oidOpname);

if((iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0) || iJSPCommand==JSPCommand.LOAD){
//delete item, load opname
	try{
		opname = DbOpname.fetchExc(oidOpname);
	}
	catch(Exception e){
	}
}

double subTotalReal = DbOpnameItem.getTotalQtyOpname(oidOpname,DbOpnameItem.colNames[DbOpnameItem.COL_QTY_REAL]);
double subTotalSystem = DbOpnameItem.getTotalQtyOpname(oidOpname,DbOpnameItem.colNames[DbOpnameItem.COL_QTY_SYSTEM]);

//Vector itemStock = DbStock.getStock(fromLocationId);
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
	window.open("<%=printroot%>.report.RptOpnameOrderPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
    var str = document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_ITEM_MASTER_ID]%>.value;
	<%if(stockItems!=null && stockItems.size()>0){
		for(int i=0; i<stockItems.size(); i++){
			Stock stock = (Stock)stockItems.get(i);				
	%>
			if('<%=stock.getItemMasterId()%>'==str){
				//alert("sama");
				//document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_PRICE]%>.value = <%=stock.getPrice()%>;
				document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_QTY_SYSTEM]%>.value = <%=stock.getQty()%>;
				document.frmopname.unit_code.value="<%=stock.getUnit()%>";
			}
	<%}}%>
	calculateSubTotal();
}

function calculateSubTotal(){
	var price = document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_PRICE]%>.value;
	var qty = document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_QTY_REAL]%>.value;
	
	amount = removeChar(price);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_QTY_REAL]%>.value = qty;
	
	var totalItemAmount = (parseFloat(amount) * parseFloat(qty));
	document.frmopname.<%=JspOpnameItem.colNames[JspOpnameItem.JSP_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var subtot = document.frmopname.sub_tot.value;
	subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("amount : "+amount);
	//alert("subtot : "+subtot);
	//alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
	
	<%
	//add
	if(oidOpnameItem==0){%>
		//document.frmopname.<%//=JspOpname.colNames[JspOpname.JSP_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	else{%>
		//var tempAmount = document.frmopname.temp_item_amount.value;
		//document.frmopname.<%//=JspOpname.colNames[JspOpname.JSP_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	%>
	
	calculateAmount();
}


function cmdVatEdit(){
	/*var vat = document.frmopname.<%//=JspOpname.colNames[JspOpname.JSP_INCLUDE_TAX]%>.value;
	if(parseInt(vat)==0){
		document.frmopname.<%//=JspOpname.colNames[JspOpname.JSP_TAX_PERCENT]%>.value="0.0";				
	}else{
		document.frmopname.<%//=JspOpname.colNames[JspOpname.JSP_TAX_PERCENT]%>.value="<%//=sysCompany.getGovernmentVat()%>";		
	}*/
	
	calculateAmount();
}

function calculateAmount(){
	
	
}

function cmdClosedReason(){
	var st = document.frmopname.<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdLocation(){
	<%if(opname.getOID()!=0 && purchItems!=null && purchItems.size()>0){%>
		if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all opname item based on vendor item master. ')){
			document.frmopname.command.value="<%=JSPCommand.LOAD%>";
			document.frmopname.action="opnameitem.jsp";
			document.frmopname.submit();
		}
	<%}else{%>
			document.frmopname.command.value="<%=JSPCommand.LOAD%>";
			document.frmopname.action="opnameitem.jsp";
			document.frmopname.submit();
		//cmdVendorChange();
	<%}%>
}

function cmdToRecord(){
	document.frmopname.command.value="<%=JSPCommand.NONE%>";
	document.frmopname.action="opnamelist.jsp";
	document.frmopname.submit();
}

function cmdVendorChange(){
	var oid = document.frmopname.<%=JspOpname.colNames[JspOpname.JSP_LOCATION_ID]%>.value;
	<%
	if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor v = (Vendor)vendors.get(i);
			%>
			if('<%=v.getOID()%>'==oid){
				document.frmopname.vnd_address.value="<%=v.getAddress()%>";
			}
			<%
		}
	}
	%>
	
}


function cmdCloseDoc(){
	document.frmopname.action="<%=approot%>/home.jsp";
	document.frmopname.submit();
}

function cmdAskDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdDeleteDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdCancelDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdSaveDoc(){
	document.frmopname.command.value="<%=JSPCommand.POST%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAdd(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.ADD%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAsk(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAskMain(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdConfirmDelete(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.DELETE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}
function cmdSaveMain(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdSave(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdEdit(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdCancel(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdBack(){
	document.frmopname.command.value="<%=JSPCommand.BACK%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
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
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_opname_item_id" value="<%=oidOpnameItem%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_OPNAME_ID]%>" value="<%=oidOpname%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Opname Stock </span></font></b></td>
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
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Opname Stock &nbsp;&nbsp;</div>
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
                                                    <%if(opname.getOID()==0){%>
                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                    <%}else{
													User us = new User();
													try{
														us = DbUser.fetch(opname.getUserId());
													}
													catch(Exception e){
													}
													%>
                                                    Prepared By : <%=us.getLoginId()%> 
                                                    <%}%>
                                                    </i>&nbsp;&nbsp;&nbsp;</div>                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="26" width="12%" >&nbsp;&nbsp;Number</td>
                                                <td height="26" width="27%"><%
												  String number = "";
												  if(opname.getOID()==0){
													  int ctr = DbOpname.getNextCounter();
													  number = DbOpname.getNextNumber(ctr);
													  //prOrder.setPoNumber(number);
												  }
												  else{
													  number = ""+opname.getNumber();
													  //prOrder.setPoNumber(number);
												  }
												  %>
                                                  <%=number%> </td>
                                                <td height="26" width="9%">&nbsp;</td>
                                                <td height="26" colspan="2" width="52%" class="comment">&nbsp;</td>
                                              </tr>
                                              
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; Location                                                  </td>
                                                <td height="21" width="27%"><span class="comment">
                                                  <select name="<%=JspOpname.colNames[JspOpname.JSP_LOCATION_ID]%>" onChange="javascript:cmdLocation()">
                                                    <%                                          
													Vector locations = DbLocation.list(0,0, "", "code");
													  if(locations!=null && locations.size()>0){
														for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															%>
                                                    <option value="<%=d.getOID()%>" <%if(opname.getLocationId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </span></td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%">                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="<%=JspOpname.colNames[JspOpname.JSP_DATE]%>" value="<%=JSPFormater.formatDate((opname.getDate()==null) ? new Date() : opname.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmopname.<%=JspOpname.colNames[JspOpname.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%//prOrder.setDate(opname.getPurchDate());%>                                                </td>
                                                <td width="9%">Status</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <%
											if(opname.getStatus()==null){
												//out.println("status = null, set to draft");
												opname.setStatus(I_Project.DOC_STATUS_DRAFT);
											}	
											%>
                                                  <input type="text" class="readOnly" name="stt" value="<%=(opname.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((opname.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : opname.getStatus())%>" size="15" readOnly>                                                </td>
                                              </tr>
                                              
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="<%=JspOpname.colNames[JspOpname.JSP_NOTE]%>" cols="120" rows="2"><%=opname.getNote()%></textarea>                                                </td>
                                                <%//prOrder.setNotes(opname.getNote());%>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  &nbsp; 
                                                  <%
													Vector x = drawList(iJSPCommand,jspOpnameItem, opnameItem, purchItems, oidOpnameItem, approot, opname.getLocationId(), iErrCode2, opname.getStatus());
													String strString = (String)x.get(0);
													Vector rptObj = (Vector)x.get(1);
												%>
                                                  <%=strString%> 
                                                  <% session.putValue("TRANSFER_DETAIL",rptObj);%>                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="3" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="3" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="45%" valign="middle"> 
                                                        <%if(opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>
                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                          <%
														if(	iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || 
															(iJSPCommand==JSPCommand.EDIT && oidOpnameItem!=0) || 
															iJSPCommand==JSPCommand.ASK	|| iErrCode2!=0){%>
                                                          <tr> 
                                                            <td> 
                                                              <%      
                                                               ctrLine = new JSPLine();
																ctrLine.setLocationImg(approot+"/images/ctr_line");
																ctrLine.initDefault();
																ctrLine.setTableWidth("80%");
																String scomDel = "javascript:cmdAsk('"+oidOpnameItem+"')";
																String sconDelCom = "javascript:cmdConfirmDelete('"+oidOpnameItem+"')";
																String scancel = "javascript:cmdBack('"+oidOpnameItem+"')";
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
																 
																if(stockItems==null || stockItems.size()==0){
																	ctrLine.setSaveCaption("");
																}
																
																if(iJSPCommand==JSPCommand.LOAD){
																	if(oidOpnameItem==0){
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
                                                        <%}%>                                                      </td>
                                                      <td width="55%" colspan="2"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Total Qty Real </b></div>                                                            </td>
                                                            <td width="17%"> 
                                                              <input type="hidden" name="sub_tot" value="<%=subTotalReal%>">                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right">
                                                                <input type="text" name="total_real" readOnly class="readOnly" value="<%=subTotalReal%>" style="text-align:right">
                                                              </div>
                                                              <%//prOrder.setSubTotal(subTotal);%>                                                            </td>
                                                          </tr>
                                                          <tr>
                                                            <td width="60%"><div align="right"><b>Total Qty System </b></div></td>
                                                            <td width="17%">&nbsp;</td>
                                                            <td width="23%"><div align="right">
                                                              <input type="text" name="total_system" readOnly class="readOnly" value="<%=subTotalSystem%>" style="text-align:right">
                                                            </div>
                                                            <%
																double totalBalance = subTotalReal - subTotalSystem;
															%></td>
                                                          </tr>
                                                          <tr>
                                                            <td><div align="right"><b>Total Qty Balance </b></div></td>
                                                            <td>&nbsp;</td>
                                                            <td><div align="right">
                                                              <input type="text" name="total_balance" readOnly class="readOnly" value="<%=totalBalance%>" style="text-align:right">
                                                            </div>
                                                            <%//prOrder.setSubTotal(subTotal);%></td>
                                                          </tr>
                                                      </table>                                                      </td>
                                                    </tr>
                                                  </table>                                                </td>
                                              </tr>
                                              <%if(opname.getOID()!=0){%>
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
                                                        <%if(opname.getOID()!=0){%>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%if( (!opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0)){%>
                                                          <tr> 
                                                            <td width="12%"><b>Set 
                                                              Status to</b> </td>
                                                            <td width="14%"> 
                                                              <select name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if( opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                <%if(posApprove1Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if( opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                <%}%>
                                                                
                                                              </select>                                                            </td>
                                                            <td width="74%">&nbsp; </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%}%>
                                                        </table>
                                                        <%}%>                                                      </td>
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
															if(opname.getOID()!=0){
													%>
                                                    <tr> 
                                                      <td colspan="4" class="errfont"><%=msgString%></td>
                                                    </tr>
                                                    <%		}%>
                                                    <%if(stockItems!=null && stockItems.size()>0){
														if(opname.getOID()!=0){
													%>
                                                    <tr> 
                                                      <%if( !opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0){%>
                                                      <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                      <td width="102" > 
                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>                                                      </td>
                                                      <%}%>
                                                      <td width="97"> 
                                                        <div align="left"><a href="javascript:cmdPrintPdf()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>                                                      </td>
                                                    </tr>
                                                    <%}}else{%>
                                                    <tr> 
                                                      <td colspan="2" nowrap> 
                                                        <div align="left"><font color="#FF0000"><i>No 
                                                          item stock for opname 
                                                          </i></font></div>
                                                      </td>
                                                      <td width="97"> 
                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211112" border="0"></a></div>                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"></div>                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <%}%>
                                                  </table>                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <%if(opname.getOID()!=0){%>
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
													u = DbUser.fetch(opname.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i><%=JSPFormater.formatDate(opname.getDate(), "dd MMMM yy")%></i></div>
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
													u = DbUser.fetch(opname.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%if(opname.getApproval1()!=0){%>
                                                          <%=JSPFormater.formatDate(opname.getApproval1_date(), "dd MMMM yy")%> 
                                                          <%}%>
                                                          </i></div>
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
							if(stockItems!=null && stockItems.size()>0){
							if(iErrCode2==0 &&(opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && opnameItem.getOID()!=0) || iErrCode!=0))){%>
                            	parserMaster();
							<%}
							}%>
                          </script>
                          <script language="JavaScript">
						    <%if(opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && opnameItem.getOID()!=0) || iErrCode!=0)){%>
									//alert('in here');
									//cmdChangeItem();																		
							<%}							
							if(opname.getOID()!=0 && !opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>
									//cmdClosedReason();
							<%}%>
							</script>
							
							<%
								//session.putValue("TRANSFER_TITTLE",prOrder);
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
