<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.*" %>

<%@ page import = "java.util.Date" %>

    <% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/check.jsp" %>
<%
String approot = "";
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
	public Vector drawList(Vector objectClass, int start){
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		
		cmdist.addHeader("No","5%");
		cmdist.addHeader("Lokasi","20%");
		cmdist.addHeader("Kode Barang","10%");
		cmdist.addHeader("Keterangan","25%");
		cmdist.addHeader("Stok","10%");
		cmdist.addHeader("Harga Jual","10%");

		cmdist.setLinkRow(-1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
		
		Vector temp = new Vector();
		double totalamount = 0.0;
		double ttAmount = 0.0;
		double totPrice = 0.0;

		for (int i = 0; i < objectClass.size(); i++) {
			SrcStockReportL stockReportL = (SrcStockReportL)objectClass.get(i);
			
			Vector rowx = new Vector();

            rowx.add("<div align=\"center\">"+(i+1)+"</div>");
			rowx.add(""+stockReportL.getLocationName());
			rowx.add(""+stockReportL.getCode());
			rowx.add(""+stockReportL.getDescription());			
			rowx.add("<div align=\"right\">"+stockReportL.getQty()+"</div>");			
			totPrice = DbPriceType.getPrice(1, "gol_1", stockReportL.getItemMasterId());
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(totPrice, "#,##0")+"</div>");
			lstData.add(rowx);
			temp.add(stockReportL);
			lstLinkData.add(String.valueOf(-1));
		}
		
		//return cmdist.draw(index);
		Vector vx = new Vector();
		vx.add(cmdist.draw(index));
		vx.add(temp);
		return  vx;
	}

%>
<%
	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}
	
	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");

long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
long srcGroupId = JSPRequestValue.requestLong(request, "src_group_id");
int orderBy = JSPRequestValue.requestInt(request, "order_by");
String srcCode = JSPRequestValue.requestString(request, "src_code");
String srcName = JSPRequestValue.requestString(request, "src_name");


/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";
int vectSize = 0;

JSPLine ctrLine = new JSPLine();
Vector listReport = new Vector(1,1);

//get value for report
SrcStockReport rptKonstan = new SrcStockReport();
if(iJSPCommand!=JSPCommand.NONE){
	listReport = SessStockReport.getItemStock(srcCode, srcName, srcLocationId, srcGroupId, orderBy,DbStock.TYPE_NON_CONSIGMENT);
}
%>
<html >
<head>
 
<title>OXY Retail</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
function cmdSearch(){
	document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
	document.frmadjusment.action="stock-location.jsp";
	document.frmadjusment.submit();
}

function cmdListFirst(){
	document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.action="stock-location.jsp";
	document.frmadjusment.submit();
}

function cmdListPrev(){
	document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.action="stock-location.jsp";
	document.frmadjusment.submit();
	}

function cmdListNext(){
	document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.action="stock-location.jsp";
	document.frmadjusment.submit();
}

function cmdListLast(){
	document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.action="stock-location.jsp";
	document.frmadjusment.submit();
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

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="100%" height="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td> 
                        <form name="frmadjusment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="5"  colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td width="15%" nowrap class="tab"> 
                                          <div align="center">&nbsp;Pencarian Barang &nbsp;&nbsp;</div>                                          </td>
                                          <td width="85%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle"> 
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                              
                                              <tr> 
                                                <td width="14%">Kode Barang </td>
                                                <td width="23%"> 
                                                  <input type="text" name="src_code" value="<%=srcCode%>" size="30">                                                </td>
                                                <td width="14%" align="right">Grup Barang </td>
                                                <td width="49%">
												  <%
												  Vector groups = DbItemGroup.list(0,0,"", "name");
												  %>	 
                                                  <select name="src_group_id">
												  	<option value="0" <%if(srcGroupId==0){%>selected<%}%>>- All -</option>
												  	<%if(groups!=null && groups.size()>0){
													for(int i=0; i<groups.size(); i++){
														ItemGroup ig = (ItemGroup)groups.get(i);
													%>
                                                    <option value="<%=ig.getOID()%>" <%if(srcGroupId==ig.getOID()){%>selected<%}%>><%=ig.getName()%></option>
													<%}}%>
                                                  </select>                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">Nama Barang </td>
                                                <td width="23%"> 
                                                  <input type="text" name="src_name" value="<%=srcName%>" size="30">                                                </td>
                                                <td width="14%" align="right">Urut Berdasarkan </td>
                                                <td width="49%"><select name="order_by">
                                                  <option value="0" <%if(orderBy==0){%>selected<%}%>>LOCATION</option>
                                                  <option value="1" <%if(orderBy==1){%>selected<%}%>>ITEM CODE</option>
                                                  <option value="2" <%if(orderBy==2){%>selected<%}%>>ITEM NAME</option>
                                                  <option value="3" <%if(orderBy==3){%>selected<%}%>>ITEM CATEGORY</option>
                                                </select></td>
                                              </tr>
                                              <tr>
                                                <td>Lokasi</td>
                                                <td><select name="src_location_id">
                                                  <%
														//if(srcLocationId==0){
														//	rptKonstan.setLocation("- All -");
														//}
													%>
                                                  <!--option value="0" <%if(srcLocationId==0){%>selected<%}%>>- 
                                                    All -</option-->
                                                  <option value="1" <%if(srcLocationId==1){%>selected<%}%>>- 
                                                    GROUP BY LOCATION -</option>
                                                  <%
													Vector locations = DbLocation.list(0,0, "", "name");
												    if(locations!=null && locations.size()>0){
														 for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															String str = "";
															if(srcLocationId==d.getOID()){
																rptKonstan.setLocation(d.getName());
															}
													%>
                                                  <option value="<%=d.getOID()%>" <%if(srcLocationId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                  <%}}%>
                                                </select></td>
                                                <td align="right">&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="14%" align="right">&nbsp;</td>
                                                <td width="49%">&nbsp;</td>
                                              </tr>
                                              
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                              </tr>
                                            </table>                                          </td>
                                        </tr>
                                        <%
							try{
								if (listReport.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle"> 
                                            <%
										  	Vector x = drawList(listReport,start);
											String strTampil = (String)x.get(0);
											Vector rptObj = (Vector)x.get(1);
										  %>
                                            <%=strTampil%> 
                                            <%
												session.putValue("DETAIL", rptObj);
											%>                                          </td>
                                        </tr>
                                        
                                        <%  } 
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" class="command"> 
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
                                      </table>                                    </td>
                                  </tr>
                                </table>                              </td>
                            </tr>
                          </table>
                        </form>                        </td>
                    </tr>
                  </table>                </td>
              </tr>
            </table>          </td>
        </tr>
    </table></td>
  </tr>
</table>
</body>
</html>
