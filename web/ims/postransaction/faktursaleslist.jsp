
<%-- 
    Document   : faktursaleslist
    Created on : Oct 3, 2012, 4:33:24 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.*" %>
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
            String fakturNumber = JSPRequestValue.requestString(request, "faktur_number");
            String dateFakturStart = JSPRequestValue.requestString(request, "date_faktur_start");
            String dateFakturEnd = JSPRequestValue.requestString(request, "date_faktur_end");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");            
            long locationToId = JSPRequestValue.requestLong(request, "location_to_id");

            Date dtFakturStart = new Date();
            Date dtFakturEnd = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }

            if (srcIgnore == 0) {
                dtFakturStart = JSPFormater.formatDate(dateFakturStart, "dd/MM/yyyy");
                dtFakturEnd = JSPFormater.formatDate(dateFakturEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "" + DbFakturPajak.colNames[DbFakturPajak.COL_NUMBER];
            
            whereClause = DbFakturPajak.colNames[DbFakturPajak.COL_TYPE_FAKTUR] + " = " + DbFakturPajak.TYPE_FAKTUR_SALES;
            
            if(fakturNumber.length() > 0){
                if(whereClause.length() > 0){
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbFakturPajak.colNames[DbFakturPajak.COL_NUMBER] + " like '%" + fakturNumber + "%' ";
            }
            
            if(locationToId != 0){
                if(whereClause.length() > 0){
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbFakturPajak.colNames[DbFakturPajak.COL_LOCATION_TO_ID]+" = "+locationToId;
            }
                   
            if (srcIgnore == 0) {
                whereClause = whereClause + " and " + DbFakturPajak.colNames[DbFakturPajak.COL_DATE] + " between '" +
                        JSPFormater.formatDate(dtFakturStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(dtFakturStart, "yyyy-MM-dd") + " 00:00:00' ";

            }

            CmdFakturPajak ctrlFakturPajak = new CmdFakturPajak(request);
            JSPLine ctrLine = new JSPLine();

            Vector listFakturPajak = new Vector(1, 1);

            /*count list All FakturPajak*/
            int vectSize = 0;

            if (iJSPCommand != JSPCommand.NONE) {
                vectSize = DbFakturPajak.getCount(whereClause);
            }

            FakturPajak fakturPajak = ctrlFakturPajak.getFakturPajak();
            msgString = ctrlFakturPajak.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {

                start = ctrlFakturPajak.actionList(iJSPCommand, start, vectSize, recordToGet);

            }
            /* end switch list*/

            /* get record to display */
            listFakturPajak = new Vector();
            if (iJSPCommand != JSPCommand.NONE) {
                listFakturPajak = DbFakturPajak.list(start, recordToGet, whereClause, orderClause);
            }

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


            Vector vCompany = DbCompany.list(0, 1, "", null);
            Company company = new Company();
            if (vCompany != null && vCompany.size() > 0) {
                company = (Company) vCompany.get(0);
            }

            Vector vLocation = new Vector();
            vLocation = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">           
            
            function cmdAdd(){                
                document.frmfakturpajak.command.value="<%=JSPCommand.ADD%>";                
                document.frmfakturpajak.action="fakturpajaksales.jsp";
                document.frmfakturpajak.submit();
            }
            
            function cmdSearch(){                
                document.frmfakturpajak.start.value=0;
                document.frmfakturpajak.command.value="<%=JSPCommand.SEARCH%>";
                document.frmfakturpajak.prev_command.value="<%=prevJSPCommand%>";
                document.frmfakturpajak.action="faktursaleslist.jsp";
                document.frmfakturpajak.submit();
            }   
            
            function cmdEdit(oidFaktur){                
                document.frmfakturpajak.hidden_faktur_pajak_id.value=oidFaktur;
                document.frmfakturpajak.command.value="<%=JSPCommand.EDIT%>";                
                document.frmfakturpajak.action="fakturpajaksales.jsp";
                document.frmfakturpajak.submit();
            }   
            
            function cmdListFirst(){
                document.frmfakturpajak.command.value="<%=JSPCommand.FIRST%>";
                document.frmfakturpajak.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmfakturpajak.action="faktursaleslist.jsp";
                document.frmfakturpajak.submit();
            }
            
            function cmdListPrev(){
                document.frmfakturpajak.command.value="<%=JSPCommand.PREV%>";
                document.frmfakturpajak.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmfakturpajak.action="faktursaleslist.jsp";
                document.frmfakturpajak.submit();
            }
            
            function cmdListNext(){
                document.frmfakturpajak.command.value="<%=JSPCommand.NEXT%>";
                document.frmfakturpajak.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmfakturpajak.action="faktursaleslist.jsp";
                document.frmfakturpajak.submit();
            }
            
            function cmdListLast(){
                document.frmfakturpajak.command.value="<%=JSPCommand.LAST%>";
                document.frmfakturpajak.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmfakturpajak.action="faktursaleslist.jsp";
                document.frmfakturpajak.submit();
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
                                                            <input type="hidden" name="hidden_faktur_pajak_id" value="0"> 
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23">&nbsp;<b><font color="#990000" class="lvl1">Tax Invoice 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">Sales Tax</span></font></b></td>
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
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<font face="arial">Records</font>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdAdd()" class="tablink"><font face="arial">Sales Tax</font></a>&nbsp;&nbsp;</div>
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
                                                                                                        <td width="80"><font face="arial">Company</font></td>
                                                                                                        <td width="5"><font face="arial">:</td>
                                                                                                        <td><b><font face="arial"><%=company.getName()%></font></b></td>                                                                                                        
                                                                                                        <td width="80">&nbsp;</td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>                                                                                                 
                                                                                                    <tr>
                                                                                                        <td width="80"><font face="arial">Address</font></td>
                                                                                                        <td width="5"><font face="arial">:</font></td>
                                                                                                        <td><b><font face="arial"><%=company.getAddress()%></font></b></td>
                                                                                                        <td width="80"><font face="arial">Date</font></td>
                                                                                                        <td width="5"><font face="arial">:</font></td>
                                                                                                        <td>
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="date_faktur_start" value="<%=JSPFormater.formatDate((dtFakturStart == null) ? new Date() : dtFakturStart, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>    
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmfakturpajak.date_faktur_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;&nbsp;to&nbsp;&nbsp;
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input name="date_faktur_end" value="<%=JSPFormater.formatDate((dtFakturEnd == null) ? new Date() : dtFakturEnd, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmfakturpajak.date_faktur_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                    <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td>
                                                                                                                        Ignored
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                 
                                                                                                    <tr>
                                                                                                        <td width="80"><font face="arial">Faktur Number</font></td>
                                                                                                        <td width="5"><font face="arial">:</font></td>
                                                                                                        <td><input type="text" size="25" name="faktur_number" value = "<%=fakturNumber%>"></td>                                                                                                        
                                                                                                        <td width="80"><font face="arial">Location</font></td>
                                                                                                        <td width="5"><font face="arial">:</font></td>
                                                                                                        <td>
                                                                                                          
                                                                                                                        <select name="location_to_id">
                                                                                                                            <option value ="0" <%if (locationToId == 0) {%>selected<%}%> >ALL</option>
                                                                                                                            <%

            if (vLocation != null && vLocation.size() > 0) {

                for (int ix = 0; ix < vLocation.size(); ix++) {
                    Location location = (Location) vLocation.get(ix);

                                                                                                                            %>
                                                                                                                            <option value ="<%=location.getOID()%>" <%if (location.getOID() == locationToId) {%>selected<%}%> ><%=location.getName()%></option>
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
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>  
                                                                                        <tr align="left" valign="top" > 
                                                                                            <td colspan="3" class="command"> 
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search" border="0">                                                                                            
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>  
                                                                                        <tr>
                                                                                            <td colspan="3">
                                                                                                <table width="95%" cellpadding="1" cellspacing="1">    
                                                                                                    <%if (iJSPCommand == JSPCommand.SEARCH) {%>                                                                                                
                                                                                                    <tr>
                                                                                                        <td class = "tablehdr" width="5%">No</td>
                                                                                                        <td class = "tablehdr" width="15%">Number</td>
                                                                                                        <td class = "tablehdr" width="30%">PKP</td>                                                                                                            
                                                                                                        <td class = "tablehdr" width="15%">Date Faktur</td>
                                                                                                        <td class = "tablehdr" width="15%">NPWP</td>                                                                                                        
                                                                                                        <td class = "tablehdr" width="20%">Location</td>
                                                                                                    </tr>         
                                                                                                    <%} else {%>
                                                                                                    <tr>
                                                                                                        <td class = "tablecell1" colspan="6" align="lecft">&nbsp;Click search to searching data</td>
                                                                                                    </tr>    
                                                                                                    <%}%>
                                                                                                    <%
            int number = start;

            if (listFakturPajak != null && listFakturPajak.size() > 0) {
                for (int i = 0; i < listFakturPajak.size(); i++) {
                    FakturPajak fp = (FakturPajak) listFakturPajak.get(i);

                    number = number + 1;
                    
                    Location locTo = new Location();
                    try {
                        locTo = DbLocation.fetchExc(fp.getLocationToId());
                    } catch (Exception e) {
                    }

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell1" align="center"><%=number%></td>
                                                                                                        <td class="tablecell1" align="center"><a href="javascript:cmdEdit('<%=fp.getOID()%>')"><%=fp.getNumber()%></a></td>
                                                                                                        <td class="tablecell1" align="left"><%=fp.getNama_pkp()%></td>
                                                                                                        <td class="tablecell1" align="center"><%=JSPFormater.formatDate(fp.getDate(), "yyyy-MM-dd")%></td>
                                                                                                        <td class="tablecell1" align="center"><%=fp.getNpwpPkp()  %></td>                                                                                                        
                                                                                                        <td class="tablecell1" align="left"><%=locTo.getName() %></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        }
                                                                                                    } else {
                                                                                                    %>  
                                                                                                    <%if (iJSPCommand == JSPCommand.SEARCH) {%> 
                                                                                                    <tr>
                                                                                                        <td class = "tablecell1" colspan="6" align="lecft">&nbsp;Data not found</td>
                                                                                                    </tr>           
                                                                                                    <%
                }
            }
                                                                                                    %>                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
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
                                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
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

