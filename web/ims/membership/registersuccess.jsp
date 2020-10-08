
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.net.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_PRINT);
%>
<%
//jsp content
            long memberId = JSPRequestValue.requestLong(request, "hidden_member_id");
            int typex = JSPRequestValue.requestInt(request, "typex");

            Member regMember = new Member();
            Produk produk = new Produk();
            try {
                regMember = DbMember.fetchExc(memberId);
                produk = DbProduk.fetchExc(regMember.getProdukId());
            } catch (Exception e) {
            }

            Vector temp = new Vector();
            if (session.getValue("ID_EGYSA") != null) {
                temp = (Vector) session.getValue("ID_EGYSA");
            }


%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="css/css.css" rel="stylesheet" type="text/css" />
        <link href="css/style.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body BGCOLOR=#000000 LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
        <table width="937" border="0" margintop="0" bottomargin="0" cellspacing="0" cellpadding="0" height="100%" align="center">
            <tr> 
                <td height="20"></td>
            </tr>
            <tr> 
                <td height="78"><!-- #BeginEditable "header" --> 
      <%@ include file="main/header.jsp"%>
                <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td height="120"><!-- #BeginEditable "hdisplay" --> 
      <%@ include file="main/display.jsp"%>
                <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td bgcolor="#FFFFFF" height="52" valign="bottom"> 
                    <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td height="8" width="731"></td>
                            <td width="208" background="<%=approot%>/images/head-bggreen.gif" height="8"></td>
                        </tr>
                    </table>
                    <!-- #BeginEditable "menu" --> 
      <%@ include file="main/menulogin.jsp"%>
                <!-- #EndEditable --> </td>
            </tr>
            <tr height="100%"> 
                <td height="100%"> 
                    <table width="100%%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="10" width="729" bgcolor="#FFFFFF" valign="top"> 
                                <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td class="container"><!-- #BeginEditable "content" --> 
                                            <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="container"> 
                                                        <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr> 
                                                                <td width="10" height="25">&nbsp;</td>
                                                                <td nowrap>&nbsp;</td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="10" height="25" bgcolor="#FF9900">&nbsp;</td>
                                                                <td nowrap><b><font size="3" color="#FF0000">&nbsp;Sukses 
                                                                <%if (typex == 0) {%>Registrasi Member Baru<%} else {%>Update Data Member<%}%></font></b></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td class="container"><font size="2">
                                                            <%

            String email = "Selamat bergabung dengan egysa.biz,\n\nDetail registrasi sebagai berikut :\n" +
                    "Tgl. Registrasi : " + JSPFormater.formatDate(regMember.getTglRegister(), "dd/MM/yyyy") + "\n" +
                    "Nama : " + regMember.getName() + "\n" +
                    "Login ID : " + regMember.getLoginId() + "\n" +
                    "Password : " + regMember.getPassword() + "\n" +
                    "Detail Produk : \n";

            if (typex == 0) {%>
                                                            Selamat, member berhasil didaftarkan, dengan nomor ID <br>
                                                            <%
                                                                if (temp.size() == 1) {
                                                                    try {
                                                                        Produk px = DbProduk.fetchExc(regMember.getProdukId());
                                                                        email = email + "    " + px.getName() + ", nomor : " + regMember.getMemberNumber();
                                                                    //out.println(px.getName()+", nomor : "+regMember.getMemberNumber());
                                                                    } catch (Exception e) {
                                                                    }

                                                                } else {
                                                                    for (int i = 0; i < temp.size(); i++) {
                                                                        Member memx = (Member) temp.get(i);
                                                                        try {
                                                                            Produk px = DbProduk.fetchExc(memx.getProdukId());
                                                                            email = email + "    ID Egysa : " + memx.getLoginId() + ", " + px.getName() + ", nomor : " + memx.getMemberNumber() + "\n";
                                                                        } catch (Exception e) {
                                                                        }

                                                                        //Vector xTemp = (Vector)temp.get(i);
                                                                        //String num = (String)xTemp.get(0);
                                                                        //String id = (String)xTemp.get(1);							
                                                                        //email = email + "ID :"+id.toUpperCase()+" - produk nomor : "+num+"\n";							
%> 
                                                            <b><%=memx.getLoginId().toUpperCase() + " - " + memx.getMemberNumber() + ", "%></b>
                                                            <%}
                                                                }

                                                                email = email + "\n\nTerimakasih,\nManagement Egysa";
                                                            %>
                                                            
                                                            <%} else {%>
                                                            Member <b><%=regMember.getLoginId()%></b> berhasil diupdate.
                                                            <%}%>
                                                            <br>
                                                            Perubahan posisi member baru masih diijinkan sampai dengan 
                                                            tengah malam hari ini.<br>
                                                            <br>
                                                            <a href="level.jsp?hidden_member_id=<%=loginMember.getOID()%>&idx=<%=System.currentTimeMillis()%>"><b>Lihat 
                                                    Jaringan</b></a> </font></td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <%
            try {
                MailSenderModif ms = new MailSenderModif();
                ms.setSMTPHost("localhost");
                ms.setSenderAddr("info@egysa.biz");
                ms.setSender("egysa.biz");
                ms.setReceiver(regMember.getEmail());
                ms.setSubject("Egysa - konfirmasi pendaftaran");
                ms.setMessage(email);
                ms.sendMail();

            } catch (Exception e) {
                System.out.println("exception email : " + e.toString());
            }

            try {
                MailSenderModif ms = new MailSenderModif();
                ms.setSMTPHost("localhost");
                ms.setSenderAddr("info@egysa.biz");
                ms.setSender("egysa.biz");
                ms.setReceiver("ekads3007@gmail.com");
                ms.setSubject("Egysa - Pendaftaran Baru");
                ms.setMessage(email);
                ms.sendMail();

            //out.println("in success sending email");

            } catch (Exception e) {
                System.out.println("exception email : " + e.toString());
            }

                                                %>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        <!-- #EndEditable --></td>
                                    </tr>
                                </table>
                            </td>
                            <td width="208" background="<%=approot%>/images/head-bggreen.gif" height="10" valign="top"> 
                                <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td class="container"><!-- #BeginEditable "menuleft" --> 
                  <%@ include file="main/menuleft.jsp"%>
                                        <!-- #EndEditable --></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr> 
                <td height="13" valign="top"> 
                    <table width="100%%" height="13" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td width="11" height="13" background="<%=approot%>/images/left-corner.gif"></td>
                            <td width="713" height="13" background="<%=approot%>/images/bg-bottom.gif"></td>
                            <td width="10" height="13" background="<%=approot%>/images/right-corner.gif"></td>
                            <td  width="208" height="13" background="<%=approot%>/images/head-bggreen.gif"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr> 
                <td background="<%=approot%>/images/head-bggreen.gif"><!-- #BeginEditable "footer" --> 
      <%@ include file="main/footer.jsp"%>
                <!-- #EndEditable --></td>
            </tr>
            <tr height="12"> 
                <td height="12"> 
                    <table width="100%%" height="12" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td background="<%=approot%>/images/bottom-left.gif" width="12"></td>
                            <td background="<%=approot%>/images/head-bggreen.gif" width="970"></td>
                            <td background="<%=approot%>/images/bottom-right.gif" width="13"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr> 
                <td height="20"></td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>
