 
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

			rowx.add(patient.getName());

			//rowx.add(patient.getBirthPlace()); 

			String str_dt_BirthDate = ""; 
			try{
				Date dt_BirthDate = patient.getBirthDate();
				if(dt_BirthDate==null){
					dt_BirthDate = new Date();
				}

				str_dt_BirthDate = JSPFormater.formatDate(dt_BirthDate, "dd-MM-yyyy");
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
long srcInsuranceId = JSPRequestValue.requestLong(request, "src_insurance_id");
String srcName = JSPRequestValue.requestString(request, "src_name");
String srcNiID = JSPRequestValue.requestString(request, "src_noid");
int srcGender = JSPRequestValue.requestInt(request, "src_gender");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE; 
String whereClause = "";
String orderClause = "";

if(iJSPCommand==JSPCommand.SUBMIT){
	if(srcName!=null && srcName.length()>0){
		whereClause = "name like '%"+srcName+"%'";  
	}
	if(srcNiID!=null && srcNiID.length()>0){
		if(whereClause.length()>0){
			whereClause = whereClause + " and ";
		}
		whereClause = whereClause + " id_number '%"+srcNiID+"%'";
	}
	if(srcInsuranceId!=0){
		if(whereClause.length()>0){
			whereClause = whereClause + " and ";
		}
		whereClause = whereClause + " insurance_id="+srcInsuranceId;
	}
	if(srcGender>-1){
		if(whereClause.length()>0){
			whereClause = whereClause + " and "; 
		}
		whereClause = whereClause + " gender="+srcGender;
	}
}

out.println("whereClause " +whereClause);

if(iJSPCommand==JSPCommand.NONE){
	srcGender = -1;
}

CmdPatient ctrlPatient = new CmdPatient(request);
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

function cmdSearch(){
	//document.frmpatient.hidden_patient_id.value="0";
	document.frmpatient.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpatient.prev_command.value="<%=prevJSPCommand%>";
	document.frmpatient.action="patientlist.jsp";
	document.frmpatient.submit();
}

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
                                                  </font> <span class="lvl2">Daftar 
                                                  Pasien</span></b></td>
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
                                                <td width="10%">Nama</td>
                                                <td width="16%"> 
                                                  <input type="text" name="src_name" value="<%=srcName%>">
                                                </td>
                                                <td width="7%">Jenis Kelamin</td>
                                                <td width="67%"> 
                                                  <% Vector gender_value = new Vector(1,1);
						Vector gender_key = new Vector(1,1);
					 	String sel_gender = ""+srcGender;
						gender_key.add("-1");
					   gender_value.add("- Semua - ");
					   gender_key.add("0");
					   gender_value.add("Wanita");
					   gender_key.add("1");
					   gender_value.add("Pria");
					   %>
                                                  <%= JSPCombo.draw("src_gender",null, sel_gender, gender_key, gender_value, "", "formElemen") %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Nomor Identitas</td>
                                                <td width="16%"> 
                                                  <input type="text" name="src_noid" value="<%=srcNiID%>">
                                                </td>
                                                <td width="7%">Asuransi</td>
                                                <td width="67%"> 
                                                  <% Vector insuranceid_value = new Vector(1,1);
						Vector insuranceid_key = new Vector(1,1);
					 	String sel_insuranceid = ""+srcInsuranceId;
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
                                                  <%= JSPCombo.draw("src_insurance_id",null, sel_insuranceid, insuranceid_key, insuranceid_value, "", "formElemen") %></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="25"><a href="javascript:cmdSearch()">Cari 
                                                  Data</a></td>
                                                <td width="16%" height="25">&nbsp;</td>
                                                <td width="7%" height="25">&nbsp;</td>
                                                <td width="67%" height="25">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                        </tr>
                                        <%
										if(iJSPCommand==JSPCommand.SUBMIT){
							try{
								if (listPatient.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listPatient,oidPatient)%> </td>
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
										}//submit
										
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iJSPCommand!=JSPCommand.SAVE)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../imagessl/new2.gif',1)">Tambah 
                                            Baru</a> | <a href="javascript:cmdBack()">Kembali</a></td>
                                        </tr>
                                        <%}
										
										%>
                                      </table> 
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
