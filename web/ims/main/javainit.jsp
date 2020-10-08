<%@ page import="com.project.system.*"%>
<%@ page import="com.project.general.Currency"%>
<%@ page import="com.project.general.DbCurrency"%>
<%@ page import="com.project.general.*"%>
<%@ page import="com.project.*"%>
<%@ page import="com.project.main.db.*"%>
<%@ include file="../../javainit-root.jsp"%>
<%
            String approot = rootapproot + "/ims";
            String imageroot = rootimageroot + "/ims/";
            String printroot = rootprintroot + "/servlet/com.project.ccs";
            String printroot2 = rootprintroot2 + "/servlet/com.project.crm";
            String approotx = rootapprootx + "";

            String strForeignCurrencyDefault = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");

            int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");

            String IDRCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
            String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
            String EURCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_EUR");

            String installProdOnly = DbSystemProperty.getValueByName("CRM_INSTALL_PRODUCT_ONLY");
            boolean CRM_INSTALL_PRODUCT_ONLY = (installProdOnly.equals("Y")) ? true : false;
%>
<script language=JavaScript src="<%=approot%>/main/common.js"></script>
<script language="JavaScript">
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