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
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
%>
<!-- Jsp Block -->
<%!

	
	public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail){
		boolean found = false;
		if(listGlDetail!=null && listGlDetail.size()>0){
			for(int i=0; i<listGlDetail.size(); i++){
				GlDetail cr = (GlDetail)listGlDetail.get(i);
				if(cr.getCoaId()==glDetail.getCoaId() && cr.getForeignCurrencyId()==glDetail.getForeignCurrencyId()){
					//jika coa sama dan currency sama lakukan penggabungan
					cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount()+glDetail.getForeignCurrencyAmount());
					if(cr.getDebet()>0 && glDetail.getDebet()>0){
						cr.setDebet(cr.getDebet()+glDetail.getDebet());
						found = true;
					}
					else{
					
						if(cr.getCredit()>0 && glDetail.getCredit()>0){
							cr.setCredit(cr.getCredit()+glDetail.getCredit());
							found = true;
						}
					}
					
				}
			}
		}
		
		if(!found){
			listGlDetail.add(glDetail);
		}
		
		return listGlDetail;
	}
	
	public double getTotalDetail(Vector listx, int typex){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				GlDetail crd = (GlDetail)listx.get(i);
				//debet
				if(typex==0){
					result = result + crd.getDebet();
				}
				//credit
				else{
					result = result + crd.getCredit();
				}				
			}
		}
		return result;
	}

%>
<%

//main

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidGl = JSPRequestValue.requestLong(request, "hidden_glarchive");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");

//out.println(oidGl);

long oidGlDetail = 0;
int vectSize = 0;

JspGl jspGl = new JspGl();
JspGlDetail jspGlDetail = new JspGlDetail();

Gl gl = new Gl();
if(oidGl!=0){
	try{
		gl = DbGl.fetchExc(oidGl);
	}
	catch(Exception e){
	}
}

//detail 
Vector listGlDetail = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");
double totalDebet = getTotalDetail(listGlDetail, 0);
double totalCredit = getTotalDetail(listGlDetail, 1);

Vector deps = DbDepartment.list(0,0, "", "code");

%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!glPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>


//=======================================update===========================================================

function cmdActivity(oid){
	document.frmglarchive.hidden_glarchive.value=oid;
	document.frmglarchive.hidden_gl_id.value=oid;
	<%if(gl.getActivityStatus().equals(I_Project.NA_NOT_POSTED_STATUS)){%>
			document.frmglarchive.action="glactivity.jsp";
			document.frmglarchive.command.value="<%=JSPCommand.NONE%>";
	<%}else{%>	
		document.frmglarchive.action="glactivityprint.jsp";
	<%}%>
	//document.frmglarchive.action="glactivityprint.jsp";
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
					  String navigator = "<font class=\"lvl1\">General Journal</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Archive Detail</span></font>";
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
                                                  <div align="right">Date : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : 
                                                    <%
													User u = new User();
													try{
														u = DbUser.fetch(gl.getOperatorId());
													}
													catch(Exception e){
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
                                                <td width="10%">Journal Number</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=gl.getJournalNumber()%></td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="42%"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Reference Number</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="33%"><%=gl.getRefNumber()%></td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Memo</td>
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
                                          <td> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <td class="tab">&nbsp;&nbsp;Journal&nbsp;&nbsp;</td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
												<%if(gl.getNotActivityBase()==0){%>
                                                <td class="tabin"><a href="javascript:cmdActivity('<%=oidGl%>')" class="tablink">Activity</a></td>
												<%}else{%>
												<td nowrap class="tabheader"><font color="#FF0000">&nbsp;GL 
                                                  with no expense account, ( Non 
                                                  activity transaction )</font></td>
												<%}%>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                              </tr>
                                            </table>
                                          </td>
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
                                                            <td rowspan="2"  class="tablehdr" nowrap width="25%">Account 
                                                              - Description</td>
                                                            <td rowspan="2" class="tablehdr" width="25%">Department</td>
                                                            <td colspan="2" class="tablehdr">Currency</td>
                                                            <td rowspan="2" class="tablehdr" width="8%">Booked 
                                                              Rate</td>
                                                            <td rowspan="2" class="tablehdr" width="12%">Debet 
                                                              <%=baseCurrency.getCurrencyCode()%></td>
                                                            <td rowspan="2" class="tablehdr" width="12%">Credit 
                                                              <%=baseCurrency.getCurrencyCode()%> </td>
                                                            <td rowspan="2" class="tablehdr" width="12%">Description</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="6%" class="tablehdr">Code</td>
                                                            <td width="12%" class="tablehdr"> 
                                                              Amount</td>
                                                          </tr>
                                                          <%
														  		if(listGlDetail!=null && listGlDetail.size()>0)
																{
																	for(int i=0; i<listGlDetail.size(); i++)
																	{
																		GlDetail crd = (GlDetail)listGlDetail.get(i);
																																			
																		Coa c = new Coa();
																		try{
																			c = DbCoa.fetchExc(crd.getCoaId());
																		}
																		catch(Exception e){}
																		
																		Currency curr = new Currency();
																		try{	
																			curr = DbCurrency.fetchExc(crd.getForeignCurrencyId());
																		}
																		catch(Exception e){}
																		
														  %>
                                                          <tr> 
                                                            <td class="tablecell" width="25%" nowrap><%=c.getCode()+" - "+c.getName()%></td>
                                                            <td width="25%" class="tablecell" align="center" nowrap> 
                                                              <div align="left"> 
                                                                <%if(crd.getDepartmentId()==0){%>
                                                                0.0.0.0 - TOTAL 
                                                                CORPORATE 
                                                                <%}else{
															long oidx = crd.getDepartmentId();
															if(crd.getSectionId()!=0){
																oidx = crd.getSectionId();
															}
															if(crd.getSubSectionId()!=0){
																oidx = crd.getSubSectionId();
															}
															if(crd.getJobId()!=0){
																oidx = crd.getJobId();
															}
														
														    Department d = new Department();
														    try{
																d = DbDepartment.fetchExc(oidx);
														    }
														  	catch(Exception e){
														    }
																  
															%>
                                                                <%=d.getCode()+" - "+d.getName()%> 
                                                                <%}%>
                                                              </div>
                                                            </td>
                                                            <td width="6%" class="tablecell" align="center"><%=curr.getCurrencyCode()%></td>
                                                            <td width="12%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%></td>
                                                            <td width="8%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%></td>
                                                            <td width="12%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></td>
                                                            <td width="12%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></td>
                                                            <td width="12%" class="tablecell" align="right">
                                                              <div align="left"><%=crd.getMemo()%></div>
                                                            </td>
                                                          </tr>
                                                          <%
														  			}
																}
														  %>
                                                          <tr> 
                                                            <td class="tablecell" colspan="5" height="1"></td>
                                                            <td width="12%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                            <td width="12%" class="tablecell" height="1"> 
                                                              <div align="right"></div>
                                                            </td>
                                                            <td width="12%" class="tablecell" height="1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="5" height="20"> 
                                                              <div align="right"><b>TOTAL 
                                                                : </b></div>
                                                            </td>
                                                            <td width="12%" bgcolor="#CCCCCC" height="20"> 
                                                              <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                            </td>
                                                            <td width="12%" bgcolor="#CCCCCC" height="20"> 
                                                              <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b></div>
                                                            </td>
                                                            <td width="12%" bgcolor="#CCCCCC" height="20">&nbsp;</td>
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
