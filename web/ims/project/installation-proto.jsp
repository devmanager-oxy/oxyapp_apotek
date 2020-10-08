 
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
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Project</span><span class="level1"></span> 
                        &raquo; <span class="level2">Installation<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td>&nbsp; </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <tr > 
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                    <td class="tabin" nowrap><a href="newproject-proto.jsp" class="tablink">Project 
                                      Detail</a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tabin" nowrap> <a href="newproductdetail-proto.jsp" class="tablink">Product 
                                      Detail</a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabin" nowrap><a href="newproject-proto.jsp" class="tablink">Payment 
                                      Term </a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td class="tabin" nowrap><a href="#" class="tablink">Order Confirmation </a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tab" nowrap>Installation 
                                      Order</td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tabin" nowrap><a href="#" class="tablink">Closing</a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                      </font></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp; </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%"><b>Project Number</b></td>
                                          <td width="22%"> PNC/PPJ/0908001</td>
                                          <td width="8%"><b>Customer</b></td>
                                          <td width="60%">PT. Maju Mundur</td>
                                        </tr>
                                        <tr> 
                                          <td height="14" width="10%"><b>Project 
                                            Name</b></td>
                                          <td height="14" width="22%"> Pemasangan 
                                            Septic Tank</td>
                                          <td height="14" width="8%">&nbsp;</td>
                                          <td width="60%">Jln. Gunung Agung 20a, 
                                            Denpasar</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td class="tablehdr" width="2%">No</td>
                                                <td class="tablehdr" width="9%">Location</td>
                                                <td class="tablehdr" width="11%">Address</td>
                                                <td class="tablehdr" width="9%"> 
                                                  Start</td>
                                                <td class="tablehdr" width="10%"> 
                                                  End</td>
                                                <td class="tablehdr" width="14%">Duration</td>
                                                <td class="tablehdr" width="14%">PIC</td>
                                                <td class="tablehdr" width="9%">Budget<br>
                                                  Status</td>
                                                <td class="tablehdr" width="9%">Installation 
                                                  <br>
                                                  Status</td>
                                              </tr>
                                              <tr> 
                                                <td width="2%" class="tablecell1"> 
                                                  <div align="center">1</div>
                                                </td>
                                                <td width="9%" class="tablecell1"><a href="#">Lombok</a></td>
                                                <td width="11%" class="tablecell1">Jln. 
                                                  Lombok Tengah ... </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">20 Jan 2008</div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="center">27 Jan 2008</div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="center">7 Days </div>
                                                </td>
                                                <td width="14%" class="tablecell1">Made 
                                                  Suar </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">Approved</div>
                                                </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">Finish</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="2%" class="tablecell"> 
                                                  <div align="center">2</div>
                                                </td>
                                                <td width="9%" class="tablecell"><a href="#">Lombok</a></td>
                                                <td width="11%" class="tablecell">Jln. 
                                                  Lombok Tengah</td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">1 Feb 2008</div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center">10 Feb 2008</div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="center">10 Days 
                                                  </div>
                                                </td>
                                                <td width="14%" class="tablecell">Made 
                                                  Suar </td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">Approved</div>
                                                </td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">Finish</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="2%" class="tablecell1"> 
                                                  <div align="center">3</div>
                                                </td>
                                                <td width="9%" class="tablecell1"><a href="#">Lombok</a></td>
                                                <td width="11%" class="tablecell1">Jln. 
                                                  Lombok Tengah</td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">30 Juni 
                                                    2008 </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="center">10 Juli 
                                                    2008 </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="14%" class="tablecell1">Made 
                                                  Suar </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">Approved</div>
                                                </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center">In Progress</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="2%" class="tablecell"> 
                                                  <div align="center">4</div>
                                                </td>
                                                <td width="9%" class="tablecell"><a href="#">Lombok</a></td>
                                                <td width="11%" class="tablecell">Jln. 
                                                  Lombok Tengah</td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">20 Agustus 
                                                    2008 </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center">30 Agustus 
                                                    2008 </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="14%" class="tablecell">Made 
                                                  Suar</td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">To Approve</div>
                                                </td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center">-</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="2%" class="tablecell1"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="9%" class="tablecell1">&nbsp;</td>
                                                <td width="11%" class="tablecell1">&nbsp;</td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="14%" class="tablecell1">&nbsp;</td>
                                                <td width="14%" class="tablecell1">&nbsp;</td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center"> </div>
                                                </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center"></div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td><a href="#"><img src="../images/add.gif" width="49" height="22" border="0"></a></td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%"><b>Installation Editor</b></td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Installation Location</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield">
                                          </td>
                                          <td width="8%">Start Date</td>
                                          <td width="60%"> 
                                            <input type="text" name="textfield3">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Address</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield2">
                                          </td>
                                          <td width="8%">End Date</td>
                                          <td width="60%"> 
                                            <input type="text" name="textfield4">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">PIC</td>
                                          <td width="22%"> 
                                            <select name="select">
                                              <option selected>Pegawai 1</option>
                                              <option>Pagawai 2</option>
                                              <option>Pegawai 3</option>
                                            </select>
                                          </td>
                                          <td width="8%">PIC Position</td>
                                          <td width="60%"> 
                                            <input type="text" name="textfield5">
                                            <font color="#FF0000">PIC dan PIC 
                                            Position di ambil dari data employee</font></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Status</td>
                                          <td width="22%"> 
                                            <select name="select6">
                                              <option selected>Draft</option>
                                              <option>In Progress</option>
                                              <option>Finish</option>
                                            </select>
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Description</td>
                                          <td colspan="3"> 
                                            <textarea name="textfield8" rows="2" cols="100"></textarea>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="4">
                                            <table width="61%" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td width="13%"><img src="../images/save.gif" width="55" height="22"></td>
                                                <td width="24%" nowrap><img src="../images/print.gif" width="53" height="22">installation 
                                                  order </td>
                                                <td width="25%" nowrap>&nbsp;</td>
                                                <td width="19%">&nbsp;</td>
                                                <td width="19%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><font color="#FF0000">- 
                                            tab budget propose dll dibawah muncul 
                                            setelah oid != 0<br>
                                            - print installation order isinya 
                                            instalaltion data diatas dengan product 
                                            list dibawah, 2 approval Supervisor, 
                                            dan Customer, akan dibawa untuk install 
                                            ke client, status instalasi ditentukan 
                                            oleh ini,<br>
                                            </font></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <td class="tab" nowrap><font color="#000000">Budget 
                                                  Proposed</font></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <td class="tabin" nowrap> <a href="installationproduct-proto.jsp" class="tablink"> 
                                                  Product </a></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <td nowrap class="tabheader"></td>
                                                <td class="tabin" nowrap><a href="intallationcost-proto.jsp" class="tablink">Resources 
                                                  </a></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <td class="tabin" nowrap><a href="intallationcost-proto.jsp" class="tablink">Real 
                                                  Cost</a></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                                  jika status finish, baru bisa 
                                                  input cost</font></td>
                                              </tr>
                                              <tr > 
                                                <td class="page1" colspan="13"> 
                                                  <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="60%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="4%" class="tablehdr" height="18">No</td>
                                                            <td width="27%" class="tablehdr" height="18">Type</td>
                                                            <td width="40%" class="tablehdr" height="18">Description</td>
                                                            <td width="29%" class="tablehdr" height="18">Amount</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%">1</td>
                                                            <td width="27%">Transport</td>
                                                            <td width="40%">Perjalanan 
                                                              pulang pergi dari 
                                                              Bali ke Lombok</td>
                                                            <td width="29%"> 
                                                              <div align="right">5.000.000,-</div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%">2</td>
                                                            <td width="27%">Meals</td>
                                                            <td width="40%">Makan 
                                                              selama seminggu 
                                                              pada lokasi</td>
                                                            <td width="29%"> 
                                                              <div align="right">1.000.000,-</div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%">3</td>
                                                            <td width="27%">Hotel</td>
                                                            <td width="40%">Tempat 
                                                              menginap</td>
                                                            <td width="29%"> 
                                                              <div align="right">4.000.000,-</div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%">4</td>
                                                            <td width="27%"> 
                                                              <select name="select2">
                                                                <option>Transport</option>
                                                                <option>Meals</option>
                                                                <option>Hotel</option>
                                                                <option selected>Spare 
                                                                Part</option>
                                                                <option>Other</option>
                                                              </select>
                                                            </td>
                                                            <td width="40%"> 
                                                              <input type="text" name="textfield6">
                                                            </td>
                                                            <td width="29%"> 
                                                              <div align="right"> 
                                                                <input type="text" name="textfield7">
                                                              </div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%">&nbsp;</td>
                                                            <td width="27%">&nbsp;</td>
                                                            <td width="40%">&nbsp;</td>
                                                            <td width="29%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="4%" class="tablecell">&nbsp;</td>
                                                            <td width="27%" class="tablecell">&nbsp;</td>
                                                            <td width="40%" class="tablecell"> 
                                                              <div align="center">T 
                                                                O T A L : </div>
                                                            </td>
                                                            <td width="29%" class="tablecell"> 
                                                              <div align="right">10.000.000,-</div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="11%">&nbsp;</td>
                                                            <td width="10%">&nbsp;</td>
                                                            <td width="73%">&nbsp;</td>
                                                            <td width="1%">&nbsp;</td>
                                                            <td width="5%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="11%"><img src="../images/add.gif" width="49" height="22"></td>
                                                            <td width="10%"><img src="../images/save.gif" width="55" height="22"></td>
                                                            <td width="73%">&nbsp;</td>
                                                            <td width="1%">&nbsp;</td>
                                                            <td width="5%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="80%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="23%" nowrap>Check 
                                                              Request Status</td>
                                                            <td width="26%"> 
                                                              <select name="select4">
                                                                <option selected>Draft</option>
                                                                <option>To Be 
                                                                Approved</option>
                                                                <option>Approved</option>
                                                              </select>
                                                            </td>
                                                            <td width="47%"><font color="#FF0000">Draft 
                                                              : baru dibuat, To 
                                                              Approve : diapprove 
                                                              supervisor, Approved 
                                                              : Finance approval</font></td>
                                                            <td width="2%">&nbsp;</td>
                                                            <td width="2%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="23%">&nbsp;</td>
                                                            <td width="26%">&nbsp;</td>
                                                            <td width="47%">&nbsp;</td>
                                                            <td width="2%">&nbsp;</td>
                                                            <td width="2%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="23%"><img src="../images/save.gif" width="55" height="22">update 
                                                              Status </td>
                                                            <td width="26%"><img src="../images/print.gif" width="53" height="22">Check 
                                                              Request </td>
                                                            <td width="47%">&nbsp;</td>
                                                            <td width="2%">&nbsp;</td>
                                                            <td width="2%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td class="tablecell"><b>Approval</b></td>
                                                            <td class="tablecell"><b>Date</b></td>
                                                            <td class="tablecell"><b>By</b></td>
                                                          </tr>
                                                          <tr> 
                                                            <td class="tablecell1">Draft</td>
                                                            <td class="tablecell1">20 
                                                              Januari 2008</td>
                                                            <td class="tablecell1">Komang</td>
                                                          </tr>
                                                          <tr> 
                                                            <td class="tablecell1">Approve 
                                                              By </td>
                                                            <td class="tablecell1">21 
                                                              Januari 2008</td>
                                                            <td class="tablecell1">Made 
                                                              Suar</td>
                                                          </tr>
                                                          <tr> 
                                                            <td class="tablecell1">Check 
                                                              By</td>
                                                            <td class="tablecell1">23 
                                                              Januari 2008</td>
                                                            <td class="tablecell1">DW</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <p><font color="#FF0000">1. 
                                                          Type berupa tabel master 
                                                          expense type untuk link 
                                                          ke finance system yang 
                                                          isinya :</font></p>
                                                        <p><font color="#FF0000">- 
                                                          Name</font></p>
                                                        <p><font color="#FF0000">- 
                                                          Account Number</font></p>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td><font color="#FF0000">2. 
                                                        jika status tidak draf, 
                                                        tidak bisa tambah data 
                                                        lagi, approval history 
                                                        otomatis sesuai user yang 
                                                        di approve</font></td>
                                                    </tr>
                                                    <tr> 
                                                      <td><font color="#FF0000">3. 
                                                        print : - 3 approval - 
                                                        Prepared By, Approve By, 
                                                        Check By</font></td>
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
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><b></b></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
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
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp; </td>
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
