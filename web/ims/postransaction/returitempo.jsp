
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>


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
	public String drawList(int iJSPCommand,JspReturItem jspRetur, 
                ReturItem objEntity, Vector objectClass, 
                long returItemId, String approot, long oidVendor,
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
			 ReturItem returItem = (ReturItem)objectClass.get(i);
			 rowx = new Vector();
			 if(returItemId == returItem.getOID())
			 	 index = i; 

			 if(iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK ||  (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && returItemId==0))){
					
					//------------			
					rowx.add("<div align=\"center\">"+(i+1)+"</div>");	
					if(vectVendMaster!=null && vectVendMaster.size()>0){
						rowx.add("<div align=\"left\">"+JSPCombo.draw(jspRetur.colNames[JspReturItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+jspRetur.getErrorMsg(jspRetur.JSP_ITEM_MASTER_ID)+"</div>");                                
					}
					else{
						rowx.add("<font color=\"red\">No retur item available for vendor</font>");
					}
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_AMOUNT] +"\" value=\""+returItem.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_AMOUNT)+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+returItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+returItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+returItem.getQty()+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+returItem.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_TOTAL_AMOUNT] +"\" value=\""+returItem.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div><input type=\"hidden\" name=\"temp_item_amount\" value=\""+returItem.getTotalAmount()+"\">");
					//rowx.add("<div align=\"right\">"+JSPCombo.draw(jspRetur.colNames[JspReturItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
					rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
					rowx.add("<div align=\"center\"><input name=\""+JspReturItem.colNames[JspReturItem.JSP_EXPIRED_DATE]+"\" value=\""+JSPFormater.formatDate((returItem.getExpiredDate()==null) ? new Date() : returItem.getExpiredDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
								"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmretur."+JspReturItem.colNames[JspReturItem.JSP_EXPIRED_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");

			 }else{
				ItemMaster itemMaster = new ItemMaster();
				ItemGroup ig = new ItemGroup();
				ItemCategory ic = new ItemCategory();
				try{
					itemMaster = DbItemMaster.fetchExc(returItem.getItemMasterId());
					ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
					ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
				}catch(Exception e){}
                                
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(returItem.getUomId());
				}catch(Exception e){}
				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				if(status!=null && status.equals(I_Project.DOC_STATUS_DRAFT)){		
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(returItem.getOID())+"')\">"+ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName()+"</a>");
				}
				else{
					rowx.add(ig.getName()+"/ "+ic.getName()+"/ "+itemMaster.getCode()+" - "+itemMaster.getName());
				}
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(returItem.getAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"center\">"+returItem.getQty()+"</div>");
				rowx.add("<div align=\"center\">"+returItem.getQty()+"</div>");
				rowx.add("<div align=\"center\">"+returItem.getQty()+"</div>");
				
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(returItem.getTotalDiscount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(returItem.getTotalAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");
                rowx.add("<div align=\"center\">"+JSPFormater.formatDate(returItem.getExpiredDate(), "dd/MM/yyyy")+"</div>");
			 } 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand != JSPCommand.POST && (iJSPCommand == JSPCommand.ADD || iJSPCommand==JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && returItemId==0))){ 
				rowx.add("<div align=\"center\">"+(objectClass.size()+1)+"</div>");	
				if(vectVendMaster!=null && vectVendMaster.size()>0){
					rowx.add("<div align=\"left\">"+JSPCombo.draw(jspRetur.colNames[JspReturItem.JSP_ITEM_MASTER_ID],null, ""+objEntity.getItemMasterId(), vect_value , vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen")+jspRetur.getErrorMsg(jspRetur.JSP_ITEM_MASTER_ID)+"</div>");                                
				}
				else{
					rowx.add("<font color=\"red\">No retur item available for vendor</font>");
				}
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_AMOUNT)+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\""+jspRetur.colNames[JspReturItem.JSP_QTY] +"\" value=\""+((objEntity.getQty()==0) ? 1 : objEntity.getQty())+"\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+jspRetur.getErrorMsg(jspRetur.JSP_QTY)+"</div>");				
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_TOTAL_DISCOUNT] +"\" value=\""+objEntity.getTotalDiscount()+"\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">"+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"20\" name=\""+jspRetur.colNames[JspReturItem.JSP_TOTAL_AMOUNT] +"\" value=\""+objEntity.getTotalAmount()+"\" class=\"readOnly\" style=\"text-align:right\" readOnly>"+"</div>");
				//rowx.add("<div align=\"right\">"+JSPCombo.draw(jspRetur.colNames[JspReturItem.JSP_UOM_ID],null, ""+objEntity.getUomId(), uom_value , uom_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"right\">"+"<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">"+"</div>");
				rowx.add("<div align=\"center\"><input name=\""+JspReturItem.colNames[JspReturItem.JSP_EXPIRED_DATE]+"\" value=\""+JSPFormater.formatDate((objEntity.getExpiredDate()==null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy")+"\" size=\"11\" readonly>"+
							"<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmretur."+JspReturItem.colNames[JspReturItem.JSP_EXPIRED_DATE]+");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
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

	if(session.getValue("PO_TITTLE")!=null){
		session.removeValue("PO_TITTLE");
	}
	
	if(session.getValue("PO_DETAIL")!=null){
		session.removeValue("PO_DETAIL");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
long oidPO = JSPRequestValue.requestLong(request, "hidden_po_id");
long oidRetur = JSPRequestValue.requestLong(request, "hidden_retur_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidRetur =0;
}

Receive receive = new Receive();
try{
	receive = DbReceive.fetchExc(oidReceive);
	oidPO = receive.getPurchaseId();
}
catch(Exception e){
}

Purchase po = new Purchase();
try{
	po = DbPurchase.fetchExc(oidPO);
}
catch(Exception e){
}


//out.println(temp);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

SessPoRetur poR = new SessPoRetur();

//vector baru
Vector objRpt = new Vector();

CmdRetur cmdRetur = new CmdRetur(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdRetur.action(iJSPCommand , oidRetur);

//out.println("oidRetur : "+oidRetur);
//out.println("oidRetur : "+oidRetur);

JspRetur jspRetur = cmdRetur.getForm();
Retur retur = cmdRetur.getRetur();
msgString =  cmdRetur.getMessage();

if(retur.getOID()!=0){
	try{
		receive = DbReceive.fetchExc(retur.getReceiveId());
		oidReceive = retur.getReceiveId();
	}
	catch(Exception e){
	}
	
	try{
		oidPO = retur.getPurchaseId();
		po = DbPurchase.fetchExc(oidPO);
	}
	catch(Exception e){
	}
}

Vector temp = DbReceiveItem.list(0,0, "receive_id="+oidReceive, "");
        
if(oidRetur==0){
    oidRetur = retur.getOID();
	if(oidRetur==0){
		retur.setStatus(I_Project.DOC_STATUS_DRAFT);	
	}
}

//out.println("oidRetur : "+oidRetur);
//out.println("jspRetur : "+jspRetur.getErrors());

if(iJSPCommand==JSPCommand.POST){
	
	DbReturItem.deleteByReturId(oidRetur);
        DbStockCode.deleteStockCodeRetur(oidRetur);
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
			String[] txtRecItemId = null;
			
            long itemId = 0;
            long prItemId = 0;
			long recItemId = 0;
            double qty = 0;
            double amount = 0;
            double discout = 0;
            double totAmount = 0;
            long uomId = 0;
			
            if(temp.size()>1){
			
                txtItemId = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]);
				txtPRItemId = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_PURCHASE_ITEM_ID]);
				txtRecItemId = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_RECEIVE_ITEM_ID]);
				txtQty = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_QTY]);
				txtAmount = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_AMOUNT]);
				txtDiscount = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]);
				txtTotalAmount = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]);
				txtUomId = request.getParameterValues(JspReturItem.colNames[JspReturItem.JSP_UOM_ID]);
                
				itemId = Long.parseLong(txtItemId[h]);
				prItemId = Long.parseLong(txtPRItemId[h]);
				recItemId = Long.parseLong(txtRecItemId[h]);
				qty = Double.parseDouble(removeNumberFormat(txtQty[h]));
				amount = Double.parseDouble(removeNumberFormat(txtAmount[h]));
				discout = Double.parseDouble(removeNumberFormat(txtDiscount[h]));
				totAmount = Double.parseDouble(removeNumberFormat(txtTotalAmount[h]));
				uomId = Long.parseLong(txtUomId[h]);
				
            }else{
                itemId = JSPRequestValue.requestLong(request, JspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]);
				prItemId = JSPRequestValue.requestLong(request, JspReturItem.colNames[JspReturItem.JSP_PURCHASE_ITEM_ID]);
				recItemId = JSPRequestValue.requestLong(request, JspReturItem.colNames[JspReturItem.JSP_RECEIVE_ITEM_ID]);
				qty = JSPRequestValue.requestDouble(request, JspReturItem.colNames[JspReturItem.JSP_QTY]);
				amount = JSPRequestValue.requestDouble(request, JspReturItem.colNames[JspReturItem.JSP_AMOUNT]);
				discout = JSPRequestValue.requestDouble(request, JspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]);
				totAmount = JSPRequestValue.requestDouble(request, JspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]);
				uomId = JSPRequestValue.requestLong(request, JspReturItem.colNames[JspReturItem.JSP_UOM_ID]);
            }
			
			if(qty>0){
				//ada atau sudah ada yang qty itemnya > 0
				if(!ok){
					ok = true;
				}
				
				DbReturItem.insertByItem(oidRetur, itemId, prItemId, qty, amount, discout, totAmount, uomId, recItemId);
                                ItemMaster itemMaster = new ItemMaster(); 
                                try{
                                    itemMaster = DbItemMaster.fetchExc(itemId);
                                }catch(Exception ex){
                                    
                                }
                                
                                if(itemMaster.getApplyStockCode() != DbItemMaster.NON_APPLY_STOCK_CODE){
                                    
                                    Vector vStockCode = new Vector();
                                    vStockCode = DbStockCode.list(0, 0, DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID] + "=" + recItemId, ""); 
                                    StockCode stockCode = new StockCode();
                                    StockCode stockCodeR = new StockCode();
                                    
                                    
                                    for(int a=0;a<vStockCode.size();a++){
                                        stockCode = (StockCode) vStockCode.get(a);
                                        //DbStockCode.deleteStockCode(receiveItemId);
                                        stockCodeR.setCode(stockCode.getCode());
                                        stockCodeR.setLocationId(stockCode.getLocationId());
                                        stockCodeR.setItemMasterId(stockCode.getItemMasterId());
                                        stockCodeR.setInOut(DbStockCode.STOCK_OUT);
                                        stockCodeR.setType(DbStockCode.TYPE_RETUR_GOODS);
                                        stockCodeR.setReturId(oidRetur);
                                        stockCodeR.setStatus(DbStockCode.STATUS_OUT); 
                                        stockCodeR.setType_item(3);//pada consigment tidak ada retur PO
                                        DbStockCode.insertExc(stockCodeR);
                                    }
                                }
			}
            
        }
	}
	
	if(ok){
		//out.println("check status po start");
		//DbPurchase.checkPurchaseStatus(oidPO);
	}
	else{
		//jika tidak ada item yang di retur hapus retur doc
		try{
			DbRetur.deleteExc(oidRetur);
			oidRetur = 0;			
		}
		catch(Exception e){
		}
	}
	
}

if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
    iErrCode = cmdRetur.action(iJSPCommand , oidRetur);
}

whereClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ID]+"="+oidRetur;
orderClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ITEM_ID];
Vector purchReqItems = DbReturItem.list(0,0, whereClause, orderClause);

%>	
	
<%
//int iJSPCommand = JSPRequestValue.requestCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
//long oidRetur = JSPRequestValue.requestLong(request, "hidden_retur_id");
long oidReturItem = JSPRequestValue.requestLong(request, "hidden_retur_item_id");

/*variable declaration*/
//int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";
//System.out.println("jaskjhdfajkshdfjkhasjkdf : "+oidRetur);
//Retur retur = new Retur();
//try{
//        retur = DbRetur.fetchExc(oidRetur);
//    }catch(Exception e){}

//System.out.println("jaskjhdfajkshdfjkhasjkdf ************ ");

CmdReturItem cmdReturItem = new CmdReturItem(request);
//JSPLine ctrLine = new JSPLine();
//iErrCode2 = cmdReturItem.action(iJSPCommand , oidReturItem, oidRetur);
JspReturItem jspReturItem = cmdReturItem.getForm();
ReturItem returItem = cmdReturItem.getReturItem();
msgString2 =  cmdReturItem.getMessage();

whereClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ID]+"="+oidRetur;
orderClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ITEM_ID];
Vector purchItems = DbReturItem.list(0,0, whereClause, orderClause);
Vector vendors = DbVendor.list(0,0, "", "name");

if(retur.getVendorId()==0){
	if(vendors!=null && vendors.size()>0){
		Vendor vx = (Vendor)vendors.get(0);
		retur.setVendorId(vx.getOID());
	}
}

//out.println("retur.setVendorId : "+retur.getVendorId());

Vector vendorItems = QrVendorItem.getVendorItems(retur.getVendorId());//DbVendorItem.list(0, 0, whereCls, "");


if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE){
	iJSPCommand = JSPCommand.ADD;
	oidReturItem = 0;
	returItem = new ReturItem();
}

if(iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0){
	oidReturItem = 0;
	returItem = new ReturItem();
}

if((iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0) || iJSPCommand==JSPCommand.LOAD){
//delete item, load retur
	try{
		retur = DbRetur.fetchExc(oidRetur);
	}
	catch(Exception e){
	}
}

double subTotal = DbReturItem.getTotalReturAmount(oidRetur);

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
function cmdPrintPdf(){
	//window.open();
	window.open("<%=printroot%>.report.RptPoReturPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
		document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>[a].value = qty;
		
		qtypo = document.frmretur.item_po[a].value;
		prevrec = document.frmretur.prev_retur[a].value;
		
		if(parseInt(qty)>(parseInt(qtypo)-parseInt(prevrec))){
			alert("The quantity is more than maximum limit!");
			qty = "0";
			document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>[a].value = qty;
		}
	
		price = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>[a].value;
		discount = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>[a].value;
		price = removeChar(price);
		price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("price : "+price);
		//alert("discount : "+discount);
		
		var subtotal = (parseFloat(price) - parseFloat(discount)) * parseFloat(qty);
		
		var currTotal = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>[a].value;
		
		currTotal = removeChar(currTotal);
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>[a].value = formatFloat(''+subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		var total = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value;
		total = removeChar(total);
		total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		total = parseFloat(total) - parseFloat(currTotal) + subtotal;
		
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		
		calcTotal();
			
	<%}else{%>
		
		document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>.value = qty;
		
		qtypo = document.frmretur.item_po.value;
		prevrec = document.frmretur.prev_retur.value;
		
		if(parseInt(qty)>(parseInt(qtypo)-parseInt(prevrec))){
			alert("The quantity is more than maximum limit!");
			qty = "0";
			document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>.value = qty;
		}
		
		price = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value;
		discount = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>.value;
		price = removeChar(price);
		price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		discount = removeChar(discount);
		discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var subtotal = (parseFloat(price) - parseFloat(discount)) * parseFloat(qty);
		
		var currTotal = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>.value;
		currTotal = removeChar(currTotal);
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("price : "+price+", discount : "+discount+", subtotal : "+subtotal+", currTotal : "+currTotal);
		
		document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		var total = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value;
		total = removeChar(total);
		total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert("total : "+total+", curtotal : "+currTotal+", subtotal : "+subtotal);
		
		total = parseFloat(total) - parseFloat(currTotal) + subtotal;
		
		//alert("total - currTotal + subtotal : "+total);
		
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		calcTotal();
			
	
	<%}%>
	
}

function calcTotal(){
	var total = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value;
	total = removeChar(total);
	total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);

	var dicspercent = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_PERCENT]%>.value;
	dicspercent = removeChar(dicspercent);
	dicspercent = cleanNumberFloat(dicspercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_PERCENT]%>.value = dicspercent;
	
	disctotal = (parseFloat(total) * parseFloat(dicspercent))/100;
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+disctotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	var taxpercent = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value;
	taxpercent = removeChar(taxpercent);
	taxpercent = cleanNumberFloat(taxpercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value = taxpercent;
	
	taxtotal = ((total - disctotal) * parseFloat(taxpercent))/100;
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_TAX]%>.value = formatFloat(''+taxtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	
	total = (total - disctotal + taxtotal);
	
	document.frmretur.grand_total.value = formatFloat(''+total, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function parserMaster(){
    var str = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]%>.value;
	<%if(vendorItems!=null && vendorItems.size()>0){
		for(int i=0; i<vendorItems.size(); i++){
			Vector v = (Vector)vendorItems.get(i);				
			ItemMaster imx = (ItemMaster)v.get(0);
			Uom uom = (Uom)v.get(3);
			VendorItem vix = (VendorItem)v.get(4);
	%>
			if('<%=imx.getOID()%>'==str){
				document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value = formatFloat('<%=vix.getLastPrice()%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
				document.frmretur.unit_code.value="<%=uom.getUnit()%>";
			}
	<%}}%>
    
	calculateSubTotal();
	
}

function calculateSubTotal(){
	var amount = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value;
	var qty = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_QTY]%>.value;
	var discount = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>.value;
	
	amount = removeChar(amount);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	qty = removeChar(qty);
	qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_QTY]%>.value = qty;
	
	discount = removeChar(discount);
	discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
	document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	
	var subtot = document.frmretur.sub_tot.value;
	subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("amount : "+amount);
	//alert("subtot : "+subtot);
	//alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
	
	<%
	//add
	if(oidReturItem==0){%>
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	else{%>
		var tempAmount = document.frmretur.temp_item_amount.value;
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	<%}
	%>
	
	calculateAmount();
}


function cmdVatEdit(){
	var vat = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_INCLUDE_TAX]%>.value;
	if(parseInt(vat)==0){
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value="0.0";				
	}else{
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
	}
	
	calcTotal();
}

function calculateAmount(){
	
	var vat = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_INCLUDE_TAX]%>.value;
	var taxPercent = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value;
	taxPercent = removeChar(taxPercent);
	taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var discPercent = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_PERCENT]%>.value;	
	discPercent = removeChar(discPercent);
	discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
	
	var subTotal = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>.value;
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
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value="0.0";		
		//document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_TAX]%>.value="0.00";		
		totalTax = 0;
	}else{
		document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
		totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
	}
	
	//alert("subTotal :"+subTotal);
	//alert("totalDiscount :"+totalDiscount);
	//alert("totalTax :"+totalTax);
	
	var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
	
	//alert("grandTotal :"+grandTotal);
	
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	document.frmretur.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	
}

function cmdClosedReason(){
	var st = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_STATUS]%>.value;
	if(st=='CLOSED'){
		document.all.closingreason.style.display="";
	}
	else{
		document.all.closingreason.style.display="none";		
	}
}

function cmdVendor(){
	<%if(retur.getOID()!=0 && purchItems!=null && purchItems.size()>0){%>
		if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all retur item based on vendor item master. ')){
			document.frmretur.command.value="<%=JSPCommand.LOAD%>";
			document.frmretur.action="returitempo.jsp";
			document.frmretur.submit();
		}
	<%}else{%>
			document.frmretur.command.value="<%=JSPCommand.LOAD%>";
			document.frmretur.action="returitempo.jsp";
			document.frmretur.submit();
		//cmdVendorChange();
	<%}%>
}

function cmdToRecord(){
	document.frmretur.command.value="<%=JSPCommand.NONE%>";
	document.frmretur.action="returlist.jsp";
	document.frmretur.submit();
}

function cmdVendorChange(){
	var oid = document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_VENDOR_ID]%>.value;
	<%
	if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor v = (Vendor)vendors.get(i);
			%>
			if('<%=v.getOID()%>'==oid){
				document.frmretur.vnd_address.value="<%=v.getAddress()%>";
			}
			<%
		}
	}
	%>
	
}


function cmdCloseDoc(){
	document.frmretur.action="<%=approot%>/home.jsp";
	document.frmretur.submit();
}

function cmdAskDoc(){
	document.frmretur.hidden_retur_request_item_id.value="0";
	document.frmretur.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdDeleteDoc(){
	document.frmretur.hidden_retur_request_item_id.value="0";
	document.frmretur.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdCancelDoc(){
	document.frmretur.hidden_retur_request_item_id.value="0";
	document.frmretur.command.value="<%=JSPCommand.EDIT%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdSaveDoc(){
	document.frmretur.command.value="<%=JSPCommand.POST%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdAdd(){
	document.frmretur.hidden_retur_item_id.value="0";
	document.frmretur.command.value="<%=JSPCommand.ADD%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdAsk(oidReturItem){
	document.frmretur.hidden_retur_item_id.value=oidReturItem;
	document.frmretur.command.value="<%=JSPCommand.ASK%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdAskMain(oidRetur){
	document.frmretur.hidden_retur_id.value=oidRetur;
	document.frmretur.command.value="<%=JSPCommand.ASK%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="retur.jsp";
	document.frmretur.submit();
}

function cmdConfirmDelete(oidReturItem){
	document.frmretur.hidden_retur_item_id.value=oidReturItem;
	document.frmretur.command.value="<%=JSPCommand.DELETE%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}
function cmdSaveMain(){
	document.frmretur.command.value="<%=JSPCommand.SAVE%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="retur.jsp";
	document.frmretur.submit();
	}

function cmdSave(){
	document.frmretur.command.value="<%=JSPCommand.SAVE%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
	}

function cmdEdit(oidRetur){
	document.frmretur.hidden_retur_item_id.value=oidRetur;
	document.frmretur.command.value="<%=JSPCommand.EDIT%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
	}

function cmdCancel(oidRetur){
	document.frmretur.hidden_retur_item_id.value=oidRetur;
	document.frmretur.command.value="<%=JSPCommand.EDIT%>";
	document.frmretur.prev_command.value="<%=prevJSPCommand%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdBack(){
	document.frmretur.command.value="<%=JSPCommand.BACK%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
	}

function cmdListFirst(){
	document.frmretur.command.value="<%=JSPCommand.FIRST%>";
	document.frmretur.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdListPrev(){
	document.frmretur.command.value="<%=JSPCommand.PREV%>";
	document.frmretur.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
	}

function cmdListNext(){
	document.frmretur.command.value="<%=JSPCommand.NEXT%>";
	document.frmretur.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
}

function cmdListLast(){
	document.frmretur.command.value="<%=JSPCommand.LAST%>";
	document.frmretur.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmretur.action="returitempo.jsp";
	document.frmretur.submit();
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
                        <form name="frmretur" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspRetur.colNames[JspRetur.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_retur_item_id" value="<%=oidReturItem%>">
                          <input type="hidden" name="hidden_retur_id" value="<%=oidRetur%>">
                          <input type="hidden" name="<%=JspReturItem.colNames[JspReturItem.JSP_RETUR_ID]%>" value="<%=oidRetur%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_po_id" value="<%=oidPO%>">
						  <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
						  <input type="hidden" name="<%=JspRetur.colNames[JspRetur.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">
                                                   <% if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                                                      <input type="hidden" name="<%=JspRetur.colNames[JspRetur.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
						  <%}%>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Incoming 
                                      Goods </span>&raquo; <span class="lvl2"> 
                                      <%if(retur.getOID()==0){%>
                                      New 
                                      <%}%>
                                      PO Retur</span></font></b></td>
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
                                    <td>&nbsp;</td>
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
                                            <div align="center">PO Retur&nbsp;&nbsp;</div>
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
                                                <td height="21" valign="middle" width="13%">&nbsp;</td>
                                                <td height="21" valign="middle" width="31%">&nbsp;</td>
                                                <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                <td height="21" colspan="2" width="45%" class="comment" valign="top"> 
                                                  <div align="right"><i>Date : 
                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                    <%if(retur.getOID()==0){%>
                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                    <%}else{
													User us = new User();
													try{
														us = DbUser.fetch(retur.getUserId());
													}
													catch(Exception e){
													}
													%>
                                                    Prepared By : <%=us.getLoginId()%> 
                                                    <%}%>
                                                    </i>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                              <%
											     if(oidPO!=0){
											  		poR.setOidPo(oidPO);
											  %>
                                              <tr align="left"> 
                                                <td height="15" width="13%">&nbsp;&nbsp;PO 
                                                  Number </td>
                                                <td height="15" width="31%"> 
                                                  <input type="hidden" name="<%=JspRetur.colNames[JspRetur.JSP_PURCHASE_ID]%>" value="<%=po.getOID()%>">
                                                  <input type="text" name="textfield" class="readonly" value="<%=po.getNumber()%>" readOnly>
                                                  <%poR.setPoNumber(""+po.getNumber());%>
                                                </td>
                                                <td height="15" width="11%">&nbsp;</td>
                                                <td height="15" colspan="2" width="45%" class="comment">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="13%">&nbsp;&nbsp;PO 
                                                  Date</td>
                                                <td height="15" width="31%"> 
                                                  <input type="text" name="textfield2" class="readOnly" readonly value="<%=JSPFormater.formatDate(po.getPurchDate(), "dd/MM/yyyy")%>">
                                                  <%poR.setPoDate(po.getPurchDate());%>
                                                </td>
                                                <td height="15" width="11%">&nbsp;</td>
                                                <td height="15" colspan="2" width="45%" class="comment">&nbsp; 
                                                </td>
                                              </tr>
                                              <%}%>
                                              <tr align="left"> 
                                                <td height="15" width="13%">&nbsp;&nbsp;Incoming 
                                                  Number </td>
                                                <td height="15" width="31%"> 
                                                  <input type="text" name="textfield2" class="readOnly" readonly value="<%=receive.getNumber()%>">
                                                  <%poR.setIncomingNumber(receive.getNumber());%>
                                                </td>
                                                <td height="15" width="11%">DO 
                                                  Number </td>
                                                <td height="15" colspan="2" width="45%" class="comment"> 
                                                  <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_DO_NUMBER]%>" value="<%=receive.getDoNumber()%>" class="readonly" readonly>
                                                  <%=jspRetur.getErrorMsg(JspRetur.JSP_DO_NUMBER)%> 
                                                  <%poR.setDoNumber(receive.getDoNumber());%>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="15" width="13%">&nbsp;&nbsp;Incoming 
                                                  Date</td>
                                                <td height="15" width="31%"> 
                                                  <input type="text" name="textfield2" class="readOnly" readonly value="<%=JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy")%>">
                                                  <%poR.setIncomingDate(receive.getDate());%>
                                                </td>
                                                <td height="15" width="11%">Invoice 
                                                  Number </td>
                                                <td height="15" colspan="2" width="45%" class="comment"> 
                                                  <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_INVOICE_NUMBER]%>" value="<%=receive.getInvoiceNumber()%>" class="readonly" readonly>
                                                  <%=jspRetur.getErrorMsg(JspRetur.JSP_INVOICE_NUMBER)%> 
                                                  <%poR.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="13%">&nbsp;&nbsp;Vendor</td>
                                                <td height="20" width="31%"> 
                                                  <%
												Vendor vendor = new Vendor();
												try{
													vendor = DbVendor.fetchExc(receive.getVendorId());
												}
												catch(Exception e){
												}
												%>
                                                  <input type="hidden" name="<%=JspRetur.colNames[JspRetur.JSP_VENDOR_ID]%>" value="<%=receive.getVendorId()%>">
                                                  <input type="text" name="textfield" value="<%=vendor.getName()%>" size="40" readOnly class="readonly">
                                                  <%poR.setVendor(vendor.getName());%>
                                                </td>
                                                <td height="20" width="11%">Retur 
                                                  From</td>
                                                <td height="20" colspan="2" width="45%" class="comment"> 
                                                  <select name="<%=JspRetur.colNames[JspRetur.JSP_LOCATION_ID]%>">
                                                    <%                                          
													Vector locations = userLocations;//DbLocation.list(0,0, DbLocation.colNames[DbLocation.COL_TYPE]+"='"+DbLocation.TYPE_WAREHOUSE+"'", "code");
													  if(locations!=null && locations.size()>0){
														for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															
															if(retur.getLocationId()==d.getOID()){
															    poR.setReturFrom(d.getCode()+" - "+d.getName());	
															}
													%>
                                                    <option value="<%=d.getOID()%>" <%if(retur.getLocationId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="20" width="13%">&nbsp;&nbsp;Address</td>
                                                <td height="20" width="31%"> 
                                                  <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly"><%=vendor.getAddress()%></textarea>
                                                  <%poR.setAddress(vendor.getAddress());%>
                                                </td>
                                                <td width="11%" height="20">Doc 
                                                  Number</td>
                                                <td colspan="2" class="comment" width="45%" height="20"> 
                                                  <%
												  String number = "";
												  if(retur.getOID()==0){
													  int ctr = DbRetur.getNextCounter();
													  number = DbRetur.getNextNumber(ctr);
													  poR.setDocNumber(number);
												  }
												  else{
													  number = retur.getNumber();
													  poR.setDocNumber(number);
												  }
												  %>
                                                  <%=number%> </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="13%">&nbsp;&nbsp;</td>
                                                <td height="21" width="31%"> 
                                                  <%
                                              Vector currs = DbCurrency.list(0, 0, "", "");
                                              Vector exchange_value = new Vector(1,1);
                                                    Vector exchange_key = new Vector(1,1);
                                                    String sel_exchange = ""+retur.getCurrencyId();
                                                  if(currs!=null && currs.size()>0){
                                                        for(int i=0; i<currs.size(); i++){
                                                            Currency d = (Currency)currs.get(i);
                                                            exchange_key.add(""+d.getOID());
                                                            exchange_value.add(d.getCurrencyCode());
                                                        }
                                                  }          
                                              %>
                                                  <%//= JSPCombo.draw(JspRetur.colNames[JspRetur.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %>
                                                </td>
                                                <td width="11%">Status</td>
                                                <td colspan="2" class="comment" width="45%"> 
                                                  <%
											if(retur.getStatus()==null || retur.getStatus().length()==0){
												//out.println("status = null, set to draft");
												retur.setStatus(I_Project.DOC_STATUS_DRAFT);
											}	
											%>
                                                  <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){%>                                       
                                                  <input type="text" class="readOnly" name="stt" value="<%=(retur.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((retur.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : retur.getStatus())%>" size="15" readOnly>
                                                  <%}else{%>
                                                  <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="13%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="31%"> 
                                                  <input name="<%=JspRetur.colNames[JspRetur.JSP_DATE]%>" value="<%=JSPFormater.formatDate((retur.getDate()==null) ? new Date() : retur.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%poR.setDate(retur.getDate());%>
                                                </td>
                                                <td width="11%">Applay VAT</td>
                                                <td colspan="2" class="comment" width="45%"> 
                                                  <% 
                                                Vector include_value = new Vector(1,1);
												Vector include_key = new Vector(1,1);
												String sel_include = ""+retur.getIncluceTax();
												poR.setApplayVat(retur.getIncluceTax());
                                                include_value.add(DbRetur.strIncludeTax[DbRetur.INCLUDE_TAX_NO]);
                                                include_key.add(""+DbRetur.INCLUDE_TAX_NO);
                                                include_value.add(DbRetur.strIncludeTax[DbRetur.INCLUDE_TAX_YES]);
                                                include_key.add(""+DbRetur.INCLUDE_TAX_YES);
					   							%>
                                                  <%= JSPCombo.draw(JspRetur.colNames[JspRetur.JSP_INCLUDE_TAX],null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %> </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="13%">&nbsp;&nbsp;Payment 
                                                  Type </td>
                                                <td height="21" width="31%"> 
                                                  <% 
                                                Vector payment_value = new Vector(1,1);
												Vector payment_key = new Vector(1,1);
												String sel_payment = ""+retur.getPaymentType();
												poR.setPaymentType(""+retur.getPaymentType());
                                                payment_key.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CASH);
                                                payment_key.add(I_Project.PAYMENT_TYPE_CREDIT);
                                                payment_value.add(I_Project.PAYMENT_TYPE_CREDIT);
					   							%>
                                                  <%= JSPCombo.draw(JspRetur.colNames[JspRetur.JSP_PAYMENT_TYPE],null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                                <td width="11%">Term Of Payment</td>
                                                <td width="45%" colspan="2" class="comment"> 
                                                  <input name="<%=JspRetur.colNames[JspRetur.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((retur.getDueDate()==null) ? new Date() : retur.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmretur.<%=JspRetur.colNames[JspRetur.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%poR.setTop(retur.getDueDate());%>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              <tr align="left"> 
                                                <td height="21" width="13%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="<%=JspRetur.colNames[JspRetur.JSP_NOTE]%>" cols="55" rows="2"><%=retur.getNote()%></textarea>
                                                  <%poR.setNotes(retur.getNote());%>
                                                </td>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2" width="30%">Group/Category/Code 
                                                        - Name</td>
                                                      <td class="tablehdr" colspan="3" height="16">Quantity</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">@Price</td>
                                                      <td class="tablehdr" rowspan="2" width="12%">Discount</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">Total</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Unit</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="7%" height="18">Receive</td>
                                                      <td class="tablehdr" width="9%" height="18">Prev. 
                                                        Retur</td>
                                                      <td class="tablehdr" width="7%" height="18">Retur</td>
                                                    </tr>
                                                    <%
													if(temp!=null && temp.size()>0){
														for(int i=0; i<temp.size(); i++){
															ReceiveItem recItem = (ReceiveItem)temp.get(i);
															
															SessPoReturL poRL = new SessPoReturL();
															
															//out.println("recItem.getPurchaseItemId() : "+recItem.getPurchaseItemId()+", recItem.getItemMasterId() : "+recItem.getItemMasterId());
															
															PurchaseItem pi = new PurchaseItem();
															try{
																pi = DbPurchaseItem.fetchExc(recItem.getPurchaseItemId());
															}
															catch(Exception e){
															}
															
															ItemMaster im = new ItemMaster();
															ItemGroup ig = new ItemGroup();
															ItemCategory ic = new ItemCategory();
															Uom uom = new Uom();															
															try{
																im = DbItemMaster.fetchExc(recItem.getItemMasterId());
																ig = DbItemGroup.fetchExc(im.getItemGroupId());
																ic = DbItemCategory.fetchExc(im.getItemCategoryId());
																//uom = DbUom.fetchExc(pi.getUomId());
                                                                                                                                uom = DbUom.fetchExc(recItem.getUomId());
															}
															catch(Exception e){
															}
															
															double prevReturQty = DbReturItem.getTotalQtyRetur(recItem.getOID());
															ReturItem ri = DbReturItem.getReturItem(recItem.getOID(), oidRetur);
															
															if(i%2==0){
													%>
                                                    <tr> 
                                                      <td width="30%" class="tablecell1"> 
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]%>" value="<%=im.getOID()%>">
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_PURCHASE_ITEM_ID]%>" value="<%=pi.getOID()%>">
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_RECEIVE_ITEM_ID]%>" value="<%=recItem.getOID()%>">
                                                        <%=ig.getName()+"/"+ic.getName()+"/"+im.getName()%> 
                                                        <%poRL.setGroup(ig.getName()+"/"+ic.getName()+"/"+im.getName());%>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> <%=recItem.getQty()%> 
                                                          <input type="hidden" name="item_po" value="<%=recItem.getQty()%>">
                                                        </div>
                                                        <%poRL.setReceive(recItem.getQty());%>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"><%=prevReturQty - ri.getQty()%> 
                                                          <input type="hidden" name="prev_retur" value="<%=prevReturQty - ri.getQty()%>">
                                                        </div>
                                                        <%poRL.setPrevRetur(prevReturQty - ri.getQty());%>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>" size="5" style="text-align:center" onBlur="javascript:calcPrice(this, '<%=i%>')" value="<%=ri.getQty()%>" onClick="this.select()">
                                                        </div>
                                                        <%poRL.setRetur(ri.getQty());%>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(recItem.getAmount(), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setPrice(recItem.getAmount());%>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber((recItem.getTotalDiscount()/recItem.getQty()), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setDiscount(recItem.getTotalDiscount()/recItem.getQty());%>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(ri.getTotalAmount(), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setTotal(ri.getTotalAmount());%>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_UOM_ID]%>" value="<%=recItem.getUomId()%>">
                                                          <%=uom.getUnit()%> </div>
                                                        <%poRL.setUnit(uom.getUnit());%>
                                                      </td>
                                                    </tr>
                                                    <%
													  objRpt.add(poRL);
													  session.putValue("PO_DETAIL",objRpt);
													  //out.println("ini objRpt1 = "+objRpt);
													  }else{
													%>
                                                    <tr> 
                                                      <td width="30%" class="tablecell"> 
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]%>" value="<%=im.getOID()%>">
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_PURCHASE_ITEM_ID]%>" value="<%=pi.getOID()%>">
                                                        <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_RECEIVE_ITEM_ID]%>" value="<%=recItem.getOID()%>">
                                                        <%=ig.getName()+"/"+ic.getName()+"/"+im.getName()%> 
                                                        <%poRL.setGroup(ig.getName()+"/"+ic.getName()+"/"+im.getName());%>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"><%=recItem.getQty()%> 
                                                          <input type="hidden" name="item_po" value="<%=recItem.getQty()%>">
                                                        </div>
                                                        <%poRL.setReceive(recItem.getQty());%>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="center"><%=prevReturQty - ri.getQty()%> 
                                                          <input type="hidden" name="prev_retur" value="<%=prevReturQty - ri.getQty()%>">
                                                        </div>
                                                        <%poRL.setPrevRetur(prevReturQty - ri.getQty());%>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_QTY]%>" size="5" style="text-align:center" onBlur="javascript:calcPrice(this, '<%=i%>')" value="<%=ri.getQty()%>" onClick="this.select()">
                                                        </div>
                                                        <%poRL.setRetur(ri.getQty());%>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(recItem.getAmount(), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setPrice(recItem.getAmount());%>
                                                      </td>
                                                      <td width="12%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_DISCOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber((recItem.getTotalDiscount()/recItem.getQty()), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setDiscount(recItem.getTotalDiscount()/recItem.getQty());%>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>" size="20" class="readonly" readonly style="text-align:right" value="<%=JSPFormater.formatNumber(ri.getTotalAmount(), "#,###.##")%>">
                                                        </div>
                                                        <%poRL.setTotal(ri.getTotalAmount());%>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="<%=jspReturItem.colNames[JspReturItem.JSP_UOM_ID]%>" value="<%=recItem.getUomId()%>">
                                                          <%=uom.getUnit()%> </div>
                                                        <%poRL.setUnit(uom.getUnit());%>
                                                      </td>
                                                    </tr>
                                                    <%
														objRpt.add(poRL);
														//out.println("ini objRpt2 = "+objRpt);
														session.putValue("PO_DETAIL",objRpt);
													%>
                                                    <%}}}%>
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
                                                      <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="38%" valign="middle">&nbsp; 
                                                      </td>
                                                      <td width="55%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                          <tr> 
                                                            <td width="62%"> 
                                                              <div align="right"><b>Sub 
                                                                Total</b></div>
                                                            </td>
                                                            <td width="15%"> 
                                                              <input type="hidden" name="sub_tot" value="<%=subTotal%>">
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                              </div>
                                                              <%poR.setSubTotal(subTotal);%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>Discount</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input name="<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=retur.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calcTotal()" onClick="this.select()">
                                                                % </div>
                                                              <%poR.setDiscount1(retur.getDiscountPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(retur.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                              </div>
                                                              <%poR.setDiscount2(retur.getDiscountTotal());%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="60%"> 
                                                              <div align="right"><b>VAT</b></div>
                                                            </td>
                                                            <td width="17%"> 
                                                              <div align="center"> 
                                                                <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_TAX_PERCENT]%>" size="5" value="<%=retur.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                                                                % </div>
                                                              <% poR.setVat1(retur.getTaxPercent());%>
                                                            </td>
                                                            <td width="23%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="<%=JspRetur.colNames[JspRetur.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(retur.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                              </div>
                                                              <%poR.setVat2(retur.getTotalTax());%>
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
                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(retur.getTotalAmount()+retur.getTotalTax()+retur.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                              </div>
                                                              <%poR.setGrandTotal(retur.getTotalAmount()+retur.getTotalTax()+retur.getDiscountTotal());%>
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
                                              <%if(retur.getOID()!=0){%>
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
                                                        <%if(retur.getOID()!=0 && !retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="14%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <%if(( (!retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){%>
                                                          <tr> 
                                                            <td width="12%"><b>Set 
                                                              Status to</b> </td>
                                                            <td width="14%"> 
                                                              <select name="<%=JspRetur.colNames[JspRetur.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if( retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                <%if(posApprove1Priv){%>
                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if( retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                <%}%>
                                                                <%if(posApprove2Priv && 1==2){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if( retur.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                <%}%>
                                                                <%if(posApprove4Priv && 1==2){%>
                                                                <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if( retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
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
															if(retur.getOID()!=0){
													%>
                                                    <tr> 
                                                      <td colspan="4" class="errfont"><%=msgString%></td>
                                                    </tr>
                                                    <%		}%>
                                                    <%if(temp!=null && temp.size()>0){
														//if(retur.getOID()!=0){
													%>
                                                    <tr> 
                                                      <%if((( !retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode!=0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO"))){%>
                                                      <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                      <td width="102" > 
                                                        <div align="left"> 
                                                          <%if(retur.getOID()!=0){%>
                                                          <a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a> 
                                                          <%}else{%>
                                                          <a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211113','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211113" border="0"></a> 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                      <%}%>
                                                      <td width="97"> 
                                                        <div align="left"> 
                                                          <%if(retur.getOID()!=0){%>
                                                          <a href="javascript:cmdPrintPdf()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a> 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                      <td width="862"> 
                                                        <div align="left"> 
                                                          <%if(retur.getOID()!=0){%>
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
                                                          retur item for vendor</i></font></div>
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
                                              <%if(retur.getOID()!=0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES") ){%>
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
													u = DbUser.fetch(retur.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i><%=JSPFormater.formatDate(retur.getDate(), "dd MMMM yy")%></i></div>
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
													u = DbUser.fetch(retur.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%if(retur.getApproval1()!=0){%>
                                                          <%=JSPFormater.formatDate(retur.getApproval1Date(), "dd MMMM yy")%> 
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
							<%if(iErrCode2==0 &&(retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && returItem.getOID()!=0) || iErrCode!=0))){%>
                            	parserMaster();
							<%}%>
                          </script>
                          <script language="JavaScript">
						    <%if(retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.EDIT && returItem.getOID()!=0) || iErrCode!=0)){%>
									//alert('in here');
									//cmdChangeItem();																		
							<%}							
							if(retur.getOID()!=0 && !retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){%>
									//cmdClosedReason();
							<%}%>
							</script>
							
							<%
							  session.putValue("PO_TITTLE",poR);
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
