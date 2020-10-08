 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.clinic.master.*" %> 
<%@ page import = "com.project.clinic.transaction.*" %> 
<%@ page import = "com.project.clinic.*" %>
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

	public String drawList(Vector objectClass ,  long patientId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Tgl. Reg.","5%");
		ctrlist.addHeader("Nomor Pasien","5%");
		//ctrlist.addHeader("Counter","5%");
		ctrlist.addHeader("Nomor Identitas","5%");
		//ctrlist.addHeader("Id Type","5%");
		//ctrlist.addHeader("Title","5%");
		//ctrlist.addHeader("Gender","5%");
		ctrlist.addHeader("Nama","5%");
		ctrlist.addHeader("Tempat/Tgl. Lahir","5%");
		//ctrlist.addHeader("Birth Date","5%");
		ctrlist.addHeader("Alamat","5%");
		//ctrlist.addHeader("Country Id","5%");
		ctrlist.addHeader("Kode Post","5%");
		//ctrlist.addHeader("Fax","5%");
		//ctrlist.addHeader("Company Id","5%");
		ctrlist.addHeader("Email","5%");
		//ctrlist.addHeader("Employee Num","5%");
		//ctrlist.addHeader("Insurance Id","5%");
		//ctrlist.addHeader("Insurance No","5%");
		//ctrlist.addHeader("Insurance Relation Id","5%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Patient patient = (Patient)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(patientId == patient.getOID())
				 index = i;

			String str_dt_RegDate = ""; 
			try{
				Date dt_RegDate = patient.getRegDate();
				if(dt_RegDate==null){
					dt_RegDate = new Date();
				}

				str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_RegDate = ""; }

			rowx.add(str_dt_RegDate);

			rowx.add(patient.getCin());

			//rowx.add(String.valueOf(patient.getCounter()));

			rowx.add(patient.getIdType()+" # "+patient.getIdNumber());

			//rowx.add(patient.getIdType());

			//rowx.add(patient.getTitle());

			//rowx.add(String.valueOf(patient.getGender()));

			rowx.add(patient.getTitle()+" " +patient.getName());

			//rowx.add(patient.getBirthPlace()); 

			String str_dt_BirthDate = ""; 
			try{
				Date dt_BirthDate = patient.getBirthDate();
				if(dt_BirthDate==null){
					dt_BirthDate = new Date();
				}

				str_dt_BirthDate = JSPFormater.formatDate(dt_BirthDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_BirthDate = ""; }

			rowx.add(patient.getBirthPlace()+"/"+str_dt_BirthDate);

			rowx.add(patient.getAddress());

			//rowx.add(String.valueOf(patient.getCountryId()));

			rowx.add(patient.getZip());

			//rowx.add(patient.getFax());

			//rowx.add(String.valueOf(patient.getCompanyId()));

			rowx.add(patient.getEmail());

			//rowx.add(patient.getEmployeeNum());

			//rowx.add(String.valueOf(patient.getInsuranceId()));

			//rowx.add(patient.getInsuranceNo());

			//rowx.add(String.valueOf(patient.getInsuranceRelationId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(patient.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);   
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPatient = JSPRequestValue.requestLong(request, "hidden_patient_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = ""; 

CmdPatient ctrlPatient = new CmdPatient(request);
ctrlPatient.setLanguage(0);
JSPLine ctrLine = new JSPLine();
Vector listPatient = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPatient.action(iJSPCommand , oidPatient);
/* end switch*/
JspPatient jspPatient = ctrlPatient.getForm();

/*count list All Patient*/
int vectSize = DbPatient.getCount(whereClause);

Patient patient = ctrlPatient.getPatient();
msgString =  ctrlPatient.getMessage();

if(oidPatient==0){
	oidPatient = patient.getOID();
}

/*switch list Patient*/
//if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//start = DbPatient.generateFindStart(patient.getOID(),recordToGet, whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPatient.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPatient = DbPatient.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPatient.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPatient = DbPatient.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
                        
<script language="JavaScript">
<!--



function cmdAdd(){
	document.frmpatient.hidden_patient_id.value="0";
	document.frmpatient.command.value="<%=JSPCommand.ADD%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

function cmdAsk(oidPatient){
	document.frmpatient.hidden_patient_id.value=oidPatient;
	document.frmpatient.command.value="<%=JSPCommand.ASK%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

function cmdConfirmDelete(oidPatient){
	document.frmpatient.hidden_patient_id.value=oidPatient;
	document.frmpatient.command.value="<%=JSPCommand.DELETE%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}
function cmdSave(){
	document.frmpatient.command.value="<%=JSPCommand.SAVE%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
	}

function cmdEdit(oidPatient){
	document.frmpatient.hidden_patient_id.value=oidPatient;
	document.frmpatient.command.value="<%=JSPCommand.EDIT%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
	}

function cmdCancel(oidPatient){
	document.frmpatient.hidden_patient_id.value=oidPatient;
	document.frmpatient.command.value="<%=JSPCommand.EDIT%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

function cmdBack(){
	document.frmpatient.command.value="<%=JSPCommand.BACK%>";
	document.frmpatient.action="patienthome.jsp";
	document.frmpatient.submit();
	}

function cmdListFirst(){
	document.frmpatient.command.value="<%=JSPCommand.FIRST%>";
	document.frmpatient.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

function cmdListPrev(){
	document.frmpatient.command.value="<%=JSPCommand.PREV%>";
	document.frmpatient.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
	}

function cmdListNext(){
	document.frmpatient.command.value="<%=JSPCommand.NEXT%>";
	document.frmpatient.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

function cmdListLast(){
	document.frmpatient.command.value="<%=JSPCommand.LAST%>";
	document.frmpatient.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpatient.action="patient.jsp";
	document.frmpatient.submit();
}

//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif')">
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
                        <form name="frmpatient" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_patient_id" value="<%=oidPatient%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                              <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Reservasi 
                                                  </font><font class="tit1">&raquo; 
                                                  </font> <span class="lvl2">Pasien 
                                                  Baru </span></b></td>
                                                <td width="40%" height="23"> 
                                                  <%@ include file = "../main/userpreview.jsp" %>
                                                </td>
                                              </tr>
                                              <tr > 
                                                <td colspan="2" height="3" background="<%=approot%>/imagessl/line1.gif" ></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                        </tr>
                                        <%
							try{
								if (listPatient.size()>0){
							%>
                                        <%  } 
						  }catch(Exception exc){ 
						  }%>
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iJSPCommand!=JSPCommand.SAVE)
						{
					%>
                                        <%}%>
                                      </table> 
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="11%">*)= 
                                            Harap diisi</td>
                                          <td height="21" valign="middle" width="24%">&nbsp;</td>
                                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                                          <td height="21" colspan="2" width="56%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="5" valign="middle" colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Tgl. Register</td>
                                          <td height="21" width="24%"> 
                                            <input name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_REG_DATE]%>" value="<%=JSPFormater.formatDate((patient.getRegDate()==null) ? new Date() : patient.getRegDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpatient.<%=jspPatient.colNames[JspPatient.JSP_FIELD_REG_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_REG_DATE) %></td>
                                          <td height="21" width="9%">Nama Dokter</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <% Vector doctorid_value = new Vector(1,1);
						Vector doctorid_key = new Vector(1,1);
					 	String sel_doctorid = ""+patient.getDoctorId();
					        Vector docs = DbDoctor.list(0,0, "", "");
                                                doctorid_key.add("0");
						doctorid_value.add("");
						if(docs!=null && docs.size()>0){
							for(int i=0; i<docs.size(); i++){
								Doctor c = (Doctor)docs.get(i);
                                                                doctorid_key.add(""+c.getOID());
                                                                doctorid_value.add(""+c.getName());
                                                        }
                                                }
                                           
					   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_DOCTOR_ID],null, sel_doctorid, doctorid_key, doctorid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nomor Pasien</td>
                                          <td height="21" width="24%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_CIN] %>"  value="<%= patient.getCin() %>" readOnly class="readonly" size="35">
                                          </td>
                                          <td height="21" width="9%">Nama</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_NAME] %>"  value="<%= patient.getName() %>" class="formElemen" size="35">
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Jenis Identitas</td>
                                          <td height="21" width="24%"> 
                                            <% Vector idtype_value = new Vector(1,1);
											Vector idtype_key = new Vector(1,1);
											String sel_idtype = ""+patient.getIdType();
										   idtype_key.add("KTP");
										   idtype_value.add("KTP");
										   idtype_key.add("SIM");
										   idtype_value.add("SIM");
										   idtype_key.add("KITAS");
										   idtype_value.add("KITAS");
										   idtype_key.add("PASSPORT");
										   idtype_value.add("PASSPORT");
										   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_ID_TYPE],null, sel_idtype, idtype_key, idtype_value, "", "formElemen") %> </td>
                                          <td height="21" width="9%">Jenis Kelamin</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <% Vector gender_value = new Vector(1,1);
						Vector gender_key = new Vector(1,1);
					 	String sel_gender = ""+patient.getGender();
					   gender_key.add("0");
					   gender_value.add("Wanita");
					   gender_key.add("1");
					   gender_value.add("Pria");
					   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_GENDER],null, sel_gender, gender_key, gender_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nomor Identitas</td>
                                          <td height="21" width="24%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_ID_NUMBER] %>"  value="<%= patient.getIdNumber() %>" class="formElemen" size="35">
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_ID_NUMBER) %> </td>
                                          <td height="21" width="9%">Pekerjaan</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_OCCUPATION] %>"  value="<%= patient.getOccupation() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Tempat Lahir</td>
                                          <td height="21" width="24%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_BIRTH_PLACE] %>"  value="<%= patient.getBirthPlace() %>" class="formElemen" size="35">
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_BIRTH_PLACE) %> </td>
                                          <td height="21" width="9%">Nama Perusahaan</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <% Vector companyid_value = new Vector(1,1);
						Vector companyid_key = new Vector(1,1);
					 	String sel_companyid = ""+patient.getCompanyId();
						Vector comps = DbCompany.list(0,0, "", "");
                                                companyid_key.add("0");
						companyid_value.add("");
						if(comps!=null && comps.size()>0){
							for(int i=0; i<comps.size(); i++){
								Company c = (Company)comps.get(i);
								companyid_key.add(""+c.getOID());
								companyid_value.add(c.getName());
							}
						}
					    
					   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_COMPANY_ID],null, sel_companyid, companyid_key, companyid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Tanggal 
                                            Lahir</td>
                                          <td height="21" width="24%"> 
                                            <input name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_BIRTH_DATE] %>" value="<%=JSPFormater.formatDate((patient.getBirthDate() ==null) ? new Date() : patient.getBirthDate() , "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpatient.<%=jspPatient.colNames[JspPatient.JSP_FIELD_BIRTH_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                          <td height="21" width="9%">Nomor Pegawai</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_EMPLOYEE_NUM] %>"  value="<%= patient.getEmployeeNum() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Ikut Asuransi</td>
                                          <td height="21" width="24%"> 
                                            <% Vector insuranceid_value = new Vector(1,1);
						Vector insuranceid_key = new Vector(1,1);
					 	String sel_insuranceid = ""+patient.getInsuranceId();
						Vector insurs = DbInsurance.list(0,0, "", "");
                        insuranceid_key.add("0");
						insuranceid_value.add("");
						if(insurs!=null && insurs.size()>0){
							for(int i=0; i<insurs.size(); i++){
								Insurance c = (Insurance)insurs.get(i);
							    insuranceid_key.add(""+c.getOID());
							    insuranceid_value.add(""+c.getName());
					  		}
						}
					   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_INSURANCE_ID],null, sel_insuranceid, insuranceid_key, insuranceid_value, "", "formElemen") %> </td>
                                          <td height="21" width="9%">Nomor Asuransi</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_INSURANCE_NO] %>"  value="<%= patient.getInsuranceNo() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%" nowrap>Relasi 
                                            Dgn Asuransi</td>
                                          <td height="21" width="24%"> 
                                            <% Vector insurancerelationid_value = new Vector(1,1);
						Vector insurancerelationid_key = new Vector(1,1);
					 	String sel_insurancerelationid = ""+patient.getInsuranceRelationId();
					   
                                                Vector irels = DbInsuranceRelation.list(0,0, "", "");
                                                insurancerelationid_key.add("0");
						insurancerelationid_value.add(""); 
						if(irels!=null && irels.size()>0){
							for(int i=0; i<irels.size(); i++){
								InsuranceRelation c = (InsuranceRelation)irels.get(i);
                                                                insurancerelationid_key.add(""+c.getOID());
                                                                insurancerelationid_value.add(""+c.getName());
                                                        }
                                                }

					   %>
                                            <%= JSPCombo.draw(jspPatient.colNames[JspPatient.JSP_FIELD_INSURANCE_RELATION_ID],null, sel_insurancerelationid, insurancerelationid_key, insurancerelationid_value, "", "formElemen") %> </td>
                                          <td height="21" width="9%">&nbsp;</td>
                                          <td height="21" colspan="2" width="56%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="11%" valign="top">Alamat</td>
                                          <td height="21"> 
                                            <textarea name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_ADDRESS] %>" class="formElemen" cols="35" rows="2"><%= patient.getAddress() %></textarea>
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_ADDRESS) %> </td>
                                          <td height="21">Kode Post</td>
                                          <td height="21"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_ZIP] %>"  value="<%= patient.getZip() %>" class="formElemen" size="35">
                                          </td>
                                          <td height="21">&nbsp;</td>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Telephone</td>
                                          <td height="21" width="24%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_PHONE] %>"  value="<%= patient.getPhone() %>" class="formElemen" size="35">
                                          </td>
                                          <td height="21" width="9%">Email</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_EMAIL] %>"  value="<%= patient.getEmail() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Fax</td>
                                          <td height="21" width="24%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_FAX] %>"  value="<%= patient.getFax() %>" class="formElemen" size="35">
                                          </td>
                                          <td height="21" width="9%">Mobile/HP</td>
                                          <td height="21" colspan="2" width="56%"> 
                                            <input type="text" name="<%=jspPatient.colNames[JspPatient.JSP_FIELD_MOBILE] %>"  value="<%= patient.getMobile() %>" class="formElemen" size="35">
                                            * <%= jspPatient.getErrorMsg(JspPatient.JSP_FIELD_MOBILE) %> 
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="11%">&nbsp;</td>
                                          <td height="8" valign="middle" width="24%">&nbsp;</td>
                                          <td height="8" valign="middle" width="9%">&nbsp;</td>
                                          <td height="8" colspan="2" width="56%" valign="top">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
									//ctrLine.initDefault();
									ctrLine.initDefault(1, ""); //kebalik di jsp line 1=id, 0=eng
									ctrLine.setTableWidth("40%");
									String scomDel = "javascript:cmdAsk('"+oidPatient+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPatient+"')";
									String scancel = "javascript:cmdEdit('"+oidPatient+"')";
									ctrLine.setBackCaption("Kembali");
									ctrLine.setJSPCommandStyle("buttonlink");
										//ctrLine.setDeleteCaption("Delete");
										//ctrLine.setSaveCaption("Simpan");
										//ctrLine.setAddCaption("");

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
									%>
                                            <%//= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%>
											<%= ctrLine.draw(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="9%">&nbsp;</td>
                                          <td width="56%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                            </tr>
                          </table></td>
  </tr>
</table>
                          
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
