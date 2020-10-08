 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean payablePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE);
%>
<%
	//jsp content
	long vendorId = JSPRequestValue.requestLong(request, "vendor_id");

	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "status='OPEN'";	
	String orderClause = "journal_number";//trans_date";
	
	if(vendorId!=0){
		whereClause = whereClause + " and vendor_id="+vendorId;
	}
	
	//out.println(whereClause);


	int vectSize = DbPurchase.getCount(whereClause);
	
	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
	{
		CmdBankArchive cmdBankArchive = new CmdBankArchive(request);
		start = cmdBankArchive.actionList(iJSPCommand, start, vectSize, recordToGet);
//		out.println("ubah start "+iJSPCommand+" "+ start+" "+ vectSize+" "+ recordToGet);
	} 

	Vector listPurchases = new Vector();
	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST || iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.BACK))
	{
		 listPurchases= DbPurchase.list(start,recordToGet, whereClause , orderClause);
	}
	
	Vector vendors = DbVendor.list(0,0, "", "");

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

<%if(!payablePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdSearch(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="invoicesrc.jsp";
	document.form1.submit();
}

function cmdInvoice(oid){
	document.form1.hidden_po_id.value=oid;
	document.form1.command.value="<%=JSPCommand.NONE%>";
	document.form1.action="invoice_edit.jsp";
	document.form1.submit();
}

function cmdCheckVendor(){
	var v = document.form1.vendor_id.value;
	var found = false;
	<%
	
	if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor v = (Vendor)vendors.get(i);
	%>
		if('<%=v.getOID()%>'==v){
			document.form1.vendor_address.value="<%=v.getAddress() + ((v.getCity().length()>0) ? ", "+v.getCity() : "") + ((v.getState().length()>0) ? ", "+v.getState() : "") + ((v.getCountryName().length()>0) ? ", "+v.getCountryName() : "") %>";
			found = true;
		}
	<%}}%>
	
	//cmdSearch();
}

	function cmdListFirst(){
		document.form1.command.value="<%=JSPCommand.FIRST%>";
		document.form1.prev_command.value="<%=JSPCommand.FIRST%>";
		document.form1.action="invoicesrc.jsp";
		document.form1.submit();
	}

	function cmdListPrev(){
		document.form1.command.value="<%=JSPCommand.PREV%>";
		document.form1.prev_command.value="<%=JSPCommand.PREV%>";
		document.form1.action="invoicesrc.jsp";
		document.form1.submit();
		}

	function cmdListNext(){
		document.form1.command.value="<%=JSPCommand.NEXT%>";
		document.form1.prev_command.value="<%=JSPCommand.NEXT%>";
		document.form1.action="invoicesrc.jsp";
		document.form1.submit();
	}

	function cmdListLast(){
		document.form1.command.value="<%=JSPCommand.LAST%>";
		document.form1.prev_command.value="<%=JSPCommand.LAST%>";
		document.form1.action="invoicesrc.jsp";
		document.form1.submit();
	}

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
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
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Account 
                        Payable </span> &raquo; New Invoice &raquo; <span class="level2">Search 
                        for PO<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_po_id" value="">
						  <input type="hidden" name="start" value="<%=start%>">
						  <input type="hidden" name="prev_command" value="">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">Vendor</td>
                                    <td width="95%"> 
                                      <select name="vendor_id" onChange="javascript:cmdCheckVendor()">
                                        <%if(vendors!=null && vendors.size()>0){
											for(int i=0; i<vendors.size(); i++){
												Vendor v = (Vendor)vendors.get(i);
										%>
                                        <option value="<%=v.getOID()%>" <%if(v.getOID()==vendorId){%>selected<%}%>><%=v.getCode() + " - "+v.getName()%></option>
                                        <%}}%>
                                        <option>PT. Wahana Raya</option>
                                        <option>PT. Daksina</option>
                                        <option>...</option>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%"> 
                                      <textarea name="vendor_address" rows="3" cols="65" class="readonly" readOnly>Vendor address</textarea>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="5%" height="13">&nbsp;</td>
                                    <td width="95%" height="13">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2" class="boxed1"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="9%" class="tablehdr">PO Number</td>
                                          <td height="26" width="14%" class="tablehdr">Vendor</td>
                                          <td width="20%" class="tablehdr">Vendor 
                                            Address </td>
                                          <td width="6%" class="tablehdr">Currency</td>
                                          <td width="12%" class="tablehdr">Total</td>
                                          <td width="10%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="22%" class="tablehdr">Memo</td>
                                          <td width="7%" class="tablehdr">Status</td>
                                        </tr>
                                        <%												
													if(listPurchases!=null && listPurchases.size()>0)
													{
														for(int i=0; i<listPurchases.size(); i++)
														{															
															Purchase bd = (Purchase)listPurchases.get(i);
															//out.println("i = "+i);

															Vendor vnd = new Vendor();
															try{
																vnd = DbVendor.fetchExc(bd.getVendorId());
															}
															catch(Exception e){
															}
															
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="9%"><a href="javascript:cmdInvoice('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="14%"><%=vnd.getCode()+" - "+vnd.getName()%></td>
                                          <td class="tablecell" width="20%"><%=vnd.getAddress()%></td>
                                          <td class="tablecell" width="6%"> 
                                            <div align="center"> 
                                              <%
										  Currency c = new Currency();
										  try{
										  		c = DbCurrency.fetchExc(bd.getCurrencyId());
										  }
										  catch(Exception e){
										  }
										  %>
                                              <%=c.getCurrencyCode()%> </div>
                                          </td>
                                          <td class="tablecell" width="12%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getTotal(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="22%"><%=bd.getMemo()%></td>
                                          <td class="tablecell" width="7%"> 
                                            <div align="center"><%=bd.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="9%"><a href="javascript:cmdInvoice('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="14%"><%=vnd.getCode()+" - "+vnd.getName()%></td>
                                          <td class="tablecell1" width="20%"><%=vnd.getAddress()%></td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center"> 
                                              <%
										  Currency c = new Currency();
										  try{
										  		c = DbCurrency.fetchExc(bd.getCurrencyId());
										  }
										  catch(Exception e){
										  }
										  %>
                                              <%=c.getCurrencyCode()%></div>
                                          </td>
                                          <td class="tablecell1" width="12%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getTotal(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="22%"><%=bd.getMemo()%></td>
                                          <td class="tablecell1" width="7%"> 
                                            <div align="center"><%=bd.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%
															}
															
														}
													}else{%>
                                        <tr> 
                                          <td class="tablecell1" colspan="8" height="25"> 
                                            <%if(iJSPCommand==JSPCommand.NONE){%>
                                            Please click the search button to 
                                            find your data. 
                                            <%}else{%>
                                            Data is empty. 
                                            <%}%>
                                          </td>
                                        </tr>
                                        <%}
																					
											%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><span class="command"> 
                                      <% 
											int cmd = 0;
											if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) 
												cmd = iJSPCommand; 
											else
											{
												if(iJSPCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
													cmd = JSPCommand.FIRST;
												else 
													cmd = prevCommand; 
											} 
											
											JSPLine jspLine = new JSPLine();
											
											jspLine.setLocationImg(approot+"/images/ctr_line");
											jspLine.initDefault();
											
											jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
										   jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
										   jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
										   jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
										   
										   jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
										   jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
										   jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
										   jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
										   
										   
										   if(listPurchases!=null && listPurchases.size()>0){
										%>
                                      <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                      <%}%>
                                      </span></td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="95%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
							cmdCheckVendor();
							<%if(iJSPCommand==JSPCommand.NONE){%>
								cmdSearch();
							<%}%>
						  </script>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
