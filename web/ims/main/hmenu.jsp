<script language="JavaScript"> 
    <!--
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td rowspan="2"><img src="<%=approot%>/images/logo-finance1.jpg" width="216" height="144" /></td>
                    <td><img src="<%=approot%>/images/logotxt-finance.gif" width="343" height="94" /></td>    
                </tr>
                <tr> 
                    <td style="background:url(<%=approot%>/images/head-line.gif) repeat-x"><img src="<%=approot%>/images/head-corner.gif" width="119" height="50" /></td>
                </tr>
            </table>
        </td>
        <td width="100%" valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                <tr> 
                    <td valign="top" style="background:url(<%=approot%>/images/head-bg.gif) repeat-x"> 
                        <table border="0" align="right" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td height="31" align="right" valign="top" >&nbsp;</td>
                                <td rowspan="2" height="74" valign="middle"><BR><BR>
                                    <%
            String nmcmpxxxxx = "";
            Vector vcmpxx = DbCompany.listAll();
            if (vcmpxx != null && vcmpxx.size() > 0) {
                Company cmpxxx = (Company) vcmpxx.get(0);
                nmcmpxxxxx = cmpxxx.getName();
            }
                                    %>
                                    <B><font face="Berlin Sans FB Demi" size="4" color="#2f5611"><%=nmcmpxxxxx%></font></B>&nbsp;&nbsp;
                                </td><td rowspan="2">&nbsp;</td>
                            </tr>
                            <tr><td align="right" valign="top" >&nbsp;</td></tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td style="background:url(<%=approot%>/images/head-icon-bg.gif) repeat-x">
                        <script language="JavaScript">
                            function cmdEnterApp(idx){                                
                                
                                if(parseInt(idx)==2){
                                    window.location="<%=approotx%>/ims/home.jsp?command=1";
                                }
                                if(parseInt(idx)==3){
                                    window.location="<%=approotx%>/ims/indexconsigment.jsp?command=1";
                                }
                                if(parseInt(idx)==4){
                                    window.location="<%=approotx%>/ims/indexservice.jsp?command=1";
                                }
                                if(parseInt(idx)==5){
                                    window.location="<%=approotx%>/sales/homesl.jsp?command=1";
                                }
                                if(parseInt(idx)==6){
                                    window.location="<%=approotx%>/fin/home.jsp?command=1&lang=2&menu_idx=1";
                                }
                            }
                        </script>
                        <table border="0" align="right" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td><img src="<%=approot%>/images/button-inventory2.gif" width="50" height="45" /></td>
                                <td>&nbsp;</td>                 
                                <td><a href="javascript:cmdEnterApp(5)" title="Sales"><img src="<%=approot%>/images/button-simpan.gif" width="50" height="45" border="0" /></a></td>
                                <td>&nbsp;</td>
                                <td><a href="javascript:cmdEnterApp(6)" title="Finance"><img src="<%=approot%>/images/button-finance.gif" width="50" height="45" border="0" /></a></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>