
<%-- 
    Document   : fakturpajak
    Created on : Sep 24, 2012, 11:47:01 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            long oidFakturPajak = JSPRequestValue.requestLong(request, "hidden_faktur_pajak_id");
            long oidFakturPajakDetail = JSPRequestValue.requestLong(request, "hidden_faktur_pajak_detail_id");
            long oidTmpTransferId = JSPRequestValue.requestLong(request, "hidden_tmp_transfer_id");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdFakturPajak ctrlFakturPajak = new CmdFakturPajak(request);
            JSPLine ctrLine = new JSPLine();
            Vector listFakturPajak = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlFakturPajak.action(iJSPCommand, oidFakturPajak);
            /* end switch*/
            JspFakturPajak jspFakturPajak = ctrlFakturPajak.getForm();

            /*count list All FakturPajak*/
            int vectSize = DbFakturPajak.getCount(whereClause);

            FakturPajak fakturPajak = ctrlFakturPajak.getFakturPajak();
            msgString = ctrlFakturPajak.getMessage();

            if (oidFakturPajak == 0) {
                oidFakturPajak = fakturPajak.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlFakturPajak.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listFakturPajak = DbFakturPajak.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listFakturPajak.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listFakturPajak = DbFakturPajak.list(start, recordToGet, whereClause, orderClause);
            }

            Vector v = DbFakturPajak.list(0, 0, "", "");

            Vector vCompany = DbCompany.list(0, 1, "", null);
            Company company = new Company();
            if (vCompany != null && vCompany.size() > 0) {
                company = (Company) vCompany.get(0);
            }

            Vector vLocation = new Vector();
            vLocation = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);

            String npwp = "";
            
            long locId = 0;

            if (fakturPajak.getLocationId() == 0) {
                if (vLocation != null && vLocation.size() > 0) {
                    Location objLocation = (Location) vLocation.get(0);
                    locId = objLocation.getOID();
                    npwp = objLocation.getNpwp();
                }
            } else {
                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(fakturPajak.getLocationId());
                } catch (Exception e) {
                }
                npwp = loc.getNpwp();
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT) {
                session.removeValue("FAKTUR_PAJAK_DETAIL");
            }
            String whereFPD = DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID] + " = " + fakturPajak.getOID();

            Vector vFakturPajakDetail = new Vector();
            if (session.getValue("FAKTUR_PAJAK_DETAIL") != null) {
                vFakturPajakDetail = (Vector) session.getValue("FAKTUR_PAJAK_DETAIL");
            } else {
                if (fakturPajak.getOID() != 0) {
                    vFakturPajakDetail = DbFakturPajakDetail.list(0, 0, whereFPD, DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]);
                }
            }
            boolean dataExist = false;
            if (iJSPCommand == JSPCommand.SAVE){
                if (fakturPajak.getOID() == 0) {
                    if (vFakturPajakDetail != null && vFakturPajakDetail.size() > 0) {
                        long tmpOid = 0;
                        int counter = 1;
                        for (int t = 0; t < vFakturPajakDetail.size(); t++) {
                            FakturPajakDetail fd = (FakturPajakDetail) vFakturPajakDetail.get(t);
                            int count = 0;
                            if (tmpOid != fd.getTransferId()) {
                                count = DbFakturPajakDetail.getCount(fd.getTransferId());
                            }
                            if (count == 0) {
                                fd.setFakturPajakId(fakturPajak.getOID());
                                fd.setDate(new Date());  
                                fd.setCounter(counter);                                                                         
                                DbFakturPajakDetail.insertExc(fd);
                                counter++; 
                            } else {
                                dataExist = true;
                            }
                        }
                    }
                } else {
                    DbFakturPajakDetail.deleteAllItem(fakturPajak.getOID());
                    if (vFakturPajakDetail != null && vFakturPajakDetail.size() > 0) {
                        long tmpOid = 0;
                        int counter = 1;
                        for (int t = 0; t < vFakturPajakDetail.size(); t++) {
                            FakturPajakDetail fd = (FakturPajakDetail) vFakturPajakDetail.get(t);
                            int count = 0;
                            if (tmpOid != fd.getTransferId()) {
                                count = DbFakturPajakDetail.getCount(fd.getTransferId());
                            }
                            if (count == 0) {
                                tmpOid = fd.getTransferId();
                                fd.setFakturPajakId(fakturPajak.getOID());
                                fd.setDate(new Date());  
                                fd.setCounter(counter);  
                                DbFakturPajakDetail.insertExc(fd);
                                counter++; 
                            } else {
                                dataExist = true;
                            }
                        }
                    }
                }
                vFakturPajakDetail = DbFakturPajakDetail.list(0, 0, whereFPD, DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]);
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                if (vFakturPajakDetail != null && vFakturPajakDetail.size() > 0) {
                    String whereFd = "";
                    Vector tmpTrans = new Vector();
                    for (int t = 0; t < vFakturPajakDetail.size(); t++) {
                        FakturPajakDetail fd = (FakturPajakDetail) vFakturPajakDetail.get(t);
                        int checked = JSPRequestValue.requestInt(request, "CHECK_" + t);
                        if (checked == 1) {
                            if (whereFd.length() > 0) {
                                whereFd = whereFd + " or ";
                            }
                            whereFd = whereFd + DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_TRANSFER_ID] + " = " + fd.getTransferId();
                            tmpTrans.add("" + fd.getTransferId());
                        }
                    }
                    if (whereFd.length() > 0) {
                        whereFd = DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID] + " = " + fakturPajak.getOID() + " and (" + whereFd + " )";
                        DbFakturPajakDetail.deleteAllItem(whereFd);
                    }
                    vFakturPajakDetail = DbFakturPajakDetail.list(0, 0, whereFPD, DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]);
                    
                    if(vFakturPajakDetail != null && vFakturPajakDetail.size() > 0){
                        for(int ix = 0; ix < vFakturPajakDetail.size() ; ix++){
                            FakturPajakDetail fpd = (FakturPajakDetail)vFakturPajakDetail.get(ix);
                            int vc = ix+1;                            
                            DbFakturPajakDetail.updateCounter(fpd.getOID(),vc);
                        }
                    }
                }
            }

            Vector tmpFakturPD = new Vector();
            boolean trasferIdExist = false;

            if (iJSPCommand == JSPCommand.REFRESH) {
                if (vFakturPajakDetail != null && vFakturPajakDetail.size() > 0) {
                    for (int t = 0; t < vFakturPajakDetail.size(); t++) {
                        FakturPajakDetail fd = (FakturPajakDetail) vFakturPajakDetail.get(t);
                        if (fd.getTransferId() == oidTmpTransferId) {
                            trasferIdExist = true;
                        }
                    }
                }

                if (trasferIdExist == false){
                    String whereFD = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID] + " = " + oidTmpTransferId;                    
                    String orderFD = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID];
                    Vector vItem = DbTransferItem.list(0, 0, whereFD, orderFD);
                    if (vItem != null && vItem.size() > 0) {
                        for (int iItem = 0; iItem < vItem.size(); iItem++) {
                            TransferItem tItem = (TransferItem) vItem.get(iItem);
                            ItemMaster itemMaster = new ItemMaster();
                            try {
                                itemMaster = DbItemMaster.fetchExc(tItem.getItemMasterId());
                            } catch (Exception e) {}

                            if (itemMaster.getIs_bkp() == DbItemMaster.BKP) {
                                FakturPajakDetail tmpFPD = new FakturPajakDetail();
                                tmpFPD.setTransferId(oidTmpTransferId);
                                tmpFPD.setItemMasterId(itemMaster.getOID());
                                tmpFPD.setItemName(itemMaster.getName());
                                tmpFPD.setPrice(tItem.getPrice());
                                tmpFPD.setDiscount(0);
                                tmpFPD.setQty(tItem.getQty());
                                double total = (tItem.getPrice() * tItem.getQty());
                                tmpFPD.setTotal(total);
                                vFakturPajakDetail.add(tmpFPD);
                            }
                        }
                    }
                }
            }  
                     
            if (iJSPCommand == JSPCommand.RESET){                
                String whereFd = DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID] + " = " + fakturPajak.getOID();
                DbFakturPajakDetail.deleteAllItem(whereFd);
                long oidLocationFrom = JSPRequestValue.requestLong(request, JspFakturPajak.colNames[JspFakturPajak.JSP_LOCATION_ID]);
                long oidLocationTo = JSPRequestValue.requestLong(request, JspFakturPajak.colNames[JspFakturPajak.JSP_LOCATION_TO_ID]);                
                fakturPajak.setLocationId(oidLocationFrom);
                fakturPajak.setLocationToId(oidLocationTo);
                if(fakturPajak.getOID() != 0){
                    DbFakturPajak.updateLocation(fakturPajak.getOID(),oidLocationFrom,oidLocationTo);
                }
                vFakturPajakDetail = new Vector();
                
            }
            if (iJSPCommand == JSPCommand.NONE){   
                fakturPajak.setLocationId(locId);
                fakturPajak.setLocationToId(locId);
            }

            session.putValue("FAKTUR_PAJAK_DETAIL", vFakturPajakDetail);
%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">    
            
            function cmdPrintDocXLS(){                
                window.open("<%=printroot%>.report.ReportPajakXls?oid=<%=fakturPajak.getOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                } 
                
                function cmdList(){                
                    document.frmfakturpajak.command.value="<%=JSPCommand.NONE%>";
                    document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                    document.frmfakturpajak.action="fakturpajaklist.jsp";
                    document.frmfakturpajak.submit();
                }
                
                function cmdSave(){                
                    document.frmfakturpajak.command.value="<%=JSPCommand.SAVE%>";
                    document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                    document.frmfakturpajak.action="fakturpajak.jsp";
                    document.frmfakturpajak.submit();
                }
                
                function cmdNewConfirm(){
                    var cfrm = confirm('Same items not yet save, continues ?');                    
                    if( cfrm==true){
                        document.frmfakturpajak.hidden_faktur_pajak_id.value="0";
                        document.frmfakturpajak.command.value="<%=JSPCommand.NONE%>";
                        document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                        document.frmfakturpajak.action="fakturpajak.jsp";
                        document.frmfakturpajak.submit();
                    }
                }
                
                function cmdNew(){
                    document.frmfakturpajak.hidden_faktur_pajak_id.value="0";
                    document.frmfakturpajak.command.value="<%=JSPCommand.NONE%>";
                    document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                    document.frmfakturpajak.action="fakturpajak.jsp";
                    document.frmfakturpajak.submit();
                }
                
                function cmdDelete(){         
                    var cfrm = confirm('Are you sure you want to continous to delete data ?');                    
                    if( cfrm==true){
                        document.frmfakturpajak.command.value="<%=JSPCommand.DELETE%>";
                        document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                        document.frmfakturpajak.action="fakturpajak.jsp";
                        document.frmfakturpajak.submit();
                    }
                }
                
                function cmdAdd(){
                    document.frmfakturpajak.hidden_faktur_pajak_id.value="0";
                    document.frmfakturpajak.command.value="<%=JSPCommand.ADD%>";
                    document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                    document.frmfakturpajak.action="fakturpajak.jsp";
                    document.frmfakturpajak.submit();
                }    
                
                function cmdChange(){          
                    var cfrm = confirm('Are you sure you want to change location and reset data item detail ?');                    
                    if( cfrm==true){
                    document.frmfakturpajak.command.value="<%=JSPCommand.RESET%>";
                    document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                    document.frmfakturpajak.action="fakturpajak.jsp";
                    document.frmfakturpajak.submit();
                    }
                }            
                
                function cmdOpenTransfer(){
                    window.open("<%=approot%>/postransaction/gettransferlist.jsp?from_location=<%=fakturPajak.getLocationId()%>&to_location=<%=fakturPajak.getLocationToId()%>", null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }
                    
        </script>
        <script type="text/javascript">
            <!--
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmfakturpajak" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                        
                                                            <input type="hidden" name="hidden_faktur_pajak_detail_id" value="<%=oidFakturPajakDetail%>">   
                                                            <input type="hidden" name="hidden_faktur_pajak_id" value="<%=oidFakturPajak%>">   
                                                            <input type="hidden" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_NAMA_PKP]%>" value="<%=company.getName()%>">                                                               
                                                            <input type="hidden" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_PKP_ADDRESS]%>" value="<%=company.getAddress()%>">   
                                                            <input type="hidden" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_NPWP_PKP]%>" value="<%=npwp%>">   
                                                            <input type="hidden" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_TYPE_FAKTUR]%>" value="<%=DbFakturPajak.TYPE_FAKTUR_TRANSFER%>">   
                                                            <input type="hidden" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_DATE]%>" value="<%=JSPFormater.formatDate(new Date(), "yyyy-MM-dd hh:mm:ss") %>">   
                                                            <input type="hidden" name="hidden_tmp_transfer_id" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23">&nbsp;<b><font color="#990000" class="lvl1">Tax Invoice 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">Transfer Tax</span></font></b></td>
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
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdList()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                Transfer Tax
                                                                                            </td>                                                                                            
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="11" valign="middle" colspan="3"> </td> 
                                                                                        </tr>     
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <table width="800" border="0">
                                                                                                    <tr>
                                                                                                        <td width="80">Company</td>
                                                                                                        <td width="5">:</td>
                                                                                                        <td><b><%=company.getName()%></b></td>                                                                                                        
                                                                                                        <td width="80">&nbsp;</td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6" height="5"></td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td width="80">Address</td>
                                                                                                        <td width="5">:</td>
                                                                                                        <td><b><%=company.getAddress()%></b></td>
                                                                                                        <td width="80">Date</td>
                                                                                                        <td width="5">:</td>
                                                                                                        <td><b><%=JSPFormater.formatDate(new Date(), "yyyy-MM-dd")%></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6" height="5"></td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <%
            String strNumber = "";
            int counterJournal = 0;

            if (fakturPajak.getLocationToId() == 0) {
                if (vLocation != null && vLocation.size() > 0) {
                    Location objLocation = (Location) vLocation.get(0);
                    counterJournal = DbFakturPajak.getNextCounterFp(objLocation.getOID());
                    strNumber = DbFakturPajak.getNextNumberFpTransfer(counterJournal, objLocation.getOID());
                }
            } else {
                counterJournal = DbFakturPajak.getNextCounterFp(fakturPajak.getLocationId());
                strNumber = DbFakturPajak.getNextNumberFpTransfer(counterJournal, fakturPajak.getLocationToId());

            }

            if (fakturPajak.getOID() != 0 || oidFakturPajak != 0) {
                strNumber = fakturPajak.getNumber();
            }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                        <td width="80">Faktur Number</td>
                                                                                                        <td width="5">:</td>
                                                                                                        <td><b><%=strNumber%></b></td>                                                                                                        
                                                                                                        <td width="80">Location</td>
                                                                                                        <td width="5">:</td>
                                                                                                        <td>
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <select name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_LOCATION_ID]%>" onChange="javascript:cmdChange()">
                                                                                                                            <%

            if (vLocation != null && vLocation.size() > 0) {

                for (int ix = 0; ix < vLocation.size(); ix++) {
                    Location location = (Location) vLocation.get(ix);

                                                                                                                            %>
                                                                                                                            <option value ="<%=location.getOID()%>" <%if (location.getOID() == fakturPajak.getLocationId()) {%>selected<%}%> ><%=location.getName()%></option>
                                                                                                                            <%

                }
            }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="5">&nbsp;<td>
                                                                                                                    <td width="5">To<td>
                                                                                                                    <td width="5">&nbsp;<td>
                                                                                                                    <td>
                                                                                                                        <select name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_LOCATION_TO_ID]%>" onChange="javascript:cmdChange()">
                                                                                                                            <%

            if (vLocation != null && vLocation.size() > 0) {

                for (int ib = 0; ib < vLocation.size(); ib++) {
                    Location locationob = (Location) vLocation.get(ib);

                                                                                                                            %>
                                                                                                                            <option value ="<%=locationob.getOID()%>" <%if (locationob.getOID() == fakturPajak.getLocationToId()) {%>selected<%}%> ><%=locationob.getName()%></option>
                                                                                                                            <%

                }
            }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table width="95%" border="0" cellpadding="1" cellspacing="1">    
                                                                                                    <tr>
                                                                                                        <td class = "tablehdr" width="3%">No</td>
                                                                                                        <td class = "tablehdr" width="10%">Number</td>
                                                                                                        <td class = "tablehdr" width="10%">Code</td>
                                                                                                        <td class = "tablehdr" width="27%">Item Master</td>                                                                                                            
                                                                                                        <td class = "tablehdr" width="10%">Price</td>
                                                                                                        <td class = "tablehdr" width="10%">Qty</td>
                                                                                                        <td class = "tablehdr" width="10%">Discount</td>                                                                                                            
                                                                                                        <td class = "tablehdr" width="10%">Total</td>
                                                                                                        <td class = "tablehdr" width="10%">Process</td>
                                                                                                    </tr>         
                                                                                                    <%
            int number = 1;
            long transferId = 0;
            boolean tmpexist = false;

            if (vFakturPajakDetail != null && vFakturPajakDetail.size() > 0) {
                for (int i = 0; i < vFakturPajakDetail.size(); i++) {
                    FakturPajakDetail fpd = (FakturPajakDetail) vFakturPajakDetail.get(i);

                    ItemMaster im = new ItemMaster();
                    try {
                        im = DbItemMaster.fetchExc(fpd.getItemMasterId());
                    } catch (Exception e) {
                    }

                    Transfer transfer = new Transfer();
                    try {
                        transfer = DbTransfer.fetchExc(fpd.getTransferId());
                    } catch (Exception e) {
                    }
                    double total = fpd.getQty() * fpd.getPrice();
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <%
                                                                                                            if (transfer.getOID() != transferId) {

                                                                                                        %>
                                                                                                        <td align="center" class="tablecell1"><%=number%></td>
                                                                                                        <td class="tablecell1" align="center"><%=transfer.getNumber()%></td>
                                                                                                        <%
                                                                                                            number++;
                                                                                                        } else {%>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell1" align="center"><%=im.getCode()%></td>
                                                                                                        <td class="tablecell1"><%=fpd.getItemName()%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getPrice(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getQty(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getDiscount(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(total, "#,###.##")%></td>
                                                                                                        <%
                                                                                                            if (transfer.getOID() != transferId) {
                                                                                                        %>
                                                                                                        <%if (fakturPajak.getOID() != 0 && fpd.getFakturPajakId() != 0) {%>
                                                                                                        <td class="tablecell1" align="center"><input type="checkbox" name="CHECK_<%=i%>" value="1"></td>
                                                                                                        <%
} else {
    tmpexist = true;
                                                                                                        %>
                                                                                                        <td class="tablecell1" align="center"><font face="arial">Save please..</font></td>
                                                                                                        <%}%>
                                                                                                        <%} else {%>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                    <%
                    transferId = transfer.getOID();
                }
            }

                                                                                                    %>
                                                                                                    <%
            if (tmpFakturPD != null && tmpFakturPD.size() > 0 && false) {

                for (int iFD = 0; iFD < tmpFakturPD.size(); iFD++) {
                    FakturPajakDetail fpd = (FakturPajakDetail) tmpFakturPD.get(iFD);

                    ItemMaster im = new ItemMaster();
                    try {
                        im = DbItemMaster.fetchExc(fpd.getItemMasterId());
                    } catch (Exception e) {
                    }
                    Transfer transfer = new Transfer();
                    try {
                        transfer = DbTransfer.fetchExc(fpd.getTransferId());
                    } catch (Exception e) {
                    }

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <%if (iFD == 0) {%>
                                                                                                        <td align="center" class="tablecell1"><%=number%></td>
                                                                                                        <td class="tablecell1" align="center"><%=transfer.getNumber()%></td>
                                                                                                        <%} else {%>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell1" align="center"><%=im.getCode()%></td>
                                                                                                        <td class="tablecell1" ><%=fpd.getItemName()%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getPrice(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getQty(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(fpd.getDiscount(), "#,###.##")%></td>
                                                                                                        <td class="tablecell1" align="right"></td>
                                                                                                        <%if (iFD == 0) {%>
                                                                                                        <td class="tablecell1" align="center"><input type="checkbox" name="CHECK_<%=fpd.getOID()%>"></td>
                                                                                                        <%} else {%>
                                                                                                        <td class="tablecell"></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            number++;
                                                                                                        }

                                                                                                    } else {%>
                                                                                                    <tr>
                                                                                                        <td align="center" bgcolor="#F4F673"><%=number%></td>
                                                                                                        <td bgcolor="#F4F673" colspan="7" valign="middle"><font face="arial">&nbsp;Klik search button to add item >></font></td>                                                                                                        
                                                                                                        <td bgcolor="#F4F673" align="center"><a href="javascript:cmdOpenTransfer()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a></td>
                                                                                                    </tr>
                                                                                                    <%}%> 
                                                                                                    <tr height="15" align="left" valign="top" > 
                                                                                                        <td colspan="3" class="command"> </td>
                                                                                                    </tr>
                                                                                                    <%if (trasferIdExist) {%>
                                                                                                    <tr height="20" align="left" valign="top" > 
                                                                                                        <td colspan="3" bgcolor="#F15858" valign="middle"><font face="arial" color="FFFFFF">&nbsp;Data transfer already exist</font></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (dataExist) {%>
                                                                                                    <tr height="20" align="left" valign="top" > 
                                                                                                        <td colspan="4" bgcolor="#F15858" valign="middle"><font face="arial" color="FFFFFF">&nbsp;Same items can't be save, because was exist in another tax invoice</font></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                                                                                                          
                                                                                        <tr align="left" valign="top" > 
                                                                                            <td colspan="3" class="command"> 
                                                                                                <table>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','../images/save2.gif',1)"><img src="../images/save.gif" name="save" height="22" border="0">                                                                                            
                                                                                                        </td>
                                                                                                        <td width="10"></td> 
                                                                                                        <%if (fakturPajak.getOID() != 0) {%>
                                                                                                        <td>
                                                                                                            <a href="javascript:cmdDelete()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="del" height="22" border="0">                                                                                            
                                                                                                        </td>
                                                                                                        <td width="10"></td> 
                                                                                                        <td>
                                                                                                            <div align="left"><a href="javascript:cmdPrintDocXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" border="0"></a></div>
                                                                                                        </td>
                                                                                                        <%if (tmpexist) {%>
                                                                                                        <td width="10"></td> 
                                                                                                        <td><a href="javascript:cmdNewConfirm()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" height="22" border="0"></td>                                                                                            
                                                                                                        <%} else {%>
                                                                                                        <td width="10"></td> 
                                                                                                        <td><a href="javascript:cmdNew()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" height="22" border="0"></td>                                                                                            
                                                                                                        <%}%>
                                                                                                        
                                                                                                        <%}%>
                                                                                                    </tr>     
                                                                                                </table>       
                                                                                            </td>
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
