
<%-- 
    Document   : modulopen
    Created on : Mar 12, 2012, 10:43:06 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<%
            String sourcePage = JSPRequestValue.requestString(request, "source_name");

            if (sourcePage == null || sourcePage.length() == 0) {
                sourcePage = "frmgl";
            }

            String where = JSPRequestValue.requestString(request, "where");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String val = JSPRequestValue.requestString(request, "val");
            String formName = JSPRequestValue.requestString(request, "formName");
            String idx = JSPRequestValue.requestString(request, "id");
            String desc = JSPRequestValue.requestString(request, "desc");
            StringTokenizer strTokenizer = new StringTokenizer(val, ",");
            Vector listMd = new Vector();

            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
            String whereMd = "";
            String oidMd = "";

            long jenAktifitas = 0;

            if (vSeg != null && vSeg.size() > 0) {

                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {

                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (iSeg == 2) {
                        jenAktifitas = segment_id;
                    }

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (iSeg == 0) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                    } else if (iSeg == 1) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                    } else if (iSeg == 2) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                    } else if (iSeg == 3) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                    } else if (iSeg == 4) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                    } else if (iSeg == 5) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                    } else if (iSeg == 6) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                    } else if (iSeg == 7) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                    } else if (iSeg == 8) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                    } else if (iSeg == 9) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                    } else if (iSeg == 10) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                    } else if (iSeg == 11) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                    } else if (iSeg == 12) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                    } else if (iSeg == 13) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                    } else if (iSeg == 14) {
                        whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                    }
                }
            }

            if (activityPeriodId != 0) {
                if (whereMd.length() > 0) {
                    whereMd = whereMd + " and ";
                }

                whereMd = whereMd + DbModule.colNames[DbModule.COL_ACTIVITY_PERIOD_ID] + " = " + activityPeriodId;
            }

            if (iJSPCommand == JSPCommand.SUBMIT) {
                System.out.println("where " + whereMd);
                listMd = DbModule.list(0, 0, whereMd, null);
            }

            /*** LANG ***/
            String[] langCT = {"Number", "Code", "Activity", "Target", "Total Budget", "Total", "Saldo", "Period"}; //0-7

            String[] langNav = {"Activity", "Activity List", "Data not found"};

            if (lang == LANG_ID) {

                String[] langID = {"No", "Kode", "Kegiatan", "Sasaran", "Total Anggaran", "Total Pemakaian", "Saldo", "Periode"}; //0-7

                langCT = langID;

                String[] navID = {"Kegiatan", "Data Kerja", "Data tidak ditemukan"};
                langNav = navID;
            }

%>
<html >
    <head>
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            function cmdSelect(moduleid,modulename,coaid, coaname){                
                self.opener.document.<%=sourcePage%>.module_txt.value = modulename;
                self.opener.document.<%=sourcePage%>.<%=JspGlDetail.colNames[JspGlDetail.JSP_MODULE_ID]%>.value = moduleid;           
                self.opener.document.<%=sourcePage%>.coa_txt.value = coaname;
                self.opener.document.<%=sourcePage%>.<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>.value = coaid;           
                self.close();
            }
            
            function cmdGetData(){
                document.form1.command.value="<%=JSPCommand.SUBMIT%>";
                document.form1.action="modulopen.jsp";
                document.form1.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            //-->
        </script>
    </head>
    <body>
        <form name="form1" method="post" action="">
            <input type="hidden" name="command">
            <input type="hidden" name="source_name" value="<%=sourcePage%>">  
            <table width="100%">
                <tr> 
                    <td align="center"> 
                        <table width="98%" cellpadding="0" cellspacing="1">
                            <tr> 
                                <td colspan="3"> 
                                    <%
            Vector vSegment = new Vector();

            try {
                vSegment = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            } catch (Exception e) {
            }

            if (vSegment != null && vSegment.size() > 0) {%>
                                    <table width="625">
                                        <tr> 
                                            <td width="102">&nbsp;</td>
                                            <td width="511">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="102"><%=langCT[7]%></td>
                                            <td colspan="2">
                                                <%
                                        Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
                                                %>
                                                <select name="activity_period_id">
                                                    <%if (actPeriods != null && actPeriods.size() > 0) {
                                            for (int i = 0; i < actPeriods.size(); i++) {
                                                ActivityPeriod ap = (ActivityPeriod) actPeriods.get(i);
                                                    %>
                                                    <option value="<%=ap.getOID()%>" <%if (ap.getOID() == activityPeriodId) {%>selected<%}%>><%=ap.getName()%></option>
                                                    <%
                                            }
                                        }
                                                    %>
                                                </select>                                                                                                            
                                            </td>
                                        </tr> 
                                        <%
                                        if (vSegment != null && vSegment.size() > 0) {

                                            for (int i = 0; i < vSegment.size(); i++) {

                                                Segment seg = (Segment) vSegment.get(i);
  String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + seg.getOID();
             switch (i + 1) {
                 //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                 //maka akan di tampikan sesuai dengan segment yang ditentukan
                 case 1:
                     if (user.getSegment1Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment1Id();
                     }
                     break;
                 case 2:
                     if (user.getSegment2Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment2Id();
                     }
                     break;
                 case 3:
                     if (user.getSegment3Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment3Id();
                     }
                     break;
                 case 4:
                     if (user.getSegment4Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment4Id();
                     }
                     break;
                 case 5:
                     if (user.getSegment5Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment5Id();
                     }
                     break;
                 case 6:
                     if (user.getSegment6Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment6Id();
                     }
                     break;
                 case 7:
                     if (user.getSegment7Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment7Id();
                     }
                     break;
                 case 8:
                     if (user.getSegment8Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment8Id();
                     }
                     break;
                 case 9:
                     if (user.getSegment9Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment9Id();
                     }
                     break;
                 case 10:
                     if (user.getSegment10Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment10Id();
                     }
                     break;
                 case 11:
                     if (user.getSegment11Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment11Id();
                     }
                     break;
                 case 12:
                     if (user.getSegment12Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment12Id();
                     }
                     break;
                 case 13:
                     if (user.getSegment13Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment13Id();
                     }
                     break;
                 case 14:
                     if (user.getSegment14Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
                     }
                     break;
                 case 15:
                     if (user.getSegment15Id() != 0) {
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
                     }
                     break;
             }
                                                
                                                
                                                Vector sgDetails = DbSegmentDetail.list(0, 0, wh, "");
                                                int pgs = i + 1;
                                                long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");

                                        %>
                                        <tr align="left"> 
                                            <td height="21" width="102">&nbsp;<%=seg.getName()%></td>
                                            <td height="21" colspan="2" width="511"> 
                                                <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);

                                                    %>
                                                    <option value="<%=sd.getOID()%>" <%if (sd.getOID() == seg_id) {%>selected<%}%> ><%=sd.getName()%></option>
                                                    <%}
                                                }%>
                                                </select>
                                            </td>
                                        </tr>
                                        <%}
                                        }%>
                                        <tr> 
                                            <td width="102">&nbsp;</td>
                                            <td width="511"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" height="29">
                                                    <tr> 
                                                        <td width="5%"><a href="javascript:cmdGetData()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="20" border="0" style="padding:0px"></a></td>
                                                        <td width="95%">&nbsp;<a href="javascript:cmdGetData()">Get Data</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <%}%>
                                </td>
                            </tr>
                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                if (listMd != null && listMd.size() > 0) {%>
                            <tr> 
                                <td class="tablehdr" width="10%"><%=langCT[0]%></td>
                                <td class="tablehdr" width="30%"><%=langCT[2]%></td>
                                <td class="tablehdr" width="43%">Budget</td>
                            </tr>
                            <%
                                    for (int i = 0; i < listMd.size(); i++) {

                                        Module mod = (Module) listMd.get(i);

                                        String descx = "";
                                        StringTokenizer strTok = new StringTokenizer(mod.getDescription(), ";");

                                        int countOut = 0;

                                        while (strTok.hasMoreTokens()) {

                                            if (countOut != 0) {
                                                descx = descx + "<BR>";
                                            }

                                            descx = descx + strTok.nextToken();
                                            countOut++;
                                        }

                                        if (i % 2 == 0) {
                            %>
                            <tr> 
                                <td class="tablecell" align="center" valign="top" width="10%"><%=i + 1%></td>
                                <td class="tablecell" align="left" valign="top" width="30%">&nbsp;<%=descx%></td>
                                <td class="tablecell" align="right" valign="top" width="43%"> 
                                    <div align="left"> 
                                        <%
                                    Vector temp = DbModuleBudget.list(0, 0, "module_id=" + mod.getOID(), "");
                                        %>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                                <td height="17"><b>Perkiraan</b></td>
                                                <td height="17"><b>Saldo</b></td>
                                            </tr>
                                            <tr> 
                                                <td colspan="2" height="1" bgcolor="#CCCCCC"></td>
                                            </tr>
                                            <%if (temp != null && temp.size() > 0) {
                                                
                                        for (int x = 0; x < temp.size(); x++) {
                                            ModuleBudget mbg = (ModuleBudget) temp.get(x);
                                            Coa coa = new Coa();
                                            try {
                                                coa = DbCoa.fetchExc(mbg.getCoaId());
                                            } catch (Exception e) {}
                                            %>
                                            <tr> 
                                                <td><a href="javascript:cmdSelect('<%=mod.getOID()%>','<%=mod.getDescription()%>','<%=mbg.getCoaId()%>', '<%=coa.getName()%>')"><%=coa.getCode() + " - " + coa.getName()%></a></td>
                                                <td><%=JSPFormater.formatNumber(mbg.getAmount() - mbg.getAmountUsed(), "#,###.##")%></td>
                                            </tr>
                                            <%}
                                    }%>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr> 
                                <td class="tablecelll" align="center" valign="top" width="10%"><%=i + 1%></td>
                                <td class="tablecelll" align="left" valign="top" width="30%">&nbsp;<%=descx%></td>
                                <td class="tablecelll" align="right" valign="top" width="43%"> 
                                    <div align="left"> 
                                        <%
                                    Vector temp = DbModuleBudget.list(0, 0, "module_id=" + mod.getOID(), "");
                                        %>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                                <td height="17"><b>Perkiraan</b></td>
                                                <td height="17"><b>Saldo</b></td>
                                            </tr>
                                            
                                            <%if (temp != null && temp.size() > 0) {
                                        for (int x = 0; x < temp.size(); x++) {
                                            ModuleBudget mbg = (ModuleBudget) temp.get(x);
                                            Coa coa = new Coa();
                                            try {
                                                coa = DbCoa.fetchExc(mbg.getCoaId());
                                            } catch (Exception e) {
                                            }
                                            %>
                                            <tr> 
                                                <td><a href="javascript:cmdSelect('<%=mod.getOID()%>','<%=mod.getDescription()%>','<%=mbg.getCoaId()%>', '<%=coa.getName()%>')"><%=coa.getCode() + " - " + coa.getName()%></a></td>
                                                <td><%=JSPFormater.formatNumber(mbg.getAmount() - mbg.getAmountUsed(), "#,###.##")%></td>
                                            </tr>
                                            <%}
                                    }%>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <%}%>
                            <%}%>
                            <%} else {%>
                            <tr> 
                                <td colspan="3" class="tablecell" align="center"><%=langNav[2]%></td>
                            </tr>
                            <%}
                            } else {%>
                            <tr> 
                                <td colspan="3" class="tablecell" align="center">Klik "Get Data" untuk 
                                menampilkan daftar kegiatan</td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>
            <script language="JavaScript">
                window.focus();
            </script>
        </form>
    </body>
</html>
