 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.coorp.member.*" %>

<%@ page import = "com.project.fms.report.*" %>

<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksp.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->

<%

String str = "5044041090,1250000;"+
"5044041093,1388889;"+
"5044041099,833333;"+
"5044041100,833333;"+
"5044041103,1041667;"+
"5044041104,1000000;"+
"5044041106,1041667;"+
"5044041107,1250000;"+
"5044041112,1250000;"+
"5044041116,1388889;"+
"5044041119,1000000;"+
"5044041121,1041667;"+
"5044041128,1000000;"+
"5044041129,666667;"+
"5044041130,1250000;"+
"5044041131,1500000;"+
"5044041132,1500000;"+
"5044041133,1500000;"+
"5044041134,500000;"+
"5044041135,750000;"+
"5044041136,1000000;"+
"5044041139,1250000;"+
"5044041142,750000;"+
"5044041143,1250000;"+
"5044041145,3750000;"+
"5044041147,1000000;"+
"5044041149,1250000;"+
"5044041150,1111111;"+
"5044041151,1875000;"+
"504404416783022802,500000;"+
"5044041154,1250000;"+
"5044041155,1250000;"+
"5044041156,500000;"+
"5044041160,1250000;"+
"5044041157,1250000;"+
"5044041158,750000;"+
"5044041163,1250000;"+
"5044041164,2000000;"+
"5044041166,1041667;"+
"5044041167,1250000;"+
"5044041168,625000;"+
"5044041177,500000;"+
"5044041179,1250000;"+
"5044041181,833333;"+
"5044041182,1250000;"+
"5044041183,750000;"+
"5044041185,833333;"+
"5044041186,1250000;"+
"5044041187,750000;"+
"5044041188,1250000;"+
"5044041189,1250000;"+
"5044041191,1250000;"+
"5044041192,1250000;"+
"5044041193,1041667;"+
"5044041195,1250000;"+
"5044041196,2083334;"+
"5044041198,1388889;"+
"5044041199,1250000;"+
"5044041201,1250000;"+
"5044041202,1041667;"+
"5044041203,1250000;"+
"5044041204,416667;"+
"5044041206,2000000;"+
"5044041207,2000000;"+
"5044041210,1388889;"+
"5044041211,750000;"+
"5044041212,2083333;"+
"5044041213,1500000;"+
"5044041215,300000;"+
"504404416856418473,1500000;"+
"5044041217,1500000;"+
"5044041219,1388889;"+
"5044041220,2000000;"+
"5044041222,500000;"+
"5044041223,1250000;"+
"5044041224,1041667;"+
"5044041226,1250000;"+
"5044041227,416667;"+
"5044041231,1250000;"+
"5044041232,1250000;"+
"5044041233,750000;"+
"5044041237,1000000;"+
"5044041240,1041667;"+
"5044041241,1388889;"+
"5044041242,1250000;"+
"5044041243,875000;"+
"5044041247,833333;"+
"5044041249,1041667;"+
"5044041250,1500000;"+
"5044041251,1041667;"+
"5044041252,500000;"+
"5044041253,1250000;"+
"5044041254,1250000;"+
"5044041256,1000000;"+
"5044041257,1250000;"+
"5044041259,1250000;"+
"5044041260,1250000;"+
"5044041261,625000;"+
"5044041262,1250000;"+
"5044041263,500000;"+
"5044041264,1000000;"+
"5044041267,1041667;"+
"5044041266,1250000;"+
"5044041268,1250000;"+
"5044041270,1250000;"+
"5044041271,1041667;"+
"5044041272,1500000;"+
"5044041276,750000;"+
"5044041278,833333;"+
"5044041279,750000;"+
"5044041280,500000;"+
"5044041281,750000;"+
"504404416791408395,1250000;"+
"5044041283,825000;"+
"5044041284,1250000;"+
"5044041286,750000;"+
"5044041287,2555556;"+
"5044041291,1388889;"+
"5044041293,625000;"+
"5044041294,1250000;"+
"5044041298,1000000;"+
"5044041299,1250000;"+
"5044041300,1500000;"+
"5044041301,1500000;"+
"5044041302,3000000;"+
"5044041303,1449652;"+
"5044041305,1250000;"+
"5044041308,5000000;"+
"5044041316,1388889;"+
"5044041317,1250000;"+
"5044041318,1250000;"+
"5044041319,1250000;"+
"5044041323,1041667;"+
"5044041324,1041667;"+
"5044041326,600000;"+
"5044041335,277778;"+
"5044041337,1500000;"+
"5044041416,1250000;"+
"5044041343,1250000;"+
"5044041351,1000000;"+
"5044041366,1388889;"+
"5044041387,1388889;"+
"504404416786214489,1388889;"+
"5044041096,1000000;"+
"5044041097,1041667;"+
"5044041098,1250000;"+
"5044041105,1666667;"+
"5044041120,1111111;"+
"5044041137,1250000;"+
"5044041138,2000000;"+
"5044041141,750000;"+
"5044041144,1041667;"+
"5044041148,1250000;"+
"5044041153,1250000;"+
"5044041162,500000;"+
"5044041165,1041667;"+
"5044041170,1250000;"+
"5044041171,1360832;"+
"5044041175,500000;"+
"5044041190,1041667;"+
"5044041209,1250000;"+
"5044041221,1250000;"+
"5044041230,1250000;"+
"5044041236,1250000;"+
"5044041238,1388889;"+
"5044041239,1388889;"+
"5044041244,1250000;"+
"5044041245,1611111;"+
"5044041269,1041667;"+
"5044041274,1250000;"+
"5044041277,1250000;"+
"5044041297,1250000;"+
"5044041304,1250000;"+
"5044041412,500000;"+
"5044041074,1041667;"+
"5044041313,1388889;"+
"5044041109,1000000;"+
"5044041127,1250000;"+
"5044041312,750000;"+
"5044041265,0;"+
"5044041285,1666666;"+
"5044041353,500000;"+
"5044041401,2777776;"+
"5044041172,1500000;"+
"5044041184,1250000;"+
"5044041248,1250000;"+
"5044041275,1250000;"+
"5044041290,1250000;"+
"5044041292,833333;"+
"5044041296,1250000;"+
"504404416794621145,500000;"+
"5044041001,250000;"+
"5044041002,100000;"+
"5044041003,250000;"+
"5044041004,500000;"+
"5044041005,250000;"+
"5044041006,500000;"+
"5044041007,375000;"+
"5044041008,250000;"+
"5044041009,250000;"+
"5044041010,250000;"+
"5044041011,500000;"+
"5044041012,250000;"+
"5044041013,250000;"+
"5044041014,200000;"+
"5044041015,0;"+
"5044041016,500000;"+
"5044041017,150000;"+
"5044041018,416666;"+
"5044041020,833333;"+
"5044041021,350000;"+
"5044041022,150000;"+
"5044041023,500000;"+
"5044041024,500000;"+
"5044041025,500000;"+
"5044041026,500000;"+
"5044041027,100000;"+
"5044041028,500000;"+
"5044041031,300000;"+
"5044041032,1000000;"+
"5044041034,416667;"+
"5044041035,3000000;"+
"5044041036,1000000;"+
"5044041037,1000000;"+
"5044041038,500000;"+
"5044041039,500000;"+
"5044041040,500000;"+
"5044041042,416666;"+
"5044041043,350000;"+
"5044041045,1000000;"+
"5044041046,500000;"+
"5044041047,2000000;"+
"5044041048,500000;"+
"5044041049,500000;"+
"5044041050,500000;"+
"5044041051,416666;"+
"5044041052,500000;"+
"504404416789874989,500000;"+
"5044041055,500000;"+
"5044041057,500000;"+
"5044041059,500000;"+
"5044041060,500000;"+
"504404416784531302,416666;"+
"5044041063,1000000;"+
"5044041064,1250000;"+
"5044041066,350000;"+
"5044041070,500000;"+
"5044041076,416666;"+
"5044041077,24000000;"+
"5044041078,500000;"+
"5044041079,1000000;"+
"5044041080,200000;"+
"5044041081,1000000;"+
"5044041082,0;"+
"5044041083,200000;"+
"5044041084,250000;"+
"5044041086,416666;"+
"504404416790986958,250000;"+
"5044041088,250000;"+
"5044041089,1249998;"+
"504404416788007458,416666;"+
"5044041101,250000;"+
"5044041108,500000;"+
"5044041110,250000;"+
"5044041111,500000;"+
"5044041114,500000;"+
"5044041115,250000;"+
"5044041118,200000;"+
"5044041124,500000;"+
"5044041140,500000;"+
"5044041152,1000000;"+
"5044041214,3300000;"+
"5044041229,1000000;"+
"5044041357,200000;"+
"5044041348,200000;"+
"5044041339,250000;"+
"5044041421,500000;"+
"5044041355,200000;"+
"5044041334,200000;"+
"5044041398,200000;"+
"5044041385,100000;"+
"5044041334,200000;"+
"5044041354,200000;"+
"5044041368,200000;"+
"5044041338,200000;"+
"5044041402,200000;"+
"5044041415,200000;"+
"5044041408,200000;"+
"5044041414,125000;"+
"5044041410,285714;"+
"5044041358,200000;"+
"5044041352,200000;"+
"5044041382,200000;"+
"5044041356,200000;"+
"5044041327,200000;"+
"5044041394,222222;"+
"5044041400,200000;"+
"5044041396,200000;"+
"5044041342,200000;"+
"5044041346,200000;"+
"5044041273,200000;"+
"5044041380,200000;"+
"5044041431,200000;"+
"5044041340,200000;"+
"5044041427,200000;"+
"5044041409,500000;"+
"504404417391381958,200000;"+
"5044041413,200000;"+
"5044041391,100000;"+
"5044041310,734333;"+
"5044041309,416667;"+
"5044041419,483453;"+
"5044041420,250000;"+
"5044041363,166667;"+
"5044041388,166667;"+
"5044041389,500000;"+
"5044041364,416667;"+
"5044041403,333333;"+
"5044041369,291667;"+
"5044041395,500000;"+
"5044041330,225000;"+
"5044041365,250000;"+
"5044041333,416667;"+
"5044041321,250000;"+
"5044041362,500000;"+
"5044041306,916667;"+
"5044041386,312500;"+
"5044041208,416667;"+
"5044041314,500000;"+
"5044041422,200000;"+
"5044041341,416667;"+
"5044041372,291667;"+
"5044041393,166667;"+
"5044041397,266667;"+
"504404416782915880,250000;"+
"504404417812641066,500000;"+
"5044041381,200000;"+
"504404417490087505,500000;"+
"5044041378,133333;"+
"5044041374,200000;"+
"5044041370,333333;"+
"5044041377,200000;"+
"5044041345,150000;"+
"5044041371,200000;"+
"5044041384,100000;"+
"5044041425,200000;"+
"5044041329,200000;"+
"5044041368,200000;"+
"5044041379,200000;"+
"5044041347,200000;"+
"5044041328,150000;"+
"5044041331,200000;"+
"5044041390,200000;"+
"5044041360,200000;"+
"5044041332,200000;"+
"5044041350,100000;"+
"5044041433,5666667;"+
"5044041434,34556119;"+
"504404417483541395,92000000;";



int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

if(iJSPCommand==JSPCommand.START){

	StringTokenizer strTok = new StringTokenizer(str, ";");
	Vector result = new Vector();
	while(strTok.hasMoreTokens()){
		result.add((String)strTok.nextToken());
	}
	
	System.out.println("result : "+result);

	for(int i=0; i<result.size(); i++){
		String strx = (String)result.get(i);
		StringTokenizer strTokx = new StringTokenizer(strx, ",");
		Vector resultx = new Vector();
		while(strTokx.hasMoreTokens()){
			resultx.add((String)strTokx.nextToken());
		}
		
		System.out.println("resultx : "+resultx);
		
		long oidPinjaman = Long.parseLong((String)resultx.get(0));
		double bayar = Double.parseDouble((String)resultx.get(1));
		
		try{
			Pinjaman pinjaman = DbPinjaman.fetchExc(oidPinjaman);
			
			if(oidPinjaman!=0 && bayar!=0){
				Vector temp = DbPinjamanDetail.list(0,1, "pinjaman_id="+oidPinjaman+" and status=0", "jatuh_tempo asc");
				if(temp!=null && temp.size()>0){
					PinjamanDetail pd = (PinjamanDetail)temp.get(0);
					DbBayarPinjaman.insertAndPostPaymentAutoWOJurnal(pinjaman, pd);					
					pd.setStatus(1);
					DbPinjamanDetail.updateExc(pd);
				}
			}
		}
		catch(Exception e){
		}
		
	}
	
}



%>
<html ><!-- #BeginTemplate "/Templates/indexsp.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript"> 

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptPinjamanAnggotaXLS?idx=<%=System.currentTimeMillis()%>");
}

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

function checkNumber1(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = result;//formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdStartIt(){
	document.frmpinjaman.command.value="<%=JSPCommand.START%>";
	document.frmpinjaman.action="a-start-data-bayar-nov.jsp";
	document.frmpinjaman.submit();
}

function cmdUpdateTanggal(oid){
	document.frmpinjaman.hidden_pinjaman_id.value="0";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oid;
	document.frmpinjaman.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}



function cmdAdd(){
	document.frmpinjaman.hidden_pinjaman_id.value="0";
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdAsk(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.ASK%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdConfirmDelete(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.DELETE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}
function cmdSave(){
	document.frmpinjaman.command.value="<%=JSPCommand.SAVE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdEdit(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdCancel(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdBack(){
	document.frmpinjaman.command.value="<%=JSPCommand.BACK%>";
	//document.frmpinjaman.action="<%=approot%>/home.jsp?menu_idx=0";
	document.frmpinjaman.action="arsippinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListFirst(){
	document.frmpinjaman.command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListPrev(){
	document.frmpinjaman.command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListNext(){
	document.frmpinjaman.command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListLast(){
	document.frmpinjaman.command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function getMember(){
	window.open("scrmember.jsp","srcmember","scrollbars=yes,height=400,width=800,addressbar=no,menubar=no,toolbar=no,location=no,");
}

//-------------- script control line -------------------
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Pinjaman Koperasi 
                        
                        <br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpinjaman" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container">
                                <input type="button" name="Button" value="Start" onClick="javascript:cmdStartIt()">
                              </td>
                            </tr>
                          </table>
                        </form>
						
                        <!-- #EndEditable -->
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
