
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_LOCATION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%

            int salesType = JSPRequestValue.requestInt(request, "sales_type");
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            String number = JSPRequestValue.requestString(request, "number").trim();
            int allLocation = JSPRequestValue.requestInt(request, "all_location");
            if (session.getValue("REPORT_SALES_LOCATION") != null) {
                session.removeValue("REPORT_SALES_LOCATION");
            }
            if (session.getValue("VECTOR_LOCATION") != null) {
                session.removeValue("VECTOR_LOCATION");
            }

            if (iJSPCommand == JSPCommand.NONE) {
                salesType = -1;
            }

            String whereClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }
            Vector listSales = new Vector();
            
            String whereLoc="";
            Vector vLocSelected= new Vector();
             if (userLocations != null && userLocations.size() > 0) {
                    for (int i = 0; i < userLocations.size(); i++) {
                        Location ic = (Location) userLocations.get(i);
                        
                        
                        int ok = JSPRequestValue.requestInt(request, "location_id" + ic.getOID());
                        if (ok == 1){
                            vLocSelected.add(ic);
                            if (whereLoc != null && whereLoc.length() > 0) {
                                whereLoc = whereLoc + ",";
                            }
                            whereLoc = whereLoc + ic.getOID();
                        }
                    }
                    

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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>                
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.RptSalesLocationXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                }
                 function setCheckedLocation(val){
                     <%
                    for (int k = 0; k < userLocations.size(); k++) {
                    Location ic = (Location) userLocations.get(k);
                    %>
                        document.frmsales.location_id<%=ic.getOID()%>.checked=val.checked;

                    <%}%>
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
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
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Report by Location<br>
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
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td >                                                                                                                                                
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="4" height="10"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td colspan="3" height="14" class="fontarial"><i><b>Searching Parameter :</b></i></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td width="100" nowrap class="tablearialcell">&nbsp;&nbsp;Date Between</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td > 
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>
                                                                                                                                                                    <td class="fontarial">
                                                                                                                                                                        &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                                    </td>    
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>       
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablearialcell" >&nbsp;&nbsp;Cashier Location</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                         <td  >                                                                                                                                                             
                                                                                                                                                            <%
                                                                                                                                                             if (userLocations != null && userLocations.size() > 0) {
                                                                                                                                                            %>
                                                                                                                                                            <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <%
                                                                                                                                                                int x = 0;
                                                                                                                                                                boolean ok = true;
                                                                                                                                                                while (ok) {

                                                                                                                                                                    for (int t = 0; t < 5; t++) {
                                                                                                                                                                        Location ic = new Location();
                                                                                                                                                                        try {
                                                                                                                                                                            ic = (Location) userLocations.get(x);
                                                                                                                                                                        } catch (Exception e) {
                                                                                                                                                                            ok = false;
                                                                                                                                                                            ic = new Location();
                                                                                                                                                                            break;
                                                                                                                                                                        }
                                                                                                                                                                        int o = JSPRequestValue.requestInt(request, "location_id" + ic.getOID());
                                                                                                                                                                        if (t == 0) {
                                                                                                                                                                %>
                                                                                                                                                                <tr>
                                                                                                                                                                    <%}%>
                                                                                                                                                                    <td width="5"><input type="checkbox" name="location_id<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                                                                                                    <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                                                                                                    <%if (t == 4) {
                                                                                                                                                                    %>
                                                                                                                                                                </tr>
                                                                                                                                                                <%}%>
                                                                                                                                                                <%
                                                                                                                                                                        x++;
                                                                                                                                                                    }
                                                                                                                                                                }%>                                                                                                                                                                
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><input type="checkbox" name="all_location" value="1" <%if (allLocation == 1) {%> checked <%}%>   onClick="setCheckedLocation(this)"></td>
                                                                                                                                                                    <td class="fontarial">ALL LOCATION</td>
                                                                                                                                                                </tr>                                                                                                                                                                   
                                                                                                                                                            </table>
                                                                                                                                                            <%}%>                                                                                                                                                       
                                                                                                                                                        </td> 
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Number</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td > 
                                                                                                                                                            <input type="text" name="number" value="<%=number%>" class="fontarial" size="20">
                                                                                                                                                        </td>
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Sales Type </td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td > 
                                                                                                                                                            <select name="sales_type" class="fontarial">
                                                                                                                                                                <option value="-1" <%if (salesType == -1) {%>selected<%}%>>All Type..</option>	
                                                                                                                                                                <option value="0" <%if (salesType == 0) {%>selected<%}%>>Cash</option>
                                                                                                                                                                <option value="1" <%if (salesType == 1) {%>selected<%}%>>Credit</option>
                                                                                                                                                                <option value="2" <%if (salesType == 2) {%>selected<%}%>>Retur Cash</option>
                                                                                                                                                                <option value="3" <%if (salesType == 3) {%>selected<%}%>>Retur Credit</option>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>                                                                                                                                                                                                                        
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                      
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>      
                                                                                                                            <tr>
                                                                                                                                <td colspan="4">
                                                                                                                                    <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">
                                                                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                                </td> 
                                                                                                                            </tr>    
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="20" valign="middle" colspan="4"></td> 
                                                                                                                            </tr>    
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {

                ReportParameterLocation rp = new ReportParameterLocation();
                rp.setLocationId(locationId);
                rp.setStartDate(invStartDate);
                rp.setEndDate(invEndDate);
                rp.setSalesType(salesType);
                //rp.setNumber(number);
                boolean isOk = false;

                session.putValue("REPORT_SALES_LOCATION", rp);
                session.putValue("VECTOR_LOCATION", vLocSelected);

                Vector vLoca = new Vector();

                //if (locationId == 0) {
                  //  if (vLoc != null && vLoc.size() > 0) {
                  //      vLoca = vLoc;
                 //   }
               // } else {
               //     vLoca = DbLocation.list(0, 0, " location_id=" + locationId, "");
               // }
                for (int a = 0; a < vLocSelected.size(); a++) {

                    Location loc = new Location();
                    loc = (Location) vLocSelected.get(a);
                                                                                                                            %>
                                                                                                                            
                                                                                                                            <%
                                                                                                                                    whereClause = "";
                                                                                                                                    if (chkInvDate == 0) {
                                                                                                                                        if (whereClause != "") {
                                                                                                                                            whereClause = whereClause + " and ";
                                                                                                                                        }
                                                                                                                                        whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd 00:00:00") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd 23:59:59") + "'";
                                                                                                                                    }

                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " location_id=" + loc.getOID();


                                                                                                                                    if (number != null && number.length() > 0) {
                                                                                                                                        if (whereClause != "") {
                                                                                                                                            whereClause = whereClause + " and ";
                                                                                                                                        }
                                                                                                                                        whereClause = whereClause + " number like '%" + number + "%'";
                                                                                                                                    }

                                                                                                                                    if (salesType != -1) {
                                                                                                                                        if (whereClause != "") {
                                                                                                                                            whereClause = whereClause + " and ";
                                                                                                                                        }
                                                                                                                                        whereClause = whereClause + " type=" + salesType;
                                                                                                                                    }
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;

                                                                                                                                    listSales = DbSales.list(0, 0, whereClause, "date, number");


                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td class="boxed1">
                                                                                                                                                <table width="1500" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="5" ><font face="arial"><i><b>Location : <%=loc.getName().toLowerCase() %></b></i></font></td>                                                                                        
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="5" height="2"></td>                                                                                        
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr> 
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="20">No</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="100">Date</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">Number</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="100">Cashier</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" >Description</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="120">Group</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="100">Customer</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="50">Qty</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="50">Unit</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="50">Price</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">Amount</td>
                                                                                                                                                        <td class="tablearialhdr" colspan="2" >Discount</td>                                                                                        
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="50">PPN</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">Kwitansi</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">HPP</td>
                                                                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">Profit</td>                                                                                                                                                                                                                                             
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialhdr" width="30">( % )</td>
                                                                                                                                                        <td class="tablearialhdr" width="50">Amount</td>                                                                                                                                                        
                                                                                                                                                    </tr>    
                                                                                                                                                    <%
                                                                                                                                    if (listSales != null && listSales.size() > 0) {
                                                                                                                                        isOk = true;

                                                                                                                                        try {


                                                                                                                                            double totalQty = 0;
                                                                                                                                            double totalAmount = 0;
                                                                                                                                            double totalDiscountPercent = 0;

                                                                                                                                            double totalVat = 0;
                                                                                                                                            double grandTotal = 0;
                                                                                                                                            double grandDiscountAmount = 0;
                                                                                                                                            double grandTotalKwitansi = 0;
                                                                                                                                            double grandTotalHpp = 0;
                                                                                                                                            double granTotalLaba = 0;
                                                                                                                                            double totallaba = 0;
                                                                                                                                            double grandTotalDiscountPercen = 0;
                                                                                                                                            double totalhpp = 0;
                                                                                                                                            double totalKwitansi = 0;
                                                                                                                                            double totalDiscount_invoice = 0;

                                                                                                                                            if (listSales != null && listSales.size() > 0) {
                                                                                                                                                for (int i = 0; i < listSales.size(); i++) {

                                                                                                                                                    Sales sales = (Sales) listSales.get(i);

                                                                                                                                                    Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");
                                                                                                                                                    Customer cus = new Customer();
                                                                                                                                                    try {
                                                                                                                                                        cus = DbCustomer.fetchExc(sales.getCustomerId());
                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                    }

                                                                                                                                                    User usr = new User();
                                                                                                                                                    try {
                                                                                                                                                        usr = DbUser.fetch(sales.getUserId());
                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                    }

                                                                                                                                                    totalDiscount_invoice = 0;
                                                                                                                                                    totalDiscountPercent = 0;
                                                                                                                                                    totalhpp = 0;
                                                                                                                                                    totallaba = 0;
                                                                                                                                                    totalKwitansi = 0;

                                                                                                                                                    if (temp != null && temp.size() > 0) {

                                                                                                                                                        double dAmount = 0;
                                                                                                                                                        double dQty = 0;
                                                                                                                                                        double dDiscount = 0;
                                                                                                                                                        double dDiscountAmount = 0;
                                                                                                                                                        double dPpn = 0;

                                                                                                                                                        for (int xx = 0; xx < temp.size(); xx++) {

                                                                                                                                                            SalesDetail sd = (SalesDetail) temp.get(xx);

                                                                                                                                                            ItemMaster im = new ItemMaster();
                                                                                                                                                            try {
                                                                                                                                                                im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }

                                                                                                                                                            ItemGroup ig = new ItemGroup();
                                                                                                                                                            try {
                                                                                                                                                                ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }

                                                                                                                                                            totalAmount = totalAmount + sd.getTotal();
                                                                                                                                                            if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                                                                                                                                totalhpp = totalhpp - (sd.getCogs() * sd.getQty());
                                                                                                                                                                totallaba = totallaba - (((sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()));
                                                                                                                                                                totalQty = totalQty - sd.getQty();
                                                                                                                                                            } else {
                                                                                                                                                                totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                                                                                                                                                totallaba = totallaba + (((sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()));
                                                                                                                                                                totalQty = totalQty + sd.getQty();
                                                                                                                                                            }

                                                                                                                                                            if (sd.getDiscountPercent() == 0 && sd.getDiscountAmount() != 0) {
                                                                                                                                                                sd.setDiscountPercent(((sd.getDiscountAmount() / (sd.getTotal() + sd.getDiscountAmount())) * 100));
                                                                                                                                                            }

                                                                                                                                                            totalVat = totalVat + sales.getVatAmount();
                                                                                                                                                            totalDiscountPercent = totalDiscountPercent + sd.getDiscountPercent();
                                                                                                                                                            totalDiscount_invoice = totalDiscount_invoice + sd.getDiscountAmount();

                                                                                                                                                            //untk total semua invoice
                                                                                                                                                            if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                                                                                                                                grandTotal = grandTotal - (sd.getQty() * sd.getSellingPrice());
                                                                                                                                                            } else {
                                                                                                                                                                grandTotal = grandTotal + (sd.getQty() * sd.getSellingPrice());
                                                                                                                                                            }
                                                                                                                                                            if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                                                                                                                                totalKwitansi = totalKwitansi - (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                                                                                                                                            } else {
                                                                                                                                                                totalKwitansi = totalKwitansi + (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                                                                                                                                            }
                                                                                                                                                            String uomName="";
                                                                                                                                                            try{
                                                                                                                                                                Uom uom = new Uom();
                                                                                                                                                                uom = DbUom.fetchExc(sd.getUomId());
                                                                                                                                                                uomName=uom.getUnit();
                                                                                                                                                            }catch(Exception e){
                                                                                                                                                            }

                                                                                                                                                    %>
                                                                                                                                                    <tr height="22"> 
                                                                                                                                                        <td class="tablearialcell"> 
                                                                                                                                                            <div align="center"><%=(xx == 0) ? "" + (i + 1) : ""%></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" align="center" nowrap><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "yyyy-MM-dd HH:mm:ss") : ""%></td>
                                                                                                                                                        <td class="tablearialcell" align="center"><%=(xx == 0) ? sales.getNumber() : ""%></td>
                                                                                                                                                        <td class="tablearialcell" ><%=(xx == 0) ? usr.getFullName() : ""%></td>
                                                                                                                                                        <td class="tablearialcell" ><%=im.getName()%></td>
                                                                                                                                                        <td class="tablearialcell" ><%=ig.getName()%></td>
                                                                                                                                                        <td class="tablearialcell" ><%=(xx == 0 && cus.getOID() != 0) ? cus.getName() : ""%></td>
                                                                                                                                                        <td class="tablearialcell" ><%=(temp.size() == 1) ? "<B>" : ""%>                                                                                                                                                         
                                                                                                                                                            <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                                                                                                                        dQty = dQty + (sd.getQty() * -1);
                                                                                                                                                            %>
                                                                                                                                                            <div align="right"><%=JSPFormater.formatNumber(sd.getQty() * -1, "###,###.##") %></div>
                                                                                                                                                            <%} else {
    dQty = dQty + (sd.getQty());
                                                                                                                                                            %>
                                                                                                                                                            <div align="right"><%=JSPFormater.formatNumber(sd.getQty(), "###,###.##")%></div>
                                                                                                                                                            <%}%>
                                                                                                                                                            <%=(temp.size() == 1) ? "</B>" : ""%> 
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" >
                                                                                                                                                            <div align="left"><%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%=uomName%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" >
                                                                                                                                                            <div align="right"><%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="right"><%=(temp.size() == 1) ? "<B>" : ""%>                                                                                              
                                                                                                                                                            <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                            <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()) * -1, "#,###")%> 
                                                                                                                                                            <%dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()) * -1);%>
                                                                                                                                                            <%} else {%>
                                                                                                                                                            <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()), "#,###")%> 
                                                                                                                                                            <%dAmount = dAmount + (sd.getTotal() + sd.getDiscountAmount());%>
                                                                                                                                                            <%}%><%=(temp.size() == 1) ? "</B>" : ""%>                                                                                            
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right"> 
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%=JSPFormater.formatNumber(sd.getDiscountPercent(), "#,###.##")%>
                                                                                                                                                                <%dDiscount = dDiscount + sd.getDiscountPercent();%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right">
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%=JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###.##")%> 
                                                                                                                                                                <%dDiscountAmount = dDiscountAmount + sd.getDiscountAmount();%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right"> 
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###.##")%> 
                                                                                                                                                                <%dPpn = dPpn + sales.getVatAmount();%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>                                                                                                                                                            
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right">
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                                <%=JSPFormater.formatNumber((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount()) * -1, "#,###.##")%>                                                                                                 
                                                                                                                                                                <%} else {%>
                                                                                                                                                                <%=JSPFormater.formatNumber((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount()), "#,###.##")%>                                                                                                 
                                                                                                                                                                <%}%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right">         
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                                <%=JSPFormater.formatNumber((sd.getCogs() * sd.getQty()) * -1, "#,###.##")%> 
                                                                                                                                                                <%} else {%>    
                                                                                                                                                                <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###.##")%> 
                                                                                                                                                                <%}%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>
                                                                                                                                                        <td class="tablearialcell" > 
                                                                                                                                                            <div align="right"> 
                                                                                                                                                                <%=(temp.size() == 1) ? "<B>" : ""%>
                                                                                                                                                                <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                                <%=JSPFormater.formatNumber((((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty())) * -1, "#,###.##")%> 
                                                                                                                                                                <%} else {%>
                                                                                                                                                                <%=JSPFormater.formatNumber(((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()), "#,###.##")%> 
                                                                                                                                                                <%}%>
                                                                                                                                                                <%=(temp.size() == 1) ? "</B>" : ""%>
                                                                                                                                                            </div>
                                                                                                                                                        </td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>                                                                                    
                                                                                                                                                    <%if (temp.size() > 1) {%>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td height="2" colspan="7" class="tablearialcell1">&nbsp;</td>
                                                                                                                                                        <td height="2" class="tablearialcell1">
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(dQty, "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1">&nbsp;</td>
                                                                                                                                                        <td height="2" class="tablearialcell1">&nbsp;</td>
                                                                                                                                                        <td height="2" class="tablearialcell1"> 
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(dAmount, "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1"> 
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(dDiscount, "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1"> 
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(dDiscountAmount, "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1"> 
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1"> 
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalKwitansi, "#,###.##")%></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1">
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalhpp, "#,###.##")%></b></div>                                                                      
                                                                                                                                                        </td>
                                                                                                                                                        <td height="2" class="tablearialcell1">
                                                                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totallaba, "#,###.##")%></b></div>
                                                                                                                                                        </td>                                                                                                                                                       
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>                                                                                    
                                                                                                                                                    <%}

                                                                                                                                                    grandDiscountAmount = grandDiscountAmount + totalDiscount_invoice + sales.getDiscountAmount();
                                                                                                                                                    grandTotalDiscountPercen = grandTotalDiscountPercen + totalDiscountPercent + sales.getDiscountPercent();
                                                                                                                                                    grandTotalKwitansi = grandTotalKwitansi + totalKwitansi;
                                                                                                                                                    grandTotalHpp = grandTotalHpp + totalhpp;
                                                                                                                                                    granTotalLaba = granTotalLaba + totallaba;
                                                                                                                                                }
                                                                                                                                            }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                    <tr height="25">  
                                                                                                                                                        <td height="19" colspan="5"></td>  
                                                                                                                                                        <td height="19" bgcolor="#3366CC" colspan="2"> 
                                                                                                                                                            <div align="center"><font face="arial" color="#FFFFFF" ><b>T O T A L</b></font></div>
                                                                                                                                                        </td>                                                                                        
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalQty, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalDiscountPercen, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandDiscountAmount, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalKwitansi, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalHpp, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                            <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(granTotalLaba, "#,###.##")%></font></b></div>
                                                                                                                                                        </td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td coslpan="18">&nbsp;</td>                                                                                       
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                                        } catch (Exception exc) {
                                                                                                                                                        }%>
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="22" align="left" colspan="16" class="tablearialcell"> 
                                                                                                                                                            <i>Data not found...</i>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="8" align="left" colspan="3" class="fontarial" height="35"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <%
                                                                                                                                }%>
                                                                                                                            <%if (isOk) {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" > 
                                                                                                                                    <%if (privPrint) {%>
                                                                                                                                    <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <%} else {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" > 
                                                                                                                                    <i>Klik search button to seraching the data ....</i>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="97%">&nbsp;</td>
                                                                                                                                        </tr>                                                                      
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
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

