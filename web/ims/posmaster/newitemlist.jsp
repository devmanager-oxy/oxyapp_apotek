<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %> 
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
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

	public String drawList(Vector objectClass, int start)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","4%");
		cmdist.addHeader("Barcode","8%");
		cmdist.addHeader("SKU","8%");
		cmdist.addHeader("Item Name","30%");
                cmdist.addHeader("gol1","10%");
		cmdist.addHeader("gol2","10%");
                cmdist.addHeader("gol3","10%");
                cmdist.addHeader("gol4","10%");
                cmdist.addHeader("gol5","10%");
                cmdist.addHeader("gol6","10%");
                cmdist.addHeader("gol7","10%");
                cmdist.addHeader("gol8","10%");
                cmdist.addHeader("gol9","10%");
                cmdist.addHeader("gol10","10%");

		//cmdist.setLinkRow(1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		//cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			//PriceType priceType = (PriceType)objectClass.get(i);
                        ItemMaster im = (ItemMaster)objectClass.get(i);
			Vector rowx = new Vector();

                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");         
						
		        PriceType priceType = new PriceType();
                        try{
                            priceType= DbPriceType.getPriceType(im.getOID());
                        }catch(Exception ex){
                            
                        }
                        rowx.add(""+im.getBarcode());
                        rowx.add(""+im.getCode());
                        rowx.add(""+im.getName());
                        rowx.add("<div align=\"right\">"+priceType.getGol1()+"</div>");
			rowx.add("<div align=\"right\">"+priceType.getGol2()+"</div>");
                        rowx.add("<div align=\"right\">"+priceType.getGol3()+"</div>");
                        rowx.add("<div align=\"right\">"+priceType.getGol4()+"</div>");
                        rowx.add("<div align=\"right\">"+priceType.getGol5()+"</div>");                                         
                        rowx.add("<div align=\"right\">"+priceType.getGol6()+"</div>");                                         
                        rowx.add("<div align=\"right\">"+priceType.getGol7()+"</div>");                                         
                        rowx.add("<div align=\"right\">"+priceType.getGol8()+"</div>");                                         
                        rowx.add("<div align=\"right\">"+priceType.getGol9()+"</div>");                                         
                        rowx.add("<div align=\"right\">"+priceType.getGol10()+"</div>");                                         
			

                        lstData.add(rowx);
			lstLinkData.add(String.valueOf(priceType.getOID()));
		}

		return cmdist.draw(index);
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
long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");

long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
String srcStatus = JSPRequestValue.requestString(request, "src_status");
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
//int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
 


Date srcStartDate = new Date();
Date srcEndDate = new Date();
//if(iJSPCommand==JSPCommand.NONE){
	//srcIgnore = 1;
//}
//if(srcIgnore==0){
	srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
	srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
//}



/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

//if(srcVendorId!=0){
//	whereClause = DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+srcVendorId;	
//}
//if(srcStatus!=null && srcStatus.length()>0){
	//if(whereClause.length()>0){
	///	whereClause = whereClause + " and "+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+srcStatus+"'";	
	//}
	//else{
	//	whereClause = DbReceive.colNames[DbReceive.COL_STATUS]+"='"+srcStatus+"'";	
	//}
//}
if(iJSPCommand!=JSPCommand.NONE){
	if(whereClause.length()>0){
		whereClause = whereClause + " and (to_days("+DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
	else{
		whereClause = "(to_days("+DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
}
//if(srcIncomingNumber.length()>0){
//	if(whereClause.length()>0){
//		whereClause = whereClause + " and ";
//	}
	
	//whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NUMBER]+ " like '%"+srcIncomingNumber+"%'";
	
//}

//if(whereClause.length()>0){
//    whereClause = whereClause + " and " + DbItemMaster.colNames[DbItemMaster.COL_TYPE] + " = " + DbItemMaster.TYPE_NON_CONSIGMENT;
//}else{
 //   whereClause = DbItemMaster.colNames[DbItemMaster.COL_TYPE] + " = " + DbItemMaster.TYPE_NON_CONSIGMENT;    
//}
        





CmdItemMaster cmdItemMaster = new CmdItemMaster(request);
JSPLine ctrLine = new JSPLine();
Vector listNewItem = new Vector(1,1);

/*switch statement */
iErrCode = cmdItemMaster.action(iJSPCommand , oidReceive);
/* end switch*/
JspItemMaster jspItemMaster = cmdItemMaster.getForm();

/*count list All Receive*/
int vectSize=0;
if(iJSPCommand!=JSPCommand.NONE){
    vectSize = DbItemMaster.getCount(whereClause);
}
ItemMaster itemMaster = cmdItemMaster.getItemMaster();
msgString =  cmdItemMaster.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//orderClause = DbItemMaster.colNames[DbItemMaster.COL_NUMBER];
if(iJSPCommand!=JSPCommand.NONE){
    listNewItem = DbItemMaster.list(start,recordToGet, whereClause , orderClause);
}

if(iJSPCommand!=JSPCommand.NONE){
    Vector vlist = DbItemMaster.list(0,0, whereClause , orderClause);
    Vector vr = new Vector();
    if(vlist.size()>0){
        PriceType pt = new PriceType();
        ItemMaster im = new  ItemMaster();
        for(int i=0;i<vlist.size();i++){
            RptChangePriceL pl = new RptChangePriceL();


            //pt = (PriceType) vlist.get(i);
            
            im = (ItemMaster) vlist.get(i);
            
            try{
                pt=DbPriceType.getPriceType(im.getOID());
            }catch(Exception ex){

            }
            
            
            pl.setDate(im.getRegisterDate());
            pl.setBarcode(im.getBarcode());
            pl.setCode(im.getCode());
            pl.setName(im.getName());
            pl.setGol1(pt.getGol1());
            pl.setGol2(pt.getGol2());
            pl.setGol3(pt.getGol3());
            pl.setGol4(pt.getGol4());
            pl.setGol5(pt.getGol5());
            pl.setGol6(pt.getGol6());
            pl.setGol7(pt.getGol7());
            pl.setGol8(pt.getGol8());
            pl.setGol9(pt.getGol9());
            pl.setGol10(pt.getGol10());  			
            vr.add(pl);

        }
        session.putValue("DETAIL", vr);
    }
}
/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listNewItem.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listNewItem = DbItemMaster.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
function cmdSearch(){
	document.frmreceive.command.value="<%=JSPCommand.LIST%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
}

function cmdPrintXLS(){	 
            window.open("<%=printroot%>.report.RptNewItemListXLS?idx=<%=System.currentTimeMillis()%>");
        }
                
function cmdEdit(oid){
	document.frmreceive.hidden_receive_id.value=oid;
	
	document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
}

function cmdAdd(){
	document.frmreceive.hidden_receive_id.value="0";
	document.frmreceive.command.value="<%=JSPCommand.ADD%>";
	document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
	document.frmreceive.action="pricechangelist.jsp";
	document.frmreceive.submit();
}

function cmdListFirst(){
	document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
}

function cmdListPrev(){
	document.frmreceive.command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
	}

function cmdListNext(){
	document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
}

function cmdListLast(){
	document.frmreceive.command.value="<%=JSPCommand.LAST%>";
	document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmreceive.action="newitemlist.jsp";
	document.frmreceive.submit();
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
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmreceive" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master Maintenance
                                      </font><font class="tit1">&raquo; <span class="lvl2">New Item List
                                       
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
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabin" nowrap> 
                                              <div align="center">&nbsp;&nbsp;<a href="javascript:cmdAdd()" class="tablink">Price Change&nbsp;&nbsp;</a></div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;New Item List</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                              <tr> 
                                                <td colspan="2"><b><i>Search Parameters 
                                                  :</i></b></td>
                                              </tr>
                                              
                                              <tr> 
                                                <td width="10%">Date</td>
                                                <td width="90%"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  
                                                  </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                <td width="90%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="90%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listNewItem.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listNewItem,start)%> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
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
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
