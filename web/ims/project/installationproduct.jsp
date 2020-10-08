<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_PRODUCT);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_PRODUCT, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_PRODUCT, AppMenu.PRIV_UPDATE);
	
	//Approval 1
	boolean approvalPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED);
	boolean approvalPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_APPROVED, AppMenu.PRIV_UPDATE);

	//Approval 2
	boolean approvalPriv2 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED);
	boolean approvalPrivView2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate2 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_BUDGET_ISSUED, AppMenu.PRIV_UPDATE);
	
	//Approval 3 Finish Install
	boolean approvalPriv3 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH);
	boolean approvalPrivView3 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate3 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_FINISH, AppMenu.PRIV_UPDATE);
	
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspProjectInstallationProduct frmObject, ProjectInstallationProduct objEntity, Vector objectClass,  long projectInstallationProductId, ProjectInstallation objEntity1, long companyId, long userId, Project project)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Product","30%");
		jsplist.addHeader("Category","24%");
		jsplist.addHeader("Qty","8%");
		jsplist.addHeader("UOM","8%");
		jsplist.addHeader("Stock Location","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		//Vector vProjectProductDetail = DbProjectProductDetail.list(0,0, "company_id="+companyId+" and project_id="+objEntity1.getProjectId(), "squence");
		Vector vProjectProductDetail = DbProjectProductDetail.list(0,0, "project_id="+objEntity1.getProjectId(), "squence");
		Vector ProjectProductDetail_value = new Vector(1,1);
		Vector ProjectProductDetail_key = new Vector(1,1);
		if(vProjectProductDetail!=null && vProjectProductDetail.size()>0)
		{
			for(int i=0; i<vProjectProductDetail.size(); i++)
			{
				ProjectProductDetail c = (ProjectProductDetail)vProjectProductDetail.get(i);
				ItemMaster product = new ItemMaster();
				try{
					product = DbItemMaster.fetchExc(c.getProductMasterId());
				}catch(Exception e){
					System.out.println(e);
				}
				ProjectProductDetail_key.add(product.getName().trim());
				ProjectProductDetail_value.add(""+c.getOID());
			}
		}
		
		Vector vLocs = DbLocation.list(0,0, "", "");
		Vector loc_value = new Vector(1,1);
		Vector loc_key = new Vector(1,1);
		if(vLocs!=null && vLocs.size()>0)
		{
			for(int i=0; i<vLocs.size(); i++)
			{
				Location c = (Location)vLocs.get(i);
				loc_key.add(c.getName().trim());
				loc_value.add(""+c.getOID());
			}
		}

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectInstallationProduct objProjectInstallationProduct = (ProjectInstallationProduct)objectClass.get(i);
			rowx = new Vector();
			if(projectInstallationProductId == objProjectInstallationProduct.getOID())
				index = i;

			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objProjectInstallationProduct.getOID()!=0))){
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectInstallationProduct.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));							
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ProjectProductDetail_value , ProjectProductDetail_key, "onChange=\"javascript:checkCategory()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));

				//Project Product Detail	
				ProjectProductDetail colCombo3  = new ProjectProductDetail();
				try{
					colCombo3 = DbProjectProductDetail.fetchExc(objEntity.getProjectProductDetailId());
				}catch(Exception e) {}
				
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(colCombo3.getProductMasterId());
				}catch(Exception e) {
					System.out.println("exception 1 : "+e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println("exception 2 : "+e);
				}
				ItemCategory subCategory = new ItemCategory();
				try{
					subCategory = DbItemCategory.fetchExc(colCombo2.getItemCategoryId());
				}catch(Exception e) {
					System.out.println("exception 3 : "+e);
				}
				ItemGroup category = new ItemGroup();
				try{
					category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
				}catch(Exception e) {
					System.out.println("exception 4 : "+e);
				}
				rowx.add("<input type=\"text\" name=\"productCategory\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");					
				rowx.add("<input type=\"text\" onClick=\"this.select()\" style=\"text-align:right\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objProjectInstallationProduct.getQty()+"\" class=\"formElemen\" size=\"15\" onBlur=\"javascript:checkQty()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
				rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>"); 
				
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_STOCK_LOCATION_ID],null, ""+objEntity.getStockLocationId(), loc_value , loc_key, "", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_STOCK_LOCATION_ID));
				
				/*rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_LOCATION_DETAIL] +"\" value=\""+objProjectInstallationProduct.getLocationDetail()+"\" class=\"formElemen\" size=\"40\">"+ frmObject.getErrorMsg(frmObject.JSP_LOCATION_DETAIL)+

				"<input type=\"hidden\" name=\"maxQtyInstall\" value=\""+DbProjectInstallationProduct.getMaxQtyInstall(objEntity1.getOID(),objEntity.getProjectProductDetailId())+"\" class=\"formElemen\" size=\"20\">"+
				"<input type=\"hidden\" name=\"maxQtyProduct\" value=\""+DbProjectInstallationProduct.getMaxQtyProduct(objEntity1.getOID(),objEntity.getProjectProductDetailId())+"\" class=\"formElemen\" size=\"20\">"+
				"<input type=\"hidden\" name=\"editQty\" value=\""+objProjectInstallationProduct.getQty()+"\" class=\"formElemen\" size=\"20\">"+

				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectInstallationProduct.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objProjectInstallationProduct.getInstallationId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectInstallationProduct.getDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));
				*/

			}
			else
			{
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationProduct.getSquence())+"</div>");
				ProjectProductDetail colCombo3  = new ProjectProductDetail();
				try{
					colCombo3 = DbProjectProductDetail.fetchExc(objProjectInstallationProduct.getProjectProductDetailId());
				}catch(Exception e) {}

				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(colCombo3.getProductMasterId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}				
				if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || objEntity1.getStatus()==I_Crm.INSTALL_STATUS_FINISH){
					rowx.add(colCombo2.getName());
				}else{
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectInstallationProduct.getOID())+"')\">"+colCombo2.getName()+"</a>");
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
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationProduct.getQty())+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(uom.getUnit())+"</div>");
				
				Location loc = new Location();
				try{
					loc = DbLocation.fetchExc(objProjectInstallationProduct.getStockLocationId());
				}catch(Exception e) {
					System.out.println(e);
				}
				
				rowx.add(loc.getCode()+"-"+loc.getName());
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
			rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbProjectInstallationProduct.getMaxSquence(objEntity1.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));		
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ProjectProductDetail_value , ProjectProductDetail_key, "onChange=\"javascript:checkCategory()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));

			//Project Product Detail	
			ProjectProductDetail colCombo3  = new ProjectProductDetail();
			try{
				colCombo3 = DbProjectProductDetail.fetchExc(objEntity.getProjectProductDetailId());
			}catch(Exception e) {}
	
			ItemMaster colCombo2  = new ItemMaster();
			try{
				colCombo2 = DbItemMaster.fetchExc(colCombo3.getProductMasterId());
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
			
			rowx.add("<input type=\"text\" name=\"productCategory\" value=\""+category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName()+"\" class=\"readonly\" size=\"40\" readOnly>");
			rowx.add("<input type=\"text\" onClick=\"this.select()\" style=\"text-align:right\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"15\" onBlur=\"javascript:checkQty()\">"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
			rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
			
			rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_STOCK_LOCATION_ID],null, ""+objEntity.getStockLocationId(), loc_value , loc_key, "", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_STOCK_LOCATION_ID));
			
			/*rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_LOCATION_DETAIL] +"\" value=\""+objEntity.getLocationDetail()+"\" class=\"formElemen\" size=\"40\">"+ frmObject.getErrorMsg(frmObject.JSP_LOCATION_DETAIL)+

			"<input type=\"hidden\" name=\"maxQtyInstall\" value=\""+DbProjectInstallationProduct.getMaxQtyInstall(objEntity1.getOID(),objEntity.getProjectProductDetailId())+"\" class=\"formElemen\" size=\"20\">"+
			"<input type=\"hidden\" name=\"maxQtyProduct\" value=\""+DbProjectInstallationProduct.getMaxQtyProduct(objEntity1.getOID(),objEntity.getProjectProductDetailId())+"\" class=\"formElemen\" size=\"20\">"+
			"<input type=\"hidden\" name=\"editQty\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"20\">"+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objEntity1.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objEntity1.getOID()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
			"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(new Date(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));
			*/
			
			lstData.add(rowx);
		}

		

		return jsplist.draw(index);
	}
%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	long installationId = JSPRequestValue.requestLong(request, "oid");
	//long oidProposal = JSPRequestValue.requestLong(request, "hidden_proposal_id");
	//load Instalation 
	ProjectInstallation projInstallation = new ProjectInstallation();
	try{
		projInstallation = DbProjectInstallation.fetchExc(installationId);
	}catch(Exception e){
		System.out.println(e);
	}
	
	//Load Employee
	Employee emp = new Employee();
	try{
		emp = DbEmployee.fetchExc(projInstallation.getEmployeeId());
	}catch(Exception e){
		System.out.println(e);
	}
	
	long projectId = projInstallation.getProjectId();	
	//out.println(projectId);
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	
	try{ 
		project = DbProject.fetchExc(projectId);
		//oidProposal = project.getProposalId();
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
	long oidProjectInstallationProduct = JSPRequestValue.requestLong(request, "hidden_projectinstallationproduct");
	
	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "installation_id="+installationId;
	String orderClause = "squence";

	CmdProjectInstallationProduct cmdProjectInstallationProduct = new CmdProjectInstallationProduct(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectInstallationProduct = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectInstallationProduct.action(iCommand , oidProjectInstallationProduct, systemCompanyId);
	iErrCode = cmdProjectInstallationProduct.action(iCommand , oidProjectInstallationProduct);

	// end switch
	JspProjectInstallationProduct jspProjectInstallationProduct = cmdProjectInstallationProduct.getForm();

	// count list All ProjectInstallationProduct
	int vectSize = DbProjectInstallationProduct.getCount(whereClause);

	//recordToGet = vectSize;

	out.println(jspProjectInstallationProduct.getErrors());

	ProjectInstallationProduct projectInstallationProduct = cmdProjectInstallationProduct.getProjectInstallationProduct();
	msgString =  cmdProjectInstallationProduct.getMessage();
	//out.println(msgString);

	// switch list ProjectInstallationProduct
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbProjectInstallationProduct.generateFindStart(projectInstallationProduct.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdProjectInstallationProduct.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listProjectInstallationProduct = DbProjectInstallationProduct.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listProjectInstallationProduct.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listProjectInstallationProduct = DbProjectInstallationProduct.list(start,recordToGet, whereClause , orderClause);
	}
	
	if (iCommand==JSPCommand.SUBMIT){
		if(oidProjectInstallationProduct>0){
			iCommand = JSPCommand.EDIT;
		}else{
			iCommand = JSPCommand.ADD;
		}
	}
	
	int finish = JSPRequestValue.requestInt(request, "finish");
	if(finish>0){
		try{
			projInstallation.setStatus(I_Crm.INSTALL_STATUS_FINISH);
			DbProjectInstallation.updateExc(projInstallation);
		}catch(Exception e){
			System.out.println(e);
		}	
	}	
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

	function cmdInstallFinish(){
		<%if(approvalPrivUpdate3){%>
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationproduct.finish.value="<%=I_Crm.INSTALL_STATUS_FINISH%>";
		document.frmprojectinstallationproduct.submit();
		<%}%>
	}
	
	function cmdPrintOrder(){	 
		window.open("<%=printroot2%>.report.RptProjectInstallationOrderXLS?oid=<%=installationId%>");
	}
	
	var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
	var usrDigitGroup = "<%=sUserDigitGroup%>";
	var usrDecSymbol = "<%=sUserDecimalSymbol%>";

	function checkQty(){
		var maxQtyInstall = document.frmprojectinstallationproduct.maxQtyInstall.value;
		maxQtyInstall = cleanNumberFloat(maxQtyInstall, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		var maxQtyProduct = document.frmprojectinstallationproduct.maxQtyProduct.value;
		maxQtyProduct = cleanNumberFloat(maxQtyProduct, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		var editQty = document.frmprojectinstallationproduct.editQty.value;
		editQty = cleanNumberFloat(editQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		var newQty = document.frmprojectinstallationproduct.<%=jspProjectInstallationProduct.colNames[jspProjectInstallationProduct.JSP_QTY]%>.value;
		newQty = cleanNumberFloat(newQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		
		var pbalance = parseFloat(maxQtyProduct)-parseFloat(maxQtyInstall)+parseFloat(editQty);
		
		if(parseFloat(newQty)>parseFloat(pbalance))
		{
			alert("Maximum Qty limit is "+pbalance+" \nsystem will reset the data");
			document.frmprojectinstallationproduct.<%=jspProjectInstallationProduct.colNames[jspProjectInstallationProduct.JSP_QTY]%>.value = pbalance; 	
		}		
		
	}
	
	function checkCategory(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmprojectinstallationproduct.submit();	
	}
	
	function cmdBackToList(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationproduct.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallationproduct.submit();
		}

	function cmdAdd(){
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value="0";
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdAsk(oidProjectInstallationProduct){
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value=oidProjectInstallationProduct;
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdDelete(oidProjectInstallationProduct){
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value=oidProjectInstallationProduct;
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdConfirmDelete(oidProjectInstallationProduct){
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value=oidProjectInstallationProduct;
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdSave(){
		//checkQty();
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
		}

	function cmdEdit(oidProjectInstallationProduct){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value=oidProjectInstallationProduct;
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallationProduct){
		document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value=oidProjectInstallationProduct;
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdBack(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallationproduct.hidden_projectinstallationproduct.value="0";
		//document.frmprojectinstallationproduct.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallationproduct.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationproduct.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationproduct.action="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationproduct.submit();
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
                                                <form name="frmprojectinstallationproduct" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallationproduct" value="<%=oidProjectInstallationProduct%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
												  <input type="hidden" name="<%=JspProjectInstallationProduct.colNames[JspProjectInstallationProduct.JSP_PROJECT_ID]%>" value="<%=project.getOID()%>">
												  <input type="hidden" name="<%=JspProjectInstallationProduct.colNames[JspProjectInstallationProduct.JSP_USER_ID]%>" value="<%=user.getOID()%>">
												  <input type="hidden" name="<%=JspProjectInstallationProduct.colNames[JspProjectInstallationProduct.JSP_INSTALLATION_ID]%>" value="<%=projInstallation.getOID()%>">
												  <input type="hidden" name="<%=jspProjectInstallationProduct.colNames[jspProjectInstallationProduct.JSP_QTY]%>" value="">
                                                  <input type="hidden" name="finish" value=""> 
												  <input type="hidden" name="maxQtyInstall" value="">
												  <input type="hidden" name="maxQtyProduct" value="">
												  <input type="hidden" name="editQty" value="">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"><span class="lvl2">Installation 
                                                              Detail<br>
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
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>" class="tablink">Project 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Product 
                                                              Detail</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Payment 
                                                              Term</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Order 
                                                              Confirmation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tab" nowrap>Installation</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Closing</a></b></td>
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
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Number</b></td>
                                                                  <td width="22%"><strong><%=project.getNumber()%></strong></td>
                                                                  <td width="10%"><b>Customer</b></td>
                                                                  <td width="58%"><%=customer.getName()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Name</b></td>
                                                                  <td width="22%"><%=project.getName()%></td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%"><%=project.getCustomerAddress()%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="8%"><b>Start 
                                                                    Date</b></td>
                                                                  <td width="22%"><%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                  <td width="10%"><b>End 
                                                                    Date</b></td>
                                                                  <td width="58%"><%=JSPFormater.formatDate(project.getEndDate(), "dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="18" width="10%"><b>Project 
                                                                    Status</b></td>
                                                                  <td width="22%"><b><%=I_Crm.projectStatusStr[project.getStatus()]%></b></td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="8" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15" colspan="4"><b><u>Installation</u></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Location</b></td>
                                                                  <td colspan="3"><b><%=projInstallation.getLocation()%></b> 
                                                                    ( <%=projInstallation.getAddress()%> 
                                                                    )</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>PIC</b></td>
                                                                  <td colspan="3"><%=emp.getEmpNum()%> 
                                                                    / <%=emp.getName()%> 
                                                                    ( <%=projInstallation.getPicPosition()%> 
                                                                    )</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Date</b></td>
                                                                  <td colspan="3"><%=JSPFormater.formatDate(projInstallation.getStartDate(),"dd MMMM yyyy")%> 
                                                                    - <%=JSPFormater.formatDate(projInstallation.getEndDate(),"dd MMMM yyyy")%></td>
                                                                </tr>
                                                                <%
				long duration = DateCalc.dayDifference(projInstallation.getStartDate(), projInstallation.getEndDate());
				String Duration = "";
				if (duration>0) {
					Duration = duration +"  days";
				}else{
					Duration = duration + "  day";
				}
			%>
                                                                <tr> 
                                                                  <td height="15"><b>Duration</b></td>
                                                                  <td><%=Duration%></td>
                                                                  <td></td>
                                                                  <td></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15"><b>Status</b></td>
                                                                  <td><b><%=I_Crm.installStatusStr[projInstallation.getStatus()]%></b></td>
                                                                  <td><b><%if(!CRM_INSTALL_PRODUCT_ONLY){%>Budget 
                                                                    Status<%}%></b></td>
                                                                  <td><b><%if(!CRM_INSTALL_PRODUCT_ONLY){%><%=I_Crm.installBudgetStatusStr[projInstallation.getBudgetStatus()]%><%}%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    <%if(CRM_INSTALL_PRODUCT_ONLY && projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_FINISH){%>
																	<input type="button" onClick="javascript:cmdInstallFinish()" title="Finish" value="Installation Finish">
																	<%}else if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_IN_PROGRESS){%>
                                                                    <input type="button" onClick="javascript:cmdInstallFinish()" title="Finish" value="Installation Finish">
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="8" colspan="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4"> 
                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                      <tr > 
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
																		<%if(!CRM_INSTALL_PRODUCT_ONLY){%>
                                                                        <td class="tabin" nowrap> 
                                                                          <a href="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Budget 
                                                                          Proposed</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
																		<%}%>
                                                                        <td class="tab" nowrap><font color="#000000">Product</font></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <td nowrap class="tabheader"></td>
																		<%if(!CRM_INSTALL_PRODUCT_ONLY){%>
                                                                        <td class="tabin" nowrap><a href="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Resources 
                                                                          & Spareparts</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH){%>
                                                                        <td class="tabin" nowrap><a href="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Travel 
                                                                          Report</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%}}%>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="16" colspan="4"></td>
                                                                </tr>
                                                                <%
			 try
			 {
		   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawList(iCommand,jspProjectInstallationProduct, projectInstallationProduct,listProjectInstallationProduct,oidProjectInstallationProduct,  projInstallation, systemCompanyId, appSessUser.getUserOID(), project)%></td>
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
                                                                  <td height="15" valign="middle" colspan="4"> 
                                                                  </td>
                                                                </tr>
                                                                <%if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0){%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                        <%if(projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_FINISH){%>
                                                                        <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <%}}%>
                                                                        <%if(listProjectInstallationProduct.size()>0){%>
                                                                        <a href="javascript:cmdPrintOrder()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new23','','../images/printinstall2.gif',1)"><img src="../images/printinstall.gif" name="new23" width="170" height="22" border="0"></a> 
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <%}%>
                                                                        <a href="javascript:cmdBackToList()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/back2.gif',1)"><img src="../images/back.gif" name="new22" width="51" height="22" border="0"></a> 
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
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
			 String scomDel = "javascript:cmdAsk('"+oidProjectInstallationProduct+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectInstallationProduct+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectInstallationProduct+"')";
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
			 if(iCommand==JSPCommand.EDIT && project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){
				jspLine.setDeleteCaption("");
				jspLine.setSaveCaption("");
			 }else {
			 	//if(projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_DRAFT) {
				//	jspLine.setDeleteCaption("");
				//}
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
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
						<%
							if ((iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT) && projectInstallationProduct.getProjectProductDetailId()==0) 
							{
						%>
								//checkCategory();
								//checkQty();
						<%
							}
						%>						
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

