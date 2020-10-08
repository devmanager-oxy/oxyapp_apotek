 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.marketing.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long customerId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Name","20%");
		//cmdist.addHeader("DOB","10%");
		cmdist.addHeader("Address","25%");
		cmdist.addHeader("Country","15%");
		cmdist.addHeader("Nationality","15%");
		cmdist.addHeader("Tax ID/SS","15%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Customer customer = (Customer)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(customerId == customer.getOID())
				 index = i;

			if(customer.getType()==0){
				String str = customer.getSalutation()+" "+customer.getName();
				if(customer.getLastName().length()>0){
					str = str + ((customer.getMiddleName()==null || customer.getMiddleName().length()==0) ? "" : customer.getMiddleName()) + ", "+customer.getLastName();
				}
				else{
					str = str + ((customer.getMiddleName()==null || customer.getMiddleName().length()>0) ? "" : customer.getMiddleName());
				}
				rowx.add(str);
			}
			else{
				rowx.add(customer.getSalutation()+" "+customer.getName());
			}

			//rowx.add((customer.getDobIgnore()==0) ? JSPFormater.formatDate(customer.getDob(),"dd MMMM yy") : "");
			
			rowx.add(customer.getAddress()+((customer.getCity()==null || customer.getCity().length()<1) ? "" : ", "+customer.getCity()) + ((customer.getState()==null || customer.getState().length()<1) ? "" : ", "+customer.getState()));

			rowx.add(customer.getCountryName());

			rowx.add(customer.getNationalityName());

			rowx.add((customer.getIdNumber()==null || customer.getIdNumber().length()<1) ? "" : (customer.getIdType()+"/"+customer.getIdNumber()));

			lstData.add(rowx);
			
			String str = customer.getOID()+"','"+customer.getType()+"','"+customer.getCode()+"','"+customer.getName()+"','"+customer.getMiddleName();
			str = str + "','"+customer.getLastName()+"','"+customer.getContactPerson()+"','"+customer.getContactMiddleName();
			str = str + "','"+customer.getContactLastName()+"','"+customer.getAddress()+"','"+customer.getCity()+"','"+customer.getState();
			str = str + "','"+customer.getCountryId()+"','"+customer.getZipCode()+"','"+customer.getPhoneArea()+"','"+customer.getPhone();
			str = str + "','"+customer.getFaxArea()+"','"+customer.getFax()+"','"+customer.getHp()+"','"+customer.getEmail();
			str = str + "','"+customer.getWebSite()+"','"+customer.getSalutation();
			
			lstLinkData.add(str);
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
int isSearch = JSPRequestValue.requestInt(request, "hidden_search");
int type = JSPRequestValue.requestInt(request, "hidden_type");

JSPLine ctrLine = new JSPLine();

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;


String srcIntroNumber = JSPRequestValue.requestString(request, "src_intro_number");
String srcName = JSPRequestValue.requestString(request, "src_name");
String srcAddress = JSPRequestValue.requestString(request, "src_address");

int vectSize = DbIntroLetter.getCountIntroLetter(srcName, srcAddress, srcIntroNumber);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
  		Control c = new Control();
		start = c.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

Vector intros = DbIntroLetter.getIntroLetter(start, recordToGet, srcName, srcAddress, srcIntroNumber);

%>
<html >
<head>
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--



<%if(!custNewPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>	  	
		
function cmdResetX(){
	document.frmcustomer.src_name.value="";
	document.frmcustomer.src_address.value="";
	document.frmcustomer.src_country.value="";
	document.frmcustomer.src_nationality.value="";
	document.frmcustomer.src_dobfrom.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
	document.frmcustomer.src_dobto.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
	document.frmcustomer.src_dobignore.checked;
}

function cmdAdd(){
	document.frmcustomer.hidden_customer_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdAsk(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(iloid,ilnumber,croid,crnumber,coid,cname,caddress,cryth1,cryth2,type, middleName, lastName, salut, phones, cperson, cposition ){
	
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_INTRO_LETTER_ID] %>.value=iloid;	
	self.opener.frmproposal.intro_letter.value=ilnumber;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_CUSTOMER_REQUEST_ID] %>.value=croid;
	self.opener.frmproposal.customer_request.value=crnumber;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_CUSTOMER_ID] %>.value=coid;
	
	self.opener.frmproposal.customer_address.value=caddress;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_ADDRESS] %>.value=caddress;
	self.opener.frmproposal.comname.value=cname+", "+salut;;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH]%>.value=cposition;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH1]%>.value=cperson;
	
	<%if(type==0){%>
		//self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH1] %>.value=cname+" "+middleName+" "+lastName+", "+salut;
		self.opener.frmproposal.customer_name.value=cname+" "+middleName+" "+lastName+", "+salut;
	<%}
	else{%>
		//self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH1] %>.value=cname+", "+salut;
		self.opener.frmproposal.customer_name.value=cname+", "+salut;
		self.opener.frmproposal.<%=JspProposalEng.colNames[JspProposalEng.JSP_GREATING_ENG]%>.value = "Attention to : "+cperson;
	<%}%>
	
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH_ADDRESS] %>.value=caddress;
	self.opener.frmproposal.<%=JspProposal.colNames[JspProposal.JSP_YTH_PHONE] %>.value=phones;
		
	self.close();
	
}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="proposaliletterlist.jsp";//proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdSearch(){
	document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcustomer.action="proposaliletterlist.jsp";
	document.frmcustomer.submit();
}

function cmdSearchActive(){
	document.all.searching.style.display="";
	document.all.activate.style.display="none";
	document.all.deactivate.style.display="";
	document.frmcustomer.hidden_search.value="1";
}

function cmdSearchHide(){
	document.all.searching.style.display="none";
	document.all.activate.style.display="";
	document.all.deactivate.style.display="none";
	document.frmcustomer.hidden_search.value="0";
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


//-------------- script control line -------------------
//-->
</script>
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/addnew2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif">&nbsp; 
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><span class="level1">Marketing</span> 
                        &raquo; <span class="level2">Introduction Letter List<br>
                        </span></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td> 
                        <form name="frmcustomer" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                          <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_type" value="<%=type%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr  id="searching"> 
                                    <td height="14" valign="top" colspan="3" class="comment" width="99%"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="10%" height="8"></td>
                                          <td width="22%" height="8"></td>
                                          <td width="9%" height="8"></td>
                                          <td width="19%" height="8"></td>
                                          <td width="13%" height="8"></td>
                                          <td width="27%" height="8"></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" nowrap>Customer<img src="../images/spacer.gif" width="10" height="8"></td>
                                          <td width="22%"> 
                                            <input type="text" name="src_name"  value="<%= srcName %>" class="formElemen" size="30">
                                          </td>
                                          <td width="9%" nowrap><img src="../images/spacer.gif" width="10" height="8">Address/City/State<img src="../images/spacer.gif" width="10" height="8"></td>
                                          <td width="19%" nowrap> 
                                            <input type="text" name="src_address"  value="<%= srcAddress %>" class="formElemen" size="35">
                                            <img src="../images/spacer.gif" width="10" height="8"> 
                                          </td>
                                          <td width="13%" nowrap> 
                                            <input type="button" name="Button" value="Search" onClick="javascript:cmdSearch()">
                                            <input type="button" name="Button" value="Reset" onClick="javascript:cmdResetX()">
                                          </td>
                                          <td width="27%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" nowrap>Introduction 
                                            Number</td>
                                          <td width="22%"> 
                                            <input type="text" name="src_intro_number"  value="<%= srcIntroNumber %>" class="formElemen" size="30">
                                          </td>
                                          <td width="9%" nowrap>&nbsp;</td>
                                          <td width="19%" nowrap>&nbsp;</td>
                                          <td width="13%" nowrap>&nbsp;</td>
                                          <td width="27%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="7" valign="middle" colspan="3" width="99%"></td>
                                  </tr>
                                  <%
							try{
								
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" width="99%">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="10%">Introduction 
                                            Number</td>
                                          <td class="tablehdr" width="13%">Customer 
                                            Request Ref.</td>
                                          <td class="tablehdr" width="14%">Introduction 
                                            Date</td>
                                          <td class="tablehdr" width="15%">Customer</td>
                                          <td class="tablehdr" width="15%">Address</td>
                                          <td class="tablehdr" width="16%">Intro. 
                                            Contact Person</td>
                                          <td class="tablehdr" width="17%">Subject</td>
                                        </tr>
                                        <%if (intros!=null && intros.size()>0){
										for(int i=0; i<intros.size(); i++){
											IntroLetter il = (IntroLetter)intros.get(i);
											Customer c = new Customer();
											CustomerRequest cr = new CustomerRequest();
											try{
												c = DbCustomer.fetchExc(il.getCustomerId());
												cr = DbCustomerRequest.fetchExc(il.getCustomerRequestId());
											}
											catch(Exception e){
											}
											
											String phone = c.getContactPhone();
											phone = (phone==null && phone.length()==0) ? c.getHp() : phone+"/"+c.getHp();
											//((c.getPhoneArea()==null) ? "" : "-"+c.getPhoneArea())+((c.getPhone()==null) ? "" : c.getPhone())+
															//((c.getHp()==null) ? "" : "/"+c.getHp());
											
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell" width="10%"><a href="javascript:cmdEdit('<%=il.getOID()%>','<%=il.getNumber()%>','<%=cr.getOID()%>','<%=cr.getRequestNumber()%>','<%=c.getOID()%>','<%=c.getName()%>','<%=c.getAddress()%>','<%=il.getYth1()%>','<%=il.getYth2()%>','<%=c.getType()%>','<%=c.getMiddleName()%>','<%=c.getLastName()%>','<%=c.getSalutation()%>','<%=phone%>','<%=c.getContactPerson()%>','<%=c.getContactPosition()%>')"><%=il.getNumber()%></a></td>
                                          <td class="tablecell" width="13%"><%=(cr.getRequestNumber().length()>0) ? cr.getRequestNumber() : "-"%></td>
                                          <td class="tablecell" width="14%"><%=JSPFormater.formatDate(il.getDocDate(),"dd MMMM yyyy")%></td>
                                          <td class="tablecell" width="15%"><%=c.getName()%></td>
                                          <td class="tablecell" width="15%"><%=c.getAddress()%></td>
                                          <td class="tablecell" width="16%"><%=il.getYth1()+" "+il.getYth2()%></td>
                                          <td class="tablecell" width="17%"><%=(il.getSubjectIndo().length()>0) ? il.getSubjectIndo() : il.getSubjectEng()%></td>
                                        </tr>
										<%}else{%>
                                        <tr> 
                                          <td class="tablecell1" width="10%"><a href="javascript:cmdEdit('<%=il.getOID()%>','<%=il.getNumber()%>','<%=cr.getOID()%>','<%=cr.getRequestNumber()%>','<%=c.getOID()%>','<%=c.getName()%>','<%=c.getAddress()%>','<%=il.getYth1()%>','<%=il.getYth2()%>','<%=c.getType()%>','<%=c.getMiddleName()%>','<%=c.getLastName()%>','<%=c.getSalutation()%>','<%=phone%>','<%=c.getContactPerson()%>','<%=c.getContactPosition()%>')"><%=il.getNumber()%></a></td>
                                          <td class="tablecell1" width="13%"><%=(cr.getRequestNumber().length()>0) ? cr.getRequestNumber() : "-"%></td>
                                          <td class="tablecell1" width="14%"><%=JSPFormater.formatDate(il.getDocDate(),"dd MMMM yyyy")%></td>
                                          <td class="tablecell1" width="15%"><%=c.getName()%></td>
                                          <td class="tablecell1" width="15%"><%=c.getAddress()%></td>
                                          <td class="tablecell1" width="16%"><%=il.getYth1()+" "+il.getYth2()%></td>
                                          <td class="tablecell1" width="17%"><%=(il.getSubjectIndo().length()>0) ? il.getSubjectIndo() : il.getSubjectEng()%></td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%  
						  }catch(Exception exc){ 
						  }%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command" width="99%"> 
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
                                      <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								
											
											ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
											ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
											ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
											ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
											
											ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
											ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
											ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
											ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" width="99%"><a href="javascript:cmdAdd()" class="command"></a></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
                            </tr>
                          </table>
						  <script language="JavaScript">
window.focus();
</script>
                        </form>
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
          <td height="25">&nbsp; </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
