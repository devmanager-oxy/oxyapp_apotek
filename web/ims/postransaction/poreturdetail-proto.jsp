 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"><b>Transaction &raquo; <span class="level1">PO</span> 
                                      &raquo; <span class="level2">PO Retur</span></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">&nbsp;</td>
                                    <td width="19%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19">PO 
                                      Number </td>
                                    <td width="19%" height="19">PO001</td>
                                    <td width="10%" bgcolor="#F1FDEA" height="19">DO/Invoice 
                                      Number</td>
                                    <td width="56%" height="19">DO001</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19">PO 
                                      Date </td>
                                    <td width="19%" height="19">11/11/2008</td>
                                    <td width="10%" bgcolor="#F1FDEA" height="19">Incoming 
                                      Date </td>
                                    <td width="56%" height="19">10/11/2008</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap height="19">&nbsp;</td>
                                    <td width="19%" height="19">&nbsp;</td>
                                    <td width="10%" bgcolor="#F1FDEA" height="19">&nbsp;</td>
                                    <td width="56%" height="19">&nbsp;</td>
                                  </tr>
                                  <tr background="../images/line1.gif"> 
                                    <td colspan="4" nowrap bgcolor="#F1FDEA" height="3"></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19">Supplier</td>
                                    <td width="19%" height="19">Matahari</td>
                                    <td width="10%" height="19">Retur Number</td>
                                    <td width="56%" height="19"> <font color="#FF0000"> 
                                      <input type="text" name="textfield43" value="RT/1108/0001">
                                      otomatis readonly, pake cara yang di direct 
                                      incoming</font></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19">Address</td>
                                    <td width="19%" height="19">Jln. Dewi Sartika</td>
                                    <td width="10%" height="19">Retur Date </td>
                                    <td width="56%" height="19"> 
                                      <input type="text" name="textfield4">
                                      <font color="#FF0000">tanggal pake yang 
                                      javascript itu</font></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19">&nbsp;</td>
                                    <td width="19%" height="19">Denpasar, Bali</td>
                                    <td width="10%" height="19">Retur From</td>
                                    <td width="56%" height="19">
                                      <select name="select">
                                        <option selected>Gudang</option>
                                      </select>
                                      <font color="#FF0000">lokasi, ambil yang 
                                      tipenya gudang/warehouse</font> </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap height="19">&nbsp;</td>
                                    <td width="19%" height="19">&nbsp; </td>
                                    <td width="10%" height="19">&nbsp;</td>
                                    <td width="56%" height="19">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap height="19">Document 
                                      Status</td>
                                    <td width="19%" height="19"> 
                                      <select name="select8">
                                        <option selected>Draft</option>
                                        <option>Approved</option>
                                      </select>
                                    </td>
                                    <td width="10%" height="19"><font color="#FF0000"></font></td>
                                    <td width="56%" height="19">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" height="19">&nbsp;</td>
                                    <td colspan="3" height="19"><font color="#FF0000">saat 
                                      status approved, stock dikurang, jurnal 
                                      pengurangan AP dilakukan ke finance</font></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" height="19">Notes</td>
                                    <td colspan="3" height="19"> 
                                      <input type="text" name="textfield5" size="100">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><font color="#FF0000">Tampilkan 
                                      semua item pada incoming tanpa next prev 
                                      command</font></td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%"><font color="#FF0000">@price 
                                      diambil dari harga Item incoming</font></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" rowspan="2" width="3%">No</td>
                                          <td class="tablehdr" rowspan="2" width="21%">Item</td>
                                          <td class="tablehdr" rowspan="2" width="14%">Group</td>
                                          <td class="tablehdr" rowspan="2" width="15%">Category</td>
                                          <td class="tablehdr" colspan="3">QTY</td>
                                          <td class="tablehdr" rowspan="2" width="16%">Unit</td>
                                          <td class="tablehdr" rowspan="2" width="16%">Retur 
                                            @Price</td>
                                          <td class="tablehdr" rowspan="2" width="12%">Total 
                                            Retur </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablehdr" width="5%">Incoming</td>
                                          <td class="tablehdr" width="6%">Prev. 
                                            Retur</td>
                                          <td class="tablehdr" width="8%"> New 
                                            Retur</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="3%"> 
                                            <div align="center">1</div>
                                          </td>
                                          <td class="tablecell1" width="21%">AC 
                                            1Pk</td>
                                          <td class="tablecell1" width="14%">Air 
                                            Conditioner </td>
                                          <td class="tablecell1" width="15%">AC</td>
                                          <td class="tablecell1" width="5%"> 
                                            <div align="center">5</div>
                                          </td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center">2</div>
                                          </td>
                                          <td class="tablecell1" width="8%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield2" size="10" value="1">
                                            </div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center">Pcs</div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield34" value="4.000,000.-" style="text-align:right">
                                            </div>
                                          </td>
                                          <td class="tablecell1" width="12%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield3" value="4.000,000.-" style="text-align:right">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" width="3%"> 
                                            <div align="center">2</div>
                                          </td>
                                          <td class="tablecell" width="21%">Kulkas 
                                            National </td>
                                          <td class="tablecell" width="14%">Kulkas</td>
                                          <td class="tablecell" width="15%">Kulkas</td>
                                          <td class="tablecell" width="5%"> 
                                            <div align="center">1</div>
                                          </td>
                                          <td class="tablecell" width="6%"> 
                                            <div align="center">-</div>
                                          </td>
                                          <td class="tablecell" width="8%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield22" size="10" value="1">
                                            </div>
                                          </td>
                                          <td class="tablecell" width="16%"> 
                                            <div align="center">Pcs</div>
                                          </td>
                                          <td class="tablecell" width="16%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield35" value="10.000,000.-" style="text-align:right">
                                            </div>
                                          </td>
                                          <td class="tablecell" width="12%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield32" value="10.000,000.-" style="text-align:right">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="3%"> 
                                            <div align="center">3</div>
                                          </td>
                                          <td class="tablecell1" width="21%">Kursi</td>
                                          <td class="tablecell1" width="14%">Kursi</td>
                                          <td class="tablecell1" width="15%">Kursi</td>
                                          <td class="tablecell1" width="5%"> 
                                            <div align="center">5</div>
                                          </td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center">5</div>
                                          </td>
                                          <td class="tablecell1" width="8%"> 
                                            <div align="center">-</div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center">Pcs</div>
                                          </td>
                                          <td class="tablecell1" width="16%">&nbsp;</td>
                                          <td class="tablecell1" width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="3%"> 
                                            <div align="center">4</div>
                                          </td>
                                          <td class="tablecell1" width="21%">Almary</td>
                                          <td class="tablecell1" width="14%">Almary</td>
                                          <td class="tablecell1" width="15%">Almary</td>
                                          <td class="tablecell1" width="5%"> 
                                            <div align="center">2</div>
                                          </td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center">-</div>
                                          </td>
                                          <td class="tablecell1" width="8%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield222" size="10">
                                            </div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center">Pcs</div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield36" value="4.000,000.-" style="text-align:right">
                                            </div>
                                          </td>
                                          <td class="tablecell1" width="12%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield322" value="0" style="text-align:right">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" colspan="10" height="5"> 
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td rowspan="4" bgcolor="#CCCCCC"><font color="#FF0000">jika 
                                            sudah diretur semua, tidak bisa di 
                                            tambah new retur</font></td>
                                          <td rowspan="4" bgcolor="#CCCCCC"><font color="#FF0000">yang 
                                            disimpan ke retur item adalah item 
                                            yang new retur&gt;0</font> </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%" bgcolor="#CCCCCC"><font color="#FF0000">jumlah 
                                            semua dari total</font></td>
                                          <td width="16%" bgcolor="#CCCCCC"><b>Sub 
                                            Total :</b></td>
                                          <td width="12%" bgcolor="#CCCCCC"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield37" value="14.000,000.-" style="text-align:right" readOnly class="readOnly">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%" bgcolor="#CCCCCC"><font color="#FF0000">diambil 
                                            dari persentase di PO = sub total 
                                            * persentase</font></td>
                                          <td width="16%" bgcolor="#CCCCCC"><b>Discount 
                                            : 10%</b></td>
                                          <td width="12%" bgcolor="#CCCCCC"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield38" value="1.400.000,-" style="text-align:right" readOnly class="readOnly">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%" bgcolor="#CCCCCC"><font color="#FF0000">diambil 
                                            dari vat persentase dr PO = (subtotal 
                                            - discount) * persent</font></td>
                                          <td width="16%" bgcolor="#CCCCCC"><b>PPN/VAT 
                                            : 10%</b></td>
                                          <td width="12%" bgcolor="#CCCCCC"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield39" value="1.260,000.-" style="text-align:right" readOnly class="readOnly">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%" bgcolor="#CCCCCC"><font color="#FF0000">=subtotal 
                                            - discount + vat</font></td>
                                          <td width="16%" bgcolor="#CCCCCC"> 
                                            <div align="left"><b>T O T A L : </b></div>
                                          </td>
                                          <td width="12%" bgcolor="#CCCCCC"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield33" value="13.860,000.-" style="text-align:right" readOnly class="readOnly">
                                            </div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="5%">&nbsp;</td>
                                          <td width="6%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td colspan="3"><font color="#FF0000"><b>tolong 
                                            jalankan javascript agar semua bisa 
                                            jalan otomatis, lihat contoh incoming 
                                            direct </b></font></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="13"> 
                                      <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="5%"><img src="../images/success.gif" width="20" height="20"></td>
                                          <td width="38%"><a href="processprtopo.jsp">Save 
                                            retur Goods</a></td>
                                          <td width="26%"><img src="../images/cancel.gif" width="63" height="22"></td>
                                          <td width="31%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">&nbsp;</td>
                                    <td width="19%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">&nbsp;</td>
                                    <td width="19%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td valign="top"> 
                                <p>&nbsp;</p>
                                </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
