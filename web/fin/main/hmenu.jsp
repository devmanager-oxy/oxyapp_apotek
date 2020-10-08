<script language=JavaScript src="<%=approot%>/main/common.js"></script>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0" >       
    <tr>
        <td >
            <table width="100%" border="0" cellpadding="2" cellspacing="0" >
                <tr height="22" bgcolor="#3A2C2C">                                                           
                    <td colspan="2" align="right" class="headertitle-subcompany"><%=user.getFullName()%> , Login : <%=JSPFormater.formatDate(user.getLastLoginDate(), "dd MMM yyyy HH:mm:ss")%></td>   
                </tr>
                <tr height="22" bgcolor="#336F06">                                       
                    <td align="left" class="headertitle-subcompany"><a href="javascript:cmdEnterApp(2)" title="Inventory Management System">Inventory</a> | <a href="javascript:cmdEnterApp(3)" title="Saless">Sales</a> | Finance</td>   
                    <td width="300" align="right" class="headertitle-subcompany"><a href="<%=approot%>/updatepwd.jsp">Change Password</a>| <a href="<%=approot%>/logout.jsp">Logout</a>&nbsp;</td>   
                </tr>
            </table>
            
        </td>
    </tr> 
    <tr> 
        <td  >
            <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
                <tr>
                    <td height="50" width="50%"  rowspan="2" bgcolor="#336F06" class="headertitle-company">&nbsp;F i n a n c e</td>
                    <td class="headertitle" bgcolor="#336F06" align="right"><%=sysCompany.getName()%>&nbsp;&nbsp;</td>
                </tr>    
                <tr>                    
                    <td bgcolor="#336F06" class="subtitle" align="right"><%=sysCompany.getAddress().toUpperCase()%>&nbsp;&nbsp;</td>
                </tr> 
            </table>
        </td>
    </tr> 
    <tr> 
        <td bgcolor="#336F06" height="5"></td>
    </tr>
    <tr> 
        <td bgcolor="#D4391A" height="2"></td>
    </tr>  
    <%if (false) {%>
    <tr>
        <td height="20" ></td>
    </tr>
    <tr> 
        <td class="header" >
            <div class="headerleft">
                <div class="headertitle"><%=systemTitle.toUpperCase()%></div>
                <div class="headermenu" >                
                    <a href="javascript:cmdEnterApp(2)" title="Inventory Management System">IMS</a>               
                    <a href="javascript:cmdEnterApp(3)" title="Sales Management System">SMS</a> 
                    <font color="#FF9900">FMS</font>
                </div>
            </div>
            <div class="headerright">
                <div class="headertitle"><%=sysCompany.getName()%></div>
                <div class="subtitle"><%=sysCompany.getAddress().toUpperCase()%></div>
            </div>
        </td>
    </tr>
    <tr>
        <td height="5" class="header"></td>
    </tr>
    <tr> 
        <td height="1"></td>
    </tr>
    <tr> 
        <td bgcolor="#84C754" height="6"></td>
    </tr>   
    <%}%>
    <script language="JavaScript">
        function cmdEnterApp(idx){
            if(parseInt(idx)==1){
                window.location="<%=approotx%>/fin/home.jsp?command=1";
            }
            if(parseInt(idx)==2){
                window.location="<%=approotx%>/ims/home.jsp?command=1";
            }
            if(parseInt(idx)==3){
                window.location="<%=approotx%>/sales/homesl.jsp?command=1";
            }
            if(parseInt(idx)==4){
                window.location="<%=approotx%>/simprop/homesl.jsp?command=1";
            }
            if(parseInt(idx)==5){
                window.location="<%=approotx%>/rental/home.jsp?command=1";
            }
        }
    </script>
</table>