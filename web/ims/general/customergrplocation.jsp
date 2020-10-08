
<%-- 
    Document   : customergrplocation
    Created on : Oct 13, 2015, 2:39:58 PM
    Author     : Roy
--%>


<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");

            String code = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            String srcAddress = JSPRequestValue.requestString(request, "src_address");
            String srcId = JSPRequestValue.requestString(request, "src_id");
            int statusDraft = JSPRequestValue.requestInt(request, "status_draft");
            int statusApprove = JSPRequestValue.requestInt(request, "status_approve");
            int statusExpired = JSPRequestValue.requestInt(request, "status_expired");
            int type = JSPRequestValue.requestInt(request, "type");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            int grpType = JSPRequestValue.requestInt(request, "grp_type");

            if (session.getValue("REPORT_GROUP_CUSTOMER") != null) {
                session.removeValue("REPORT_GROUP_CUSTOMER");
            }

            Vector locations = userLocations;

            Date regStart = new Date();
            Date regEnd = new Date();

            long oidPub = 0;
            try {
                oidPub = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
            } catch (Exception e) {
                oidPub = 0;
            }

            if (JSPRequestValue.requestString(request, "reg_start").length() > 0) {
                regStart = JSPFormater.formatDate(JSPRequestValue.requestString(request, "reg_start"), "dd/MM/yyyy");
            }
            if (JSPRequestValue.requestString(request, "reg_end").length() > 0) {
                regEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "reg_end"), "dd/MM/yyyy");
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                statusDraft = 1;
                statusApprove = 1;
                type = -1;
                if (locations.size() != totLocationxAll && locations != null && locations.size() > 0) {
                    try {
                        Location d = (Location) locations.get(0);
                        srcLocationId = d.getOID();
                    } catch (Exception e) {
                    }
                }
            }


            Vector loc = new Vector();
            try {
                if (srcLocationId != 0) {
                    loc = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + srcLocationId, DbLocation.colNames[DbLocation.COL_NAME]);
                } else {
                    loc = userLocations;
                }
            } catch (Exception e) {
            }

            /*variable declaration*/
            String whereClause = DbCustomer.colNames[DbCustomer.COL_TYPE] + " in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ")";

            if (oidPub != 0) {
                whereClause = whereClause + " and " + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " != " + oidPub;
            }

            String status = "";
            if (statusDraft == 1 || statusApprove == 1 || statusExpired == 1) {
                if (statusDraft == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'','" + I_Project.DOC_STATUS_DRAFT + "'";
                }

                if (statusApprove == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'" + I_Project.DOC_STATUS_APPROVED + "'";
                }

                if (statusExpired == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'" + I_Project.DOC_STATUS_EXPIRED + "'";
                }
            } else {
                status = "-1";
            }
            if (status.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }

                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_STATUS] + " in (" + status + ") ";
            }

            if (code != null && code.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_CODE] + " like '%" + code + "%' ";
            }

            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_NAME] + " like '%" + srcName + "%' ";
            }

            if (srcAddress != null && srcAddress.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ADDRESS_1] + " like '%" + srcAddress + "%' ";
            }

            if (srcId != null && srcId.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ID_NUMBER] + " like '%" + srcId + "%' ";
            }

            Vector list = DbLocation.listAll();
            Hashtable lx = new Hashtable();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Location l = (Location) list.get(i);
                    lx.put("" + l.getOID(), l.getName());
                }
            }

            MemberParameter memberParameter = new MemberParameter();
            memberParameter.setType(type);
            memberParameter.setName(srcName);
            memberParameter.setCode(code);
            memberParameter.setId(srcId);
            memberParameter.setLocationRegId(srcLocationId);
            memberParameter.setRegStart(regStart);
            memberParameter.setRegEnd(regEnd);
            memberParameter.setAddress(srcAddress);
            memberParameter.setStatusDraft(statusDraft);
            memberParameter.setStatusApprove(statusApprove);
            memberParameter.setStatusExpired(statusExpired);
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
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportTotalMemberXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdReload(){
                    var x = document.frmcustomer.grp_type.value;
                    if(x==0){
                        document.frmcustomer.action="customer.jsp";
                    }else{
                    document.frmcustomer.action="customergrplocation.jsp";
                }
                document.frmcustomer.command.value="<%=JSPCommand.NONE%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";                    
                document.frmcustomer.submit();
            }
            
            function cmdSearch(){
                document.frmcustomer.command.value="<%=JSPCommand.SEARCH%>";
                document.frmcustomer.action="customergrplocation.jsp";
                document.frmcustomer.submit();
            }
            
            //-------------- script control line -------------------
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
              <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcustomer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">    
                                                            <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">   
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                        Maintenance </font><font class="tit1">&raquo; 
                                                                                        </font><span class="lvl2">Member List (By Total)
                                                                                </span></b></td>
                                                                                <td width="40%" height="23"> 
                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr > 
                                                                                <td colspan="2" height="3" background="../images/line1.gif" ></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr  id="searching"> 
                                                                                <td height="14" valign="top" colspan="3" class="comment" width="99%"> 
                                                                                    <table border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="100" height="8"></td>
                                                                                            <td width="1" height="8"></td>
                                                                                            <td width="200" height="8"></td>
                                                                                            <td width="100" height="8"></td>
                                                                                            <td width="1" height="8"></td>
                                                                                            <td width="150" height="8"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" class="fontarial"><b><i>Search Parameter :</i></b></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1" style="padding:3px;">Group</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <select name="grp_type" class="fontarial" onChange=javascript:cmdReload()>                                                                                                    
                                                                                                    <option value="0" <%if (grpType == 0) {%> selected<%}%> >Member</option>
                                                                                                    <option value="1" <%if (grpType == 1) {%> selected<%}%> >Location</option>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td colspan="3">&nbsp;</td>                                                                                            
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td class="tablearialcell" style="padding:3px;">Name</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_name" value="<%=srcName%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell" style="padding:3px;">Registrasi Date</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input name="reg_start" value="<%=JSPFormater.formatDate((regStart == null) ? new Date() : regStart, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.reg_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                        <td class="fontarial">&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                        <td><input name="reg_end" value="<%=JSPFormater.formatDate((regEnd == null) ? new Date() : regEnd, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.reg_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                        
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1" style="padding:3px;">Code</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_code"  value="<%=code%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;">Address</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_address" value="<%=srcAddress%>" class="fontarial" size="20"></td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell" style="padding:3px;">ID / KTP Member</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_id"  value="<%=srcId%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell" style="padding:3px;">Status</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input type="checkbox" name="status_draft" value="1" <%if (statusDraft == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Draft</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name="status_approve" value="1" <%if (statusApprove == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Approve</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name="status_expired" value="1" <%if (statusExpired == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Expired</td>
                                                                                                    </tr>    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1">&nbsp;Location Register</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="4">
                                                                                                <select name="src_location_id">                                                                                                                
                                                                                                    <%if (locations.size() == totLocationxAll) {%>
                                                                                                    <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location -</option>
                                                                                                    <%
            }
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);

                                                                                                    %>
                                                                                                    <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="2"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr > 
                                                                                                        <td height="3" background="../images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6"> 
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="8" valign="middle" colspan="3" class="comment" width="99%"></td>
                                                                            </tr>
                                                                            <tr id="activate"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment" width="99%"><b></b></td>
                                                                            </tr>
                                                                            <%
            try {
                if (iJSPCommand == JSPCommand.SEARCH) {
                    int yearStart = regStart.getYear() + 1900;
                    int yearEnd = regEnd.getYear() + 1900;

                    Vector strDate = new Vector();
                    int grandTotal[];
                    int grandSubTotal = 0;
                    grandTotal = new int[100];
                                                                            %>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" width="99%"> 
                                                                                    <table border="0" cellpadding="1" cellspacing="1">
                                                                                        <tr height="24">
                                                                                            <td class="tablearialhdr" width="25">No</td>                                                                                            
                                                                                            <td class="tablearialhdr" width="150">Location</td>
                                                                                            <%
                                                                                    while (yearStart <= yearEnd) {
                                                                                        int m = 1;
                                                                                        int y = 12;

                                                                                        if (yearStart == (regStart.getYear() + 1900)) {
                                                                                            m = regStart.getMonth() + 1;
                                                                                        }

                                                                                        if (yearStart == yearEnd) {
                                                                                            y = regEnd.getMonth() + 1;
                                                                                        }

                                                                                        for (int i = m; i <= y; i++) {

                                                                                            String strMonth = "";
                                                                                            String intMonth = "";
                                                                                            if (i == 1) {
                                                                                                strMonth = "Jan";
                                                                                                intMonth = "01";
                                                                                            } else if (i == 2) {
                                                                                                strMonth = "Feb";
                                                                                                intMonth = "02";
                                                                                            } else if (i == 3) {
                                                                                                strMonth = "Mar";
                                                                                                intMonth = "03";
                                                                                            } else if (i == 4) {
                                                                                                strMonth = "Apr";
                                                                                                intMonth = "04";
                                                                                            } else if (i == 5) {
                                                                                                strMonth = "Mei";
                                                                                                intMonth = "05";
                                                                                            } else if (i == 6) {
                                                                                                strMonth = "Jun";
                                                                                                intMonth = "06";
                                                                                            } else if (i == 7) {
                                                                                                strMonth = "Jul";
                                                                                                intMonth = "07";
                                                                                            } else if (i == 8) {
                                                                                                strMonth = "Agu";
                                                                                                intMonth = "08";
                                                                                            } else if (i == 9) {
                                                                                                strMonth = "Sep";
                                                                                                intMonth = "09";
                                                                                            } else if (i == 10) {
                                                                                                strMonth = "Okt";
                                                                                                intMonth = "10";
                                                                                            } else if (i == 11) {
                                                                                                strMonth = "Nov";
                                                                                                intMonth = "11";
                                                                                            } else if (i == 12) {
                                                                                                strMonth = "Des";
                                                                                                intMonth = "12";
                                                                                            }
                                                                                            strMonth = strMonth + "-" + yearStart;
                                                                                            strDate.add(intMonth + "-" + yearStart);
                                                                                            %>
                                                                                            <td class="tablearialhdr" width="70"><%=strMonth%></td>
                                                                                            <%
                                                                                        }
                                                                                        yearStart++;
                                                                                    }

                                                                                            %>
                                                                                            <td class="tablearialhdr" width="70">Total</td>
                                                                                        </tr>
                                                                                        <%
                                                                                        int nomor = 1;
                                                                                    for (int i = 0; i < loc.size(); i++) {
                                                                                        Location l = (Location) loc.get(i);
                                                                                        Location lxx = new Location();
                                                                                        try {
                                                                                            lxx = DbLocation.fetchExc(l.getOID());
                                                                                        } catch (Exception e) {
                                                                                        }
                                                                                        if (lxx.getType().equals(DbLocation.TYPE_STORE) && lxx.getCode().compareTo("1024") != 0 && lxx.getCode().compareTo("1033") != 0 && lxx.getCode().compareTo("1022") != 0 && lxx.getCode().compareTo("1007") != 0 ){
                                                                                            String style = "";
                                                                                            if (i % 2 == 0) {
                                                                                                style = "tablearialcell";
                                                                                            } else {
                                                                                                style = "tablearialcell1";
                                                                                            }
                                                                                        %>    
                                                                                        <tr height="22">
                                                                                            <td nowrap class="<%=style%>" align="center" style="padding:3px;"><%=(nomor)%></td>                                                                                            
                                                                                            <td nowrap class="<%=style%>" style="padding:3px;"><%=l.getName().toUpperCase()%></td>
                                                                                            <%
                                                                                                String where = whereClause;

                                                                                                where = where + " and " + DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID] + " = " + l.getOID();

                                                                                                where = where + " and ( " + DbCustomer.colNames[DbCustomer.COL_REG_DATE] + " between '" + JSPFormater.formatDate(regStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(regEnd, "yyyy-MM-dd") + " 23:59:59') ";
                                                                                                Hashtable value = DbCustomer.getTotal(where, DbCustomer.colNames[DbCustomer.COL_REG_DATE]);
                                                                                                int subTotal = 0;
                                                                                                for (int x = 0; x < strDate.size(); x++) {
                                                                                                    String per = String.valueOf(strDate.get(x));
                                                                                                    int total = 0;
                                                                                                    try {
                                                                                                        total = Integer.parseInt(String.valueOf(value.get(String.valueOf(per))));
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                    subTotal = subTotal + total;
                                                                                                    grandTotal[x] = grandTotal[x] + total;
                                                                                                    grandSubTotal = grandSubTotal + total;
                                                                                            %>    
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(total, "###,###.##")%></td>
                                                                                            <%}%>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        nomor++;
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="2" align="center" bgcolor="#cccccc" class="fontarial"><b>Grand Total</b></td>
                                                                                            <%for (int x = 0; x < strDate.size(); x++) {%>
                                                                                            <td align="right" bgcolor="#cccccc" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(grandTotal[x], "###,###.##")%></b></td>
                                                                                            <%}%>
                                                                                            <td align="right" bgcolor="#cccccc" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(grandSubTotal, "###,###.##")%></b></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="3" class="command" width="99%"> 
                                                                                &nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                            <%
                                                                                    if (privPrint) {

                                                                                        session.putValue("REPORT_GROUP_CUSTOMER", memberParameter);
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="3">
                                                                                    <table>
                                                                                        <tr>                                                                                            
                                                                                            <%if (privPrint) {%>
                                                                                            <td width="25"><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                            <%}%>
                                                                                        </tr>    
                                                                                    </table>    
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <%}%>
                                                                            
                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                            
                                                                            <tr align="left" valign="top" height="35"> 
                                                                                <td colspan="3"></td>
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                        </form>
                                                        <!-- #EndEditable -->
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


