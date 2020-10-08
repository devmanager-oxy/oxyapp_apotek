
<%-- 
    Document   : rpt_arsip_detail
    Created on : Feb 23, 2011, 11:39:32 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.session.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ page import = "com.project.crm.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../../main/check.jsp" %>


<style>
    .borderB{
        border-bottom: 1px solid #000;
    }
    #stringC{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        line-height: 18px;
        color: #000;
        text-align: center;
    }
    #string{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        line-height: 18px;
        color: #000;
        text-align: left;
    }
    
    #string-tidak-putus{
        font-family:'Courier New', Courier, monospace;
        font-size: 12px;
        line-height:18px; 
        color: #9A958F;
        text-align: left;
    }
    
    #string-tidak-putus-2{
        font-family:'Courier New', Courier, monospace;
        font-size: 14px;
        line-height:18px; 
        color: #9A958F;
        text-align: left;
    }
    
    #string-tourism{
        font-family:'Courier New', Courier, monospace;
        font-size: 14px;
        line-height:18px; 
        color: #000000;
        text-align: left;
    }
    
    #string-putus{
        font-family:'Courier New', Courier, monospace;
        border-bottom: dashed 1px;        
        padding-bottom:3px;
        font-size: 12px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
    }
    
    #string-garis-bawah-putus{
        font-family:'Courier New', Courier, monospace;
        border-bottom: dashed 1px;        
        padding-bottom:3px;
        font-size: 12px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
    }
    #string-garis-atas-putus{
        font-family:'Courier New', Courier, monospace;
        border-top: dashed 1px;        
        padding-bottom:3px;
        font-size: 12px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
    }
    #string-garis-atas-kiri-center{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px; 
        border-top : dashed 1px;
        border-bottom : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;
    }
    
    #string-keterangan{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px; 
        border-top : dashed 1px;
        border-bottom : dashed 1px;
        padding-bottom: 3px;
        font-size: 14px;
        vertical-align : top;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
    }
    
    
    #string-garis-kiri-center{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;
    }
    
    #string-garis-atas-kiri-padding-left{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        border-top : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
        padding-left:20px;
    }
    
    #string-garis-atas-kiri-padding-left-top{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        border-top : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
        padding-left:20px;
        vertical-align: top;
        padding-top:6px;
    }
    
    #string-isi-tabel{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        border-top : dashed 1px;
        padding-bottom:3px;
        padding-top:6px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;        
        vertical-align: top;
    }
    
    #string-garis-kiri-padding-left{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
        padding-left:20px;
    }
    
    #string-garis-kiri-padding-left-paraf{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-bottom : dashed 1px;
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: left;
        padding-left:5px;
        height : 20px;
    }
    
    #string-garis-atas-kiri-kanan-center{
        font-family:'Courier New', Courier, monospace;
        border: dashed 1px;                
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;
    }
    
    #string-garis-atas-kiri-kanan-center-top{
        font-family:'Courier New', Courier, monospace;
        border: dashed 1px;                
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;
        vertical-align: top;
        padding-top:6px;
    }
    
    #string-garis-kiri-kanan-center{
        font-family:'Courier New', Courier, monospace;
        border-left : dashed 1px;         
        border-right : dashed 1px;        
        border-bottom : dashed 1px;        
        padding-bottom:3px;
        font-size: 14px;
        line-height:16px; 
        color: #9A958F;
        text-align: center;
    }
    
    #bukti-putus{
        font-family:'Courier New', Courier, monospace;
        border-bottom: dashed 2px;
        letter-spacing:3px;
        padding-bottom:3px;
        font-size: 22px;
        font-weight:bolder; 
        color: #9A958F;
        text-align: center;
    }
    
    #strongC{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        line-height: 18px;
        font-weight: bold;
        color: #000;
        text-align: center;
    }
    #strong{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        line-height: 18px;
        font-weight: bold;
        color: #000;
        text-align: left;
    }
    .style1 {
        font-size: 9px;
        font-style: italic;
    }
    </style>
<%
            
            long cashReceiveOid = Long.parseLong(request.getParameter("cashReceiveOid"));

            String no_bkm = request.getParameter("no_bkm");
            int transaction_source = Integer.parseInt(request.getParameter("transaction_source"));
            long matauangId = Long.parseLong(request.getParameter("matauangId"));
            String tanggal_invoice = request.getParameter("tanggal_invoice");
            String sarana = request.getParameter("sarana");
            String jml_pembayaran = request.getParameter("jml_pembayaran");
            long limbahId = Long.parseLong(request.getParameter("limbahId"));
            long irigasiId = Long.parseLong(request.getParameter("irigasiId"));
            
            Currency curr = new Currency();
            try {
                curr = DbCurrency.fetchExc(matauangId);
            } catch (Exception e) {
                System.out.println("[exception] "+e.toString());
            }
            
            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
            LimbahTransaction limbahTransaction = new LimbahTransaction();
            
            String keterangan = "";
            
            if(limbahId!=0){
                try{
                    limbahTransaction = DbLimbahTransaction.fetchExc(limbahId);
                    keterangan = limbahTransaction.getKeterangan();
                }catch(Exception E){
                    System.out.println("[exception] "+E.toString());
                }
            }else if(irigasiId!=0){
                try{
                    irigasiTransaction = DbIrigasiTransaction.fetchExc(irigasiId);
                    keterangan = irigasiTransaction.getKeterangan();
                }catch(Exception E){
                    System.out.println("[exception] "+E.toString());
                }
            }
            

%>

<table width="100%" border="0">
    <tr>
        <td width="5%">&nbsp</td>
        <td width="45%" ><font class id = 'string-putus'>P.T. (PERSERO) PENGEMBANGAN PARIWISATA BALI</font></td>
        <td width="5%">&nbsp</td>
        <%if (transaction_source == DbPembayaran.PAYMENT_TYPE_BANK) {%>
        <td width="40%" align="center" ><font class id = 'bukti-putus'>BUKTI <strike><%=DbPembayaran.paymentTypeStr[DbPembayaran.PAYMENT_TYPE_CASH]%></strike>/<%=DbPembayaran.paymentTypeStr[DbPembayaran.PAYMENT_TYPE_BANK]%></font></td>
        <%} else {%>
        <td width="40%" align="center" ><font class id = 'bukti-putus'>BUKTI <%=DbPembayaran.paymentTypeStr[DbPembayaran.PAYMENT_TYPE_CASH]%>/<strike><%=DbPembayaran.paymentTypeStr[DbPembayaran.PAYMENT_TYPE_BANK]%> </strike></font></td>
        <%}%>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="100%" colspan="5" height="2px"></td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ><font class id = 'string-tidak-putus'>P.T. BALI TOURISM DEVELOPMENT CORPORATION</font></td>
        <td width="5%">&nbsp</td>
        <td width="45%" align="center"><font class id = 'string-tidak-putus-2'>P E N E R I M A A N</font></td>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ><font class id = 'string-tidak-putus'>NUSA DUA - BUALU P.O. BOX 3 NUSA DUA TELP 71010</font></td>
        <td width="5%">&nbsp</td>
        <td width="45%" align="center"><font class id = 'string-tidak-putus-2'></font></td>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" >&nbsp;</td>
        <td width="5%">&nbsp</td>
        <td width="45%" align="center"></td>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="100%" colspan="5" height="2px"></td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ></td>
        <td width="5%">&nbsp</td>
        <td width="45%">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>No. BKM : <%=no_bkm%></font></td>
                </tr>   
            </table>  
        </td>    
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="100%" colspan="5" height="2px"></td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ></td>
        <td width="5%">&nbsp</td>
        <td width="45%" align="left">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>Tanggal : <%=tanggal_invoice%></font></td>
                </tr>   
            </table> 
        </td>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ><font class id = 'string-tidak-putus-2'>Diterima dari &nbsp;&nbsp;&nbsp;&nbsp;: <%=sarana%></font></td>
        <td width="5%">&nbsp</td>
        <td width="45%" ></td>
        <td width="5%">&nbsp</td>
    </tr>
    <tr>
        <td width="5%">&nbsp</td>
        <td width="40%" ></td>
        <td width="5%">&nbsp</td>
        <td width="45%" align="left">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>Periode :</font></td>
                </tr>   
            </table> 
        </td>
        <td width="5%">&nbsp</td>
    </tr>
    <%
        NumberSpeller numberSpeller = new NumberSpeller();
    %>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%">&nbsp</td>
                    <td ><font class id = 'string-tidak-putus-2'>Jumlah dgn. angka  : <%=curr.getCurrencyCode()%> <%=jml_pembayaran%></font><td>                
                    <td width="5%">&nbsp</td>
                </tr>
            </table>   
        </td>    
    </tr>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="57px">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>dgn. huruf  : <%=numberSpeller.spellNumberToIna(Double.parseDouble(jml_pembayaran.replaceAll(",", "")))%></font><td>
                    <td width="5%">&nbsp;</td>
                </tr>
            </table>   
        </td>    
    </tr>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%">&nbsp</td>
                    <td width="14%"><font class id = 'string-tidak-putus-2'>Terima berupa  :</font></td>
                    <td><td>                
                    <td width="5%">&nbsp</td>
                </tr>
            </table>   
        </td>    
    </tr>
    <tr>
        <td width="100%" colspan="5" height="5px"></td>    
    </tr>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%">&nbsp</td>
                    <td width="14%"></td>
                    <td><font class id = 'string-tidak-putus-2'>Cash</font><td>                
                    <td width="5%">&nbsp</td>
                </tr>
            </table>   
        </td>    
    </tr>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%" border="0px">
                <tr>
                    <td width="5%">&nbsp</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="4" class id='string-garis-bawah-putus' height="5px">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="4" height="2px"></td>
                            </tr>            
                            <tr>
                                <td width="10%" class id='string-garis-atas-kiri-center'>No</td>
                                <td width="30%" class id='string-garis-atas-kiri-padding-left' >P E R I N C I A N</td>
                                <td width="30%" class id='string-garis-atas-kiri-padding-left' >No. Rekening</td>
                                <td width="30%" class id='string-garis-atas-kiri-kanan-center' >J U M L A H</td>
                            </tr> 
                            <tr>
                                <td colspan="4" height="2px"></td>
                            </tr> 
                            <tr height="80px">
                                <td width="10%" class id='string-isi-tabel'><%=keterangan.compareTo("")==0 && jml_pembayaran.compareTo("")==0 ? "&nbsp" : "1" %></td>
                                <td width="30%" class id='string-garis-atas-kiri-padding-left-top' ><%=keterangan.compareTo("")==0 ? "&nbsp" : keterangan %></td>
                                <td width="30%" class id='string-garis-atas-kiri-padding-left-top' ><%=keterangan.compareTo("")==0 ? "&nbsp" : "-" %></td>
                                <td width="30%" class id='string-garis-atas-kiri-kanan-center-top' ><%=jml_pembayaran%></td>
                            </tr> 
                            <tr>
                                <td colspan="4" height="2px"></td>
                            </tr>
                            <tr>
                                <td width="70%" colspan="3" class id='string-garis-atas-kiri-center'>T O T A L</td>                    
                                <td width="30%" class id='string-garis-atas-kiri-kanan-center' ><%=jml_pembayaran%></td>
                            </tr> 
                            <tr>
                                <td colspan="4">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="20%" class id='string-garis-kiri-center'>SETUJU DITERIMA</td>
                                            <td width="30%" class id='string-garis-kiri-center' colspan="2">DIPERIKSA OLEH</td>
                                            <td width="20%" class id='string-garis-kiri-center'>DITERIMA</td>
                                            <td width="30%" class id='string-garis-kiri-kanan-center' colspan="2">TELAH DIBUKUKAN</td>
                                        </tr>
                                        <tr>
                                            <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                            <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                            <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                            <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                            <td class id='string-garis-kiri-center'>Paraf</td>
                                            <td class id='string-garis-kiri-kanan-center'>Tanggal</td>
                                        </tr>
                                        <tr>
                                            <td class id='string-garis-kiri-padding-left-paraf'>1.</td>
                                            <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class id='string-garis-kiri-padding-left-paraf'>2.</td>
                                            <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                        </tr>
                                        <% 
            String nama_1 = "";                            
            String nama_2 = "";
            String nama_3 = "";
            String nama_4 = "";
            String nama_5 = "";
            
            String ket_1 = "&nbsp;";                            
            String ket_2 = "&nbsp;";
            String ket_3 = "&nbsp;";
            String ket_4 = "&nbsp;";
            String ket_5 = "&nbsp;";
            
            try{
                Approval approval_1 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_PEMBAYARAN_IRIGASI, DbApproval.URUTAN_1);
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama_1 = employee.getName();
                ket_1 = approval_1.getKeterangan();
                
            }catch(Exception E){
                System.out.println("[exception] "+E.toString());
            }
            
            try{
                Approval approval_2 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_PEMBAYARAN_IRIGASI, DbApproval.URUTAN_2);
                Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                nama_2 = employee.getName();
                ket_2 = approval_2.getKeterangan();
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            
            try{
                Approval approval_3 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_PEMBAYARAN_IRIGASI, DbApproval.URUTAN_3);
                Employee employee = DbEmployee.fetchExc(approval_3.getEmployeeId());
                nama_3 = employee.getName();
                ket_3 = approval_3.getKeterangan();
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }    
            
            try{
                Approval approval_4 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_PEMBAYARAN_IRIGASI, DbApproval.URUTAN_4);
                Employee employee = DbEmployee.fetchExc(approval_4.getEmployeeId());
                nama_4 = employee.getName();
                ket_4 = approval_4.getKeterangan();
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }    
            
            try{
                Approval approval_5 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_PEMBAYARAN_IRIGASI, DbApproval.URUTAN_5);
                Employee employee = DbEmployee.fetchExc(approval_5.getEmployeeId());
                nama_5 = employee.getName();
                ket_5 = approval_5.getKeterangan();
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
                                        %>
                                        <tr>
                                            <td class id='string-garis-kiri-center'><%=ket_1==null? "&nbsp" : ket_1 %></td>
                                            <td class id='string-garis-kiri-center'><%=ket_2==null? "&nbsp" : ket_2 %></td>
                                            <td class id='string-garis-kiri-center'><%=ket_3==null? "&nbsp" : ket_3 %></td>
                                            <td class id='string-garis-kiri-center'><%=ket_4==null? "&nbsp" : ket_5 %></td>
                                            <td class id='string-garis-kiri-padding-left-paraf'>3.</td>
                                            <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                        </tr>
                                        <tr >
                                            <td class id='string-garis-kiri-center'>Tgl &nbsp&nbsp/&nbsp&nbsp&nbsp;/20</td>
                                            <td class id='string-garis-kiri-center'>Tgl &nbsp/&nbsp;/20</td>
                                            <td class id='string-garis-kiri-center'>Tgl &nbsp/&nbsp;/20</td>                                            
                                            <td class id='string-garis-kiri-center'>Tgl &nbsp&nbsp/&nbsp&nbsp&nbsp;/20</td>
                                            <td colspan="2" class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                        </tr>
                                        <tr height="80px">
                                            <td colspan="3" class id='string-garis-kiri-center'>&nbsp;</td>                                            
                                            <td colspan="3" class id='string-garis-kiri-kanan-center'>
                                                <table align="center">
                                                    <tr>
                                                        <td><font class id = 'string-tidak-putus-2'>Yang menyerahkan pembayaran Tgl .......20.....</font></td>       
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>       
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>       
                                                    </tr>
                                                    <tr>
                                                        <td><font class id = 'string-tidak-putus-2'>Nama jelas : <%=nama_5==null? "" : nama_5 %> a/n.</font></td>       
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6"><font class id = 'string-tidak-putus-2'>Dicetak Tanggal <%=JSPFormater.formatDate(new Date(),"dd/MM/yy")%></font></td>                                            
                                        </tr>
                                        <tr>
                                            <td colspan="6" align="center">
                                                <%
                                                out.print("<a href=\"../report/print_rpt_arsip_detail.jsp?no_bkm=" + no_bkm + "&transaction_source=" + transaction_source + "&tanggal_invoice=" + tanggal_invoice + "&sarana=" + sarana + "&jml_pembayaran=" + jml_pembayaran + "&limbahId=" + limbahId + "&irigasiId=" + irigasiId + "&matauangid="+matauangId+"\" target='_blank'><img src=\"../../images/print.gif\" name=\"delete\" height=\"22\" border=\"0\"></a></td>");
                                                %>
                                            </td>                                            
                                        </tr>
                                    </table>    
                                </td>
                            </tr>
                        </table>
                    </td>    
                    <td width="5%">&nbsp;</td>
                </tr>
            </table>
        </td>    
    </tr>
</table>    
