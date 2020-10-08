
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    final static int CMD_CLOSE = 1;    
    public static boolean getClosing(long periodId){
        try{
            Vector listPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE]+" desc");
            if(listPeriode != null && listPeriode.size() > 0){
                for(int i =0 ; i < listPeriode.size(); i++){
                    Periode p = (Periode)listPeriode.get(i);
                    if(p.getOID() == periodId){
                        if(p.getStatus().equalsIgnoreCase(I_Project.STATUS_PERIOD_CLOSED)){
                            return true;
                        }else{
                            if((i+1)==listPeriode.size()){
                                return true;
                            }else{
                                Periode px = (Periode)listPeriode.get(i+1);
                                if(px.getStatus().equalsIgnoreCase(I_Project.STATUS_PERIOD_CLOSED)){
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }catch(Exception e){}
        return false;
        
    }
    
%>
<%
            int cmdx = JSPRequestValue.requestInt(request, "cmd");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            if (cmdx != 0) {
                iJSPCommand = cmdx;
            }
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPeriode = JSPRequestValue.requestLong(request, "hidden_periode_id");

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = " start_date desc";

            CmdPeriode ctrlPeriode = new CmdPeriode(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPeriode = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPeriode.action(iJSPCommand, oidPeriode);
            /* end switch*/
            JspPeriode jspPeriode = ctrlPeriode.getForm();

            /*count list All Periode*/
            int vectSize = DbPeriode.getCount(whereClause);

            Periode periode = ctrlPeriode.getPeriode();
            msgString = ctrlPeriode.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPeriode.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listPeriode = DbPeriode.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listPeriode.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listPeriode = DbPeriode.list(start, recordToGet, whereClause, orderClause);
            }
%>

<%
//get open period id            

            if (iJSPCommand == CMD_CLOSE) {
                response.sendRedirect("../closing/closeperiod.jsp?menu_idx=13");
            }

            String[] langMD = {"Period", "Start Date", "End Date", "Input Tolerance", "Status", "required"}; //0-5
            String[] langNav = {"Close Period", "Monthly Closing", "Yearly Closing"};
            if (lang == LANG_ID) {
                String[] langID = {"Periode", "Tanggal Mulai", "Tanggal Berakhir", "Batas Akhir Data", "Status", "harus diisi"};
                langMD = langID;
                String[] navID = {"Tutup Periode", "Tutup Bulanan", "Tutup Tahunan"};
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
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>        
            
            function cmdEdit(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="closeperiod.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListFirst(){
                document.frmperiode.command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.action="periode.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListPrev(){
                document.frmperiode.command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.action="periode.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListNext(){
                document.frmperiode.command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.action="periode.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListLast(){
                document.frmperiode.command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.action="periode.jsp";
                document.frmperiode.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/closeperiode2.gif')">
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
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + ((!isYearlyClose) ? langNav[1] : langNav[2]) + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>                                              
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmperiode" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_periode_id" value="<%=oidPeriode%>"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">                                                                                     
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="10" valign="middle" colspan="3" class="comment"></td>
                                                                                        </tr>										                                                                                        
                                                                                        <%
            try {
                if (listPeriode.size() > 0) {
                                                                                        %>                                                                                       
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="900" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" width="24">No.</td>
                                                                                                        <td class="tablehdr"><%=langMD[0]%></td>
                                                                                                        <td class="tablehdr" width="140"><%=langMD[1]%></td>
                                                                                                        <td class="tablehdr" width="140"><%=langMD[2]%></td>
                                                                                                        <td class="tablehdr" width="140"><%=langMD[3]%></td>
                                                                                                        <td class="tablehdr" width="140"><%=langMD[4]%></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
                                                                                                if (listPeriode != null && listPeriode.size() > 0) {
                                                                                                    for (int i = 0; i < listPeriode.size(); i++) {
                                                                                                        Periode px = (Periode) listPeriode.get(i);
                                                                                                        String style = "";
                                                                                                        if (i % 2 == 0) {
                                                                                                            style = "tablecell";
                                                                                                        } else {
                                                                                                            style = "tablecell1";
                                                                                                        }

                                                                                                        String str_dt_StartDate = "";
                                                                                                        try {
                                                                                                            Date dt_StartDate = px.getStartDate();
                                                                                                            if (dt_StartDate == null) {
                                                                                                                str_dt_StartDate = "";
                                                                                                            } else {
                                                                                                                str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMM yyyy");
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                            str_dt_StartDate = "";
                                                                                                        }

                                                                                                        String str_dt_EndDate = "";
                                                                                                        try {
                                                                                                            Date dt_EndDate = px.getEndDate();
                                                                                                            if (dt_EndDate == null) {
                                                                                                                str_dt_EndDate = "";
                                                                                                            } else {
                                                                                                                str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMM yyyy");
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                            str_dt_EndDate = "";
                                                                                                        }

                                                                                                        String str_dt_InputTolerance = "";
                                                                                                        try {
                                                                                                            Date dt_InputTolerance = px.getInputTolerance();
                                                                                                            if (dt_InputTolerance == null) {
                                                                                                                str_dt_InputTolerance = "";
                                                                                                            } else {
                                                                                                                str_dt_InputTolerance = JSPFormater.formatDate(dt_InputTolerance, "dd MMM yyyy");
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                            str_dt_InputTolerance = "";
                                                                                                        }

                                                                                                        boolean canClose = getClosing(px.getOID());
                                                                                                        
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="<%=style%>" align="center"><%=(start + i + 1)%>.</td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%if(canClose){%><a href="javascript:cmdEdit('<%=px.getOID()%>')"> <%}%><%=px.getName()%><%if(canClose){%></a><%}%></td>
                                                                                                        <td class="<%=style%>" align="center"><%=str_dt_StartDate%></td>
                                                                                                        <td class="<%=style%>" align="center"><%=str_dt_EndDate%></td>
                                                                                                        <td class="<%=style%>" align="center"><%=str_dt_InputTolerance%></td>
                                                                                                        <td class="<%=style%>" align="center"><%=px.getStatus()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    }
                                                                                                }
                                                                                                    %>
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command" valign="top"> 
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
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="12" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
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
