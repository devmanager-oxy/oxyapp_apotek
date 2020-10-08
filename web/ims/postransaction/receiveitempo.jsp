
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.report.*" %>
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
/*
	public String drawList(int iJSPCommand,JspReceiveItem jspReceive, 
                ReceiveItem objEntity, Vector objectClass, 
                long receiveItemId, String approot, long oidVendor,
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
		jsplist.addHeader("PO Qty","7%");		
		jsplist.addHeader("Already<br>Rec. Qty","7%");		
		jsplist.addHeader("Qty","7%");		
		jsplist.addHeader("Price","10%");
		jsplist.addHeader("Discount","10%");
		jsplist.addHeader("Total","10%");
		jsplist.addHeader("Unit","7%");
		jsplist.addHeader("Expired Date","16%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

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
			 ReceiveItem receiveItem = (ReceiveItem)objectClass.get(i);
			 rowx = new Vector();
			 if(receiveItemId == receiveItem.getOID())
			 	 index = i; 

			 if(iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK ||  (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && receiveItemId==0))){
					
					//------------			
					rowx.add("<div align=\"center\">"+(i+1)+"</div>");	
					if(vectVendMaster!=null && vectVendMaster.size()>0){
						rowx.add("<div align=\"left\">"+JSPCombo.draw(jspReceive.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+jspReceive.getErrorMsg(jspReceive.JSP_ITEM_MASTER_ID)+"</div>");                                
					}
					else{
						rowx.add("<font color=\"red\">No receive item available for vendor</font>");
					}
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_AMOUNT] +"\" value=\""+receiveItem.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_AMOUNT)+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+receiveItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+receiveItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+receiveItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+receiveItem.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] +"\" value=\""+receiveItem.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div><input type=\"hidden\" name=\"temp_item_amount\" value=\""+receiveItem.getTotalAmount()+"\">");
					//rowx.add("<div align=\"right\">"+JSPCombo.draw(jspReceive.colNames[JspReceiveItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
					rowx.add("<div align=\"center\"><input name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+"\" value=\""+JSPFormater.formatDate((receiveItem.getExpiredDate()==null) ? new Date() : receiveItem.getExpiredDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
								"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive."+JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");

			 }else{
				ItemMaster itemMaster = new ItemMaster();
				ItemGroup ig = new ItemGroup();
				ItemCategory ic = new ItemCategory();
				try{
					itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
					ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
					ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
				}catch(Exception e){}
                                
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(receiveItem.getUomId());
				}catch(Exception e){}
				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				if(status!=null && status.equals(I_Project.DOC_STATUS_DRAFT)){		
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(receiveItem.getOID())+"')\">"+ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName()+"</a>");
				}
				else{
					rowx.add(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"center\">"+receiveItem.getQty()+"</div>");
				rowx.add("<div align=\"center\">"+receiveItem.getQty()+"</div>");
				rowx.add("<div align=\"center\">"+receiveItem.getQty()+"</div>");
				
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(receiveItem.getTotalDiscount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(receiveItem.getTotalAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");
                rowx.add("<div align=\"center\">"+JSPFormater.formatDate(receiveItem.getExpiredDate(), "dd/MM/yyyy")+"</div>");
			 } 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand != JSPCommand.POST && (iJSPCommand == JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && receiveItemId==0))){ 
				rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
				if(vectVendMaster!=null && vectVendMaster.size()>0){
					rowx.add("<div align=\"left\">"+JSPCombo.draw(jspReceive.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+jspReceive.getErrorMsg(jspReceive.JSP_ITEM_MASTER_ID)+"</div>");                                
				}
				else{
					rowx.add("<font color=\"red\">No receive item available for vendor</font>");
				}
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_AMOUNT)+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspReceive.getErrorMsg(jspReceive.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+objEntity.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspReceive.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] +"\" value=\""+objEntity.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div>");
				//rowx.add("<div align=\"right\">"+JSPCombo.draw(jspReceive.colNames[JspReceiveItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
				rowx.add("<div align=\"center\"><input name=\""+JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+"\" value=\""+JSPFormater.formatDate((objEntity.getExpiredDate()==null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
							"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive."+JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
		}


		lstData.add(rowx);

		return jsplist.draw(index);
	}
	*/
	
	public String removeNumberFormat(String str){
		
		System.out.println("before : "+str);
		
		String result = "";
		for(int i=0; i<str.length(); i++){
			String x = ""+str.charAt(i);
			if(!x.equals(",")){
				result = result + x;
			}
		}
		
		System.out.println("after : "+result);
		
		return result;
	}
	
%>
	
<%

if (session.getValue("PURCHASE_TITTLE") != null) {
                session.removeValue("PURCHASE_TITTLE");
            }

            if (session.getValue("PURCHASE_DETAIL") != null) {
                session.removeValue("PURCHASE_DETAIL");
}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

long oidPO = JSPRequestValue.requestLong(request, "hidden_po_id");
long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
long itemMasterId =JSPRequestValue.requestLong(request, "item_bonus");
long closePo = JSPRequestValue.requestLong(request, "close_po");

SessIncomingGoods igg = new SessIncomingGoods();
//boolean poClose =false;
//if(closePo==1){
 //   poClose=true;
//}


Vector tempt = new Vector();
ItemMaster itemBonus = new ItemMaster();
if(itemMasterId!=0){
    try{
        itemBonus= DbItemMaster.fetchExc(itemMasterId);
    }catch(Exception e){
        
    }
}
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidReceive =0;
}

Purchase po = new Purchase();
try{
	po = DbPurchase.fetchExc(oidPO);
}
catch(Exception e){
}


Vector temp = DbPurchaseItem.list(0,0, "purchase_id="+oidPO, "");

//out.println(temp);

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
Receive receive = cmdReceive.getReceive();
msgString =  cmdReceive.getMessage();
        
if(oidReceive==0){
    oidReceive = receive.getOID();
	if(oidReceive==0){
		receive.setStatus(I_Project.DOC_STATUS_DRAFT);	
	}
}

if(iJSPCommand==JSPCommand.POST){
	
	DbReceiveItem.deleteByReceiveId(oidReceive);
	boolean ok = false;
	
	if(temp!=null && temp.size()>0){
		for(int h=0;h<temp.size();h++){
			
            //PurchaseItem pr = (PurchaseItem)temp.get(h);
            
            String[] txtItemId = null;
            String[] txtPRItemId = null;
            String[] txtQty = null;
            String[] txtAmount = null;
			String[] txtDiscount = null;
			String[] txtTotalAmount = null;
			String[] txtUomId = null;
			
            long itemId = 0;
            long prItemId = 0;
            double qty = 0;
            double amount = 0;
            double discout = 0;
            double totAmount = 0;
			long uomId = 0;
			
            if(temp.size()>1){
			
                txtItemId = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]);
				txtPRItemId = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_PURCHASE_ITEM_ID]);
				txtQty = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]);
				txtAmount = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]);
				txtDiscount = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]);
				txtTotalAmount = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]);
				txtUomId = request.getParameterValues(JspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]);
                
				itemId = Long.parseLong(txtItemId[h]);
				prItemId = Long.parseLong(txtPRItemId[h]);
				qty = Double.parseDouble(removeNumberFormat(txtQty[h]));
				amount = Double.parseDouble(removeNumberFormat(txtAmount[h]));
				discout = Double.parseDouble(removeNumberFormat(txtDiscount[h]));
				totAmount = Double.parseDouble(removeNumberFormat(txtTotalAmount[h]));
				uomId = Long.parseLong(txtUomId[h]);
				
            }else{
                itemId = JSPRequestValue.requestLong(request, JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]);
				prItemId = JSPRequestValue.requestLong(request, JspReceiveItem.colNames[JspReceiveItem.JSP_PURCHASE_ITEM_ID]);
				qty = JSPRequestValue.requestDouble(request, JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]);
				amount = JSPRequestValue.requestDouble(request, JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]);
				discout = JSPRequestValue.requestDouble(request, JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]);
				totAmount = JSPRequestValue.requestDouble(request, JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]);
				uomId = JSPRequestValue.requestLong(request, JspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]);
            }
			
            if(qty>0){
				//ada atau sudah ada yang qty itemnya > 0
				if(!ok){
					ok = true;
				}
				Date expDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "ITM_JSP_EXPIRED_DATE"+h), "dd/MM/yyyy");
				DbReceiveItem.insertByItem(oidReceive, itemId, prItemId, qty, amount, discout, totAmount, uomId, expDate);
                                
            }
                        
            
        }
	}
        Vector vrecitem = new Vector();
        vrecitem = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+ "=" + receive.getOID(), "");
        for(int i=0;i<vrecitem.size();i++){
            ReceiveItem ri = (ReceiveItem) vrecitem.get(i);
            try{
                
                DbStock.insertReceiveGoods(receive, ri);
            }catch(Exception ex){
                
            }
        }
	
	if(ok && iErrCode==0){
		//out.println("check status po start");
		DbPurchase.checkPurchaseStatus(oidPO,closePo);
	}
	else{
		//jika tidak ada item yang di receive hapus receive doc
		try{
			DbReceive.deleteExc(oidReceive);
			oidReceive = 0;			
		}
		catch(Exception e){
		}
	}
	
	//jika sudah diapprove, lakukan posting jurnal
	if(receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
		//DbReceive.postJournal(receive);
	}
	
}

whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+oidReceive;
orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
Vector purchReqItems = DbReceiveItem.list(0,0, whereClause, orderClause);

%>	
	
<%
//int iJSPCommand = JSPRequestValue.requestCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
//long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");

/*variable declaration*/
//int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";
//System.out.println("jaskjhdfajkshdfjkhasjkdf : "+oidReceive);
//Receive receive = new Receive();
//try{
//        receive = DbReceive.fetchExc(oidReceive);
//    }catch(Exception e){}

//System.out.println("jaskjhdfajkshdfjkhasjkdf ************ ");

CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);
//JSPLine ctrLine = new JSPLine();
//iErrCode2 = cmdReceiveItem.action(iJSPCommand , oidReceiveItem, oidReceive);
JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();
msgString2 =  cmdReceiveItem.getMessage();

whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+oidReceive;
orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
Vector purchItems = DbReceiveItem.list(0,0, whereClause, orderClause);
Vector vendors = DbVendor.list(0,0, "", "name");

if(receive.getVendorId()==0){
	if(vendors!=null && vendors.size()>0){
		Vendor vx = (Vendor)vendors.get(0);
		receive.setVendorId(vx.getOID());
	}
}

//out.println("receive.setVendorId : "+receive.getVendorId());

Vector vendorItems = QrVendorItem.getVendorItems(receive.getVendorId());//DbVendorItem.list(0, 0, whereCls, "");


if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidReceiveItem = 0;
	receiveItem = new ReceiveItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidReceiveItem = 0;
	receiveItem = new ReceiveItem();
}

if((iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0) || iJSPCommand==JSPCommand.LOAD){
//delete item, load receive
	try{
		receive = DbReceive.fetchExc(oidReceive);
	}
	catch(Exception e){
	}
}

double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);

//out.println("subTotal : "+subTotal);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--

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

function cmdPrintDoc(){	 
                window.open("<%=printroot%>.report.RptIncomingGoodsXLS?idx=<%=System.currentTimeMillis()%>");
                }

function calcPrice(obj, a){
    
	qty = obj.value;
	//alert("qty : "+qty);
	//alert("a : "+a);	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(qty==""){
		qty = "0";
	}
	
		
	<%
	if(temp.size()>1){
	%>
		document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>[a].value = qty;
		
		qtypo = document.frmreceive.item_po[a].value;
		prevrec = document.frmreceive.prev_receive[a].value;
		
		if(parseInt(qty)>(parseInt(qtypo)-parseInt(prevrec))){
			alert("The quantity is more than maximum limit!");
			qty = "0";
			document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>[a].value = qty;
		}
	
		price = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>[a].value;
		discount = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>[a].value;
		price = removeChar(price);
		price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("price : "+price);
		//alert("discount : "+discount);
		
		var subtotal = (parseFloat(price) - parseFloat(discount)) * parseFloat(qty);
		
		var currTotal = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>[a].value;
		
		currTotal = removeChar(currTotal);
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>[a].value = formatFloat(''+subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		var total = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
		total = removeChar(total);
		total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		total = parseFloat(total) - parseFloat(currTotal) + subtotal;
		
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		
		calcTotal();
			
	<%}else{%>
		
		document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
		
		qtypo = document.frmreceive.item_po.value;
		prevrec = document.frmreceive.prev_receive.value;
		
		if(parseInt(qty)>(parseInt(qtypo)-parseInt(prevrec))){
			alert("The quantity is more than maximum limit!");
			qty = "0";
			document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
		}
		
		price = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
		discount = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
		price = removeChar(price);
		price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var subtotal = (parseFloat(price) - parseFloat(discount)) * parseFloat(qty);
		
		var currTotal = document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value;
		currTotal = removeChar(currTotal);
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("price : "+price+", discount : "+discount+", subtotal : "+subtotal+", currTotal : "+currTotal);
		
		document.frmreceive.<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		var total = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
		total = removeChar(total);
		total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("total : "+total+", curtotal : "+currTotal+", subtotal : "+subtotal);
		
		total = parseFloat(total) - parseFloat(currTotal) + subtotal;
		
		//alert("total - currTotal + subtotal : "+total);
		
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		calcTotal();
			
	
	<%}%>
	
}

function calcTotal(){
	var total = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
	total = removeChar(total);
	total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);

	var dicspercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value;
	dicspercent = removeChar(dicspercent);
	dicspercent = cleanNumberFloat(dicspercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value = dicspercent;
	
	disctotal = (parseFloat(total) * parseFloat(dicspercent))/100;
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+disctotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	var taxpercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value;
	taxpercent = removeChar(taxpercent);
	taxpercent = cleanNumberFloat(taxpercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value = taxpercent;
	
	taxtotal = ((total - disctotal) * parseFloat(taxpercent))/100;
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value = formatFloat(''+taxtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	total = (total - disctotal + taxtotal);
	
	document.frmreceive.grand_total.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function parserMaster(){
    var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
	<%if(vendorItems!=null && vendorItems.size()>0){
		for(int i=0; i<vendorItems.size(); i++){
			Vector v = (Vector)vendorItems.get(i);				
			ItemMaster imx = (ItemMaster)v.get(0);
			Uom uom = (Uom)v.get(3);
			VendorItem vix = (VendorItem)v.get(4);
	%>
			if('<%=imx.getOID()%>'==str){
				document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat('<%=vix.getLastPrice()%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
				document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
			}
	<%}}%>
    
	calculateSubTotal();
	
}

function calculateSubTotal(){
	var amount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
	var qty = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
	var discount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
	
	amount = removeChar(amount);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
	
	discount = removeChar(discount);
	discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
	document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var subtot = document.frmreceive.sub_tot.value;
	subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("amount : "+amount);
	//alert("subtot : "+subtot);
	//alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
	
	<%
	//add
	if(oidReceiveItem==0){%>
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	else{%>
		var tempAmount = document.frmreceive.temp_item_amount.value;
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	%>
	
	calculateAmount();
}


function cmdVatEdit(){
	var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
	if(parseInt(vat)==0){
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";				
	}else{
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
	}
	
	calcTotal();
}

function calculateAmount(){
	
	var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
	var taxPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value;
	taxPercent = removeChar(taxPercent);
	taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var discPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value;	
	discPercent = removeChar(discPercent);
	discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var subTotal = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
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
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";		
		//document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value="0.00";		
		totalTax = 0;
	}else{
		document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
		totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
	}
	
	//alert("subTotal :"+subTotal);
	//alert("totalDiscount :"+totalDiscount);
	//alert("totalTax :"+totalTax);
	
	var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
	
	//alert("grandTotal :"+grandTotal);
	
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmreceive.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}

function cmdClosedReason(){
	var st = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdVendor(){
	<%if(receive.getOID()!=0 && purchItems!=null && purchItems.size()>0){%>
		if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all receive item based on vendor item master. ')){
			document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
			document.frmreceive.action="receiveitempo.jsp";
			document.frmreceive.submit();
		}
	<%}else{%>
			document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
			document.frmreceive.action="receiveitempo.jsp";
			document.frmreceive.submit();
		//cmdVendorChange();
	<%}%>
}

function cmdToRecord(){
	document.frmreceive.command.value="<%=JSPCommand.NONE%>";
	document.frmreceive.action="receivelist.jsp";
	document.frmreceive.submit();
}

function cmdVendorChange(){
	var oid = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>.value;
	<%
	if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor v = (Vendor)vendors.get(i);
			%>
			if('<%=v.getOID()%>'==oid){
				document.frmreceive.vnd_address.value="<%=v.getAddress()%>";
			}
			<%
		}
	}
	%>
	
}


function cmdCloseDoc(){
	document.frmreceive.action="<%=approot%>/home.jsp";
	document.frmreceive.submit();
}

function cmdAskDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdDeleteDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdCancelDoc(){
	document.frmreceive.hidden_receive_request_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdSaveDoc(){
        if(confirm('Close Doc PO?')){
            document.frmreceive.close_po.value="1";
        }else{
            document.frmreceive.close_po.value="0";
        }
	document.frmreceive.command.value="<%=JSPCommand.POST%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdAdd(){
	document.frmreceive.hidden_receive_item_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.ADD%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdAsk(oidReceiveItem){
	document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
	document.frmreceive.command.value="<%=JSPCommand.ASK%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
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
	document.frmreceive.action="receiveitempo.jsp";
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
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
	}
function cmdAddItemMaster(){            
             
             
            window.open("<%=approot%>/postransaction/addItemBonus.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            
            document.frmreceive.submit();    
        }
function cmdEdit(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
	}

function cmdCancel(oidReceive){
	document.frmreceive.hidden_receive_item_id.value=oidReceive;
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}
function cmdCancelAddItemBonus(){
        document.frmreceive.command.value="<%=JSPCommand.ADD%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="receiveitempo.jsp";
        
	document.frmreceive.submit();
}
function cmdAddItemBonus(){                   
        document.frmreceive.command.value="<%=JSPCommand.GET%>";
        document.frmreceive.action="receiveitempo.jsp";
        document.frmreceive.submit();
}

function cmdBack(){
	document.frmreceive.command.value="<%=JSPCommand.BACK%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
	}

function cmdListFirst(){
	document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdListPrev(){
	document.frmreceive.command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
	}

function cmdListNext(){
	document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.action="receiveitempo.jsp";
	document.frmreceive.submit();
}

function cmdListLast(){
	document.frmreceive.command.value="<%=JSPCommand.LAST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmreceive.action="receiveitempo.jsp";
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
                        <form name="frmreceive" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                          <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                          <input type="hidden" name="close_po" value="">
                          <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">						  						  
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_po_id" value="<%=oidPO%>">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" > 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Incoming 
                                      Goods </span>&raquo; <span class="lvl2">PO 
                                      Base</span></font></b></td>
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
                                    <td height="6"></td>
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
                                            <div align="center">&nbsp;Incoming 
                                              Goods &nbsp;&nbsp;</div>
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
                                                    <%if(receive.getOID()==0){%>
                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                    <%}else{
													User us = new User();
													try{
														us = DbUser.fetch(receive.getUserId());
													}
													catch(Exception e){
													}
													%>
                                                    Prepared By : <%=us.getLoginId()%> 
                                                    <%igg.setUser(us.getLoginId());%>
                                                    <%}%>
                                                    </i>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="12%">&nbsp;&nbsp;PO 
                                                  Number </td>
                                                <td height="15" width="27%"> 
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=po.getOID()%>">
                                                  <input type="text" name="textfield" class="readonly" value="<%=po.getNumber()%>" readOnly>
                                                  <%igg.setPoNumber(po.getNumber());%>
                                                </td>
                                                <td height="15" width="9%">&nbsp;</td>
                                                <td height="15" colspan="2" width="52%" class="comment">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="12%">&nbsp;&nbsp;PO 
                                                  Date</td>
                                                <td height="15" width="27%"> 
                                                  <input type="text" name="textfield2" class="readOnly" readonly value="<%=JSPFormater.formatDate(po.getPurchDate(), "dd/MM/yyyy")%>">
                                                  <%igg.setPoDate(po.getPurchDate());%>
                                                </td>
                                                <td height="15" width="9%">&nbsp;</td>
                                                <td height="15" colspan="2" width="52%" class="comment">&nbsp;</td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>
                                                <td height="20" width="27%"> 
                                                  <%
												Vendor vendor = new Vendor();
												try{
													vendor = DbVendor.fetchExc(po.getVendorId());
												}
												catch(Exception e){
												}
												%>
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" value="<%=po.getVendorId()%>">
                                                  <input type="text" name="textfield" value="<%=vendor.getName()%>" size="40" readOnly class="readonly">
                                                  <%igg.setVendor(vendor.getName());
                                                  igg.setAddress(vendor.getAddress());%>
                                                </td>
                                                <td height="20" width="9%">Receive 
                                                  In</td>
                                                <td height="20" colspan="2" width="52%" class="comment"> 
                                                  <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                                    <%                                          
                                                                        
													Vector locations = DbLocation.list(0,0, "", "code");
													  if(locations!=null && locations.size()>0){
														for(int i=0; i<locations.size(); i++){
														Location d = (Location)locations.get(i);
															%>
                                                    <option value="<%=d.getOID()%>" <%if(po.getLocationId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    
                                                    <%}
                                                           Location locc = new Location();
                                                           try{
                                                               locc = DbLocation.fetchExc(receive.getLocationId());
                                                             igg.setReceiveIn(locc.getName());                                                     
                                                           }catch(Exception ex){
                                                               
                                                           }
                                                             
                                                                                                          }%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="12%">&nbsp;&nbsp;Address</td>
                                                <td height="20" width="27%"> 
                                                  <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly"><%=vendor.getAddress()%></textarea>
                                                </td>
                                                <td width="9%" height="20">Doc 
                                                  Number</td>
                                                <td colspan="2" class="comment" width="52%" height="20"> 
                                                  <b>
                                                  <%
												  String number = "";
												  if(receive.getOID()==0){
													  int ctr = DbReceive.getNextCounter();
													  number = DbReceive.getNextNumber(ctr);
												  }
												  else{
													  number = receive.getNumber();
                                                                                                          igg.setOidGoods(receive.getPurchaseId());
                                                                                                           igg.setDocNumber(number);
												  }
												  %>
                                                  <%=number%> </b></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;DO 
                                                  Number </td>
                                                <td height="21" width="27%"> 
                                                  <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DO_NUMBER]%>" value="<%=receive.getDoNumber()%>">
                                                  <%=jspReceive.getErrorMsg(JspReceive.JSP_DO_NUMBER)%> </td>
                                                  <%igg.setDoNumber(receive.getDoNumber());%>
                                                <td width="9%">Currency</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <b>
                                                  <%
												Currency curr = new Currency();
												try{
													curr = DbCurrency.fetchExc(po.getCurrencyId());
												}
												catch(Exception e){
												}
												out.println(curr.getCurrencyCode());
												%>
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>" value="<%=po.getCurrencyId()%>">
												  </b></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Invoice 
                                                  Number</td>
                                                <td height="21" width="27%"> 
                                                  <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_INVOICE_NUMBER]%>" value="<%=receive.getInvoiceNumber()%>">
                                                  <%=jspReceive.getErrorMsg(JspReceive.JSP_INVOICE_NUMBER)%> 
                                                  <%igg.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                  <%
                                              Vector currs = DbCurrency.list(0, 0, "", "");
                                              Vector exchange_value = new Vector(1,1);
                                                    Vector exchange_key = new Vector(1,1);
                                                    String sel_exchange = ""+receive.getCurrencyId();
                                                  if(currs!=null && currs.size()>0){
                                                        for(int i=0; i<currs.size(); i++){
                                                            Currency d = (Currency)currs.get(i);
                                                            exchange_key.add(""+d.getOID());
                                                            exchange_value.add(d.getCurrencyCode());
                                                        }
                                                  }          
                                              %>
                                                  <%//= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %>
                                                </td>
                                                <td width="9%">Doc. Status</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <%
											if(receive.getStatus()==null || receive.getStatus().length()==0){
												//out.println("status = null, set to draft");
												receive.setStatus(I_Project.DOC_STATUS_DRAFT);
											}	
											%>
                                                  <input type="text" class="readOnly" name="stt" value="<%=(receive.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>" size="15" readOnly>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="<%=JspReceive.colNames[JspReceive.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate()==null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%igg.setDate(receive.getDate());%>
                                                </td>
                                                <td width="9%">Applay VAT</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <% 
                                                /*Vector include_value = new Vector(1,1);
												Vector include_key = new Vector(1,1);
												String sel_include = ""+receive.getIncluceTax();
                                                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_NO]);
                                                include_key.add(""+DbReceive.INCLUDE_TAX_NO);
                                                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_YES]);
                                                include_key.add(""+DbReceive.INCLUDE_TAX_YES);
												*/
					   							%>
                                                  <%//= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX],null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %>
                                                  <b><%=DbReceive.strIncludeTax[po.getIncluceTax()]%></b>
<input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=po.getIncluceTax()%>">												  
												   </td>
                                                                                                    <%igg.setApplayVat(receive.getIncluceTax());%>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Payment 
                                                  Type </td>
                                                <td height="21" width="27%"> 
                                                  <% 
                                                Vector payment_value = new Vector(1,1);
												Vector payment_key = new Vector(1,1);
												String sel_payment = ""+receive.getPaymentType();
                                                payment_key.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_key.add(I_Project.PAYMENT_TYPE_CREDIT);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CREDIT);
					   							%>
                                                  <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE],null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                                  <%igg.setPaymentType("" + receive.getPaymentType());%>
                                                <td width="9%">Term Of Payment</td>
                                                <td width="52%" colspan="2" class="comment"> 
                                                  <input name="<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDueDate()==null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                                <%igg.setTermOfPayment(receive.getDueDate());%>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" cols="100" rows="2"><%=receive.getNote()%></textarea>
                                                  <%igg.setNotes(receive.getNote());%>
                                                </td>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp; 
                                                  <%//=drawList(iJSPCommand,jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus())%>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2" width="30%">Code 
                                                        - Name</td>
                                                      <td class="tablehdr" colspan="3" height="16">Quantity</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">@Price</td>
                                                      <td class="tablehdr" rowspan="2" width="12%">Discount</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">Total</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Unit Purchase</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Unit Stock</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Expired Date</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="7%" height="18">PO</td>
                                                      <td class="tablehdr" width="9%" height="18">Prev. 
                                                        Receive</td>
                                                      <td class="tablehdr" width="7%" height="18">Receive</td>
                                                    </tr>
                                                    <%
                                                                                                        
													if(temp!=null && temp.size()>0){
														for(int i=0; i<temp.size(); i++){
                                                                                                                    SessIncomingGoodsL igL = new SessIncomingGoodsL();
															PurchaseItem pi = (PurchaseItem)temp.get(i);
															ItemMaster im = new ItemMaster();
															ItemGroup ig = new ItemGroup();
															ItemCategory ic = new ItemCategory();
															Uom uom = new Uom();
                                                                                                                        Uom uomStock = new Uom();												
															try{
																im = DbItemMaster.fetchExc(pi.getItemMasterId());
																ig = DbItemGroup.fetchExc(im.getItemGroupId());
																ic = DbItemCategory.fetchExc(im.getItemCategoryId());
																uom = DbUom.fetchExc(pi.getUomId());
                                                                                                                                uomStock = DbUom.fetchExc(im.getUomStockId());
															}
															catch(Exception e){
															}
															
															double prevReceiveQty = DbReceiveItem.getTotalQtyRec(pi.getOID());
															ReceiveItem ri = DbReceiveItem.getReceiveItem(pi.getOID(), oidReceive);
															igL.setDiscount(ri.getTotalDiscount());
                                                                                                                        igL.setExpiredDate(ri.getExpiredDate());
                                                                                                                        igL.setGroup(im.getName());
                                                                                                                        igL.setBarcode(im.getBarcode());
                                                                                                                        igL.setPrice(ri.getAmount());
                                                                                                                        igL.setQty(ri.getQty());
                                                                                                                        igL.setTotal(ri.getTotalAmount());
                                                                                                                        igL.setUnit(uom.getUnit());
                                                                                                                        igL.setUnitStock(uomStock.getUnit());
                                                                                                                        
                                                                                                                        tempt.add(igL);
															if(i%2==0){
													%>
                                                    <tr> 
                                                      <td width="30%" class="tablecell1"> 
                                                        <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>" value="<%=im.getOID()%>">
                                                        <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_PURCHASE_ITEM_ID]%>" value="<%=pi.getOID()%>">
                                                        <%//=ig.getName()+"/"+ic.getName()+"/"+im.getName()%>
														<%=im.getCode()+" - "+im.getName()%></td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"><%=pi.getQty()%> 
                                                          <input type="hidden" name="item_po" value="<%=pi.getQty()%>">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"><%=prevReceiveQty - ri.getQty()%> 
                                                          <input type="hidden" name="prev_receive" value="<%=prevReceiveQty - ri.getQty()%>">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>" size="5" style="text-align:center" onBlur="javascript:calcPrice(this, '<%=i%>')" value="<%=ri.getQty()%>" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(pi.getAmount(), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>" size="12" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber((pi.getTotalDiscount()/pi.getQty()), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(ri.getTotalAmount(), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="<%=pi.getUomId()%>">
                                                          <%=uom.getUnit()%></div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="<%=pi.getUomId()%>">
                                                          <%=uom.getUnit()%></div>
                                                      </td>
                                                      
                                                      <td width="5%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+i%>" value="<%=JSPFormater.formatDate((ri.getExpiredDate() == null) ? new Date() : ri.getExpiredDate(), "dd/MM/yyyy")%>" size="10" >
                                                          <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+i%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                          
                                                        </div>
                                                      </td>
                                                       
                                                                                                   
                                                    </tr>
                                                    <%}else{%>
                                                    <tr> 
                                                      <td width="30%" class="tablecell1"> 
                                                        <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>" value="<%=im.getOID()%>">
                                                        <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_PURCHASE_ITEM_ID]%>" value="<%=pi.getOID()%>">
                                                        <%//=ig.getName()+"/"+ic.getName()+"/"+im.getName()%>
														<%=im.getCode()+" - "+im.getName()%></td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"><%=pi.getQty()%> 
                                                          <input type="hidden" name="item_po" value="<%=pi.getQty()%>">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"><%=prevReceiveQty - ri.getQty()%> 
                                                          <input type="hidden" name="prev_receive" value="<%=prevReceiveQty - ri.getQty()%>">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>" size="5" style="text-align:center" onBlur="javascript:calcPrice(this, '<%=i%>')" value="<%=ri.getQty()%>" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(pi.getAmount(), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>" size="12" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber((pi.getTotalDiscount()/pi.getQty()), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(ri.getTotalAmount(), "#,###.##")%>">
                                                        </div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="<%=pi.getUomId()%>">
                                                          <%=uom.getUnit()%></div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="<%=pi.getUomId()%>">
                                                          <%=uom.getUnit()%></div>
                                                      </td>
                                                      
                                                      <td width="5%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+i%>" value="<%=JSPFormater.formatDate((ri.getExpiredDate() == null) ? new Date() : ri.getExpiredDate(), "dd/MM/yyyy")%>" size="10" >
                                                          <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE]+i%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                        </div>
                                                      </td>
                                                          
                                                          
                                                    </tr>
                                                    <%}}}
                                                          session.putValue("PURCHASE_DETAIL", tempt);                                            
                                                                                                         
                                                                                                         %>
                                                    <% if(iJSPCommand==JSPCommand.GET){%>
                                                        <tr>
                                                           <td width="30%" class="tablecell1">  
                                                           <input type="text" name="item_bonus" value="<%=itemBonus.getName()%>"> 
                                                           <a href="javascript:cmdAddItemMaster()">Search</a>
                                                           </td>
                                                           <td width="7%" class="tablecell1"> 
                                                            <div align="center">&nbsp;
                                                            
                                                            </div>
                                                           </td>
                                                           <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="prev_receive" value=""
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>" size="5" style="text-align:center"  value="" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>" size="12" class="readonly" readonly style="text-align:right" value="">
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>" size="15" class="readonly" readonly style="text-align:right" value="">
                                                        </div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="">
                                                          </div>
                                                      </td>
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReceiveItem.colNames[JspReceiveItem.JSP_UOM_ID]%>" value="">
                                                          </div>
                                                      </td>
                                                      
                                                     
                                                           
                                                           
                                                           
                                                        </tr>
                                                    <%}%>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    
                                                    <% if(iJSPCommand==JSPCommand.ADD){%>
                                                    
                                                    <%}else if(iJSPCommand!=JSPCommand.POST){%>
                                                        <tr>
                                                        <td width="30"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/save2.gif',1)"><img src="../images/save.gif" name="save211" height="22" border="0"></a></td>
                                                        <td width="30"><a href="javascript:cmdCancelAddItemBonus()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                        <td width="30"><a href="javascript:cmdAddItemBonus()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/save2.gif',1)"><img src="../images/save.gif" name="save211" height="22" border="0"></a></td>
                                                        </tr>    
                                                    <%}%>
                                                    
                                                    
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                        <td>&nbsp;
                                                        </td>  
                                                    </tr>
                                                    
                                                    <tr> 
                                                      <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="45%" valign="middle">&nbsp; 
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
                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                                <%igg.setSubTotal(subTotal);%>
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Discount</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=po.getDiscountPercent()%><%//=receive.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calcTotal()" onClick="this.select()" readOnly class="readOnly">
                                                                % </div>
                                                                <%igg.setDiscount1(receive.getDiscountPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                <%igg.setDiscount2(receive.getDiscountTotal());%>
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>VAT</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>" size="5" value="<%=po.getTaxPercent()%><%//=receive.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                                                                % </div>
                                                                <%igg.setVat1(receive.getTaxPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                                <%igg.setVat2(receive.getTotalTax());%>
                                                              </div>
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
                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(subTotal+receive.getTotalTax()+receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                <%igg.setGrandTotal(receive.getTotalAmount() + receive.getTotalTax() - receive.getDiscountTotal());%>
                                                              </div>
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
                                              <%if(receive.getOID()!=0){%>
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
                                                        <%if(receive.getOID()!=0 && !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%if( (!receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0)){%>
                                                          <tr> 
                                                            <td width="12%"><b>Set 
                                                              Status to</b> </td>
                                                            <td width="14%"> 
                                                              <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if( receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                <%if(posApprove1Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if( receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                <%}%>
                                                                <%if(posApprove2Priv && 1==2){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if( receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                <%}%>
                                                                <%if(posApprove4Priv && 1==2){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if( receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
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
															if(receive.getOID()!=0){
													%>
                                                    <tr> 
                                                      <td colspan="4" class="errfont"><%=msgString%></td>
                                                    </tr>
                                                    <%		}%>
                                                    <%if(temp!=null && temp.size()>0){
														//if(receive.getOID()!=0){
													%>
                                                    <tr> 
                                                      <%if( !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0){%>
                                                      <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                      <td width="102" > 
                                                        <div align="left"> 
                                                          <%if(receive.getOID()!=0){%>
                                                          <a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a> 
                                                          <%}else{%>
                                                          <a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211113','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211113" border="0"></a> 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                      <%}%>
                                                      <td width="97"> 
                                                        <div align="left"> 
                                                          <%if(receive.getOID()!=0){%>
                                                          <a href="javascript:cmdPrintDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a> 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"> 
                                                          <%if(receive.getOID()!=0){%>
                                                          <a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a> 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <%//}
													}else{%>
                                                    <tr> 
                                                      <td colspan="2" nowrap> 
                                                        <div align="left"><font color="#FF0000"><i>No 
                                                          receive item for vendor</i></font></div>
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
                                              <%if(receive.getOID()!=0){%>
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
													u = DbUser.fetch(receive.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
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
													u = DbUser.fetch(receive.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%if(receive.getApproval1()!=0){%>
                                                          <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
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
						  //	cmdVendorChange();
							<%if(iErrCode2==0 &&(receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && receiveItem.getOID()!=0) || iErrCode!=0))){%>
                            //	parserMaster();
							<%}%>
                          </script>
                          <script language="JavaScript">
						    <%if(receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && receiveItem.getOID()!=0) || iErrCode!=0)){%>
									//alert('in here');
									//cmdChangeItem();																		
							<%}							
							if(receive.getOID()!=0 && !receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>
									//cmdClosedReason();
							<%}%>
							</script>
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
        <%session.putValue("PURCHASE_TITTLE", igg);%>
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
