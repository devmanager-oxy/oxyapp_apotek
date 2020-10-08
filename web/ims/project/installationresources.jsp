<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%//@ page import = "com.project.ims.production.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.ccs.posmaster.Uom" %>
<%@ page import = "com.project.ccs.posmaster.DbUom" %>
<%@ page import = "com.project.ccs.posmaster.CmdUom" %>
<%@ page import = "com.project.ccs.posmaster.JspUom" %>
<%@ page import = "com.project.payroll.*" %>

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
	boolean masterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_RESOURCES);
	boolean masterPrivView = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_RESOURCES, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT, AppMenu.M2_CRM_PRJ_INSTALLATION_RESOURCES, AppMenu.PRIV_UPDATE);

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

	//Approval 4 Spareparts
	boolean approvalPriv4 = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_SPAREPARTS_APPROVED);
	boolean approvalPrivView4 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_SPAREPARTS_APPROVED, AppMenu.PRIV_VIEW);
	boolean approvalPrivUpdate4 = true; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_PROJECT_APPROVAL, AppMenu.M2_CRM_PRJ_INSTALLATION_SPAREPARTS_APPROVED, AppMenu.PRIV_UPDATE);
	
%>
<!-- Jsp Block -->
<%!
	public String drawList(int iCommand, JspProjectInstallationSpareparts frmObject, ProjectInstallationSpareparts objEntity, Vector objectClass,  long projectInstallationSparepartsId, ProjectInstallation objEntity1, long companyId, long userId, Project project, ProjectInstallationResources projectInstallationResources)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No.","5%");
		jsplist.addHeader("Spareparts","30%");
		jsplist.addHeader("Qty","8%");
		jsplist.addHeader("UOM","8%");
		jsplist.addHeader("Description","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		Vector vItemMaster = DbItemMaster.list(0,0, "type<>"+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+" and type<>"+I_Ccs.TYPE_CATEGORY_CIVIL_WORK, "");
		Vector ItemMaster_value = new Vector(1,1);
		Vector ItemMaster_key = new Vector(1,1);
		if(vItemMaster!=null && vItemMaster.size()>0)
		{
			for(int i=0; i<vItemMaster.size(); i++)
			{
				ItemMaster c = (ItemMaster)vItemMaster.get(i);
				ItemMaster_key.add(c.getName().trim());
				ItemMaster_value.add(""+c.getOID());
			}
		}

		for (int i = 0; i < objectClass.size(); i++) 
		{
			ProjectInstallationSpareparts objProjectInstallationSpareparts = (ProjectInstallationSpareparts)objectClass.get(i);
			
			rowx = new Vector();
			if(projectInstallationSparepartsId == objProjectInstallationSpareparts.getOID())
				index = i;

			if(index == i && ((iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK) || (frmObject.getErrors().size() > 0 && objProjectInstallationSpareparts.getOID()!=0))){
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+objProjectInstallationSpareparts.getSquence()+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));
				//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ItemMaster_value , ItemMaster_key, "onChange=\"javascript:checkCategory()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ItemMaster_value , ItemMaster_key, "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));
				rowx.add("<input type=\"text\" style=\"text-align:right\" onClick=\"this.select()\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objProjectInstallationSpareparts.getQty()+"\" class=\"formElemen\" size=\"15\" >"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
				
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(objEntity.getProjectProductDetailId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}
				
				rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>"); 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_LOCATION_DETAIL] +"\" value=\""+objProjectInstallationSpareparts.getLocationDetail()+"\" class=\"formElemen\" size=\"40\">"+ frmObject.getErrorMsg(frmObject.JSP_LOCATION_DETAIL)+

				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objProjectInstallationSpareparts.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID) +
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objProjectInstallationSpareparts.getInstallationId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID) +
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(objProjectInstallationSpareparts.getDate(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));


			}
			else
			{
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationSpareparts.getSquence())+"</div>");
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(objProjectInstallationSpareparts.getProjectProductDetailId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}
				if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || objEntity1.getStatus()==I_Crm.INSTALL_STATUS_FINISH || projectInstallationResources.getApproval1()>0){
					rowx.add(colCombo2.getName());
				}else{
					rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objProjectInstallationSpareparts.getOID())+"')\">"+colCombo2.getName()+"</a>");
				}
				rowx.add("<div align=\"center\">"+String.valueOf(objProjectInstallationSpareparts.getQty())+"</div>");
				rowx.add("<div align=\"center\">"+String.valueOf(uom.getUnit())+"</div>");
				rowx.add(objProjectInstallationSpareparts.getLocationDetail());
			}
			lstData.add(rowx);
		}

		rowx = new Vector();

		if(projectInstallationResources.getApproval1()==0){
			if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0 && objEntity.getOID()==0)){
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_SQUENCE] +"\" value=\""+DbProjectInstallationSpareparts.getMaxSquence(objEntity1.getOID())+"\" class=\"formElemen\" size=\"5\">"+ frmObject.getErrorMsg(frmObject.JSP_SQUENCE));		
				//rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ItemMaster_value , ItemMaster_key, "onChange=\"javascript:checkCategory()\"", "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));
				rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID],null, ""+objEntity.getProjectProductDetailId(), ItemMaster_value , ItemMaster_key, "formElemen")+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_PRODUCT_DETAIL_ID));
				rowx.add("<input type=\"text\" style=\"text-align:right\" onClick=\"this.select()\" name=\""+frmObject.colNames[frmObject.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\" size=\"15\" >"+ frmObject.getErrorMsg(frmObject.JSP_QTY));
				
				ItemMaster colCombo2  = new ItemMaster();
				try{
					colCombo2 = DbItemMaster.fetchExc(objEntity.getProjectProductDetailId());
				}catch(Exception e) {
					System.out.println(e);
				}
				Uom uom = new Uom();
				try{
					uom = DbUom.fetchExc(colCombo2.getUomSalesId());
				}catch(Exception e){
					System.out.println(e);
				}
				
				rowx.add("<input style=\"text-align:center\" type=\"text\" name=\"uom\" value=\""+uom.getUnit()+"\" class=\"readonly\" size=\"5\" readOnly>");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_LOCATION_DETAIL] +"\" value=\""+objEntity.getLocationDetail()+"\" class=\"formElemen\" size=\"40\">"+ frmObject.getErrorMsg(frmObject.JSP_LOCATION_DETAIL)+
	
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_PROJECT_ID] +"\" value=\""+objEntity1.getProjectId()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_PROJECT_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_INSTALLATION_ID] +"\" value=\""+objEntity1.getOID()+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_INSTALLATION_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_COMPANY_ID] +"\" value=\""+companyId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_COMPANY_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_USER_ID] +"\" value=\""+userId+"\" class=\"formElemen\" size=\"20\">"+ frmObject.getErrorMsg(frmObject.JSP_USER_ID)+
				"<input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_DATE] +"\" value=\""+JSPFormater.formatDate(new Date(), "dd/MM/yyyy")+"\" class=\"formElemen\" size=\"20\" readonly>"+ frmObject.getErrorMsg(frmObject.JSP_DATE));
			}
		}
		
		lstData.add(rowx);

		return jsplist.draw(index);
	}
%>
<%
	long installationId = JSPRequestValue.requestLong(request, "oid");
	//long oidProposal = 0;
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
	long oidProjectInstallationResources = JSPRequestValue.requestLong(request, "hidden_projectinstallationresources");
	
	
		
	//out.println("iCommand : "+iCommand);

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "installation_id="+installationId;
	String orderClause = "";

	CmdProjectInstallationResources cmdProjectInstallationResources = new CmdProjectInstallationResources(request);
	JSPLine jspLine = new JSPLine();
	Vector listProjectInstallationResources = new Vector(1,1);


	// switch statement
	if(iCommand!=JSPCommand.DELETE){
		//iErrCode = cmdProjectInstallationResources.action(iCommand , oidProjectInstallationResources, systemCompanyId);
		iErrCode = cmdProjectInstallationResources.action(iCommand , oidProjectInstallationResources);
	}

	// end switch
	JspProjectInstallationResources jspProjectInstallationResources = cmdProjectInstallationResources.getForm();

	// count list All ProjectInstallationResources
	int vectSize = DbProjectInstallationResources.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspProjectInstallationResources.getErrors());

	ProjectInstallationResources projectInstallationResources = cmdProjectInstallationResources.getProjectInstallationResources();
	msgString =  cmdProjectInstallationResources.getMessage();
	//out.println(msgString);

	// get record to display
	listProjectInstallationResources = DbProjectInstallationResources.list(start,recordToGet, whereClause , orderClause);
	if (listProjectInstallationResources.size()>0)
	{
		projectInstallationResources = (ProjectInstallationResources)listProjectInstallationResources.get(0);
	}
	
	oidProjectInstallationResources = projectInstallationResources.getOID();

	int finish = JSPRequestValue.requestInt(request, "finish");
	if(finish>0){
		try{
			projInstallation.setStatus(I_Crm.INSTALL_STATUS_FINISH);
			DbProjectInstallation.updateExc(projInstallation);
		}catch(Exception e){
			System.out.println(e);
		}	
	}

	//add Spareparts	
	long oidProjectInstallationSpareparts = JSPRequestValue.requestLong(request, "hidden_projectinstallationspareparts");
	String msgStringSpareparts = "";
	int iErrCodeSpareparts = JSPMessage.NONE;

	CmdProjectInstallationSpareparts cmdProjectInstallationSpareparts = new CmdProjectInstallationSpareparts(request);
	Vector listProjectInstallationSpareparts = new Vector(1,1);
	//iErrCodeSpareparts = cmdProjectInstallationSpareparts.action(iCommand , oidProjectInstallationSpareparts, systemCompanyId);
	iErrCodeSpareparts = cmdProjectInstallationSpareparts.action(iCommand , oidProjectInstallationSpareparts);
	
	JspProjectInstallationSpareparts jspProjectInstallationSpareparts = cmdProjectInstallationSpareparts.getForm();
	ProjectInstallationSpareparts projectInstallationSpareparts = cmdProjectInstallationSpareparts.getProjectInstallationSpareparts();
	
	msgStringSpareparts =  cmdProjectInstallationSpareparts.getMessage();
	
	
	out.println("product_id ="+projectInstallationSpareparts.getProjectProductDetailId());
	
	
	
	// get record to display
	listProjectInstallationSpareparts = DbProjectInstallationSpareparts.list(0,0, whereClause , "squence");
	
	if (iCommand==JSPCommand.SUBMIT){
		/*if(oidProjectInstallationSpareparts>0){
			iCommand = JSPCommand.EDIT;
		}else{
			iCommand = JSPCommand.ADD;
		}
		*/
	}

	//Approved	
	int approvedStatus = JSPRequestValue.requestInt(request, "installStatus");
	//out.println("app = "+approvedStatus);
	if(approvedStatus>0 && iCommand==JSPCommand.NONE){
		long oidUpdate = 0;
		try{			
			if(approvedStatus==I_Crm.SPAREPARTS_STATUS_APPROVED){
				if(approvalPrivUpdate4){
					projectInstallationResources.setApproval1(appSessUser.getUserOID());
					projectInstallationResources.setDateApproval1(new Date());
				}
			}
			oidUpdate = DbProjectInstallationResources.updateExc(projectInstallationResources);
		}catch(Exception e){
			System.out.println(e);
		}
	}

	if(project.getStatus()==I_Crm.PROJECT_STATUS_CLOSE || projInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH){
	}else{
		if(iCommand==JSPCommand.NONE)
		{
			iCommand = JSPCommand.ADD;
			projectInstallationSpareparts = new ProjectInstallationSpareparts();
			oidProjectInstallationSpareparts = 0;
		}else if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCodeSpareparts==0){
			iCommand = JSPCommand.ADD;
			projectInstallationSpareparts = new ProjectInstallationSpareparts();
			oidProjectInstallationSpareparts = 0;
		}else if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0 && iErrCodeSpareparts==0)
		{
			iCommand = JSPCommand.ADD;
			projectInstallationSpareparts = new ProjectInstallationSpareparts();
			oidProjectInstallationSpareparts = 0;
		}
	}
	
	//out.println("iCommand : "+iCommand);

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

	function cmdApproved(){
		<%if(approvalPrivUpdate4){%>
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
		<%}%>
	}

	function cmdInstallFinish(){
		<%if(approvalPrivUpdate3){%>
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationresources.finish.value="<%=I_Crm.INSTALL_STATUS_FINISH%>";
		document.frmprojectinstallationresources.submit();
		<%}%>
	}
	
	function checkCategory(){
		//document.frmprojectinstallationresources.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.LOAD%>";
		document.frmprojectinstallationresources.submit();	
	}

	function cmdBackToList(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.NONE%>";
		document.frmprojectinstallationresources.action="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid=<%=projectId%>";
		document.frmprojectinstallationresources.submit();
		}

	function cmdAdd(){
		document.frmprojectinstallationresources.hidden_projectinstallationresources.value="0";
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdAsk(oidProjectInstallationResources){
		document.frmprojectinstallationresources.hidden_projectinstallationresources.value=oidProjectInstallationResources;
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdDelete(oidProjectInstallationResources){
		document.frmprojectinstallationresources.hidden_projectinstallationresources.value=oidProjectInstallationResources;
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.ASK%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdConfirmDelete(oidProjectInstallationResources){
		document.frmprojectinstallationresources.hidden_projectinstallationresources.value=oidProjectInstallationResources;
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.DELETE%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}


	function cmdSave(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.SAVE%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
		}

	function cmdEdit(oidProjectInstallationResources){
		<%if(masterPrivUpdate){%>
		document.frmprojectinstallationresources.hidden_projectinstallationspareparts.value=oidProjectInstallationResources;
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
		<%}%>
		}

	function cmdCancel(oidProjectInstallationResources){
		document.frmprojectinstallationresources.hidden_projectinstallationresources.value=oidProjectInstallationResources;
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.EDIT%>";
		document.frmprojectinstallationresources.prev_command.value="<%=prevCommand%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdBack(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.BACK%>";
		//document.frmprojectinstallationresources.hidden_projectinstallationresources.value="0";
		//document.frmprojectinstallationresources.command.value="<%=JSPCommand.ADD%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
		}

	function cmdListFirst(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationresources.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdListPrev(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationresources.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
		}

	function cmdListNext(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationresources.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
	}

	function cmdListLast(){
		document.frmprojectinstallationresources.command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationresources.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmprojectinstallationresources.action="installationresources.jsp?menu_idx=<%=menuIdx%>&oid=<%=installationId%>";
		document.frmprojectinstallationresources.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif','../images/process2.gif')">
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
                                                <form name="frmprojectinstallationresources" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_projectinstallationresources" value="<%=oidProjectInstallationResources%>">
                                                  <input type="hidden" name="hidden_projectinstallationspareparts" value="<%=oidProjectInstallationSpareparts%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="finish" value="">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"> 
                                                              <span class="lvl2"> 
                                                              </span><span class="lvl2">Installation 
                                                              Detail </span><span class="lvl2"><br>
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
                                                                  <td><b>Budget 
                                                                    Status</b></td>
                                                                  <td><b><%=I_Crm.installBudgetStatusStr[projInstallation.getBudgetStatus()]%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    <%if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_IN_PROGRESS){%>
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
                                                                        <td class="tabin" nowrap> 
                                                                          <a href="installationbudget.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Budget 
                                                                          Proposed</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <td class="tabin" nowrap><a href="installationproduct.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Product</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <td nowrap class="tabheader"></td>
                                                                        <td class="tab" nowrap><font color="#000000">Resources 
                                                                          & Spareparts</font></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%if(projInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH){%>
                                                                        <td class="tabin" nowrap><a href="installationtravel.jsp?menu_idx=<%=menuIdx%>&oid=<%=projInstallation.getOID()%>" class="tablink">Travel 
                                                                          Report</a></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                                        </td>
                                                                        <%}%>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="8" colspan="4"></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="3"><br>
                                                              <%//if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspProjectInstallationResources.errorSize()>=0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Description</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <textarea name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_DESCRIPTION] %>" rows="4" cols="120"><%= projectInstallationResources.getDescription() %></textarea>
                                                                    <%= jspProjectInstallationResources.getErrorMsg(jspProjectInstallationResources.JSP_DESCRIPTION) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Equipment</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <textarea name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_EQUIPMENT] %>" rows="4" cols="120"><%= projectInstallationResources.getEquipment() %></textarea>
                                                                    <%= jspProjectInstallationResources.getErrorMsg(jspProjectInstallationResources.JSP_EQUIPMENT) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Num 
                                                                    Of Days</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <input size="30" style="text-align:right" align="right" type="text" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_NUM_OF_DAY] %>"  value="<%= projectInstallationResources.getNumOfDay() %>" class="formElemen">
                                                                    <%= jspProjectInstallationResources.getErrorMsg(jspProjectInstallationResources.JSP_NUM_OF_DAY) %> 
                                                                <tr align="left"> 
                                                                  <td height="21" width="9%">&nbsp;Num 
                                                                    Of People</td>
                                                                  <td height="21" width="1%">&nbsp; 
                                                                  <td height="21" colspan="2" width="90%"> 
                                                                    <input size="30" style="text-align:right" type="text" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_NUM_OF_PEOPLE] %>"  value="<%= projectInstallationResources.getNumOfPeople() %>" class="formElemen">
                                                                    <%= jspProjectInstallationResources.getErrorMsg(jspProjectInstallationResources.JSP_NUM_OF_PEOPLE) %> 
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_PROJECT_ID] %>"  value="<%= projectId %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_INSTALLATION_ID] %>"  value="<%= installationId %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_COMPANY_ID] %>"  value="<%= systemCompanyId %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_USER_ID] %>"  value="<%= appSessUser.getUserOID() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_DATE] %>"  value="<%= JSPFormater.formatDate(projectInstallationResources.getDate(), "dd/MM/yyyy") %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_APPROVAL_1] %>"  value="<%= projectInstallationResources.getApproval1() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspProjectInstallationResources.colNames[jspProjectInstallationResources.JSP_DATE_APPROVAL_1] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen">
                                                                <tr align="left"> 
                                                                  <td height="8" valign="middle" colspan="4">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <%if(listProjectInstallationSpareparts.size()==0 && projInstallation.getStatus()==I_Crm.INSTALL_STATUS_FINISH){}else{%>
                                                                <tr align="left"> 
                                                                  <td height="20" valign="middle" colspan="4"><b>Spareparts 
                                                                    Detail</b></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="60%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td class="boxed1"><%= drawList(iCommand,jspProjectInstallationSpareparts, projectInstallationSpareparts,listProjectInstallationSpareparts,oidProjectInstallationSpareparts,  projInstallation, systemCompanyId, appSessUser.getUserOID(), project, projectInstallationResources)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr align="left"> 
                                                                  <td height="4" valign="middle" colspan="4">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                                <tr align="left" > 
                                                                  <td colspan="4" class="command" valign="top"> 
                                                                    <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidProjectInstallationResources+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectInstallationResources+"')";
			 String scancel = "javascript:cmdEdit('"+oidProjectInstallationResources+"')";
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
                                                                    <%if(projectInstallationResources.getApproval1()==0){%>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCodeSpareparts, msgStringSpareparts)%> 
                                                                    <%}else{%>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                    <%}%>
                                                                  </td>
                                                                </tr>
                                                                <%if(listProjectInstallationSpareparts.size()>0){%>
                                                                <%if(projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_FINISH){%>
                                                                <%if(projectInstallationResources.getApproval1()==0){%>
                                                                <%if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                <tr align="left" > 
                                                                  <td colspan="4" valign="top"> 
                                                                    <table width="100%">
                                                                      <tr> 
                                                                        <td> 
                                                                          <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                            <tr> 
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.SPAREPARTS_STATUS_APPROVED%>" checked>
                                                                                <%=I_Crm.sparepartsStatusStr[I_Crm.SPAREPARTS_STATUS_APPROVED]%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="150"> 
                                                                                <input name="installStatus" type="radio" value="<%=I_Crm.SPAREPARTS_STATUS_CANCELLED%>">
                                                                                <%=I_Crm.sparepartsStatusStr[I_Crm.SPAREPARTS_STATUS_CANCELLED]%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                              <td width="150" nowrap><a href="javascript:cmdApproved()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new29','','../images/process2.gif',1)"><img src="../images/process.gif" name="new29" border="0"></a></td>
                                                                            </tr>
                                                                          </table>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr align="left"> 
                                                                  <td height="4" valign="middle" colspan="4">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <%}}}}%>
                                                                <tr align="left" > 
                                                                  <td colspan="4" class="command" valign="top"> 
                                                                    <div align="left"> 
                                                                      <table width="60%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                          <td width="98%"> 
                                                                            <%	if(project.getStatus()!=I_Crm.PROJECT_STATUS_CLOSE){%>
                                                                            <%if(projInstallation.getStatus()!=I_Crm.INSTALL_STATUS_FINISH){%>
                                                                            <%if(projectInstallationResources.getApproval1()==0){%>
                                                                            <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/save2.gif',1)"><img src="../images/save.gif" name="new22" border="0" height="22"></a> 
                                                                            &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                            <%}%>
                                                                            <%if(projectInstallationResources.getApproval1()==0 && oidProjectInstallationSpareparts>0){%>
                                                                            <a href="javascript:cmdConfirmDelete()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="new23" border="0" height="22"></a> 
                                                                            &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                            <%	}	}	}%>
                                                                            <a href="javascript:cmdBackToList()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/back2.gif',1)"><img src="../images/back.gif" name="new22" width="51" height="22" border="0"></a> 
                                                                          </td>
                                                                        </tr>
                                                                      </table>
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%if(listProjectInstallationSpareparts.size()>0){%>
                                                                <tr align="left"> 
                                                                  <td height="8" valign="middle" colspan="4">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="4" valign="top"> 
                                                                    <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                                                      <tr> 
                                                                        <td width="33%" height="20" class="tablecell1">&nbsp;&nbsp;<b><u>Approval 
                                                                          History</u></b></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                          <div align="center"><b><u>User</u></b></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                          <div align="center"><b><u>Date</u></b></div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.sparepartsStatusStr[I_Crm.SPAREPARTS_STATUS_DRAFT]%> 
                                                                          by</i></td>
                                                                        <td width="34%" class="tablecell"> 
                                                                          <div align="center"> 
                                                                            <i> 
                                                                            <%
												User u = new User();
												try{
													u = DbUser.fetch(projectInstallationResources.getUserId());
												}
												catch(Exception e){
												}
											  %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell"> 
                                                                          <%if(projectInstallationResources.getUserId()!=0){%>
                                                                          <div align="center"><i><%=JSPFormater.formatDate(projectInstallationResources.getDate(), "dd MMMM yy")%></i></div>
                                                                          <%}%>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="33%" class="tablecell">&nbsp;&nbsp;<i><%=I_Crm.sparepartsStatusStr[I_Crm.SPAREPARTS_STATUS_APPROVED]%> 
                                                                          by</i></td>
                                                                        <td width="34%" class="tablecell"> 
                                                                          <div align="center"> 
                                                                            <i> 
                                                                            <%
												u = new User();
												try{
													u = DbUser.fetch(projectInstallationResources.getApproval1());
												}
												catch(Exception e){
												}
											  %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell"> 
                                                                          <%if(projectInstallationResources.getApproval1()!=0){%>
                                                                          <div align="center"><i><%=JSPFormater.formatDate(projectInstallationResources.getDateApproval1(), "dd MMMM yy")%></i></div>
                                                                          <%}%>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                              </table>
                                                              <%//}%>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
						<%
							if ((iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT) && projectInstallationSpareparts.getProjectProductDetailId()==0 && projectInstallationResources.getApproval1()==0) 
							{
						%>
								//checkCategory();
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

