<%@ page import="com.project.general.Company"%>
<%@ page import="com.project.general.DbCompany"%>
<%@ page import="com.project.main.db.*"%>
<%  
    String rootSystemTitle = "OxySystem";    
    String rootapproot="/oxyapp_apotek";
    String rootimageroot ="/oxyapp_apotek/";
    String rootprintroot="/oxyapp_apotek";
    String rootprintrootinv="/oxyapp_apotek";
    String rootapprootx = "/oxyapp_apotek";
    String rootprintroot2 = "/oxyapp_apotek";
    String rootprintrootproperty="/oxyapp_apotek";
    String rootLogout = "/oxyapp_apotek";
    
    String systemTitle  = "Finance System";      
    String spTitle      = "Simpan Pinjam";
    String titleSP      = "Sipadu Pengadaan"; 
    String titleIS      = "Retail System"; 
    String salesSt      = "Sales System"; 
    String titleService = "Service System";
    String titleSimpro  = "Property System";
    
    String sSystemDecimalSymbol = ".";  
    String sUserDecimalSymbol   = ".";    
    String sUserDigitGroup 	= ",";
    
    boolean includeActivity     = true;            
    boolean isSystemActive = CONHandler.isSystemLicenseActive();
    
    final int LANG_EN = 1; 
    final int LANG_ID = 2;
    int lang = 0;
    
    String strLang = "";
    if(session.getValue("APP_LANG") != null) {
        strLang = String.valueOf(session.getValue("APP_LANG"));
        lang = Integer.parseInt(strLang);
    } else lang = 2;
    
    Company sysCompany = new Company();
    try{
	sysCompany = DbCompany.getCompany();
    }catch(Exception e){ System.out.println("Exc get company : "+e.toString()); response.sendRedirect(rootapproot+"/index.jsp"); }    
    
    String appxTitle = "OxySystem";    
    String formNumbComp = "#,##0";        
    int INVENTORY_NON_MULTY_CURRENCY = 0;
    int INVENTORY_MULTY_CURRENCY = 1;
    
    int inventory_type = INVENTORY_MULTY_CURRENCY;
    
%>
