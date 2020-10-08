<%@ page import="com.project.system.*"%><%@ page import="com.project.general.Currency"%><%@ page import="com.project.general.DbCurrency"%>
<%@ page import="com.project.fms.master.*"%><%@ page import="com.project.payroll.*"%>
<%@ page import="com.project.general.DbLocation"%><%@ page import="com.project.general.Location"%>
<%@ page import="com.project.main.db.*"%> <%@ include file="../../javainit-root.jsp"%>
<%     
    String approot = rootapproot +"/fin";    
    String imageroot = rootimageroot+"/fin/"; 
    String printroot = rootprintroot + "/servlet/com.project.fms";  
    String printrootinv= rootprintrootinv+"/servlet/com.project.ccs";
    String approotx = rootapprootx + "";
    
    boolean gereja = DbSystemProperty.getModSysPropGereja();    
    String transactionFolder = "";
    
    if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_COMMON){
        transactionFolder = "transaction";
    } else if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_RETAIL){
        transactionFolder = "transactionact";
    } else if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) {
        transactionFolder = "transactionngo";
    }
    
    int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");   
    Currency baseCurrency = new Currency();
    Location sysLocation = new Location();    
    try{
	baseCurrency = DbCurrency.getCurrencyById(sysCompany.getBookingCurrencyId());
    }catch(Exception e){    System.out.println("Exc get currency : "+e.toString()); response.sendRedirect(approot+"/index.jsp");  }
    
    try{
	sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());
    }catch(Exception e){    System.out.println("Exc get location : "+e.toString()); response.sendRedirect(approot+"/index.jsp"); }
    
    String baseCurrencyCode = baseCurrency.getCurrencyCode();        
    boolean isPostableOnly = false;
    String IDRCODE = "IDR"; String USDCODE = "USD"; String EURCODE = "EUR"; String CURRFORMAT = "#,###";    
    
    try{
	IDRCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR"); USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
	EURCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_EUR"); CURRFORMAT = DbSystemProperty.getValueByName("CURR_FORMAT");
	String postableOnly = DbSystemProperty.getValueByName("ACCOUNT_POSTABLE_ONLY");
	if(postableOnly.equals("Y")){ isPostableOnly = true; }	
    }catch(Exception e){	
	IDRCODE = "IDR"; USDCODE = "USD"; EURCODE = "EUR"; CURRFORMAT = "#,###"; isPostableOnly = false;
    }
    boolean isYearlyClose = false;
    Periode currentOpen = DbPeriode.getPreClosedPeriod();
    if(currentOpen.getOID()==0){ currentOpen = DbPeriode.getOpenPeriod();}
    java.util.Date currentStart = currentOpen.getEndDate();
    boolean applyActivity = (DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y") ? true : false;
    if(sysCompany.getEndFiscalMonth()==currentStart.getMonth()){
        isYearlyClose = true;
    }
%>
    <script language=JavaScript src="<%=approot%>/main/common.js"></script>