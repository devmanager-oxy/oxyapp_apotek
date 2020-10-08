
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
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean bankPriv = true;
%>

<%

            long oidBankDeposit = JSPRequestValue.requestLong(request, "hidden_bankarchive");

            BankDeposit bankDeposit = new BankDeposit();
            bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(bankDeposit.getCoaId());
            } catch (Exception e) {
            }

            String[] langBT = {"Deposit to Account", "Amount", "Memo", "Journal Number", "Transaction Date", //0-4
                "Account - Description", "Currency", "Code", "Amount", "Booked Rate", "Amount", "Description", //5-11
                "Journal is ready to be saved", "Journal has been saved", "Searching", "Customer", "Segments", "Search for Bank Deposit", "Bank Deposit Editor", "Credit", "Amount Credit", "Period", "Receive From", "Segment"}; //12-23

            String[] langNav = {"Bank", "Deposit", "Date", "Select...", "Segment"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Setoran ke Perkiraan", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-4
                    "Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan", //5-11
                    "Jurnal siap untuk di simpan", "Jurnal sukses di simpan", "Pencarian", "Konsumen", "Segmen", "Pencarian", "Editor Bank Deposit", "Credit", "Jumlah Credit", "Periode", "Diterima Dari", "Segmen"}; //12-23

                langBT = langID;
                String[] navID = {"Bank", "Setoran", "Tanggal", "Pilih...", "Segmen"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            Vector segments = DbSegment.list(0, 0, "", "count");
            String str = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <script language="JavaScript">
            
            <%if (!bankPriv) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptBankDepositPDF?oid=<%=appSessUser.getLoginId()%>&dep_id=<%=oidBankDeposit%>");  				
                }
                
                function cmdBack(){
                    window.history.back();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/back2.gif')">
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
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
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
                                                        <form name="frmbankdepositdetail" method ="post" action="">
                                                            <input type="hidden" name="hidden_bankarchive" value="<%=oidBankDeposit%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="13%">&nbsp;</td>
                                                                                                        <td width="33%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="18"> 
                                                                                                        <td width="13%" bgcolor="#EBEBEB">&nbsp;<%=langBT[0]%></td>
                                                                                                        <td width="33%">: <%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                                        <td width="12%"bgcolor="#EBEBEB">&nbsp;<%=langBT[3]%></td>
                                                                                                        <td width="42%">: <%=bankDeposit.getJournalNumber()%></td>
                                                                                                    </tr>
                                                                                                    <tr height="18"> 
                                                                                                        <td width="13%" bgcolor="#EBEBEB">&nbsp;<%=langBT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td width="33%">: <%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></td>
                                                                                                        <td width="12%" bgcolor="#EBEBEB">&nbsp;<%=langBT[4]%></td>
                                                                                                        <td width="42%">: <%=JSPFormater.formatDate(bankDeposit.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                                    </tr>
                                                                                                    <tr height="18"> 
                                                                                                        <td width="13%" bgcolor="#EBEBEB">&nbsp;<%=langBT[2]%></td>
                                                                                                        <td colspan="3">: <%=bankDeposit.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%
            if (segments != null && segments.size() > 0) {
                for (int is = 0; is < segments.size(); is++) {
                    String seg = "";
                    String nameSeg = "";
                    Segment objSeg = (Segment) segments.get(is);

                    seg = objSeg.getName();
                    switch (is + 1) {
                        case 1:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment1Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }
                        case 2:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment2Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 3:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment3Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 4:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment4Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 5:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment5Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 6:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment6Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 7:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment7Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 8:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment8Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 9:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment9Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 10:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment10Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 11:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment11Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 12:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment12Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 13:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment13Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 14:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment14Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 15:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDeposit.getSegment15Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }
                            break;
                    }
                                                                                                    %>
                                                                                                    <tr height="18"> 
                                                                                                        <td width="13%" bgcolor="#EBEBEB">&nbsp;<%=seg%></td>
                                                                                                        <td colspan="3">: <%=nameSeg%></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    
                                                                                                    <%
                }
            }

                                                                                                    %>
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1"> 
                                                                                                <table width="1000" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" rowspan="2" width="25%"><%=langBT[5]%></td>
                                                                                                        <td class="tablehdr" rowspan="2" width="15%"><%=langNav[4]%></td>
                                                                                                        <td class="tablehdr" colspan="2" width="20%"><%=langBT[6]%></td>
                                                                                                        <td class="tablehdr" rowspan="2" valign="4%"><%=langBT[9]%></td>
                                                                                                        <td class="tablehdr" rowspan="2" width="10%"><%=langBT[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td class="tablehdr" rowspan="2" ><%=langBT[11]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="5%" class="tablehdr"><%=langBT[7]%></td>
                                                                                                        <td width="15%" class="tablehdr"><%=langBT[8]%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                Vector vectorList = DbBankDepositDetail.list(0, DbBankDepositDetail.getCount(""), " bank_deposit_id = " + oidBankDeposit, "");
                                                                                for (int i = 0; i < vectorList.size(); i++) {
                                                                                    BankDepositDetail bankDepositDetail = (BankDepositDetail) vectorList.get(i);
                                                                                    Coa coax = new Coa();
                                                                                    try {
                                                                                        coax = DbCoa.fetchExc(bankDepositDetail.getCoaId());
                                                                                    } catch (Exception e) {
                                                                                    }
                                                                                    Currency curr = new Currency();
                                                                                    try {
                                                                                        curr = DbCurrency.fetchExc(bankDepositDetail.getForeignCurrencyId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                    String nameSeg = "&nbsp;";

                                                                                    if (segments != null && segments.size() > 0) {
                                                                                        for (int is = 0; is < segments.size(); is++) {
                                                                                            Segment objSeg = (Segment) segments.get(is);
                                                                                            if (is != 0) {
                                                                                                nameSeg = nameSeg + " | ";
                                                                                            }
                                                                                            nameSeg = nameSeg + objSeg.getName();
                                                                                            switch (is + 1) {
                                                                                                case 1:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment1Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                case 2:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment2Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 3:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment3Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 4:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment4Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 5:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment5Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 6:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment6Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 7:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment7Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 8:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment8Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 9:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment9Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 10:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment10Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 11:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment11Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 12:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment12Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 13:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment13Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 14:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment14Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                case 15:
                                                                                                    try {
                                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(bankDepositDetail.getSegment15Id());
                                                                                                        nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                    break;
                                                                                            }
                                                                                        }
                                                                                    }

                                                                                                    %>											  
                                                                                                    <tr> 
                                                                                                        <td class="tablecell"><%=coax.getCode() + " - " + coax.getName()%></td>										  
                                                                                                        <td class="tablecell"><%=nameSeg%></td>	
                                                                                                        <td class="tablecell" align="center"><%=curr.getCurrencyCode()%></td>
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(bankDepositDetail.getForeignAmount(), "#,###.##")%></td>
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(bankDepositDetail.getBookedRate(), "#,###.##")%></td>
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##")%></td>
                                                                                                        <td class="tablecell"><%=bankDepositDetail.getMemo()%></td>												
                                                                                                    </tr>
                                                                                                    <%
                                                                                }															
                                                                                                    %>
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>&nbsp; </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
            }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <table width="1000" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="2" height="5"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="78%">&nbsp;</td>
                                                                                            <td width="22%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="78%"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td width="9%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="boxed1" width="22%"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="36%"> 
                                                                                                            <div align="left"><b>Total 
                                                                                                                    <%=baseCurrency.getCurrencyCode()%> : 
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="64%"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (bankDeposit.getOID() != 0 && str.equalsIgnoreCase("Y")) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3">&nbsp;</td> 
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <%
    Vector temp = DbApprovalDoc.getDocApproval(oidBankDeposit);
                                                                                    %>
                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td>
                                                                                            <td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                            <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>
                                                                                            <td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
    if (temp != null && temp.size() > 0) {
        Employee userEmp = new Employee();
        try {
            userEmp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }

        for (int i = 0; i < temp.size(); i++) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(i);

            String tanggal = "";
            String status = "";
            String catatan = (apd.getNotes() == null) ? "" : apd.getNotes();
            String nama = "";
            Employee employee = new Employee();
            try {
                employee = DbEmployee.fetchExc(apd.getEmployeeId());
            } catch (Exception e) {
            }

            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(employee.getDepartmentId());
            } catch (Exception e) {
            }

            Approval app = new Approval();
            try {
                app = DbApproval.fetchExc(apd.getApprovalId());
            } catch (Exception e) {
            }

            if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED || apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {
                tanggal = JSPFormater.formatDate(apd.getApproveDate(), "dd/MM/yyyy");
                status = DbApprovalDoc.strStatus[apd.getStatus()];
                nama = employee.getName();
            }

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="11%"><%=apd.getSequence()%></td>
                                                                                            <td width="13%"><%=employee.getPosition()%></td>
                                                                                            <td width="20%"><%=nama%></td>
                                                                                            <td width="13%"><%=tanggal%></td>
                                                                                            <td width="11%"><%=status%></td>
                                                                                            <td width="20%"> 
                                                                                                <%if (bankDeposit.getPostedStatus() == 0) {
                                                                                                    if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED && user.getEmployeeId() == apd.getEmployeeId()) {%>
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                </div>
                                                                                                <%} else if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {%>
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                </div>
                                                                                                <%} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}
} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="12%"> 
                                                                                                <%if (bankDeposit.getPostedStatus() == 0) {%>
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td> 
                                                                                                            <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                                                            %>
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr> 
                                                                                                                        <td> 
                                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/success-2.gif',1)" alt="Klik : Untuk Menyetujui Dokumen"><img src="../images/success.gif" name="save1" height="20" border="0"></a></div>
                                                                                                                        </td>
                                                                                                                        <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no3','','../images/no1.gif',1)" alt="Klik : Untuk tidak menyetujui"><img src="../images/no.gif" name="no3" height="20" border="0"></a></div></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                            <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                                                                                            %>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no','','../images/no1.gif',1)" alt="Klik : Untuk Membatalkan Persetujuan"><img src="../images/no.gif" name="no" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%	} else {%>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','../images/success-2.gif',1)" alt="Klik : Untuk Melakukan Persetujuan"><img src="../images/success.gif" name="save2" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%}
        }
    }%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%} else {%>
                                                                                                &nbsp; 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                        <%}
    }%>
                                                                                        <tr> 
                                                                                            <td width="11%">&nbsp;</td><td width="13%">&nbsp;</td><td width="20%">&nbsp;</td><td width="13%">&nbsp;</td><td width="11%">&nbsp;</td><td width="20%">&nbsp;</td><td width="12%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <%}%>
                                                                            
                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
