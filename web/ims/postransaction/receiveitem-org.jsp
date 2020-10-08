
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
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
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspReceiveItem frmObject, 
                ReceiveItem objEntity, Vector objectClass, 
                long purchaseItemId, String approot, long oidVendor)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No","2%"); 
		jsplist.addHeader("Code/Name","15%");
		jsplist.addHeader("Price","5%");
		jsplist.addHeader("Qty","3%");
		jsplist.addHeader("Uom","5%");
		jsplist.addHeader("Discount","5%");
		jsplist.addHeader("Total","8%");

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
                Vector vect_vend_master = DbVendorItem.list(0, 0, whereCls, "");
		Vector vect_value = new Vector(1,1);
		Vector vect_key = new Vector(1,1);
		if(vect_vend_master!=null && vect_vend_master.size()>0){
			for(int i=0; i<vect_vend_master.size(); i++){
				VendorItem ig = (VendorItem)vect_vend_master.get(i);
                                ItemMaster im = new ItemMaster();
                                try{
                                    im = DbItemMaster.fetchExc(ig.getItemMasterId());
                                    vect_key.add(""+im.getCode()+" / "+im.getName());
                                    vect_value.add(""+im.getOID()+"_"+im.getCogs());
                                    }catch(Exception e){}
			}
		}

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
			 ReceiveItem purchaseItem = (ReceiveItem)objectClass.get(i);
			 rowx = new Vector();
			 if(purchaseItemId == purchaseItem.getOID())
			 	 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
                                ItemMaster im = new ItemMaster();
                                try{
                                    im = DbItemMaster.fetchExc(purchaseItem.getItemMasterId());
                                    }catch(Exception ee){}
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");	
                                rowx.add("<div align=\"left\">"+JSPCombo.draw(JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]+"_1",null, ""+purchaseItem.getItemMasterId()+"_"+im.getCogs(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+"<input type=\"hidden\" size=\"12\" name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID] +"\" value=\""+purchaseItem.getItemMasterId()+"\" class=\"formElemen\"></div>");                                
                                rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT] +"\" value=\""+purchaseItem.getAmount()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                                rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"4\" name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+purchaseItem.getQty()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                                rowx.add("<div align=\"right\">"+JSPCombo.draw(JspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID],null, ""+purchaseItem.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
                                rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+purchaseItem.getTotal_discount()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                                rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] +"\" value=\""+purchaseItem.getTotal_amount()+"\" class=\"formElemen\">"+"</div>");
			 }else{
				ItemMaster itemMaster = new ItemMaster();
				try{
					itemMaster = DbItemMaster.fetchExc(purchaseItem.getItemMasterId());
				}catch(Exception e){}
                                
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(purchaseItem.getUomId());
				}catch(Exception e){}
                                rowx.add("<div align=\"center\">"+(i+1)+"</div>");		
                                rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(purchaseItem.getOID())+"')\">"+itemMaster.getCode()+" / "+itemMaster.getName()+"</a>");
                                rowx.add("<div align=\"right\">"+purchaseItem.getAmount()+"</div>");
                                rowx.add("<div align=\"right\">"+purchaseItem.getQty()+"</div>");
                                rowx.add("<div align=\"right\">"+uom.getUnit()+"</div>");
				rowx.add("<div align=\"right\">"+purchaseItem.getTotal_discount()+"</div>");
				rowx.add("<div align=\"right\">"+purchaseItem.getTotal_amount()+"</div>");
			 } 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
                        rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
                        rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]+"_1",null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+"<input type=\"hidden\" size=\"12\" name=\""+frmObject.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID] +"\" value=\""+objEntity.getItemMasterId()+"\" class=\"formElemen\"></div>");                                
                        rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+frmObject.colNames[JspReceiveItem.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                        rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"4\" name=\""+frmObject.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                        rowx.add("<div align=\"right\">"+JSPCombo.draw(frmObject.colNames[JspReceiveItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
                        rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+objEntity.getTotal_discount()+"\" onkeyUp=\"javascript:calculate()\" class=\"formElemen\">"+"</div>");
                        rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"12\" name=\""+frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] +"\" value=\""+objEntity.getTotal_amount()+"\" class=\"formElemen\">"+"</div>");
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}%>

<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidReceive =0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdReceive cmdReceive = new CmdReceive(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdReceive.action(iJSPCommand , oidReceive);
JspReceive jspReceive = cmdReceive.getForm();
Receive purchase = cmdReceive.getReceive();
msgString =  cmdReceive.getMessage();
        
if(oidReceive==0){
    oidReceive = purchase.getOID();
	purchase.setStatus(I_Project.DOC_STATUS_DRAFT);
}

whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+oidReceive;
orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
Vector purchReqItems = DbReceiveItem.list(0,0, whereClause, orderClause);

Vector exchanges = DbExchangeRate.list(0,0, "", DbExchangeRate.fieldNames[DbExchangeRate.FLD_DATE]+" desc ");
ExchangeRate exchangeRate = new ExchangeRate();
if(exchanges.size()>0){
    exchangeRate = (ExchangeRate)exchanges.get(0);
}


%>	
<%
//int iJSPCommand = JSPRequestValue.requestCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
//long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");


/*variable declaration*/
///int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";
//System.out.println("jaskjhdfajkshdfjkhasjkdf : "+oidReceive);
//System.out.println("jaskjhdfajkshdfjkhasjkdf ************ ");

CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);
//JSPLine ctrLine = new JSPLine();
iErrCode2 = cmdReceiveItem.action(iJSPCommand , oidReceiveItem);
JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
ReceiveItem purchaseItem = cmdReceiveItem.getReceiveItem();
msgString2 =  cmdReceiveItem.getMessage();

whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+oidReceive;
orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
Vector purchItems = DbReceiveItem.list(0,0, whereClause, orderClause);
//Vector deps = DbDepartment.list(0,0, "", "code");

if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidreceiveItem = 0;
	receiveItem = new receiveItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidreceiveItem = 0;
	receiveItem = new receiveItem();
}

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--

<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdClosedReason(){
	var st = document.frmreceive.<%=Jspreceive.colNames[Jspreceive.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdToRecord(){
	document.frmreceive.command.value="<%=JSPCommand.NONE%>";
	document.frmreceive.action="receivelist.jsp";
	document.frmreceive.submit();
}


function cmdChangeItem(){
	var oid = document.frmreceive.<%=jspreceiveItem.colNames[JspreceiveItem.JSP_ITEM_MASTER_ID]%>.value;
	//alert(oid);
	<%
	if(itemForBuy!=null && itemForBuy.size()>0){
		for(int i=0; i<itemForBuy.size(); i++){
			ItemMaster im =  (ItemMaster)itemForBuy.get(i);			
	%>
			if(oid=='<%=im.getOID()%>'){
				//alert('ketemu');
				<%
				try{
					Uom purUom = DbUom.fetchExc(im.getUomPurchaseId());
					ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
					ItemCategory ic = DbItemCategory.fetchExc(im.getItemCategoryId());
				    %>
					//alert('<%=purUom.getUnit()%>');
					 document.frmreceive.uom.value="<%=purUom.getUnit()%>";	
					 document.frmreceive.group.value="<%=ig.getName()%>";	
					 document.frmreceive.category.value="<%=ic.getName()%>";	
					<%		
				}
				catch(Exception e){
				}
				%>
			}	
	<%}}%>
}

function cmdCloseDoc(){
	document.frmreceive.action="<%=approot%>/home.jsp";
	document.frmreceive.submit();
}

function cmdAskDoc(){
	document.frmreceive.hidden_purchase_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdDeleteDoc(){
	document.frmreceive.hidden_purchase_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdCancelDoc(){
	document.frmreceive.hidden_purchase_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}



function calculate(){
    var amount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
    if(amount=='')
        amount = 0;
    
    var discount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
    if(discount=='')
        discount = 0;

    var qty = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
    if(qty=='')
        qty = 0;

    var total = (parseFloat(amount) - parseFloat(discount)) * parseFloat(qty);
    if(total=='NaN')
        total = 0;
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = parseFloat(total);
}
    
function getRate(){
    var oid = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>.value;
    switch(oid){
        case '<%=exchangeRate.getCurrencyIdrId()%>':
            return <%=exchangeRate.getValueIdr()%>;
            break;
        case '<%=exchangeRate.getCurrencyEuroId()%>':
            return <%=exchangeRate.getValueEuro()%>;
            break;
        case '<%=exchangeRate.getCurrencyUsdId()%>':
            return <%=exchangeRate.getValueUsd()%>;
            break;
        default:    
            return 0;
            break;
        }
    }

function parserMaster(){
    var rate = getRate();
    var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>_1.value;
    var str1 = str.substring(0, str.indexOf("_"));
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value=str1;
    var str2 = str.substring(str.indexOf("_")+1, str.length);
    str2 = parseFloat(str2) / parseFloat(rate);
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value=str2;
}

function checkRate(){
    var oid = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>.value;
    switch(oid){
        case '<%=exchangeRate.getCurrencyIdrId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueIdr()%>';
            break;
        case '<%=exchangeRate.getCurrencyEuroId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueEuro()%>';
            break;
        case '<%=exchangeRate.getCurrencyUsdId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueUsd()%>';
            break;
        default:    
            document.all.exc_rate.innerHTML = 'Used Rate :';
            break;
        }
    }

function cmdAdd(){
	document.frmreceive.hidden_receive_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.ADD%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdAsk(oidReceiveItem){
	document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
	document.frmreceive.command.value="<%=JSPCommand.ASK%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdAskMain(oidReceive){
	document.frmreceive.hidden_receive_id.value=oidReceive;
	document.frmreceive.command.value="<%=JSPCommand.ASK%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receive.jsp";
	document.frmreceive.submit();
}

function cmdConfirmDelete(oidReceiveItem){
	document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
	document.frmreceive.command.value="<%=JSPCommand.DELETE%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}
function cmdSaveMain(){
	document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receive.jsp";
	document.frmreceive.submit();
	}

function cmdSave(){
	document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdEdit(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdCancel(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdBack(){
	document.frmreceive.command.value="<%=JSPCommand.BACK%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdListFirst(){
	document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdListPrev(){
	document.frmreceive.command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
	}

function cmdListNext(){
	document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.action="receiveitem.jsp";
	document.frmreceive.submit();
}

function cmdListLast(){
	document.frmreceive.command.value="<%=JSPCommand.LAST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
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
<body onLoad="MM_preloadImages('&lt;%=approot%&gt;/images/home2.gif','&lt;%=approot%&gt;/images/logout2.gif','../images/new2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" -->Transaction 
                        &raquo; <span class="level2">Incoming Goods<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmreceive" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                          <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                          <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Incoming 
                                              Goods&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" valign="middle" width="30%">&nbsp;</td>
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                            <div align="right"><i>Date : <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
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
                                          <td height="26" width="12%">&nbsp;</td>
                                          <td height="26" width="30%">&nbsp;</td>
                                          <td height="26" width="11%">&nbsp;</td>
                                          <td height="26" colspan="2" width="47%" class="comment">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="26" width="12%">&nbsp;&nbsp;Vendor</td>
                                          <td height="26" width="30%"> 
                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>">
                                              <%                                          Vector vendors = DbVendor.list(0,0, "", "code");
											  if(vendors!=null && vendors.size()>0){
											  	for(int i=0; i<vendors.size(); i++){
											  		Vendor d = (Vendor)vendors.get(i);
													%>
                                              <option value="<%=d.getOID()%>" <%if(purchase.getVendor_id()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td height="26" width="11%">Number</td>
                                          <td height="26" colspan="2" width="47%" class="comment"><%=purchase.getNumber()%></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21">&nbsp;&nbsp;Location</td>
                                          <td height="21"> 
                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                              <%                                          Vector locations = DbLocation.list(0,0, "", "code");
											  if(locations!=null && locations.size()>0){
											  	for(int i=0; i<locations.size(); i++){
											  		Location d = (Location)locations.get(i);
													%>
                                              <option value="<%=d.getOID()%>" <%if(purchase.getLocation_id()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td>Status</td>
                                          <td colspan="2" class="comment"> 
                                            <% 
                                                Vector status_value = new Vector(1,1);
						Vector status_key = new Vector(1,1);
					 	String sel_status = ""+purchase.getStatus();
                                                status_key.add(DbReceive.strStatus[DbReceive.STATUS_DRAFT]);
                                                status_value.add(DbReceive.strStatus[DbReceive.STATUS_DRAFT]);
                                                status_key.add(DbReceive.strStatus[DbReceive.STATUS_PROCESS]);
                                                status_value.add(DbReceive.strStatus[DbReceive.STATUS_PROCESS]);
                                                status_key.add(DbReceive.strStatus[DbReceive.STATUS_CLOSE]);
                                                status_value.add(DbReceive.strStatus[DbReceive.STATUS_CLOSE]);
					   %>
                                            <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_STATUS],null, sel_status, status_key, status_value, "", "formElemen") %> </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21">&nbsp;&nbsp;Currency</td>
                                          <td height="21"> 
                                            <%
                                              Vector currs = DbCurrency.list(0, 0, "", "");
                                              Vector exchange_value = new Vector(1,1);
                                                    Vector exchange_key = new Vector(1,1);
                                                    String sel_exchange = ""+purchase.getCurrency_id();
                                                  if(currs!=null && currs.size()>0){
                                                        for(int i=0; i<currs.size(); i++){
                                                            Currency d = (Currency)currs.get(i);
                                                            exchange_key.add(""+d.getOID());
                                                            exchange_value.add(d.getCurrencyCode());
                                                        }
                                                  }          
                                              %>
                                            <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %> 
                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_EXCHANGERATE_ID]%>" value="<%=exchangeRate.getOID()%>">
                                            <a id="exc_rate"></a> </td>
                                          <td width="11%">Include Tax</td>
                                          <td width="47%" colspan="2" class="comment"> 
                                            <% 
                                                Vector include_value = new Vector(1,1);
						Vector include_key = new Vector(1,1);
					 	String sel_include = ""+purchase.getIncluce_tax();
                                                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_NO]);
                                                include_key.add(""+DbReceive.INCLUDE_TAX_NO);
                                                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_YES]);
                                                include_key.add(""+DbReceive.INCLUDE_TAX_YES);
					   %>
                                            <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX],null, sel_include, include_key, include_value, "", "formElemen") %> 
                                            <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>" size="6" value="<%=purchase.getTax_percent()%>">
                                            % </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                          <td height="21" width="30%"> 
                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_RECEIVE_DATE]%>" value="<%=JSPFormater.formatDate((purchase.getReceive_date()==null) ? new Date() : purchase.getReceive_date(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_RECEIVE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                          <td width="11%">Discount</td>
                                          <td width="47%" colspan="2" class="comment"> 
                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=purchase.getDiscount_percent()%>" size="6">
                                            % </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21">&nbsp;&nbsp;Payment 
                                            Type </td>
                                          <td height="21"> 
                                            <% 
                                                Vector payment_value = new Vector(1,1);
						Vector payment_key = new Vector(1,1);
					 	String sel_payment = ""+purchase.getPayment_type();
                                                payment_key.add(DbReceive.strPaymentType[DbReceive.PAYMENT_TYPE_CASH]);
                                                payment_value.add(DbReceive.strPaymentType[DbReceive.PAYMENT_TYPE_CASH]);
                                                payment_key.add(DbReceive.strPaymentType[DbReceive.PAYMENT_TYPE_CREDIT]);
                                                payment_value.add(DbReceive.strPaymentType[DbReceive.PAYMENT_TYPE_CREDIT]);
					   %>
                                            <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE],null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                          <td width="11%">Notes</td>
                                          <td width="47%" colspan="2" class="comment"> 
                                            <textarea name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" cols="40"><%=purchase.getNote()%></textarea>
                                          </td>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <div align="left"> 
                                              <%                                                                        
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAskMain('"+oidReceive+"')";
                                                                        String scomSave = "javascript:cmdSaveMain('"+oidReceive+"')";
									String sconDelCom = "javascript:cmdConfirmDeleteMain('"+oidReceive+"')";
									String scancel = "javascript:cmdEditMain('"+oidReceive+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("Delete");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");
									
                                                                        ctrLine.setSaveJSPCommand(scomSave);
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
									ctrLine.setBackCaption("");
									%>
                                              <%//if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                              <%= ctrLine.drawImageOnly(JSPCommand.EDIT, iErrCode, msgString)%> 
                                              <%//}%>
                                            </div>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;&nbsp;List 
                                            of Item Receive</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;<%=drawList(iJSPCommand,jspReceiveItem, purchaseItem, purchItems, oidReceiveItem,approot, purchase.getVendor_id())%></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <%      
                                                                        ctrLine = new JSPLine();
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									scomDel = "javascript:cmdAsk('"+oidReceiveItem+"')";
									sconDelCom = "javascript:cmdConfirmDelete('"+oidReceiveItem+"')";
									scancel = "javascript:cmdBack('"+oidReceiveItem+"')";
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
                                                                        
                                                                        System.out.println("iErrCode : "+iErrCode);
                                                                        System.out.println("iJSPCommand : "+iJSPCommand);
									%>
                                            <%//if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                            <%//}%>
                                          </td>
                                        </tr>
                                        <%if((iJSPCommand ==JSPCommand.BACK)||(iJSPCommand==JSPCommand.SAVE)&&(iErrCode==0)||(iJSPCommand==JSPCommand.BACK)||(iJSPCommand==JSPCommand.DELETE)){%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
                            checkRate();
                            parserMaster();
                            calculate();
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
