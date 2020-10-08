<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%@ include file = "../main/constant.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM, AppMenu.PRIV_UPDATE);
	
	//Approval
	boolean approvalPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM_APPROVE);
	boolean approvalPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM_APPROVE, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_ORDER_CONFIRM_APPROVE, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawListTerm(Vector objectClass, Project project)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Condition","35%");
		jsplist.addHeader("Due Date","12%");
		jsplist.addHeader("Amount","15%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectTerm objProjectTerm = (ProjectTerm)objectClass.get(i);
			rowx = new Vector();
			rowx.add("<div align=\"center\">"+String.valueOf(objProjectTerm.getSquence())+"</div>");
			if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || project.getStatus()==I_Crm.PROJECT_STATUS_AMEND || project.getStatus()==I_Crm.PROJECT_STATUS_REJECT){
				rowx.add("<div align=\"left\">"+objProjectTerm.getDescription()+"</div>");					
			}else{
				rowx.add("<div align=\"left\"><a href=\"javascript:cmdEditPayment('"+String.valueOf(objProjectTerm.getOID())+"')\">"+objProjectTerm.getDescription()+"</a></div>");
			}
			rowx.add("<div align=\"left\">"+JSPFormater.formatDate(objProjectTerm.getDueDate(), "dd MMMM yyyy")+"</div>");		
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objProjectTerm.getAmount(), "#,###.##")+"</div>");		
			lstData.add(rowx);
		}		
		//add total
		rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Total</b></div>");
		rowx.add("<div align=\"right\"><b>"+(getTotalPayment(objectClass)==0?"<b>Free</b>":JSPFormater.formatNumber(getTotalPayment(objectClass), "#,###.##"))+"</b></div>");		
		lstData.add(rowx);
		
		return jsplist.draw(index);
	}
	
	public String drawListProduct(Vector objectClass, Project project, Company company)
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
		jsplist.addHeader("Category","18%");
		jsplist.addHeader("Qty","12%");
		jsplist.addHeader("UOM","7%");
//		jsplist.addHeader("Amount","15%");
		jsplist.addHeader("Total Sales","15%");		

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectProductDetail objProjectProductDetail = (ProjectProductDetail)objectClass.get(i);
			rowx = new Vector();
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
				rowx.add("<div align=\"left\">"+colCombo2.getName()+"</div>");					
			}else{			
				rowx.add("<a href=\"javascript:cmdEditProduct('"+String.valueOf(objProjectProductDetail.getOID())+"')\">"+colCombo2.getName()+"</a>");
			}
			ItemCategory  subCategory = new ItemCategory ();
			try{
				subCategory = DbItemCategory .fetchExc(colCombo2.getItemCategoryId());
			}catch(Exception e) {
				System.out.println();
			}
			ItemGroup category = new ItemGroup();
			try{
				category = DbItemGroup.fetchExc(colCombo2.getItemGroupId());
			}catch(Exception e) {
				System.out.println(e);
			}
			rowx.add(category.getName()+""+((colCombo2.getItemCategoryId()>0)?"/":"")+""+subCategory.getName());
			rowx.add("<div align=\"center\">"+String.valueOf(objProjectProductDetail.getQty())+"</div>");
			rowx.add("<div align=\"center\">"+String.valueOf(uom.getUnit())+"</div>");
			//rowx.add("<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getSellingPrice(), "#,###.##"))+"</div>");
			rowx.add("<div align=\"right\">"+(objProjectProductDetail.getSellingPrice()==0?"<b>Free</b>":JSPFormater.formatNumber(objProjectProductDetail.getTotal(), "#,###.##"))+"</div>");		
			lstData.add(rowx);
		}
		//Total Amount
		double totalAmount = getTotalProduct(objectClass);
		
		//add total
		rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Sub Total</b></div>");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>"+(getTotalProduct(objectClass)==0?"<b>Free</b>":JSPFormater.formatNumber(totalAmount, "#,###.##"))+"</b></div>");		
		lstData.add(rowx);
		if(project.getDiscount()>0){
			rowx = new Vector();
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("<div align=\"right\"><b>Discount</b></div>");
			rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(project.getDiscountPercent(), "#,###.##")+"%</b></div>");		
			rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(project.getDiscountAmount(), "#,###.##")+"</b></div>");		
			lstData.add(rowx);
			totalAmount = totalAmount - (project.getDiscountPercent()*totalAmount/100);
		}		
		if(project.getVat()>0){
			rowx = new Vector();
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("<div align=\"right\"><b>VAT</b></div>");
			rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(company.getGovernmentVat(), "#,###.##")+"%</b></div>");		
			rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(totalAmount*company.getGovernmentVat()/100, "#,###.##")+"</b></div>");		
			lstData.add(rowx);
			totalAmount = totalAmount + totalAmount*company.getGovernmentVat()/100;
		}
		rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Grand Total</b></div>");
		rowx.add("");		
		rowx.add("<div align=\"right\"><b>"+(getTotalProduct(objectClass)==0?"<b>Free</b>":JSPFormater.formatNumber(totalAmount, "#,###.##"))+"</b></div>");		
		lstData.add(rowx);

		return jsplist.draw(index);
	}
	
	public double getTotalProduct(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectProductDetail projectProductDetail = (ProjectProductDetail)listx.get(i);
				result = result + (projectProductDetail.getSellingPrice()*projectProductDetail.getQty()) - (projectProductDetail.getDiscountAmount());
			}
		}
		return result;
	}
	
	public double getTotalPayment(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ProjectTerm projectTerm = (ProjectTerm)listx.get(i);
				result = result + projectTerm.getAmount();
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
	//long proposalId = 0;
	//out.println(projectId);
	Project project = new Project();
	Customer customer = new Customer();
	Currency currency = new Currency();
	Company company = new Company();
	
	try{ 
		project = DbProject.fetchExc(projectId);
		//proposalId = project.getProposalId();
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
	
	try{
		company = DbCompany.getCompany();
	}catch(Exception exc){
	}
	
	int iCommand = JSPRequestValue.requestCommand(request);

	if(iCommand==JSPCommand.NONE)
	{
		iCommand = JSPCommand.ADD;
	}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidProjectOrderConfirmation = JSPRequestValue.requestLong(request, "hidden_projectorderconfirmation");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	//String whereClause = "company_id="+systemCompanyId+" and project_id="+projectId;
	String whereClause = "project_id="+projectId;
	String orderClause = "squence";

	CmdProjectOrderConfirmation cmdProjectOrderConfirmation = new CmdProjectOrderConfirmation(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectOrderConfirmation = new Vector(1,1);

	// switch statement
	//iErrCode = cmdProjectOrderConfirmation.action(iCommand , oidProjectOrderConfirmation, systemCompanyId);
	iErrCode = cmdProjectOrderConfirmation.action(iCommand , oidProjectOrderConfirmation);

	// end switch
	JspProjectOrderConfirmation jspProjectOrderConfirmation = cmdProjectOrderConfirmation.getForm();

	// count list All ProjectOrderConfirmation
	int vectSize = DbProjectOrderConfirmation.getCount(whereClause);
	recordToGet = vectSize;

	ProjectOrderConfirmation projectOrderConfirmation = cmdProjectOrderConfirmation.getProjectOrderConfirmation();
	msgString =  cmdProjectOrderConfirmation.getMessage();

	// get record to display Order Confirmation
	listProjectOrderConfirmation = DbProjectOrderConfirmation.list(start,recordToGet, whereClause , "");
	if (listProjectOrderConfirmation.size()>0)
	{
		projectOrderConfirmation = (ProjectOrderConfirmation)listProjectOrderConfirmation.get(0);
	}
	oidProjectOrderConfirmation = projectOrderConfirmation.getOID();

	// get recort Project Term Payment
	Vector listProjectTerm = DbProjectTerm.list(0,0, "project_id="+projectId, orderClause);
	
	// get recort Project Product Detail
	Vector listProjectProductDetail = DbProjectProductDetail.list(0,0, "project_id="+projectId, orderClause);
	
	//Update Project Status to Selected Process
	long userApprove = JSPRequestValue.requestLong(request, jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_USER_ID]);
	int projStatus = JSPRequestValue.requestInt(request, "projStatus");
	if(iCommand==JSPCommand.SAVE && userApprove>0){
		//Update Project
		project.setStatus(projStatus);
		try{
			DbProject.updateExc(project);
		}catch(Exception e){
			System.out.println(e);
		}
		//Update Confirmation
		if(projStatus==I_Crm.PROJECT_STATUS_RUNNING){		
			projectOrderConfirmation.setStatus(I_Crm.CONFIRM_STATUS_APPROVED);
			//posting journal
			DbProjectOrderConfirmation.postJournal(projectId);

		}else if(projStatus==I_Crm.PROJECT_STATUS_AMEND || projStatus==I_Crm.PROJECT_STATUS_REJECT){		
			projectOrderConfirmation.setStatus(I_Crm.CONFIRM_STATUS_CANCELLED);
		}		
		projectOrderConfirmation.setUserId(appSessUser.getUserOID());
		projectOrderConfirmation.setDate((projectOrderConfirmation.getDate()==null)?new Date():projectOrderConfirmation.getDate());
		try{
			DbProjectOrderConfirmation.updateExc(projectOrderConfirmation);
		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	//Count Total Product
	double totalAmount = getTotalProduct(listProjectProductDetail);
	if(project.getDiscount()>0){
		totalAmount = totalAmount - (project.getDiscountPercent()*totalAmount/100);
	}
	/*
	if(project.getVat()>0){
		totalAmount = totalAmount + totalAmount*sysCompany.getGovernmentVat()/100;
	}*/
	
	if(project.getVat()>0){
		totalAmount = totalAmount + totalAmount*company.getGovernmentVat()/100;
	}
	
	double balance = project.getAmount()-totalAmount; //total product
	double balanceTerm = project.getAmount()-getTotalPayment(listProjectTerm);
	balance = Math.round(balance*100)/100;
	balanceTerm = Math.round(balanceTerm*100)/100;
	//out.println(Math.round(balance*100)/100);
	//out.println(Math.round(balanceTerm*100)/100);
	
	Vector lstProjectTerm = DbProjectTerm.list(0,0,"project_id="+projectId,"squence");
	double ttAmount = getTtDetail(lstProjectTerm);
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
	
	<%if(ttAmount==0 || ttBalance!=0){%>
		window.location="<%=approot%>/project/projectlist.jsp?target_page=1&menu_idx=<%=menuIdx%>";
	<%}%>
	
	function cmdPrintWork(){	 
		window.open("<%=printroot2%>.report.RptProjectWorkOrderXLS?oid=<%=projectId%>");
	}
	
	function cmdPrintConfirm(){	 
		window.open("<%=printroot2%>.report.RprProjectOrderConfirmationXLS?oid=<%=projectId%>");
	}



	function cmdAdd(){
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value="0";
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdAsk(oidProjectOrderConfirmation){
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdDelete(oidProjectOrderConfirmation){
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdConfirmDelete(oidProjectOrderConfirmation){
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdSave(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
		}

	function cmdApproved(type){	
		<%if(approvalPrivUpdate){%>
			if(confirm('Are you sure to do this action ?\nThis command could not be repeated. All data will be locked for additional new details')){
				document.frmprojectorderconfirmation.command.value="<%=JSPCommand.SAVE%>";
				document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
				document.frmprojectorderconfirmation.projStatus.value=type;
				//document.frmprojectorderconfirmation.<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_STATUS]%>.value="<%=I_Crm.CONFIRM_STATUS_APPROVED%>";		
				document.frmprojectorderconfirmation.<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_USER_ID] %>.value="<%= appSessUser.getUserOID()%>";
				document.frmprojectorderconfirmation.<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_DATE] %>.value="<%= JSPFormater.formatDate((projectOrderConfirmation.getDate()==null)?new Date():projectOrderConfirmation.getDate(),"dd/MM/yyyy")%>";				
				document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
				document.frmprojectorderconfirmation.submit();
			}
		<%}%>
		}

	function cmdEditPayment(oidProjectOrderConfirmation){
		<%if(masterPrivUpdate){%>
		document.frmprojectorderconfirmation.hidden_projectterm.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newpaymenterm.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
		<%}%>
		}

	function cmdEditProduct(oidProjectOrderConfirmation){
		<%if(masterPrivUpdate){%>
		document.frmprojectorderconfirmation.hidden_projectproductdetail.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newproductdetail.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
		<%}%>
		}


	function cmdCancel(oidProjectOrderConfirmation){
		document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value=oidProjectOrderConfirmation;
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=prevCommand%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdBack(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectorderconfirmation.hidden_projectorderconfirmation.value="0";
		//document.frmprojectorderconfirmation.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
		}

	function cmdListFirst(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdListPrev(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
		}

	function cmdListNext(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
	}

	function cmdListLast(){
		document.frmprojectorderconfirmation.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectorderconfirmation.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectorderconfirmation.action="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectorderconfirmation.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/save2.gif')">
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
                                                <form name="frmprojectorderconfirmation" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectorderconfirmation" value="<%=oidProjectOrderConfirmation%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="hidden_projectproductdetail" value="<%=oidProjectOrderConfirmation%>">
                                                  <input type="hidden" name="hidden_projectterm" value="<%=oidProjectOrderConfirmation%>">
                                                  <input type="hidden" name="projStatus" value="">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo;</font></b><b><font class="tit1"><span class="lvl2"> 
                                                              </span> <span class="lvl2"> 
                                                              Order Confirmation 
                                                              </span><span class="lvl2"><br>
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
                                                              <b><a href="newproject.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>&command=<%=JSPCommand.EDIT%>" class="tablink">Project 
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
                                                            <td class="tab" nowrap>Order 
                                                              Confirmation</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                              <%if(project.getStatus()==I_Crm.PROJECT_STATUS_RUNNING || project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE){%>
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Installation</a></b></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                            <td class="tabin" nowrap> 
                                                              <b><a href="newclosing.jsp?menu_idx=<%=menuIdx%>&oid=<%=project.getOID()%>" class="tablink">Closing</a></b></td>
                                                            <%}%>
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
                                                                  <td height="18" width="10%"><b>Amount</b></td>
                                                                  <td width="22%"><b><%=currency.getCurrencyCode()%>. 
                                                                    <%=JSPFormater.formatNumber(project.getAmount(),"#,###.##")%></b></td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%">&nbsp;</td>
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
                                                                  <td width="10%"><b>Confirm 
                                                                    Status</b></td>
                                                                  <td width="58%"> 
                                                                    <table width="35%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td> 
                                                                          <div align="center"><b><font size="4"><%=I_Crm.confirmStatusStr[projectOrderConfirmation.getStatus()]%></font></b></div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td height="5"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td bgcolor="#CCCCCC" height="5"></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="22%">&nbsp;</td>
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="58%"> 
                                                                    <table width="100%">
                                                                      <tr> 
                                                                        <td> 
                                                                          <%
												if(balanceTerm==0 && balance==0 && projectOrderConfirmation.getOID()>0)
												{
													if(projectOrderConfirmation.getStatus()==I_Crm.CONFIRM_STATUS_DRAFT)
													{
											%>
                                                                          <table width="35%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td width="50%"> 
                                                                                <div align="center"> 
                                                                                </div>
                                                                              </td>
                                                                              <td width="5%">&nbsp;</td>
                                                                              <td width="45%"> 
                                                                                <div align="center"> 
                                                                                </div>
                                                                              </td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="50%"> 
                                                                                <div align="center"><a href="javascript:cmdApproved('<%=I_Crm.PROJECT_STATUS_RUNNING%>')"><img src="../images/approve.gif" width="50" height="43" border="0"></a></div>
                                                                              </td>
                                                                              <td width="5%">&nbsp;</td>
                                                                              <td width="45%"> 
                                                                                <div align="center"><a href="javascript:cmdApproved('<%=I_Crm.PROJECT_STATUS_REJECT%>')"><img src="../images/revised.gif" width="50" height="41" border="0"></a></div>
                                                                              </td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="50%"> 
                                                                                <div align="center"><a href="javascript:cmdApproved('<%=I_Crm.PROJECT_STATUS_RUNNING%>')">Approve</a></div>
                                                                              </td>
                                                                              <td width="5%">&nbsp;</td>
                                                                              <td width="45%"> 
                                                                                <div align="center"><a href="javascript:cmdApproved('<%=I_Crm.PROJECT_STATUS_REJECT%>')">Rejected</a></div>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                          <%}}%>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Description 
                                                                    :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"> 
                                                                    <textarea name="textarea" rows="3" cols="120"><%=project.getDescription()%></textarea>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Naratif 
                                                                    1 :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"> 
                                                                    <textarea name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_NARATIF_1] %>" rows="3" cols="120"><%=projectOrderConfirmation.getNaratif1().length()>0?projectOrderConfirmation.getNaratif1():xNaratif_1%></textarea>
                                                                    <%= jspProjectOrderConfirmation.getErrorMsg(jspProjectOrderConfirmation.JSP_NARATIF_1) %> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Product 
                                                                    Detail</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="59%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawListProduct(listProjectProductDetail, project, company)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Naratif 
                                                                    2 :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"> 
                                                                    <textarea name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_NARATIF_2] %>" rows="3" cols="120"><%=projectOrderConfirmation.getNaratif2().length()>0?projectOrderConfirmation.getNaratif2():xNaratif_2%></textarea>
                                                                    <%= jspProjectOrderConfirmation.getErrorMsg(jspProjectOrderConfirmation.JSP_NARATIF_2) %> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Payment 
                                                                    Term</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="59%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawListTerm(listProjectTerm, project)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Naratif 
                                                                    3 :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"> 
                                                                    <textarea name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_NARATIF_3] %>" rows="3" cols="120"><%=projectOrderConfirmation.getNaratif3().length()>0?projectOrderConfirmation.getNaratif3():xNaratif_3%></textarea>
                                                                    <%= jspProjectOrderConfirmation.getErrorMsg(jspProjectOrderConfirmation.JSP_NARATIF_3) %> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="10"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"><b>Note 
                                                                    :</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4" height="25"> 
                                                                    <textarea name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_MEMO] %>" rows="3" cols="120"><%= projectOrderConfirmation.getMemo()%></textarea>
                                                                    <%= jspProjectOrderConfirmation.getErrorMsg(jspProjectOrderConfirmation.JSP_MEMO) %> 
                                                                    <input  type="hidden" name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_PROJECT_ID] %>"  value="<%= project.getOID()%>" class="formElemen">
                                                                    <input  type="hidden" name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_STATUS] %>"  value="<%= projectOrderConfirmation.getStatus()%>" class="formElemen">
                                                                    <input  type="hidden" name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_USER_ID] %>"  value="<%= projectOrderConfirmation.getUserId()%>" class="formElemen">
                                                                    <input  type="hidden" name="<%=jspProjectOrderConfirmation.colNames[jspProjectOrderConfirmation.JSP_DATE] %>"  value="<%= (projectOrderConfirmation.getDate()==null)?"":JSPFormater.formatDate(projectOrderConfirmation.getDate(),"dd/MM/yyyy")%>" class="formElemen">
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="4"><br>
                                                              <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspProjectOrderConfirmation.errorSize()>=0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr align="left" > 
                                                                  <td colspan="4" class="command" valign="top"> 
                                                                    <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProjectOrderConfirmation+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectOrderConfirmation+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectOrderConfirmation+"')";
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

			 jspLine.setSaveCaption("");
		     jspLine.setAddCaption("");
			 jspLine.setBackCaption("");
			 jspLine.setConfirmDelCaption("");
			 jspLine.setDeleteCaption("");
			 jspLine.setEditCaption("");
			 
		   %>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="5" valign="top"> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="5" height="10"></td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="5" valign="top"> 
                                                                    <div align="left"> 
                                                                      <table width="60%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                          <%										
										if(balanceTerm!=0 || balance!=0 || ttAmount==0){%>
                                                                          <td nowrap bgcolor="#FFFF00" height="20">&nbsp;<font color="#FF0000"><br>
                                                                            &nbsp;Command 
                                                                            button 
                                                                            is 
                                                                            disabled,<br>
                                                                            &nbsp;Please 
                                                                            complete 
                                                                            payment 
                                                                            term 
                                                                            data 
                                                                            before 
                                                                            proceeding 
                                                                            order 
                                                                            confirmation 
                                                                            form.<br>
                                                                            &nbsp;The 
                                                                            amount 
                                                                            should 
                                                                            be 
                                                                            balance 
                                                                            between 
                                                                            Product 
                                                                            Detail 
                                                                            - 
                                                                            Grand 
                                                                            Total 
                                                                            and 
                                                                            Payment 
                                                                            Term 
                                                                            Amount.&nbsp;<br>
                                                                            </font></td>
                                                                          <%}
										else{										
											if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE && projectOrderConfirmation.getStatus()==I_Crm.CONFIRM_STATUS_DRAFT){
										%>
                                                                          <td width="18%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/save2.gif',1)"><img src="../images/save.gif" name="new22" border="0" height="22"></a></td>
                                                                          <%	}										
											if(balanceTerm==0 && balance==0 && projectOrderConfirmation.getOID()>0)	{
										%>
                                                                          <td width="35%"><a href="javascript:cmdPrintConfirm()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/printconfirm2.gif',1)"><img src="../images/printconfirm.gif" name="new21" border="0"></a></td>
                                                                          <td width="20%"><a href="javascript:cmdPrintWork()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/printorder2.gif',1)"><img src="../images/printorder.gif" name="new2" border="0"></a></td>
                                                                          <%	}
										}%>
                                                                          <td width="0%">&nbsp;</td>
                                                                        </tr>
                                                                      </table>
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
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

