<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.main.db.*" %>
<%//@ page import="com.project.crm.master.*" %>
<%@ page import="com.project.fms.transaction.*" %>
<%@ page import="com.project.general.*" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/check.jsp"%> 
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command"); 
int previewType = JSPRequestValue.requestInt(request, "preview_type"); 


int iErrCode = JSPMessage.NONE;
String msgString = "";
int recordToGet = 5;
int vectSize = 0;
JSPLine ctrLine = new JSPLine(); 

boolean homePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_HOMEPAGE);

String[] langHome = {"Finance System", "Welcome"};
String langHome1 = "welcome to OxySystem Finance System. Your last login is";
String langHome2 = "Please click one of the menu provided in menu navigator to using our Finance System.";
String langHome3 = "Reminder";
String langHome4 = "Messages";
String langHome5 = "When";

if(lang == LANG_ID) {
	langHome1 = "selamat datang di Sistem Keuangan OxySystem. Anda terakhir login pada";
	langHome2 = "Silahkan klik salah satu menu yang disediakan dalam menu navigator untuk menggunakan sistem keuangan ini.";
	langHome3 = "Pengingat";
	langHome4 = "Pesan";
	langHome5 = "Tanggal";
	
	String[] homeID = {"Sistem Keuangan", "Selamat Datang"};
	langHome = homeID;
}

//===================== approval ======================
if(iJSPCommand==JSPCommand.SUBMIT){
	long approvalDocId = JSPRequestValue.requestLong(request, "approval_doc_id");
	int approvalDocStatus = JSPRequestValue.requestInt(request, "approval_doc_status");
	String approvalNotes = JSPRequestValue.requestString(request, "approval_doc_note");
	approvalNotes = (approvalNotes==null) ? "" : approvalNotes;
	if(approvalDocId!=0){
		DbApprovalDoc.approveDoc(approvalDocId, user, approvalDocStatus, approvalNotes);
	}
}

//searching
//search
CmdApprovalDoc ctrlAppDoc = new CmdApprovalDoc(request);


int docType = JSPRequestValue.requestInt(request, "src_doc_type"); 
String docNumber = JSPRequestValue.requestString(request, "src_doc_number");
Vector listDocument = new Vector();
if(iJSPCommand==JSPCommand.START || (iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	
	String where = "journal_number like '%"+docNumber+"%'";
	
	switch(docType){
		case 12 :
			vectSize = DbPettycashPayment.getCount(where);
			if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
					(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
				start = ctrlAppDoc.actionList(iJSPCommand, start, vectSize, recordToGet);
			}
			listDocument = DbPettycashPayment.list(start, recordToGet, where, "date desc");
			break;
		case 13 :
			vectSize = DbCashReceive.getCount(where);
			if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
					(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
				start = ctrlAppDoc.actionList(iJSPCommand, start, vectSize, recordToGet);
			}
			listDocument = DbCashReceive.list(start, recordToGet, where, "date desc");
			break;
	}
}

//out.println("docNumber : "+docNumber);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
<%if(!isSystemActive){%>
	window.location="expired.jsp";
<%}%>

<%if(!homePriv){%>
	window.location="nopriv.jsp";
<%}%>

function cmdChange(type){
	document.frm_data.preview_type.value=type;
	document.frm_data.command.value="<%=JSPCommand.NONE%>";
	if(parseInt(type)==0){
		document.frm_data.action="home.jsp";
	}
	else{
		document.frm_data.action="home-app.jsp";
	}
	document.frm_data.submit();
}

function cmdSearch(){
	var x = document.frm_data.src_doc_number.value;
	if(x==""){
		alert("harap mengisi nomor dokumen");
		document.frm_data.src_doc_number.focus();
	}
	else{
		document.frm_data.command.value="<%=JSPCommand.START%>";
		document.frm_data.action="home.jsp";
		document.frm_data.submit();
	}
}

function cmdApprove(appdocid, status){
	//alert(status);
	if(parseInt(status)==1){
		if(confirm("Anda yakin menyetujui dokumen ini ?")){
			document.frm_data.approval_doc_id.value=appdocid;
			document.frm_data.approval_doc_status.value=status;
			document.frm_data.command.value="<%=JSPCommand.SUBMIT%>";
			document.frm_data.action="home.jsp";
			document.frm_data.submit();
		}

	}
	else{
		if(confirm("Anda yakin membatalkan persetujuan dokumen ini ?")){
			document.frm_data.approval_doc_id.value=appdocid;
			document.frm_data.approval_doc_status.value=status;
			document.frm_data.command.value="<%=JSPCommand.SUBMIT%>";
			document.frm_data.action="home.jsp";
			document.frm_data.submit();
		}
	}
}

function cmdDetail(type, apdId, docId){
	document.frm_data.approval_doc_id.value=apdId;
	document.frm_data.doc_id.value=docId;
	document.frm_data.doc_type.value=type;
	
	if(parseInt(type)==12){
		document.frm_data.command.value="<%=JSPCommand.LIST%>";
		document.frm_data.hidden_pettycash_payment_id.value=docId;
		document.frm_data.action="<%=approot%>/transaction/pettycashpaymentdetail-app.jsp";
	}
	else if(parseInt(type)==13){
		document.frm_data.command.value="<%=JSPCommand.LIST%>";
		document.frm_data.hidden_cash_receive_id.value=docId;
		document.frm_data.action="<%=approot%>/transaction/cashreceivedetail-app.jsp";
	}
	document.frm_data.submit();
}


function cmdListFirst(){
	document.frm_data.command.value="<%=JSPCommand.FIRST%>";
	document.frm_data.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frm_data.action="home.jsp";
	document.frm_data.submit();
}

function cmdListPrev(){
	document.frm_data.command.value="<%=JSPCommand.PREV%>";
	document.frm_data.prev_command.value="<%=JSPCommand.PREV%>";
	document.frm_data.action="home.jsp";
	document.frm_data.submit();
}

function cmdListNext(){
	document.frm_data.command.value="<%=JSPCommand.NEXT%>";
	document.frm_data.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frm_data.action="home.jsp";
	document.frm_data.submit();
}

function cmdListLast(){
	document.frm_data.command.value="<%=JSPCommand.LAST%>";
	document.frm_data.prev_command.value="<%=JSPCommand.LAST%>";
	document.frm_data.action="home.jsp";
	document.frm_data.submit();
}

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
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','images/search2.gif','images/viewdoc1.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="main/hmenu.jsp"%> 
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
                      <%
					  String navigator = "<font class=\"lvl1\">"+langHome[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langHome[1]+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>					
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" -->
					  
                        <form name="frm_data" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="start" value="<%=start%>">
						  <input type="hidden" name="command" value="<%=iJSPCommand%>">
						  <input type="hidden" name="prev_command" value="">
                          <input type="hidden" name="approval_doc_id" value="">
						  <input type="hidden" name="doc_id" value="">
						  <input type="hidden" name="doc_type" value="">
						  <input type="hidden" name="approval_doc_status" value="">
						  <input type="hidden" name="hidden_pettycash_payment_id" value="">
						  <input type="hidden" name="hidden_cash_receive_id" value="">						  
						  <input type="hidden" name="preview_type" value="<%=previewType%>">						  					  						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            
                            <tr> 
                              <td class="container"> 
                                <table width="68%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="17%" valign="top" nowrap><font face="Arial, Helvetica, sans-serif"><b><img src="<%=approot%>/images/<%=user.getEmployeeNum()%>.jpg" height="130" border="0"><img src="images/spacer.gif" width="10" height="8"></b></font></td>
                                    <td width="55%" valign="top"> 
                                      <div align="left"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName()%></b>, <%=langHome1%> : <%=(user.getLastLoginDate1()==null) ? " - " : JSPFormater.formatDate(user.getLastLoginDate1(), "dd MMMM yyyy HH:mm:ss")%><br>
                                        <br>
                                        <%=langHome2%></font></div>
                                    </td>
                                    <td width="28%" valign="top" align="right" colspan="2"> 
                                      <%@ include file = "main/calendar.jsp" %>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="4"></td>
                                  </tr>
                                  <tr> 
                                    <td width="17%"> </td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="4" class="boxed">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="8%" nowrap>Tipe Dokumen&nbsp;</td>
                                          <td width="8%" nowrap> 
                                            <select name="src_doc_type">
                                              <option value="12" <%if(docType==12){%>selected<%}%>>BKK</option>
                                              <option value="13" <%if(docType==13){%>selected<%}%>>BKM</option>
                                            </select>
                                            <img src="images/spacer.gif" width="15" height="8"> 
                                          </td>
                                          <td width="4%">Nomor&nbsp;</td>
                                          <td width="18%" nowrap> 
                                            <input type="text" name="src_doc_number" value="<%=docNumber%>">
                                            <img src="images/spacer.gif" width="10" height="8"> 
                                          </td>
                                          <td width="62%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('src','','images/search2.gif',1)"><img src="images/search.gif" name="src"  border="0" alt="Klik untuk melakukan pencarian"></a></td>
                                          <td width="62%" valign="top" nowrap> 
                                            <div align="right"><font size="1">pencarian 
                                              untuk check status approval</font></div>
                                          </td>
                                        </tr>
										<%if(iJSPCommand==JSPCommand.START || (iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){%>
                                        <tr> 
                                          <td colspan="6" nowrap>
                                            <table width="69%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="6%" height="5"></td>
                                                <td width="17%" height="5"></td>
                                                <td width="14%" height="5"></td>
                                                <td width="15%" height="5"></td>
                                                <td width="42%" height="5"></td>
                                                <td width="6%" height="5"></td>
                                              </tr>
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="6%" height="1"></td>
                                                <td width="17%" height="1"></td>
                                                <td width="14%" height="1"></td>
                                                <td width="15%" height="1"></td>
                                                <td width="42%" height="1"></td>
                                                <td width="6%" height="1"></td>
                                              </tr>
                                              <tr> 
                                                <td width="6%" height="20"><b>No</b></td>
                                                <td width="17%" height="20"><b>Nomor 
                                                  Dok. </b></td>
                                                <td width="14%" height="20"><b>Tanggal</b></td>
                                                <td width="15%" height="20"><b>Total</b></td>
                                                <td width="42%" height="20"><b>Keterangan</b></td>
                                                <td width="6%" height="20">&nbsp;</td>
                                              </tr>
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="6%" height="1"></td>
                                                <td width="17%" height="1"></td>
                                                <td width="14%" height="1"></td>
                                                <td width="15%" height="1"></td>
                                                <td width="42%" height="1"></td>
                                                <td width="6%" height="1"></td>
                                              </tr>
                                              <%if(listDocument!=null && listDocument.size()>0){
											  		for(int i=0; i<listDocument.size(); i++){
													
														String nomor = "";
														String tglInput = "";
														String tglTransaksi = "";
														String jumlah = "";
														String keterangan = "";
														String docId = "";
														
														switch(docType){
															case 0 : break;
															case 1 : break;
															case 2 : break;
															case 3 : break;
															case 4 : break;
															case 5 : break;
															case 6 : break;
															case 7 : break;
															case 8 : break;
															case 9 : break;
															case 10 : break;
															case 11 : break;
															
															case 12 : PettycashPayment ptc = (PettycashPayment)listDocument.get(i);
																	  try{																			
																			nomor = ptc.getJournalNumber();
																			tglInput = JSPFormater.formatDate(ptc.getDate(), "dd/MM/yyyy");
																			tglTransaksi = JSPFormater.formatDate(ptc.getTransDate(), "dd/MM/yyyy");
																			jumlah = JSPFormater.formatNumber(ptc.getAmount(), "#,###");;
																			keterangan = ptc.getMemo();
																			docId = ptc.getOID()+"";
																	  }
																	  catch(Exception e){
																	  }	
															
																	  break;
																	  
															case 13 : CashReceive cr = (CashReceive)listDocument.get(i);
																	  try{																			
																			nomor = cr.getJournalNumber();
																			tglInput = JSPFormater.formatDate(cr.getDate(), "dd/MM/yyyy");
																			tglTransaksi = JSPFormater.formatDate(cr.getTransDate(), "dd/MM/yyyy");
																			jumlah = JSPFormater.formatNumber(cr.getAmount(), "#,###");;
																			keterangan = cr.getMemo();
																			docId = cr.getOID()+"";
																	  }
																	  catch(Exception e){
																	  }
															
																	  break;
															case 14 : break;
															case 15 : break;
														}
														
											  %>
                                              <tr> 
                                                <td width="6%"><%=start+i+1%></td>
                                                <td width="17%"><%=nomor%></td>
                                                <td width="14%"><%=tglTransaksi%></td>
                                                <td width="15%"><%=jumlah%></td>
                                                <td width="42%"><%=keterangan%></td>
                                                <td width="6%"> 
                                                  <div align="center"><a href="javascript:cmdDetail('<%=docType%>','0','<%=docId%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2111x1<%=i%>','','images/viewdoc1.gif',1)"><img src="images/viewdoc.gif" name="new2111x1<%=i%>"  border="0" alt="Klik untuk melihat detail dokumen"></a></div>
                                                </td>
                                              </tr>
                                              <%}%>
											  <tr bgcolor="#CCCCCC"> 
                                                <td width="6%" height="1"></td>
                                                <td width="17%" height="1"></td>
                                                <td width="14%" height="1"></td>
                                                <td width="15%" height="1"></td>
                                                <td width="42%" height="1"></td>
                                                <td width="6%" height="1"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="6" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="6"> <span class="command"> 
                                                  <%
													int cmd = 0;
													if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
															(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
														cmd = iJSPCommand;
													} else {
														if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
															cmd = JSPCommand.FIRST;
														} else {
															cmd = prevJSPCommand;
														}
													}
													%>
                                                  <% ctrLine.setLocationImg(approot + "/images/ctr_line");
														ctrLine.initDefault();
													%>
                                                  <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                              </tr>
                                              <%}else{%>
											  <tr> 
                                                <td colspan="6" height="5"><i>data 
                                                  tidak ditemukan</i></td>
                                              </tr>
											  <%}%>
                                            </table>
                                          </td>
                                        </tr>
										<%}%>
                                      </table>
                                    </td>
                                  </tr>								  
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
								  
                                  <%
								  
								  String applyWorkingDesk = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");
								  
								  if(applyWorkingDesk.equalsIgnoreCase("Y")){
								  		Vector docs = new Vector();
										if(previewType==0){
											docs = DbApprovalDoc.getDocumentByUser(user);
										}else{
											docs = DbApprovalDoc.getArsipDocumentByUser(user, previewType);
										}
								  %>
                                  <tr> 
                                    <td colspan="4"> 
                                      <%if(previewType==0){%>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td class="tablehdr" width="150">Lembar 
                                            Kerja Anda</td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><a href="javascript:cmdChange('1')"><b>Dokumen 
                                              Sdh Disetujui</b></a></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><b><a href="javascript:cmdChange('2')">Dokumen 
                                              Yg Ditolak</a></b></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                      <%}else if(previewType==1){%>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><b><a href="javascript:cmdChange('0')">Lembar 
                                              Kerja Anda</a></b></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150" class="tablehdr"> Dokumen 
                                            Sdh Disetujui</td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><b><a href="javascript:cmdChange('2')">Dokumen 
                                              Yg Ditolak</a></b></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                      <%}else{%>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><b><a href="javascript:cmdChange('0')">Lembar 
                                              Kerja Anda</a></b></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150" bgcolor="#FF9900"> 
                                            <div align="center"><a href="javascript:cmdChange('1')"><b>Dokumen 
                                              Sdh Disetujui</b></a></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td width="150"  class="tablehdr"> 
                                            <div align="center"><b>Dokumen Yg 
                                              Ditolak</b></div>
                                          </td>
                                          <td width="2" bgcolor="#FFFFFF">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr class="boxed"> 
                                    <td colspan="4" class="boxed" height="90"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <%										
										if(docs!=null && docs.size()>0){
										%>
                                        <tr> 
                                          <td height="16" colspan="8"><b> 
                                            <%if(previewType==0){%>
                                            Daftar dokumen yang membutuhkan persetujuan 
                                            anda. 
                                            <%}else if(previewType==1){%>
                                            Daftar dokumen yang sudah anda setujui 
                                            dan status postingnya. 
                                            <%}else{%>
                                            Daftar dokumen yang sudah anda tolak 
                                            persetujuannya. 
                                            <%}%>
                                            </b></td>
                                        </tr>
                                        <tr> 
                                          <td height="3" colspan="8"></td>
                                        </tr>
                                        <%
										for(int x=0; x<docs.size(); x++){
											Vector temp = (Vector)docs.get(x);
											
											System.out.println(temp);
											
											int type = Integer.parseInt((String)temp.get(0));
											
											System.out.println("type : "+type);
											
											Vector apds = (Vector)temp.get(1);
											
											System.out.println("apds : "+apds);
										%>
                                        <tr valign="middle"> 
                                          <td colspan="8" height="22" bgcolor="#F3F3F3"><b>Dokumen 
                                            : <%=I_Project.approvalTypeStr[type]%></b></td>
                                        </tr>
                                        <tr valign="bottom"> 
                                          <td width="24" height="17"> 
                                            <div align="left"><font size="1"><b>No</b></font></div>
                                          </td>
                                          <td width="85" height="17"> 
                                            <div align="left"><font size="1"><b>No 
                                              Dokumen</b></font></div>
                                          </td>
                                          <td width="98" height="17"> 
                                            <div align="left"><font size="1"><b>Tgl. 
                                              Input</b></font></div>
                                          </td>
                                          <td width="100" height="17"> 
                                            <div align="left"><font size="1"><b>Tgl. 
                                              Transaksi</b></font></div>
                                          </td>
                                          <td width="116" height="17"> 
                                            <div align="left"><font size="1"><b>Jumlah 
                                              Transaksi</b></font></div>
                                          </td>
                                          <td width="347" height="17"> 
                                            <div align="left"><font size="1"><b>Keterangan</b></font></div>
                                          </td>
                                          <td colspan="2" height="17"><font size="1"><b>Tindakan</b></font></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="8" height="1" bgcolor="#CCCCCC"></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="8" height="1" bgcolor="#CCCCCC"></td>
                                        </tr>
                                        <%
										if(apds!=null && apds.size()>0){
										for(int y=0; y<apds.size(); y++){
											
											ApprovalDoc apd = (ApprovalDoc)apds.get(y);
											
											int isPosted = 0;
											
											String nomor = "";
											String tglInput = "";
											String tglTransaksi = "";
											String jumlah = "";
											String keterangan = "";
											
											switch(apd.getDocType()){
												case 0 : break;
												case 1 : break;
												case 2 : break;
												case 3 : break;
												case 4 : break;
												case 5 : break;
												case 6 : break;
												case 7 : break;
												case 8 : break;
												case 9 : break;
												case 10 : break;
												case 11 : break;
												
												case 12 : PettycashPayment ptc = new PettycashPayment();
														  try{
														  	  	ptc = DbPettycashPayment.fetchExc(apd.getDocId());
																isPosted = ptc.getPostedStatus();
															  	
																nomor = ptc.getJournalNumber();
																tglInput = JSPFormater.formatDate(ptc.getDate(), "dd/MM/yyyy");
																tglTransaksi = JSPFormater.formatDate(ptc.getTransDate(), "dd/MM/yyyy");
																jumlah = JSPFormater.formatNumber(ptc.getAmount(), "#,###");;
																keterangan = ptc.getMemo();
														  }
														  catch(Exception e){
														  }	
												
														  break;
														  
												case 13 : CashReceive cr = new CashReceive();
														  try{
														  	  	cr = DbCashReceive.fetchExc(apd.getDocId());
																isPosted = cr.getPostedStatus();
															  	
																nomor = cr.getJournalNumber();
																tglInput = JSPFormater.formatDate(cr.getDate(), "dd/MM/yyyy");
																tglTransaksi = JSPFormater.formatDate(cr.getTransDate(), "dd/MM/yyyy");
																jumlah = JSPFormater.formatNumber(cr.getAmount(), "#,###");;
																keterangan = cr.getMemo();
														  }
														  catch(Exception e){
														  }
												
														  break;
												case 14 : break;
												case 15 : break;
											}
											
										%>
                                        <tr> 
                                          <td width="24" height="21" nowrap> <%=y+1%> </td>
                                          <td width="85" height="21" nowrap><%=nomor%></td>
                                          <td width="98" height="21" nowrap><%=tglInput%></td>
                                          <td width="100" height="21" nowrap><%=tglTransaksi%></td>
                                          <td width="116" height="21" nowrap><%=jumlah%></td>
                                          <td width="347" height="21"><%=keterangan%></td>
                                          <td width="45" height="21" nowrap> 
                                            <div align="center"> 
                                              <%if(isPosted==1){%>
                                              POSTED 
                                              <%}else{%>
                                              <%if(apd.getStatus()==DbApprovalDoc.STATUS_DRAFT){%>
                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                <tr> 
                                                  <td> 
                                                    <div align="center"><a href="javascript:cmdApprove('<%=apd.getOID()%>','1')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21<%=x%><%=y%>','','images/success1.gif',1)"><img src="images/success.gif" name="new21<%=x%><%=y%>"  border="0" alt="Klik untuk menyetujui dokumen"></a></div>
                                                  </td>
                                                  <td> 
                                                    <div align="center"><a href="javascript:cmdApprove('<%=apd.getOID()%>','2')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no21x<%=x%><%=y%>','','images/no1.gif',1)"><img src="images/no.gif" name="no21x<%=x%><%=y%>" border="0"  alt="Klik untuk TIDAK menyetujui dokumen"></a></div>
                                                  </td>
                                                </tr>
                                              </table>
                                              <% }
														else{
															if(user.getEmployeeId()==apd.getEmployeeId()){
																if(apd.getStatus()==DbApprovalDoc.STATUS_APPROVED){
															%>
                                              <div align="center"><a href="javascript:cmdApprove('<%=apd.getOID()%>','2')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no21<%=x%><%=y%>','','images/no1.gif',1)"><img src="images/no.gif" name="no21<%=x%><%=y%>" border="0" alt="Klik untuk membatalkan persetujuan"></a></div>
                                              <%	}else{%>
                                              <div align="center"><a href="javascript:cmdApprove('<%=apd.getOID()%>','1')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211<%=x%><%=y%>','','images/success1.gif',1)"><img src="images/success.gif" name="new211<%=x%><%=y%>"  border="0" alt="Klik untuk menyetujui dokumen"></a></div>
                                              <%}
															}
														}%>
                                              <%}%>
                                            </div>
                                          </td>
                                          <td width="43" height="21"> 
                                            <div align="center"><a href="javascript:cmdDetail('<%=apd.getDocType()%>','<%=apd.getOID()%>','<%=apd.getDocId()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('doc2111x<%=x%><%=y%>','','images/viewdoc1.gif',1)"><img src="images/viewdoc.gif" name="doc2111x<%=x%><%=y%>"  border="0" alt="Klik untuk melihat detail dokumen"></a></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="8" height="1" bgcolor="#CCCCCC"></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td colspan="8" height="1" bgcolor="#CCCCCC"></td>
                                        </tr>
                                        <%}}}
										else{
											
										%>
                                        <tr> 
                                          <td height="16" colspan="8"><b> 
                                            <%if(previewType==0){%>
                                            Tidak ada dokumen yang membutuhkan 
                                            persetujuan anda. 
                                            <%}else if(previewType==1){%>
                                            Tidak ada dokumen yang sudah anda 
                                            setujui. 
                                            <%}else{%>
                                            Tidak ada dokumen yang anda tolak. 
                                            <%}%>
                                            </b></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="24">&nbsp;</td>
                                          <td width="85">&nbsp;</td>
                                          <td width="98">&nbsp;</td>
                                          <td width="100">&nbsp;</td>
                                          <td width="116">&nbsp;</td>
                                          <td width="347">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="43">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="8"> 
                                            <%if(iJSPCommand==JSPCommand.SUBMIT){%>
                                            <font color="#006600">proses sudah 
                                            selesai.</font> 
                                            <%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
                        <!-- #EndEditable -->
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
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
