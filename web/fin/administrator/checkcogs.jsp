
<%-- 
    Document   : checkcogs
    Created on : Mar 13, 2015, 3:26:31 PM
    Author     : Roy
--%>

<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*"%>
<%@ page import = "com.project.I_Project"%>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);            
            int parameter = JSPRequestValue.requestInt(request, "parameter");
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int all = JSPRequestValue.requestInt(request, "all");
            Vector result = new Vector();

            if (session.getValue("REPORT_BALANCE_COGS") != null) {
                session.removeValue("REPORT_BALANCE_COGS");
            }

            if (session.getValue("REPORT_BALANCE_COGS_PARAMETER") != null) {
                session.removeValue("REPORT_BALANCE_COGS_PARAMETER");
            }

            if (tanggal == null) {
                tanggal = new Date();
            }
            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }

            Vector locations = new Vector();
            try {
                locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            } catch (Exception e) {
            }

            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
            String note = "";
            
            String number = "";
            
            String whereGrp = "";

                if (vCategory != null && vCategory.size() > 0) {
                    for (int i = 0; i < vCategory.size(); i++) {
                        ItemGroup ic = (ItemGroup) vCategory.get(i);
                        int ok = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                        if (ok == 1) {
                            if (whereGrp != null && whereGrp.length() > 0) {
                                whereGrp = whereGrp + ",";
                                note = note +",";
                            }
                            note = note + ic.getName();
                            whereGrp = whereGrp + ic.getOID();
                        }
                    }
                }

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.ACTIVATE) {
                result = SessCOGS.getCOGS(locationId, tanggal, tanggalEnd, whereGrp);
            }


            if (iJSPCommand == JSPCommand.ACTIVATE) {
                if (result != null && result.size() > 0) {
                    boolean main = false;
                    long oid = 0;
                    for (int x = 0; x < result.size(); x++) {
                        Vector tmp = (Vector) result.get(x);

                        long itemId = 0;
                        try {
                            itemId = Long.parseLong(String.valueOf(tmp.get(0)));
                        } catch (Exception e) {
                        }
                        double diff = JSPRequestValue.requestDouble(request, "diff" + itemId);
                        int chk = JSPRequestValue.requestInt(request, "chk" + itemId);

                        if (diff != 0 && chk==1) {
                            if (main == false) {
                                Adjusment adjusment = new Adjusment();
                                int ctr = DbAdjusment.getNextCounter();
                                adjusment.setCounter(ctr);
                                adjusment.setPrefixNumber(DbAdjusment.getNumberPrefix());
                                adjusment.setNumber(DbAdjusment.getNextNumber(ctr));
                                adjusment.setStatus(I_Project.DOC_STATUS_POSTED);
                                adjusment.setDate(tanggalEnd);
                                adjusment.setLocationId(locationId);
                                adjusment.setNote("Adjusment value category :"+note);
                                adjusment.setUserId(user.getOID());
                                adjusment.setApproval1(user.getOID());
                                adjusment.setApproval1_date(tanggalEnd);   
                                adjusment.setPostedDate(tanggalEnd);   
                                adjusment.setPostedById(user.getOID());   
                                adjusment.setEffectiveDate(tanggalEnd);  
                                try{
                                    oid = DbAdjusment.insertExc(adjusment);
                                    number = adjusment.getNumber();
                                }catch(Exception e){}
                                main = true;
                            }
                            
                            if(oid != 0){
                                AdjusmentItem adjusmentItem = new AdjusmentItem();
                                adjusmentItem.setAdjusmentId(oid);
                                adjusmentItem.setItemMasterId(itemId);
                                adjusmentItem.setQtySystem(0);
                                adjusmentItem.setQtyReal(0);
                                adjusmentItem.setQtyBalance(1);
                                adjusmentItem.setPrice(diff);
                                adjusmentItem.setAmount(diff);
                                try{
                                    DbAdjusmentItem.insertExc(adjusmentItem);
                                }catch(Exception e){}
                                
                                AdjusmentItem adjusmentItemMinus = new AdjusmentItem();
                                adjusmentItemMinus.setAdjusmentId(oid);
                                adjusmentItemMinus.setItemMasterId(itemId);
                                adjusmentItemMinus.setQtySystem(0);
                                adjusmentItemMinus.setQtyReal(0);
                                adjusmentItemMinus.setQtyBalance(-1);
                                adjusmentItemMinus.setPrice(0);
                                adjusmentItemMinus.setAmount(0);
                                try{
                                    DbAdjusmentItem.insertExc(adjusmentItemMinus);
                                }catch(Exception e){}
                            }

                        }
                    }
                    result = SessCOGS.getCOGS(locationId, tanggal, tanggalEnd, whereGrp);
                }
            }

            ReportParameter rp = new ReportParameter();
            rp.setLocationId(locationId);
            rp.setDateFrom(tanggal);
            rp.setDateTo(tanggalEnd);

            Vector print = new Vector();
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">        
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.RptCogsXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function setChecked1(val){
                 <%
            for (int k = 0; k < result.size(); k++) {
                Vector tmp = (Vector) result.get(k);

                        long itemId = 0;
                        try {
                            itemId = Long.parseLong(String.valueOf(tmp.get(0)));
                        } catch (Exception e) {
                        }
                        %>
                        
                        document.frmsaleseditor.chk<%=itemId%>.checked=val.checked;
                        
                
                     <%}
            %>
            
            }
                
                function cmdSearch(){
                    document.frmsaleseditor.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsaleseditor.action="checkcogs.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsaleseditor.submit();
                }
                
                function cmdSave(){
                    document.frmsaleseditor.command.value="<%=JSPCommand.ACTIVATE %>";
                    document.frmsaleseditor.action="checkcogs.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsaleseditor.submit();
                }
                
                function setChecked(val){
                 <%
            for (int k = 0; k < vCategory.size(); k++) {
                ItemGroup ic = (ItemGroup) vCategory.get(k);
                %>
                    document.frmsaleseditor.grp<%=ic.getOID()%>.checked=val.checked;
                    
                    <%}%>
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
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                  <%@ include file="menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Check COGS</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td class="container" ><!-- #BeginEditable "content" --> 
                                                        <form name="frmsaleseditor" method="post" action="">
                                                            <input type="hidden" name="command" value="">    
                                                            <table width="100%" border="0" >
                                                                <tr height="22">
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>            
                                                                            <tr height="22"> 
                                                                                <td width="80" class="tablearialcell1">&nbsp;Date</td>
                                                                                <td width="2" class="fontarial">:</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsaleseditor.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td>&nbsp;&nbsp;to&nbsp;</td>
                                                                                            <td>&nbsp;<input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsaleseditor.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                        </tr>
                                                                                    </table>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Location</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td >
                                                                                    <select name="src_location_id" class="fontarial">
                                                                                        <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                        %>
                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                        <%}
            }%>
                                                                                    </select>   
                                                                                </td>
                                                                            </tr>  
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Category</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td >
                                                                                    <%
            if (vCategory != null && vCategory.size() > 0) {
                                                                                    %>
                                                                                    <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                        <%
                                                                                        int x = 0;
                                                                                        boolean ok = true;
                                                                                        while (ok) {

                                                                                            for (int t = 0; t < 4; t++) {
                                                                                                ItemGroup ic = new ItemGroup();
                                                                                                try {
                                                                                                    ic = (ItemGroup) vCategory.get(x);
                                                                                                } catch (Exception e) {
                                                                                                    ok = false;
                                                                                                    ic = new ItemGroup();
                                                                                                    break;
                                                                                                }
                                                                                                int o = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                                                                                                if (t == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <%}%>
                                                                                            <td width="5"><input type="checkbox" name="grp<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                            <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                            <%if (t == 3) {
                                                                                            %>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
                                                                                                x++;
                                                                                            }
                                                                                        }%>
                                                                                        <tr>
                                                                                            <td><input type="checkbox" name="all" value="1" <%if (all == 1) {%> checked <%}%>   onClick="setChecked(this)"></td>
                                                                                            <td class="fontarial">ALL CATEGORY</td>
                                                                                        </tr>   
                                                                                    </table>
                                                                                    <%}%>     
                                                                                </td>
                                                                            </tr> 
                                                                            <tr height="22"> 
                                                                                <td width="80" class="tablearialcell1">&nbsp;Parameter</td>
                                                                                <td width="2" class="fontarial">:</td>
                                                                                <td >
                                                                                    <select name="parameter" class="fontarial">
                                                                                        <option value="0" <%if (parameter == 0) {%>selected<%}%>>- none -</option>
                                                                                        <option value="1" <%if (parameter == 1) {%>selected<%}%>>Transfer In</option>
                                                                                        <option value="2" <%if (parameter == 2) {%>selected<%}%>>Transfer Out</option>
                                                                                        <option value="3" <%if (parameter == 3) {%>selected<%}%>>Ajustment</option>
                                                                                    </select>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td >&nbsp;</td>
                                                                                <td colspan="2"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%if(number.length() > 0){%>
                                                                <tr>
                                                                    <td><b>number : <%=number%></b></td>
                                                                </tr> 
                                                                <%}%>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr> 
                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="0" cellspacing="1">
                                                                            <tr height="22">
                                                                                <td class="tablehdr" rowspan="2" width="30">No.</td>
                                                                                <td class="tablehdr" rowspan="2" >Item Name</td>
                                                                                <td class="tablehdr" rowspan="2" width="80">SKU</td>
                                                                                <td class="tablehdr" colspan="3">Begining</td>
                                                                                <td class="tablehdr" colspan="3">Incoming</td>
                                                                                <td class="tablehdr" colspan="3">Incoming Adj</td>
                                                                                <td class="tablehdr" colspan="3">Retur</td>
                                                                                <td class="tablehdr" colspan="3">Transfer In</td>   
                                                                                <td class="tablehdr" colspan="3">Sales</td>                                                                                
                                                                                <td class="tablehdr" colspan="3">Transfer Out</td>
                                                                                <td class="tablehdr" colspan="3">Costing</td>                                                                                
                                                                                <td class="tablehdr" colspan="3">Repack In</td>
                                                                                <td class="tablehdr" colspan="3">Repack Out</td>
                                                                                <td class="tablehdr" colspan="3">Adjusment</td>                                                                                
                                                                                <td class="tablehdr" colspan="6">Ending</td>                                                                                
                                                                                <td class="tablehdr" rowspan="2" >
                                                                                    <input type="checkbox" name="chkbox" onClick="setChecked1(this)">
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22">                                                                               
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td> 
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td> 
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td> 
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td> 
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>  
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="60">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td> 
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="70">Qty</td>                                                                                
                                                                                <td class="tablehdr" width="100">COGS</td>
                                                                                <td class="tablehdr" width="100">COGS <BR>REAL</td>
                                                                                <td class="tablehdr" width="100">Total</td> 
                                                                                <td class="tablehdr" width="100">Total<BR>Real</td> 
                                                                                <td class="tablehdr" width="100">DIFF</td> 
                                                                            </tr>
                                                                            <%if (result != null && result.size() > 0) {

                double grandOpeningQty = 0;
                double grandOpeningCogs = 0;

                double grandQty = 0;
                double grandCogs = 0;

                double gIncomingQty = 0;
                double gIncomingCogs = 0;

                double gIncomingAdjQty = 0;
                double gIncomingAdjCogs = 0;

                double gReturQty = 0;
                double gReturCogs = 0;

                double gTrfQty = 0;
                double gTrfCogs = 0;

                double gTrfOutQty = 0;
                double gTrfOutCogs = 0;

                double gSalesQty = 0;
                double gSalesCogs = 0;

                double gCostingQty = 0;
                double gCostingCogs = 0;

                double gAdjQty = 0;
                double gAdjCogs = 0;
                int totFalse = 0;

                double gRepackInQty = 0;
                double gRepackInCogs = 0;

                double gRepackOutQty = 0;
                double gRepackOutCogs = 0;

                double gTot1 = 0;
                double gTot2 = 0;

                for (int x = 0; x < result.size(); x++) {
                    Vector tmp = (Vector) result.get(x);
                    String name = "";
                    String sku = "";

                    long itemId = 0;
                    try {
                        itemId = Long.parseLong(String.valueOf(tmp.get(0)));
                    } catch (Exception e) {
                    }

                    double salesQty = 0;
                    double salesCogs = 0;
                    double totSales = 0;

                    double trfQty = 0;
                    double trfCogs = 0;
                    double totTrf = 0;

                    double trfOutQty = 0;
                    double trfOutCogs = 0;
                    double totTrfOut = 0;

                    double adjQty = 0;
                    double adjCogs = 0;
                    double totAdj = 0;

                    double incQty = 0;
                    double incCogs = 0;
                    double totInc = 0;

                    double returQty = 0;
                    double returCogs = 0;
                    double totRetur = 0;

                    double costQty = 0;
                    double costCogs = 0;
                    double totCost = 0;

                    double repackInQty = 0;
                    double repackInCogs = 0;
                    double totRepackIn = 0;

                    double repackOutQty = 0;
                    double repackOutCogs = 0;
                    double totRepackOut = 0;

                    try {
                        name = String.valueOf(tmp.get(2));
                    } catch (Exception e) {
                    }

                    try {
                        sku = String.valueOf(tmp.get(1));
                    } catch (Exception e) {
                    }

                    try {
                        salesQty = Double.parseDouble(String.valueOf(tmp.get(3)));
                    } catch (Exception e) {
                    }

                    try {
                        totSales = Double.parseDouble(String.valueOf(tmp.get(4)));
                        if (salesQty != 0) {
                            salesCogs = totSales / salesQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        trfQty = Double.parseDouble(String.valueOf(tmp.get(5)));
                    } catch (Exception e) {
                    }

                    try {
                        totTrf = Double.parseDouble(String.valueOf(tmp.get(6)));
                        if (trfQty != 0) {
                            trfCogs = totTrf / trfQty;
                        }
                    } catch (Exception e) {
                    }


                    try {
                        trfOutQty = Double.parseDouble(String.valueOf(tmp.get(7)));
                    } catch (Exception e) {
                    }

                    try {
                        totTrfOut = Double.parseDouble(String.valueOf(tmp.get(8)));
                        if (trfOutQty != 0) {
                            trfOutCogs = totTrfOut / trfOutQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        adjQty = Double.parseDouble(String.valueOf(tmp.get(9)));
                    } catch (Exception e) {
                    }

                    try {
                        totAdj = Double.parseDouble(String.valueOf(tmp.get(10)));
                        if (adjQty != 0) {
                            adjCogs = totAdj / adjQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        incQty = Double.parseDouble(String.valueOf(tmp.get(11)));
                    } catch (Exception e) {
                    }

                    try {
                        totInc = Double.parseDouble(String.valueOf(tmp.get(12)));
                        if (incQty != 0) {
                            incCogs = totInc / incQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        returQty = Double.parseDouble(String.valueOf(tmp.get(13)));
                    } catch (Exception e) {
                    }

                    try {
                        totRetur = Double.parseDouble(String.valueOf(tmp.get(14)));
                        if (returQty != 0) {
                            returCogs = totRetur / returQty;
                        }
                    } catch (Exception e) {
                    }

                    double psalesQty = 0;
                    double psalesCogs = 0;
                    double totpsales = 0;

                    double ptrfQty = 0;
                    double ptrfCogs = 0;
                    double totptrf = 0;

                    double ptrfOutQty = 0;
                    double ptrfOutCogs = 0;
                    double totptrfOut = 0;

                    double padjQty = 0;
                    double padjCogs = 0;
                    double totpadj = 0;

                    double pincQty = 0;
                    double pincCogs = 0;
                    double totpinc = 0;

                    double preturQty = 0;
                    double preturCogs = 0;
                    double totpretur = 0;

                    double pcostQty = 0;
                    double pcostCogs = 0;
                    double totpcost = 0;

                    double pRepackInQty = 0;
                    double pRepackInCogs = 0;
                    double totpRepackIn = 0;

                    double pRepackOutQty = 0;
                    double pRepackOutCogs = 0;
                    double totpRepackOut = 0;

                    try {
                        psalesQty = Double.parseDouble(String.valueOf(tmp.get(15)));
                    } catch (Exception e) {
                    }

                    try {
                        totpsales = Double.parseDouble(String.valueOf(tmp.get(16)));
                        if (psalesQty != 0) {
                            psalesCogs = totpsales / psalesQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        ptrfQty = Double.parseDouble(String.valueOf(tmp.get(17)));
                    } catch (Exception e) {
                    }

                    try {
                        totptrf = Double.parseDouble(String.valueOf(tmp.get(18)));
                        if (ptrfQty != 0) {
                            ptrfCogs = totptrf / ptrfQty;
                        }
                    } catch (Exception e) {
                    }


                    try {
                        ptrfOutQty = Double.parseDouble(String.valueOf(tmp.get(19)));
                    } catch (Exception e) {
                    }

                    try {
                        totptrfOut = Double.parseDouble(String.valueOf(tmp.get(20)));
                        if (ptrfOutQty != 0) {
                            ptrfOutCogs = totptrfOut / ptrfOutQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        padjQty = Double.parseDouble(String.valueOf(tmp.get(21)));
                    } catch (Exception e) {
                    }

                    try {
                        totpadj = Double.parseDouble(String.valueOf(tmp.get(22)));
                        if (padjQty != 0) {
                            padjCogs = totpadj / padjQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        pincQty = Double.parseDouble(String.valueOf(tmp.get(23)));
                    } catch (Exception e) {
                    }

                    try {
                        totpinc = Double.parseDouble(String.valueOf(tmp.get(24)));
                        if (pincQty != 0) {
                            pincCogs = totpinc / pincQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        preturQty = Double.parseDouble(String.valueOf(tmp.get(25)));
                    } catch (Exception e) {
                    }

                    try {
                        totpretur = Double.parseDouble(String.valueOf(tmp.get(26)));
                        if (preturQty != 0) {
                            preturCogs = totpretur / preturQty;
                        }
                    } catch (Exception e) {
                    }


                    try {
                        pcostQty = Double.parseDouble(String.valueOf(tmp.get(27)));
                    } catch (Exception e) {
                    }

                    try {
                        totpcost = Double.parseDouble(String.valueOf(tmp.get(28)));
                        if (pcostQty != 0) {
                            pcostCogs = totpcost / pcostQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        costQty = Double.parseDouble(String.valueOf(tmp.get(29)));
                    } catch (Exception e) {
                    }

                    try {
                        totCost = Double.parseDouble(String.valueOf(tmp.get(30)));
                        if (costQty != 0) {
                            costCogs = totCost / costQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        pRepackInQty = Double.parseDouble(String.valueOf(tmp.get(31)));
                    } catch (Exception e) {
                    }

                    try {
                        totpRepackIn = Double.parseDouble(String.valueOf(tmp.get(32)));
                        if (pRepackInQty != 0) {
                            pRepackInCogs = totpRepackIn / pRepackInQty;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        pRepackOutQty = Double.parseDouble(String.valueOf(tmp.get(33)));
                    } catch (Exception e) {
                    }

                    try {
                        totpRepackOut = Double.parseDouble(String.valueOf(tmp.get(34)));
                        if (pRepackOutQty != 0) {
                            pRepackOutCogs = totpRepackOut / pRepackOutQty;
                        }
                    } catch (Exception e) {
                    }


                    try {
                        repackInQty = Double.parseDouble(String.valueOf(tmp.get(35)));
                    } catch (Exception e) {
                    }

                    try {
                        totRepackIn = Double.parseDouble(String.valueOf(tmp.get(36)));
                        if (repackInQty != 0) {
                            repackInCogs = totRepackIn / repackInQty;
                        }
                    } catch (Exception e) {
                    }


                    try {
                        repackOutQty = Double.parseDouble(String.valueOf(tmp.get(37)));
                    } catch (Exception e) {
                    }

                    try {
                        totRepackOut = Double.parseDouble(String.valueOf(tmp.get(38)));
                        if (repackOutQty != 0) {
                            repackOutCogs = totRepackOut / repackOutQty;
                        }
                    } catch (Exception e) {
                    }

                    double qtyCogs = 0;
                    double valueCogs = 0;
                    double totCogs = 0;

                    double qtyPRecAdj = 0;
                    double cogsPRecAdj = 0;
                    double totPRecAdj = 0;

                    double qtyRecAdj = 0;
                    double cogsRecAdj = 0;
                    double totRecAdj = 0;

                    try {
                        qtyPRecAdj = Double.parseDouble(String.valueOf(tmp.get(41)));
                    } catch (Exception e) {
                    }

                    try {
                        totPRecAdj = Double.parseDouble(String.valueOf(tmp.get(42)));
                        if (qtyPRecAdj != 0) {
                            cogsPRecAdj = totPRecAdj / qtyPRecAdj;
                        }
                    } catch (Exception e) {
                    }

                    try {
                        qtyRecAdj = Double.parseDouble(String.valueOf(tmp.get(43)));
                    } catch (Exception e) {
                    }

                    try {
                        totRecAdj = Double.parseDouble(String.valueOf(tmp.get(44)));
                        if (qtyRecAdj != 0) {
                            cogsRecAdj = totRecAdj / qtyRecAdj;
                        }
                    } catch (Exception e) {
                    }


                    double openingCogs = totptrf - totpsales - totptrfOut + totpadj + totpinc - totpretur - totpcost + totpRepackIn - totpRepackOut + totPRecAdj;
                    double openingQty = ptrfQty - psalesQty - ptrfOutQty + padjQty + pincQty - preturQty - pcostQty + pRepackInQty - pRepackOutQty;
                    double cogs = 0;
                    if (openingQty != 0) {
                        cogs = openingCogs / openingQty;
                    }

                    double endingQty = openingQty + incQty - returQty + trfQty - salesQty - trfOutQty + adjQty - costQty + repackInQty - repackOutQty;
                    double endingCogs = openingCogs + totInc - totRetur + totTrf - totSales - totTrfOut + totAdj - totCost + totRepackIn - totRepackOut;
                    double endingAvgCogs = 0;
                    if (endingQty != 0) {
                        endingAvgCogs = endingCogs / endingQty;
                    }

                    grandOpeningQty = grandOpeningQty + openingQty;
                    grandOpeningCogs = grandOpeningCogs + openingCogs;

                    grandQty = grandQty + endingQty;
                    grandCogs = grandCogs + endingCogs;

                    gIncomingQty = gIncomingQty + incQty;
                    gIncomingCogs = gIncomingCogs + (incQty * incCogs);

                    gReturQty = gReturQty + returQty;
                    gReturCogs = gReturCogs + (returQty * returCogs);

                    gTrfQty = gTrfQty + trfQty;
                    gTrfCogs = gTrfCogs + (trfQty * trfCogs);

                    gTrfOutQty = gTrfOutQty + trfOutQty;
                    gTrfOutCogs = gTrfOutCogs + (trfOutQty * trfOutCogs);

                    gCostingQty = gCostingQty + costQty;
                    gCostingCogs = gCostingCogs + (costQty * costCogs);

                    gAdjQty = gAdjQty + adjQty;
                    gAdjCogs = gAdjCogs + (adjQty * adjCogs);

                    gSalesQty = gSalesQty + salesQty;
                    gSalesCogs = gSalesCogs + (salesQty * salesCogs);

                    gRepackInQty = gRepackInQty + repackInQty;
                    gRepackInCogs = gRepackInCogs + repackInCogs;

                    gRepackOutQty = gRepackOutQty + repackOutQty;
                    gRepackOutCogs = gRepackOutCogs + repackOutCogs;

                    gIncomingAdjQty = gIncomingAdjQty + qtyRecAdj;
                    gIncomingAdjCogs = gIncomingAdjCogs + (qtyRecAdj * cogsRecAdj);

                    double cogsReal = 0;
                    double totalReal = 0;

                    try {
                        qtyCogs = Double.parseDouble(String.valueOf(tmp.get(39)));
                    } catch (Exception e) {
                    }

                    try {
                        totCogs = Double.parseDouble(String.valueOf(tmp.get(40)));
                        if (qtyCogs != 0) {
                            cogsReal = totCogs / qtyCogs;
                        }
                    } catch (Exception e) {
                    }

                    if (cogsReal == 0) {
                        cogsReal = SessCOGS.getCOGSByVendor(itemId);
                        if (cogsReal == 0) {
                            cogsReal = SessCOGS.getCOGSByItem(itemId);
                        }
                    }


                    totalReal = endingQty * cogsReal;
                    double diff = totalReal - endingCogs;
                    gTot1 = gTot1 + totalReal;
                    gTot2 = gTot2 + diff;

                    long oid = 0;
                    try {
                        oid = Long.parseLong(String.valueOf(tmp.get(0)));
                    } catch (Exception e) {
                    }
                    Vector tmpPrint = new Vector();
                    tmpPrint.add(String.valueOf(oid));
                    tmpPrint.add(name);
                    tmpPrint.add(sku);

                                                                            %>
                                                                            <tr height="22">
                                                                                <td class="tablecell1" align="center"><%=(x + 1)%></td>
                                                                                <td class="tablecell1" align="left" nowrap style="padding:3px;"><%=name%></td>
                                                                                <td class="tablecell1" align="left" style="padding:3px;"><%=sku%></td>                                               
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(openingQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(openingCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(incQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(incCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(incQty * incCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(qtyRecAdj, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cogsRecAdj, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(qtyRecAdj * cogsRecAdj, "###,###.##") %></td>
                                                                                
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(returQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(returCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(returQty * returCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfQty * trfCogs, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(salesQty, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(salesCogs, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(salesQty * salesCogs, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfOutQty, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfOutCogs, "###,###.##") %></td>
                                                                                <td class="tablecell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trfOutQty * trfOutCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(costQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(costCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(costQty * costCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackInQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackInCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackInQty * repackInCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackOutQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackOutCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackOutQty * repackOutCogs, "###,###.##") %></td>
                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(adjQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(adjCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(adjQty * adjCogs, "###,###.##") %></td>
                                                                                
                                                                                
                                                                                <%
                                                                                                if ((endingQty > 0 && endingCogs < 0) || (endingQty < 0 && endingCogs > 0)) {
                                                                                                    totFalse = totFalse + 1;
                                                                                %>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingQty, "###,###.##") %></td>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingAvgCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cogsReal, "###,###.##") %></td>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalReal, "###,###.##") %></td>
                                                                                <td bgcolor="#F87979" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(diff, "###,###.##") %></td>
                                                                                <%} else {%>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingQty, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingAvgCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cogsReal, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(endingCogs, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalReal, "###,###.##") %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(diff, "###,###.##") %></td>
                                                                                <%}%>
                                                                                <input type="hidden" name="diff<%=itemId%>" value="<%=diff%>">
                                                                                <%
                                                                                                tmpPrint.add(String.valueOf(endingCogs));
                                                                                                tmpPrint.add(String.valueOf(totalReal));
                                                                                                tmpPrint.add(String.valueOf(diff));
                                                                                                print.add(tmpPrint);
                                                                                %>
                                                                                <td class="tablecell1" align="center" style="padding:3px;"><input type="checkbox" name="chk<%=itemId%>" value="1"></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr height="22">
                                                                                <td bgcolor="#cccccc" align="center" colspan="3"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(grandOpeningQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(grandOpeningCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gIncomingQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gIncomingCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gIncomingAdjQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gIncomingAdjCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gReturQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gReturCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTrfQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTrfCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gSalesQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gSalesCogs, "###,###.##") %></td>
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTrfOutQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTrfOutCogs, "###,###.##") %></td>
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gCostingQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gCostingCogs, "###,###.##") %></td>
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gRepackInQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gRepackInCogs, "###,###.##") %></td>
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gRepackOutQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gRepackOutCogs, "###,###.##") %></td>
                                                                                
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gAdjQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gAdjCogs, "###,###.##") %></td>
                                                                                
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(grandQty, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(grandCogs, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTot1, "###,###.##") %></td>
                                                                                <td bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(gTot2, "###,###.##") %></td>
                                                                            </tr>
                                                                            <tr height="28">
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <%
    session.putValue("REPORT_BALANCE_COGS", print);
    session.putValue("REPORT_BALANCE_COGS_PARAMETER", rp);
                                                                            %>
                                                                            <tr height="28">
                                                                                <td colspan="2">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/save2.gif',1)"><img src="../images/save.gif" name="post" border="0"></a>                                                                               
                                                                                    &nbsp;&nbsp;
                                                                                    <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%}%>
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
