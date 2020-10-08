 
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

	public String drawList(Vector objectClass ,  long reservationId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("70%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Reg Untuk Tanggal","14%");
		ctrlist.addHeader("Pasien","14%");
		ctrlist.addHeader("Nomor Urut","14%");
		ctrlist.addHeader("Dokter","14%");
		ctrlist.addHeader("Perkiraan Jam","14%");
		ctrlist.addHeader("Status","14%");
		//ctrlist.addHeader("Admin","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Reservation reservation = (Reservation)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(reservationId == reservation.getOID())
				 index = i;

			String str_dt_RegDate = ""; 
			try{
				Date dt_RegDate = reservation.getRegDate();
				if(dt_RegDate==null){
					dt_RegDate = new Date();
				}

				str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_RegDate = ""; }

			rowx.add(str_dt_RegDate);
			
			Patient p = new Patient();
			try{
				p = DbPatient.fetchExc(reservation.getPatientId());
			}
			catch(Exception e){
			}

			rowx.add(p.getName());

			rowx.add(String.valueOf(reservation.getQueueNumber()));
			
			Doctor d = new Doctor();
			try{
				d = DbDoctor.fetchExc(reservation.getDoctorId());
			}
			catch(Exception e){
			}

			rowx.add(d.getName());

			String str_dt_QueueTime = ""; 
			try{
				Date dt_QueueTime = reservation.getQueueTime();
				if(dt_QueueTime==null){
					dt_QueueTime = new Date();
				}

				str_dt_QueueTime = JSPFormater.formatDate(dt_QueueTime, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_QueueTime = ""; }

			rowx.add(JSPFormater.formatDate(reservation.getQueueTime(), "hh:mm")); 

			rowx.add((reservation.getStatus()==0) ? "Baru" : ((reservation.getStatus()==1) ? "Register"  : "Selesai"));

			//rowx.add(String.valueOf(reservation.getAdminId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(reservation.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidReservation = JSPRequestValue.requestLong(request, "hidden_reservation_id");
long srcDokter = JSPRequestValue.requestLong(request, "src_dokter");

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
	
	
}

//ut.println(whereClause);



CmdReservation ctrlReservation = new CmdReservation(request);
JSPLine ctrLine = new JSPLine();
Vector listReservation = new Vector(1,1);

/*switch statement */
iErrCode = ctrlReservation.action(iJSPCommand , oidReservation);
/* end switch*/
JspReservation jspReservation = ctrlReservation.getForm();

/*count list All Reservation*/
int vectSize = DbReservation.getCount(whereClause);

Reservation reservation = ctrlReservation.getReservation();
msgString =  ctrlReservation.getMessage();

/*switch list Reservation*/
//if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//start = DbReservation.generateFindStart(reservation.getOID(),recordToGet, whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlReservation.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listReservation = DbReservation.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listReservation.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listReservation = DbReservation.list(start,recordToGet, whereClause , orderClause);
}

Vector docs = DbDoctor.list(0,0, "", "");

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
	document.frmreservation.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmreservation.action="reservationupdate.jsp";
	document.frmreservation.submit();
}

function cmdAdd(){
	document.frmreservation.hidden_reservation_id.value="0";
	document.frmreservation.command.value="<%=JSPCommand.ADD%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}

function cmdAsk(oidReservation){
	document.frmreservation.hidden_reservation_id.value=oidReservation;
	document.frmreservation.command.value="<%=JSPCommand.ASK%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}

function cmdConfirmDelete(oidReservation){
	document.frmreservation.hidden_reservation_id.value=oidReservation;
	document.frmreservation.command.value="<%=JSPCommand.DELETE%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}
function cmdSave(){
	document.frmreservation.command.value="<%=JSPCommand.SAVE%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
	}

function cmdEdit(oidReservation){
	document.frmreservation.hidden_reservation_id.value=oidReservation;
	document.frmreservation.command.value="<%=JSPCommand.EDIT%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
	}

function cmdCancel(oidReservation){
	document.frmreservation.hidden_reservation_id.value=oidReservation;
	document.frmreservation.command.value="<%=JSPCommand.EDIT%>";
	document.frmreservation.prev_command.value="<%=prevJSPCommand%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}

function cmdBack(){
	document.frmreservation.command.value="<%=JSPCommand.BACK%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
	}

function cmdListFirst(){
	document.frmreservation.command.value="<%=JSPCommand.FIRST%>";
	document.frmreservation.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}

function cmdListPrev(){
	document.frmreservation.command.value="<%=JSPCommand.PREV%>";
	document.frmreservation.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
	}

function cmdListNext(){
	document.frmreservation.command.value="<%=JSPCommand.NEXT%>";
	document.frmreservation.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
}

function cmdListLast(){
	document.frmreservation.command.value="<%=JSPCommand.LAST%>";
	document.frmreservation.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmreservation.action="reservation.jsp";
	document.frmreservation.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../imagessl/new2.gif')">
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
                        <form name="frmreservation" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_reservation_id" value="<%=oidReservation%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_ADMIN_ID] %>"  value="<%=(reservation.getAdminId()==0) ? user.getOID() :  reservation.getAdminId()%>">
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
                                                  </font> <span class="lvl2">Daftar 
                                                  Reservasi</span></b></td>
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
                                                <td width="3%">Dokter</td>
                                                <td width="11%"> 
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
                                                <td width="5%">Tanggal</td>
                                                <td width="13%" nowrap> 
                                                  <input name="src_tanggal" value="<%=JSPFormater.formatDate((srcTanggal==null) ? new Date() : srcTanggal, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreservation.src_tanggal);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                <td width="68%"> 
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
								if (listReservation.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listReservation,oidReservation)%> </td>
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
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspReservation.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left">
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="89%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="89%" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Dokter</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector doctorid_value = new Vector(1,1);
						Vector doctorid_key = new Vector(1,1);
					 	String sel_doctorid = ""+reservation.getDoctorId();
						
						doctorid_key.add("0");
						doctorid_value.add("");
						if(docs!=null && docs.size()>0){
							for(int i=0; i<docs.size(); i++){
								Doctor d = (Doctor)docs.get(i);								
							   doctorid_key.add(""+d.getOID());
							   doctorid_value.add(""+d.getName());
					  		}
						}
					   %>
                                            <%= JSPCombo.draw(jspReservation.colNames[JspReservation.JSP_FIELD_DOCTOR_ID],null, sel_doctorid, doctorid_key, doctorid_value, "", "formElemen") %> * <%= jspReservation.getErrorMsg(JspReservation.JSP_FIELD_DOCTOR_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Pasien</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <%
										  Vector patients = DbPatient.list(0,0,"", "name");
										  %>
                                            <select name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_PATIENT_ID] %>">
                                              <option></option>
                                              <%if(patients!=null && patients.size()>0){
											for(int i=0; i<patients.size(); i++){
												Patient pt = (Patient)patients.get(i);
											%>
                                              <option value="<%=pt.getOID()%>" <%if(reservation.getPatientId()==pt.getOID()){%>selected<%}%>><%=pt.getName()%></option>
                                              <%}}%>
                                            </select>
                                            * <%= jspReservation.getErrorMsg(JspReservation.JSP_FIELD_PATIENT_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nomor Urut</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <select name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_QUEUE_NUMBER] %>">
                                              <%for(int i=1; i<251; i++){%>
                                              <option value="<%=i%>" <%if(reservation.getQueueNumber()==i){%>selected<%}%>><%=(i<10) ? "0"+i : ""+i%></option>
                                              <%}%>
                                            </select>
                                            * <%= jspReservation.getErrorMsg(JspReservation.JSP_FIELD_QUEUE_NUMBER) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Register 
                                            untuk Tanggal</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_REG_DATE]%>" value="<%=JSPFormater.formatDate((reservation.getRegDate()==null) ? new Date() : reservation.getRegDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreservation.<%=jspReservation.colNames[JspReservation.JSP_FIELD_REG_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>* 
                                            <%= jspReservation.getErrorMsg(JspReservation.JSP_FIELD_REG_DATE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Perkiraan 
                                            Jam</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <%
										  Date dt = (reservation.getQueueTime()==null) ? new Date() : reservation.getQueueTime();
										  %>
                                            <select name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_QUEUE_TIME] %>_hh">
                                              <%for(int i=0; i<24; i++){%>
                                              <option value="<%=i%>" <%if(dt.getHours()==i){%>selected<%}%>><%=(i<10) ? "0"+i : ""+i%></option>
                                              <%}%>
                                            </select>
                                            : 
                                            <select name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_QUEUE_TIME] %>_mm">
                                              <%for(int i=0; i<59; i++){%>
                                              <option value="<%=i%>" <%if(dt.getMinutes()==i){%>selected<%}%>><%=(i<10) ? "0"+i : ""+i%></option>
                                              <%}%>
                                            </select>
                                        <tr align="left"> 
                                          <td height="21" width="11%" valign="top">Keterangan/Keluhan</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <textarea name="<%=jspReservation.colNames[JspReservation.JSP_FIELD_DESCRIPTION] %>" class="formElemen" cols="40" rows="3"><%= reservation.getDescription() %></textarea>
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="11%">&nbsp;</td>
                                          <td height="8" colspan="2" width="89%" valign="top">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("40%");
									String scomDel = "javascript:cmdAsk('"+oidReservation+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidReservation+"')";
									String scancel = "javascript:cmdEdit('"+oidReservation+"')";
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
                                          <td width="11%">&nbsp;</td>
                                          <td width="89%">&nbsp;</td>
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
