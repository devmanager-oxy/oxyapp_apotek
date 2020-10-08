
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/checksl.jsp" %>
<%
	
	boolean privAdd 	= true; 
	boolean privUpdate	= true; 
	boolean privDelete	= true; 
	boolean masterPriv      = true; 
	boolean masterPrivView  = true; 
	boolean masterPrivUpdate= true; 
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspSalesDetail  frmObject, SalesDetail objEntity, Vector objectClass, long salesDetailId, Sales sales, 
	long itemMasterId, boolean useStockCode, boolean useStockCodeSales, Vector listStockCode, double qty, Vector vStockCode, Customer customer, int iErr, boolean isSave, double sellPrice, boolean optionalCode)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Product","25%");		
		jsplist.addHeader("Qty","5%");
		jsplist.addHeader("UOM","5%");
		jsplist.addHeader("Selling Price","15%");
		jsplist.addHeader("Discount","10%");
		jsplist.addHeader("Total Sales","15%");		

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		
		String wh = "for_sales=1 "; //and item_group_id="+itemGroupId;	

		Vector vItemMaster = DbItemMaster.list(0,0, wh, "name");		
		Vector ItemMaster_value = new Vector(1,1);
		Vector ItemMaster_key = new Vector(1,1);
                if(iCommand != JSPCommand.EDIT){
                    if(vItemMaster!=null && vItemMaster.size()>0)
                    {
                            for(int i=0; i<vItemMaster.size(); i++)
                            {
                                    ItemMaster c = (ItemMaster)vItemMaster.get(i);
                                    //jika kosong dan urutan pertama
                                    if(itemMasterId==0 && i==0){
                                            itemMasterId = c.getOID();
                                    }
                                    ItemMaster_key.add(c.getName().trim());
                                    ItemMaster_value.add(""+c.getOID());
                            }
                            itemMasterId = getValidId(itemMasterId, vItemMaster);
                    }
		}else{
                    if(itemMasterId==0 ){
					itemMasterId = objEntity.getProductMasterId();
		}
               }
               ItemMaster itemMaster = new ItemMaster();
               try{
                   itemMaster = DbItemMaster.fetchExc(itemMasterId);
               }catch(Exception e){
                   
               }
		if(itemMaster.getApplyStockCode()==DbItemMaster.APPLY_STOCK_CODE){
                    useStockCode=true;
                }
                 
		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		

		for (int i = 0; i < objectClass.size(); i++) 
		{
			SalesDetail objSalesDetail = (SalesDetail )objectClass.get(i);
			rowx = new Vector();
			if(salesDetailId == objSalesDetail .getOID())
				index = i;
                        
			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || ((frmObject.getErrors().size() > 0 || iErr > 0 ) && objSalesDetail .getOID()!=0))){
				if(sales.getStatus()==I_Ccs.SALES_STATUS_DRAFT){				
					objEntity.setProductMasterId(itemMasterId);
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SALES_ID] +"\" value=\""+objSalesDetail .getSalesId()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objSalesDetail .getCurrencyId()+"\">"+
							 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+(i+1)+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
					
                                        ItemMaster colCombo2  = new ItemMaster();
                                try{
                                        colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
                                }catch(Exception e) {
                                        System.out.println(e);
                                }
                                        
                                        String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                                        strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";

                                        int cntStockCode = 0;

                                    if (useStockCodeSales){

                                        int pg = 1;
                                        int counter = 0;
                                        double recItmQty = qty <= 0 ? 1 : qty;
                                        strVal += "<tr><td colspan=\"4\" height=\"5\"></td></tr>";
                                        strVal += "<tr><td width=\"10%\"></td><td class=\"tablehdr\" width=\"15%\">No</td><td class = \"tablehdr\" width=\"70%\">Stock Code</td><td></td></tr>";

                                        for (double xx = 0; xx < recItmQty; xx++) {

                                            cntStockCode++;
                                            StockCode stockCode = new StockCode();
                                            try {
                                              stockCode = (StockCode) vStockCode.get(counter);
                                            } catch (Exception e) {
                                            }

                                            String msgErr ="";
                                                //if(optStockCode == DbItemMaster.APPLY_STOCK_CODE){
                                                if (isSave && stockCode.getCode().length() <= 0){
                                                    msgErr = "data required";
                                                } else{

                                                    for(int a=0; a<vStockCode.size();a++){
                                                                if(counter!=a){
                                                                    StockCode code = (StockCode) vStockCode.get(a);
                                                                    if(stockCode.getCode().equalsIgnoreCase(code.getCode())){
                                                                        msgErr = "code already exist";
                                                                        break;
                                                                    }
                                                                }
                                                    }
                                                    //if(DbStockCode.checkCode(stockCode.getCode())){
                                                    //        msgErr = "code already exist";
                                                    //}

                                                }
                                            //}

                                            strVal += "<tr><td width=\"15\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + counter + "\" value=\"" + stockCode.getOID() + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] + "_" + counter + "\" value=\"" + sales.getCompanyId() + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + counter + "\" value=\"" + objEntity.getProductMasterId() + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + counter + "\" value=\"" + DbStockCode.STOCK_IN + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + counter + "\" value=\"" + DbStockCode.TYPE_SALES + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ID] + "_" + counter + "\" value=\"" + sales.getOID() + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + counter + "\" value=\"" + 1 + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ITEM_ID] + "_" + counter + "\" value=\"" + objEntity.getOID() + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                                    "</td><td width=\"15\" align=\"center\">" + pg + "</td><td><input type=\"text\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + counter + "\" value=\"" + stockCode.getCode() + "\" size=\"30\" >&nbsp;*)&nbsp;<font color=\"#FF0000\">" + msgErr + "</font></td><td></td></tr>";

                                            pg++;
                                            counter++;

                                        }


                                    }else if(useStockCode){
                                        
                                        
                                            strVal += "<tr><td colspan=\"3\" height=\"10\"></td></tr>";

                                        strVal += "<tr><td colspan=\"3\"><table width=\"300\" cellpadding=\"0\" cellspacing=\"1\" border=\"0\">" +
                                                "<tr>" +
                                                "<td width=\"15\" class = \"tablehdr\" align=\"center\">No</td>" +
                                                "<td class = \"tablehdr\" align=\"center\">Stock Code</td>" +
                                                "<td width = \"30\" class = \"tablehdr\" align=\"center\">Action</td>" +
                                                "</tr>";

                                        if (listStockCode != null && listStockCode.size() > 0){

                                            int pg = 1;

                                            for (int xxSt = 0; xxSt < listStockCode.size(); xxSt++){

                                                String style = "";
                                                if (xxSt % 2 == 0){
                                                    style = "tablecell";
                                                } else {
                                                    style = "tablecell1";
                                                }
                                                
                                                StockCode stockCD = new StockCode();

                                                try {
                                                    stockCD = (StockCode) listStockCode.get(xxSt);
                                                } catch (Exception e) {}

                                                strVal += "<tr>" +
                                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getProductMasterId() + "\">" +
                                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + sales.getOID() + "\">" +
                                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xxSt + "\" value=\"" + objEntity.getOID() + "\">" +
                                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xxSt + "\" value=\"" + stockCD.getCode() + "\">" +
                                                        "<td width=\"15\" class =\"" + style + "\" align=\"center\">" + pg + "</td>" +
                                                        "<td class =\"" + style + "\" align=\"left\">&nbsp;" + stockCD.getCode() + "</td>" +
                                                        "<td class =\"" + style + "\" align=\"center\">" +
                                                        "<a href=\"javascript:cmdDelStockCode('" + xxSt + "')\">Delete</a>" +
                                                        "</td>" +
                                                        "</tr>";
                                                pg++;

                                            }
                                        }

                                        int sumQty = 0;

                                        for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++){
                                            sumQty++;
                                        }


                                        if (listStockCode.size() < sumQty && isSave){
                                            if(optionalCode == false){
                                                strVal += "<tr>" +
                                                    "<td colspan=\"3\">" +
                                                    "<font color=\"FF0000\">Data stock code incomplete</font>" +
                                                    "</td>" +
                                                    "</tr>";
                                            }
                                        }

                                        if (sumQty > listStockCode.size()){
                                            strVal += "<tr>"+
                                                    "<td colspan=\"3\">" +
                                                    "<input type=\"hidden\" name=\"OID_STOCK_CODE\" value =\"\">" +
                                                    "<a href=\"javascript:cmdAddStockCode()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('new21','','../images/add.gif',1)\"><img src=\"../images/add2.gif\" name=\"new21\" height=\"22\" border=\"0\" style=\"padding:0px\"></a>" +
                                                    "</td>" +
                                                    "</tr>";
                                        }

                                        strVal += "</table></td></tr>";
                                    }

                                    strVal += "<tr><td></td><td></td><td></td></tr>";
                                    strVal += "</table>";

                                    rowx.add(strVal);
                                        
                                    Uom uom = new Uom();
                                    try{
                                            uom = DbUom.fetchExc(colCombo2.getUomSalesId());
                                    }catch(Exception e){
                                            System.out.println(e);
                                    }     

                                     					rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\"0\" class=\"formElemen\" size=\"5\">"+
					 "<input type=\"text\" style=\"text-align:right\" class=\"formElemen\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
                                        //rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objEntity.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
                                        rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
                                        rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\"0\">"+
                                                         "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(sellPrice,"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
                                        rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
                                                         "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
                                        //rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objEntity.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
                                        rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(sellPrice * objEntity.getQty(),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
				}else{//jika statusna bukan draft
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SALES_ID] +"\" value=\""+objSalesDetail .getSalesId()+"\">" +
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objSalesDetail .getCurrencyId()+"\">" +
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+(i+1)+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE) +
							 "<div align=\"center\">"+String.valueOf(objSalesDetail .getSquence())+"</div>");
					//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+objSalesDetail .getProductMasterId(), ItemMaster_value , ItemMaster_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
					ItemMaster colCombo2  = new ItemMaster();
					try{
						colCombo2 = DbItemMaster.fetchExc(objSalesDetail .getProductMasterId());
					}catch(Exception e) {
						System.out.println(e);
					}
					Uom uom = new Uom();
					try{
						uom = DbUom.fetchExc(colCombo2.getUomSalesId());
					}catch(Exception e){
						System.out.println(e);
					}
					
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID]+"\" value=\""+objSalesDetail .getProductMasterId()+"\" class=\"readonly\" size=\"30\" readOnly>"+
							 colCombo2.getName());
					//rowx.add("<input type=\"text\" name=\"category\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");
					//rowx.add("<div align=\"left\">"+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"</div>");
					//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objSalesDetail .getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS));				
					rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\""+objSalesDetail .getQty()+"\" class=\"formElemen\" size=\"5\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objSalesDetail .getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY)+
							 "<div align=\"center\">"+String.valueOf(objSalesDetail .getQty())+"</div>");						
					rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>"); 
					rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(sellPrice,"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(sellPrice,"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
							 "<div align=\"right\">"+(objSalesDetail .getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getSellingPrice(), "#,###.##"))+"</div>");				
					rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\""+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(),"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
							 "<div align=\"right\">"+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(), "#,###.##")+"</div>");	
					rowx.add("<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objSalesDetail .getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL)+
							 "<div align=\"right\">"+(sellPrice==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getTotal(), "#,###.##"))+"</div>");			
				}
			}
			else//jika bukan edit
			{				
				rowx.add("<div align=\"center\">"+(i+1)+"</div>");
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(objSalesDetail .getProductMasterId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}
				if(sales.getStatus()==1){//I_Crm.PROJECT_STATUS_CLOSE || sales.getStatus()==I_Crm.PROJECT_STATUS_AMEND || sales.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
					rowx.add(colCombo2.getName());
				}else{
                                        //rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objSalesDetail .getOID())+"')\">"+colCombo2.getName()+"</a>");
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objSalesDetail .getOID())+"','"+String.valueOf(colCombo2.getOID())+"')\">"+colCombo2.getName()+"</a>");
                                        //rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID]+"\" value=\""+objSalesDetail .getProductMasterId()+"\" class=\"readonly\" size=\"30\" readOnly>");
				}
				rowx.add("<div align=\"center\">"+String.valueOf(objSalesDetail .getQty())+"</div>" );
				rowx.add("<div align=\"center\">"+String.valueOf(uom.getUnit())+"</div>");
				rowx.add("<div align=\"right\">"+(objSalesDetail .getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getSellingPrice(), "#,###.##"))+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objSalesDetail .getDiscountAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+(objSalesDetail .getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objSalesDetail .getTotal(), "#,###.##"))+"</div>");
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && (frmObject.errorSize() > 0 || iErr > 0)  && objEntity.getOID()==0) || iCommand == JSPCommand.VIEW){
			
			objEntity.setProductMasterId(itemMasterId);
		
			rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SALES_ID] +"\" value=\""+sales.getOID()+"\">"+
					 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+sales.getCurrencyId()+"\">"+
					 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbSalesDetail.getMaxSquence(sales.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
			
			//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+itemMasterId, ItemMaster_value , ItemMaster_key, "onchange=\"javascript:checkProduct()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
			
			ItemMaster colCombo2  = new ItemMaster();
                        
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
			}catch(Exception e) {
				System.out.println(e);
			}
                        //rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a>") ;
                                            
                        
                        String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                        strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                        
                        int cntStockCode = 0;
                        
                    if (useStockCodeSales) {

                        int pg = 1;
                        int counter = 0;
                        double recItmQty = qty <= 0 ? 1 : qty;
                        strVal += "<tr><td colspan=\"4\" height=\"5\"></td></tr>";
                        strVal += "<tr><td width=\"10%\"></td><td class=\"tablehdr\" width=\"15%\">No</td><td class = \"tablehdr\" width=\"70%\">Stock Code</td><td></td></tr>";
                        
                        
                        for (double xx = 0; xx < recItmQty; xx++) {

                            cntStockCode++;
                            StockCode stockCode = new StockCode();
                            try {
                               stockCode = (StockCode) vStockCode.get(counter);
                            } catch (Exception e) {
                            }
                            
                            String msgErr ="";
                                                       
                            //if(optStockCode == DbItemMaster.APPLY_STOCK_CODE){
                                if (isSave && stockCode.getCode().length() <= 0){
                                    msgErr = "data required";
                                } else{

                                for(int a=0; a<vStockCode.size();a++){
                                            if(counter!=a){
                                                StockCode code = (StockCode) vStockCode.get(a);
                                                if(stockCode.getCode().equalsIgnoreCase(code.getCode())){
                                                    msgErr = "code already exist";
                                                    break;
                                                }
                                            }
                                }
                                if(DbStockCode.checkCode(stockCode.getCode())){
                                        msgErr = "code already exist";
                                }

                                }
                            //}
                            
                            strVal += "<tr><td width=\"15\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + counter + "\" value=\"" + stockCode.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] + "_" + counter + "\" value=\"" + sales.getCompanyId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + counter + "\" value=\"" + objEntity.getProductMasterId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + counter + "\" value=\"" + DbStockCode.STOCK_IN + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + counter + "\" value=\"" + DbStockCode.TYPE_SALES + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ID] + "_" + counter + "\" value=\"" + sales.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + counter + "\" value=\"" + 1 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ITEM_ID] + "_" + counter + "\" value=\"" + objEntity.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "</td><td width=\"15\" align=\"center\">" + pg + "</td><td><input type=\"text\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + counter + "\" value=\"" + stockCode.getCode() + "\" size=\"30\" >&nbsp;*)&nbsp;<font color=\"#FF0000\">" + msgErr + "</font></td><td></td></tr>";

                            pg++;
                            counter++;

                        }


                    }else if(useStockCode){
                            strVal += "<tr><td colspan=\"3\" height=\"10\"></td></tr>";

                        strVal += "<tr><td colspan=\"3\"><table width=\"300\" cellpadding=\"0\" cellspacing=\"1\" border=\"0\">" +
                                "<tr>" +
                                "<td width=\"15\" class = \"tablehdr\" align=\"center\">No</td>" +
                                "<td class = \"tablehdr\" align=\"center\">Stock Code</td>" +
                                "<td width = \"30\" class = \"tablehdr\" align=\"center\">Action</td>" +
                                "</tr>";

                        if (listStockCode != null && listStockCode.size() > 0 ){

                            int pg = 1;

                            for (int xxSt = 0; xxSt < listStockCode.size(); xxSt++){

                                String style = "";
                                if (xxSt % 2 == 0){
                                    style = "tablecell";
                                } else {
                                    style = "tablecell1";
                                }

                                StockCode stockCD = new StockCode();

                                try {
                                    stockCD = (StockCode) listStockCode.get(xxSt);
                                } catch (Exception e) {}

                                strVal += "<tr>" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getProductMasterId() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + sales.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xxSt + "\" value=\"" + objEntity.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xxSt + "\" value=\"" + stockCD.getCode() + "\">" +
                                        "<td width=\"15\" class =\"" + style + "\" align=\"center\">" + pg + "</td>" +
                                        "<td class =\"" + style + "\" align=\"left\">&nbsp;" + stockCD.getCode() + "</td>" +
                                        "<td class =\"" + style + "\" align=\"center\">" +
                                        "<a href=\"javascript:cmdDelStockCode('" + xxSt + "')\">Delete</a>" +
                                        "</td>" +
                                        "</tr>";
                                pg++;

                            }
                        }

                        int sumQty = 0;

                        for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++){
                            sumQty++;
                        }
                                              
                        if (listStockCode.size() < sumQty && isSave){
                            if(optionalCode == false){
                                strVal += "<tr>" +
                                    "<td colspan=\"3\">" +
                                    "<font color=\"FF0000\">Data stock code incomplete</font>" +
                                    "</td>" +
                                    "</tr>";
                            }
                        }

                        if (sumQty > listStockCode.size()){
                            strVal += "<tr>"+
                                    "<td colspan=\"3\">" +
                                    "<input type=\"hidden\" name=\"OID_STOCK_CODE\" value =\"\">" +
                                    "<a href=\"javascript:cmdAddStockCode()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('new21','','../images/add.gif',1)\"><img src=\"../images/add2.gif\" name=\"new21\" height=\"22\" border=\"0\" style=\"padding:0px\"></a>" +
                                    "</td>" +
                                    "</tr>";
                        }

                        strVal += "</table></td></tr>";
                    }

                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);
                                                
                          
                        
			Uom uom = new Uom();
			try{
				uom = DbUom.fetchExc(colCombo2.getUomSalesId());
			}catch(Exception e){
				System.out.println(e);
			}
                        
			rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\"0\" class=\"formElemen\" size=\"5\">"+
					 "<input type=\"text\" style=\"text-align:right\" class=\"formElemen\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onChange=\"javascript:viewStockCode()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objEntity.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
			rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\"0\">"+
		 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(sellPrice,"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
		 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objEntity.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
			rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(sellPrice * objEntity.getQty(),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
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
        long oidSalesdetail1 =JSPRequestValue.requestLong(request, "hidden_sales_item_id");
	//long itemGroupId = JSPRequestValue.requestLong(request, JspSales.colNames[JspSales.JSP_ITEM_GROUP_ID]);
	long itemMasterId = JSPRequestValue.requestLong(request, JspSalesDetail.colNames[JspSalesDetail.JSP_PRODUCT_MASTER_ID]);
        //long itemMasterId = JSPRequestValue.requestLong(request, "hidden_item_master_id");
        //long itemMasterId = JSPRequestValue.requestLong(request, "hidden_item_master_id");
        long oidPayment = JSPRequestValue.requestLong(request, "hidden_payment_id");
        long oidReturnPayment = JSPRequestValue.requestLong(request, "hidden_return_payment_id");
        double qty = JSPRequestValue.requestDouble(request, "x_qty");
        long marketingId = JSPRequestValue.requestLong(request, "marketing_id");
        int opt_stock_code_sales =JSPRequestValue.requestInt(request, "hidden_optional_stock_code");
        long oidCustomer = JSPRequestValue.requestLong(request, JspSales.colNames[JspSales.JSP_CUSTOMER_ID]);  
        long oidCashCashier = JSPRequestValue.requestLong(request, JspSales.colNames[JspSales.JSP_CASH_CASHIER_ID]);          
        
        int countStockCode = JSPRequestValue.requestInt(request, "hidden_count_stock_code");
        int stockDel = JSPRequestValue.requestInt(request, "hidden_del_stock");
        int idxStockCodeDel = JSPRequestValue.requestInt(request, "hidden_oid_stock_code_del");
        
        long locationID = JSPRequestValue.requestLong(request, JspSales.colNames[JspSales.JSP_LOCATION_ID]);          
        boolean alreadyOpening = false;
        
         Vector listStockCode = new Vector();

            if (countStockCode > 0) {
                for (int dSc = 0; dSc < countStockCode; dSc++) {
                    StockCode tmpStockCode = new StockCode();
                    tmpStockCode.setOID(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + dSc));
                    tmpStockCode.setItemMasterId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + dSc));
                    tmpStockCode.setTransferId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + dSc));
                    tmpStockCode.setTransferItemId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + dSc));
                    tmpStockCode.setCode(JSPRequestValue.requestString(request, "" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + dSc));
                    listStockCode.add(tmpStockCode);
                }
            }
            
            if (stockDel == 1) {

                for (int ixSc = 0; ixSc < listStockCode.size(); ixSc++) {

                    StockCode tStockCode = (StockCode) listStockCode.get(ixSc);

                    if (ixSc == idxStockCodeDel) {
                        listStockCode.remove(ixSc);
                        break;
                    }
                }
            }
        
        String strStockId = "";

            if (listStockCode != null && listStockCode.size() > 0) {

                for (int uSc = 0; uSc < listStockCode.size(); uSc++) {

                    StockCode Codes = (StockCode) listStockCode.get(uSc);

                    if (strStockId.length() <= 0) {
                        strStockId = "" + Codes.getOID();
                    } else {
                        strStockId = strStockId + "," + Codes.getOID();
                    }
                }
            }
        
       
        
        String vStCode = JSPRequestValue.requestString(request, "OID_STOCK_CODE");

            if (vStCode.length() > 0) {

                StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(vStCode, ",");

                while (strTokenizerOutputDeliver.hasMoreTokens()) {
                    StockCode stCode = new StockCode();
                    try {
                        long stockCodeId = Long.parseLong("" + strTokenizerOutputDeliver.nextToken());
                        stCode = DbStockCode.fetchExc(stockCodeId);
                    } catch (Exception e) {
                        System.out.println("[exception] fetching Stock Code " + e.toString());
                    }
                    stCode.setOID(0);
                    listStockCode.add(stCode);
                }
            }
        
        
        
        CashCashier cashCashier = new CashCashier();
        Shift shift = new Shift();
        CashMaster cashMaster = new CashMaster();
        if(oidCashCashier !=0){
                    
            try{
                cashCashier= DbCashCashier.fetchExc(oidCashCashier);
                shift = DbShift.fetchExc(cashCashier.getShiftId());
                cashMaster = DbCashMaster.fetchExc(cashCashier.getCashMasterId());
                locationID = cashMaster.getLocationId();
            }catch(Exception e){

            }
        }
        
        Company com = new Company();
        ItemMaster itemMaster = new ItemMaster();
        boolean useStockCode = false;
        boolean useStockCodeSales = false;
        boolean optionalCode =false;
	try{
              com = DbCompany.fetchExc(user.getCompanyId());
            
        }catch(Exception E){}
        try{
              itemMaster = DbItemMaster.fetchExc(itemMasterId);
        }catch(Exception E){}
	//out.println("itemMasterId : "+itemMasterId);
	if(itemMaster.getApplyStockCode()==DbItemMaster.APPLY_STOCK_CODE){
            useStockCode=true;
        }
        if(itemMaster.getApplyStockCodeSales()==DbItemMaster.APPLY_STOCK_CODE_SALES){
            useStockCodeSales=true;
        }
        opt_stock_code_sales = itemMaster.getApplyStockCodeSales();
        if(itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE){
            optionalCode = true;
        }
	Sales sales = new Sales();
        Payment payment= new Payment();
        ReturnPayment returnPayment = new ReturnPayment();
	Customer customer = new Customer();
	Currency currency = new Currency();
	
	//Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
	//Vector itemGroups = DbItemGroup.list(0,0, "", "name");
        if(oidCustomer !=0){
            try{
                customer= DbCustomer.fetchExc(oidCustomer);
            }catch(Exception e){
                
            }
        }
	
        
        
	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidSalesDetail = JSPRequestValue.requestLong(request, "hidden_salesproductdetail");

         if (iCommand == JSPCommand.ADD) {
                
                listStockCode = new Vector();
         }
     
        
	// variable declaration
	int recordToGet = 10000;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "sales_id="+oidSales;
	String orderClause = "squence";
	
	//sales action
	CmdSales cmdSales = new CmdSales(request);
        
	iErrCode = cmdSales.action(iCommand , oidSales, sysCompany.getOID(),user);
	JspSales jspSales = cmdSales.getForm();
	sales = cmdSales.getSales();
	
	
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                com= (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
               
	
	if(oidSales==0){
		oidSales = sales.getOID();
	}
			
	whereClause = "sales_id="+oidSales;
	//out.println("<br>whereClause : "+whereClause);
	
	//sales detail
	CmdSalesDetail cmdSalesDetail = new CmdSalesDetail (request);
	JSPLine jspLine = new JSPLine();
	Vector listSalesDetail = new Vector(1,1);

        
        
        
        double loop = qty;

            boolean isStockEmpty = false;
            boolean isStockSame = false;
           
            if(useStockCodeSales == true){
               
                if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        if (stCode.length() <= 0) {
                            isStockEmpty = true;
                            break;
                        }
                    }
                }
            }
            Vector vstockCode = new Vector();
            if(useStockCodeSales == true){
               
                if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        vstockCode.add(y, stCode);
                    }
                }
            }
            
            if(useStockCodeSales == true){
               if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        if(oidSalesDetail==0){//kalau stok diedit
                            if (DbStockCode.checkCode(stCode)) {
                               isStockSame = true;
                               break;
                            }
                        }
                        for(int x=0 ; x< vstockCode.size();x++){
                            if(y!=x){
                                if(vstockCode.get(x).equals(stCode)){
                                    isStockSame = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        
        
        
        
	// switch statement
	//iErrCode = cmdSalesDetail .action(iCommand , oidSalesDetail, systemCompanyId);
	iErrCode = cmdSalesDetail.action(iCommand , oidSalesDetail, sales.getOID(), isStockEmpty, isStockSame);

	// end switchadmin
	JspSalesDetail  jspSalesDetail = cmdSalesDetail .getForm();

	// count list All SalesDetail 
	int vectSize = DbSalesDetail.getCount(whereClause);
        
        
	//recordToGet = vectSize;

	//out.println(jspSalesDetail .getErrors());

	SalesDetail salesProductDetail = cmdSalesDetail.getSalesDetail ();
	msgString =  cmdSalesDetail.getMessage();
        if(oidSalesDetail==0){
            oidSalesDetail = salesProductDetail.getOID();
        }
        qty = salesProductDetail.getQty();
        if(itemMasterId==0){
            itemMasterId= salesProductDetail.getProductMasterId();
        }
        double sellPrice = DbPriceType.getPrice(qty, customer.getGol_price(), itemMasterId);
        
        if(iCommand == JSPCommand.POST && sales.getType()!=DbSales.TYPE_CREDIT){
           // Payment payment = new Payment();
            
            CmdPayment cmdPayment= new CmdPayment(request);
            iErrCode = cmdPayment.action(iCommand , oidPayment, oidSales);
            JspPayment jspPayment = cmdPayment.getForm();
            payment = cmdPayment.getPayment();
            oidPayment= payment.getOID();
            
            CmdReturnPayment cmdReturnPayment = new CmdReturnPayment(request);
            iErrCode = cmdReturnPayment.action(iCommand , oidReturnPayment, oidSales);
            JspReturnPayment jspReturnPayment = cmdReturnPayment.getForm();
            returnPayment = cmdReturnPayment.getReturnPayment();
            oidReturnPayment= returnPayment.getOID();
        }
	
	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdSalesDetail .actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listSalesDetail = DbSalesDetail.list(start, recordToGet, whereClause , orderClause);
        
	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listSalesDetail.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listSalesDetail = DbSalesDetail.list(start,recordToGet, whereClause , orderClause);
	}
	
	//out.println("<br>listSalesDetail : "+listSalesDetail);
	
	
	double totalAmount = getTotalDetail(listSalesDetail);
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

		sales.setVat(JSPRequestValue.requestInt(request, jspSales.colNames[jspSales.JSP_VAT]));		
		sales.setVatPercent(JSPRequestValue.requestDouble(request, jspSales.colNames[jspSales.JSP_VAT_PERCENT]));		
		sales.setDiscount(JSPRequestValue.requestInt(request, jspSales.colNames[jspSales.JSP_DISCOUNT]));
		sales.setDiscountPercent(JSPRequestValue.requestDouble(request, jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT]));
		
		DbSales.updateSalesAmount(oidSales, sales);
		
	}
	
	if(oidSales!=0){
		try{			
			sales = DbSales.fetchExc(oidSales);			
		}
		catch(Exception e){
			
		}
	}
	
	
	
        Vector vErr = new Vector();
        String whereSCode = DbStockCode.colNames[DbStockCode.COL_SALES_DETAIL_ID] + "=" + salesProductDetail.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_TYPE] + "=" + DbStockCode.TYPE_SALES;
        Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);
        
        boolean isSave = false;
        boolean isEdit = false;
        if(iCommand==JSPCommand.EDIT){
            isEdit=true;
        }
        if (iCommand == JSPCommand.SAVE) {
             isSave = true;
        }
        try{
            itemMaster= DbItemMaster.fetchExc(itemMasterId);
        }catch(Exception e){
            
        }
        if(itemMaster.getApplyStockCode()==DbItemMaster.APPLY_STOCK_CODE && isEdit){
             if (salesProductDetail.getOID() != 0 && isEdit) {

                listStockCode = new Vector();
                String whereSc = DbStockCode.colNames[DbStockCode.COL_SALES_DETAIL_ID] + " = " + salesProductDetail.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_STATUS] + "=" + DbStockCode.STATUS_OUT;
                listStockCode = DbStockCode.list(0, 0, whereSc, DbStockCode.colNames[DbStockCode.COL_CODE]);

            }
        }
        if(useStockCodeSales ){
        
	if ((iErrCode != 0 ) && iCommand == JSPCommand.SAVE){

                double loopStockCode = qty;

                if (loopStockCode > 0) {

                    vStockCode = new Vector();

                    for (int ySc = 0; ySc < loopStockCode; ySc++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc);
                        StockCode sCode = new StockCode();

                        sCode.setOID(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + ySc));
                        sCode.setLocationId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] ));
                        sCode.setItemMasterId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + ySc));
                        sCode.setInOut(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + ySc));
                        sCode.setType(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + ySc));
                        sCode.setReturId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + ySc));
                        sCode.setTransferId(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + ySc));
                        sCode.setQty(JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + ySc));
                        sCode.setStatus(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + ySc));
                        sCode.setTransferItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + ySc));
                        sCode.setReturItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + ySc));
                        sCode.setCode(JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc));
                        //sCode.setReceiveItemId(receiveItem.getOID());
                        //sCode.setReceiveId(receive.getOID());
                        sCode.setType_item(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM] ));
                        sCode.setSalesId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_SALES_ID] ));
                        sCode.setSalesDetailId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_SALES_DETAIL_ID] ));
                        
                        vStockCode.add(sCode);
                        if(opt_stock_code_sales==DbItemMaster.APPLY_STOCK_CODE){
                            if (stCode == null || stCode.length() <= 0) {
                                vErr.add("" + ySc);
                            }
                        }
                        
                    }
                }
            }
        }
        if(useStockCodeSales){
        if ((iErrCode == 0 && iCommand == JSPCommand.SAVE) || iCommand == JSPCommand.VIEW){

                if ((iErrCode == 0 && iCommand == JSPCommand.SAVE)) {

                    double loopStockCode = salesProductDetail.getQty();

                    if (loopStockCode > 0) {

                        vStockCode = new Vector();

                        for (int ySc = 0; ySc < loopStockCode; ySc++) {

                            String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc);
                            StockCode sCode = new StockCode();

                            sCode.setOID(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + ySc));
                            sCode.setLocationId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] ));
                            sCode.setItemMasterId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + ySc));
                            sCode.setInOut(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + ySc));
                            sCode.setType(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + ySc));
                            sCode.setReturId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + ySc));
                            sCode.setTransferId(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + ySc));
                            sCode.setQty(JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + ySc));
                            sCode.setStatus(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + ySc));
                            sCode.setTransferItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + ySc));
                            sCode.setReturItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + ySc));
                            sCode.setCode(JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc));
                            //sCode.setReceiveItemId(receiveItem.getOID());
                            //sCode.setReceiveId(receive.getOID());
                            sCode.setType_item(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM] ));
                            sCode.setSalesId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_SALES_ID] ));
                            sCode.setSalesDetailId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_SALES_DETAIL_ID] ));
                            vStockCode.add(sCode);
                            if(opt_stock_code_sales==DbItemMaster.APPLY_STOCK_CODE){
                                if (stCode == null || stCode.length() <= 0){
                                    vErr.add("" + ySc);
                                }
                            }
                            

                        }

                        if (vErr == null || vErr.size() <= 0) {

                            for (int xStockCode = 0; xStockCode < loopStockCode; xStockCode++) {

                                long stockCodeId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xStockCode);
                                long locationId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] );
                                //long itemMasterId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xStockCode);
                                int inOut = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + xStockCode);
                                int type = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + xStockCode);
                                long retId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + xStockCode);
                                long transId = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xStockCode);
                                double quantity = JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + xStockCode);
                                int status = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + xStockCode);
                                long tranItmId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xStockCode);
                                long returItmId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + xStockCode);
                                int type_item = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]);
                                String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xStockCode);

                                StockCode objStockCode = new StockCode();
                                objStockCode.setOID(stockCodeId);
                                objStockCode.setLocationId(cashMaster.getLocationId());
                               
                                objStockCode.setItemMasterId(itemMasterId);
                                objStockCode.setInOut(DbStockCode.STOCK_OUT);
                                objStockCode.setType(type);
                                //objStockCode.setReceiveId(receive.getOID());
                                objStockCode.setReturId(retId);
                                objStockCode.setTransferId(transId);
                                objStockCode.setQty(quantity);
                                objStockCode.setStatus(status);
                                //objStockCode.setReceiveItemId(receiveItem.getOID());
                                objStockCode.setTransferItemId(tranItmId);
                                objStockCode.setReturItemId(returItmId);
                                objStockCode.setCode(stCode);
                                objStockCode.setType_item(type_item);
                                objStockCode.setSalesId(oidSales);
                                objStockCode.setSalesDetailId(oidSalesDetail);
                                
                                if (stCode != null && stCode.length() > 0) {
                                    if (stockCodeId == 0) {
                                        DbStockCode.insertExc(objStockCode);
                                    } else {
                                        DbStockCode.updateExc(objStockCode);
                                    }
                                }
                            }
                        }
                    }
                }
                
                  
                
                //iCommand = JSPCommand.NONE;
                oidSalesDetail = 0;
                salesProductDetail = new SalesDetail();
                //me = "Data is saved";
        }    
	}
	
	//out.println("<br>uniUsahaId : "+uniUsahaId);

	if (iCommand==JSPCommand.SUBMIT){
		
		if(oidSalesDetail>0){
			iCommand = JSPCommand.EDIT;
		}else{
			iCommand = JSPCommand.ADD;
		}
	}
	
        //String whereSCode = DbStockCode.colNames[DbStockCode.sale] + "=" + sales.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_TYPE] + "=" + DbStockCode.TYPE_INCOMING_GOODS;
        //    Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);
	//out.println("amount ="+JSPFormater.formatNumber(ttAmount, "#,###.##"));
	//out.println("balance ="+JSPFormater.formatNumber(ttBalance, "#,###.##"));
        
        if(itemMaster.getApplyStockCode()== DbItemMaster.APPLY_STOCK_CODE){
            if (iErrCode == 0 && iCommand == JSPCommand.SAVE) {

                if (listStockCode != null && listStockCode.size() > 0) {

                    //DbStockCode.deleteStockCodeBySalesItem(salesProductDetail.getOID());

                    for (int ixSc = 0; ixSc < listStockCode.size(); ixSc++) {

                        StockCode objSc = new StockCode();

                        objSc = (StockCode) listStockCode.get(ixSc);

                        //if (objSc.getOID() == 0) { // jika stock masih kosong

                        StockCode objStockCodeFrom = new StockCode();
                        

                        objStockCodeFrom = objSc;
                        

                        //insert di transfer from
                        objStockCodeFrom.setInOut(DbStockCode.STOCK_OUT);
                        objStockCodeFrom.setLocationId(sales.getLocation_id());
                        objStockCodeFrom.setStatus(DbStockCode.STATUS_OUT);
                        objStockCodeFrom.setType(DbStockCode.TYPE_SALES);
                        objStockCodeFrom.setSalesId(sales.getOID());
                        objStockCodeFrom.setSalesDetailId(salesProductDetail.getOID());
                        objStockCodeFrom.setReceiveId(0);
                        objStockCodeFrom.setReceiveItemId(0);
                        objStockCodeFrom.setReturId(0);
                        objStockCodeFrom.setReturItemId(0);
                        objStockCodeFrom.setQty(1);
                        objStockCodeFrom.setType_item(DbStockCode.TYPE_NON_CONSIGMENT);

                        try {
                            DbStockCode.insertExc(objStockCodeFrom);
                        } catch (Exception e) {
                        }

                      
                    //}
                    }
                }
                
              
                
               
            }
        }
        
        
        

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Oxy-Sales</title>
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
		if(document.frmsalesproductdetail.chkVat.checked){
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>.value="<%=sysCompany.getGovernmentVat()%>";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value="0.00";
		}
		else{
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value="0.00";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value="0.00";
		}		

		if(document.frmsalesproductdetail.chkDiscount.checked){
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value="<%=sales.getDiscountPercent()%>";
			document.frmsalesproductdetail.discountAmount.value="0.00";
		}
		else{
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value="0.00";
			document.frmsalesproductdetail.discountAmount.value="0.00";
		}		

		cmdUpdateDiscount();
	} 
        
        function parserCurrency(){
             var str = document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_CURRENCY_ID]%>.value;
             
             <%
                Vector Vcurr = DbCurrency.list(0, 0, "", "");
                Currency cur = new Currency();
                if(Vcurr != null && Vcurr.size() >0){
                   for(int a=0;a<Vcurr.size();a++){
                       cur = (Currency) Vcurr.get(a);
                   
                       
            %>  
                 
                if('<%=cur.getOID()%>'==str){  
                    
                    document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_RATE]%>.value="1";
                                  
                }
                            
            <%
                        
                }
             }      
            %>
                        
           
        }
        

	function cmdUpdateDiscount(){	
		var subtotal = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_AMOUNT] %>.value;
		subtotal = removeChar(subtotal);	
		subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
		var discount = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value;		
		if(discount.length>0 && discount!=" "){
			discount = removeChar(discount);
			discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			discount = (subtotal * parseFloat(discount))/100;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			discount = 0;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value="0.00";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value="0.00";
		}
		
		
		var vat = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>.value;		
		if(vat.length>0 && vat!=" "){
			vat = removeChar(vat);			
			vat = cleanNumberFloat(vat, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			vat = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			vat = ((subtotal - discount) * parseFloat(vat))/100;		
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			vat = 0;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value = "0.00";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value = "0.00";
		}
		
		
                 
                var pph = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_PPH_PERCENT] %>.value;		
                if(pph.length>0 && pph!=" "){
			pph = removeChar(pph);			
			pph = cleanNumberFloat(pph, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			pph = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_PPH_PERCENT] %>.value = formatFloat(pph, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			pph = ((subtotal - discount) * parseFloat(pph))/100;		
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_PPH_AMOUNT] %>.value = formatFloat(pph, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			pph = 0;
			
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_PPH_AMOUNT] %>.value = "0.00";
		}
                 
                var cost = document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_PERCENT] %>.value;		
                var grandTotal = subtotal - discount + vat + pph
                if(cost.length>0 && cost!=" "){
			cost = removeChar(cost);			
			cost = cleanNumberFloat(cost, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			cost = document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_PERCENT] %>.value = formatFloat(cost, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			cost = (grandTotal * parseFloat(cost))/100;		
			document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_AMOUNT] %>.value = formatFloat(cost, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			cost = 0;
			
			document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_AMOUNT] %>.value = "0.00";
		} 
                 
                var grandTotal = subtotal - discount + vat + pph + cost;
		document.frmsalesproductdetail.grandTotal.value = formatFloat(grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 			 
                 
	}
	function cmdDelStockCode(stockCodeId){
             if(confirm('Are sure you want delete this item ?')){
                 document.frmsalesproductdetail.hidden_oid_stock_code_del.value=stockCodeId;
                 document.frmsalesproductdetail.hidden_del_stock.value=1;
                 document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                 document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
                 document.frmsalesproductdetail.action="sales.jsp";
                 document.frmsalesproductdetail.submit(); 
                 
             }
         }  
	function cmdUpdateDiscount1(){	
		
		var subtotal = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_AMOUNT] %>.value;
		
		//alert("subtotal : "+subtotal);
		
		subtotal = removeChar(subtotal);	
		subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
		//var discount = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value;		
		var discount = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value;
		
		//alert("discount : "+discount);		
		
		if(discount.length>0 && discount!=" "){
			
			discount = removeChar(discount);
			discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			//document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			var discountPercent = (parseFloat(discount)/parseFloat(subtotal))*100;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value = formatFloat(discountPercent, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}else{
			discount = 0;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>.value="0.00";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value="0.00";
		}
		
		
		var vat = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>.value;		
		if(vat.length>0 && vat!=" "){
			vat = removeChar(vat);			
			vat = cleanNumberFloat(vat, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			vat = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			vat = ((subtotal - discount) * parseFloat(vat))/100;		
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			vat = 0;
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>.value = "0.00";
			document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>.value = "0.00";
		}
		
		var grandTotal = subtotal - discount + vat;
		document.frmsalesproductdetail.grandTotal.value = formatFloat(grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 			
	}

	function cmdEditCogs(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales_edit.jsp";
		document.frmsalesproductdetail.submit()
	}
        function cmdCashCashier(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmsalesproductdetail.action="sales.jsp";
                document.frmsalesproductdetail.submit();
                
        }

	function checkProduct(){	
		document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmsalesproductdetail.submit();
	}
	
	function cmdUpdateDoc(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.POST%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp";
                checkPayment(); 
                if(document.frmsalesproductdetail.cekPayment.value != 1) {
                    document.frmsalesproductdetail.submit()
                    
                }
                
	}
	
	function cmdDeleteDoc(){
		if(confirm("Sure to delete sales doc ?")){
			document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
			document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
			document.frmsalesproductdetail.command.value="<%=JSPCommand.START%>";
			document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
			document.frmsalesproductdetail.action="sales.jsp";
			document.frmsalesproductdetail.submit();
		}
	}
		
	function cmdAdd(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
                document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.ADD%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdAsk(oidSalesDetail){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.ASK%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdDelete(oidSalesDetail){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.ASK%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdConfirmDelete(oidSalesDetail){
		//if(confirm("Are you sure to delete sales ?")){
			document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
			document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
			document.frmsalesproductdetail.command.value="<%=JSPCommand.DELETE%>";
			document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
			document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
			document.frmsalesproductdetail.submit();
		//}
	}

	function cmdSave(){
		checkNumber2();
			
				document.frmsalesproductdetail.command.value="<%=JSPCommand.SAVE%>";
				document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
				document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
				document.frmsalesproductdetail.submit();
			
		}

	function cmdEdit(oidSalesDetail){
             
		<%if(masterPrivUpdate){%>
                document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmsalesproductdetail.prev_command.value="<u%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
		<%}%>
		}
        function cmdAddStockCode(){            
             
             
             window.open("<%=approot%>/postransaction/addstockcodeSales.jsp?locationId=<%=locationID%>&maxStock=<%=salesProductDetail.getQty()%>&stockReady=<%=listStockCode.size()%>&codes=<%=strStockId%>&salesId=<%=sales.getOID()%>&type=<%=DbStockCode.TYPE_NON_CONSIGMENT%>&itemMasterId=<%=salesProductDetail.getProductMasterId()%>&salesItemId=<%=salesProductDetail.getOID()%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
        } 
        
	function cmdCancel(oidSalesDetail){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.hidden_salesproductdetail.value=oidSalesDetail;
		document.frmsalesproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdBack(){
		document.frmsalesproductdetail.hidden_sales_id.value="<%=oidSales%>";
		document.frmsalesproductdetail.command.value="<%=JSPCommand.BACK%>";
		//document.frmsalesproductdetail.hidden_salesproductdetail.value="0";
		
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
		}

	function cmdListFirst(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.FIRST%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdListPrev(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.PREV%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
		}

	function cmdListNext(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.NEXT%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function cmdListLast(){
		document.frmsalesproductdetail.command.value="<%=JSPCommand.LAST%>";
		document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmsalesproductdetail.action="sales.jsp?menu_idx=<%=menuIdx%>&oid=<%=oidSales%>";
		document.frmsalesproductdetail.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
	}
        function viewStockCode(){
            
            document.frmsalesproductdetail.command.value="<%=JSPCommand.ADD%>";
            document.frmsalesproductdetail.prev_command.value="<%=prevCommand%>";
            document.frmsalesproductdetail.action="sales.jsp";
            document.frmsalesproductdetail.submit();
            
        }
        
	function checkNumber2(){
		//new Amount Input
                               
		var newAmount = document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_SELLING_PRICE]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                //new Qty Input
		var newQty = document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_QTY]%>.value;
		newQty = cleanNumberFloat(newQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);						
		
		//new Discount
		var newDiscount = document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_DISCOUNT_AMOUNT]%>.value;
		newDiscount = cleanNumberFloat(newDiscount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		
		if((parseFloat(newAmount)*parseFloat(newQty))<=(parseFloat(newDiscount)))
		{
			//alert("Discount > Selling Price * Qty");
			document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_DISCOUNT_AMOUNT]%>.value = 0; 		
		}
		document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_SELLING_PRICE]%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_DISCOUNT_AMOUNT]%>.value = formatFloat((parseFloat(newDiscount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmsalesproductdetail.<%=jspSalesDetail .colNames[jspSalesDetail .JSP_TOTAL]%>.value = formatFloat(((parseFloat(newAmount)*parseFloat(newQty))-(parseFloat(newDiscount))), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
               
	}
         
        function checkPayment(){
               
                var newPaymentAmount = document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_AMOUNT]%>.value;
                var rate = document.frmsalesproductdetail.<%=JspPayment.colNames[JspPayment.JSP_RATE]%>.value;
                
                newPaymentAmount = cleanNumberFloat(newPaymentAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                rate = cleanNumberFloat(rate, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                newPaymentAmount = newPaymentAmount * rate;
                
                var newGrandTotal = document.frmsalesproductdetail.grandTotal.value;
                newGrandTotal = cleanNumberFloat(newGrandTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                //alert(newGrandTotal);
                var typeSales = document.frmsalesproductdetail.<%=jspSales.colNames[jspSales.JSP_TYPE]%>.value;
                if(parseFloat(typeSales)==0){
                if(parseFloat(newPaymentAmount)< parseFloat(newGrandTotal)){
                        alert("payment is less");
                        document.frmsalesproductdetail.cekPayment.value=1;
                }else{
                     document.frmsalesproductdetail.cekPayment.value=0;
                }
                }
                document.frmsalesproductdetail.<%=JspReturnPayment.colNames[JspReturnPayment.JSP_AMOUNT]%>.value = newPaymentAmount - newGrandTotal;
                
               
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
                                                  <input type="hidden" name="hidden_payment_id" value="<%=oidPayment%>"> 
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_VAT] %>" value="1">
						  <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_DISCOUNT] %>" value="1">
						  <input type="hidden" name="hidden_optional_stock_code" value="<%=opt_stock_code_sales%>">						  
						  <input type="hidden" name="hidden_qty" value="<%=salesProductDetail.getQty()%>">
                                                  <input type="hidden" name="hidden_count_stock_code" value="<%=listStockCode.size()%>">
                                                  <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_SHIFT_ID]%>" value="<%=shift.getOID()%>"> 
                                                  <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_CASH_MASTER_ID]%>" value="<%=cashMaster.getOID()%>"> 
                                                  <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_LOCATION_ID]%>" value="<%=cashMaster.getLocationId()%>"> 
                                                  <input type="hidden" name="hidden_del_stock" value="<%=0%>">
                                                  <input type="hidden" name="hidden_oid_stock_code_del" value="<%=0%>">
                                                  
                                                  
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              </font><font class="tit1">&raquo; 
                                                              <span class="lvl2"> 
                                                              New Sales<br>
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
                                                                  
                                                                <%if(user.getEmployeeId()==0){%> 
                                                                
                                                                <tr>
                                                                    <td height="18" width="10%">Marketing
                                                                     </td> 
                                                                    <td>
                                                                        <select name="<%=JspSales.colNames[JspSales.JSP_MARKETING_ID]%>">
                                                                        <option value="0" <%if(marketingId==0){%>selected<%}%>>-
                                                                       </option>
                                                                        <%

                                                                                                                            Vector vemploy = DbEmployee.list(0,0, "", "name");

                                                                                                                        if(vemploy!=null && vemploy.size()>0){
                                                                                                                                     for(int a=0; a<vemploy.size(); a++){
                                                                                                                                            Employee d = (Employee)vemploy.get(a);
                                                                                                                                            String str = "";
                                                                                                                            %>
                                                                        <option value="<%=d.getOID()%>" <%if(marketingId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                                        <%}}%>
                                                                        </select>
                                                                    
                                                                    </td>    
                                                                </tr>
                                                                <%}%>
                                                                <tr> 
                                                                  <td height="18" width="10%">Company 
                                                                     </td>
                                                                  <td width="30%"> 
                                                                    <%= com.getName()      %>
                                                                        
                                                                  </td>
                                                                  <td width="6%"><b>Date</b></td>
                                                                  <td width="54%"><%=JSPDate.drawDateWithStyle(jspSales.colNames[jspSales.JSP_DATE], (sales.getDate()==null) ? new Date() : sales.getDate(), 0,-10, "formElemen", "") %><b></b></td>
                                                                </tr>
                                                               <tr>
                                                                <% 
                                                                    Vector unitUsh = DbUnitUsaha.list(0,0, "", "name");
                                                                %>
                                                                  <td height="18" width="10%">Unit Usaha
                                                                     </td>
                                                                  <td width="30%"> 
                                                                     <select name="<%=jspSales.colNames[jspSales.JSP_UNIT_USAHA_ID] %>">
                                                                      <%if(unitUsh!=null && unitUsh.size()>0){
                                                                           for(int i=0; i<unitUsh.size(); i++){
                                                                            UnitUsaha us = (UnitUsaha)unitUsh.get(i);
                                                                           %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==sales.getUnitUsahaId()){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>  
                                                                  </td>
                                                                  <td width="6%"><b></b></td>
                                                                  <td width="54%"><b></b></td>
                                                                </tr>
                                                                
                                                                
                                                                                                                                
                                                                <tr> 
                                                                  <td height="18" width="10%">Cashier Location 
                                                                     </td>
                                                                  <td width="30%"> 
                                                                    <%
																  Vector Vcashier = DbCashCashier.list(0,0, "status =" + DbCashCashier.status_opening, "");
                                                                                                                                  if(Vcashier.size()>0){
                                                                                                                                      alreadyOpening = true;
                                                                                                                                  }
																  %>
                                                                    <select name="<%=jspSales.colNames[jspSales.JSP_CASH_CASHIER_ID]%>" onChange="javascript:cmdCashCashier()">
                                                                     
                                                                      <%if(Vcashier!=null && Vcashier.size()>0){
																	  for(int j=0; j<Vcashier.size(); j++){
																	  	CashCashier c = (CashCashier)Vcashier.get(j);
                                                                                                                                                CashMaster cm = new CashMaster();
                                                                                                                                                Location loc = new Location();
                                                                                                                                                try{
                                                                                                                                                    cm = DbCashMaster.fetchExc(c.getCashMasterId());
                                                                                                                                                    //cashMaster = DbCashMaster.fetchExc(c.getCashMasterId());
                                                                                                                                                    if(oidCashCashier==0){
                                                                                                                                                         shift = DbShift.fetchExc(c.getShiftId());
                                                                                                                                                         oidCashCashier=c.getOID();
                                                                                                                                                    }
                                                                                                                                                    loc = DbLocation.fetchExc(cm.getLocationId());
                                                                                                                                                }catch(Exception e){
                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                
																	  %>
                                                                      <option value="<%=c.getOID()%>" <%if(c.getOID()==oidCashCashier){%>selected<%}%>><%=loc.getName() + " " + cm.getCashierNumber()%></option>
                                                                      <%}
																	  }%>
                                                                    </select>
                                                                        
                                                                  </td>
                                                                  <td width="6%">Shift</td>
                                                                  <td width="54%"><b><%=shift.getName()%></b></td>
                                                                </tr>
                                                                
                                                                
                                                                
                                                                <tr> 
                                                                  <td height="18" width="10%">Number</td>
                                                                  <td width="30%"><strong> 
                                                                    <%
																		int counter = DbSales.getNextCounter(sysCompany.getOID());
																		String strNumber = DbSales.getNextNumber(counter, sysCompany.getOID());
																		String prefix = DbSales.getNumberPrefix(sysCompany.getOID());
																		
																		//if(project.getOID()!=0 && project.getNumber()!=null && project.getNumber().length()>0){
																		if(sales.getOID()!=0){//getNumber()!=null && sales.getNumber().length()>0){
																			strNumber = sales.getNumber();
																			counter = sales.getCounter();
																			prefix = sales.getNumberPrefix();
																		}									  
																	
																	%>
                                                                    <input type="text" name="<%=jspSales.colNames[jspSales.JSP_NUMBER]%>"  value="<%=strNumber%>" size="20" >
                                                                    <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_COUNTER]%>" value="<%=counter%>">
                                                                    <input type="hidden" name="<%=jspSales.colNames[jspSales.JSP_NUMBER_PREFIX]%>" value="<%=prefix%>">
                                                                    </strong></td>
                                                                  <td width="6%">Note</td>
                                                                  <td width="54%"> 
                                                                    <input type="text" name="<%=jspSales.colNames[jspSales.JSP_NOTE_CLOSING]%>" size="40" value="<%=sales.getNoteClosing()%>">
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="5"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15" nowrap>Sales 
                                                                    Type </td>
                                                                  <td width="30%"> 
                                                                    <select name="<%=jspSales.colNames[jspSales.JSP_TYPE]%>">
                                                                      <option value="0" <%if(sales.getType()==0){%>selected<%}%>>CASH</option>
                                                                      <option value="1" <%if(sales.getType()==1){%>selected<%}%>>CREDIT</option>
                                                                    </select>
                                                                  </td>
                                                                  <td width="6%">Customer</td>
                                                                  <td width="54%"> 
                                                                    <%
																  Vector customers = DbCustomer.list(0,0, "", "");
																  %>
                                                                    <select name="<%=jspSales.colNames[jspSales.JSP_CUSTOMER_ID]%>">
                                                                      <option value="0"></option>
                                                                      <%if(customers!=null && customers.size()>0){
																	  for(int j=0; j<customers.size(); j++){
																	  	Customer c = (Customer)customers.get(j);
																	  %>
                                                                      <option value="<%=c.getOID()%>" <%if(c.getOID()==sales.getCustomerId()){%>selected<%}%>><%=c.getName()%></option>
                                                                      <%}
																	  }%>
                                                                    </select>
                                                                    <%=jspSales.getErrorMsg(jspSales.JSP_CUSTOMER_ID)%> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="5" nowrap></td>
                                                                  
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15" nowrap><b><font color="#FF0000" size="2">Sales 
                                                                    Amount</font></b></td>
                                                                  <td width="30%"><font color="#FF0000" size="2"><b>: 
                                                                    <%=JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount(),"#,###.##")%></b></font></td>
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
                                                                  <td colspan="4" height="25"><b>Product 
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
                                                                        <td class="boxed1"><%= drawList(iCommand,jspSalesDetail , salesProductDetail, listSalesDetail, oidSalesDetail,sales, itemMasterId, useStockCode, useStockCodeSales, listStockCode, qty, vStockCode, customer, iErrCode, isSave, sellPrice, optionalCode)%></td>
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
                                                                            <%if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.VIEW  && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && sales.getStatus()==0){%>
                                                                            <tr> 
                                                                              <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                              <td> 
                                                                                <%                                              if(alreadyOpening){
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
																 
																 if(iCommand==JSPCommand.EDIT){
																	if(sales.getStatus()==I_Ccs.SALES_STATUS_POSTED){
																		jspLine.setDeleteCaption("");
																		jspLine.setSaveCaption("");
																	}
																 }
																 
															   %>
                                                                                <%
																 if(sales.getStatus()==0 && (iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0))
																 {
															   %>
                                                                                <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                                <%
																 }}
															   %>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                        <td width="40%" class="boxed1"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td width="37%" class="tablecell" align="left"><strong>&nbsp;&nbsp;&nbsp;SUB 
                                                                                TOTAL</strong></td>
                                                                              <td width="25%" class="tablecell" align="right"></td>
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_AMOUNT] %>" value="<%=JSPFormater.formatNumber(totalAmount,"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//if(sales.getDiscount()>0){%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;DISCOUNT</strong></td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_DISCOUNT_PERCENT] %>" value="<%=JSPFormater.formatNumber(sales.getDiscountPercent(),"#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()" <%if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){}else{%><%}%> <%if(sales.getStatus()==1){%>readonly<%}%>>
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_DISCOUNT_AMOUNT] %>" value="<%=JSPFormater.formatNumber(sales.getDiscountAmount(),"#,###.##")%>" style="text-align:right" size="20" onClick="this.select()" onChange="javascript:cmdUpdateDiscount1()" <%if(sales.getStatus()==1){%>readonly<%}%>>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//}%>
                                                                            <%	//if(sales.getVat()>0){%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;VAT</strong></td>
                                                                              <td class="tablecell" align="center"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_VAT_PERCENT] %>" value="<%=JSPFormater.formatNumber(sales.getVatPercent(),"#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()" <%if(sales.getStatus()==1){%>readonly<%}%>>
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_VAT_AMOUNT] %>" value="<%=JSPFormater.formatNumber(sales.getVatAmount(),"#,###.##")%>" style="text-align:right" size="20" onClick="this.select()"  onChange="javascript:cmdUpdateDiscount1()" class="readOnly" readonly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//}%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;GRAND 
                                                                                TOTAL</strong></td>
                                                                              <td class="tablecell" align="right"></td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="grandTotal" value="<%=JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+sales.getVatAmount()+ sales.getPphAmount(),"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                             
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;</strong><b>PPH</b> 
                                                                                <b> 
                                                                                <select name="<%=jspSales.colNames[jspSales.JSP_PPH_TYPE] %>">
                                                                                  <option value="0" <%if(sales.getPphType()==DbSales.TYPE_JASA){%>selected<%}%>>JASA</option>
                                                                                  <option value="1" <%if(sales.getPphType()==DbSales.TYPE_MATERIAL){%>selected<%}%>>MATERIAL</option>
                                                                                </select>
                                                                                </b> 
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="<%=jspSales.colNames[jspSales.JSP_PPH_PERCENT] %>" value="<%=JSPFormater.formatNumber(sales.getPphPercent(),"#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()">
                                                                                  %</div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <input type="text" name="<%=jspSales.colNames[jspSales.JSP_PPH_AMOUNT] %>" value="<%=JSPFormater.formatNumber(sales.getPphAmount(),"#,###.##")%>" style="text-align:right" size="20" class="rightalign">
                                                                              </td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;</strong><b>PAYMENT TYPE</b> 
                                                                               
                                                                              </td>
                                                                              <td class="tablecell" align="right" colspan=2> 
                                                                                <b> 
                                                                                <select name="<%=JspPayment.colNames[JspPayment.JSP_PAY_TYPE] %>">
                                                                                  <option value="0" <%if(payment.getPay_type()==DbPayment.PAY_TYPE_CASH){%>selected<%}%>>CASH</option>
                                                                                  <option value="1" <%if(payment.getPay_type()==DbPayment.PAY_TYPE_CREDIT_CARD){%>selected<%}%>>CREDIT CARD</option>
                                                                                </select>
                                                                                </b> 
                                                                              </td>
                                                                              
                                                                            </tr>
                                                                            
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;CURRENCY</strong></td>
                                                                              <td class="tablecell" align="left"> 
                                                                                         <%
            if (payment.getOID() == 0) {

                Vector currs = DbCurrency.list(0, 0, "", "");
                Vector exchange_value = new Vector(1, 1);
                Vector exchange_key = new Vector(1, 1);
                String sel_exchange = "" + payment.getCurrency_id();
                if (currs != null && currs.size() > 0) {
                    for (int a = 0; a < currs.size(); a++) {
                        Currency d = (Currency) currs.get(a);
                        
                        exchange_key.add("" + d.getOID());
                        exchange_value.add(d.getCurrencyCode());
                    }
                }
                                                                                                            %>
                                                  <%= JSPCombo.draw(JspPayment.colNames[JspPayment.JSP_CURRENCY_ID], null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:parserCurrency()\"", "formElemen") %> 
                                                  <%} else {
                                                                                                                Currency curr = new Currency();
                                                                                                                try {
                                                                                                                    curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            %>
                                                  <b><%=curr.getCurrencyCode()%></b> 
                                                  <input type="hidden" name="<%=JspPayment.colNames[JspPayment.JSP_CURRENCY_ID]%>" value="<%=payment.getCurrency_id()%>">
                                                                                                            <%}%>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=JspPayment.colNames[JspPayment.JSP_RATE] %>" value="<%=JSPFormater.formatNumber(payment.getRate(),"#,###.##")%>" style="text-align:right" size="20" onClick="this.select()" onChange="javascript:cmdUpdateDiscount1()" readonly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                                                                                                        
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;</strong><b>PAYMENT</b> 
                                                                               
                                                                              </td>
                                                                              <td class="tablecell" align="right" colspan=2> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=JspPayment.colNames[JspPayment.JSP_AMOUNT] %>" value="<%=JSPFormater.formatNumber(payment.getAmount(),"#,###.##")%>" style="text-align:right" size="37" onClick="this.select()" onChange="javascript:checkPayment()">
                                                                                </div>
                                                                              </td>
                                                                              
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;COST</strong></td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_PERCENT] %>" value="<%=JSPFormater.formatNumber(payment.getCost_card_percent(),"#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()" <%if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){}else{%><%}%> <%if(sales.getStatus()==1){%>readonly<%}%>>
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=JspPayment.colNames[JspPayment.JSP_COST_CARD_AMOUNT] %>" value="<%=JSPFormater.formatNumber(payment.getCost_card_amount(),"#,###.##")%>" style="text-align:right" size="20" onClick="this.select()" onChange="javascript:cmdUpdateDiscount1()" <%if(sales.getStatus()==1){%>readonly<%}%>>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;</strong><b>CHANGE</b> 
                                                                               
                                                                              </td>
                                                                              <td class="tablecell" align="right" colspan=2> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="<%=JspReturnPayment.colNames[JspReturnPayment.JSP_AMOUNT] %>" value="<%=JSPFormater.formatNumber(returnPayment.getAmount(),"#,###.##")%>" style="text-align:right" size="37" onClick="this.select()" onChange="javascript:checkPayment()">
                                                                                  </div>
                                                                              </td>
                                                                              
                                                                            </tr>
                                                                            <script language="JavaScript">
                                                                                parserCurrency();
                                                                               
                                                                             </script>
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
                                                                                <% if(iCommand != JSPCommand.POST && sales.getOID()!=0) {%>
                                                                              <td width="33%"><a href="javascript:cmdUpdateDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save2111" border="0"></a></td>
                                                                                <%}%>
                                                                                <% if(oidReturnPayment != 0){%>
                                                                                    <td width="97"> 
                                                                                        <td width="33%"><a href="../posreport/print_invoice_priview.jsp?sales_id=<%=oidSales %>&payment_id=<%=oidPayment%>&sales_detail_id=<%=oidSalesDetail%>&return_payment_id=<%=oidReturnPayment%>" onClick="return hs.htmlExpand(this,{objectType: 'ajax'})"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('exportdoc','','../images/print2.gif',1)"><img src="../images/print.gif" name="exportdoc"  border="0"></a></td>
                                                                                        
                                                                                    </td>
                                                                                <%}%>
                                                                              <td width="34%">
                                                                                <%if(sales.getStatus()==0 && sales.getOID()!=0){%>
                                                                                <a href="javascript:cmdDeleteDoc('<%=oidSales%>')"><img src="../images/deletedoc.gif" width="120" height="22" border="0"></a>
                                                                                <%}%>
                                                                              </td>
                                                                              
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
                                                          
                                                          <tr align="left" valign="top"> 
                                                            <td colspan="3" class="command">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="3" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
						<%
							if ((iCommand==JSPCommand.SUBMIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT) && salesProductDetail.getProductMasterId()==0) 
							{
						%>
								checkProduct();
						<%
							}
						%>						
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

