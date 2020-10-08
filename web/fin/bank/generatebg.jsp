
<%-- 
    Document   : generatebg
    Created on : Mar 30, 2016, 2:33:22 PM
    Author     : Roy
--%>

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
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG, AppMenu.PRIV_DELETE);
%>
<%!
    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        int level = 0;
        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    String str = "";
                    if (!isPostableOnly) {
                        level = coax.getLevel() + minus;
                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }
                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";
                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }

%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            int tipeTransaksi = JSPRequestValue.requestInt(request, "tipe_transaksi");
            long rekening = JSPRequestValue.requestLong(request, "rekening");
            String prefix = JSPRequestValue.requestString(request, "prefix");
            String number = JSPRequestValue.requestString(request, "number");
            int jumlahLembar = JSPRequestValue.requestInt(request, "jumlah_lembar");

            int vectSize = 0;

            String[] langCT = {"Transaction Type", "Rekening", "Number of Sheets", "Prefix", "Number", "Data required", "Chose Rekening",//0-6
                "Rekening Data, Number and Number of Sheets Must Entry"};

            String[] langNav = {"Bank Transaction", "Generate BG/Check Number"};

            if (lang == LANG_ID) {
                String[] langID = {"Tipe Transaksi", "Rekening", "Jumlah Lembar", "Prefix", "Number", "Data harus diisi", "Pilih Rekening", //0-6
                    "Data Rekening, Number dan Jumlah Lembaran Harus diisi"};
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Generate BG/Check Number"};
                langNav = navID;
            }

            Vector accBgLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_ACCOUNT_REKENING_BG + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");



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
            
            function cmdSearch(){
                document.frmbankarchive.command.value="<%=JSPCommand.SEARCH%>";    
                document.frmbankarchive.action="generatebg.jsp";
                document.frmbankarchive.submit();
            }
            
            function cmdGenerate(){
                document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";    
                document.frmbankarchive.action="generatebg.jsp";
                document.frmbankarchive.submit();
            }    
            
            function cmdToArsip(){                                
                document.frmbankarchive.menu_idx.value=<%=menuIdx%>;                
                document.frmbankarchive.command.value="<%=JSPCommand.NONE%>";                
                document.frmbankarchive.action="masterbgcheck.jsp";
                document.frmbankarchive.submit();
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
                                                    <td class="container"><!-- #BeginEditable "content" --> 
                                                        <form name="frmbankarchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top">
                                                                    <td colspan="3" >
                                                                        <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                            <tr > 
                                                                                <td class="tabheader" width="5"><img src="<%=approot%>/images/spacer.gif" width="5" height="10"></td>
                                                                                <td class="tab" width="80" align="center">Generate</td>
                                                                                <td class="tabheader" width="17"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                <td class="tabin" width="120" class="fontarial">
                                                                                    <div align="center"><a href="javascript:cmdToArsip()" class="tablink">&nbsp;&nbsp;&nbsp;Arsip&nbsp;&nbsp;&nbsp;</a></div>
                                                                                </td>
                                                                                <td class="tabheader" width="100%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>                                                                                              
                                                                                
                                                                            </tr>
                                                                        </table>
                                                                    </td>    
                                                                </tr>    
                                                                <tr align="left" valign="top">
                                                                    <td colspan="3" class="command">
                                                                        <table border="0" cellpadding="1" cellspacing="2">                                                                            
                                                                            <tr>
                                                                                <td colspan="3" height="10"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"></td>
                                                                                <td></td>
                                                                                <td class="fontarial" style="padding:3px;"><i>*) <%=langCT[5]%></i></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="5"></td>
                                                                            </tr>                                                                                
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"><%=langCT[0]%></td>
                                                                                <td>:</td>
                                                                                <td>
                                                                                    <select name="tipe_transaksi" class="fontarial">                                                                                        
                                                                                        <option value="<%=DbBgMaster.TYPE_BG%>" <%if (tipeTransaksi == DbBgMaster.TYPE_BG) {%> selected<%}%> >BG</option>
                                                                                        <option value="<%=DbBgMaster.TYPE_CHECK%>" <%if (tipeTransaksi == DbBgMaster.TYPE_CHECK) {%> selected<%}%> >Check</option>
                                                                                    </select>    
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"><%=langCT[1]%> <b>*</b></td>
                                                                                <td>:</td>
                                                                                <td>
                                                                                    <select name="rekening" >
                                                                                        <option value="0" >- <%=langCT[6]%> -</option>
                                                                                        <%
            if (accBgLinks != null && accBgLinks.size() > 0) {
                for (int i = 0; i < accBgLinks.size(); i++) {

                    AccLink accLink = (AccLink) accBgLinks.get(i);
                    Coa coa = new Coa();

                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                        System.out.println("[exception]" + e.toString());
                    }
                                                                                        %>
                                                                                        <option <%if (rekening == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                        <%=getAccountRecursif(coa.getLevel() * -1, coa, rekening, isPostableOnly)%> 
                                                                                        <%}
                                                                                        } else {%>
                                                                                        <option>- <%=langCT[6]%> -</option>
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"><%=langCT[3]%></td>
                                                                                <td>:</td>
                                                                                <td><input type="text" name="prefix" value="<%=prefix%>" size="10" class="fontarial"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"><%=langCT[4]%> <b>*</b></td>
                                                                                <td>:</td>
                                                                                <td><input type="text" name="number" value="<%=number%>" size="20" class="fontarial"></td>                                                                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="100" class="fontarial" style="padding:3px;"><%=langCT[2]%> <b>*</b></td>
                                                                                <td>:</td>
                                                                                <td><input type="text" name="jumlah_lembar" value="<%=jumlahLembar%>" size="10" class="fontarial"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="20"><a href="javascript:cmdSearch()"><img src="../images/success.gif" border="0"></a></td>                                                                                            
                                                                                            <td class="fontarial"><a href="javascript:cmdSearch()"><i>Priview</i></a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr>  
                                                                <%
            if (iCommand == JSPCommand.SEARCH || iCommand == JSPCommand.SUBMIT) {
                if (rekening != 0 && number != null && number.length() > 0 && jumlahLembar > 0) {
                                                                %>
                                                                <tr>
                                                                    <td>
                                                                        <table>
                                                                            <tr height="24">
                                                                                <td class="tablearialhdr" width="25" style="padding:3px;">No</td>
                                                                                <td class="tablearialhdr" width="350" style="padding:3px;"><%=langCT[1]%></td>
                                                                                <td class="tablearialhdr" width="150" style="padding:3px;"><%=langCT[4]%></td>                                                                                
                                                                                <td class="tablearialhdr" width="120" style="padding:3px;">Status</td>     
                                                                            </tr>
                                                                            <%

                                                                        Coa c = new Coa();
                                                                        if (rekening != 0) {
                                                                            try {
                                                                                c = DbCoa.fetchExc(rekening);
                                                                            } catch (Exception e) {
                                                                            }
                                                                        }

                                                                        int numberStart = 0;
                                                                        try {
                                                                            numberStart = Integer.parseInt(number.trim());
                                                                        } catch (Exception e) {
                                                                        }
                                                                        int length = number.length();


                                                                        for (int i = 0; i < jumlahLembar; i++) {
                                                                            String cssString = "tablecell";
                                                                            if (i % 2 != 0) {
                                                                                cssString = "tablecell1";
                                                                            }
                                                                            String strRek = String.valueOf(numberStart);
                                                                            if (strRek.length() < length) {
                                                                                String strPrefix = "";

                                                                                for (int x = 0; x < (length - strRek.length()); x++) {
                                                                                    strPrefix = strPrefix + "0";
                                                                                }
                                                                                strRek = strPrefix + strRek;
                                                                            }

                                                                            String where = DbBgMaster.colNames[DbBgMaster.COL_COA_ID] + " = " + c.getOID() + " and " + DbBgMaster.colNames[DbBgMaster.COL_NUMBER] + " = '" + prefix + "" + strRek + "'";
                                                                            int count = DbBgMaster.getCount(where);
                                                                            long oid = 0;
                                                                            int intStatus = 0;
                                                                            if (iCommand == JSPCommand.SUBMIT) {
                                                                                if (count > 0) {
                                                                                    intStatus = 1;//"Data Sudah Ada";   
                                                                                } else {
                                                                                    BgMaster bgMaster = new BgMaster();
                                                                                    bgMaster.setNumber(prefix + "" + strRek);
                                                                                    bgMaster.setCoaId(c.getOID());
                                                                                    bgMaster.setCreateDate(new Date());
                                                                                    bgMaster.setUserId(user.getOID());
                                                                                    bgMaster.setType(tipeTransaksi);
                                                                                    try {
                                                                                        oid = DbBgMaster.insertExc(bgMaster);
                                                                                    } catch (Exception e) {
                                                                                    }
                                                                                    if (oid != 0) {
                                                                                        intStatus = 2;//Sukses
                                                                                    } else {
                                                                                        intStatus = -1; //"Faild";
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                if (count > 0) {
                                                                                    intStatus = 1;//"Data Sudah Ada";
                                                                                }
                                                                            }




                                                                            %>
                                                                            <tr>
                                                                                <td class="<%=cssString%>" align="center" style="padding:3px;"><%=(i + 1)%></td>
                                                                                <td class="<%=cssString%>" style="padding:3px;"><%=c.getCode()%>-<%=c.getName()%></td>
                                                                                <td class="<%=cssString%>" style="padding:3px;"><%=prefix%><%=strRek%></td>  
                                                                                <%if (intStatus == 0) {%>
                                                                                <td class="<%=cssString%>" style="padding:3px;" align="center"><i>-</i></td>                                                                                
                                                                                <%} else if (intStatus == 2) {%>
                                                                                <td class="<%=cssString%>" style="padding:3px;" align="center"><i>Sukses</i></td>                                                                                
                                                                                <%} else {
    String sts = "";
    if (intStatus == -1) {
        sts = "Failed";
    } else {
        sts = "Data sudah ada";
    }
                                                                                %>
                                                                                <td class="<%=cssString%>" style="padding:3px;" align="center"><font color="#FF0000"><i><%=sts%></i></font></td>                                                                                
                                                                                <%}%>
                                                                            </tr>
                                                                            <%
                                                                            numberStart++;
                                                                        }%>
                                                                        </table>
                                                                    </td>
                                                                </tr>   
                                                                <tr>
                                                                    <td colspan="3">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td width="20"><a href="javascript:cmdGenerate()"><img src="../images/success.gif" border="0"></a></td>                                                                                            
                                                                                <td class="fontarial"><a href="javascript:cmdGenerate()"><i>Generate</i></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%} else {%>
                                                                <tr>
                                                                    <td colspan="3" class="fontarial"><i><%=langCT[7]%></i></td>
                                                                </tr>
                                                                <%}%>
                                                                <%}%>
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
