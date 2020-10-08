
<%@ page import="com.project.admin.*"%>
<%@ include file="../../check-root.jsp"%>
<%
            if (appSessUser == null) {
                appSessUser = new QrUserSession();
            }
            
            long systemCompanyId = 0;            
            boolean mSalUploadSales = false; boolean mSalOpening = false; boolean mSalNewSales = false; boolean mSalNewArchives = false;
            boolean mSalCreditPayment = false; boolean mSalClosing = false;boolean mSalMaster = false;
            
            boolean mSalReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT);
            boolean mSalReportLocation = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_LOCATION);
            boolean mSalReportCashier = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_CASHIER);
            boolean mSalReportMember = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_MEMBER);
            boolean mSalCreditPaymentReport = false;
            boolean mSalReportSalesCanceled = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_CANCELED);
            boolean mSalReportSalesRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_RETUR);   
            boolean mSalReportSalesCategory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_CATEGORY);
            boolean mSalReportKonsinyasiBeli = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI);
            boolean mSalReportKonsinyasiJual = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL);
                                          
            boolean mSalReportSalesClosing = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_CLOSING);
            boolean mSalReportSalesMonthly = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_MONTHLY);
            
            boolean mSalReportByItem = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_ITEM);
            boolean mSalReportBeliPutus = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BELI_PUTUS);
            boolean mSalReportMargin = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_MARGIN);
            boolean mSalReportCogsSection = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_COGS_BY_SECTION);
            boolean mSalReportGolPrice = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_BY_GOL_PRICE);
            boolean mSalReportPromotion = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_PROMOTION);
            boolean mSalReporBySuplier = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_BY_SUPLIER);
            boolean mSalReporSlowFast = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SLOW_FAST_MOVING);
            boolean mSalReporKomisi = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KOMISI);
            boolean mSalReporGA = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_GA);
            boolean mSalReporSetoran = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SETORAN);
            boolean mSalReporCreditCard = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_CREDIT_CARD);
            boolean mSalReporTopSales = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_TOP_SALES);
            boolean mSalByStartDate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_START_DATE);
            boolean mSalVoidReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_VOID_REPORT);
            boolean mSalBonus = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_BONUS);
            
            boolean mSalAccounting = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL);
            boolean mSalJurRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL_RETUR);            
            boolean mSalEditor = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_EDITOR_CC); 
            boolean mSalJournalCashBack = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK); 
%>
