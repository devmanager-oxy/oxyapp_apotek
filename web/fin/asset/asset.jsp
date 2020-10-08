
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.asset.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long itemMasterId = JSPRequestValue.requestLong(request, "item_master_id");
            long assetDataId = JSPRequestValue.requestLong(request, "asset_data_id");
            long stockId = JSPRequestValue.requestLong(request, "stock_id");

            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            CmdAssetData ctrlAssetData = new CmdAssetData(request);

            /*switch statement */
            iErrCode = ctrlAssetData.action(iJSPCommand, assetDataId, stockId);
            msgString = ctrlAssetData.getMessage();
            JspAssetData jspAssetData = ctrlAssetData.getForm();
            AssetData assetDataObj = ctrlAssetData.getAssetData();

//out.println("iErrCode : "+iErrCode);
//out.println("jspAssetData : "+jspAssetData.getErrors());

            ItemMaster itemMaster = new ItemMaster();
            try {
                itemMaster = DbItemMaster.fetchExc(itemMasterId);
            } catch (Exception e) {
            }

            Vector assetList = DbStock.getAssetList();
            Vector coaFixedAsset = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_FIXED_ASSET + "'", "");
            Vector coaExpense = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_EXPENSE + "'", "");

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        <%if (iJSPCommand == JSPCommand.EDIT || iErrCode != 0) {%>
        window.location="#go";
        <%}%>
        
        var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
        var usrDigitGroup = "<%=sUserDigitGroup%>";
        var usrDecSymbol = "<%=sUserDecimalSymbol%>";
        
        function removeChar(number){
            
            var ix;
            var result = "";
            for(ix=0; ix<number.length; ix++){
                var xx = number.charAt(ix);
                //alert(xx);
                if(!isNaN(xx)){
                    result = result + xx;
                }
                else{
                    if(xx==',' || xx=='.'){
                        result = result + xx;
                    }
                }
            }
            
            return result;
        }
        
        function checkNumber(obj){
            var st = obj.value;
            
            result = removeChar(st);
            
            result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        }
        <!--
        function cmdSave(oid, oidAsset, stockId){
            document.form1.item_master_id.value=oid;
            document.form1.asset_data_id.value=oidAsset;
            document.form1.stock_id.value=stockId;
            document.form1.command.value="<%=JSPCommand.SAVE%>";
            document.form1.action="asset.jsp";
            document.form1.submit();
        }
        
        function cmdCancel(){
            document.form1.item_master_id.value="0";
            document.form1.asset_data_id.value="0";
            document.form1.command.value="<%=JSPCommand.BACK%>";
            document.form1.action="asset.jsp";
            document.form1.submit();
        }
        
        
        function cmdEdit(oid, oidStock){
            document.form1.item_master_id.value=oid;
            document.form1.stock_id.value=oidStock;
            document.form1.command.value="<%=JSPCommand.EDIT%>";
            document.form1.action="asset.jsp";
            document.form1.submit();
        }
        
        
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/save2.gif','../images/back2.gif')">
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
            String navigator = "<font class=\"lvl1\">Asset Management</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Asset List</span></font>";
                                           %>
                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                </tr>
                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                </tr-->
                <tr> 
                    <td><!-- #BeginEditable "content" --> 
                    <form id="form1" name="form1" method="post" action="">
                    <input type="hidden" name="command">
                    <input type="hidden" name="item_master_id" value="<%=itemMasterId%>">
                    <input type="hidden" name="asset_data_id" value="<%=assetDataId%>">
                    <input type="hidden" name="stock_id" value="<%=stockId%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_ITEM_MASTER_ID]%>" value="<%=itemMaster.getOID()%>">
                    <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_USER_ID]%>" value="<%=user.getOID()%>">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="container">&nbsp;</td>
                        </tr>
                        <tr> 
                            <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                        <td class="tablehdr" width="7%"><font size="1">NOMOR 
                                        INVENTARIS</font></td>
                                        <td class="tablehdr" width="15%"><font size="1">AKTIVA</font></td>
                                        <td class="tablehdr" width="4%"> 
                                            <p><font size="1">DLM<br>
                                                    PRO<br>
                                                    SEN<br>
                                            TASE</font></p>
                                        </td>
                                        <td class="tablehdr" width="4%"> 
                                            <p><font size="1">JML/<br>
                                                    UNIT/<br>
                                                    BH/<br>
                                            SET</font></p>
                                        </td>
                                        <td class="tablehdr" width="5%"><font size="1">TAHUN 
                                                <br>
                                                PERO<br>
                                        LEHAN</font></td>
                                        <td class="tablehdr" width="7%"><font size="1">BLN 
                                                MULAI<br>
                                                DEPRE<br>
                                        SIASI</font></td>
                                        <td class="tablehdr" width="7%"><font size="1">NILAI 
                                        PEROLEHAN</font></td>
                                        <td class="tablehdr" width="6%"><font size="1">RESIDU</font></td>
                                        <td class="tablehdr" width="7%"><font size="1">JML<br>
                                                DEPRESIASI <br>
                                        /THN</font></td>
                                        <td class="tablehdr" width="7%"><font size="1">JML<br>
                                                DEPRESIASI <br>
                                        /BLN</font></td>
                                        <td class="tablehdr" width="5%"><font size="1">TOTAL<br>
                                                DEPRESIASI<br>
                                        SEBELUMNYA</font></td>
                                        <td class="tablehdr" width="5%"><font size="1">TGL<br>
                                                DEPRE<br>
                                        TERAKHIR</font> </td>
                                        <td class="tablehdr" width="13%"><font size="1">COA 
                                        ACCUM. DEP.</font></td>
                                        <td class="tablehdr" width="13%"><font size="1">COA 
                                        DEP. EXPENSE</font></td>
                                    </tr>
                                    <%

            long groupId = 0;
            long locationId = 0;

            if (assetList != null && assetList.size() > 0) {

                for (int i = 0; i < assetList.size(); i++) {
                    Vector v = (Vector) assetList.get(i);

                    ItemGroup ig = (ItemGroup) v.get(0);
                    ItemMaster im = (ItemMaster) v.get(1);
                    Location loc = (Location) v.get(2);
                    Stock s = (Stock) v.get(3);

                    AssetData assetData = new AssetData();
                    Vector ads = DbAssetData.list(0, 0, "item_master_id=" + im.getOID(), "");
                    boolean isEditable = true;
                    if (ads != null && ads.size() > 0) {
                        assetData = (AssetData) ads.get(0);
                        int cnt = DbAssetDataDepresiasi.getCount("asset_data_id=" + assetData.getOID());
                        if (cnt > 0) {
                            isEditable = false;
                        }
                    }

                    Coa akumDep = new Coa();
                    Coa expDep = new Coa();
                    try {
                        akumDep = DbCoa.fetchExc(assetData.getCoaAkumDepId());
                    } catch (Exception e) {
                    }
                    try {
                        expDep = DbCoa.fetchExc(assetData.getCoaExpenseDepId());
                    } catch (Exception e) {
                    }


                    if (s.getQty() > 0) {

                        if (groupId != ig.getOID()) {
                            groupId = ig.getOID();
                            locationId = loc.getOID();
                                    %>
                                    <tr> 
                                        <td colspan="14">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td colspan="14"><b><%=ig.getName().toUpperCase()%></b></td>
                                    </tr>
                                    <tr> 
                                        <td colspan="14" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                    </tr>
                                    <%
                                                              //edit
                                                              if ((iJSPCommand == JSPCommand.EDIT && im.getOID() == itemMasterId) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0 && im.getOID() == itemMasterId)) {

                                                                  if (iJSPCommand == JSPCommand.SAVE) {
                                                                      assetData = assetDataObj;
                                                                  }

                                    %>
                                    <tr> 
                                        <td width="7%" class="tablecell1" height="33" nowrap valign="bottom"><b><i>EDITOR 
                                        DATA</i></b></td>
                                        <td width="15%" class="tablecell1" height="33" valign="top"><a name="go"></a></td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="6%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1">
                                        <font size="1"><%=im.getCode()%></font></td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_DEPRESIASI_PERCENT]%>" size="4" value="<%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            %<%= jspAssetData.getErrorMsg(JspAssetData.JSP_DEPRESIASI_PERCENT) %></font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>" value="<%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%>" size="9" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <select name="<%=JspAssetData.colNames[JspAssetData.JSP_BULAN_MULAI_DEPRESIASI]%>">
                                                        <%for (int x = 0; x < I_Project.shortMonths.length; x++) {%>
                                                        <option value="<%=x%>" <%if (assetData.getBulanMulaiDepresiasi() == x) {%>selected<%}%>><%=I_Project.shortMonths[x]%></option>
                                                        <%}%>
                                                    </select>
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="textfield22" size="10" value="<%=(s.getQty() * im.getCogs() == 0) ? "" : JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_RESIDU]%>" size="10" value="<%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%>" style="text-align:right"  onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield3" size="10" value="<%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield4" size="10" value="<%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_TOTAL_DEPRE_SEBELUM]%>" size="10" value="<%=(assetData.getTotalDepreSebelum() == 0) ? "" : "" + assetData.getTotalDepreSebelum()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>" value="<%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() == null) ? new Date() : assetData.getTglDepreTerakhir(), "dd/MM/yyyy")%>" size="9" readonly>
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_AKUM_DEP_ID]%>">
                                                    <%if (coaFixedAsset != null && coaFixedAsset.size() > 0) {
                                            for (int x = 0; x < coaFixedAsset.size(); x++) {
                                                Coa coa = (Coa) coaFixedAsset.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                    %>
                                                    <option value="<%=coa.getOID()%>" <%if (akumDep.getOID() == coa.getOID()) {%>selected<%}%>><%=str + coa.getCode() + "/" + coa.getName()%></option>
                                                    <%}
                                        }%>
                                                </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_AKUM_DEP_ID) %> </font></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_EXPENSE_DEP_ID]%>">
                                                <%if (coaExpense != null && coaExpense.size() > 0) {
                                            for (int x = 0; x < coaExpense.size(); x++) {
                                                Coa coa = (Coa) coaExpense.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                %>
                                            <option value="<%=coa.getOID()%>" <%if (expDep.getOID() == coa.getOID()) {%>selected<%}%>><font size="1"><%=str + coa.getCode() + "/" + coa.getName()%></font></option>
                                            <%}
                                        }%>
                                            </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_EXPENSE_DEP_ID) %> </font></td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1"></td>
                                        <td width="15%" class="tablecell1">&nbsp;</td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="5%" class="tablecell1" nowrap>&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="6%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="13%" class="tablecell1"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="60"><a href="javascript:cmdSave('<%=im.getOID()%>','<%=assetData.getOID()%>','<%=s.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a></td>
                                                    <td width="1%"><img src="../images/spacer.gif" width="10" height="1"></td>
                                                    <td width="100%"><a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/back2.gif',1)"><img src="../images/back.gif" name="new21" border="0"></a></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="13%" class="tablecell1">&nbsp;</td>
                                    </tr>
                                    <%} //preview
                                    else {%>
                                    <tr> 
                                        <td width="7%" class="tablecell1">
                                            <%if (isEditable) {%>
                                            <a href="javascript:cmdEdit('<%=im.getOID()%>')"><font size="1"><%=im.getCode()%></font></a>
                                            <%} else {%>
                                            <font size="1"><%=im.getCode()%></font>
                                            <%}%>
                                        </td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>%</font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getOID() == 0) ? "" : I_Project.shortMonths[assetData.getBulanMulaiDepresiasi()]%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%></font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getTotalDepreSebelum() == 0) ? "" : JSPFormater.formatNumber(assetData.getTotalDepreSebelum(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1">
                                                    <%if (assetData.getOID() != 0) {%>
                                                    <%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() != null) ? assetData.getTglDepreTerakhir() : s.getDate(), "dd/MM/yyyy")%>
                                                    <%}%>
                                            </font></div>
                                        </td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(akumDep.getOID() == 0) ? "" : akumDep.getCode() + "/" + akumDep.getName()%></font></td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(expDep.getOID() == 0) ? "" : expDep.getCode() + "/" + expDep.getName()%></font></td>
                                    </tr>
                                    <%
                                                              }
                                                          }//end if group beda
                                                          else {
                                                              //jika lokasi beda
                                                              if (locationId != loc.getOID()) {
                                                                  locationId = loc.getOID();
                                    %>
                                    <tr> 
                                        <td colspan="14" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                    </tr>
                                    
                                    <%
                                        //edit
                                        if ((iJSPCommand == JSPCommand.EDIT && im.getOID() == itemMasterId) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0 && im.getOID() == itemMasterId)) {

                                            if (iJSPCommand == JSPCommand.SAVE) {
                                                assetData = assetDataObj;
                                            }

                                    %>
                                    <tr> 
                                        <td width="7%" class="tablecell1" height="33" nowrap valign="bottom"><b><i>EDITOR 
                                        DATA</i></b></td>
                                        <td width="15%" class="tablecell1" height="33" valign="top"><a name="go"></a></td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="6%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1"><font size="1"><%=im.getCode()%></font></td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_DEPRESIASI_PERCENT]%>" size="4" value="<%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            %<%= jspAssetData.getErrorMsg(JspAssetData.JSP_DEPRESIASI_PERCENT) %></font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>" value="<%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%>" size="9" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <select name="<%=JspAssetData.colNames[JspAssetData.JSP_BULAN_MULAI_DEPRESIASI]%>">
                                                        <%for (int x = 0; x < I_Project.shortMonths.length; x++) {%>
                                                        <option value="<%=x%>" <%if (assetData.getBulanMulaiDepresiasi() == x) {%>selected<%}%>><%=I_Project.shortMonths[x]%></option>
                                                        <%}%>
                                                    </select>
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="textfield22" size="10" value="<%=(s.getQty() * im.getCogs() == 0) ? "" : JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_RESIDU]%>" size="10" value="<%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%>" style="text-align:right"  onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield3" size="10" value="<%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield4" size="10" value="<%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_TOTAL_DEPRE_SEBELUM]%>" size="10" value="<%=(assetData.getTotalDepreSebelum() == 0) ? "" : "" + assetData.getTotalDepreSebelum()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>" value="<%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() == null) ? new Date() : assetData.getTglDepreTerakhir(), "dd/MM/yyyy")%>" size="9" readonly>
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_AKUM_DEP_ID]%>">
                                                    <%if (coaFixedAsset != null && coaFixedAsset.size() > 0) {
                                            for (int x = 0; x < coaFixedAsset.size(); x++) {
                                                Coa coa = (Coa) coaFixedAsset.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                    %>
                                                    <option value="<%=coa.getOID()%>" <%if (akumDep.getOID() == coa.getOID()) {%>selected<%}%>><%=str + coa.getCode() + "/" + coa.getName()%></option>
                                                    <%}
                                        }%>
                                                </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_AKUM_DEP_ID) %> </font></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_EXPENSE_DEP_ID]%>">
                                                <%if (coaExpense != null && coaExpense.size() > 0) {
                                            for (int x = 0; x < coaExpense.size(); x++) {
                                                Coa coa = (Coa) coaExpense.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                %>
                                            <option value="<%=coa.getOID()%>" <%if (expDep.getOID() == coa.getOID()) {%>selected<%}%>><font size="1"><%=str + coa.getCode() + "/" + coa.getName()%></font></option>
                                            <%}
                                        }%>
                                            </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_EXPENSE_DEP_ID) %> </font></td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1"></td>
                                        <td width="15%" class="tablecell1">&nbsp;</td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="5%" class="tablecell1" nowrap>&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="6%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="13%" class="tablecell1"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="60"><a href="javascript:cmdSave('<%=im.getOID()%>','<%=assetData.getOID()%>','<%=s.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a></td>
                                                    <td width="1%"><img src="../images/spacer.gif" width="10" height="1"></td>
                                                    <td width="100%"><a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/back2.gif',1)"><img src="../images/back.gif" name="new21" border="0"></a></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="13%" class="tablecell1">&nbsp;</td>
                                    </tr>
                                    <%} //preview
                                    else {%> 
                                    
                                    <tr> 
                                        <td width="7%" class="tablecell1">
                                            <%if (isEditable) {%>
                                            <a href="javascript:cmdEdit('<%=im.getOID()%>')"><font size="1"><%=im.getCode()%></font></a>
                                            <%} else {%>
                                            <font size="1"><%=im.getCode()%></font>
                                        <%}%></td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>%</font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getOID() == 0) ? "" : I_Project.shortMonths[assetData.getBulanMulaiDepresiasi()]%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%></font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getTotalDepreSebelum() == 0) ? "" : JSPFormater.formatNumber(assetData.getTotalDepreSebelum(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <%if (assetData.getOID() != 0) {%>
                                                    <%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() != null) ? assetData.getTglDepreTerakhir() : s.getDate(), "dd/MM/yyyy")%> 
                                                    <%}%>
                                            </font></div>
                                        </td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(akumDep.getOID() == 0) ? "" : akumDep.getCode() + "/" + akumDep.getName()%></font></td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(expDep.getOID() == 0) ? "" : expDep.getCode() + "/" + expDep.getName()%></font></td>
                                    </tr>
                                    <%}//end editor
                                    }//end if loc beda
                                    else {
                                    %>
                                    <%
                                        //edit
                                        if ((iJSPCommand == JSPCommand.EDIT && im.getOID() == itemMasterId) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0 && im.getOID() == itemMasterId)) {

                                            if (iJSPCommand == JSPCommand.SAVE) {
                                                assetData = assetDataObj;
                                            }

                                    %>
                                    <tr> 
                                        <td width="7%" class="tablecell1" height="33" nowrap valign="bottom"><b><i>EDITOR 
                                        DATA</i></b></td>
                                        <td width="15%" class="tablecell1" height="33" valign="top"><a name="go"></a></td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="4%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="6%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="7%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="5%" class="tablecell1" height="33">&nbsp;</td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp; 
                                        </td>
                                        <td width="13%" class="tablecell1" height="33">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1"><font size="1"><%=im.getCode()%></font></td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_DEPRESIASI_PERCENT]%>" size="4" value="<%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            %<%= jspAssetData.getErrorMsg(JspAssetData.JSP_DEPRESIASI_PERCENT) %></font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"> 
                                                    <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>" value="<%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%>" size="9" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_PEROLEHAN]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <select name="<%=JspAssetData.colNames[JspAssetData.JSP_BULAN_MULAI_DEPRESIASI]%>">
                                                        <%for (int x = 0; x < I_Project.shortMonths.length; x++) {%>
                                                        <option value="<%=x%>" <%if (assetData.getBulanMulaiDepresiasi() == x) {%>selected<%}%>><%=I_Project.shortMonths[x]%></option>
                                                        <%}%>
                                                    </select>
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="textfield22" size="10" value="<%=(s.getQty() * im.getCogs() == 0) ? "" : JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_RESIDU]%>" size="10" value="<%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%>" style="text-align:right"  onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield3" size="10" value="<%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="textfield4" size="10" value="<%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%>" style="text-align:right" readonly class="readonly">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <input type="text" name="<%=JspAssetData.colNames[JspAssetData.JSP_TOTAL_DEPRE_SEBELUM]%>" size="10" value="<%=(assetData.getTotalDepreSebelum() == 0) ? "" : "" + assetData.getTotalDepreSebelum()%>" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                            </font></div>
                                        </td>
                                        <td width="5%" class="tablecell1" nowrap> 
                                            <input name="<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>" value="<%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() == null) ? new Date() : assetData.getTglDepreTerakhir(), "dd/MM/yyyy")%>" size="9" readonly>
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.<%=JspAssetData.colNames[JspAssetData.JSP_TGL_DEPRE_TERAKHIR]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_AKUM_DEP_ID]%>">
                                                    <%if (coaFixedAsset != null && coaFixedAsset.size() > 0) {
                                            for (int x = 0; x < coaFixedAsset.size(); x++) {
                                                Coa coa = (Coa) coaFixedAsset.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                    %>
                                                    <option value="<%=coa.getOID()%>" <%if (akumDep.getOID() == coa.getOID()) {%>selected<%}%>><%=str + coa.getCode() + "/" + coa.getName()%></option>
                                                    <%}
                                        }%>
                                                </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_AKUM_DEP_ID) %> </font></td>
                                        <td width="13%" class="tablecell1"><font size="1"> 
                                                <select name="<%=JspAssetData.colNames[JspAssetData.JSP_COA_EXPENSE_DEP_ID]%>">
                                                <%if (coaExpense != null && coaExpense.size() > 0) {
                                            for (int x = 0; x < coaExpense.size(); x++) {
                                                Coa coa = (Coa) coaExpense.get(x);
                                                String str = "";

                                                if (!isPostableOnly) {
                                                    switch (coa.getLevel()) {
                                                        case 1:
                                                            break;
                                                        case 2:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 3:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 4:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                        case 5:
                                                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                            break;
                                                    }
                                                }
                                                %>
                                            <option value="<%=coa.getOID()%>" <%if (expDep.getOID() == coa.getOID()) {%>selected<%}%>><font size="1"><%=str + coa.getCode() + "/" + coa.getName()%></font></option>
                                            <%}
                                        }%>
                                            </select>
                                        <%= jspAssetData.getErrorMsg(JspAssetData.JSP_COA_EXPENSE_DEP_ID) %> </font></td>
                                    </tr>
                                    <tr> 
                                        <td width="7%" class="tablecell1"></td>
                                        <td width="15%" class="tablecell1">&nbsp;</td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="4%" class="tablecell1">&nbsp; </td>
                                        <td width="5%" class="tablecell1" nowrap>&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="6%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="7%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="5%" class="tablecell1">&nbsp;</td>
                                        <td width="13%" class="tablecell1"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="60"><a href="javascript:cmdSave('<%=im.getOID()%>','<%=assetData.getOID()%>','<%=s.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a></td>
                                                    <td width="1%"><img src="../images/spacer.gif" width="10" height="1"></td>
                                                    <td width="100%"><a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/back2.gif',1)"><img src="../images/back.gif" name="new21" border="0"></a></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="13%" class="tablecell1">&nbsp;</td>
                                    </tr>
                                    <%} //preview
                                    else {%> 
                                  
                                    <tr> 
                                        <td width="7%" class="tablecell1">
                                            <%if (isEditable) {%>
                                            <a href="javascript:cmdEdit('<%=im.getOID()%>')"><font size="1"><%=im.getCode()%></font></a>
                                            <%} else {%>
                                            <font size="1"><%=im.getCode()%></font>
                                        <%}%></td>
                                        <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent() == 0) ? "" : "" + assetData.getDepresiasiPercent()%>%</font></div>
                                        </td>
                                        <td width="4%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan() != null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getOID() == 0) ? "" : I_Project.shortMonths[assetData.getBulanMulaiDepresiasi()]%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty() * im.getCogs(), "#,###")%></font></div>
                                        </td>
                                        <td width="6%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getResidu() == 0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getYearlyDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getYearlyDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="1"><%=(assetData.getMthDepresiasi() == 0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"><%=(assetData.getTotalDepreSebelum() == 0) ? "" : JSPFormater.formatNumber(assetData.getTotalDepreSebelum(), "#,###")%></font></div>
                                        </td>
                                        <td width="5%" class="tablecell1"> 
                                            <div align="center"><font size="1"> 
                                                    <%if (assetData.getOID() != 0) {%>
                                                    <%=JSPFormater.formatDate((assetData.getTglDepreTerakhir() != null) ? assetData.getTglDepreTerakhir() : s.getDate(), "dd/MM/yyyy")%> 
                                                    <%}%>
                                            </font></div>
                                        </td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(akumDep.getOID() == 0) ? "" : akumDep.getCode() + "/" + akumDep.getName()%></font></td>
                                        <td width="13%" class="tablecell1"><font size="1"><%=(expDep.getOID() == 0) ? "" : expDep.getCode() + "/" + expDep.getName()%></font></td>
                                    </tr>
                                    <%}//end editor
                                                          }
                                                      }%>
                                    <%
                    }// if > 0
                }// for
            }// if ada%>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td width="7%">&nbsp;</td>
                                        <td width="15%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="4%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="6%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="7%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="5%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td>&nbsp;</td>
                        </tr>
                        <tr> 
                            <td>&nbsp;</td>
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
