
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
<%@ page import = "com.project.system.*" %>
<%//@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>

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

	public Vector drawList(int iJSPCommand,JspPurchaseRequestItem frmObject, PurchaseRequestItem objEntity, Vector objectClass, long purchaseRequestItemId, String status, long itemMasterId)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("80%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No","3%");
		jsplist.addHeader("Product - Item","28%");	
                jsplist.addHeader("SKU/Barcode","10%");	
		jsplist.addHeader("Group","13%");
		jsplist.addHeader("Category","13%");		
		jsplist.addHeader("Qty","7%");
		jsplist.addHeader("Unit","11%");
		jsplist.addHeader("PO Status","12%");

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
                whereCls = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY]+"=1";//+
				   //" and "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"!="+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+
				   //" and "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"!="+I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
				   
				   
				   
		Vector vect_master = DbItemMaster.list(0,1, whereCls, "");
		
		//System.out.println("vect_master : "+vect_master);
		
		Vector vect_value = new Vector(1,1);
		Vector vect_key = new Vector(1,1);
		if(vect_master!=null && vect_master.size()>0){
			for(int i=0; i<vect_master.size(); i++){
				ItemMaster ig = (ItemMaster)vect_master.get(i);
				vect_key.add(""+ig.getCode()+" - "+ig.getName());
				vect_value.add(""+ig.getOID());
			}
		}

		//vector untuk ambil data
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
			 PurchaseRequestItem purchaseRequestItem = (PurchaseRequestItem)objectClass.get(i);
			 
			 //Buat instansiasi object untuk menampung datanya
			 SessPurchaseRequestL prL = new  SessPurchaseRequestL();
			 			 
			 rowx = new Vector();
			 if(purchaseRequestItemId == purchaseRequestItem.getOID())
			 	 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
                                //objEntity.setItemMasterId(itemMasterId);
                                if(itemMasterId!=0){
                                                objEntity.setItemMasterId(itemMasterId);
                                }
                                ItemMaster colCombo2  = new ItemMaster();
                
                                try{
                                        colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

                                }catch(Exception e) {
                                        System.out.println(e);
                                }
				//rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_ITEM_MASTER_ID],null, ""+purchaseRequestItem.getItemMasterId(), vect_value , vect_key, "formElemen onChange=\"javascript:cmdChangeItem()\"", "")+"</div>");				
                                rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" onChange=\"javascript:cmdAddItemMaster()\" size=\"35\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a>");
                                rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"15\" name=\"jsp_code_item\" value=\""+colCombo2.getCode()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onChange=\"javascript:cmdAddItemMaster2()\"></div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"17\" name=\"group\" style=\"text-align:center\" value=\"\" readOnly class=\"readOnly\"></div>");//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"17\" name=\"category\" style=\"text-align:center\"  value=\"\" readOnly class=\"readOnly\"></div>");//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");				
				rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"3\" style=\"text-align:right\"  name=\""+frmObject.colNames[JspPurchaseRequestItem.JSP_QTY] +"\" value=\""+purchaseRequestItem.getQty()+"\" class=\"formElemen\" onClick=\"this.select()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY)+"</div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"10\" name=\"uom\" style=\"text-align:center\"  value=\"\" readOnly class=\"readOnly\"></div>");
				rowx.add("<div align=\"center\">"+((purchaseRequestItem.getItemStatus()==-1) ? "-" : DbPurchaseRequestItem.strItemStatus[purchaseRequestItem.getItemStatus()])+"</div>");
			 }else{
				ItemMaster itemMaster = new ItemMaster();
				try{
					itemMaster = DbItemMaster.fetchExc(purchaseRequestItem.getItemMasterId());
				}catch(Exception e){}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(purchaseRequestItem.getUomId());
				}catch(Exception e){}
				ItemGroup ig = new ItemGroup();
				ItemCategory ic  = new ItemCategory();
				try{
					ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
					ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
				}
				catch(Exception e){
				}
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");		
				if(status.equals(I_Project.DOC_STATUS_DRAFT )){
                                rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(purchaseRequestItem.getOID())+"')\">"+itemMaster.getCode()+" - "+itemMaster.getName()+"</a>");				
					prL.setProduct(itemMaster.getCode()+" - "+itemMaster.getName());
				}
				else{
					rowx.add(itemMaster.getCode()+" - "+itemMaster.getName());
					prL.setProduct(itemMaster.getCode()+" - "+itemMaster.getName());				
				}
                                rowx.add(itemMaster.getCode()+"/"+itemMaster.getBarcode());
				rowx.add(ig.getName());
				    prL.setGroup(ig.getName());
				rowx.add(ic.getName());
				    prL.setCategory(ic.getName());				
				rowx.add("<div align=\"center\">"+purchaseRequestItem.getQty()+"</div>");
				    prL.setQty(purchaseRequestItem.getQty());
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");
				    prL.setUnit(uom.getUnit());
				rowx.add("<div align=\"center\">"+((purchaseRequestItem.getItemStatus()==-1) ? "-" : DbPurchaseRequestItem.strItemStatus[purchaseRequestItem.getItemStatus()])+"</div>");
			        prL.setPoStatus(purchaseRequestItem.getItemStatus());
			 } 

			lstData.add(rowx);
			temp.add(prL);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
                    rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
                    objEntity.setItemMasterId(itemMasterId);
                                ItemMaster colCombo2  = new ItemMaster();
                
                                try{
                                        colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

                                }catch(Exception e) {
                                        System.out.println(e);
                                }
                    //rowx.add("<div align=\"left\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "formElemen onChange=\"javascript:cmdChangeItem()\"", "")+"</div>");                    
                    rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" onChange=\"javascript:cmdAddItemMaster()\" size=\"35\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a>");
                                    rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"15\" name=\"jsp_code_item\" value=\""+colCombo2.getCode()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onChange=\"javascript:cmdAddItemMaster2()\"></div>");
                    rowx.add("<div align=\"center\"><input type=\"text\" size=\"17\" name=\"group\" style=\"text-align:center\" value=\"\" readOnly class=\"readOnly\"></div>");//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
					rowx.add("<div align=\"center\"><input type=\"text\" size=\"17\" name=\"category\" style=\"text-align:center\"  value=\"\" readOnly class=\"readOnly\"></div>");//rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspPurchaseRequestItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");					
					rowx.add("<div align=\"center\">"+"<input type=\"text\" style=\"text-align:right\"  size=\"3\" name=\""+frmObject.colNames[JspPurchaseRequestItem.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" onClick=\"this.select()\">"+frmObject.getErrorMsg(frmObject.JSP_QTY)+"</div>");
					rowx.add("<div align=\"center\"><input type=\"text\" size=\"10\" name=\"uom\" style=\"text-align:center\"  value=\"\" readOnly class=\"readOnly\"></div>");
					rowx.add("<div align=\"center\">-</div>");
		}

		lstData.add(rowx);

		//return jsplist.draw(index);
		//vector baru 
		Vector v = new Vector();
		v.add(jsplist.draw(index));
		v.add(temp);
		
		return v ;
	}

%>

<%

//purchase request main data

    if(session.getValue("PURCHASE_TITTLE")!=null){
		session.removeValue("PURCHASE_TITTLE");
	}
	
	if(session.getValue("PURCHASE_DETAIL")!=null){
		session.removeValue("PURCHASE_DETAIL");
	}


int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchaseRequest = JSPRequestValue.requestLong(request, "hidden_purchase_request_id");
long itemMasterId = JSPRequestValue.requestLong(request, JspPurchaseRequestItem.colNames[JspPurchaseRequestItem.JSP_ITEM_MASTER_ID]);
String srcCode = JSPRequestValue.requestString(request, "jsp_code_item");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchaseRequest =0;
}

//out.println("iJSPCommand : "+iJSPCommand);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

//record data dengan entity
SessPurchaseRequest pr = new SessPurchaseRequest();

CmdPurchaseRequest ctrlPurchaseRequest = new CmdPurchaseRequest(request);
JSPLine ctrLine = new JSPLine();
iErrCode = ctrlPurchaseRequest.action(iJSPCommand , oidPurchaseRequest);
JspPurchaseRequest jspPurchaseRequest = ctrlPurchaseRequest.getForm();
PurchaseRequest purchaseRequest = ctrlPurchaseRequest.getPurchaseRequest();
msgString =  ctrlPurchaseRequest.getMessage();
        
if(oidPurchaseRequest==0){
    oidPurchaseRequest = purchaseRequest.getOID();
	purchaseRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
}

//out.println("msgString : "+msgString);

//out.println("oidPurchaseRequest : "+oidPurchaseRequest);

//whereClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+oidPurchaseRequest;
//orderClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID];
//Vector purchReqItems = DbPurchaseRequestItem.list(0,0, whereClause, orderClause);
//Vector deps = DbDepartment.list(0,0, "", "code");

%>

<%

//purchase request detail

long oidPurchaseRequestItem = JSPRequestValue.requestLong(request, "hidden_purchase_request_item_id");
//out.println("<br>oidPurchaseRequestItem : "+oidPurchaseRequestItem);

CmdPurchaseRequestItem ctrlPurchaseRequestItem = new CmdPurchaseRequestItem(request);
//JSPLine ctrLine = new JSPLine();
int iErrCode2 = ctrlPurchaseRequestItem.action(iJSPCommand , oidPurchaseRequestItem, oidPurchaseRequest);
JspPurchaseRequestItem jspPurchaseRequestItem = ctrlPurchaseRequestItem.getForm();
PurchaseRequestItem purchaseRequestItem = ctrlPurchaseRequestItem.getPurchaseRequestItem();
String msgString2 =  ctrlPurchaseRequestItem.getMessage();

//out.println(jspPurchaseRequestItem.getErrors());

whereClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+oidPurchaseRequest;
orderClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID];
Vector purchReqItems = DbPurchaseRequestItem.list(0,0, whereClause, orderClause);
Vector deps = DbDepartment.list(0,0, "level=2", "code");

String where = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY]+"=1";//+
			   //" and "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"!="+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+
			   //" and "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"!="+I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
			   
Vector itemForBuy = DbItemMaster.list(0,1, where, DbItemMaster.colNames[DbItemMaster.COL_CODE]);

//out.println("itemForBuy : "+itemForBuy);

if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchaseRequestItem = 0;
        srcCode="";
        itemMasterId=0;
	purchaseRequestItem = new PurchaseRequestItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidPurchaseRequestItem = 0;
	purchaseRequestItem = new PurchaseRequestItem();
}

if(purchaseRequest.getStatus().length()==0){
	purchaseRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
}

int vectSize=0;
            if(iJSPCommand != JSPCommand.SAVE && iJSPCommand!=JSPCommand.POST){
            if(srcCode.length()>0){
               vectSize  = DbItemMaster.getCount(" code like '%"+ srcCode+"%'");
                if(vectSize==1){
                   Vector vlist = DbItemMaster.list(0, 1," code like '%"+ srcCode+"%' || barcode like '%"+srcCode+"%'" , "");
                   ItemMaster itemMaster = (ItemMaster) vlist.get(0);
                   itemMasterId= itemMaster.getOID();
                }
            }
           }





%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
function cmdPrintPdf(){
	//window.open();
	window.open("<%=printroot%>.report.RptPurchaseRequestPdf?oid=<%=oidPurchaseRequestItem%>&mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
}

<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdClosedReason(){
	var st = document.frmpurchaserequest.<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdToRecord(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.NONE%>";
	document.frmpurchaserequest.action="purchaserequestlist.jsp";
	document.frmpurchaserequest.submit();
}


function cmdChangeItem(){
	var oid = document.frmpurchaserequest.<%=jspPurchaseRequestItem.colNames[JspPurchaseRequestItem.JSP_ITEM_MASTER_ID]%>.value;
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
					
					 document.frmpurchaserequest.uom.value="<%=purUom.getUnit()%>";	
					 document.frmpurchaserequest.group.value="<%=ig.getName()%>";	
					 document.frmpurchaserequest.category.value="<%=ic.getName()%>";	
					<%		
				}
				catch(Exception e){
					System.out.println(e);
				}
				%>
			}	
	<%}}%>
}

function cmdCloseDoc(){
	document.frmpurchaserequest.action="<%=approot%>/home.jsp";
	document.frmpurchaserequest.submit();
}

function cmdAskDoc(){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value="0";
	document.frmpurchaserequest.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdDeleteDoc(){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value="0";
	document.frmpurchaserequest.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdCancelDoc(){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value="0";
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdAdd(){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value="0";
	document.frmpurchaserequest.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdAsk(oidPurchaseRequestItem){
	//if(confirm("Are you sure to delete this data ?")){
		document.frmpurchaserequest.hidden_purchase_request_item_id.value=oidPurchaseRequestItem;
		document.frmpurchaserequest.command.value="<%=JSPCommand.ASK%>";
		
		document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
		document.frmpurchaserequest.action="purchaserequestitem.jsp";
		document.frmpurchaserequest.submit();
	//}
}

function cmdAskMain(oidPurchaseRequestItem){
	document.frmpurchaserequest.hidden_purchase_reques_item_id.value=oidPurchaseRequestItem;
	document.frmpurchaserequest.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
}

function cmdConfirmDelete(oidPurchaseRequestItem){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value=oidPurchaseRequestItem;
	document.frmpurchaserequest.command.value="<%=JSPCommand.DELETE%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdSaveDoc(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.POST%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdSave(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdSaveMain(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
}

function cmdEdit(oidPurchaseRequestItem){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value=oidPurchaseRequestItem;
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdCancel(oidPurchaseRequestItem){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value=oidPurchaseRequestItem;
	document.frmpurchaserequest.command.value="<%=JSPCommand.CANCEL%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}
 
        
function cmdAddItemMaster(){  
         
            var itemName =document.frmpurchaserequest.X_JSP_ITEM_MASTER_ID.value;
            document.frmpurchaserequest.jsp_code_item.value="";
            
            window.open("<%=approot%>/postransaction/addItemPR.jsp?item_name=" + itemName, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            
            //document.frmpurchase.submit();    
     }
     function cmdAddItemMaster3(){            
            var itemCode =document.frmpurchaserequest.hidden_item_code.value;
            document.frmpurchaserequest.jsp_code_item.value=""; 
            window.open("<%=approot%>/postransaction/addItemPR.jsp?item_code=" + itemCode, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            
     }
        
     function cmdAddItemMaster2(){            
             
            
            document.frmpurchaserequest.JSP_ITEM_MASTER_ID.value=0;
            
            
            document.frmpurchaserequest.submit(); 
     }        
     

function cmdBack(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
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
                        <form name="frmpurchaserequest" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="<%=JspPurchaseRequestItem.colNames[JspPurchaseRequestItem.JSP_PURCHASE_REQUEST_ID]%>" value="<%=oidPurchaseRequest%>">
                          <input type="hidden" name="hidden_purchase_request_id" value="<%=oidPurchaseRequest%>">
                          <input type="hidden" name="hidden_purchase_request_item_id" value="<%=oidPurchaseRequestItem%>">
                          <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" > 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Purchase 
                                      Request</span></font></b></td>
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
                                    <td height="5" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Purchase 
                                              Request &nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" valign="middle" width="33%">&nbsp;</td>
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" colspan="2" width="45%" class="comment" valign="top"> 
                                            <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                              <%if(purchaseRequest.getOID()==0){%>
                                              Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                              <%}else{
											User us = new User();
											try{
												us = DbUser.fetch(purchaseRequest.getUserId());
											}
											catch(Exception e){
											}
											%>
                                              Prepared By : <%=us.getLoginId()%> 
                                              <%}%>
                                              &nbsp;&nbsp;&nbsp;</div>
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="26" valign="middle" width="10%">&nbsp;&nbsp;Department</td>
                                          <td height="26" valign="middle" width="33%"> 
                                            <select name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_DEPARTMENT_ID]%>">
                                              <%
											  if(deps!=null && deps.size()>0){
											  	for(int i=0; i<deps.size(); i++){
											  		Department d = (Department)deps.get(i);
													String str = "";
													/*if(d.getLevel()==1){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel()==2){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel()==3){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}*/	
													
													if(purchaseRequest.getDepartmentId()==d.getOID()){
														pr.setDepartment(d.getName());
													}
													
													%>
                                              <option value="<%=d.getOID()%>" <%if(purchaseRequest.getDepartmentId()==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td height="26" width="12%">Number</td>
                                          <td height="26" colspan="2" width="45%" class="comment"> 
                                            <%
										  String number = "";
										  if(purchaseRequest.getOID()==0){
										  	  int ctr = DbPurchaseRequest.getNextCounter();
											  number = DbPurchaseRequest.getNextNumber(ctr);
											  pr.setNumber(number);
										  }
										  else{
										  	  number = purchaseRequest.getNumber();
											  pr.setNumber(number);
										  }
										  %>
                                            <%=number%></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="10%">&nbsp;&nbsp;Date</td>
                                          <td height="21" valign="middle" width="33%"> 
                                            <input name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_DATE]%>" value="<%=JSPFormater.formatDate((purchaseRequest.getDate()==null) ? new Date() : purchaseRequest.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpurchaserequest.<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            <%pr.setDate(purchaseRequest.getDate());%>
                                          </td>
                                          <td width="12%">Document &nbsp;Status</td>
                                          <td width="45%" colspan="2" class="comment"> 
                                            <%
											if(purchaseRequest.getStatus()==null){
												//out.println("status = null, set to draft");
												purchaseRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
											}	
											%>
                                            <input type="text" class="readOnly" name="stt" value="<%=(purchaseRequest.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((purchaseRequest.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : purchaseRequest.getStatus())%>" size="15" readOnly>
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="5" colspan="5"></td>
                                        <tr align="left"> 
                                          <td height="21" width="10%">&nbsp;&nbsp;Notes</td>
                                          <td height="21" valign="top" colspan="4"> 
                                            <textarea name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_NOTE]%>" cols="50" rows="2"><%=purchaseRequest.getNote()%></textarea>
                                            <%pr.setNotes(purchaseRequest.getNote());%>
                                          </td>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top" height="5"></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <%try{
										  //out.println("purchaseRequest.getStatus() : "+purchaseRequest.getStatus());
										  %>
                                            &nbsp; 
                                            <%
												Vector x = drawList(iJSPCommand,jspPurchaseRequestItem, purchaseRequestItem, purchReqItems, oidPurchaseRequestItem, purchaseRequest.getStatus(), itemMasterId);
												String strList = (String)x.get(0);
												Vector objRpt = (Vector)x.get(1); 
											%>
                                            <%=strList%> 
                                            <%
												session.putValue("PURCHASE_DETAIL",objRpt);
											%>
                                            <%}catch(Exception ex){
										  		out.println("ex : "+ex.toString());	
										   }%>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <%if((!purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) && (iJSPCommand==JSPCommand.ADD || ((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) && oidPurchaseRequestItem!=0) || iErrCode2!=0)){%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <%      
                                                                        ctrLine = new JSPLine();
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidPurchaseRequestItem+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPurchaseRequestItem+"')";
									String scancel = "javascript:cmdBack('"+oidPurchaseRequestItem+"')";
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
									
									if(iErrCode2!=0){
										iErrCode = iErrCode2;
										if(msgString.length()==0){										
											msgString = msgString2;
										}
									}
									%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <%}%>
                                        <%
										if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) &&
										((iJSPCommand ==JSPCommand.BACK || (iJSPCommand==JSPCommand.EDIT && oidPurchaseRequestItem==0) || 
										iJSPCommand ==JSPCommand.POST || iJSPCommand==JSPCommand.SAVE || 
										iJSPCommand==JSPCommand.DELETE)
										&& (iErrCode2==0))){
																				
										%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <%if(oidPurchaseRequest!=0){%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr > 
                                                      <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="74%">&nbsp;</td>
                                                    </tr>
                                                    <%if( (!purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0)){%>
                                                    <tr> 
                                                      <td width="12%"><b>Set Status 
                                                        to</b> </td>
                                                      <td width="14%"> 
                                                        <select name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                          <%if( purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) || purchaseRequest.getStatus().length()==0){%>
                                                          <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if( purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                          <%}%>
                                                          <%if(posApprove1Priv){%>
                                                          <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if( purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                          <%}%>
                                                          <%if(posApprove4Priv){%>
                                                          <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if( purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
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
                                                  <table width="80%" border="0" cellspacing="0" cellpadding="0" id="closingreason">
                                                    <tr> 
                                                      <td width="12%"><b>Close 
                                                        Reason</b></td>
                                                      <td width="88%"> 
                                                        <%if( (!purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0)){%>
                                                        <textarea name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_CLOSED_REASON]%>" cols="50"><%=(purchaseRequest.getClosedReason()==null) ? "" : purchaseRequest.getClosedReason()%></textarea>
                                                        * <%=jspPurchaseRequest.getErrorMsg(JspPurchaseRequest.JSP_CLOSED_REASON)%> 
                                                        <%}else{%>
                                                        <i><%=(purchaseRequest.getClosedReason()==null) ? "" : purchaseRequest.getClosedReason()%> </i> 
                                                        <%}%>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="88%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%if(iJSPCommand==JSPCommand.SUBMIT){%>
                                              <tr> 
                                                <td colspan="3">Are you sure to 
                                                  delete document ?</td>
                                                <td width="862">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="149"><a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                <td width="102"><a href="javascript:cmdCancelDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                <td width="97">&nbsp;</td>
                                                <td width="862">&nbsp;</td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td colspan="4" class="errfont"><%=msgString%></td>
                                              </tr>
                                              <tr> 
                                                <%if( !purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0){%>
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
                                        <%}%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                              <tr > 
                                                <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="74%">&nbsp;</td>
                                              </tr>
                                              <%if( (!purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE) || iErrCode!=0)){%>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
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
                                                <td width="33%" class="tablecell1">Prepared 
                                                  By</td>
                                                <td width="34%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <%
												User u = new User();
												try{
													u = DbUser.fetch(purchaseRequest.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                    <%=u.getLoginId()%></div>
                                                </td>
                                                <td width="33%" class="tablecell1"> 
                                                  <div align="center"><%=JSPFormater.formatDate(purchaseRequest.getDate(), "dd MMMM yy")%></div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="33%" class="tablecell1">Approved 
                                                  by</td>
                                                <td width="34%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <%
												 u = new User();
												try{
													u = DbUser.fetch(purchaseRequest.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                    <%=u.getLoginId()%></div>
                                                </td>
                                                <td width="33%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <%if(purchaseRequest.getApproval1()!=0){%>
                                                    <%=JSPFormater.formatDate(purchaseRequest.getApproval1Date(), "dd MMMM yy")%> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="33%" class="tablecell1">Closed 
                                                  By</td>
                                                <td width="34%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <div align="center"> 
                                                      <%
												u = new User();
												try{
													u = DbUser.fetch(purchaseRequest.getApproval2());
												}
												catch(Exception e){
												}
												%>
                                                      <%=u.getLoginId()%></div>
                                                  </div>
                                                </td>
                                                <td width="33%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <div align="center"> 
                                                      <%if(purchaseRequest.getApproval2()!=0){%>
                                                      <%=JSPFormater.formatDate(purchaseRequest.getApproval2Date(), "dd MMMM yy")%> 
                                                      <%}%>
                                                    </div>
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
                          <script language="JavaScript">
						    <%if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && purchaseRequestItem.getOID()!=0) || iErrCode!=0)){%>
									//alert('in here');
									cmdChangeItem();																		
							<%}							
							if(purchaseRequest.getOID()!=0 && !purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>
									cmdClosedReason();
							<%}%>
							</script>
							
							<%}
							catch(Exception e){
								out.println(e.toString());
							}%>
							
							<%
							    //session laporan
								session.putValue("PURCHASE_TITTLE",pr);
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
        <%if(vectSize>1){%>
                                                            <script language="JavaScript">
                                                                cmdAddItemMaster3();
                                                            </script>
                                                            <%}%>
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
