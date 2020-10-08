

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
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.Purchase" %>
<%@ page import = "com.project.ccs.postransaction.purchase.DbPurchase" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_DELETE);
%>

<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long vendorId = JSPRequestValue.requestLong(request, "vendorid");
            String vndInvNumber = JSPRequestValue.requestString(request, "vndinvnumber");
            String poNumber = JSPRequestValue.requestString(request, "ponumber");
            long bankpoId = JSPRequestValue.requestLong(request, "bankpo_id");
            int overDue = JSPRequestValue.requestInt(request, "overdue");
            int overStatus = JSPRequestValue.requestInt(request, "src_overdue");
            
            Date dueDate = new Date();
            if (JSPRequestValue.requestString(request, "duedate").length() > 0) {
                dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "duedate"), "dd/MM/yyyy");
            }

            InvoiceSrc invSrc = new InvoiceSrc();                       
            invSrc.setVendorId(vendorId);            
            invSrc.setPoNumber(poNumber);            
            invSrc.setVndInvNumber(vndInvNumber);            
            invSrc.setDueDate(dueDate);            
            invSrc.setOverDue(overDue);
            invSrc.setStatusOverdue(overStatus);
            
            if (iJSPCommand == JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {
                overDue = 1;
            }

            if (iJSPCommand == JSPCommand.BACK && iJSPCommand != JSPCommand.REFRESH) {
                invSrc = (InvoiceSrc) session.getValue("SRC_POPAY");                
            }

            Vector listDatas = new Vector();
            
            if (iJSPCommand != JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {
                listDatas = QrInvoice.searchForInvoice(invSrc);                                                                   
            }

            session.putValue("SRC_POPAY", invSrc);

            /*** LANG ***/
            String[] langBT = {"Search for Open Invoice", "Vendor", "Vendor Invoice Number", "Due Date", "Ignore", "Yes", //0-5
                "Status", "Vendor", "Vendor Invoice Number", "Currency", "Amount", "Payment", "Due Date", //6-12
                "Record is Empty", "Please click on search button to find your data","Overdue"}; //13-15

            String[] langNav = {"Acc. Payable", "Faktur Searching", "Date", "Searching", "Journal Number"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian Faktur yang Belum Terbayarkan", "Suplier", "Nomor Faktur Suplier", "Tanggal Pelunasan", "Abaikan", "Ya",
                    "Status", "Suplier", "Nomor Faktur Suplier", "Mata Uang", "Jumlah", "Pelunasan", "Tanggal Pelunasan",
                    "Tidak ada data", "Silahkan tekan tombol search untuk memulai pencarian data","Overdue"
                };
                langBT = langID;

                String[] navID = {"Hutang", "Pencarian Faktur", "Tanggal", "Pencarian", "Nomor Jurnal"};
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
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script> 
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iJSPCommand == JSPCommand.REFRESH) {%>
            window.location="<%=approot%>/transactionact/bankpopaymentedt.jsp?edt_bankpo_payment_id=<%=bankpoId%>&edt=1";
            <%}%>
            
            function cmdSearchJurnal(){
                var numb = document.frmap.jurnal_number.value;                                
                window.open("<%=approot%>/transactionact/sbankpayment.jsp?txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }            
            <!--
            function cmdPayment(oid){
                document.frmap.hidden_vendor_id.value=oid;
                document.frmap.command.value="<%=JSPCommand.NONE%>";
                document.frmap.action="bankpopayment.jsp";                
                document.frmap.submit();
            }
            
            function cmdSearch(){
                document.frmap.command.value="<%=JSPCommand.FIRST%>";
                document.frmap.action="bankpopaymentsrc.jsp";
                document.frmap.submit();
            }
            
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
            //-->
        </script>
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
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --><%
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
                                                        <form name="frmap" method="post" action="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="hidden_vendor_id">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="2" valign="middle" colspan="3">
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <table width="300" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                                        <tr height="5">
                                                                                            <td colspan=""></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="5">&nbsp;</td>
                                                                                            <td><font face="arial"><b><i><%=langNav[3]%> :</i></b></font></td>
                                                                                            <td colspan="3">&nbsp;</td>                                                                                            
                                                                                        </tr>
                                                                                        <tr height="25">
                                                                                            <td width="5">&nbsp;</td>
                                                                                            <td class="tablecell1" width="90">&nbsp;&nbsp;<%=langNav[4]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td width="20"><input size="20" type="text" name="jurnal_number" value=""></td>
                                                                                            <td><input type="hidden" name="bankpo_id" value="">
                                                                                                <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search2.jpg',1)"><img src="../images/search.jpg" name="new21" height="17" border="0"></a>
                                                                                            </td>
                                                                                            <td width="5"></td>
                                                                                        </tr>
                                                                                        <tr height="5">
                                                                                            <td colspan="6"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr><td colspan="2" height="15"></td></tr>
                                                                            <tr> 
                                                                                <td colspan="2" width="100%"><table width="800" border="0" cellspacing="0" cellpadding="0"><tr><td background="../images/line.gif"><img src="../images/line.gif"></td></tr></table></td>
                                                                            </tr>  
                                                                            <tr>
                                                                                <td colspan="2" height="10"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="top" colspan="3" class="comment">                                                                                     
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5">                                                                                                
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" >                                                                                                            
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5"></td>
                                                                                                                    <td colspan="3" height="5"><b><i><%=langBT[0]%></i></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5"></td>
                                                                                                                    <td width="30%" nowrap><%=langBT[1]%></td>
                                                                                                                    <td > 
                                                                                                                        <%
            Vector vnds = DbVendor.list(0, 0, "", "" + DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                        %>
                                                                                                                        <select name="vendorid">
                                                                                                                            <option value="0">< all ></option>
                                                                                                                            <%if (vnds != null && vnds.size() > 0) {
                for (int i = 0; i < vnds.size(); i++) {
                    Vendor v = (Vendor) vnds.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=v.getOID()%>" <%if (vendorId == v.getOID()) {%>selected<%}%>><%=v.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td ></td>
                                                                                                                    <td ><%=langBT[2]%></td>
                                                                                                                    <td ><input type="text" name="vndinvnumber" value="<%=vndInvNumber%>" size="25"></td>                                                                                                                    
                                                                                                                    <td ></td>       
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td ></td>                                                                                                                    
                                                                                                                    <td ><%=langBT[3]%></td>
                                                                                                                    <td > 
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="duedate" value="<%=JSPFormater.formatDate(dueDate, "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.duedate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                            
                                                                                                                                <td >&nbsp;&nbsp;<input type="checkbox" name="overdue" value="1" <%if (overDue == 1) {%>checked<%}%>></td>
                                                                                                                                <td ><%=langBT[4]%></td>
                                                                                                                            </tr>       
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td ></td>                                                                                                                    
                                                                                                                    <td ><%=langBT[15]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="src_overdue" >
                                                                                                                            <option value = "0" <%if(overStatus == 0){%> selected<%}%> >All...</option>
                                                                                                                            <option value = "1" <%if(overStatus == 1){%> selected<%}%> >Overdue</option>
                                                                                                                            <option value = "2" <%if(overStatus == 2){%> selected<%}%> >Not Overdue</option>
                                                                                                                        </select>    
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" height="5"></td>
                                                                                                                </tr>                                                                                                                
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5" class="boxed1"> </td>
                                                                                        </tr>
                                                                                        <%if (privView) {%>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5" class="boxed1"> 
                                                                                            <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="15" class="boxed1"> </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5" class="boxed1"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" width="8%" height="19"><%=langBT[6]%></td>
                                                                                                        <td class="tablehdr" width="16%" height="19"><%=langBT[7]%></td>
                                                                                                        <td class="tablehdr" width="19%" height="19"><%=langBT[8]%></td>
                                                                                                        <td class="tablehdr" width="7%" height="19"><%=langBT[9]%></td>
                                                                                                        <td class="tablehdr" width="17%" height="19"><%=langBT[10]%></td>
                                                                                                        <td class="tablehdr" width="19%" height="19"><%=langBT[11]%></td>
                                                                                                        <td  class="tablehdr" width="14%" height="19"><%=langBT[12]%></td>
                                                                                                    </tr>
                                                                                                    <%
            if (listDatas != null && listDatas.size() > 0) {
                for (int i = 0; i < listDatas.size(); i++) {
                    Vector v = (Vector) listDatas.get(i);
                    Vendor vnd = (Vendor) v.get(0);
                    //Hashtable pendingOnePO = new Hashtable(); 
                    try{
                        //if(vnd.getPendingOnePo() == DbVendor.TYPE_ONE_PENDING_PO){
                            //pendingOnePO =  DbReceive.getOnePendingPO(invSrc,vnd .getOID());  
                        //}
                    }catch(Exception e){}
                    
                    Vector tempInv = (Vector) v.get(1);
                    boolean isPending = false;
                    
                    
                    
                                                                                                    %>
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="8%" height="20">&nbsp;</td>
                                                                                                        <td class="tablecell" width="16%" height="20"> 
                                                                                                            <div align="center"><a href="javascript:cmdPayment('<%=vnd.getOID()%>')"><b><%=vnd.getCode() + " - " + vnd.getName()%></b></a></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="19%" height="20">&nbsp;</td>
                                                                                                        <td class="tablecell" width="7%" height="20">&nbsp;</td>
                                                                                                        <td class="tablecell" width="17%" height="20">&nbsp;</td>
                                                                                                        <td class="tablecell" width="19%" height="20">&nbsp;</td>
                                                                                                        <td class="tablecell" width="14%" height="20">&nbsp;</td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <%
                                                                                                            if (tempInv != null && tempInv.size() > 0) {

                                                                                                                for (int ix = 0; ix < tempInv.size(); ix++) {
                                                                                                                    
                                                                                                                    Vector vx = (Vector) tempInv.get(ix);

                                                                                                                    Purchase pur = new Purchase();
                                                                                                                    Receive inv = (Receive) vx.get(1);

                                                                                                                    String cssClass = "tablecell1";

                                                                                                                    if (inv.getDueDate().before(new Date())) {
                                                                                                                        cssClass = "readonly";
                                                                                                                    }

                                                                                                                    if (inv.getPurchaseId() != 0) {
                                                                                                                        try {
                                                                                                                            pur = DbPurchase.fetchExc(inv.getPurchaseId());
                                                                                                                        } catch (Exception e) {
                                                                                                                            System.out.println("[exception] " + e.toString());
                                                                                                                        }
                                                                                                                    }
                                                                                                                    OnePendingPO onePendingPO = new OnePendingPO();
                                                                                                                    try{
                                                                                                                        //onePendingPO = (OnePendingPO)pendingOnePO.get(""+inv.getOID());
                                                                                                                    }catch(Exception e){}
                                                                                                                    
                                                                                                                    String number = "";
                                                                                                                    if(inv.getInvoiceNumber().length() > 0){
                                                                                                                        number = inv.getInvoiceNumber();
                                                                                                                    }else{
                                                                                                                        number = inv.getNumber();
                                                                                                                    }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="8%" bgcolor="#F2F2F2" class="<%=cssClass%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
                                                                                                                /*if(onePendingPO != null && onePendingPO.getReceiveId() > 0){                                                                                                                
                                                                                                                <b><font color="#FF0000">PENDING PO</font></b>                                                                                                                <%
                                                                                                                }else{ */                                                                                                                        
                                                                                                            if (inv.getDueDate().before(new Date())) {
                                                                                                                %>
                                                                                                                <b><font color="#FF0000">OVER DUE</font></b> 
                                                                                                                <%} //}%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="16%" > 
                                                                                                            <div align="center"><%=(inv.getPurchaseId() == 0) ? "DIRECT" : pur.getNumber() + "/" + JSPFormater.formatDate(pur.getPurchDate(), "dd-MM-yyyy")%></div>
                                                                                                        </td>
                                                                                                        <td width="19%" > 
                                                                                                            <div align="center"><%=number + "/" + JSPFormater.formatDate(inv.getApproval1Date(), "dd MMM yyyy")%></div>
                                                                                                        </td>
                                                                                                        <td width="7%"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
                                                                                                            Currency c = new Currency();
                                                                                                            try {
                                                                                                                c = DbCurrency.fetchExc(inv.getCurrencyId());
                                                                                                            } catch (Exception e) {
                                                                                                            }%>
                                                                                                            <%=c.getCurrencyCode()%></div>
                                                                                                        </td>                                                                                                                
                                                                                                        <td width="17%" > 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(DbReceive.getTotInvoice(inv.getOID()), "#,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td width="19%" > 
                                                                                                            <div align="right"> 
                                                                                                                <%
                                                                                                            double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoice(inv.getOID());
                                                                                                                %>
                                                                                                            <%=JSPFormater.formatNumber(balanceTotal, "#,###.##")%> </div>
                                                                                                        </td>
                                                                                                        <td width="14%" > 
                                                                                                            <div align="center"><%=JSPFormater.formatDate(inv.getDueDate(), "dd MMM yyyy")%></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" height="10"> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" background="../images/line1.gif" height="3"> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td  colspan="7" height="5"> </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%
                                                                                                        }%>
                                                                                                    <tr> 
                                                                                                        <td colspan="6" height="5">&nbsp;<b>
                                                                                                                <a href="javascript:cmdPayment('<%=0%>')">Pay Invoices For All Vendor</a> 
                                                                                                        </b></td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <%} else {
                                                                                                        if (iJSPCommand != JSPCommand.NONE) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" colspan="7" height="21"> 
                                                                                                            <div align="left">&nbsp;<font color="#000"><i><%=langBT[13]%></i></font></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" colspan="7" height="21"><i><%=langBT[14]%></i></td>
                                                                                                    </tr>
                                                                                                    <%}
            }
                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="5">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
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
