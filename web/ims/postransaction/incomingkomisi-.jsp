 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
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

	public Vector drawList(Vector objectClass, long vendorId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell1");
		jsplist.setCellStyle1("tablecell");
		jsplist.setHeaderStyle("tablehdr");
		
                
                
                jsplist.addHeader("No","5%");
                jsplist.addHeader("Code","10%");
                jsplist.addHeader("Item Name","30%");
                jsplist.addHeader("Price","30%");
                jsplist.addHeader("Margin(%)","10%");
                jsplist.addHeader("Total Price","20%");
                jsplist.addHeader("Select","20%");
                
                

		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		
		//jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;
                
                
                    Vector tempig = new Vector();
                    Vector temp = new Vector();
                                
                int jum=0;
                          
		for (int i = 0; i < objectClass.size(); i++){
			Vector vdet = new Vector();
                        vdet = (Vector)objectClass.get(i);
                        //RptOrder detail = new RptOrder();
                        ItemMaster im = new ItemMaster();
                            try{
                                im = DbItemMaster.fetchExc(Long.valueOf(vdet.get(0).toString()));
                            }catch(Exception ex){
                                
                            }
                            Vendor ven = new Vendor();
                            try{
                                ven = DbVendor.fetchExc(vendorId);
                            }catch(Exception ex){
                                
                            }
                            
                            jum = jum+1;
                            Vector rowx = new Vector();
                            Location loc = new Location();
                            double totalPrice = 0;
                            rowx.add("<div align=\"center\">"+""+jum+"</div>");
                            rowx.add(im.getCode());
                            rowx.add(im.getName());
                            rowx.add("<div align=\"right\">"+ JSPFormater.formatNumber(Double.parseDouble(vdet.get(1).toString()), "###,###.##")+"</div>");//qty
                            rowx.add("<div align=\"center\">"+""+ven.getKomisiMargin()+"</div>");
                            
                            totalPrice = (Double.parseDouble(vdet.get(1).toString()))- ((Double.parseDouble(vdet.get(1).toString())) * ven.getKomisiMargin() / 100 );
                            
                            rowx.add("<div align=\"right\">"+ JSPFormater.formatNumber(totalPrice, "###,###.##")+"</div>" );//qty
                            rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"oid_"+im.getOID()+ "\" value=\"1\" >" + "<input type=\"hidden\" size=\"20\" name=\"total_"+im.getOID()+ "\" value=\""+totalPrice+"\" >" +  "</div>");
                            lstData.add(rowx);
                                     
                        
		}
                //session.putValue("DETAIL", vdet);

                 Vector v = new Vector();
                v.add(jsplist.draw(index));
               
                
                return v;    
		//return jsplist.draw(index);
	}

%>
<%

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");


long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
                           
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
//-----------------------------------------------------------------------------

Date srcStartDate = new Date();
Date srcEndDate = new Date();

	srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
	srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");



/*variable declaration*/
int recordToGet = 0;
String whereClause = "";
String orderClause = "";


if(srcLocationId!=0){
        whereClause = "s."+ DbSales.colNames[DbSales.COL_LOCATION_ID]+"="+srcLocationId;
}
if(srcVendorId!=0){
    if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " sd.status_komisi=0 and sd.product_master_id in (select item_master_id from pos_item_master where default_vendor_id="+ srcVendorId + ")";
}

if(whereClause.length()>0){
		whereClause = whereClause + " and (to_days(s."+ DbSales.colNames[DbSales.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
}else{
		whereClause = "(to_days(s."+DbSales.colNames[DbSales.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
}





CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
JSPLine jspLine = new JSPLine();
Vector listKomisiItem = new Vector(1,1);
if(iJSPCommand==JSPCommand.SEARCH || iJSPCommand==JSPCommand.SAVE ){
    listKomisiItem = DbReceiveItem.getReceiveKomisi(whereClause);
}

JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

/*count list All ItemMaster*/
int vectSize =0;
long oidRec = 0;    
ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
//msgString =  ctrlItemMaster.getMessage();

if (iJSPCommand == JSPCommand.SAVE){
        Vector vitem = new Vector();
         Vector vv = new Vector();
       for(int i=0;i<listKomisiItem.size();i++){
         Vector v = new Vector(); 
         
         v = (Vector)listKomisiItem.get(i);
         long oidItemMaster = Long.parseLong(v.get(0).toString());
         long yy = JSPRequestValue.requestLong(request, "oid_" + v.get(0));   
         double total = JSPRequestValue.requestDouble(request, "total_" + v.get(0));   
         if(yy==1){
             ReceiveItem r = new ReceiveItem();
             r.setAmount(total);
             r.setItemMasterId(yy);
             r.setItemMasterId(oidItemMaster);
             r.setTotalAmount(total);
             vv.add(r);
         }
       }
        if(vv.size()>0){
                    
           int counter=0;
           Receive rec = new Receive();
           rec.setLocationId(srcLocationId);
           counter = DbReceive.getNextCounter()+1 ; 
           rec.setNumber(DbReceive.getNextNumber(counter));
           rec.setCounter(counter);
           rec.setDate(new Date());
           rec.setLocationId(srcLocationId);
           rec.setPrefixNumber(DbReceive.getNumberPrefix());
           rec.setStatus("DRAFT");
           rec.setUserId(user.getOID());
           rec.setVendorId(srcVendorId);
           
           
           try{
               oidRec = DbReceive.insertExc(rec);
           }catch(Exception ex){

           }
           //ReceiveItem ri = new ReceiveItem();
           if(oidRec !=0){
               for(int i=0;i<vv.size();i++){
                   ReceiveItem rii = new ReceiveItem();
                   rii= (ReceiveItem) vv.get(i);
                   rii.setReceiveId(oidRec);
                   try{
                       DbReceiveItem.insertExc(rii);
                   }catch(Exception ex){
                                            
                   }
                    String sql = "update pos_sales_detail set status_komisi=1 where sales_id in (select sales_id from pos_sales where to_days(date) >= to_days('"+ JSPFormater.formatDate(srcStartDate , "yyyy-MM-dd")+"') and to_days(date) <= to_days('"+ JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "') and location_id="+ srcLocationId + " ) and product_master_id = " + rii.getItemMasterId();
                    try{
                        DbReceiveItem.execUpdate(sql);
                    }catch(Exception ex){
                        
                    }
                    
              
           }
                
       }
}
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">
    
    
function cmdPrintXLS(){	 
        
            window.open("<%=printroot%>.report.RptPrintOrderXLS?idx=<%=System.currentTimeMillis()%>");
        } 
        
        


function cmdSearch(){
	//document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmorder.command.value="<%=JSPCommand.SEARCH%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
}

function cmdCheckOrder(){
    if(confirm('Pastikan parameter sudah benar')){
            //document.frmitemmaster.hidden_item_master_id.value="0";
            document.frmorder.command.value="<%=JSPCommand.GET%>";
            document.frmorder.prev_command.value="<%=prevJSPCommand%>";
            document.frmorder.action="incomingkomisi.jsp";
            document.frmorder.submit();
        }else{
            
        }
    
    
	
}
function cmdReceive(oidReceive){
        document.frmorder.hidden_receive_id.value=oidReceive;
        document.frmorder.command.value="<%=JSPCommand.EDIT%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="receiveitem.jsp";
	document.frmorder.submit();
}

function cmdAsk(oidItemMaster){
	document.frmorder.hidden_item_master_id.value=oidItemMaster;
	document.frmorder.command.value="<%=JSPCommand.ASK%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
}


function cmdSave(){
	document.frmorder.command.value="<%=JSPCommand.SAVE%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
	}

function cmdTransfer(oidTransfer){
        
	document.frmorder.hidden_transfer_id.value=oidTransfer;
	document.frmorder.command.value="<%=JSPCommand.EDIT%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
}

function cmdCancel(oidItemMaster){
	document.frmorder.hidden_item_master_id.value=oidItemMaster;
	document.frmorder.command.value="<%=JSPCommand.EDIT%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
}

function cmdBack(){
	document.frmorder.command.value="<%=JSPCommand.BACK%>";
	document.frmorder.action="incomingkomisi.jsp";
	document.frmorder.submit();
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
                        <form name="frmorder" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="hidden_receive_id" value="<%=oidRec%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                   
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Incoming Goods 
                                            </font><font class="tit1">&raquo; 
                                            </font><font class="tit1"><span class="lvl2">Incoming Komisi
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
                                  
                                  
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" colspan="3"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                    <tr> 
                                                      <td width="5%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="15%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7" nowrap><b><u>Search 
                                                        Option</u></b></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="15%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      
                                                     
                                                      <td width="6%">From Location</td>
                                                      <td width="15%">
                                                       
                                                  <select name="src_location_id">
                                                    
                                                    <%
													
													Vector vloc = DbLocation.list(0,0, "", "name");
													
												    if(vloc!=null && vloc.size()>0){
														 for(int i=0; i<vloc.size(); i++){
															Location loc = (Location)vloc.get(i);
															
													%>
                                                    <option value="<%=loc.getOID()%>" <%if(srcLocationId==loc.getOID()){%>selected<%}%>><%=loc.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>  
                                                      </td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                      <td width="5%">Vendor</td>
                                                      <td width="11%">
                                                          <select name="src_vendor_id">
                                                            <option value="0" <%if(srcVendorId==0){%>selected<%}%>>- 
                                                            All -</option>
                                                            <%

                                                                                                                Vector vendors = DbVendor.list(0,0, "is_komisi=1", "name");

                                                                                                            if(vendors!=null && vendors.size()>0){
                                                                                                                         for(int i=0; i<vendors.size(); i++){
                                                                                                                                Vendor d = (Vendor)vendors.get(i);
                                                                                                                                
                                                                                                                %>
                                                            <option value="<%=d.getOID()%>" <%if(srcVendorId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                                                                          
                                                      </td>
                                                     
                                                    </tr>
                                                    <tr> 
                                                <td width="9%">Date Between</td>
                                                <td width="91%"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  
                                                  &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  
                                                </td>
                                              </tr>
                                                    
                                                    <tr>
                                                      <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                    </tr>    
                                                    <tr> 
                                                      <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%
							try{
								if(listKomisiItem.size()>0 && iJSPCommand==JSPCommand.SEARCH){
					      %>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                <%
                                                Vector x = drawList(listKomisiItem, srcVendorId);
                                                 String strString = (String) x.get(0);
                                                  
                                                
                                                
                                                %>
                                                
                                                  <%=strString%> </td>
                                                  
                                              </tr>
                                              <%  }else if(iJSPCommand==JSPCommand.SEARCH){%>
                                                    <tr align="left" valign="top"> 
                                                    <td height="22" valign="middle" colspan="3"> 
                                                    <h3>TIDAK ADA DATA</h3>
                                                    </tr>                
                                              <%} 
						  }catch(Exception exc){ 
						  }%>
                                                   
                                                
                                               
                                              
                                              <tr align="left" valign="top"> 
                                                <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                              </tr>
                                              <% if(oidRec!=0){ %>
                                                 <script language="JavaScript">
                                                    cmdReceive('<%=oidRec%>')
                                                 </script>

                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                       
                                        <%if(listKomisiItem.size()>0){%>
                                         <tr> 
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <a href="javascript:cmdSave()">Create Incoming Komisi</a>
                                                        </td>
                                                        <td>
                                                            &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                             
                                                             
                                                        </td>
                                                        
                                                        
                                                    </tr>    
                                                </table>
                                                
                                            </td>
                                          </tr>
                                         <%}%> 
                                         <tr><td></td></tr>
                                        
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                       
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
    
  

</body>
<!-- #EndTemplate --></html>
