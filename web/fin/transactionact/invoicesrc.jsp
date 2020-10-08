
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_IGL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long locationId = JSPRequestValue.requestLong(request, "location_id");

            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            String nomorDocument = JSPRequestValue.requestString(request, "nomor_document");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            int non = JSPRequestValue.requestInt(request, "type_non");
            int konsinyasi = JSPRequestValue.requestInt(request, "type_konsinyasi");
            int komisi = JSPRequestValue.requestInt(request, "type_komisi");

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
                non = 1;
                konsinyasi = 1;
                komisi = 1;
            }
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 25;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;          

            CmdReceive cmdReceive = new CmdReceive(request);
            JSPLine ctrLine = new JSPLine();
            Vector listReceive = new Vector(1, 1);
            
            /*count list All Receive*/         
            int vectSize = SessReceive.countReceive(srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);
            msgString = cmdReceive.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdReceive.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */           
            listReceive = SessReceive.listReceive(start,recordToGet,srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listReceive.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listReceive = SessReceive.listReceive(start,recordToGet,srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);
            }

            if (iJSPCommand == JSPCommand.POST) {
                if (listReceive != null && listReceive.size() > 0) {
                    ExchangeRate er = DbExchangeRate.getStandardRate();
                    for (int i = 0; i < listReceive.size(); i++) {
                        Receive receive = (Receive) listReceive.get(i);
                        int pilih = JSPRequestValue.requestInt(request, "pilih" + receive.getOID());
                        if (pilih == 1) {
                            SessReceive.postingReceive(receive.getOID(), user, sysCompany, er);
                        }
                    }

                    vectSize = SessReceive.countReceive(srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);
                    listReceive = SessReceive.listReceive(start,recordToGet,srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);

                    if (listReceive.size() < 1 && start > 0) {
                        if (vectSize - recordToGet > recordToGet) {
                            start = start - recordToGet;
                        } //go to JSPCommand.PREV
                        else {
                            start = 0;
                            iJSPCommand = JSPCommand.FIRST;
                            prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                        }
                        listReceive = SessReceive.listReceive(start,recordToGet,srcVendorId,nomorDocument,srcIgnore,srcStartDate,srcEndDate,locationId,non,konsinyasi,komisi);
                    }
                }
            }

            /*** LANG ***/
            String[] langAP = {"Search Parameters", "Vendor", "PO Between", "and", "Ignored", "Invoice Number", //0-5
                "No", "Number", "Date", "PO Number", "Receive Loc.", "Vendor", "Amount", "Status", "Notes", "Searching Parameter"}; //6-15

            String[] langNav = {"Account Payable", "Incoming Goods List", "Date", "Klik serach button to searching the data", "Data not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Parameter Pencarian", "Suplier", "Tanggal", "sampai", "Abaikan", "Nomor Faktur", //0-5
                    "No", "Nomor Faktur", "Tanggal", "Nomor PO", "Lokasi Penerimaan", "Suplier", "Jumlah", "Status", "Catatan", "Parameter Pencarian :"}; //6-15
                langAP = langID;

                String[] navID = {"Hutang", "Daftar Penerimaan Barang", "Tanggal", "Klik tombol seacrh untuk melakukan pencarian data", "Data tidak ditemukan"};
                langNav = navID;
            }
            
           
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
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
            <%if (!priv && !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function setChecked(val){                            
                 <%
            for (int k = 0; k < listReceive.size(); k++) {
                Receive bp = (Receive) listReceive.get(k);
                %>
                    document.frmreceive.pilih<%=bp.getOID()%>.checked=val.checked;
                    
                    <%}%>                    
                }
                
                function cmdPost(){            	
                    document.frmreceive.command.value="<%=JSPCommand.POST%>";                
                    document.frmreceive.action="invoicesrc.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdSearch(){
                    document.frmreceive.command.value="<%=JSPCommand.LIST%>";
                    document.frmreceive.action="invoicesrc.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdEdit(oid){
                    document.frmreceive.hidden_receive_id.value=oid;	
                    document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="invoice_edit.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdAdd(){
                    document.frmreceive.hidden_receive_id.value="0";
                    document.frmreceive.command.value="<%=JSPCommand.ADD%>";
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="invoice_edit.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdListFirst(){
                    document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
                    document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmreceive.action="invoicesrc.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdListPrev(){
                    document.frmreceive.command.value="<%=JSPCommand.PREV%>";
                    document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmreceive.action="invoicesrc.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdListNext(){
                    document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
                    document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmreceive.action="invoicesrc.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdListLast(){
                    document.frmreceive.command.value="<%=JSPCommand.LAST%>";
                    document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmreceive.action="invoicesrc.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                    <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                         %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
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
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">   
                                                                                                <table border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="6" height="5"></td>
                                                                                                    </tr> 
                                                                                                    <tr>                                                                                                                    
                                                                                                        <td colspan="6" height="5"><i><b><%=langAP[15]%></b></i></td>
                                                                                                    </tr>                                                                                                                  
                                                                                                    <tr height="23">
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langAP[1]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td colspan="4"> 
                                                                                                            <select name="src_vendor_id" class="fontarial">
                                                                                                                <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- All Vendor -</option>
                                                                                                                <%
            Vector vendors = DbVendor.list(0, 0, "", "name");
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>                                                                                                                              
                                                                                                    </tr>
                                                                                                    <tr height="23">
                                                                                                        <td width="100" class="tablecell1" style="padding:3px;"><%=langAP[5]%></td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td width="400"><input type="text" name="nomor_document" value = "<%=nomorDocument%>" class="fontarial"></td>
                                                                                                        <td width="100" class="tablecell1" style="padding:3px;"><%=langAP[10]%></td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td width="300">
                                                                                                            <select name="location_id" class="fontarial">
                                                                                                                <option value="<%=0%>" <%if (locationId == 0) {%>selected<%}%>>- All Lokasi -</option>
                                                                                                                <%
            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_CODE]);

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (locationId == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23">
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langAP[2]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;<%=langAP[3]%>&nbsp;&nbsp;</td>
                                                                                                                    <td>
                                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                                                                                    <td class="fontarial"><%=langAP[4]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>       
                                                                                                        <td class="tablecell1" style="padding:3px;">Tipe</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input type="checkbox" name = "type_non" value = "1" <%if (non == 1) {%>checked<%}%>></td> 
                                                                                                                    <td class="fontarial">Beli Putus</td>
                                                                                                                    <td>&nbsp;&nbsp;<input type="checkbox" name = "type_konsinyasi" value = "1" <%if (konsinyasi == 1) {%>checked<%}%>></td> 
                                                                                                                    <td class="fontarial">&nbsp;Konsinyasi</td>
                                                                                                                    <td>&nbsp;&nbsp;<input type="checkbox" name = "type_komisi" value = "1" <%if (komisi == 1) {%>checked<%}%>></td> 
                                                                                                                    <td class="fontarial">&nbsp;Komisi</td>
                                                                                                                </tr>    
                                                                                                            </table> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="3" height="5">
                                                                                                <table width="80%" border="0" cellspacing="1" cellpadding="1" >                                                                                                                            
                                                                                                    <tr > 
                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>   
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listReceive.size() > 0) {
                                                                                        %>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            &nbsp; </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <table width="1150" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="23">                                                                                                        
                                                                                                        <td class="tablehdr" width="25"><%=langAP[6]%></td>
                                                                                                        <td class="tablehdr" width="80"><%=langAP[7]%></td>
                                                                                                        <td class="tablehdr" width="60"><%=langAP[8]%></td>
                                                                                                        <td class="tablehdr" width="150"><%=langAP[10]%></td>
                                                                                                        <td class="tablehdr" width="200"><%=langAP[11]%></td>
                                                                                                        <td class="tablehdr" width="80"><%=langAP[12]%></td>
                                                                                                        <td class="tablehdr" width="60"><%=langAP[13]%></td>
                                                                                                        <td class="tablehdr"><%=langAP[14]%></td>
                                                                                                        <td class="tablehdr" width="25"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                    </tr>    
                                                                                                    <%

                                                                                                if (listReceive != null && listReceive.size() > 0) {
                                                                                                    for (int i = 0; i < listReceive.size(); i++) {
                                                                                                        Receive receive = (Receive) listReceive.get(i);
                                                                                                        String style = "";
                                                                                                        if (i % 2 == 0) {
                                                                                                            style = "tablecell";
                                                                                                        } else {
                                                                                                            style = "tablecell1";
                                                                                                        }

                                                                                                        Location location = new Location();
                                                                                                        try {
                                                                                                            location = DbLocation.fetchExc(receive.getLocationId());
                                                                                                        } catch (Exception e) {
                                                                                                        }

                                                                                                        Vendor vendorx = new Vendor();
                                                                                                        try {
                                                                                                            vendorx = DbVendor.fetchExc(receive.getVendorId());
                                                                                                        } catch (Exception e) {
                                                                                                        }
                                                                                                        
                                                                                                        Receive r = QrInvoice.getIncoming(receive.getOID());                                                                                                        

                                                                                                    %>
                                                                                                    <tr height="23">                                                                                                        
                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><%=(start + i + 1)%></td>
                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><a href="javascript:cmdEdit('<%=receive.getOID()%>')"> <%=receive.getNumber()%></a></td>
                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><%=JSPFormater.formatDate(receive.getDate(), "dd MMM yyyy")%></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=location.getName()%></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=vendorx.getName()%></td>
                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber((r.getTotalAmount() + r.getTotalTax() - r.getDiscountTotal()), "#,###.##")%></td>
                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><%=((receive.getStatus().length() == 0) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=receive.getNote() %></td>
                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><input type="checkbox" name="pilih<%=receive.getOID()%>" value="1"></td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                                }%>             
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } else {
                                                                                                if (iJSPCommand == JSPCommand.LIST) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"><i><%=langNav[4]%>....</i></td>
                                                                                        </tr>
                                                                                        
                                                                                        <%
                    }
                }
            } catch (Exception exc) {
                System.out.println("excption : " + exc.toString());
            }%>
                                                                                        <%if (iJSPCommand == JSPCommand.NONE && (listReceive == null || listReceive.size() <= 0)) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"><i><%=langNav[3]%>...</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                <span class="command"> 
                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (listReceive != null && listReceive.size() > 0 && (privUpdate || privAdd || privDelete)) {%>
                                                                                        <tr>
                                                                                            <td align="left"><a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a></td>                                     
                                                                                        </tr> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                            
                                                        </form>
                                                        <span class="level2"><br>
                                                    </span><!-- #EndEditable --> </td>
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

