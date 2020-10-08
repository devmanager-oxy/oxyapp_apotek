

<%-- 
    Document   : cashregister_priview
    Created on : Sep 20, 2011, 2:46:20 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ page import = "com.project.crm.*" %>
<%@ include file="../main/check.jsp"%>

<style>
    #border-bottom{
        border-bottom: 1px solid #000000;
    }
    #border-top{
        border-top: 1px solid #000000;
    }
    
    #company{
        font-family:Arial, Helvetica, sans-serif;
        font-size: 12px;
        color: #000000;
        text-align: left;
        font-weight: bold;
    }
    #company-alamat{
        font-family:Arial, Helvetica, sans-serif;
        font-size: 12px;
        color: #000000;
        text-align: left;
        font-weight: bold;
        border-bottom: 2px solid #9A958F;
        padding-bottom:5px;
    }
    
    #title-1{
        font-family:"Courier New", Courier, monospace;
        font-size: 18px;
        color: #000000;
    }
    
    #title-2{
        font-family:"Courier New", Courier, monospace;
        font-size: 14px;
        color: #000000;
    }
    
    #head-left{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-bottom: 1px solid #000000;
    }
    
    #head-left-2{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
    }
    
    #head-right{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-right: 1px dashed #000000;
        border-bottom: 1px solid #000000;
    }
    
    #head-right-2{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-right: 1px dashed #000000;
    }
    
    #listfirst-left{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        padding-left : 2px;
        padding-right : 2px;
    }
    
    #listfirst-right{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-right: 1px dashed #000000;
        padding-left : 2px;
        padding-right : 2px;
    }
    
    #listfirst-left-last{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-bottom: 1px solid #000000;
        padding-left : 2px;
        padding-right : 2px;
    }
    
    #listfirst-right-last{
        font-family:"Courier New", Courier, monospace;
        font-size: 12px;
        color: #000000;
        border-left: 1px dashed #000000;
        border-top: 1px solid #000000;
        border-right: 1px dashed #000000;
        border-bottom: 1px solid #000000;
        padding-left : 2px;
        padding-right : 2px;
    }
    
    </style>    
<%

            Vector vAccLinks = new Vector();
            Date findDt = new Date();
            long accLinkId = 0;
            findDt = JSPFormater.formatDate(JSPRequestValue.requestString(request, "transaction_date"), "dd/MM/yyyy");
            
            try{
                accLinkId = JSPRequestValue.requestLong(request, "acc_link_id");
            }catch(Exception e){}
            System.out.println("accLink : "+accLinkId);
            Periode p = DbPeriode.getOpenPeriod();
            //String whereAccLink = DbAccLink.colNames[DbAccLink.COL_TYPE] + " = '" + I_Project.ACC_LINK_GROUP_CASH + "'";
            
            //String whereAccLink = DbAccLink.colNames[DbAccLink.COL_ACC_LINK_ID] + " = " + accLinkId;
            String whereAccLink = DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + accLinkId;

            //vAccLinks = DbAccLink.list(0, 0, whereAccLink, null);
            vAccLinks = DbCoa.list(0, 0, whereAccLink, null);

            Vector vCompany = DbCompany.listAll();

            String name_company = "";
            String alamat_company = "";

            if (vCompany != null && vCompany.size() > 0) {
                Company company = (Company) vCompany.get(0);
                name_company = company.getName();
                alamat_company = company.getAddress();
            }

            /*** LANG ***/
            String[] langFR = {"CASH REGISTER", "Acc. Group", //0-1
                "BKK/BKM number", "Check/GB Number", "Memo", "Debet", "Credit", "Balance", "Opening Balance", "Check Number/Gb", "Receive From/Pay to", "Summary (Rp)"}; //2-8
            String[] langNav = {"Cash Transaction", "Cash Register", "Date", "Data not found"};

            if (lang == LANG_ID) {
                String[] langID = {"KAS REGISTER", "Kelompok Akun",
                    "No. BKK/BKM", "No Cek/GB", "Uraian", "Penerimaan", "Pengeluaran", "Saldo", "Saldo Awal", "No. Cek/Gb", "Diterima dari/bayar kepada", "Jumlah (Rp)"
                };
                langFR = langID;
                String[] navID = {"Transaksi Tunai", "Kas Register", "Tanggal", "Data tidak ditemukan"};
                langNav = navID;
            }
%>
<table width="95%" align="center" cellpadding="0" cellspacing="0">
    <tr> 
        <td class id ='company' colspan="7"><%=name_company.toUpperCase()%></td>
    </tr>
    <tr> 
        <td class id ='company-alamat' colspan="7"><%=alamat_company.toUpperCase()%></td>
    </tr>            
    <tr> 
        <td class id ='border-top' colspan="7">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=7 class id = "title-1" align="center">LAPORAN HARIAN KAS</td>
    </tr>
    <tr> 
        <td colspan=7 align="center"> 
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="47%" align="right" class id = "title-2">Tanggal</td>
                    <td width="4%" align="center" class id = "title-2">:</td>
                    <td width="49%" align="left" class id = "title-2"><%=JSPFormater.formatDate(findDt, "dd/MM/yyyy")%></td>
                </tr>
            </table>    
        </td>
    </tr>
    <%
            if (vAccLinks != null && vAccLinks.size() > 0) {

                String nama_1 = "";
                String nama_2 = "";

                String ket_1 = "";
                String ket_2 = "";

                try {
                    Approval approval_1 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_CASH_REGISTER, DbApproval.URUTAN_1);
                    Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                    nama_1 = employee.getName();
                    ket_1 = approval_1.getKeterangan();

                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                try {
                    Approval approval_2 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_CASH_REGISTER, DbApproval.URUTAN_2);
                    Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                    nama_2 = employee.getName();
                    ket_2 = approval_2.getKeterangan();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
    %>    
    
    <%
        for (int i = 0; i < vAccLinks.size(); i++){

            //AccLink accLink = (AccLink) vAccLinks.get(i);
            //Coa coa = DbCoa.fetchExc(accLink.getCoaId());            
            Coa coa = (Coa)vAccLinks.get(i);

            boolean isDebetPosition = false;

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                isDebetPosition = true;
            }
    %>
    <tr> 
        <td colspan=7 align="center"> 
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="47%" align="right" class id = "title-2">Perkiraan</td>
                    <td width="4%" class id = "title-2" align="center">:</td>
                    <td width="49%" class id = "title-2" align="left"><%=coa.getCode()%></td>
                </tr>
            </table>    
        </td>
    </tr>
    <%
        Vector temp = DbGlDetail.getGeneralLedger(findDt, coa.getOID());
    %>
    <tr>
        <td colspan="7" class id = "border-bottom">&nbsp;</td>
    </tr>
    <tr>
        <td height="1"></td>
    </tr>
    <tr> 
        <td width="14%" rowspan="2" align="center" class id = "head-left"><%=langFR[2].toUpperCase()%></td>
        <td width="10%" rowspan="2" align="center" class id = "head-left"><%=langFR[3].toUpperCase()%></td>
        <td width="20%" rowspan="2" align="center" class id = "head-left"><%=langFR[10].toUpperCase()%></td>
        <td width="20%" rowspan="2" align="center" class id = "head-left"><%=langFR[4].toUpperCase()%></td>
        <td width="26%" colspan="2" align="center" class id = "head-left-2"><%=langFR[11].toUpperCase()%></td>
        <td width="10%" rowspan="2" align="center" class id = "head-right"><%=langFR[7].toUpperCase()%></td>
    </tr>
    <tr>
        <td width="13%" align="center" class id = "head-left"><%=langFR[5]%></td>
        <td width="13%" align="center" class id = "head-left"><%=langFR[6]%></td>
    </tr>
    <%
        double openingBalance = 0;
        double totalCredit = 0;
        double totalDebet = 0;

        //jika bukan expense dan revenue
        if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
                coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {

            openingBalance = DbGlDetail.getGLOpeningBalance(findDt, coa);

    %>
    <tr>
        <td colspan ="7" height="1"></td>
    </tr> 
    <tr> 
        <td class id = "listfirst-left" align="center">&nbsp;</td>
        <td class id = "listfirst-left" align="center">&nbsp;</td>                                                                                                        
        <td class id = "listfirst-left" align="center">&nbsp;</td>
        <td class id = "listfirst-left" align="left"><%=langFR[8]%></td>
        <td class id = "listfirst-left" align="right">-</td>
        <td class id = "listfirst-left" align="right">-</td>
        <td class id = "listfirst-right" align="right"><div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div></td>
    </tr>
    <%
        }// end jika bukan revenue 	  

        if (temp != null && temp.size() > 0) {

            for (int x = 0; x < temp.size(); x++) {

                Vector gld = (Vector) temp.get(x);
                Gl gl = (Gl) gld.get(0);
                GlDetail gd = (GlDetail) gld.get(1);

                try {
                    gd = DbGlDetail.fetchExc(gd.getOID());
                } catch (Exception e) {
                }

                if (isDebetPosition) {
                    openingBalance = openingBalance + (gd.getDebet() - gd.getCredit());
                } else {
                    openingBalance = openingBalance + (gd.getCredit() - gd.getDebet());
                }

                totalDebet = totalDebet + gd.getDebet();
                totalCredit = totalCredit + gd.getCredit();
                String name = "&nbsp;";

                try {
                    name = SessReport.getPemberiOrPenerima(gd.getGlId());
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
    %>
    <%if (x == 0) {%>
       
    <tr> 
        <td class id = "listfirst-left" valign="top"><div align="center"><%=gl.getJournalNumber()%></div></td>
        <td class id = "listfirst-left">&nbsp;</td>
        <td class id = "listfirst-left" align="left" valign="top" ><%=name.length() > 0 ? name : "&nbsp;"%></td>
        <td class id = "listfirst-left" valign="top">;<%=((gl.getMemo().length() > 0) ? gl.getMemo() + " : " : "&nbsp;") + gd.getMemo()%></td>
        <td class id = "listfirst-left" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##") %></div>
        </td>
        <td class id = "listfirst-left" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
        </td>
        <td class id = "listfirst-right" align="right"><div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div></td>
        
    </tr>    
    <%} else {%>
    <tr> 
        <td class id = "listfirst-left" valign="top"><div align="center"><%=gl.getJournalNumber()%></div></td>
        <td class id = "listfirst-left" valign="top">&nbsp;</td>
        <td class id = "listfirst-left" align="left" valign="top"><%=name.length() > 0 ? name : "&nbsp;"%></td>
        <td class id = "listfirst-left" valign="top"><%=((gl.getMemo().length() > 0) ? gl.getMemo() + " : " : "&nbsp;") + gd.getMemo()%></td>
        <td class id = "listfirst-left" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##") %></div>
        </td>
        <td class id = "listfirst-left" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
        </td>
        <td class id = "listfirst-right" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
        </td>
    </tr> 
    <%}%>
    <%}%>
    <%} else {%>
    <tr>
        <td colspan="7" height="1"></td>
    </tr>
    <%}%>
    <tr> 
        <td class id = "listfirst-left-last">&nbsp;</td>
        <td class id = "listfirst-left-last">&nbsp;</td>
        <td class id = "listfirst-left-last">&nbsp;</td>
        <td class id = "listfirst-left-last"><div align="right"><b>Total <%=baseCurrency.getCurrencyCode()%></b></div></td>
        <td class id = "listfirst-left-last"> 
            <div align="right"><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></div>
        </td>
        <td class id = "listfirst-left-last"> 
            <div align="right"><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></div>
        </td>
        <td class id = "listfirst-right-last" valign="top"> 
            <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
        </td>
    </tr>
    <tr>
        <td colspan="7" height="1"></td>
    </tr>
    <tr>
        <td colspan="7" height="30" class id = "border-top">&nbsp;</td>
    </tr>    
    <%}%>
    <tr> 
        <td colspan="7">
            <table width="100%">
                <tr>
                    <td width = "40%" align="center">Mengetahui :</td>
                    <td width = "40%" align="center">Dibuat oleh :</td>
                    <td width = "20%" >&nbsp;</td>
                </tr>  
                <tr>
                    <td colspan="3" height="60">&nbsp;</td>
                </tr>  
                <tr>
                    <td width = "40%" align="center"><%=ket_1%></td>
                    <td width = "40%" align="center"><%=ket_2%></td>
                    <td width = "20%" >&nbsp;</td>
                </tr>  
            </table>    
        </td>
    </tr>
    <tr>
        <td colspan="7" height="1"></td>
    </tr>
    <tr>
        <td colspan="7" height="1" class id = "border-bottom">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="7" height="1"></td>
    </tr>
    <tr>
        <td colspan="7" height="1" class id = "border-top">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="7"><div align="center"><a href="../freport/cashregister_print.jsp?transaction_date='<%=JSPFormater.formatDate(findDt, "dd/MM/yyyy")%>'&acc_link_id=<%=accLinkId%>" target='_blank'><img src="../images/print.gif" name="delete" height="22" border="0"></div></td>
    </tr>  
    <%}%>    
</table>    

