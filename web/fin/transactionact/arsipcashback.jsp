
<%-- 
    Document   : arsipcashback
    Created on : Dec 1, 2015, 4:10:43 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            if (session.getValue("REPORT_CASH_BACK_LANGSUNG") != null) {
                session.removeValue("REPORT_CASH_BACK_LANGSUNG");
            }

            Vector locations = DbSegmentDetail.listLocation(user.getOID());
            String where = DbMemberPoint.colNames[DbMemberPoint.COL_TYPE] + " = " + DbMemberPoint.TYPE_CASH_BACK_LANGSUNG + " and " +
                    DbMemberPoint.colNames[DbMemberPoint.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd ") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd ") + " 23:59:59' ";

            if (locationId == 0) {
                if (locations != null && locations.size() > 0) {
                    if (totLocationxAll != locations.size()) {
                        Location locSelect = new Location();
                        try {
                            locSelect = (Location) locations.get(0);
                            locationId = locSelect.getOID();
                            where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = " + locationId;
                        } catch (Exception e) {
                        }
                    }
                } else {
                    where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = -1";
                }
            } else {
                where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = " + locationId;
            }

            Vector listMember = DbMemberPoint.list(0, 0, where, DbMemberPoint.colNames[DbMemberPoint.COL_DATE]);

            if (iJSPCommand == JSPCommand.POST) {
                Vector accDebet = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_CASH_BACK_DEBET + "'", "");
                Vector accCredit = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_CASH_BACK_CREDIT + "'", "");

                long coaDebet = 0;
                long coaCredit = 0;
                if (accDebet != null && accDebet.size() > 0) {
                    try {
                        AccLink acc = (AccLink) accDebet.get(0);
                        coaDebet = acc.getCoaId();
                    } catch (Exception e) {
                    }
                }

                if (accCredit != null && accCredit.size() > 0) {
                    try {
                        AccLink acc = (AccLink) accCredit.get(0);
                        coaCredit = acc.getCoaId();
                    } catch (Exception e) {
                    }
                }

                if (listMember != null && listMember.size() > 0 && coaDebet != 0 && coaCredit != 0) {
                    for (int i = 0; i < listMember.size(); i++) {
                        MemberPoint mp = (MemberPoint) listMember.get(i);
                        int cek = JSPRequestValue.requestInt(request, "check" + mp.getOID());
                        if (cek == 1 && mp.getPostedStatus() == 0) {
                            DbMemberPoint.postJournal(mp, user.getOID(), coaDebet, coaCredit, sysCompany);
                        }
                    }
                }
                listMember = DbMemberPoint.list(0, 0, where, DbMemberPoint.colNames[DbMemberPoint.COL_DATE]);
            }

            String[] langRP = {"Location", "Document", "Date", "Ignored", "To", "Number", "Notes", "Period", "Item Name", "Qty", "Price", "Amount"};
            String[] langNav = {"Journal", "Cash Back - Archive Journal", "Records", "Adjusment Stock", "Search Parameters", "Posted journal success",
                "Some journal can't be posted, please check coa configuration in group item", "Click search button to show the data", "Posting data success", "Some data can't proccess", "Data not found"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Dokumen", "Tanggal", "Abaikan", "Sampai", "Nomor", "Keterangan", "Periode", "Nama Barang", "Qty", "Harga", "Jumlah"};
                langRP = langID;

                String[] navID = {"Jurnal", "Cash Back - Arsip Jurnal", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting, cek setup coa di item group", "Klik tombol search untuk menampilkan data", "Posting data berhasil", "Beberapa data gagal di posting", "Data tidak ditemukan"
                };
                langNav = navID;
            }

            ReportParameter rp = new ReportParameter();
            rp.setLocationId(locationId);
            rp.setDateFrom(tanggal);
            rp.setDateTo(tanggalEnd);
            session.putValue("REPORT_CASH_BACK_LANGSUNG", rp);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmcashback.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcashback.action="arsipcashback.jsp?menu_idx=<%=menuIdx%>";
                document.frmcashback.submit();
            }
            
            function cmdPostJournal(){
                document.frmcashback.command.value="<%=JSPCommand.POST%>";
                document.frmcashback.action="arsipcashback.jsp?menu_idx=<%=menuIdx%>";
                document.frmcashback.submit();
            }
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.ReportCashBackLangsungXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                
                function setChecked(val){
                 <%
            for (int k = 0; k < listMember.size(); k++) {
                MemberPoint osl = (MemberPoint) listMember.get(k);
                if (osl.getPostedStatus() == 0) {
                %>
                    document.frmcashback.check<%=osl.getOID()%>.checked=val.checked;
                <%
                }
            }
                %>
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcashback" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                        
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="title"> 
                                                                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                                        %>
                                                                        <%@ include file="../main/navigator.jsp"%>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">
                                                                                    <table border="0" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                                        <tr>
                                                                                            <td colspan="5" height="10"></td>
                                                                                        </tr>   
                                                                                        <tr height="22">
                                                                                            <td width="80" class="tablearialcell" class="fontarial" style="color:#63605C">&nbsp;Tanggal</td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td width="300">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashback.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                        <td>&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                                        <td><input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashback.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                            <td width="7" colspan="4"></td>                                                                                                                                                        
                                                                                        </tr> 
                                                                                        <tr height="22">
                                                                                            <td class="tablearialcell" class="fontarial" style="color:#63605C">&nbsp;Lokasi</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="4">
                                                                                                <%

                                                                                                %>
                                                                                                <select name="src_location_id" class="fontarial">  
                                                                                                    <%if (totLocationxAll == locations.size()) {%>
                                                                                                    <option onClick="javascript:cmdchange()" value="0" <%if (0 == locationId) {%>selected<%}%>>- All Location - </option>
                                                                                                    <%}%>
                                                                                                    <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                                    %>
                                                                                                    <option onClick="javascript:cmdchange()" value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>           
                                                                                            </td>
                                                                                        </tr>                                                                                                                                                    
                                                                                    </table>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="4"> 
                                                                                    <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="10%" height="10">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="15">&nbsp;</td>
                                                                            </tr>                                                                                                                                        
                                                                            <tr> 
                                                                                <td colspan="4" height="15">
                                                                                    <table border="0" cellspacing="1" cellpadding="0" width="1100">
                                                                                        <tr height="24">
                                                                                            <td width="25" class="tablearialhdr">No</td>
                                                                                            <td width="80" class="tablearialhdr">Date</td>
                                                                                            <td width="200" class="tablearialhdr">Location</td>
                                                                                            <td class="tablearialhdr">Member</td>                                                                                                                                                        
                                                                                            <td width="80" class="tablearialhdr">Amount</td>
                                                                                            <td width="80" class="tablearialhdr">Status</td>
                                                                                            <td width="130" class="tablearialhdr">Posted By</td>                                                                                            
                                                                                        </tr>
                                                                                        <%
            if (listMember != null && listMember.size() > 0) {
                double total = 0;
                boolean readyPosted = false;
                for (int i = 0; i < listMember.size(); i++) {
                    MemberPoint mp = (MemberPoint) listMember.get(i);

                    String style = "";
                    if (i % 2 == 0) {
                        style = "tablearialcell1";
                    } else {
                        style = "tablearialcell";                    
                    }

                    String strLoc = "";
                    if (mp.getLocationId() != 0) {
                        try {
                            Location loc = DbLocation.fetchExc(mp.getLocationId());
                            strLoc = loc.getName();
                        } catch (Exception e) {
                        }
                    }

                    String strCust = "";
                    if (mp.getCustomerId() != 0) {
                        try {
                            Customer cus = DbCustomer.fetchExc(mp.getCustomerId());
                            strCust = cus.getName();
                        } catch (Exception e) {
                        }
                    }

                    total = total + mp.getPoint();

                                                                                        %>
                                                                                        <tr height="22">
                                                                                            <td align="center" class="<%=style%>"><%=(i + 1)%></td>
                                                                                            <td align="center" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatDate(mp.getDate(), "yyyy-MM-dd")%></td>
                                                                                            <td align="left" class="<%=style%>" style="padding:3px;"><%=strLoc%></td>
                                                                                            <td align="left" class="<%=style%>" style="padding:3px;"><%=strCust%></td>   
                                                                                            <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(mp.getPoint(), "###,###.##") %></td>                                                                                                                                                         
                                                                                            <%
                                                                                                if (mp.getPostedStatus() == 1 ) {
                                                                                                    String postedBy = "";
                                                                                                    if (mp.getPostedById() != 0) {
                                                                                                        try {
                                                                                                            User usx = DbUser.fetch(mp.getPostedById());
                                                                                                            postedBy = usx.getFullName();
                                                                                                        } catch (Exception e) {
                                                                                                        }
                                                                                                    }
                                                                                            %>
                                                                                            <td bgcolor="#E6AD49" class="fontarial" >       
                                                                                                <div align="center"><font size="1">POSTED</font></div>
                                                                                            </td>
                                                                                            <td align="left" class="<%=style%>" style="padding:3px;"><%=postedBy%></td>                                                                                                                                                                                                                                                    
                                                                                            <%
                                                                                            } else {
                                                                                                readyPosted = true;

                                                                                            %>
                                                                                            <td bgcolor="#D5645B" class="fontarial" >                                                                                                                                                        
                                                                                                <div align="center"><font size="1">NOT POSTED</font></div>
                                                                                            </td>
                                                                                            <td align="left" class="<%=style%>" style="padding:3px;">&nbsp;</td>                                                                                                
                                                                                            <%}%>                                                                                                                                                        
                                                                                        </tr>    
                                                                                        
                                                                                        <%
                                                                                            }%>
                                                                                        <tr height="22">
                                                                                            <td align="center" bgcolor="#cccccc" colspan="4" classs="fontarial">Grand Total</td>                                                                                                                                                        
                                                                                            <td align="right" bgcolor="#cccccc" style="padding:3px;" classs="fontarial"><%=JSPFormater.formatNumber(total, "###,###.##") %></td>
                                                                                            <td align="center" bgcolor="#cccccc" colspan="3"></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="8" height="20"></td>
                                                                                        </tr>
                                                                                        <%if (privPrint) {%>
                                                                                        <tr>
                                                                                            <td colspan="8" height="25">
                                                                                               <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="8" height="20"></td>
                                                                                        </tr>
                                                                                        <%



            }
                                                                                        %>
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr> 
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                document.all.closecmd.style.display="";
                                                                document.all.closemsg.style.display="none";
                                                            </script>
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
