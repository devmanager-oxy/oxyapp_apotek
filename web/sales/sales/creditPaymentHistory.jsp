
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>

<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksl.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = true; 
	boolean masterPrivView = true; 
	boolean masterPrivUpdate = true; 
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspCreditPayment frmObject, CreditPayment objEntity, Vector objectClass, long creditPaymentId, 
	long itemMasterId, String approot, long currencyId)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		//jsplist.addHeader("Sales Id","1%");
		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Date","25%");
		//jsplist.addHeader("Category","14%");
		//jsplist.addHeader("Status","6%");		
		jsplist.addHeader("Currency","15%");
		jsplist.addHeader("Rate","15%");
		jsplist.addHeader("Amount","20%");
		jsplist.addHeader("Total(Rp)","20%");
		

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		
		/*
		String wh = "company_id="+systemCompanyId+
			" and ("+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_FINISH_GOODS]+
			" or "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_COMPONENT]+
			" or "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_CIVIL_WORK]+
			")";
		*/
			
	   /*String wh = "("+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_FINISH_GOODS]+
			" or "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_COMPONENT]+
			" or "+DbItemMaster.colNames[DbItemMaster.COL_TYPE]+"="+I_Ccs.strType[I_Ccs.TYPE_CATEGORY_CIVIL_WORK]+
			")";
			*/
		
		//String wh = "for_sales=1 "; //and item_group_id="+itemGroupId;	

		Vector vCurr = DbCurrency.listAll();
		Vector curr_value = new Vector(1,1);
		Vector curr_key = new Vector(1,1);
                if(iCommand != JSPCommand.EDIT){
                    if(vCurr!=null && vCurr.size()>0)
                    {
                            for(int i=0; i<vCurr.size(); i++)
                            {
                                    Currency c = (Currency)vCurr.get(i);
                                    //jika kosong dan urutan pertama
                                    if(currencyId==0 && i==0){
                                            currencyId = c.getOID();
                                    }
                                    curr_key.add(c.getCurrencyCode().trim());
                                    curr_value.add(""+c.getOID());
                            }

                    }
		}else{
                    //if(itemMasterId==0 ){
			//		itemMasterId = objEntity.getProductMasterId();
			//	}
               }
                    
                   
                 
		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		//for(int i=0; i<I_Crm.productStatusStr.length; i++){
		//	status_value.add(""+i);
		//	status_key.add(I_Crm.productStatusStr[i]);
		//}
		//status_value.add(""+I_Crm.PRODUCT_STATUS_DRAFT);
	//	status_key.add(I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_DRAFT]);
	//	status_value.add(""+I_Crm.PRODUCT_STATUS_MANUFACTURING);
	//	status_key.add(I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_MANUFACTURING]);

		for (int i = 0; i < objectClass.size(); i++) 
		{
			CreditPayment objCreditPayment = (CreditPayment)objectClass.get(i);
			rowx = new Vector();
			if(creditPaymentId == objCreditPayment.getOID())
				index = i;
                        
			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objCreditPayment.getOID()!=0))){
				//if(sales.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){				
					//objEntity.setProductMasterId(itemMasterId);
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SALES_ID] +"\" value=\""+objCreditPayment.getSales_id()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objCreditPayment.getCurrency_id()+"\">"+
							 "<input type=\"text\" name=\"nomor\" value=\""+(i+1)+"\" class=\"formElemen\" size=\"5\">");
					
					CreditPayment  creditPayment = new CreditPayment();
					ItemMaster colCombo2  = new ItemMaster();
					try{
						//colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
                                            creditPayment = DbCreditPayment.fetchExc(creditPaymentId);
                                           // creditPaymentMain = DbCreditPaymentMain.fetchExc(creditPayment.getCredit_payment_main_id());
					}catch(Exception e) {
						System.out.println(e);
					}
                                        //rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a>") ;
					Currency curr = new Currency();
					try{
                                            curr = DbCurrency.fetchExc(objCreditPayment.getCurrency_id());
                                            
					}catch(Exception e){
						//System.out.println(e);
					}
					
					//rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\"0\" class=\"formElemen\" size=\"5\">"+
					// "<input type=\"text\" style=\"text-align:right\" class=\"formElemen\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
                                        //rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objEntity.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
                                        rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"date\" value=\""+creditPayment.getPay_datetime()+"\" class=\"readonly\" size=\"5\" readOnly>");
                                        rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\"0\">"+
                                                         "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+curr.getCurrencyCode()+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_CURRENCY_ID));		
                                        rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
                                                         "<input style=\"text-align:right\" type=\"text\" name=\"rate\" value=\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">");		
                                        //rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objEntity.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
                                        rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(creditPayment.getAmount(),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT));
				//}else{//jika statusna bukan draft
				//	rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SALES_ID] +"\" value=\""+objSalesDetail .getSalesId()+"\">" +
				//			 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objSalesDetail .getCurrencyId()+"\">" +
				//			 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+(i+1)+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE) +
				//			 "<div align=\"center\">"+String.valueOf(objSalesDetail .getSquence())+"</div>");
				//	//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+objSalesDetail .getProductMasterId(), ItemMaster_value , ItemMaster_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
				//	ItemMaster colCombo2  = new ItemMaster();
				//	try{
				//		colCombo2 = DbItemMaster.fetchExc(objSalesDetail .getProductMasterId());
				//	}catch(Exception e) {
				//		System.out.println(e);
				//	}
				//	Uom uom = new Uom();
				//	try{
				//		uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				//	}catch(Exception e){
				//		System.out.println(e);
				//	}
					
				//	rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID]+"\" value=\""+objSalesDetail .getProductMasterId()+"\" class=\"readonly\" size=\"30\" readOnly>"+
				//			 colCombo2.getName());
					//rowx.add("<input type=\"text\" name=\"category\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");
					//rowx.add("<div align=\"left\">"+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"</div>");
					//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objSalesDetail .getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS));				
				//	rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\""+objSalesDetail .getQty()+"\" class=\"formElemen\" size=\"5\">"+
				//			 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objSalesDetail .getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY)+
				//			 "<div align=\"center\">"+String.valueOf(objSalesDetail .getQty())+"</div>");						
				//	rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>"); 
				//	rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objSalesDetail .getSellingPrice(),"#,###.##")+"\">"+
				//			 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objSalesDetail .getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
				//			 "<div align=\"right\">"+(objSalesDetail .getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getSellingPrice(), "#,###.##"))+"</div>");				
				//	rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\""+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(),"#,###.##")+"\">"+
				//			 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
				//			 "<div align=\"right\">"+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(), "#,###.##")+"</div>");	
				//	rowx.add("<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objSalesDetail .getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL)+
				//			 "<div align=\"right\">"+(objSalesDetail .getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getTotal(), "#,###.##"))+"</div>");			
				//}
			}
			else//jika bukan edit
			{				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				//CreditPayment creditPayment = new CreditPayment();
                                
                                Currency curr = new Currency();
				try{
					//colCombo2 = DbItemMaster.fetchExc(objSalesDetail .getProductMasterId());
                                    //creditPayment = DbCreditPayment.fetchExc(creditPaymentId);
                                    curr = DbCurrency.fetchExc(objCreditPayment.getCurrency_id());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					
				}catch(Exception e){
					System.out.println(e);
				}
				//if(sales.getStatus()==1){//I_Crm.PROJECT_STATUS_CLOSE || sales.getStatus()==I_Crm.PROJECT_STATUS_AMEND || sales.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
				//	rowx.add(colCombo2.getName());
				//}else{
                                        //rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objSalesDetail .getOID())+"')\">"+colCombo2.getName()+"</a>");
				//	rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objSalesDetail .getOID())+"','"+String.valueOf(colCombo2.getOID())+"')\">"+colCombo2.getName()+"</a>");
				//}
				rowx.add("<div align=\"center\">"+String.valueOf(objCreditPayment.getPay_datetime())+"</div>" );
				rowx.add("<div align=\"center\">"+String.valueOf(curr.getCurrencyCode())+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(JSPFormater.formatNumber(curr.getRate(),"#,###.##"))+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(JSPFormater.formatNumber(objCreditPayment.getAmount(),"#,###.##"))+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(JSPFormater.formatNumber(objCreditPayment.getAmount() * curr.getRate(),"#,###.##"))+"</div>");
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
			
                    rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
                             
			//rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CREDIT_PAYMENT_MAIN_ID] +"\" value=\""+creditPaymentMain.getOID()+"\">"+
			//		 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+creditPaymentMain.getInv_number()+"\">");
		               			 
			
			//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+itemMasterId, ItemMaster_value , ItemMaster_key, "onchange=\"javascript:checkProduct()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
			
		//	ItemMaster colCombo2  = new ItemMaster();
		//	try{
		//		colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
		//	}catch(Exception e) {
		//		System.out.println(e);
		//	}
                        //rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a>") ;
		//	Uom uom = new Uom();
		//	try{
		//		uom = DbUom.fetchExc(colCombo2.getUomSalesId());
		//	}catch(Exception e){
		//		System.out.println(e);
		//	}
			//rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\"0\" class=\"formElemen\" size=\"5\">"+
					// "<input type=\"text\" style=\"text-align:right\" class=\"formElemen\" name=\"no\" value=\""+objEntity"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objEntity.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
		//	rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
		//	rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\"0\">"+
		// 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(colCombo2.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
		//	rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
		// 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objEntity.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
		//	rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(colCombo2.getSellingPrice()*objEntity.getQty(),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
                    rowx.add("<div align=\"center\"><input name=\"" + frmObject.colNames[frmObject.JSP_DATETIME_PAY] + "\" value=\"" + JSPFormater.formatDate((objEntity.getPay_datetime() == null) ? new Date() : objEntity.getPay_datetime(), "dd/MM/yyyy") + "\" size=\"10\" readonly>" +
                    "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmsalesproductdetail." + frmObject.colNames[frmObject.JSP_DATETIME_PAY] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");                 
                       // rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
			//		 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_RATE] +"\" value=\"0\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_RATE));		
                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    strVal += "<tr><td colspan=\"4\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspCreditPayment.JSP_CURRENCY_ID], null, "" + objEntity.getCurrency_id(), curr_value, curr_key, "onchange=\"javascript:parserCurrency()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_CURRENCY_ID) + "</div></td></tr>";    
                    
                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";
                    rowx.add(strVal);
                                        
                    rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_RATE] +"\" value=\"0\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_RATE));		
                    rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_AMOUNT] +"\" value=\"0\" class=\"formElemen\" size=\"35\" onClick=\"this.select()\" onBlur=\"javascript:getTotalAmount()\">"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT));
                    rowx.add("<input style=\"text-align:right\" type=\"text\" name=\"totalRp\" value=\"0\" class=\"formElemen\" size=\"35\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_AMOUNT));
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				SalesDetail salesProductDetail = (SalesDetail )listx.get(i);
				result = result + (salesProductDetail.getSellingPrice()*salesProductDetail.getQty()) - (salesProductDetail.getDiscountAmount());
			}
		}
		return result;
	}
	
	public long getValidId(long oid, Vector vItemMaster){
		
		if(vItemMaster!=null && vItemMaster.size()>0)
		{
			long selOID = 0;
			for(int i=0; i<vItemMaster.size(); i++)
			{
				ItemMaster c = (ItemMaster)vItemMaster.get(i);
				
				//jika kosong dan urutan pertama
				if(oid==c.getOID()){
					return oid;
				}
			}
			
			ItemMaster c = (ItemMaster)vItemMaster.get(0);			
			return c.getOID();
			
		}
		
		return 0;
		
	}
	
	public double getTtDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				//SalesTerm salesTerm = (SalesTerm)listx.get(i);
				result = 0;//result + salesTerm.getAmount();
				//System.out.println(salesTerm.getAmount());
			}
		}
		return result;
	}

	
%>
<%	
	long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");
	//long itemGroupId = JSPRequestValue.requestLong(request, JspSales.colNames[JspSales.JSP_ITEM_GROUP_ID]);
	long itemMasterId = JSPRequestValue.requestLong(request, JspSalesDetail.colNames[JspSalesDetail.JSP_PRODUCT_MASTER_ID]);
        //long itemMasterId = JSPRequestValue.requestLong(request, "hidden_item_master_id");
        //long itemMasterId = JSPRequestValue.requestLong(request, "hidden_item_master_id");
        //long oidPayment = JSPRequestValue.requestLong(request, "hidden_payment_id");
        //long oidReturnPayment = JSPRequestValue.requestLong(request, "hidden_return_payment_id");
        long oidCreditPayment = JSPRequestValue.requestLong(request, "hidden_credit_payment_id");
        //long oidCreditPaymentMain = JSPRequestValue.requestLong(request, "hidden_credit_payment_main_id");
        long oidCashCashier = JSPRequestValue.requestLong(request, JspCreditPayment.colNames[JspCreditPayment.JSP_CASH_cASHIER]);          
        boolean lunas = false;        
        long currencyId = 0;
        long i = user.getOID();
        Company com = new Company();
	try{
              com = DbCompany.fetchExc(user.getCompanyId());
              
        }catch(Exception E){}
	//out.println("itemMasterId : "+itemMasterId);
        
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                com= (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        
        
	
	Sales sales = new Sales();
        CreditPayment creditPayment = new CreditPayment();
        //CreditPaymentMain creditPaymentMain = new CreditPaymentMain();
        
	Customer customer = new Customer();
	Currency currency = new Currency();
	
	
	Vector vCurrency = DbCurrency.listAll();
        
        
	
	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidSalesDetail = JSPRequestValue.requestLong(request, "hidden_salesproductdetail");

	// variable declaration
	int recordToGet = 10000;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + "=" +oidSales;
	String orderClause = "";
	
	
	
	
	
	//sales detail
	CmdCreditPayment cmdCP = new CmdCreditPayment(request);
        Shift shift = new Shift();
	JSPLine jspLine = new JSPLine();
	Vector listCP = new Vector(1,1);

	// switch statement
	//iErrCode = cmdSalesDetail .action(iCommand , oidSalesDetail, systemCompanyId);
	iErrCode = cmdCP.action(iCommand , oidCreditPayment, oidSales);
        
       
        
        
	// end switch
	JspCreditPayment  jspCP = cmdCP.getForm();

	// count list All SalesDetail 
	int vectSize = DbCreditPayment.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspSalesDetail .getErrors());

	//creditPayment salesProductDetail = cmdSalesDetail.getSalesDetail ();
	msgString =  cmdCP.getMessage();
        
        //if(iCommand == JSPCommand.POST){
           // Payment payment = new Payment();
            
        //    CmdPayment cmdPayment= new CmdPayment(request);
        //    iErrCode = cmdPayment.action(iCommand , oidPayment, oidSales);
        //    JspPayment jspPayment = cmdPayment.getForm();
        //    payment = cmdPayment.getPayment();
        //    oidPayment= payment.getOID();
            
        //    CmdReturnPayment cmdReturnPayment = new CmdReturnPayment(request);
        //    iErrCode = cmdReturnPayment.action(iCommand , oidReturnPayment, oidSales);
        //    JspReturnPayment jspReturnPayment = cmdReturnPayment.getForm();
        //    returnPayment = cmdReturnPayment.getReturnPayment();
        //    oidReturnPayment= returnPayment.getOID();
        //}
	
	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdCP.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listCP = DbCreditPayment.list(start, recordToGet, whereClause, orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listCP.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listCP = DbCreditPayment.list(start,recordToGet, whereClause , orderClause);
	}
	try{			
			                        sales = new DbSales().fetchExc(oidSales);	
                        customer = DbCustomer.fetchExc(sales.getCustomerId());
		}
		catch(Exception e){
			
	}
       
	/*double subTotal = totalAmount;
        
	//Company
	Company company = new Company();
	try{
		company = DbCompany.getCompany();
	}catch(Exception e){
		System.out.println(e);
	}
	
	//Discount to total
	double discountTotal = sales.getDiscountAmount();
	double discountPercent = sales.getDiscountPercent();
	if(sales.getDiscount()>0){
		totalAmount = totalAmount - discountTotal;
	}
	
	//Vat
	double percentVat = company.getGovernmentVat();
	double vat = percentVat/100*totalAmount;
	if(sales.getVat()>0){
		totalAmount = totalAmount + vat;
	}
		
	double totalBalance = sales.getAmount()-totalAmount;
	//totalBalance = Math.round(totalBalance*100)/100;	
	totalBalance = 0;// ga ada balance lagi
	//out.println(totalBalance);
	*/
	//out.println(iCommand);
	if (iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE){

		//sales.setVat(JSPRequestValue.requestInt(request, jspSales.colNames[jspSales.JSP_VAT]));		
		//sales.setVatPercent(JSPRequestValue.requestDouble(request, jspSales.colNames[jspSales.JSP_VAT_PERCENT]));		
		//sales.setDiscount(JSPRequestValue.requestInt(request, jspSales.colNames[jspSales.JSP_DISCOUNT]));
		//sales.setDiscountPercent(JSPRequestValue.requestDouble(request, jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT]));
		
		//DbSales.updateSalesAmount(oidSales, sales);
		
	}
	
	//if(oidCreditPaymentMain!=0){
	//	try{			
	//		creditPaymentMain = DbCreditPaymentMain.fetchExc(oidCreditPaymentMain);	
          //              sales = new DbSales().fetchExc(oidSales);	
          //              customer = DbCustomer.fetchExc(sales.getCustomerId());
	//	}
	//	catch(Exception e){
			
	//	}
	//}
	
	
	//out.println("sales status : "+sales.getStatus());
	//out.println("oidSales : "+oidSales);
	//out.println("oidSales : "+sales.getOID());
	//out.println("<br>vat% : "+sales.getVatPercent());
	//out.println("<br>dic% : "+sales.getDiscountPercent());
	

	
	
	//out.println("<br>uniUsahaId : "+uniUsahaId);

	if (iCommand==JSPCommand.SUBMIT){
		
		if(oidSalesDetail>0){
			iCommand = JSPCommand.EDIT;
		}else{
			iCommand = JSPCommand.ADD;
		}
	}
	
	//out.println("amount ="+JSPFormater.formatNumber(ttAmount, "#,###.##"));
	//out.println("balance ="+JSPFormater.formatNumber(ttBalance, "#,###.##"));
        
        if(DbCreditPayment.getTotalPayment("sales_id=" + oidSales)>=sales.getAmount()){
            lunas = true;
        }
        if(lunas){
            sales.setPaymentStatus(DbSales.TYPE_LUNAS);
            DbSales.updateExc(sales);
        }
        
        

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">
	<%if(iCommand==JSPCommand.START && iErrCode==0){%>
		window.location="saleslist.jsp";
	<%}%>

	<%if(!masterPriv || !masterPrivView){%>
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
        function cmdAddItemMaster(){            
             
             
             window.open("<%=approot%>/sales/addItemMaster.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
             document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsalesproductdetail.submit();    
            }
	function cmdCheckIt(){
				

		cmdUpdateDiscount();
	} 

	function cmdUpdateDiscount(){	
		
	}
	
	function cmdUpdateDiscount1(){	
		
		
		
	}
         
        function parserCurrency(){
         var str = document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_CURRENCY_ID]%>.value;
        
            <%
                Currency cur = new Currency();
                if(vCurrency != null && vCurrency.size() >0){
                   for(int a=0;a<vCurrency.size();a++){
                       cur = (Currency) vCurrency.get(a);
                       
                       
            %>  
                 
                if('<%=cur.getOID()%>'==str){                 
                    document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_RATE]%>.value="<%=cur.getRate()%>";
                                  
                }
                            
            <%
                        
                }
             }      
            %>
                        
           
        }
	function cmdCashCashier(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmsalesproductdetail.action="creditPaymentHistory.jsp";
                document.frmsalesproductdetail.submit();
                
        }
	
	function cmdUpdateDoc(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.POST%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp";
                if(document.frmsalesproductdetail.cekPayment.value != 1) {
                    document.frmsalesproductdetail.submit()
                }else{
                    alert("payment is less");
                }
                
	}
        
        
        function getTotalAmount(){
            
            var rate = document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_RATE]%>.value;
            
            var amount = document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_AMOUNT]%>.value;
           
            rate = removeChar(rate);
            rate= cleanNumberFloat(rate, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_RATE]%>.value = formatFloat(''+rate, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                        
            amount = removeChar(amount);
            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmsalesproductdetail.<%=JspCreditPayment.colNames[JspCreditPayment.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	

            
            var totalItemAmount = (parseFloat(amount) * parseFloat(rate));
            document.frmsalesproductdetail.totalRp.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
   
 
        }    
	
	function cmdDeleteDoc(){
		if(confirm("Sure to delete sales doc ?")){
			document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
			document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
			document.frmsalesproductdetail.command.value="<%=JSPCommand.START%>";
			document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
			document.frmsalesproductdetail.action="creditPaymentHistory.jsp";
			document.frmsalesproductdetail.submit();
		}
	}
		
	function cmdAdd(){
                 
                
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
                document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.ADD%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdAsk(oidSalesDetail){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.ASK%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	

	

	

	function cmdCancel(oidSalesDetail){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdBack(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.BACK%>";
		//document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		//document.frmsalesproductdetail.command.value="<%=JSPCommand.ADD%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
		}

	function cmdListFirst(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.FIRST%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdListPrev(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.PREV%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
		}

	function cmdListNext(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.NEXT%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdListLast(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.LAST%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmsalesproductdetail.action="creditPaymentHistory.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
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
<!--End Region JavaScript-->
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/new2.gif','../images/savedoc.gif2.gif','../images/savedoc2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td> 
                                                <!--Begin Region Content-->
                                                <form name="frmsalesproductdetail" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="cekPayment" value="0">
                                                  
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_salesproductdetail" value="<%=oidSalesDetail%>">
						  <input type="hidden" name="hidden_sales_id" value="<%=oidSales%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  												  
												  
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              </font><font class="tit1">&raquo; 
                                                              <span class="lvl2"> 
                                                              Credit Payment<br>
                                                              </span></font></b></td>
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
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td height="18" width="10%">Company 
                                                                     </td>
                                                                  <td width="30%"> 
                                                                    <%= com.getName()      %>
                                                                        
                                                                  </td>
                                                                  <td width="6%">Date</td>
                                                                  <td width="54%"><b><%=JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy")%><b></b></td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td height="18" width="10%">Number</td>
                                                                  <td width="30%"><strong> 
                                                                      <%=sales.getNumber()%>  
                                                                   
                                                                    
                                                                  </strong></td>
                                                                  <td width="6%">Note</td>
                                                                  <td width="54%"> 
                                                                    
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="5"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15" nowrap>Sales 
                                                                    Type </td>
                                                                  <td width="30%"><strong> 
                                                                    Credit
                                                                  <strong>  
                                                                  </td>
                                                                  <td width="6%">Customer</td>
                                                                  <td width="54%"><strong> 
                                                                      <%=customer.getName()%>
                                                                      <strong>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15" nowrap>Payment
                                                                    Status </td>
                                                                  <td width="30%">	
                                                                  <%if(sales.getPaymentStatus()==0){ %>
                                                                    <strong>Fully paid</strong>
                                                                  <%}else{%>
                                                                    <strong>Partially paid</strong>
                                                                  <%}%>  
                                                                  </td>
                                                                  <td width="6%">Shift</td>
                                                                  <td width="54%"><strong> 
                                                                      <%=shift.getName()%>
                                                                      <strong>
                                                                  </td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td colspan="4" height="5" nowrap></td>
                                                                </tr>
                                                                <%
                                                                                double totalPayment = DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+"=" + oidSales);
                                                                                double balance = sales.getAmount() - totalPayment;
                                                                            
                                                                            %>
                                                                <tr> 
                                                                  <td width="10%" height="15" nowrap><b><font color="#FF0000" size="2">Balance</font></b></td>
                                                                  <td width="30%"><font color="#FF0000" size="2"><b>: 
                                                                    <%=JSPFormater.formatNumber(balance,"#,###.##")%></b></font></td>
                                                                  <td width="6%">&nbsp;</td>
                                                                  <td width="54%">&nbsp;</td>
                                                                </tr>
                                                                 
                                                                
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="30%">&nbsp;</td>
                                                                  <td width="6%">&nbsp;</td>
                                                                  <td width="54%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Payment 
                                                                    Detail</b></td>
                                                                </tr>
                                                                <%
			 try
			 {
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawList(iCommand,jspCP , creditPayment,listCP,oidCreditPayment, i, approot, currencyId)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <% 
			 } catch(Exception exc){}
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="4" class="command" valign="top"> 
                                                                    <span class="command"> 
                                                                    <% 
			 int cmd = 0;
			 if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
			   cmd =iCommand; 
			 else{
			   if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
				 cmd = JSPCommand.FIRST;
			   else 
				 cmd =prevCommand; 
			 } 
		   %>
                   <% 
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
			 jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
			 jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
			 jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");

			 jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
			 jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
			 jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
			 jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
		   %>
                                                                    <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                                    </span> </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4" class=""> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="60%" valign="top"> 
                                                                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                              <td>&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td> 
                                                                                <%
                                                                                        					 jspLine.setLocationImg(approot+"/images/ctr_line");
																 jspLine.initDefault();
																 jspLine.setTableWidth("80%");
																 String scomDel = "javascript:cmdAsk('"+oidSalesDetail+"')";
																 String sconDelCom = "javascript:cmdConfirmDelete('"+oidSalesDetail+"')";
																 String scancel = "javascript:cmdEdit('"+oidSalesDetail+"')";
																 jspLine.setBackCaption("Back to List");
																 jspLine.setJSPCommandStyle("buttonlink");
																 jspLine.setDeleteCaption("Delete");
													
																 jspLine.setOnMouseOut("MM_swapImgRestore()");
																 jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
																 jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
													
																 //jspLine.setOnMouseOut("MM_swapImgRestore()");
																 jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
																 jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
													
																 jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
																 jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
													
																 jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
																 jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
													
																 jspLine.setWidthAllJSPCommand("90");
																 jspLine.setErrorStyle("warning");
																 jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
																 jspLine.setQuestionStyle("warning");
																 jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
																 jspLine.setInfoStyle("success");
													
																 jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");
													
																 if (privDelete)
													
																 {
																   jspLine.setConfirmDelJSPCommand(sconDelCom);
																   jspLine.setDeleteJSPCommand(scomDel);
																   jspLine.setEditJSPCommand(scancel);
																 }else
																 { 
																   jspLine.setConfirmDelCaption("");
																   jspLine.setDeleteCaption("");
																   jspLine.setEditCaption("");
																 }
													
																 if(privAdd == false  && privUpdate == false)
																 {
																   jspLine.setSaveCaption("");
																 }
													
																 if (privAdd == false)
																 {
																   jspLine.setAddCaption("");
																 }
																 
																
																 
															   %>
                                                                                <%
																 if(sales.getStatus()==0 && (iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0))
																 {
															   %>
                                                                                <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                                <%
																 }
															   %>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                        <td width="40%" class="boxed1"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td width="37%" class="tablecell" align="left"><strong>&nbsp;&nbsp;&nbsp;TOTAL INVOICE</strong></td>
                                                                              <td width="25%" class="tablecell" align="right"></td>
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                  <div align="right"><b><%=JSPFormater.formatNumber(sales.getAmount(), "#,###.##")%></b> </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%
                                                                                //double totalPayment = DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+"=" + oidSales);
                                                                                //double balance = sales.getAmount() - totalPayment;
                                                                            
                                                                            %>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;TOTAL PAID</strong></td>
                                                                              <td width="25%" class="tablecell" align="right"></td>
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalPayment, "#,###.##")%></b> </div>
                                                                              </td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;BALANCE</strong></td>
                                                                              <td width="25%" class="tablecell" align="right"></td>
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                <div align="right"><b><%=JSPFormater.formatNumber(balance,"#,###.##")%></b> </div>
                                                                              </td>
                                                                            </tr>
                                                                                                                                       
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"> 
                                                                          <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                
                                                                              
                                                                                <!--img src="../images/print.gif" width="53" height="22"-->
                                                                               
                                                                              
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          
                                                          <tr align="left" valign="top" > 
                                                            <td colspan="3" class="command">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                                 <script language="JavaScript">
                                                                    parserCurrency();
                                                                    getTotalAmount();
                                                                 </script>
                                                          <tr> 
                                                            <td colspan="3" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
											
						//cmdCheckIt();
					</script>
                                                </form>
                                                <!--End Region Content-->
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
                              </table>
                            </td>
                          </tr>
                        </table>
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
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

