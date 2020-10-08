
<%-- 
    Document   : s_nom_jurnal
    Created on : May 30, 2011, 1:36:09 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<% int  appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
boolean privAdd=true;
boolean privUpdate=true;
boolean privDelete=true;
%>

<!-- Jsp Block -->
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
String formName = JSPRequestValue.requestString(request, "formName");
String txt_Id = JSPRequestValue.requestString(request, "txt_Id");
String txt_Name = JSPRequestValue.requestString(request, "txt_Name");

String pattyCashId = JSPRequestValue.requestString(request, "pattyCashId");
String jurnalname = JSPRequestValue.requestString(request, "jurnalname");
String v_txt_jurnal = JSPRequestValue.requestString(request, "txt_jurnal");

Vector listPettycashPayment = new Vector();

if(iJSPCommand == JSPCommand.SEARCH){
    
    String where = "";
    
    if(v_txt_jurnal != null && v_txt_jurnal.length() > 0){
        
        where = DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER]+" like '%"+v_txt_jurnal+"%' ";
    }
    
    if(where.length() > 0){
        where = where + " AND ";
    }
    
    where = where + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE]+"="+DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA;
    
    listPettycashPayment = DbPettycashPayment.list(0, 0, where, DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER]);    
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
<script language="JavaScript">
function cmdSelect(jurnalname,cashOid){      
    self.opener.document.<%=formName%>.<%=txt_Id%>.value = cashOid;
    self.opener.document.<%=formName%>.<%=txt_Name%>.value = jurnalname;
    self.opener.document.<%=formName%>.command.value="<%=JSPCommand.LOAD%>";    
    self.opener.document.<%=formName%>.submit();                
    self.close();
}
 
function cmdSearch(){           
    if(document.frm_nomorjurnal.txt_jurnal.value == ""){
        alert("Pencarian nomor jurnal harus diisi");
    }else{
        document.frm_nomorjurnal.command.value="<%=JSPCommand.SEARCH%>";
        document.frm_nomorjurnal.action="s_nom_jurnal.jsp";
        document.frm_nomorjurnal.submit();
    }
}

function cmdDelPict(oidCashReceiveDetail){
	document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="s_nomor_jurnal.jsp";
	document.frmimage.submit();
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
</script>
<!-- #EndEditable -->
</head>
<body> 
    <table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
        <form name="frm_nomorjurnal" method ="post" action="">
        <input type="hidden" name="command" value="<%=iJSPCommand%>">
        <input type="hidden" name="pattyCashId" value="<%=pattyCashId%>">
        <input type="hidden" name="jurnalname" value="<%=jurnalname%>">
        <input type="hidden" name="formName" value="<%=formName%>">
        <input type="hidden" name="txt_Id" value="<%=txt_Id%>">
        <input type="hidden" name="txt_Name" value="<%=txt_Name%>">
        <tr>
            <td width="5px">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td width="25%">Nomor Jurnal</td>
            <td>
                <table>
                <tr>
                    <td>
                        <input type="text" name="txt_jurnal" value="<%=v_txt_jurnal%>">&nbsp;
                    </td>
                    <td>
                        <a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new1" width="59" height="21" border="0"></a>
                    </td>
                </tr>
                </table>   
             </td>
        </tr>
        <tr>
            <td width="5px">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <%
        if(listPettycashPayment != null && listPettycashPayment.size() > 0){
        %>    
        <tr>
            <td width="5px">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td colspan=2>
                <table width="100%" border=0 cellpadding="1" cellspacing="1">
                    <tr>
                        <td class="tablehdr" width="20%">No. Journal</td>
                        <td class="tablehdr" width="60%">Memo</td>
                        <td class="tablehdr" width="20%">Amount</td>
                    </tr>    
                    <%
                    for(int i = 0 ; i < listPettycashPayment.size() ; i++){
                
                    PettycashPayment pettycashPayment = (PettycashPayment)listPettycashPayment.get(i);
            
                    if(i%2==0){
                    %>
                    <tr>
                        <td class="tablecell" align="center">
                        <%
                        out.println("<a style='color:blue' href=\"javascript:cmdSelect('" + pettycashPayment.getJournalNumber() + "','"+pettycashPayment.getOID()+"')\">" + pettycashPayment.getJournalNumber() + "</a>");
                        %>
                        </td>
                        <td class="tablecell" align="left">&nbsp;<%=pettycashPayment.getMemo()%></td>
                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>&nbsp;</td>
                    </tr> 
                    <%
                    }else{ 
                    %>
                    <tr>
                        <td class="tablecelll" align="center"> 
                        <%
                        out.println("<a style='color:blue' href=\"javascript:cmdSelect('" + pettycashPayment.getJournalNumber() + "','"+pettycashPayment.getOID()+"')\">" + pettycashPayment.getJournalNumber() + "</a>");
                        %>
                        </td>
                        <td class="tablecelll" align="left">&nbsp;<%=pettycashPayment.getMemo()%></td>
                        <td class="tablecelll" align="right"><%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>&nbsp;</td>
                    </tr> 
                    <% 
                    } 
                    %>
                    <% 
                    } 
                    %>
                </table>
            </td>
        </tr>
        <% 
        }
        %>
        </form>
        <tr height = "40px">
            <td>&nbsp</td>
        </tr>
    </table>
</body>
</html>
