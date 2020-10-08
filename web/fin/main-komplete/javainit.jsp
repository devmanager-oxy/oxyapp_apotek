<%@ page import="com.project.system.*"%>
<%@ page import="com.project.general.Currency"%>
<%@ page import="com.project.general.DbCurrency"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.payroll.*"%>

<%@ page import="com.project.general.Company"%>
<%@ page import="com.project.general.DbCompany"%>
<%@ page import="com.project.general.DbLocation"%>
<%@ page import="com.project.general.Location"%>
<%@ page import="com.project.main.db.*"%>
<% 

boolean isSystemActive = CONHandler.isSystemLicenseActive();

//offline
String approot="/sipadu-fin";
String imageroot ="/sipadu-fin/";
String printroot="/sipadu-fin/servlet/com.project.fms";
String printrootsp="/sipadu-fin/servlet/com.project.coorp";
String printrootinv="/sipadu-fin/servlet/com.project.ccs";

//String approotx = "http://192.168.0.2:8080";
String approotx = "http://localhost:8080";

String systemTitle = "Finance System";
String spTitle = "Simpan Pinjam";


String sSystemDecimalSymbol = ".";
String sUserDecimalSymbol 	= ".";
String sUserDigitGroup 	= ",";

int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");

boolean includeActivity = true;//((DbSystemProperty.getValueByName("APPLAY_ACTIVITY").equals("Y")) ? true : false);

Company sysCompany = new Company();
Currency baseCurrency = new Currency();
Location sysLocation = new Location();

try{
	sysCompany = DbCompany.getCompany();
}
catch(Exception e){
	System.out.println("Exc get company : "+e.toString());
	response.sendRedirect(approot+"/index.jsp");	
}

try{
	baseCurrency = DbCurrency.getCurrencyById(sysCompany.getBookingCurrencyId());
}
catch(Exception e){
	System.out.println("Exc get currency : "+e.toString());
	response.sendRedirect(approot+"/index.jsp");	
}

try{
	sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());
}
catch(Exception e){
	System.out.println("Exc get location : "+e.toString());
	response.sendRedirect(approot+"/index.jsp");	
}

//load system property
String baseCurrencyCode = baseCurrency.getCurrencyCode();

String IDRCODE = "IDR";
String USDCODE = "USD";
String EURCODE = "EUR";
boolean isPostableOnly = false;
try{
	IDRCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
	USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
	EURCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_EUR");
	String postableOnly = DbSystemProperty.getValueByName("ACCOUNT_POSTABLE_ONLY");
	if(postableOnly.equals("Y")){
		isPostableOnly = true;
	}	
}
catch(Exception e){
	System.out.println("Exc get currency code : --- "+e.toString());
	IDRCODE = "IDR";
	USDCODE = "USD";
	EURCODE = "EUR";
	isPostableOnly = false;
}

boolean isYearlyClose = false;
Periode currentOpen = DbPeriode.getOpenPeriod();
java.util.Date currentStart = currentOpen.getStartDate();

boolean applyActivity = (DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y") ? true : false;

//out.println("sysCompany.getEndFiscalMonth() : "+sysCompany.getEndFiscalMonth()+", currentStart.getMonth() : "+currentStart.getMonth() );

if(sysCompany.getEndFiscalMonth()==currentStart.getMonth()){
	isYearlyClose = true;
}

%>

<script language=JavaScript src="<%=approot%>/main/common.js"></script>





