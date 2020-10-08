<%@ page language="java"%>
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
boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_ARCHIVES);
%>
<!-- Jsp Block -->
<%!
public String drawListJournal(Vector listJournal, String[] lang) {

    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("70%");
    jsplist.setListStyle("listgen");

    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell");
    jsplist.setCellStyle1("tablecell1");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "5%");
    jsplist.addHeader(lang[0], "30%");
    jsplist.addHeader(lang[3], "20");
    jsplist.addHeader(lang[4], "30%");
    jsplist.addHeader(lang[5], "15");

    int index = -1;
    Vector lstData = jsplist.getData();
    int no = 1;

    if (listJournal != null && listJournal.size() > 0) {

        String frmCurrency = "#,###";

        for (int i = 0; i < listJournal.size(); i++) {

            try {

                Vector rowx = new Vector(1, 1);

                Gl objGl = (Gl)listJournal.get(i);

                rowx.add("<div align=\"center\">"+String.valueOf(no)+"</div>");
                rowx.add("<div align=\"left\">"+objGl.getJournalNumber()+"</div>");
                rowx.add("<div align=\"center\">"+objGl.getTransDate()+"</div>");
                rowx.add("<div align=\"left\">"+objGl.getRefNumber()+"</div>");
                rowx.add("<div align=\"center\"><input type=\"checkbox\" name=\"do_"+objGl.getOID()+"\" checked></div>");

                lstData.add(rowx);

                no++;

            } catch (Exception E) {
                System.out.println("[exception] Drawlist Report " + E.toString());
            }
        }

        return jsplist.draw(index);
    } else {
        return "<div align=\"left\">"+lang[8]+"</div>";
    }
}
%>

<%
int iCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

String journalNumber = JSPRequestValue.requestString(request, "journal_number");
long oidPeriod = JSPRequestValue.requestLong(request, "oid_period");

String where = "";
String order = "";

where = DbGl.colNames[DbGl.COL_IS_REVERSAL]+"=1 AND "+
        DbGl.colNames[DbGl.COL_REVERSAL_STATUS]+"=0";
        

if(oidPeriod != 0) {
    where += " AND "+DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+oidPeriod;
}

if(journalNumber != "") {
    where += " AND "+DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" like '%"+journalNumber+"%'";
}

order = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" DESC";

Vector vListJournal = new Vector();

if(iCommand == JSPCommand.SUBMIT) {
    vListJournal = DbGl.list(0, 0, where, order);
}

/*** LANG ***/
String[] langJR = {"Journal Number", "Period", "Journal Reversal List", "Transaction Date", "Reference Number", "Do Reversal?",  //0-5
"Do Journal Reversal", "Please click search button to get your data.", "Data not found.", "Do journal reversal success."}; //6-9

String[] langNav = {"Journal Reversal", "Process", "Date"};
	
if(lang == LANG_ID) {
	String[] langID = {"Nomor Jurnal", "Periode", "Daftar Jurnal Reversal", "Tanggal Transaksi", "Nomor Referensi", "Proses Reversal?", 
        "Proses Jurnal Reversal", "Silahkan tekan tombol pencarian untuk menampilkan data.", "Data tidak ditemukan.", "Proses jurnal reversal sukses."};
        langJR = langID;
	
	String[] navID = {"Jurnal Reversal", "Proses", "Tanggal"};
	langNav = navID;
}

String msgStatus = "";
if(iCommand == JSPCommand.CONFIRM) {
    vListJournal = DbGl.list(0, 0, where, order);
    for(int i=0; i<vListJournal.size(); i++) {
        try {
            Gl objGl = (Gl)vListJournal.get(i);
            String checked = request.getParameter("do_"+objGl.getOID());
            
            if(checked.equals("on")) {
                DbGl.doJournalReversal(objGl.getOID());
            }
        } catch(Exception e) {
            System.out.println("Error when do journal reversal!");
        }
    }
    msgStatus = langJR[9];
    vListJournal = DbGl.list(0, 0, where, order);
}
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

<%if(!glPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>


function cmdSearch(){
    document.frmjournalreversal.command.value="<%=JSPCommand.SUBMIT%>";
    document.frmjournalreversal.action="dojournalreversal.jsp";
    document.frmjournalreversal.submit();
}

function cmdDoReversal(){
    document.frmjournalreversal.command.value="<%=JSPCommand.CONFIRM%>";
    document.frmjournalreversal.action="dojournalreversal.jsp";
    document.frmjournalreversal.submit();
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
<!--End Region JavaScript-->
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                  <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmjournalreversal" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <!--DWLayoutTable-->
                                  <tr align="left" valign="top"> 
                                    <td width="100%" height="127" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="13%">&nbsp;</td>
                                                <td width="26%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%"><%=langJR[0]%></td>
                                                <td width="26%"> 
                                                  <input type="text" name="journal_number"  value="<%=journalNumber%>">
                                                </td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%"><%=langJR[1]%></td>
                                                <td width="26%">
                                                    <%
                                                    Vector p = new Vector(1, 1);
                                                    p = DbPeriode.list(0, 0, "", "NAME");
                                                    Vector p_value = new Vector(1, 1);
                                                    Vector p_key = new Vector(1, 1);
                                                    
                                                    if (p != null && p.size() > 0) {
                                                        for (int i = 0; i < p.size(); i++) {
                                                            Periode period = (Periode) p.get(i);
                                                            p_value.add(period.getName().trim());
                                                            p_key.add("" + period.getOID());
                                                        }
                                                    }
                                                    %>
                                                  <%= JSPCombo.draw("oid_period","", String.valueOf(oidPeriod), p_key, p_value, "", "formElemen") %> </td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%
                                  if (vListJournal != null && vListJournal.size() > 0) {
                                  %>
                                  <tr> 
                                      <td class="boxed1">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td colspan="3"><b><font size="2"><%=langJR[2]%></font></b> </td>
                                              </tr>
                                              <tr align="left" valign="top">
                                                  <td height="22" valign="middle" colspan="3"><%= drawListJournal(vListJournal, langJR)%></td>
                                              </tr>
                                          </table>
                                      </td>
                                  </tr>
                                  <%} else { //if list null %>
                                  <tr> 
                                    <td class="tablecell1" colspan="7"> 
                                      <%
                                      if(iCommand==JSPCommand.NONE){
                                          out.println(langJR[7]);
                                      }else{
                                          out.println(msgStatus!=""?msgStatus:langJR[8]);
                                      }
                                      %>
                                    </td>
                                  </tr>
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="1%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" >
                              <td height="8" valign="middle" width="1%">&nbsp;</td>
                              <td colspan="2" class="command" width="83%">&nbsp;
                              <%if(vListJournal.size()>0) { %>
                              <a href="javascript:cmdDoReversal()"  onMouseOut="MM_swapImgRestore()" onMouseOver=""><%=langJR[6]%></a>
                              <% } %>
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
            <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
