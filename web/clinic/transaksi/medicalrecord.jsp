 
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

	public String drawList(Vector objectClass ,  long medicalRecordId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Number","5%");
		ctrlist.addHeader("Counter","5%");
		ctrlist.addHeader("Patient Id","5%");
		ctrlist.addHeader("Reservation Id","5%");
		ctrlist.addHeader("Reg Date","5%");
		ctrlist.addHeader("Doctor Id","5%");
		ctrlist.addHeader("Weight","5%");
		ctrlist.addHeader("Height","5%");
		ctrlist.addHeader("Temperature","5%");
		ctrlist.addHeader("Respiration","5%");
		ctrlist.addHeader("Pulse","5%");
		ctrlist.addHeader("Blood Class","5%");
		ctrlist.addHeader("Bp Diatoplic","5%");
		ctrlist.addHeader("Bp Systolic","5%");
		ctrlist.addHeader("Complaints","5%");
		ctrlist.addHeader("Test Conducted","5%");
		ctrlist.addHeader("Results","5%");
		ctrlist.addHeader("Prescription","5%");
		ctrlist.addHeader("Diagnosis Id","5%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			MedicalRecord medicalRecord = (MedicalRecord)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(medicalRecordId == medicalRecord.getOID())
				 index = i;

			rowx.add(medicalRecord.getNumber());

			rowx.add(String.valueOf(medicalRecord.getCounter()));

			rowx.add(String.valueOf(medicalRecord.getPatientId()));

			rowx.add(String.valueOf(medicalRecord.getReservationId()));

			String str_dt_RegDate = ""; 
			try{
				Date dt_RegDate = medicalRecord.getRegDate();
				if(dt_RegDate==null){
					dt_RegDate = new Date();
				}

				str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_RegDate = ""; }

			rowx.add(str_dt_RegDate);

			rowx.add(String.valueOf(medicalRecord.getDoctorId()));

			rowx.add(String.valueOf(medicalRecord.getWeight()));

			rowx.add(String.valueOf(medicalRecord.getHeight()));

			rowx.add(String.valueOf(medicalRecord.getTemperature()));

			rowx.add(String.valueOf(medicalRecord.getRespiration()));

			rowx.add(String.valueOf(medicalRecord.getPulse()));

			rowx.add(medicalRecord.getBloodClass());

			rowx.add(medicalRecord.getBpDiatoplic());

			rowx.add(medicalRecord.getBpSystolic());

			rowx.add(medicalRecord.getComplaints());

			rowx.add(medicalRecord.getTestConducted());

			rowx.add(medicalRecord.getResults());

			rowx.add(medicalRecord.getPrescription());

			rowx.add(String.valueOf(medicalRecord.getDiagnosisId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(medicalRecord.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidMedicalRecord = JSPRequestValue.requestLong(request, "hidden_medical_record_id");
long srcDokter = JSPRequestValue.requestLong(request, "src_dokter");
long srcPatient = JSPRequestValue.requestLong(request, "src_patient"); 
String srcTanggalStr = JSPRequestValue.requestString(request, "src_tanggal");
Date srcTanggal = new Date();

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE; 
String whereClause = "";
String orderClause = "";

if(iJSPCommand==JSPCommand.SUBMIT){
	if(srcDokter!=0){
		whereClause = "dokter="+srcDokter;
	}
	
	if(srcTanggalStr!=null && srcTanggalStr.length()>0){
		srcTanggal = JSPFormater.formatDate(srcTanggalStr, "dd/MM/yyyy");
		if(whereClause!=null && whereClause.length()>0){
			whereClause = whereClause + " and ";
		}
		whereClause = whereClause + " reg_date='"+JSPFormater.formatDate(srcTanggal, "yyyy-MM-dd")+"'";
	}
	
	if(srcPatient!=0){
		if(whereClause!=null && whereClause.length()>0){
			whereClause = whereClause + " and ";
		}
		whereClause = whereClause + " patient_id="+srcPatient;
	}
}

CmdMedicalRecord ctrlMedicalRecord = new CmdMedicalRecord(request);
JSPLine ctrLine = new JSPLine();
Vector listMedicalRecord = new Vector(1,1);

/*switch statement */
iErrCode = ctrlMedicalRecord.action(iJSPCommand , oidMedicalRecord); 
/* end switch*/
JspMedicalRecord jspMedicalRecord = ctrlMedicalRecord.getForm();

/*count list All MedicalRecord*/
int vectSize = DbMedicalRecord.getCount(whereClause); 

MedicalRecord medicalRecord = ctrlMedicalRecord.getMedicalRecord();
msgString =  ctrlMedicalRecord.getMessage();

/*switch list MedicalRecord*/
//if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//start = DbMedicalRecord.generateFindStart(medicalRecord.getOID(),recordToGet, whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlMedicalRecord.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listMedicalRecord = DbMedicalRecord.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listMedicalRecord.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listMedicalRecord = DbMedicalRecord.list(start,recordToGet, whereClause , orderClause);
}

Vector docs = DbDoctor.list(0,0, "", "name");
Vector patients = DbPatient.list(0,0, "", "name");
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">



function cmdSearch(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdAdd(){
	document.frmmedicalrecord.hidden_medical_record_id.value="0";
	document.frmmedicalrecord.command.value="<%=JSPCommand.ADD%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdAsk(oidMedicalRecord){
	document.frmmedicalrecord.hidden_medical_record_id.value=oidMedicalRecord;
	document.frmmedicalrecord.command.value="<%=JSPCommand.ASK%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdConfirmDelete(oidMedicalRecord){
	document.frmmedicalrecord.hidden_medical_record_id.value=oidMedicalRecord;
	document.frmmedicalrecord.command.value="<%=JSPCommand.DELETE%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}
function cmdSave(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.SAVE%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
	}

function cmdEdit(oidMedicalRecord){
	document.frmmedicalrecord.hidden_medical_record_id.value=oidMedicalRecord;
	document.frmmedicalrecord.command.value="<%=JSPCommand.EDIT%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
	}

function cmdCancel(oidMedicalRecord){
	document.frmmedicalrecord.hidden_medical_record_id.value=oidMedicalRecord;
	document.frmmedicalrecord.command.value="<%=JSPCommand.EDIT%>";
	document.frmmedicalrecord.prev_command.value="<%=prevJSPCommand%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdBack(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.BACK%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
	}

function cmdListFirst(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.FIRST%>";
	document.frmmedicalrecord.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdListPrev(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.PREV%>";
	document.frmmedicalrecord.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
	}

function cmdListNext(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.NEXT%>";
	document.frmmedicalrecord.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
}

function cmdListLast(){
	document.frmmedicalrecord.command.value="<%=JSPCommand.LAST%>";
	document.frmmedicalrecord.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmmedicalrecord.action="medicalrecord.jsp";
	document.frmmedicalrecord.submit();
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
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmmedicalrecord" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_medical_record_id" value="<%=oidMedicalRecord%>">
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
                                                  </font> <span class="lvl2">Rekam 
                                                  Medik </span></b></td>
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
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="2%">Dokter</td>
                                                <td width="7%"> 
                                                  <select name="src_dokter">
                                                    <option></option>
                                                    <%if(docs!=null && docs.size()>0){
											for(int i=0; i<docs.size(); i++){
												Doctor dc = (Doctor)docs.get(i);
											%>
                                                    <option value="<%=dc.getOID()%>" <%if(srcDokter==dc.getOID()){%>selected<%}%>><%=dc.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td width="3%">Pasien</td>
                                                <td width="7%"> 
                                                  <select name="src_patient">
                                                    <option></option>
                                                    <%if(patients!=null && patients.size()>0){
											for(int i=0; i<patients.size(); i++){
												Patient dc = (Patient)patients.get(i);
											%>
                                                    <option value="<%=dc.getOID()%>" <%if(srcPatient==dc.getOID()){%>selected<%}%>><%=dc.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td width="3%">Tanggal</td>
                                                <td width="7%" nowrap> 
                                                  <input name="src_tanggal" value="<%=JSPFormater.formatDate((srcTanggal==null) ? new Date() : srcTanggal, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreservation.src_tanggal);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                <td width="71%"> 
                                                  <input type="button" name="Button" value="Cari" onClick="javascript:cmdSearch()">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                        </tr>
                                        <%
							try{
								if (listMedicalRecord.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listMedicalRecord,oidMedicalRecord)%> </td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                            <% ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../imagessl/new2.gif',1)"><img src="../imagessl/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspMedicalRecord.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="90%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="90%" class="comment">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="10%">Nomor RM</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_NUMBER] %>"  value="<%= medicalRecord.getNumber() %>" class="formElemen">
                                        <tr align="left"> 
                                          <td height="21" width="10%">Pasien</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <select name="jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_PATIENT_ID]">
                                              <option value="0"></option>
                                              <%if(patients!=null && patients.size()>0){
											for(int i=0; i<patients.size(); i++){
												Patient dc = (Patient)patients.get(i);
											%>
                                              <option value="<%=dc.getOID()%>" <%if(medicalRecord.getPatientId()==dc.getOID()){%>selected<%}%>><%=dc.getName()%></option>
                                              <%}}%>
                                            </select>
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_PATIENT_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Tanggal</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_REG_DATE]%>" value="<%=JSPFormater.formatDate((medicalRecord.getRegDate()==null) ? new Date() : medicalRecord.getRegDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmedicalrecord.<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_REG_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Dokter</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <select name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_DOCTOR_ID]%>">
                                              <option></option>
                                              <%if(docs!=null && docs.size()>0){
											for(int i=0; i<docs.size(); i++){
												Doctor dc = (Doctor)docs.get(i);
											%>
                                              <option value="<%=dc.getOID()%>" <%if(medicalRecord.getDoctorId()==dc.getOID()){%>selected<%}%>><%=dc.getName()%></option>
                                              <%}}%>
                                            </select>
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_DOCTOR_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Berat Badan</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_WEIGHT] %>"  value="<%= medicalRecord.getWeight() %>" class="formElemen" size="10">
                                            Kg * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_WEIGHT) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Tinggi Badan</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_HEIGHT] %>"  value="<%= medicalRecord.getHeight() %>" class="formElemen" size="10">
                                            cm * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_HEIGHT) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Suhu Tubuh</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_TEMPERATURE] %>"  value="<%= medicalRecord.getTemperature() %>" class="formElemen" size="10">
                                            C * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_TEMPERATURE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Pernapasan</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_RESPIRATION] %>"  value="<%= medicalRecord.getRespiration() %>" class="formElemen" size="10">
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_RESPIRATION) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Denyut Jantung</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_PULSE] %>"  value="<%= medicalRecord.getPulse() %>" class="formElemen" size="10">
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_PULSE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Kelas Darah</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_BLOOD_CLASS] %>"  value="<%= medicalRecord.getBloodClass() %>" class="formElemen" size="10">
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_BLOOD_CLASS) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Bp Diatoplic</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_BP_DIATOPLIC] %>"  value="<%= medicalRecord.getBpDiatoplic() %>" class="formElemen" size="10">
                                        <tr align="left"> 
                                          <td height="21" width="10%">Bp Systolic</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <input type="text" name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_BP_SYSTOLIC] %>"  value="<%= medicalRecord.getBpSystolic() %>" class="formElemen" size="10">
                                        <tr align="left"> 
                                          <td height="21" width="10%">Keluahan</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <textarea name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_COMPLAINTS] %>" class="formElemen" cols="45" rows="3"><%= medicalRecord.getComplaints() %></textarea>
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_COMPLAINTS) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Test Yg 
                                            Dilakukan </td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <textarea name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_TEST_CONDUCTED] %>" class="formElemen" cols="45" rows="3"><%= medicalRecord.getTestConducted() %></textarea>
                                        <tr align="left"> 
                                          <td height="21" width="10%">Hasil</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <textarea name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_RESULTS] %>" class="formElemen" cols="45" rows="3"><%= medicalRecord.getResults() %></textarea>
                                        <tr align="left"> 
                                          <td height="21" width="10%">Resep Obat</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <textarea name="<%=jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_PRESCRIPTION] %>" class="formElemen" cols="45" rows="3"><%= medicalRecord.getPrescription() %></textarea>
                                            * <%= jspMedicalRecord.getErrorMsg(JspMedicalRecord.JSP_FIELD_PRESCRIPTION) %> 
                                        <tr align="left"> 
                                          <td height="21" width="10%">Diagnosis</td>
                                          <td height="21" colspan="2" width="90%"> 
                                            <% Vector diagnosisid_value = new Vector(1,1);
						Vector diagnosisid_key = new Vector(1,1);
					 	String sel_diagnosisid = ""+medicalRecord.getDiagnosisId();
					   diagnosisid_key.add("---select---");
					   diagnosisid_value.add("");
					   %>
                                            <%= JSPCombo.draw(jspMedicalRecord.colNames[JspMedicalRecord.JSP_FIELD_DIAGNOSIS_ID],null, sel_diagnosisid, diagnosisid_key, diagnosisid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="10%">&nbsp;</td>
                                          <td height="8" colspan="2" width="90%" valign="top">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidMedicalRecord+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidMedicalRecord+"')";
									String scancel = "javascript:cmdEdit('"+oidMedicalRecord+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
                                            <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="90%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" valign="top"> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                      </table>
                                <%}%>
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
