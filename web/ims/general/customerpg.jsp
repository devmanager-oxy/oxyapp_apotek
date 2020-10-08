 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
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

	String[] strCustomerType = {
		"Private House", "Apartment",
		"Cafe", "Factory",
        "Garment", "Hospital",
        "Hotel", "Night Club",
		"Office Building", "Private House",
        "Resort", "Villa"
	};

	public String drawList(Vector objectClass ,  long customerId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		//cmdist.addHeader("Type","10%");
		cmdist.addHeader("Name","20%");
		//cmdist.addHeader("DOB","10%");
		cmdist.addHeader("Address","20%");
		cmdist.addHeader("Country","20%");
		cmdist.addHeader("Phone/Fax","20%");
		//cmdist.addHeader("Tax ID/SS","15%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			try{
				Customer customer = (Customer)objectClass.get(i);
				Vector rowx = new Vector();
				if(customerId == customer.getOID())
					 index = i;
					 
				//rowx.add(strCustomerType[customer.getType()]);
	
				try{
					if(customer.getType()==0){
						String str = customer.getName();
						if(customer.getLastName().length()>0){
							str = str +" "+((customer.getMiddleName()==null || customer.getMiddleName().length()==0) ? "" : customer.getMiddleName()) + " "+customer.getLastName();
						}
						else{
							str = str + " "+((customer.getMiddleName()==null || customer.getMiddleName().length()>0) ? "" : customer.getMiddleName());
						}
						rowx.add(str+((customer.getSalutation().length()==0) ? "" : ", "+customer.getSalutation()));
					}
					else{
						rowx.add(customer.getName()+((customer.getSalutation().length()==0) ? "" : ", "+customer.getSalutation()));
					}
				}
				catch(Exception ex){
					System.out.println("ex : "+ex.toString());
				}
	
				//rowx.add((customer.getDobIgnore()==0) ? JSPFormater.formatDate(customer.getDob(),"dd MMMM yy") : "");
				
				rowx.add(customer.getAddress()+((customer.getCity()==null || customer.getCity().length()<1) ? "" : ", "+customer.getCity()) + ((customer.getState()==null || customer.getState().length()<1) ? "" : ", "+customer.getState()));
	
				rowx.add((customer.getCountryName()==null) ? "" : customer.getCountryName());
	
				rowx.add(((customer.getPhoneArea()!=null && customer.getPhoneArea().length()==0 && customer.getPhone()!=null && customer.getPhone().length()==0) ? "-" : (customer.getPhoneArea()+" "+customer.getPhone()))+"/"+((customer.getFaxArea().length()==0 && customer.getFax().length()==0)? "-" : customer.getFaxArea()+" "+customer.getFax()));
	
				//rowx.add((customer.getIdNumber()==null || customer.getIdNumber().length()<1) ? "" : (customer.getIdType()+"/"+customer.getIdNumber()));
	
				lstData.add(rowx);
				lstLinkData.add(String.valueOf(customer.getOID())+"','"+customer.getType());
			}
			catch(Exception e){
				System.out.println("e. "+e.toString());
			}
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

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "code, name";

SrcCustomer srcCus = new SrcCustomer();
if(iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.FIRST  || iJSPCommand==JSPCommand.NEXT || 
		iJSPCommand==JSPCommand.LAST || iJSPCommand==JSPCommand.PREV || iJSPCommand==JSPCommand.BACK){
		
	try{
		if(iJSPCommand!=JSPCommand.BACK){
			srcCus.setName(JSPRequestValue.requestString(request, "src_name"));
			srcCus.setAddress(JSPRequestValue.requestString(request, "src_address"));
			srcCus.setCountry(JSPRequestValue.requestString(request, "src_country"));
			srcCus.setNationality(JSPRequestValue.requestString(request, "src_nationality"));
			srcCus.setDobFrom(JSPRequestValue.requestString(request, "src_dobfrom"));
			srcCus.setDobTo(JSPRequestValue.requestString(request, "src_dobto"));
			srcCus.setDobIgnore(1);//JSPRequestValue.requestInt(request, "src_dobignore"));
			
			/*out.println("srcCus.setName : "+srcCus.getName());
			out.println("<br>srcCus.setAddress : "+srcCus.getAddress());
			out.println("<br>srcCus.setCountry : "+srcCus.getCountry());
			out.println("<br>srcCus.setNationality : "+srcCus.getNationality());
			out.println("<br>srcCus.setDobFrom : "+srcCus.getDobFrom());
			out.println("<br>srcCus.setDobTo : "+srcCus.getDobTo());
			out.println("<br>srcCus.setDobIgnore : "+srcCus.getDobIgnore());
			*/
		}
		else{
			srcCus = ((SrcCustomer)session.getValue("SRC_CUS")==null) ? new SrcCustomer() : (SrcCustomer)session.getValue("SRC_CUS");
		}
		
	}
	catch(Exception e){
	}
	
	if(srcCus.getName().length()>0){
		whereClause = "upper(name) like upper('%"+srcCus.getName()+"%')";
	}
	if(srcCus.getAddress().length()>0){
		whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + "(upper(address) like upper('%"+srcCus.getAddress()+"%') or upper(city ) like upper('%"+srcCus.getAddress()+"%')"+
			" or upper(state) like upper('%"+srcCus.getAddress()+"%'))";
	}
	if(srcCus.getCountry().length()>0){
		whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + "(upper(country_name) like upper('%"+srcCus.getCountry()+"%'))";
	}
	if(srcCus.getNationality().length()>0){
		whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + "(upper(nationality_name) like upper('%"+srcCus.getNationality()+"%'))";
	}
	if(srcCus.getDobIgnore()==0){
		whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + 
			"(dob >= '"+JSPFormater.formatDate(JSPFormater.formatDate(srcCus.getDobFrom(), "dd/MM/yyyy"), "yyyy-MM-dd")+"' and  "+
			"dob <= '"+JSPFormater.formatDate(JSPFormater.formatDate(srcCus.getDobTo(), "dd/MM/yyyy"), "yyyy-MM-dd")+"')";
	}
	
	session.putValue("SRC_CUS", srcCus);
		
}

//out.println(whereClause);

CmdCustomer cmdCustomer = new CmdCustomer(request);
JSPLine ctrLine = new JSPLine();
Vector listCustomer = new Vector(1,1);

/*switch statement */
iErrCode = cmdCustomer.action(iJSPCommand , oidCustomer);
/* end switch*/
JspCustomer jspCustomer = cmdCustomer.getForm();

/*count list All Customer*/
int vectSize = DbCustomer.getCount(whereClause);

Customer customer = cmdCustomer.getCustomer();
msgString =  cmdCustomer.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = cmdCustomer.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCustomer = DbCustomer.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCustomer.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCustomer = DbCustomer.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
	  	
<%if(!custNewPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>	  	
		
function cmdResetX(){
	document.frmcustomer.src_name.value="";
	document.frmcustomer.src_address.value="";
	document.frmcustomer.src_country.value="";
	//document.frmcustomer.src_nationality.value="";
	//document.frmcustomer.src_dobfrom.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
	//document.frmcustomer.src_dobto.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
	//document.frmcustomer.src_dobignore.checked;
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
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer, type){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	if(parseInt(type)==0){	
		document.frmcustomer.action="customeredt.jsp";
	}
	else{
		document.frmcustomer.action="customeredtcompg.jsp";
	}
	document.frmcustomer.submit();
}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
}

function cmdSearch(){
	document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcustomer.action="customerpg.jsp";
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

</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                <form name="frmcustomer" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                  <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Project</font><font class="tit1"> 
                                                              &raquo; </font></b><b><font class="tit1"><span class="lvl2">Data 
                                                              Query<br>
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
                                                    <tr align="left" valign="top"> 
                                                      <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr  id="searching"> 
                                                            <td height="14" valign="top" colspan="3" class="comment" width="99%"> 
                                                              <table width="70%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="10%" height="8"></td>
                                                                  <td width="41%" height="8"></td>
                                                                  <td width="16%" height="8"></td>
                                                                  <td width="33%" height="8"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="4"><b>Please 
                                                                    fill in search 
                                                                    Parameter</b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%">Name</td>
                                                                  <td width="41%"> 
                                                                    <input type="text" name="src_name"  value="<%= srcCus.getName() %>" class="formElemen" size="30">
                                                                  </td>
                                                                  <td width="16%">Address/City/State</td>
                                                                  <td width="33%"> 
                                                                    <input type="text" name="src_address"  value="<%= srcCus.getAddress() %>" class="formElemen" size="35">
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%">Country</td>
                                                                  <td width="41%"> 
                                                                    <input type="text" name="src_country"  value="<%= srcCus.getCountry() %>" class="formElemen" size="30">
                                                                  </td>
                                                                  <td width="16%">&nbsp;</td>
                                                                  <td width="33%">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="41%"> 
                                                                    <input type="button" name="Button" value="Search" onClick="javascript:cmdSearch()">
                                                                    <input type="button" name="Button" value="Reset" onClick="javascript:cmdResetX()">
                                                                  </td>
                                                                  <td width="16%">&nbsp;</td>
                                                                  <td width="33%">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%">&nbsp;</td>
                                                                  <td width="41%">&nbsp;</td>
                                                                  <td width="16%">&nbsp;</td>
                                                                  <td width="33%">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="3" valign="middle" colspan="3" class="comment" width="99%" background="../images/line.gif"></td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="7" valign="middle" colspan="3" width="99%"></td>
                                                          </tr>
                                                          <%
							try{
								if (listCustomer.size()>0){
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="3" width="99%"> 
                                                              <%= drawList(listCustomer,oidCustomer)%> </td>
                                                          </tr>
                                                          <%  } 
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
                                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="10" valign="middle" colspan="3" width="99%">&nbsp;</td>
                                                          </tr>
                                                          <!--tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" width="99%"><a href="javascript:cmdAdd()" class="command"></a><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" border="0" width="71" height="22"></a></td>
                                  </tr-->
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp; 
                                                      </td>
                                                    </tr>
                                                  </table>
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
