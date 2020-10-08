
<%@ page import="com.project.admin.*"%>
<%@ page import="com.project.fms.activity.*"%>
<%@ include file="../../check-root.jsp"%>
<%
            if (appSessUser == null) {
                appSessUser = new QrUserSession();
            }

//TRANSAKSI TUNAI
            boolean cashRecPriv = appSessUser.isCsRd(appSessUser.getUserOID());
            boolean cashRecAdPriv = appSessUser.isCsRa(appSessUser.getUserOID());
            boolean cashPPayPriv = appSessUser.isCsPP(appSessUser.getUserOID());
            boolean cashPayPriv = appSessUser.isCsP(appSessUser.getUserOID());
            boolean cashPPARriv = appSessUser.isCPPA(appSessUser.getUserOID());
            boolean cashPRPriv = appSessUser.isCPR(appSessUser.getUserOID());
            boolean cashRPPriv = appSessUser.isCRP(appSessUser.getUserOID());  //Cash post
            boolean cashArPriv = appSessUser.isCAR(appSessUser.getUserOID());
            boolean cashArcPriv = appSessUser.isCA(appSessUser.getUserOID());
            boolean advanceReimbPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_ADVANCE_REIMBURSEMENT);
            boolean cashsetoran = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR);


//TRANSAKSI BANK
            boolean bankDepPriv = appSessUser.isBDEP(appSessUser.getUserOID());
            boolean bankPOPriv = appSessUser.isBPO(appSessUser.getUserOID());
            boolean bankCpPriv = appSessUser.isBCP(appSessUser.getUserOID());
            boolean bankNonPriv = appSessUser.isBPNP(appSessUser.getUserOID());
            boolean bankPostPriv = appSessUser.isBPOS(appSessUser.getUserOID());
            boolean bankArcPriv = appSessUser.isBAR(appSessUser.getUserOID());
            boolean bankLinkPriv = appSessUser.isBLINK(appSessUser.getUserOID());
            boolean bankrecon = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_RECON_CREDIT_CARD);
            boolean bankGenBg = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_GENERATE_BG);            
            boolean bankBgOutstanding = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BANK_BG_OUTSTANDING);
            boolean bankReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BANK_REPORT);

//PIUTANG
            boolean arAging = appSessUser.isArAg(appSessUser.getUserOID());
            boolean arList = appSessUser.isArL(appSessUser.getUserOID());

//HUTANG
            boolean payIGL = appSessUser.isIGL(appSessUser.getUserOID());
            boolean payILI = appSessUser.isILI(appSessUser.getUserOID());
            boolean payAAN = appSessUser.isAAN(appSessUser.getUserOID());
            boolean payPAL = appSessUser.isPAL(appSessUser.getUserOID());
            
            boolean seleksiInvoice = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE);
            boolean postInvoice = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_POST);
            boolean invoicePayment = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT);
            boolean apMemorial = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL);
            boolean postApMemorial = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL_POST);
            boolean budgetReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BUDGET_REPORT);
            boolean bGOutstanding = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BG_OUTSTANDING);
            boolean arsipBG = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_ARSIP_BG);
            boolean releaseInvoice = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_RELEASE_INVOICE);
            boolean budgetReportGA = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BUDGET_REPORT_GA);
            boolean budgetReportSummary = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BUDGET_REPORT_SUMMARY);

            boolean budgetPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST);
            boolean budgetArchivePriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_ARCHIVE);
            boolean budgetApprovalPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST);
            boolean budgetAccLinkPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_ACC_LINK);
            boolean budgetApprovePriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_APPROVAL);
            boolean budgetCheckedPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_CHECKED);
            
//====== GL PRIVILEDGED =====================
            boolean glPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean postGlPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL);
            boolean glArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_ARCHIVES);
            boolean gl13Priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL13);
            boolean postGl13Priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13);
            boolean gl13ArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL13_ARCHIVES);
            boolean glBackdatedPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_BACKDATED);
            boolean postGlBackdatedPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL_BACKDATED);
            boolean glCopyPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_COPY);
            boolean akrualSetupPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_AKRUAL_SETUP);
            boolean akrualProsesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_AKRUAL_PROSES);
            boolean akrualArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL_AKRUAL_ARCHIVES);
            boolean adjustmentPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST);
            boolean adjustmentArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES);
            boolean costingPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST);
            boolean costingArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES);
            boolean returPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_POST);
            boolean returArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_ARCHIVES);
            boolean repackPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST);
            boolean repackArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_ARCHIVES);
            
            boolean gaPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GA_POST);
            boolean gaArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GA_ARCHIVES);
            
            boolean cashBackPostPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_POST);
            boolean cashBackArchivesPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_CASH_BACK_ARCHIVES);
            
            
//====== END GL PRIVILEDGED =====================

//====== ACTIVITY PRIVILEDGED =====================
            boolean dreportPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_DONORREPORT);
            boolean approvalActPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_APPROVAL_ACTIVITY);
            boolean appActivityPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_ACTIVITY);
//====== END ACTIVITY PRIVILEDGED =====================

//====== REPORT PRIVILEDGED =====================
            boolean fnSTR = appSessUser.isSetRep(appSessUser.getUserOID());
            boolean fn = appSessUser.isRep(appSessUser.getUserOID());
            boolean fnGl = appSessUser.isRepGl(appSessUser.getUserOID());
            boolean fnNeraca = appSessUser.isRepNer(appSessUser.getUserOID());
            boolean fnGlDet = appSessUser.isGlDet(appSessUser.getUserOID());
            boolean fnProfit = appSessUser.isRepProfit(appSessUser.getUserOID());            
            boolean fnCR = appSessUser.isRepCR(appSessUser.getUserOID());
            boolean COp = appSessUser.isRepCOp(appSessUser.getUserOID());
            boolean fnReportBudget = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT_BUDGET);
//====== END REPORT PRIVILEDGED =====================


            boolean mastSysConf = appSessUser.isMstSysConf(appSessUser.getUserOID());
            boolean mastSegment = appSessUser.isMstSegment(appSessUser.getUserOID());
            boolean mastAcc = appSessUser.isMstAcc(appSessUser.getUserOID());
            boolean mastWp = appSessUser.isMstWP(appSessUser.getUserOID());
            boolean mastComp = appSessUser.isMstComp(appSessUser.getUserOID());
            boolean mastGen = appSessUser.isMstGen(appSessUser.getUserOID());
            boolean mastBgt = appSessUser.isMstBudPriv(appSessUser.getUserOID());
            boolean admin = appSessUser.isAdm(appSessUser.getUserOID());
            boolean adminExecute = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE);
            boolean adminJournalEditor = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_JOURNAL_EDITOR );
            boolean adminSalesEditor = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean closePer = appSessUser.isCP(appSessUser.getUserOID());
            boolean mastVendor = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR);
            boolean mastCurrency = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY);
%>