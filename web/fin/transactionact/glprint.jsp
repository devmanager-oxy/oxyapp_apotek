
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail) {
        boolean found = false;
        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail cr = (GlDetail) listGlDetail.get(i);
                if (cr.getCoaId() == glDetail.getCoaId() && cr.getForeignCurrencyId() == glDetail.getForeignCurrencyId()) {
                    //jika coa sama dan currency sama lakukan penggabungan
                    cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount() + glDetail.getForeignCurrencyAmount());
                    if (cr.getDebet() > 0 && glDetail.getDebet() > 0) {
                        cr.setDebet(cr.getDebet() + glDetail.getDebet());
                        found = true;
                    } else {

                        if (cr.getCredit() > 0 && glDetail.getCredit() > 0) {
                            cr.setCredit(cr.getCredit() + glDetail.getCredit());
                            found = true;
                        }
                    }

                }
            }
        }

        if (!found) {
            listGlDetail.add(glDetail);
        }

        return listGlDetail;
    }

    public double getTotalDetail(Vector listx, int typex) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                GlDetail crd = (GlDetail) listx.get(i);
                //debet
                if (typex == 0) {
                    result = result + crd.getDebet();
                } //credit
                else {
                    result = result + crd.getCredit();
                }
            }
        }
        return result;
    }

%>
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGl = JSPRequestValue.requestLong(request, "hidden_glarchive");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

            long oidGlDetail = 0;
            int vectSize = 0;

            JspGl jspGl = new JspGl();
            JspGlDetail jspGlDetail = new JspGlDetail();

            Gl gl = new Gl();
            if (oidGl != 0) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }

            Vector listGlDetail = DbGlDetail.list(0, 0, "gl_id=" + gl.getOID(), "");
            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            Vector deps = DbDepartment.list(0, 0, "", "code");

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Memo", "Journal", "Activity", "GL with no expense account (Non activity transaction)", //0-6
                "Account - Description", "Segments", "Currency", "Booked Rate", "Debet", "Credit", "Description", "Code", "Amount"}; //7-15

            String[] langNav = {"General Journal", "Archives Detail", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Memo", "Jurnal", "Aktivitas", "Jurnal tanpa perkiraan biaya (Tidak ada aktifitas transaksi)",
                    "Perkiraan", "Segment", "Mata Uang", "Kurs Transaksi", "Debet", "Credit", "Keterangan", "Kode", "Jumlah"
                };
                langGL = langID;

                String[] navID = {"Jurnal Umum", "Detail Arsip", "Tanggal"};
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
<script language="JavaScript">
            
            <%if (!priv || !privView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdActivity(oid){
                document.frmglarchive.hidden_glarchive.value=oid;
                document.frmglarchive.hidden_gl_id.value=oid;
                <%if (gl.getActivityStatus() != null && gl.getActivityStatus().equals(I_Project.NA_NOT_POSTED_STATUS)) {%>
                document.frmglarchive.action="glactivity.jsp";
                document.frmglarchive.command.value="<%=JSPCommand.NONE%>";
                <%} else {%>	
                document.frmglarchive.action="glactivityprint.jsp";
                <%}%>
                document.frmglarchive.submit();
            }
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptGLPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>");
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
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmglarchive" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
                          <input type="hidden" name="hidden_glarchive" value="<%=oidGl%>">
                          <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>">
                          <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="31%">&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : 
                                                    <%
            User u = new User();
            try {
                u = DbUser.fetch(gl.getOperatorId());
            } catch (Exception e) {
            }
                                                                                                                %>
                                                    <%=u.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%"><%=langGL[0]%></td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=gl.getJournalNumber()%></td>
                                                <td width="12%"><%=langGL[1]%></td>
                                                <td width="42%"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%"><%=langGL[2]%></td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=gl.getRefNumber()%></td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%"><%=langGL[3]%></td>
                                                <td width="3%">&nbsp;</td>
                                                <td colspan="3"><%=gl.getMemo()%></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td>&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="100%" class="page"> 
                                                  <table id="list" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td rowspan="2"  class="tablehdr" nowrap width="16%">Kegiatan</td>
                                                            <td rowspan="2"  class="tablehdr" nowrap width="17%"><%=langGL[7]%></td>
                                                            <td rowspan="2" class="tablehdr" width="17%"><%=langGL[8]%></td>
                                                            <td colspan="2" class="tablehdr"><%=langGL[9]%></td>
                                                            <td rowspan="2" class="tablehdr" width="7%"><%=langGL[10]%></td>
                                                            <td rowspan="2" class="tablehdr" width="7%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                            <td rowspan="2" class="tablehdr" width="6%"><%=langGL[12]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                            <td rowspan="2" class="tablehdr" width="16%"><%=langGL[13]%></td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="5%" class="tablehdr"><%=langGL[14]%></td>
                                                            <td width="9%" class="tablehdr"><%=langGL[15]%></td>
                                                          </tr>
                                                          <%
            if (listGlDetail != null && listGlDetail.size() > 0) {
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {
                    }

                    Currency curr = new Currency();
                    try {
                        curr = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                    } catch (Exception e) {
                    }
					
					Module module = new Module();
                    try {
                        module = DbModule.fetchExc(crd.getModuleId());
                    } catch (Exception e) {
						System.out.println(e.toString());
                    }
					
					//out.println("crd.getModuleId() : "+crd.getModuleId());
					
					
					//Tokenizer untuk Sasaran
					String kegiatan = "";
					if(module.getOID()!=0){
						StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(module.getDescription(), ";");
		
						int countOut = 0;
		
						while (strTokenizerOutputDeliver.hasMoreTokens()) {
		
							if (countOut != 0) {
								kegiatan = "("+(countOut+1)+") "+kegiatan + " ";
							}
		
							kegiatan = kegiatan + strTokenizerOutputDeliver.nextToken();
							countOut++;
						}
					}else{
						kegiatan = "Non Kegiatan";
					}
					//=== END Tokenizer untuk Sasaran ===

                                                                                                                            %>
                                                          <tr> 
                                                            <td class="tablecell" width="16%"><%=kegiatan%></td>
                                                            <td class="tablecell" width="17%" nowrap><%=c.getCode() + " - " + c.getName()%></td>
                                                            <td width="17%" class="tablecell" align="center"> 
                                                              <div align="left"> 
                                                                <%
																
																String segment = "";																
																try{
																	if(crd.getSegment1Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment1Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment2Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment2Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment3Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment3Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment4Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment4Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment5Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment5Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment6Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment6Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment7Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment7Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment8Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment8Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment9Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment9Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment10Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment10Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment11Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment11Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment12Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment12Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment13Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment13Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment14Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment14Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																	
																	if(crd.getSegment15Id()!=0){																	
																		SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment15Id());
																		segment = segment + sd.getName()+" | ";																		
																	}
																}
																catch(Exception e){
																}
															
																if(segment.length()>0){
																	segment = segment.substring(0, segment.length()-3);
																}
																
																%>
																
																<%=segment%> </div>
                                                            </td>
                                                            <td width="5%" class="tablecell" align="center"><%=curr.getCurrencyCode()%></td>
                                                            <td width="9%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%></td>
                                                            <td width="7%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%></td>
                                                            <td width="7%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></td>
                                                            <td width="6%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></td>
                                                            <td width="16%" class="tablecell" align="right"> 
                                                              <div align="left"><%=crd.getMemo()%></div>
                                                            </td>
                                                          </tr>
                                                          <%
                }
            }
                                                                                                                            %>
                                                          <tr> 
                                                            <td class="tablecell" colspan="6" height="1"></td>
                                                            <td width="7%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                            <td width="6%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                            <td width="16%" class="tablecell" height="1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="6" height="20"> 
                                                              <div align="right"><b>TOTAL 
                                                                : </b></div>
                                                            </td>
                                                            <td width="7%" bgcolor="#CCCCCC" height="20"> 
                                                              <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                            </td>
                                                            <td width="6%" bgcolor="#CCCCCC" height="20"> 
                                                              <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b></div>
                                                            </td>
                                                            <td width="16%" bgcolor="#CCCCCC" height="20">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr id="command_line"> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <!--DWLayoutTable-->
                                        <tr> 
                                          <td colspan="2" height="24"></td>
                                        </tr>
                                        <tr> 
                                          <td width="629"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/print2.gif',1)"><img src="../images/print.gif" name="print1" width="53" height="22" border="0"></a></td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="9%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
                                                <td width="83%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="3%">&nbsp;</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="83%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"><a href="gldetail-audit.jsp?hidden_gl_id=<%=gl.getOID()%>"> 
                                                  <b>Update Detail</b></a></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="178">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp;</td>
                            </tr>
                          </table>
                        </form>
                        <!-- #EndEditable --> </td>
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
