 
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
<%//@ include file="../calendar/calendarframe.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String getPerusahaan(Vector perusahaans, long indukUsahaOid){
	   if(perusahaans!=null && perusahaans.size()>0){
			for(int i=0; i<perusahaans.size(); i++){
				IndukCustomer indukCustomer = (IndukCustomer)perusahaans.get(i);
				if(indukUsahaOid==indukCustomer.getOID()){
					return indukCustomer.getName();
				}
			}
		}
		return "";
	}

	public String drawList(int start, Vector objectClass ,  Vector indukCustomers, long customerId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","5%");
		cmdist.addHeader("Sarana","20%");
		cmdist.addHeader("Investor","20%");
		cmdist.addHeader("Alamat","20%");
		cmdist.addHeader("Telp","15%");
		cmdist.addHeader("Kontak","25%");
		//cmdist.addHeader("WebSite","10%");
		//cmdist.addHeader("Email","10%");

		cmdist.setLinkRow(1);
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
			
			rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");
			rowx.add(customer.getName());
			rowx.add(getPerusahaan(indukCustomers, customer.getIndukCustomerId()));
			rowx.add(customer.getAddress1());
			rowx.add(customer.getCountryCode()+" "+customer.getAreaCode()+" "+customer.getPhone());
			rowx.add(customer.getContactPerson());
			//rowx.add(customer.getWebsite());
			//rowx.add(customer.getEmail());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(customer.getOID()));
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
int recordToGet = 20;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

// for pencarian data
SrcCustomer srcCus = new SrcCustomer();
if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.FIRST  || 
	iJSPCommand==JSPCommand.NEXT || 
		iJSPCommand==JSPCommand.LAST || iJSPCommand==JSPCommand.PREV || iJSPCommand==JSPCommand.BACK){		
	try{
		if(iJSPCommand!=JSPCommand.BACK){
			srcCus.setName(JSPRequestValue.requestString(request, "src_name"));
		}
		else{
			srcCus = ((SrcCustomer)session.getValue("SRC_UNIT_USAHA")==null) ? new SrcCustomer() : (SrcCustomer)session.getValue("SRC_UNIT_USAHA");
		}		
	}catch(Exception e){}
	
	if(srcCus.getName().length()>0){
		whereClause = "upper(name) like upper('%"+srcCus.getName()+"%')";
	}
	session.putValue("SRC_UNIT_USAHA", srcCus);
}

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

Vector indukCustomers = DbIndukCustomer.list(0,0,"","");
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function unitusahaedit(){
	document.frmcustomer.hidden_customer_id.value=0;
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

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
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
	}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdSearch(){
	document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcustomer.action="customer.jsp";
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

</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --> 
                        <%
                        String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Customer</span></font>";
			%>
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcustomer" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">                            						
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top">
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top">
                                    <td valign="middle" colspan="3"><table width="70%" border="0" cellspacing="1" cellpadding="1">
                                      
                                      <tr>
                                        <td colspan="3"><b><u>Pencarian</u></b></td>
                                      </tr>
                                      <tr>
                                          <td width="15%" nowrap>Nama Sarana&nbsp;</td>
                                        <td width="30%"><input type="text" name="src_name"  value="<%= srcCus.getName() %>" class="formElemen" size="30">                                        </td>
                                        <td width="55%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                        </tr>
                                      
                                      
                                    </table></td>
                                  </tr>
                                  <%
							try{
								if (listCustomer.size()>0){
							%>
                                  <tr align="left" valign="top">
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3" width="99%"> 
                                      <%= drawList(start, listCustomer,indukCustomers,oidCustomer)%> </td>
                                  </tr>
                                  <%  } 
						  }catch(Exception exc){ 
						  }%>
                                  <tr align="left" valign="top">
                                    <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                  </tr>
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
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" width="99%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>
