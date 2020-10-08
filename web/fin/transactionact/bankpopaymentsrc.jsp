

<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.Purchase" %>
<%@ page import = "com.project.ccs.postransaction.purchase.DbPurchase" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_DELETE);
%>

<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long vendorId = JSPRequestValue.requestLong(request, "vendorid");
            String vndInvNumber = JSPRequestValue.requestString(request, "vndinvnumber");
            String poNumber = JSPRequestValue.requestString(request, "ponumber");
            long bankpoId = JSPRequestValue.requestLong(request, "bankpo_id");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int overDue = JSPRequestValue.requestInt(request, "overdue");
            int overStatus = JSPRequestValue.requestInt(request, "src_overdue");
            String srcNumber = JSPRequestValue.requestString(request, "src_number");

            Date dueDate = new Date();
            if (JSPRequestValue.requestString(request, "duedate").length() > 0) {
                dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "duedate"), "dd/MM/yyyy");
            }

            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            String strLocation = "";
            if (locationId == 0) {
                if (locations != null && locations.size() > 0) {
                    for (int i = 0; i < locations.size(); i++) {
                        Location l = (Location) locations.get(i);
                        if (strLocation != null && strLocation.length() > 0) {
                            strLocation = strLocation + ",";
                        }
                        strLocation = strLocation + l.getOID();
                    }
                }
            } else {
                strLocation = "" + locationId;
            }

            InvoiceSrc invSrc = new InvoiceSrc();
            invSrc.setVendorId(vendorId);
            invSrc.setPoNumber(poNumber);
            invSrc.setVndInvNumber(vndInvNumber);
            invSrc.setDueDate(dueDate);
            invSrc.setOverDue(overDue);
            invSrc.setStatusOverdue(overStatus);
            invSrc.setLocationId(strLocation);
            invSrc.setInvNumber(srcNumber);

            if (iJSPCommand == JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {
                overDue = 1;
            }

            if (iJSPCommand == JSPCommand.BACK && iJSPCommand != JSPCommand.REFRESH) {
                invSrc = (InvoiceSrc) session.getValue("SRC_POPAY");
            }

            session.putValue("SRC_POPAY", invSrc);

            /*** LANG ***/
            String[] langBT = {"Search for Open Invoice", "Vendor", "Vendor Invoice Number", "Due Date", "Ignore", "Yes", //0-5
                "Status", "Vendor", "Vendor Invoice Number", "Currency", "Amount", "Payment", "Due Date", //6-12
                "Record is Empty", "Please click on search button to find your data", "Overdue", "Doc. Number", "Location"}; //13-17

            String[] langNav = {"Acc. Payable", "Faktur Searching", "Date", "Searching", "Journal Number"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian Faktur yang Belum Terbayarkan", "Suplier", "Invoice Number", "Tanggal Pelunasan", "Abaikan", "Ya",
                    "Status", "Suplier", "Nomor Faktur Suplier", "Mata Uang", "Jumlah", "Pelunasan", "Tanggal Pelunasan",
                    "Tidak ada data", "Silahkan tekan tombol search untuk memulai pencarian data", "Overdue", "Doc. Number", "Lokasi"
                };
                langBT = langID;

                String[] navID = {"Hutang", "Pencarian Faktur", "Tanggal", "Pencarian Faktur Yang Sudah Terproses", "Nomor Jurnal"};
                langNav = navID;
            }


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("select").searchable();
            });
            
            $(document).ready(function() {
                $("#value").html($("#searchabledropdown :selected").text() + " (VALUE: " + $("#searchabledropdown").val() + ")");
                $("select").change(function(){
                    $("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
                });
            });
        </script>        
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script> 
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iJSPCommand == JSPCommand.REFRESH) {%>
            window.location="<%=approot%>/transactionact/bankpopaymentedt.jsp?edt_bankpo_payment_id=<%=bankpoId%>&edt=1";
            <%}%>
            
            function cmdSearchJurnal(){
                var numb = document.frmap.jurnal_number.value;                                
                window.open("<%=approot%>/transactionact/sbankpayment.jsp?txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>", null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }            
                <!--
                function cmdPayment(oid){
                    document.frmap.hidden_vendor_id.value=oid;
                    document.frmap.command.value="<%=JSPCommand.NONE%>";
                    document.frmap.action="bankpopayment.jsp";                
                    document.frmap.submit();
                }
                
                function cmdSearch(){
                    document.frmap.command.value="<%=JSPCommand.FIRST%>";
                    document.frmap.action="bankpopaymentsrc.jsp";
                    document.frmap.submit();
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
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --><%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%> 
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmap" method="post" action="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="hidden_vendor_id">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="2" valign="middle" colspan="3">
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <table width="300" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                                        <tr height="5">
                                                                                            <td colspan=""></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="5">&nbsp;</td>
                                                                                            <td colspan="4" class="fontarial"><b><i><%=langNav[3]%> :</i></b></td>
                                                                                        </tr>
                                                                                        <tr height="25">
                                                                                            <td width="5">&nbsp;</td>
                                                                                            <td class="tablecell1" width="90">&nbsp;&nbsp;<%=langNav[4]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td width="20"><input size="20" type="text" name="jurnal_number" value=""></td>
                                                                                            <td><input type="hidden" name="bankpo_id" value="">
                                                                                                <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search2.jpg',1)"><img src="../images/search.jpg" name="new21" height="17" border="0"></a>
                                                                                            </td>
                                                                                            <td width="5"></td>
                                                                                        </tr>
                                                                                        <tr height="5">
                                                                                            <td colspan="6"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr><td colspan="2" height="15"></td></tr>
                                                                            
                                                                            <tr>
                                                                                <td colspan="2" height="10"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="top" colspan="3" class="comment">                                                                                     
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5">                                                                                                
                                                                                                <table border="0" cellpadding="0" cellspacing="0" >                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td >                                                                                                            
                                                                                                            <table border="0" cellspacing="2" cellpadding="1">
                                                                                                                <tr height="5"> 
                                                                                                                    <td width="120"></td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td width="350"></td>
                                                                                                                    <td width="80"></td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td ></td>
                                                                                                                </tr>
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td colspan="6" height="5" class="fontarial"><b><i><%=langBT[0]%> :</i></b></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="6" height="1"></td>
                                                                                                                </tr>
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[16]%></td> 
                                                                                                                    <td class="fontarial">:</td> 
                                                                                                                    <td ><input type="text" name="src_number" value="<%=srcNumber%>" size="15"></td> 
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[1]%></td>
                                                                                                                    <td class="fontarial">:</td>       
                                                                                                                    <td > 
                                                                                                                        <%
            Vector vnds = DbVendor.list(0, 0, "", "" + DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                        %>
                                                                                                                        <select name="vendorid" class="fontarial">
                                                                                                                            <option value="0">- All Suplier - </option>
                                                                                                                            <%if (vnds != null && vnds.size() > 0) {
                for (int i = 0; i < vnds.size(); i++) {
                    Vendor v = (Vendor) vnds.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=v.getOID()%>" <%if (vendorId == v.getOID()) {%>selected<%}%>><%=v.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>            
                                                                                                                    
                                                                                                                </tr>
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[2]%></td>
                                                                                                                    <td class="fontarial">:</td>       
                                                                                                                    <td ><input type="text" name="vndinvnumber" value="<%=vndInvNumber%>" size="15"></td>                                                                                                                    
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[17]%></td> 
                                                                                                                    <td class="fontarial">:</td> 
                                                                                                                    <td >
                                                                                                                        <select name="src_location_id" class="fontarial">            
                                                                                                                            <option value="0" <%if (locationId == 0) {%>selected<%}%>>- All Locations -</option>
                                                                                                                            <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select> 
                                                                                                                    </td> 
                                                                                                                </tr>
                                                                                                                <tr height="24">                                                                                                       
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[3]%></td>
                                                                                                                    <td class="fontarial">:</td>       
                                                                                                                    <td > 
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="duedate" value="<%=JSPFormater.formatDate(dueDate, "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.duedate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                            
                                                                                                                                <td >&nbsp;&nbsp;<input type="checkbox" name="overdue" value="1" <%if (overDue == 1) {%>checked<%}%>></td>
                                                                                                                                <td class="fontarial"><%=langBT[4]%></td>
                                                                                                                            </tr>       
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langBT[15]%></td> 
                                                                                                                    <td class="fontarial">:</td> 
                                                                                                                    <td >
                                                                                                                        <select name="src_overdue" class="fontarial">
                                                                                                                            <option value = "0" <%if (overStatus == 0) {%> selected<%}%> >- All Status -</option>
                                                                                                                            <option value = "1" <%if (overStatus == 1) {%> selected<%}%> >Overdue</option>
                                                                                                                            <option value = "2" <%if (overStatus == 2) {%> selected<%}%> >Not Overdue</option>
                                                                                                                        </select>  
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                                                                                                                               
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>       
                                                                                        <tr> 
                                                                                            <td colspan="6" width="100%"><table width="800" border="0" cellspacing="0" cellpadding="0"><tr><td background="../images/line.gif"><img src="../images/line.gif"></td></tr></table></td>
                                                                                        </tr> 
                                                                                        <%if (privView) {%>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5" class="boxed1"> 
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="15" class="boxed1"> </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5" class="boxed1"> 
                                                                                                <table width="1160" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr height="28"> 
                                                                                                        <td class="tablehdr" width="60" ><%=langBT[6]%></td>
                                                                                                        <td class="tablehdr" width="80"><%=langBT[7]%></td>
                                                                                                        <td class="tablehdr" width="1000">Description</td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%

            if (iJSPCommand != JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {

                CONResultSet crs = null;
                try {
                    String sql = "select v.vendor_id as vendor_id," +
                            " v.name as vendor_name," +
                            " v.code as code," +
                            " r." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " as receive_id, " +
                            " r." + DbReceive.colNames[DbReceive.COL_PURCHASE_ID] + " as purchase_id, " +
                            " r." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " as type_ap, " +
                            " r." + DbReceive.colNames[DbReceive.COL_CURRENCY_ID] + " as currency_id, " +
                            " r." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " as due_date, " +
                            " r." + DbReceive.colNames[DbReceive.COL_NUMBER] + " as number, " +
                            " r." + DbReceive.colNames[DbReceive.COL_DATE] + " as date, " +
                            " r." + DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE] + " as app_date, " +
                            " r." + DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER] + " as invoice_number, " +
                            " r." + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " as location_id, " +
                            " r." + DbReceive.colNames[DbReceive.COL_NOTE] + " as note " +
                            " from pos_receive r inner join vendor v on r.vendor_id = v.vendor_id where r.status = 'CHECKED' and r.payment_status <> " + I_Project.INV_STATUS_FULL_PAID + " and r.type_ap not in (" + DbReceive.TYPE_AP_REC_ADJ_BY_QTY + "," + DbReceive.TYPE_AP_REC_ADJ_BY_PRICE + ") ";

                    if (invSrc.getVendorId() != 0) {
                        sql = sql + " and r." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + invSrc.getVendorId();
                    }

                    if (invSrc.getOverDue() == 0) {
                        sql = sql + " and r." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " between '" + JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd") + " 23:59:59' ";
                    }

                    if (invSrc.getVndInvNumber().length() > 0) {
                        sql = sql + " and ( lower(r." + DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER] + ") like '%" + invSrc.getVndInvNumber().toLowerCase() + "%'" +
                                " or lower(r." + DbReceive.colNames[DbReceive.COL_DO_NUMBER] + ") like '%" + invSrc.getVndInvNumber().toLowerCase() + "%')";
                    }

                    if (invSrc.getInvNumber().length() > 0) {
                        sql = sql + " and lower(r." + DbReceive.colNames[DbReceive.COL_NUMBER] + ") like '%" + invSrc.getInvNumber().toLowerCase() + "%' ";
                    }

                    if (invSrc.getStatusOverdue() != 0) {
                        if (invSrc.getStatusOverdue() == 1) {
                            sql = sql + " and r." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " < '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + " 23:59:59'";
                        } else {
                            sql = sql + " and r." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " >= '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + " 00:00:00'";
                        }
                    }

                    if (invSrc.getLocationId() != null && invSrc.getLocationId().length() > 0) {
                        sql = sql + " and r." + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " in (" + invSrc.getLocationId() + ") ";
                    }

                    sql = sql + " order by v.name,r." + DbReceive.colNames[DbReceive.COL_DATE] + " desc";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    Vector curs = DbCurrency.list(0, 0, "", null);
                    Hashtable hasCur = new Hashtable();
                    if (curs != null && curs.size() > 0) {
                        for (int d = 0; d < curs.size(); d++) {
                            Currency cx = (Currency) curs.get(d);
                            hasCur.put(String.valueOf(cx.getOID()), String.valueOf(cx.getCurrencyCode()));
                        }
                    }

                    long vendorIdx = 0;
                    double totBalance = 0;
                    int index = 0;
                    while (rs.next()) {
                        index++;
                        long vId = rs.getLong("vendor_id");
                        String vendorName = rs.getString("vendor_name");
                        String vendorCode = rs.getString("code");

                        long receiveId = rs.getLong("receive_id");
                        long purchaseId = rs.getLong("purchase_id");
                        int typeAp = rs.getInt("type_ap");
                        long currencyId = rs.getLong("currency_id");
                        Date dueDatex = rs.getDate("due_date");
                        String docNumber = rs.getString("number");
                        Date datex = rs.getDate("date");

                        Date app1Date = rs.getDate("app_date");
                        String invNumber = rs.getString("invoice_number");
                        long locId = rs.getLong("location_id");
                        String note = rs.getString("note");

                        if (vendorIdx == 0 || vendorIdx != vId) {
                            if (vendorIdx != 0) {
                                                                                                    %>   
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" height="10" class="tablecell">
                                                                                                            <table width="100%" border="0" cellpadding="1" cellspacing="1">
                                                                                                                <tr height="22">
                                                                                                                    <td width="950" >&nbsp;</td>                                                                                                                    
                                                                                                                    <td width="90" class="tablecell1"><b>&nbsp;&nbsp;Total Balance</b></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="80"><%=JSPFormater.formatNumber(totBalance, "#,###.##")%></td>
                                                                                                                </tr> 
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" background="../images/line1.gif" height="3"> 
                                                                                                        </td>
                                                                                                    </tr>  
                                                                                                    <%
                                                                                                                                }

                                                                                                    %>
                                                                                                    <tr height="24"> 
                                                                                                        <td class="tablecell1">&nbsp;</td>
                                                                                                        <td class="tablecell1" colspan="6"> 
                                                                                                            <div align="left">&nbsp;<a href="javascript:cmdPayment('<%=vId%>')"><font size="1"><%=vendorCode + " - " + vendorName%></font></a></div>
                                                                                                        </td>
                                                                                                    </tr>   
                                                                                                    <%
                                                                                                                                totBalance = 0;
                                                                                                                            }


                                                                                                                            Purchase pur = new Purchase();
                                                                                                                            String strPur = "";
                                                                                                                            if (purchaseId != 0) {
                                                                                                                                try {
                                                                                                                                    pur = DbPurchase.fetchExc(purchaseId);
                                                                                                                                    strPur = pur.getNumber() + "<BR>" + JSPFormater.formatDate(pur.getPurchDate(), "dd-MM-yyyy");
                                                                                                                                } catch (Exception e) {
                                                                                                                                    strPur = "";
                                                                                                                                    System.out.println("[exception] " + e.toString());
                                                                                                                                }
                                                                                                                            }

                                                                                                                            String strType = "-";
                                                                                                                            if (typeAp == DbReceive.TYPE_AP_NO) {
                                                                                                                                strType = "Incoming";
                                                                                                                            } else if (typeAp == DbReceive.TYPE_AP_YES) {
                                                                                                                                strType = "Memorial";
                                                                                                                            } else if (typeAp == DbReceive.TYPE_RETUR) {
                                                                                                                                strType = "Retur";
                                                                                                                            }

                                                                                                                            String currCode = "";
                                                                                                                            try {
                                                                                                                                currCode = String.valueOf(hasCur.get(String.valueOf(currencyId)));
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                    %>
                                                                                                    <tr height="24" class="fontarial"> 
                                                                                                        <%if (dueDatex == null) {%>
                                                                                                        <td bgcolor="#D5645B"><div align="center"><font size="1">OVER DUE</font></div></td>
                                                                                                        <%} else {%>
                                                                                                        <%if (dueDatex.before(new Date())) {%>
                                                                                                        <td bgcolor="#D5645B"><div align="center"><font size="1">OVER DUE</font></div></td>
                                                                                                        <%} else {%>
                                                                                                        <td bgcolor="#E6AD49"><div align="center"><font size="1">-</font></div></td>
                                                                                                        <%}%>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"><font size="1"><%=(purchaseId == 0) ? "DIRECT" : strPur%></font></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell">
                                                                                                            <table width="100%" border="0" cellpadding="1" cellspacing="1">
                                                                                                                <tr height="22">
                                                                                                                    <td width="100" class="tablecell1">&nbsp;&nbsp;Doc. Number</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="100" class="fontarial"><b><%=docNumber%></b></td>
                                                                                                                    <td width="120" class="tablecell1">&nbsp;&nbsp;Date</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="150" class="fontarial"><%=JSPFormater.formatDate(datex, "dd/MM/yyyy") %></td>
                                                                                                                    <td width="100" class="tablecell1">&nbsp;&nbsp;Approval Date</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="80" class="fontarial"><%=JSPFormater.formatDate(app1Date, "dd/MM/yyyy") %></td>
                                                                                                                    <td width="90" class="tablecell1">&nbsp;&nbsp;Due Date</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <%if (dueDatex == null) {%>
                                                                                                                    <td width="100" class="fontarial">-</td>
                                                                                                                    <%} else {%>
                                                                                                                    <td width="100" class="fontarial"><%=JSPFormater.formatDate(dueDatex, "dd/MM/yyyy") %></td>
                                                                                                                    <%}%>
                                                                                                                    <td width="70" >&nbsp;</td>
                                                                                                                    <td width="1" ></td>
                                                                                                                    <td width="70" ></td>
                                                                                                                    <td width="70" >&nbsp;</td>
                                                                                                                    <td width="1" ></td>
                                                                                                                    <td width="80"></td>
                                                                                                                </tr>    
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Type Doc.</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial"><%=strType%></td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Invoice Number</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial"><%=invNumber%></td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Currency</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial"><%=currCode%></td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Jumlah</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <%

                                                                                                                            //Receive recTotal = QrInvoice.getIncoming(inv.getOID());        
                                                                                                                            double totInvoice = QrInvoice.getTotal(typeAp, receiveId);//recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal();
                                                                                                                            double totalAdj = 0;
                                                                                                                            try {
                                                                                                                                totalAdj = QrInvoice.getIncomingByReference(receiveId);
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                                            totInvoice = totInvoice + totalAdj;
                                                                                                                    %>
                                                                                                                    <td class="fontarial"><%=JSPFormater.formatNumber(totInvoice, "#,###.##")%></td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Payment</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <%
                                                                                                                            double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoice(receiveId);
                                                                                                                            totBalance = totBalance + (totInvoice - balanceTotal);
                                                                                                                    %>
                                                                                                                    <td class="fontarial"><%=JSPFormater.formatNumber(balanceTotal, "#,###.##")%></td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Balance</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial"><%=JSPFormater.formatNumber((totInvoice - balanceTotal), "#,###.##")%></td>
                                                                                                                </tr> 
                                                                                                                <tr> 
                                                                                                                    <td  colspan="18" background="../images/line1.gif" height="1"> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table> 
                                                                                                        </td>                                                                                                        
                                                                                                    </tr>                      
                                                                                                    <%

                                                                                                                            vendorIdx = vId;
                                                                                                                        }
                                                                                                                        if (index != 0) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" height="10" class="tablecell">
                                                                                                            <table width="100%" border="0" cellpadding="1" cellspacing="1">
                                                                                                                <tr height="22">
                                                                                                                    <td width="950" >&nbsp;</td>                                                                                                                    
                                                                                                                    <td width="90" class="tablecell1"><b>&nbsp;&nbsp;Total Balance</b></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="80"><%=JSPFormater.formatNumber(totBalance, "#,###.##")%></td>
                                                                                                                </tr> 
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" colspan="7" height="21"> 
                                                                                                            <div align="left">&nbsp;<font color="#000"><i><%=langBT[13]%></i></font></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}

                                                                                                                    } catch (Exception e) {
                                                                                                                    }

                                                                                                                } else {%>                
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" colspan="7" height="21"><i><%=langBT[14]%></i></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
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
