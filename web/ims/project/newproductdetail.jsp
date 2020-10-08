<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_PRODUCT_DETAIL);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_PRODUCT_DETAIL, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_PRODUCT_DETAIL, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspProjectProductDetail frmObject, ProjectProductDetail objEntity, Vector objectClass, long projectProductDetailId, Project project)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		//jsplist.addHeader("Project Id","1%");
		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Product","25%");
		jsplist.addHeader("Category","14%");
		jsplist.addHeader("Status","6%");		
		jsplist.addHeader("Qty","5%");
		jsplist.addHeader("UOM","5%");
		jsplist.addHeader("Selling Price","15%");
		jsplist.addHeader("Discount","10%");
		jsplist.addHeader("Total Sales","15%");		
		//jsplist.addHeader("Currency Id","1%");
		//jsplist.addHeader("Company Id","1%");

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
		
		String wh = "for_sales=1";	

		Vector vItemMaster = DbItemMaster.list(0,0, wh, "item_group_id, name");		
		Vector ItemMaster_value = new Vector(1,1);
		Vector ItemMaster_key = new Vector(1,1);
		if(vItemMaster!=null && vItemMaster.size()>0)
		{
			for(int i=0; i<vItemMaster.size(); i++)
			{
				ItemMaster c = (ItemMaster)vItemMaster.get(i);
				ItemGroup ig = new ItemGroup();
				try{
					ig = DbItemGroup.fetchExc(c.getItemGroupId());
				}
				catch(Exception e){
				}
				ItemMaster_key.add(ig.getName()+" / "+c.getName().trim());
				ItemMaster_value.add(""+c.getOID());
			}
		}

		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		//for(int i=0; i<I_Crm.productStatusStr.length; i++){
		//	status_value.add(""+i);
		//	status_key.add(I_Crm.productStatusStr[i]);
		//}
		status_value.add(""+I_Crm.PRODUCT_STATUS_DRAFT);
		status_key.add(I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_DRAFT]);
		status_value.add(""+I_Crm.PRODUCT_STATUS_MANUFACTURING);
		status_key.add(I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_MANUFACTURING]);

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectProductDetail objProjectProductDetail = (ProjectProductDetail)objectClass.get(i);
			rowx = new Vector();
			if(projectProductDetailId == objProjectProductDetail.getOID())
				index = i;

			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objProjectProductDetail.getOID()!=0))){
				if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){				
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectProductDetail.getProjectId()+"\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objProjectProductDetail.getCurrencyId()+"\">"+
							 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectProductDetail.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
					rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+objEntity.getProductMasterId(), ItemMaster_value , ItemMaster_key, "onchange=\"javascript:checkProduct()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
					ItemMaster colCombo2  = new ItemMaster();
					try{
						colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
					}catch(Exception e) {
						System.out.println(e);
					}
					Uom uom = new Uom();
					try{
						uom = DbUom.fetchExc(colCombo2.getUomSalesId());
					}catch(Exception e){
						System.out.println(e);
					}
					ItemCategory subCategory = new ItemCategory();
					try{
						subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
					}catch(Exception e) {
						System.out.println();
					}
					ItemGroup category = new ItemGroup();
					try{
						category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
					}catch(Exception e) {
						System.out.println(e);
					}
					rowx.add("<input type=\"text\" name=\"category\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");					
					rowx.add("<input style=\"text-align:left\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_STATUS] +"\" value=\""+I_Crm.PRODUCT_STATUS_DRAFT+"\" size=\"15\" class=\"readonly\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_STATUS) +
					 		 "<input style=\"text-align:left\" type=\"text\" name=\"status\" value=\""+I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_DRAFT]+"\" size=\"15\" class=\"readonly\" readOnly>");
					rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\""+objProjectProductDetail.getQty()+"\" class=\"formElemen\" size=\"5\">"+
							 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
					rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
					rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(),"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));				
					rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(),"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));				
					//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));			
					rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber((colCombo2.getSellingPrice()*objEntity.getQty())-(objProjectProductDetail.getDiscountAmount()),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));			
				}else{
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectProductDetail.getProjectId()+"\">" +
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+objProjectProductDetail.getCurrencyId()+"\">" +
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectProductDetail.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE) +
							 "<div align=\"center\">"+String.valueOf(objProjectProductDetail.getSquence())+"</div>");
					//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+objProjectProductDetail.getProductMasterId(), ItemMaster_value , ItemMaster_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
					ItemMaster colCombo2  = new ItemMaster();
					try{
						colCombo2 = DbItemMaster.fetchExc(objProjectProductDetail.getProductMasterId());
					}catch(Exception e) {
						System.out.println(e);
					}
					Uom uom = new Uom();
					try{
						uom = DbUom.fetchExc(colCombo2.getUomSalesId());
					}catch(Exception e){
						System.out.println(e);
					}
					ItemCategory subCategory = new ItemCategory();
					try{
						subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
					}catch(Exception e) {
						System.out.println();
					}
					ItemGroup category = new ItemGroup();
					try{
						category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
					}catch(Exception e) {
						System.out.println(e);
					}
					rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID]+"\" value=\""+objProjectProductDetail.getProductMasterId()+"\" class=\"readonly\" size=\"30\" readOnly>"+
							 colCombo2.getName());
					//rowx.add("<input type=\"text\" name=\"category\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");
					rowx.add("<div align=\"left\">"+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"</div>");
					rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_STATUS],null, ""+objProjectProductDetail.getStatus(), status_value , status_key, "formElemen", "")+ frmObject.getErrorMsg(frmObject.JSP_STATUS));				
					rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\""+objProjectProductDetail.getQty()+"\" class=\"formElemen\" size=\"5\">"+
							 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objProjectProductDetail.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY)+
							 "<div align=\"center\">"+String.valueOf(objProjectProductDetail.getQty())+"</div>");						
					rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>"); 
					rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(),"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
							 "<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(), "#,###.##"))+"</div>");				
					rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(),"#,###.##")+"\">"+
							 "<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE)+
							 "<div align=\"right\">"+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(), "#,###.##")+"</div>");	
					rowx.add("<input style=\"text-align:right\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objProjectProductDetail.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL)+
							 "<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getTotal(), "#,###.##"))+"</div>");			
				}
			}
			else
			{				
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectProductDetail.getSquence())+"</div>");
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(objProjectProductDetail.getProductMasterId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}
				if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
					rowx.add(colCombo2.getName());
				}else{
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectProductDetail.getOID())+"')\">"+colCombo2.getName()+"</a>");
				}
				ItemCategory subCategory = new ItemCategory();
				try{
					subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
				}catch(Exception e) {
					System.out.println();
				}
				ItemGroup category = new ItemGroup();
				try{
					category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
				}catch(Exception e) {
					System.out.println(e);
				}
				rowx.add("<div align=\"left\">"+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"</div>");
				rowx.add("<div align=\"left\">"+String.valueOf(I_Crm.productStatusStr[objProjectProductDetail.getStatus()])+"</div>");				
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectProductDetail.getQty())+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(uom.getUnit())+"</div>");
				rowx.add("<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(), "#,###.##"))+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objProjectProductDetail.getDiscountAmount(), "#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getTotal(), "#,###.##"))+"</div>");
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
			rowx.add("<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+project.getOID()+"\">"+
					 "<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_CURRENCY_ID] +"\" value=\""+project.getCurrencyId()+"\">"+
					 "<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbProjectProductDetail.getMaxSquence(project.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
			
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PRODUCT_MASTER_ID],null, ""+objEntity.getProductMasterId(), ItemMaster_value , ItemMaster_key, "onchange=\"javascript:checkProduct()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PRODUCT_MASTER_ID));
			
			ItemMaster colCombo2  = new ItemMaster();
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getProductMasterId());
			}catch(Exception e) {
				System.out.println(e);
			}
			Uom uom = new Uom();
			try{
				uom = DbUom.fetchExc(colCombo2.getUomSalesId());
			}catch(Exception e){
				System.out.println(e);
			}
			ItemCategory subCategory = new ItemCategory();
			try{
				subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
			}catch(Exception e) {
				System.out.println();
			}
			ItemGroup category = new ItemGroup();
			try{
				category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
			}catch(Exception e) {
				System.out.println(e);
			}
			rowx.add("<input type=\"text\" name=\"category\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");
			rowx.add("<input style=\"text-align:left\" type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_STATUS] +"\" value=\""+I_Crm.PRODUCT_STATUS_DRAFT+"\" size=\"15\" class=\"readonly\" readOnly>"+ frmObject.getErrorMsg(frmObject.JSP_STATUS) +
					 "<input style=\"text-align:left\" type=\"text\" name=\"status\" value=\""+I_Crm.productStatusStr[I_Crm.PRODUCT_STATUS_DRAFT]+"\" size=\"15\" class=\"readonly\" readOnly>");
			rowx.add("<input type=\"hidden\" name=\"EditQty\" value=\"0\" class=\"formElemen\" size=\"5\">"+
					 "<input type=\"text\" style=\"text-align:right\" class=\"formElemen\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"5\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(objEntity.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
			rowx.add("<input type=\"hidden\" name=\"EditAmount\" value=\"0\">"+
		 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SELLING_PRICE] +"\" value=\""+JSPFormater.formatNumber(colCombo2.getSellingPrice(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			rowx.add("<input type=\"hidden\" name=\"EditDiscount\" value=\"0\">"+
		 			 "<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_AMOUNT] +"\" value=\""+JSPFormater.formatNumber(objEntity.getDiscountAmount(),"#,###.##")+"\" class=\"formElemen\" size=\"15\" onClick=\"this.select()\" onBlur=\"javascript:checkNumber2()\">"+ frmObject.getErrorMsg(frmObject.JSP_SELLING_PRICE));		
			//rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(objEntity.getTotal(),"#,###.##")+"\" class=\"formElemen\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
			rowx.add("<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_TOTAL] +"\" value=\""+JSPFormater.formatNumber(colCombo2.getSellingPrice()*objEntity.getQty(),"#,###.##")+"\" class=\"readonly\" size=\"25\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_TOTAL));
		}

		lstData.add(rowx);

		return jsplist.draw(index);
	}
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectProductDetail projectProductDetail = (ProjectProductDetail)listx.get(i);
				result = result + (projectProductDetail.getSellingPrice()*projectProductDetail.getQty()) - (projectProductDetail.getDiscountAmount());
			}
		}
		return result;
	}
	
	
	public double getTtDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectTerm projectTerm = (ProjectTerm)listx.get(i);
				result = result + projectTerm.getAmount();
				System.out.println(projectTerm.getAmount());
			}
		}
		return result;
	}

	
%>
<%	
	long projectId = JSPRequestValue.requestLong(request, "oid");
	//long proposalId = JSPRequestValue.requestLong(request, "hidden_proposal_id");
	
	//out.println("projectId : "+projectId);
	//out.println("proposalId : "+proposalId);
	
	//out.println(projectId);
	//Proposal proposal = new Proposal();
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	
	/*
	try{
		proposal = DbProposal.fetchExc(proposalId);
	}
	catch(Exception e){
	}
	*/
	
	try{ 
		Vector v = DbProject.list(0,0, "project_id="+projectId, "");
		
		if(v!=null && v.size()>0){
			project = (Project)v.get(0);
			projectId = project.getOID();
		}
	}catch(Exception e){
		System.out.println(e);
	}
	
	
	try{
		customer = DbCustomer.fetchExc(project.getCustomerId());
	}catch(Exception e){
		System.out.println(e);
	}
	
	try{
		currency = DbCurrency.fetchExc(project.getCurrencyId());
	}catch(Exception e){
		System.out.println(e);
	}

	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectProductDetail = JSPRequestValue.requestLong(request, "hidden_projectproductdetail");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	//String whereClause = "company_id="+systemCompanyId+" and proposal_id="+proposalId;
	String whereClause = "project_id="+projectId;
	String orderClause = "squence";

	CmdProjectProductDetail cmdProjectProductDetail = new CmdProjectProductDetail(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectProductDetail = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectProductDetail.action(iCommand , oidProjectProductDetail, systemCompanyId);
	iErrCode = cmdProjectProductDetail.action(iCommand , oidProjectProductDetail);

	// end switch
	JspProjectProductDetail jspProjectProductDetail = cmdProjectProductDetail.getForm();

	// count list All ProjectProductDetail
	int vectSize = DbProjectProductDetail.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectProductDetail.getErrors());

	ProjectProductDetail projectProductDetail = cmdProjectProductDetail.getProjectProductDetail();
	msgString =  cmdProjectProductDetail.getMessage();
	//out.println(msgString);

	// switch list ProjectProductDetail
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectProductDetail.generateFindStart(projectProductDetail.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectProductDetail.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectProductDetail = DbProjectProductDetail.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectProductDetail.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectProductDetail = DbProjectProductDetail.list(start,recordToGet, whereClause , orderClause);
	}
	
	//out.println("<br>listProjectProductDetail : "+listProjectProductDetail);
	
/*	
	if (iCommand==JSPCommand.SAVE){
		//Update Project
		project.setVat(JSPRequestValue.requestInt(request, "chkVat"));
		project.setDiscount(JSPRequestValue.requestInt(request, "chkDiscount"));
		project.setDiscountPercent(JSPRequestValue.requestDouble(request, "discountPercent"));
		project.setDiscountAmount(JSPRequestValue.requestDouble(request, "discountAmount"));
		try{
			DbProject.updateExc(project);
		}catch(Exception e){
			System.out.println(e);
		}
	}
*/

	try{ 
		project = DbProject.fetchExc(projectId);
	}catch(Exception e){
		System.out.println(e);
	}
	
	double totalAmount = getTotalDetail(listProjectProductDetail);
	double subTotal = totalAmount;

	//Company
	Company company = new Company();
	try{
		company = DbCompany.getCompany();
	}catch(Exception e){
		System.out.println(e);
	}
	
	//Discount to total
	double discountTotal = project.getDiscountAmount();
	double discountPercent = project.getDiscountPercent();
	if(project.getDiscount()>0){
		totalAmount = totalAmount - discountTotal;
	}
	
	//Vat
	double percentVat = company.getGovernmentVat();
	double vat = percentVat/100*totalAmount;
	if(project.getVat()>0){
		totalAmount = totalAmount + vat;
	}
		
	double totalBalance = project.getAmount()-totalAmount;
	//totalBalance = Math.round(totalBalance*100)/100;	
	totalBalance = 0;// ga ada balance lagi
	//out.println(totalBalance);
	
	//out.println("iCommand : "+iCommand);

	//out.println(iCommand);
	if (iCommand==JSPCommand.SAVE || iCommand==JSPCommand.POST || iCommand==JSPCommand.DELETE){
	
		
	
		//Update Project
		//project.setVat(JSPRequestValue.requestInt(request, "chkVat"));
		//project.setDiscount(JSPRequestValue.requestInt(request, "chkDiscount"));
		//project.setDiscountPercent(JSPRequestValue.requestDouble(request, "discountPercent"));
		//project.setDiscountAmount(JSPRequestValue.requestDouble(request, "discountAmount"));
		project.setVat(JSPRequestValue.requestInt(request, "chkVat"));
		project.setDiscount(JSPRequestValue.requestInt(request, "chkDiscount"));
		project.setDiscountPercent(JSPRequestValue.requestDouble(request, "discountPercent"));
		project.setPphPercent(JSPRequestValue.requestDouble(request, "pph_percent"));
		project.setPphAmount(JSPRequestValue.requestDouble(request, "pph_amount"));
		project.setPphType(JSPRequestValue.requestInt(request, "pph_type"));
		//subTotal-(subTotal*%disc/100)
		
		DbProject.updateProjectAmount(projectId, project);
		
	}


	if (iCommand==JSPCommand.SUBMIT){
		if(oidProjectProductDetail>0){
			iCommand = JSPCommand.EDIT;
		}else{
			iCommand = JSPCommand.ADD;
		}
	}
	
	Vector listProjectTerm = DbProjectTerm.list(0,0,"project_id="+projectId,"squence");
		
	double ttAmount = getTtDetail(listProjectTerm);
	double ttBalance = project.getAmount()-ttAmount;
	
	//out.println("amount ="+JSPFormater.formatNumber(ttAmount, "#,###.##"));
	//out.println("balance ="+JSPFormater.formatNumber(ttBalance, "#,###.##"));

%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

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

	function cmdCheckIt(){
		if(document.frmprojectproductdetail.chkVat.checked){
			document.frmprojectproductdetail.vatPercent.value="<%=sysCompany.getGovernmentVat()%>";
			document.frmprojectproductdetail.vat.value="0.00";
		}
		else{
			document.frmprojectproductdetail.vatPercent.value="0.00";
			document.frmprojectproductdetail.vat.value="0.00";
		}		

		if(document.frmprojectproductdetail.chkDiscount.checked){
			document.frmprojectproductdetail.discountPercent.value="<%=project.getDiscountPercent()%>";
			document.frmprojectproductdetail.discountAmount.value="0.00";
		}
		else{
			document.frmprojectproductdetail.discountPercent.value="0.00";
			document.frmprojectproductdetail.discountAmount.value="0.00";
		}		

		cmdUpdateDiscount();
	} 

	function cmdUpdateDiscount(){	
		var subtotal = document.frmprojectproductdetail.total.value;
		subtotal = removeChar(subtotal);	
		subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
		var discount = document.frmprojectproductdetail.discountPercent.value;		
		if(discount.length>0 && discount!=" "){
			discount = removeChar(discount);
			discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			document.frmprojectproductdetail.discountPercent.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			discount = (subtotal * parseFloat(discount))/100;
			document.frmprojectproductdetail.discountAmount.value = formatFloat(discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			discount = 0;
			document.frmprojectproductdetail.discountPercent.value="0.00";
			document.frmprojectproductdetail.discountAmount.value="0.00";
		}
		
		
		var vat = document.frmprojectproductdetail.vatPercent.value;		
		if(vat.length>0 && vat!=" "){
			vat = removeChar(vat);			
			vat = cleanNumberFloat(vat, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			vat = document.frmprojectproductdetail.vatPercent.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			vat = ((subtotal - discount) * parseFloat(vat))/100;		
			document.frmprojectproductdetail.vat.value = formatFloat(vat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		else{
			vat = 0;
			document.frmprojectproductdetail.vatPercent.value = "0.00";
			document.frmprojectproductdetail.vat.value = "0.00";
		}
		
		var grandTotal = subtotal - discount + vat;
		document.frmprojectproductdetail.grandTotal.value = formatFloat(grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 			
	}

	function checkProduct(){	
		document.frmprojectproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmprojectproductdetail.submit();
	}
		
	function cmdAdd(){
		document.frmprojectproductdetail.hidden_projectproductdetail.value="0";
		document.frmprojectproductdetail.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdAsk(oidProjectProductDetail){
		document.frmprojectproductdetail.hidden_projectproductdetail.value=oidProjectProductDetail;
		document.frmprojectproductdetail.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdDelete(oidProjectProductDetail){
		document.frmprojectproductdetail.hidden_projectproductdetail.value=oidProjectProductDetail;
		document.frmprojectproductdetail.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdConfirmDelete(oidProjectProductDetail){
		document.frmprojectproductdetail.hidden_projectproductdetail.value=oidProjectProductDetail;
		document.frmprojectproductdetail.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdSave(){
		checkNumber2();
			<%
				if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){
			%>
			//if(confirm('Are you sure to save these data ?')){
			<%	}%>
				document.frmprojectproductdetail.command.value="<%=JSPCommand.SAVE%>";
				document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
				document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
				document.frmprojectproductdetail.submit();
			<%
				if(project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){
			%>	
			//}
			<%	}%>
		}
		
	function cmdSaveDoc(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.POST%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}	

	function cmdEdit(oidProjectProductDetail){
		<%if(masterPrivUpdate){%>
		document.frmprojectproductdetail.hidden_projectproductdetail.value=oidProjectProductDetail;
		document.frmprojectproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
		<%}%>
		}

	function cmdCancel(oidProjectProductDetail){
		document.frmprojectproductdetail.hidden_projectproductdetail.value=oidProjectProductDetail;
		document.frmprojectproductdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectproductdetail.prev_command.value="<%=prevCommand%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdBack(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectproductdetail.hidden_projectproductdetail.value="0";
		//document.frmprojectproductdetail.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
		}

	function cmdListFirst(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectproductdetail.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdListPrev(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectproductdetail.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
		}

	function cmdListNext(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectproductdetail.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function cmdListLast(){
		document.frmprojectproductdetail.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectproductdetail.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectproductdetail.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectproductdetail.submit();
	}

	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
	}

	function checkNumber2(){
		//new Amount Input
		var newAmount = document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_SELLING_PRICE]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				

		//new Qty Input
		var newQty = document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_QTY]%>.value;
		newQty = cleanNumberFloat(newQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);						
		
		//new Discount
		var newDiscount = document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_DISCOUNT_AMOUNT]%>.value;
		newDiscount = cleanNumberFloat(newDiscount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		
		if((parseFloat(newAmount)*parseFloat(newQty))<=(parseFloat(newDiscount)))
		{
			//alert("Discount > Selling Price * Qty");
			document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_DISCOUNT_AMOUNT]%>.value = 0; 		
		}
		document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_SELLING_PRICE]%>.value = formatFloat((parseFloat(newAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_DISCOUNT_AMOUNT]%>.value = formatFloat((parseFloat(newDiscount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmprojectproductdetail.<%=jspProjectProductDetail.colNames[jspProjectProductDetail.JSP_TOTAL]%>.value = formatFloat(((parseFloat(newAmount)*parseFloat(newQty))-(parseFloat(newDiscount))), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
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
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenupg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagespg/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menupg.jsp"%>
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
                                                <form name="frmprojectproductdetail" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectproductdetail" value="<%=oidProjectProductDetail%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"> 
                                                              <%if(projectId==0){%>
                                                              <span class="lvl2"> 
                                                              New </span> &raquo; 
                                                              <%}%>
                                                              <span class="lvl2"> 
                                                              Product Detail</span><span class="lvl2"><br>
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
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                          <tr > 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                            <%//if(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>&command=<%=JSPCommand.EDIT%>" class="tablink">Project 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <%//}%>
                                                            <td class="tab" nowrap>Product 
                                                              Detail</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if((project.getAmount()!=0)||(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT)||(project.getStatus()==I_Crm.PROJECT_STATUS_REJECT)){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Payment 
                                                              Term</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if((ttBalance==0)||(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT)||(project.getStatus()==I_Crm.PROJECT_STATUS_REJECT)){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Order 
                                                              Confirmation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING || project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Installation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Closing</a></b></td>
                                                            <%}}}%>
                                                            <td nowrap class="tabheader"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000">&nbsp; 
                                                              </font></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="4" class="listtitle"></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="4" class="listtitle"></td>
                                                                </tr>
                                                                <%if(project.getStatus()==I_Crm.PROPOSAL_STATUS_PROJECT){%>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Number</td>
                                                                  <td width="22%"><strong>: 
                                                                    <%=project.getNumber()%></strong></td>
                                                                  <td width="13%"><b></b></td>
                                                                  <td width="55%"><b></b></td>
                                                                </tr>
                                                                <%}%>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Name</td>
                                                                  <td width="22%">: 
                                                                    <%=project.getName()%></td>
                                                                  <td width="13%">Customer</td>
                                                                  <td width="55%">: 
                                                                    <%=customer.getName()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%">Start 
                                                                    Date</td>
                                                                  <td width="22%">: 
                                                                    <%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                  <td width="13%">End 
                                                                    Date</td>
                                                                  <td width="55%">: 
                                                                    <%=JSPFormater.formatDate(project.getEndDate(), "dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%">Project 
                                                                    Status</td>
                                                                  <td width="22%">: 
                                                                    <%=I_Crm.projectStatusStr[project.getStatus()]%></td>
                                                                  <td width="13%">Applay 
                                                                    PPN </td>
                                                                  <td width="55%"> 
                                                                    <input type="checkbox" name="chkVat" value="1" <%if(project.getVat()==1){%>checked<%}%> onClick="javascript:cmdCheckIt()"  <%if(iCommand==JSPCommand.NONE || iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){}else{%> disabled<%}%>>
                                                                    Yes </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b></b></td>
                                                                  <td width="22%"><b></b></td>
                                                                  <td width="13%">Applay 
                                                                    Discount Total</td>
                                                                  <td width="55%"> 
                                                                    <input type="checkbox" name="chkDiscount" value="1" <%if(project.getDiscount()==1){%>checked<%}%> onClick="javascript:cmdCheckIt()"  <%if(iCommand==JSPCommand.NONE || iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){}else{%> disabled<%}%>>
                                                                    Yes </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="5">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="55%">&nbsp;</td>
                                                                </tr>
                                                                <%if(totalBalance!=0){%>
                                                                <tr> 
                                                                  <td width="10%" height="15"><b><font color="#FF0000">Balance</font></b></td>
                                                                  <td width="22%"><font color="#FF0000"><b>: 
                                                                    <%=JSPFormater.formatNumber(totalBalance,"#,###.##")%></b></font></td>
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="55%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="55%">&nbsp;</td>
                                                                </tr>
                                                                <%}%>
                                                                <tr> 
                                                                  <td width="10%" height="15"><b><font color="#FF0000" size="2">Project 
                                                                    Amount</font></b></td>
                                                                  <td width="22%"><font color="#FF0000" size="2"><b>: 
                                                                    <%=JSPFormater.formatNumber(project.getAmount(),"#,###.##")%></b></font></td>
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="55%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="55%">&nbsp;</td>
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
                                                                        <td class="boxed1"><%= drawList(iCommand,jspProjectProductDetail, projectProductDetail,listProjectProductDetail,oidProjectProductDetail,project)%></td>
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
                                                                        <td width="70%">&nbsp;</td>
                                                                        <td width="30%" class="boxed1"> 
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td width="37%" class="tablecell" align="left"><strong>&nbsp;&nbsp;&nbsp;SUB 
                                                                                TOTAL</strong></td>
                                                                              <td width="25%" class="tablecell" align="right"></td>
                                                                              <td width="38%" class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="total" value="<%=JSPFormater.formatNumber(subTotal,"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//if(project.getDiscount()>0){%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;DISCOUNT</strong></td>
                                                                              <td class="tablecell" align="center"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="discountPercent" value="<%=JSPFormater.formatNumber(discountPercent,"#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateDiscount()" onClick="this.select()" <%if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0){}else{%> class="readonly" readonly<%}%>>
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="discountAmount" value="<%=JSPFormater.formatNumber(discountTotal,"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//}%>
                                                                            <%	//if(project.getVat()>0){%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;PPN</strong></td>
                                                                              <td class="tablecell" align="center"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="vatPercent" value="<%=JSPFormater.formatNumber(percentVat,"#,###.##")%>" style="text-align:right" size="5">
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                  <input type="text" name="vat" value="<%=JSPFormater.formatNumber(vat,"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <tr>
                                                                              <td align="left" class="tablecell"><strong>&nbsp;&nbsp;&nbsp;GRAND 
                                                                                TOTAL</strong></td>
                                                                              <td class="tablecell" align="right">&nbsp;</td>
                                                                              <td class="tablecell" align="right">
                                                                                <input type="text" name="grandTotal" value="<%=JSPFormater.formatNumber(totalAmount,"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                              </td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell" nowrap><b><strong>&nbsp;&nbsp;&nbsp;</strong>PPH 
                                                                                <select name="pph_type">
                                                                                  <option value="0" <%if(project.getPphType()==DbProject.TYPE_JASA){%>selected<%}%>>JASA</option>
                                                                                  <option value="1" <%if(project.getPphType()==DbProject.TYPE_MATERIAL){%>selected<%}%>>MATERIAL</option>
                                                                                </select>
                                                                                </b></td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="center"> 
                                                                                  <input type="text" name="pph_percent" value="<%=JSPFormater.formatNumber(project.getPphPercent(),"#,###.##")%>" style="text-align:right" size="5" onClick="this.select()">
                                                                                  % 
                                                                                </div>
                                                                              </td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <input type="text" name="pph_amount" value="<%=JSPFormater.formatNumber(project.getPphAmount(),"#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                                              </td>
                                                                            </tr>
                                                                            <%	//}%>
                                                                            <tr> 
                                                                              <td align="left" class="tablecell">&nbsp;</td>
                                                                              <td class="tablecell" align="right"></td>
                                                                              <td class="tablecell" align="right"> 
                                                                                <div align="right"> 
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%//if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){%>
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
																			  <%if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && project.getStatus()==I_Crm.PROJECT_STATUS_DRAFT){%>
                                                                              <td width="25%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
																			  <%}%>
                                                                              <td width="75%"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21x','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" width="115" height="22" border="0"></a></td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%//}%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                            <td height="8" colspan="2" width="83%">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top" > 
                                                            <td colspan="3" class="command"> 
                                                              <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProjectProductDetail+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectProductDetail+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectProductDetail+"')";
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
			 	if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
					jspLine.setDeleteCaption("");
					jspLine.setSaveCaption("");
				}else if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING){
					jspLine.setDeleteCaption("");
				}
			 }
			 
		   %>
                                                              <%
			 if(iCommand==JSPCommand.EDIT || iCommand==JSPCommand.ADD || iCommand==JSPCommand.ASK || iErrCode!=0)
			 {
		   %>
                                                              <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                              <%
			 }
		   %>
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
							if ((iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT) && projectProductDetail.getProductMasterId()==0) 
							{
						%>
								checkProduct();
						<%
							}
						%>						
						cmdCheckIt();
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
            <%@ include file="../main/footerpg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

