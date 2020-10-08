
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MASTER_MAINTENANCE), AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MASTER_MAINTENANCE), AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MASTER_MAINTENANCE), AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MASTER_MAINTENANCE), AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MASTER_MAINTENANCE), AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            int inpConsigment = JSPRequestValue.requestInt(request, "inp_consigment");
            int inpKomisi = JSPRequestValue.requestInt(request, "inp_komisi");
            int inpBeliputus = JSPRequestValue.requestInt(request, "inp_beliputus");
            int group = JSPRequestValue.requestInt(request, "src_group");
            int tax = JSPRequestValue.requestInt(request, "src_tax");
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            if (session.getValue("REPORT_VENDOR_LIST") != null) {
                session.removeValue("REPORT_VENDOR_LIST");
            }

            if (iJSPCommand == JSPCommand.NONE) {
                inpConsigment = 1;
                inpKomisi = 1;
                inpBeliputus = 1;
                tax = -1;
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

            if (group != -1) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + group;
            }


            if (tax != -1) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + tax;
            }

            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_CODE] + " like '%" + srcCode + "%'";
            }

            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_NAME] + " like '%" + srcName + "%'";
            }
            
            
            
            

            String wOR = "";            
            
            if (inpConsigment == 1) {
                wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 1 ";
            }else{
                wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 ";
            }

            if (inpKomisi == 1) {
                if (wOR.length() > 0) {
                    wOR = wOR + " or ";
                }
                wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 1 ";
            }else{
                if (wOR.length() > 0) {
                    wOR = wOR + " or ";
                }
                wOR = wOR + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = -1 ";
            }
            
            if(inpBeliputus==1){
                if (wOR.length() > 0) {
                    wOR = wOR + " or ";
                }
                 wOR = wOR + " ( "+DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 0 and "+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" = 0 )";
                
            }else{
                if (wOR.length() > 0) {
                    wOR = wOR + " or ";
                }
                wOR = wOR + " ( "+DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = -1 and "+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" = -1 )";
            }

            if (wOR.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ( " + wOR + " )";
            }

            String orderClause = "name";

            CmdVendor ctrlVendor = new CmdVendor(request);
            ctrlVendor.setUserId(user.getOID());
            JSPLine ctrLine = new JSPLine();
            Vector listVendor = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlVendor.action(iJSPCommand, oidVendor);
            /* end switch*/
            JspVendor jspVendor = ctrlVendor.getForm();

            /*count list All Vendor*/
            int vectSize = DbVendor.getCount(whereClause);

            Vendor vendor = ctrlVendor.getVendor();
            msgString = ctrlVendor.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlVendor.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listVendor = DbVendor.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listVendor.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listVendor = DbVendor.list(start, recordToGet, whereClause, orderClause);
            }

            Vector vpar = new Vector();
            vpar.add(String.valueOf(group));
            vpar.add(String.valueOf(srcCode));
            vpar.add(String.valueOf(srcName));
            vpar.add(String.valueOf(tax));
            vpar.add(String.valueOf(inpKomisi));
            vpar.add(String.valueOf(inpConsigment));
            vpar.add(String.valueOf(inpBeliputus));

            session.putValue("REPORT_VENDOR_LIST", vpar);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUnShowAll(){                
                document.frmvendor.command.value="<%=JSPCommand.LIST%>";                
                document.frmvendor.show_all.value=0;
                document.frmvendor.action="vendor.jsp";
                document.frmvendor.submit();
            }
            
            function cmdShowAll(){                
                document.frmvendor.command.value="<%=JSPCommand.LIST%>";                
                document.frmvendor.show_all.value=1;
                document.frmvendor.action="vendor.jsp";
                document.frmvendor.submit();
            }
            
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportVendorXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmvendor.hidden_vendor_id.value="0";
                    document.frmvendor.command.value="<%=JSPCommand.FIRST%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdAdd(){
                    document.frmvendor.hidden_vendor_id.value="0";
                    document.frmvendor.command.value="<%=JSPCommand.ADD%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdAsk(oidVendor){
                    document.frmvendor.hidden_vendor_id.value=oidVendor;
                    document.frmvendor.command.value="<%=JSPCommand.ASK%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdConfirmDelete(oidVendor){
                    document.frmvendor.hidden_vendor_id.value=oidVendor;
                    document.frmvendor.command.value="<%=JSPCommand.DELETE%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                function cmdSave(){
                    document.frmvendor.command.value="<%=JSPCommand.SAVE%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdEdit(oidVendor){
                    document.frmvendor.hidden_vendor_id.value=oidVendor;
                    document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdCancel(oidVendor){
                    document.frmvendor.hidden_vendor_id.value=oidVendor;
                    document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
                    document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdBack(){
                    document.frmvendor.command.value="<%=JSPCommand.BACK%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdListFirst(){
                    document.frmvendor.command.value="<%=JSPCommand.FIRST%>";
                    document.frmvendor.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdListPrev(){
                    document.frmvendor.command.value="<%=JSPCommand.PREV%>";
                    document.frmvendor.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdListNext(){
                    document.frmvendor.command.value="<%=JSPCommand.NEXT%>";
                    document.frmvendor.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function cmdListLast(){
                    document.frmvendor.command.value="<%=JSPCommand.LAST%>";
                    document.frmvendor.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmvendor.action="vendor.jsp";
                    document.frmvendor.submit();
                }
                
                function isKonsinyasi(){                
                    if(document.frmvendor.<%=JspVendor.colNames[JspVendor.JSP_IS_KONSINYASI]%>.checked == true){
                        document.all.inpkonsinyasi.style.display="";
                    }else{                    
                    document.all.inpkonsinyasi.style.display="none";
                }
            }    
            
            function isKomisi(){                
                if(document.frmvendor.<%=JspVendor.colNames[JspVendor.JSP_IS_KOMISI]%>.checked == true){
                    document.all.inpkomisi.style.display="";                
                }else{                    
                document.all.inpkomisi.style.display="none";
            }
        }  
        
        function orderDays(){                
            if(document.frmvendor.order_days.checked == true){
                document.all.inporderdays.style.display="";
            }else{                    
            document.all.inporderdays.style.display="none";
        }
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmvendor" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_vendor_id" value="<%=oidVendor%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                        Maintenance </font><font class="tit1">&raquo; 
                                                                                </font> <span class="lvl2">Vendor List</span></b></td>
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
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="5" valign="middle" colspan="3"></td>
                                                                                        </tr>                                                                                       
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="22" valign="middle" colspan="3" >
                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td  >
                                                                                                            <table  border="0" align="center" cellspacing="1" cellpadding="1">
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td colspan="2" height="15"> 
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td width="80" class="tablearialcell1">&nbsp;&nbsp;Group</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="250">
                                                                                                                        <select name ="src_group">
                                                                                                                            <option value="<%=DbVendor.VENDOR_TYPE_SUPPLIER%>" <%if (group == DbVendor.VENDOR_TYPE_SUPPLIER) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_SUPPLIER] %></option>
                                                                                                                            <option value="<%=DbVendor.VENDOR_TYPE_GA%>" <%if (group == DbVendor.VENDOR_TYPE_GA) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_GA] %></option>
                                                                                                                        </select>
                                                                                                                    </td>      
                                                                                                                    <td width="100" class="tablearialcell1">&nbsp;&nbsp;Code</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td ><input type="text" name="src_code" size="25" value="<%=srcCode%>"></td>                                                                                                                   
                                                                                                                </tr>
                                                                                                                <tr>   
                                                                                                                    <td class="tablearialcell1">&nbsp;&nbsp;Vendor Name</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td><input type="text" name="src_name" size="25" value="<%=srcName%>"></td>
                                                                                                                    <td class="tablearialcell1">&nbsp;&nbsp;Type</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input type="checkbox" name="inp_beliputus"  value="1" <%if (inpBeliputus == 1) {%>checked<%}%> ></td>                                                                                                            
                                                                                                                                <td>&nbsp;&nbsp;Beli Putus&nbsp;&nbsp;</td>
                                                                                                                                <td><input type="checkbox" name="inp_consigment"  value="1" <%if (inpConsigment == 1) {%>checked<%}%> ></td>                                                                                                            
                                                                                                                                <td>&nbsp;&nbsp;Consigment&nbsp;&nbsp;</td>
                                                                                                                                <td><input type="checkbox" name="inp_komisi" value="1" <%if (inpKomisi == 1) {%>checked<%}%> ></td>
                                                                                                                                <td>&nbsp;&nbsp;Komisi&nbsp;&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td> 
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell1">&nbsp;&nbsp;Tax</td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td colspan="4">
                                                                                                                        <select name ="src_tax">
                                                                                                                            <option value="-1" <%if (tax == -1) {%> selected <%}%> >- All -</option>
                                                                                                                            <option value="1" <%if (tax == 1) {%> selected <%}%> >PKP</option>
                                                                                                                            <option value="0" <%if (tax == 0) {%> selected <%}%> >NON PKP</option>
                                                                                                                        </select>
                                                                                                                    </td> 
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6" >
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                                                                            <tr > 
                                                                                                                                <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>  
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6" >
                                                                                                                        <a href="javascript:cmdSearch()"><img src="../images/search2.gif" width="59" height="21" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                               
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="5" valign="middle" colspan="3">
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="15" valign="middle" colspan="3"></td>
                                                                                        </tr>        
                                                                                        <%
            try {
                if (listVendor.size() > 0) {
                                                                                        %>                                                                                        
                                                                                        <%if (listVendor != null && listVendor.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="1100" border="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="25" class="tablearialhdr" rowspan="2">No</td>
                                                                                                        <td width="80" class="tablearialhdr" rowspan="2">Code</td>
                                                                                                        <td width="80" class="tablearialhdr" rowspan="2">Consigment/<BR>Komisi</td>
                                                                                                        <td width="230" class="tablearialhdr" rowspan="2">Name</td>                                                                                                        
                                                                                                        <td width="150" class="tablearialhdr" rowspan="2">A/N</td>
                                                                                                        <td width="100" class="tablearialhdr" rowspan="2">Bank</td>
                                                                                                        <td class="tablearialhdr" colspan="3">Consigment</td>
                                                                                                        <td class="tablearialhdr" colspan="3">Komisi</td>
                                                                                                    </tr>
                                                                                                    <tr height="20">
                                                                                                        <td width="5%" class="tablearialhdr" >Margin (%)</td>
                                                                                                        <td width="7%" class="tablearialhdr" >Promosi (%)</td>
                                                                                                        <td width="7%" class="tablearialhdr" >Barcode</td>
                                                                                                        <td width="5%" class="tablearialhdr" >Margin (%)</td>
                                                                                                        <td width="7%"class="tablearialhdr"  >Promosi (%)</td>
                                                                                                        <td width="7%" class="tablearialhdr" >Barcode</td>
                                                                                                    </tr>
                                                                                                    <%
    for (int i = 0; i < listVendor.size(); i++) {

        Vendor obVendor = (Vendor) listVendor.get(i);
        String type = "BELI PUTUS";
        if (obVendor.getIsKonsinyasi() == 0 && obVendor.getIsKomisi() == 0) {
            type = "BELI PUTUS";
        } else {
            type = "";
            if (obVendor.getIsKonsinyasi() == 1) {
                type = "Consigment";
            }

            if (obVendor.getIsKomisi() == 1) {
                if (type.length() > 0) {
                    type = type + " & ";
                }
                type = type + "Komisi";
            }
        }

        String style = "";
        if (i % 2 == 0) {
            style = "tablearialcell1";
        } else {
            style = "tablearialcell";
        }

        Bank b = new Bank();
        if (obVendor.getBankId() != 0) {
            try {
                b = DbBank.fetchExc(obVendor.getBankId());
            } catch (Exception e) {
            }
        }
        String noRek = "";
        if (obVendor.getNoRek() == null) {
            noRek = "";
        } else {
            noRek = obVendor.getNoRek();
        }

        String strPic = "";
        if (obVendor.getPic() != null && obVendor.getPic().length() > 0 && obVendor.getPic().compareTo("null") != 0) {
            strPic = obVendor.getPic();
        }

                                                                                                    %>
                                                                                                    <tr height="20">
                                                                                                        <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><a href="javascript:cmdEdit('<%=obVendor.getOID()%>')"><%=obVendor.getCode()%></a></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%=type.toUpperCase()%></td>
                                                                                                        <td class="<%=style%>"><%=obVendor.getName().toUpperCase() %></td>                                                                                                        
                                                                                                        <td class="<%=style%>"><%=strPic%></td>
                                                                                                        <td class="<%=style%>"><%=b.getName().toUpperCase() %></td>                                                                                                        
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getPercentMargin()%> %</td>
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getPercentPromosi()%> %</td>
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getPercentBarcode()%></td>
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getKomisiMargin()%> %</td>
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getKomisiPromosi()%> %</td>
                                                                                                        <td class="<%=style%>" align="right"><%=obVendor.getKomisiBarcode()%> %</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
            }%>
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
                                                                                            <td height="5" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <table width="100%" border="0">
                                                                                                    <tr>
                                                                                                        <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                                                        <td width="100"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>
                                                                                                        <%}%>
                                                                                                        <%if (listVendor != null && listVendor.size() > 0 && privPrint) {%>
                                                                                                        <td><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspVendor.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="900" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td width="80">&nbsp;</td>
                                                                                            <td width="1">&nbsp;</td>
                                                                                            <td width="200">&nbsp;</td>
                                                                                            <td width="80">&nbsp;</td>
                                                                                            <td width="1">&nbsp;</td>
                                                                                            <td width="200">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td >&nbsp;</td>
                                                                                            <td colspan="5"><b><i>*)= required</i></b></td>                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Group</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name ="<%=jspVendor.colNames[JspVendor.JSP_TYPE] %>" class="tablearialcell">
                                                                                                    <option value="<%=DbVendor.VENDOR_TYPE_SUPPLIER%>" <%if (vendor.getType() == DbVendor.VENDOR_TYPE_SUPPLIER) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_SUPPLIER] %></option>
                                                                                                    <option value="<%=DbVendor.VENDOR_TYPE_GA%>" <%if (vendor.getType() == DbVendor.VENDOR_TYPE_GA) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_GA] %></option>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Code</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_CODE] %>"  value="<%= vendor.getCode() %>" class="tablearialcell" size="15">
                                                                                                * <%= jspVendor.getErrorMsg(JspVendor.JSP_CODE) %> 
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Include PPN</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_INCLUDE_PPN] %>" class="tablearialcell"  value="1" <%if (vendor.getIncludePPN() == 1) {%>checked<%}%>> </td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Name</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_NAME] %>"  value="<%= vendor.getName() %>" class="formElemen" size="46">
                                                                                                * <%= jspVendor.getErrorMsg(JspVendor.JSP_NAME) %> 
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;PKP</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_IS_PKP] %>"  value="1" <%if (vendor.getIsPKP() == 1) {%>checked<%}%>> </td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Address</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_ADDRESS] %>"  value="<%= vendor.getAddress() %>" class="formElemen" size="46">
                                                                                                * <%= jspVendor.getErrorMsg(JspVendor.JSP_ADDRESS) %> 
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Direct Receive</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_DIRECT_RECEIVE] %>"  value="1" <%if (vendor.getDirectReceive() == 1) {%>checked<%}%>> </td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;City</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_CITY] %>"  value="<%= vendor.getCity() %>" class="formElemen" size="25">
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Due Date</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > <select name="<%=jspVendor.colNames[JspVendor.JSP_DUE_DATE] %>" class="formElemen">
                                                                                                    <%for (int i = 0; i < 100; i++) {%>
                                                                                                    <option value="<%=i%>" <%if (i == vendor.getDueDate()) {%>selected<%}%>><%=i%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            day(s) </td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;State</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_STATE] %>"  value="<%= vendor.getState() %>" class="formElemen" size="25">
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Discount</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_DISCOUNT] %>"  value="<%= vendor.getDiscount() %>" class="formElemen" size="5">
                                                                                            %</td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Country</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <% Vector countryid_value = new Vector(1, 1);
    Vector countryid_key = new Vector(1, 1);
    Vector vctr = DbCountry.list(0, 0, "", "name");
    String sel_countryid = "" + vendor.getCountryId();
    if (vctr != null && vctr.size() > 0) {
        for (int i = 0; i < vctr.size(); i++) {
            Country c = (Country) vctr.get(i);
            countryid_key.add("" + c.getOID());
            countryid_value.add("" + c.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspVendor.colNames[JspVendor.JSP_COUNTRY_ID], null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> 
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Prev. Liability</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_PREV_LIABILITY]%>"  value="<%= vendor.getPrevLiability() %>" class="formElemen" size="25" style="text-align:right"></td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Phone/Fax</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_PHONE] %>"  value="<%= vendor.getPhone() %>" class="formElemen" size="20">
                                                                                                / 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_FAX] %>"  value="<%= vendor.getFax() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Purchase</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;N P W P</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_NPWP] %>"  value="<%= vendor.getNpwp() %>" class="formElemen" size="46">
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Retur/Debet/Credit</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield2" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"> </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Email</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_EMAIL] %>"  value="<%= vendor.getEmail() %>" class="formElemen" size="46">
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Payment</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield3" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"></td>
                                                                                        </tr>
                                                                                        <input type="hidden" name="<%=jspVendor.colNames[JspVendor.JSP_NO_REK] %>"  value="<%= vendor.getNoRek() %>" >
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Pending one PO</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                            <input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_PENDING_ONE_PO] %>"  value="1" <%if (vendor.getPendingOnePo() == DbVendor.TYPE_ONE_PENDING_PO) {%>checked<%}%> >
                                                                                                   </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Giro</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield4" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"></td>
                                                                                        </tr>
                                                                                        <input type="hidden" name="<%=jspVendor.colNames[JspVendor.JSP_CONTACT]%>"  value="<%= vendor.getContact()%>" class="formElemen" size="46">                                                                                            
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Contact Person</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_PIC] %>"  value="<%= vendor.getPic() %>" class="formElemen" size="46">                                                                                            
                                                                                            </td>
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Total Liability</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield5" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;HP</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_HP] %>"  value="<%= vendor.getHp() %>" class="formElemen" size="20">                                                                                            
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Last Purchase</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="textfield6" size="25" style="text-align:right" class="readOnly" readOnly value="0.00"></td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Consigment</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <input type="checkbox" onclick="javascript:isKonsinyasi()"  name="<%=JspVendor.colNames[JspVendor.JSP_IS_KONSINYASI] %>"  value="1" <%if (vendor.getIsKonsinyasi() == 1) {%>checked<%}%> ></div>                                                                                             
                                                                                            </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr>
                                                                                        <tr height="22" id="inpkonsinyasi"> 
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td > 
                                                                                                <table width="200" border="0">
                                                                                                    <tr>
                                                                                                        <td class="tablecell1">
                                                                                                            <table width="230" >                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="3"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="2" class="fontarial"><B>&nbsp;&nbsp;<i>Consigment Setup</i></b></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" width="80" class="fontarial" >&nbsp;&nbsp;System</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        <select name = "<%=jspVendor.colNames[JspVendor.JSP_SYSTEM]%>" class="fontarial">
                                                                                                                            <option value= <%=DbVendor.TYPE_SYSTEM_HJ%> <%if (vendor.getSystem() == DbVendor.TYPE_SYSTEM_HJ) {%>selected<%}%> >Harga Jual</option>
                                                                                                                            <option value= <%=DbVendor.TYPE_SYSTEM_HB%> <%if (vendor.getSystem() == DbVendor.TYPE_SYSTEM_HB) {%>selected<%}%> >Harga Beli</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" class="fontarial" >&nbsp;&nbsp;Price Margin</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        <input name="<%=jspVendor.colNames[JspVendor.JSP_PERCENT_MARGIN]%>" size="15" style="text-align:right" size="10" value="<%=vendor.getPercentMargin()%>" class="fontarial">&nbsp;%
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle"  class="fontarial">&nbsp;&nbsp;Promosi</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        <input name="<%=jspVendor.colNames[JspVendor.JSP_PERCENT_PROMOSI]%>" size="15" style="text-align:right" size="10" value="<%=vendor.getPercentPromosi()%>">&nbsp;%
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle"  class="fontarial">&nbsp;&nbsp;Barcode</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        Rp.&nbsp;<input name="<%=jspVendor.colNames[JspVendor.JSP_PERCENT_BARCODE]%>" size="11" style="text-align:right" size="10" value="<%=vendor.getPercentBarcode()%>">&nbsp;
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="3"></td>
                                                                                                                </tr> 
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Komisi</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                            <input type="checkbox" onclick="javascript:isKomisi()"  name="<%=JspVendor.colNames[JspVendor.JSP_IS_KOMISI] %>"  value="1" <%if (vendor.getIsKomisi() == 1) {%>checked<%}%> >                                                                                             
                                                                                                   </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr>
                                                                                        <tr height="22" id="inpkomisi"> 
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td>
                                                                                                <table width="200" border="0">
                                                                                                    <tr>
                                                                                                        <td class="tablecell1">
                                                                                                            <table width="230" >                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="3"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="2"  class="fontarial"><B>&nbsp;&nbsp;<i>Komisi Setup</i></b></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle"  class="fontarial">&nbsp;&nbsp;Price Margin</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        <input name="<%=jspVendor.colNames[JspVendor.JSP_KOMISI_MARGIN]%>" size="15" style="text-align:right" size="10" value="<%=vendor.getKomisiMargin()%>">&nbsp;%
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle"  class="fontarial">&nbsp;&nbsp;Promosi</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        <input name="<%=jspVendor.colNames[JspVendor.JSP_KOMISI_PROMOSI]%>" size="15" style="text-align:right" size="10" value="<%=vendor.getKomisiPromosi()%>">&nbsp;%
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle"  class="fontarial">&nbsp;&nbsp;Barcode</td>
                                                                                                                    <td height="8" valign="middle" >:&nbsp;
                                                                                                                        Rp.&nbsp;<input name="<%=jspVendor.colNames[JspVendor.JSP_KOMISI_BARCODE]%>" size="11" style="text-align:right" size="10" value="<%=vendor.getKomisiBarcode()%>">&nbsp;
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td colspan="2" height="3"></td>
                                                                                                                </tr> 
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td colspan="3"></td>    
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Show Order Days</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <div><input type="checkbox" onclick="javascript:orderDays()" name="order_days" value="0"></div>
                                                                                            </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr>
                                                                                        <tr height="22" id="inporderdays"> 
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td>
                                                                                                <table width="150" border="0">
                                                                                                    <tr>
                                                                                                        <td class="tablecell1">
                                                                                                            <table width="100" border="0" >                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td colspan="4" height="3"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="4"><B>&nbsp;&nbsp;<u>Order Days</u></b></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="4" height="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Senin</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_SENIN] %>"  value="1" <%if (vendor.getOdrSenin() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Selasa</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_SELASA] %>"  value="1" <%if (vendor.getOdrSelasa() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Rabu</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_RABU] %>"  value="1" <%if (vendor.getOdrRabu() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Kamis</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_KAMIS] %>"  value="1" <%if (vendor.getOdrKamis() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Jumat</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_JUMAT] %>"  value="1" <%if (vendor.getOdrJumat() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Sabtu</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_SABTU] %>"  value="1" <%if (vendor.getOdrSabtu() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td height="8" valign="middle" >Minggu</td>
                                                                                                                    <td height="8" valign="middle" >
                                                                                                                        <div><input type="checkbox" name="<%=JspVendor.colNames[JspVendor.JSP_ODR_MINGGU] %>"  value="1" <%if (vendor.getOdrMinggu() == 1) {%>checked<%}%> ></div>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td colspan="3"></td>  
                                                                                        </tr>                                                                                        
                                                                                        
                                                                                        <input type="hidden" name="<%=JspVendor.colNames[JspVendor.JSP_BANK_ID]%>" value="<%=vendor.getBankId()%>">                                                                                        
                                                                                        <input type="hidden" name="<%=JspVendor.colNames[JspVendor.JSP_PAYMENT_TYPE]%>" value="<%=vendor.getPaymentType()%>">
                                                                                        <%if (vendor.getTypeLocIncoming() == null || vendor.getTypeLocIncoming().compareTo("") == 0) {
        vendor.setTypeLocIncoming(DbLocation.TYPE_WAREHOUSE);
    }
                                                                                        %>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Type Loc Incoming</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="<%=JspVendor.colNames[JspVendor.JSP_TYPE_LOC_INCOMING]%>">                                                                                                    
                                                                                                    <%
    for (int i = 0; i < DbLocation.strLocTypes.length; i++) {

                                                                                                    %>  
                                                                                                    <option value="<%=DbLocation.strLocTypes[i]%>" <%if (DbLocation.strLocTypes[i].compareTo(vendor.getTypeLocIncoming()) == 0) {%>selected<%}%>    ><%=DbLocation.strLocTypes[i]%></option>                                                                                                    
                                                                                                    <%
    }
    if (vendor.getTypeLocIncoming() == null) {
        vendor.setTypeLocIncoming("");
    }
                                                                                                    %>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr> 
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Type Liabilities</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="<%=JspVendor.colNames[JspVendor.JSP_LIABILITIES_TYPE]%>" class="fontarial">                                                                                                    
                                                                                                    <%
    for (int i = 0; i < DbVendor.liabilitiesTypeValue.length; i++) {

                                                                                                    %>  
                                                                                                    <option value="<%=DbVendor.liabilitiesTypeValue[i]%>" <%if (DbVendor.liabilitiesTypeValue[i]==vendor.getLiabilitiesType()){%>selected<%}%> ><%=DbVendor.liabilitiesTypeKey[i]%></option>                                                                                                    
                                                                                                    <%
    }    
                                                                                                    %>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td colspan="3"></td>                                                                                            
                                                                                        </tr> 
                                                                                        <tr align="left"> 
                                                                                            <td colspan="6">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td colspan="6" class="command" valign="top"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidVendor + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidVendor + "')";
    String scancel = "javascript:cmdEdit('" + oidVendor + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("Save");
    ctrLine.setAddCaption("");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    ctrLine.setWidthAllJSPCommand("90");
    ctrLine.setErrorStyle("warning");
    ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    ctrLine.setQuestionStyle("warning");
    ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    ctrLine.setInfoStyle("success");
    ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

    if (privDelete) {
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
    } else {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                                                %>
                                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" height="20"> 
                                                                                <td height="8" valign="middle" colspan="3"></td> 
                                                                            </tr>
                                                                            <tr align="left" valign="top" height="30"> 
                                                                                <td height="8" valign="middle" colspan="3">
                                                                                    <table width="800" >
                                                                                        <tr>
                                                                                            <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                            <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                            <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                                        </tr>   
                                                                                        <%
            int max = 10;
            if (showAll == 1) {
                max = 0;
            }
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
            if (historys != null && historys.size() > 0) {

                for (int r = 0; r < historys.size(); r++) {
                    HistoryUser hu = (HistoryUser) historys.get(r);

                    Employee e = new Employee();
                    try {
                        e = DbEmployee.fetchExc(hu.getEmployeeId());
                    } catch (Exception ex) {
                    }
                    String name = "-";
                    if (e.getName() != null && e.getName().length() > 0) {
                        name = e.getName();
                    }

                    Vendor sdx = new Vendor();
                    try {
                        sdx = DbVendor.fetchExc(hu.getRefId());
                    } catch (Exception ex) {
                    }
                    String desc = "";
                    if (sdx.getOID() != 0 && sdx.getName() != null && sdx.getName().length() > 0) {
                        desc = desc + sdx.getName() + " : ";
                    }

                    desc = desc + hu.getDescription();
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                            <td class="fontarial" style=padding:3px;><i><%=desc%></i></td>
                                                                                            <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }

                                                                                        } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
            if (countx > max) {
                if (showAll == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                        </tr>
                                                                                        <%
                }
            }%>                                                                                                                                                          
                                                                                    </table>
                                                                                </td> 
                                                                            </tr>
                                                                            <tr align="left" valign="top" height="30"> 
                                                                                <td height="8" valign="middle" colspan="3"></td> 
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                if(document.frmvendor.<%=JspVendor.colNames[JspVendor.JSP_IS_KONSINYASI]%>.checked == true){                                                                                                                
                                                                    document.all.inpkonsinyasi.style.display="";
                                                                }else{
                                                                    document.all.inpkonsinyasi.style.display="none";
                                                                }  
                                                            
                                                                if(document.frmvendor.<%=JspVendor.colNames[JspVendor.JSP_IS_KOMISI]%>.checked == true){                                                                                                                
                                                                    document.all.inpkomisi.style.display="";
                                                                }else{
                                                                    document.all.inpkomisi.style.display="none";
                                                                }
                                                        
                                                                if(document.frmvendor.order_days.checked == true){                                                                                                                
                                                                    document.all.inporderdays.style.display="";
                                                                }else{
                                                                    document.all.inporderdays.style.display="none";                                                        
                                                                }
                                                            </script>
                                                        </form>
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
                                                    </td>
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
