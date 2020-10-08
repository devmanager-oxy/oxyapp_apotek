 
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
                                    <td width="15%">&nbsp;</td>
                                    <td width="19%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" nowrap bgcolor="#F1FDEA" height="19"><b>&nbsp;Request 
                                      by Department</b></td>
                                    <td width="19%" height="19">Human Resources</td>
                                    <td width="10%" bgcolor="#F1FDEA" height="19"><b>Number</b></td>
                                    <td width="56%" height="19">PR1108001</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" bgcolor="#F1FDEA" height="19"><b>&nbsp;Date</b></td>
                                    <td width="19%" height="19">10 January 2008</td>
                                    <td width="10%" bgcolor="#F1FDEA" height="19"><b>Status</b></td>
                                    <td width="56%" height="19"> APPROVED</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" bgcolor="#F1FDEA" height="19"><b>&nbsp;Notes</b></td>
                                    <td colspan="3" height="19"> Catatan pada 
                                      notes ...</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">&nbsp;</td>
                                    <td width="19%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="56%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" rowspan="2" width="3%">No</td>
                                          <td class="tablehdr" rowspan="2" width="21%">Item</td>
                                          <td class="tablehdr" rowspan="2" width="14%">Group</td>
                                          <td class="tablehdr" rowspan="2" width="15%">Category</td>
                                          <td class="tablehdr" colspan="4">QTY</td>
                                          <td class="tablehdr" rowspan="2" width="16%">Supplier</td>
                                          <td class="tablehdr" rowspan="2" width="12%">Last 
                                            Price</td>
                                        </tr>
                                        <tr>
                                          <td class="tablehdr" width="5%">Status</td>
                                          <td class="tablehdr" width="5%">PR</td>
                                          <td class="tablehdr" width="6%">Proceed</td>
                                          <td class="tablehdr" width="8%"> New 
                                            PO</td>
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
                                            <select name="select">
                                              <option selected>-</option>
                                              <option>Pending</option>
                                              <option>Refused</option>
                                            </select>
                                          </td>
                                          <td class="tablecell1" width="5%"> 
                                            <div align="center">5</div>
                                          </td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center">2</div>
                                          </td>
                                          <td class="tablecell1" width="8%"> 
                                            <div align="center"> 
                                              <input type="text" name="textfield2" size="10" value="2">
                                            </div>
                                          </td>
                                          <td class="tablecell1" width="16%"> 
                                            <div align="center"> 
                                              <select name="select2">
                                                <option>Tiara Dewata</option>
                                                <option>Matahari</option>
                                                <option selected>Courts</option>
                                                <option>Columbia</option>
                                              </select>
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
                                            <select name="select5">
                                              <option selected>-</option>
                                              <option>Pending</option>
                                              <option>Refused</option>
                                            </select>
                                          </td>
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
                                            <div align="center"> 
                                              <select name="select3">
                                                <option>Tiara Dewata</option>
                                                <option>Matahari</option>
                                                <option selected>Courts</option>
                                                <option>Columbia</option>
                                              </select>
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
                                          <td class="tablecell1" width="21%">Almary</td>
                                          <td class="tablecell1" width="14%">Almary</td>
                                          <td class="tablecell1" width="15%">Almary</td>
                                          <td class="tablecell1" width="5%">
                                            <select name="select6">
                                              <option>-</option>
                                              <option>Pending</option>
                                              <option selected>Refused</option>
                                            </select>
                                          </td>
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
                                            <div align="center"> 
                                              <select name="select4">
                                                <option>-</option>
                                                <option>Matahari</option>
                                                <option selected>Courts</option>
                                                <option>Columbia</option>
                                                <option>Tiara Dewata</option>
                                              </select>
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
                                          <td width="5%">&nbsp;</td>
                                          <td width="5%">&nbsp;</td>
                                          <td width="6%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%" bgcolor="#CCCCCC"> 
                                            <div align="right"><b>T O T A L : 
                                              </b></div>
                                          </td>
                                          <td width="12%" bgcolor="#CCCCCC"> 
                                            <input type="text" name="textfield33" value="14.000,000.-" style="text-align:right">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%">&nbsp;</td>
                                          <td width="21%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="5%">&nbsp;</td>
                                          <td width="5%">&nbsp;</td>
                                          <td width="6%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="13">
                                      <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="5%"><img src="../images/success.gif" width="20" height="20"></td>
                                          <td width="38%"><a href="processprtopo.jsp">Export 
                                            PR to PO</a></td>
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
                              <td>
                                <p><font color="#FF0000">catatan :</font></p>
                                <p><font color="#FF0000">- data detail diatas 
                                  dibuat ambil dari data PR yang di klik<br>
                                  - 1 PR bisa diexport menjadi beberapa PO<br>
                                  - qty-PR : qty pada PR, proceed :qty yang sudah 
                                  di PO, new PO qty yang akan di PO sekarang<br>
                                  - supplier diambil dari list supplier yang menjual 
                                  item - lihat di master<br>
                                  - last price : harga terakhir dari supplier 
                                  terhadap item tsb. otomatis berubah apabila 
                                  sipplier dirubah<br>
                                  - sekali melakukan export PR to PO bisa menjadi 
                                  beberapa PO tergantung jumlah supplier yang 
                                  dipilih. 1 PO 1 supplier<br>
                                  - item status bisa di set -,pending:di pending,refused:ditolak<br>
                                  - item yang di tolak tidak bisa di PO<br>
                                  - kalau item sudah pernah di beli, tidak bisa 
                                  di refused, bisa di pending<br>
                                  - kalau item semua sudah di PO, status PR di 
                                  CLOSED, item yang di Refused tidak dihitung.<br>
                                  <br>
                                  DATABASE :</font></p>
                                <p><font color="#FF0000">- tambahin kolom pada 
                                  table PR item, <br>
                                  yaitu : item_status int, proceed_qty int<br>
                                  <br>
                                  setiap melakukan proses, data ini diupdate</font></p>
                                <p>&nbsp;</p>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
                        Transaction 
                        &raquo; <span class="level1">PR</span> &raquo; <span class="level2">Export 
                        PR to PO<br>
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
