package com.project.fms.printing;

import com.project.I_Project;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import com.project.general.Approval;
import com.project.general.DbApproval;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.printman.OXY_PrintObj;
import com.project.printman.OXY_PrinterService;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Vector;

public class PrintGL {

    static int rowx = 0;
    static int rowLoop = 0;
    static int startHeaderRowx = 0;
    static int endHeaderRowx = 0;
    static int max_row_main = 17;
    static int max_row_last_header = 8;
    static boolean rowSpellMoreThanOne = false;
    static int maxrow_description = 0;

    public OXY_PrintObj PrintFormGL(int typeDoc, long GlOID, int maxRowDetail) {

        OXY_PrintObj obj = new OXY_PrintObj();
        try {
            rowx = 0; //set Row di index 0
            rowLoop = 0;

            if (obj == null) {
                obj = new OXY_PrintObj();
            }

            OXY_PrinterService prnSvc = OXY_PrinterService.getInstance();
            obj.setObjDescription(" ******** PRINT GL ******** ");

            obj.setPageLength(61); // 60
            obj.setSkipLineIsPaperFix(5); // 2
            obj.setUseSpaceRowBlankForNewPaper(true);
            obj.setSpaceRowBlankForNewPaper(3);

            /*if(typeDoc==2){
            obj.setPageLength(61);
            obj.setSkipLineIsPaperFix(2);
            obj.setUseSpaceRowBlankForNewPaper(true);
            obj.setSpaceRowBlankForNewPaper(3);
            }else{
            obj.setPageLength(30);
            obj.setSkipLineIsPaperFix(0);
            obj.setUseSpaceRowBlankForNewPaper(true);
            obj.setSpaceRowBlankForNewPaper(3);
            }*/

            obj.setTopMargin(1);
            obj.setLeftMargin(0);
            obj.setRightMargin(0);

            obj.setCpiIndex(OXY_PrintObj.PRINTER_12_CPI); // 12 CPI = 96 char /line, 12 CPI = 163 char /line

            // obj.setCpiIndex(obj.PRINTER_CONDENSED_MODE);

            // header
            obj = (OXY_PrintObj) headerGL(obj);
            obj = (OXY_PrintObj) mainGL(obj, GlOID);
            obj = (OXY_PrintObj) detailGL(obj, GlOID, maxRowDetail);

            /*for (int k = 0; k < (11 + maxrow_description); k++) {
                System.out.println("index header: " + k);
                obj.setHeader(k);
            }*/

            // obj	= (OXY_PrintObj)footerQuickGL(obj,GlOID);

            // Vector result = DbApprovalDoc.getDocApproval(GlOID);

            //Vector result = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_JOURNAL);
            obj = (OXY_PrintObj) footerGL(obj);

            // setting header
            //System.out.println("startHeaderRowx : "+startHeaderRowx);
            //System.out.println("endHeaderRowx : "+endHeaderRowx);
            //obj.setHeader(startHeaderRowx,endHeaderRowx);

            // start untuk printing
            System.out.println("Start Printing");
            /*prnSvc.print(obj);
            prnSvc.running = true;
            prnSvc.run();*/

        } catch (Exception exc) {
            System.out.println("CETAK DATA SUMMARY : ");
        }

        return obj;
    }

    /**
     * proses pembuatan header untuk bkk
     *
     */
    public OXY_PrintObj headerGL(OXY_PrintObj obj) {
        try {

            int[] cola = {1, 54, 45};   // 2 coloum
            obj.newColumn(3, "", cola);

            // proses pencarian nama company
            String company = "";
            String address = "";
            String header = "";
            try {
                Vector vCompany = DbCompany.list(0, 0, "", null);
                if (vCompany != null && vCompany.size() > 0) {
                    Company com = (Company) vCompany.get(0);
                    company = com.getName();
                    address = com.getAddress();
                }
            } catch (Exception e) {
                System.out.println("[exc] " + e.toString());
            }
            try {
                header = DbSystemProperty.getValueByName("HEADER_BKK");
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }


            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + company, OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "J U R N A L   U M U M", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-------------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "----------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + header, OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + address, OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

        } catch (Exception exc) {
        }

        return obj;
    }

    public OXY_PrintObj mainGL(OXY_PrintObj obj, long GlOID) {
        try {
            Gl gl = new Gl();
            try {
                gl = DbGl.fetchExc(GlOID);
            } catch (Exception e) {
            }

            int[] cola = {1, 17, 45, 20, 17};
            obj.newColumn(5, "", cola);

            //startHeaderRowx = rowx;
            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Nomor Jurnal", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ": " + gl.getJournalNumber(), OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "Tanggal Transaksi", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, ": " + JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy"), OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Nomor Referensi", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ": " + gl.getRefNumber(), OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            int[] colax = {1, 17, 82};   // 4 coloum
            obj.newColumn(3, "", colax);

            String nama = gl.getMemo();
            int loop = nama.length() / 82;
            int sisa = nama.length() % 82;
            int startN = 0;
            String strName = "";

            loop = loop + 1;

            for (int j = 0; j < loop; j++) {
                strName = "";

                if (j == (loop - 1)) {
                    try {
                        if (startN < nama.length()) {
                            if (nama.length() > 0) {
                                strName = nama.substring(startN, nama.length());
                            } else {
                                strName = "";
                            }
                        } else {
                            strName = "";
                        }
                    } catch (Exception e) {
                        strName = "";
                    }
                } else {
                    try {
                        if (startN < nama.length()) {
                            if (nama.length() > (startN + 82)) {
                                strName = nama.substring(startN, startN + 82);
                            } else {
                                strName = nama.substring(startN, nama.length());
                            }
                        } else {
                            strName = "";
                        }
                    } catch (Exception exx) {
                        strName = "";
                    }
                }

                if (j == 0) {
                    maxrow_description = maxrow_description + 1;

                    obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(1, rowx, "Memo", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(2, rowx, ": " + strName, OXY_PrintObj.TEXT_LEFT);
                    obj.setHeader(rowx);
                } else {
                    maxrow_description = maxrow_description + 1;

                    obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(2, rowx, "  " + strName, OXY_PrintObj.TEXT_LEFT);
                    obj.setHeader(rowx);
                }

                startN = startN + 82;
                rowx++;
                rowLoop++;
            }

            /*obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Memo", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ": "+gl.getMemo(), OXY_PrintObj.TEXT_LEFT);*/
            //rowx++;


            // setting for header if page not fix
            // obj.setHeader(0,rowx-1);

        } catch (Exception exc) {
            System.out.println("Err>> mainGL : " + exc.toString());
        }

        return obj;
    }

    /**
     * untuk pengecekan data max per carakter cetak
     */
    public boolean checkMaxCaracter(String str, int max) {
        boolean bool = false;
        try {
            if (str.length() > max) {
                System.out.println("str.length() > max >> : " + str.length() + " - " + max);
                bool = true;
            }
        } catch (Exception ex) {
            System.out.println("ERR checkMaxCaracter >> : " + ex.toString());
        }
        return bool;
    }

    /**
     * untuk potong data sesuai max
     */
    public String subStringMaxCaracter(String str, int start, int max) {
        String strName = "";
        try {
            if (start > max) {
                strName = str.substring(start, str.length());
            } else {
                if (str.length() > max) {
                    strName = str.substring(start, max);
                } else {
                    if (max > str.length()) {
                        strName = str.substring(start, str.length());
                    }
                }
            }
        } catch (Exception ex) {
            strName = str.substring(start, str.length());
        }

        System.out.println("strName >> : " + strName);
        return strName;
    }

    public OXY_PrintObj detailGL(OXY_PrintObj obj, long GlOID, int maxLoopItem) {
        try {
            int[] cola = {1, 1, 20, 1, 18, 1, 18, 1, 38, 1};   // 18 coloum
            obj.newColumn(10, "", cola);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "====================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "======================================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "Perkiraan", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(4, rowx, "Debet", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "Kredit", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "Keterangan", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(4, rowx, "Rp", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "Rp", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "====================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "======================================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            obj.setFooter(rowx);
            rowx++;
            rowLoop++;

            double payment = 0;
            int loop = 0;
            int loopNama = 0;
            int loopPenjelasan = 0;
            int sisa = 0;
            int startN = 0;
            int startP = 0;
            int startD = 0;
            String strName = "";
            String strPenjelasan = "";
            String strDepartment = "";

            String noRek = "-";
            String nama = "-";
            String penjelasan = "";
            String department = "";
            String nsp = "";

            String strAmount = "";
            int rowItem = 0;

            Vector listGlDetail = new Vector();
            String where = DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + GlOID;
            try {
                listGlDetail = DbGlDetail.list(0, 0, where, null);
            } catch (Exception e) {
            }

            double debet = 0;
            double credit = 0;
            int ct = 0;
            boolean diffCoaClass = false;

            for (int i = 0; i < listGlDetail.size(); i++) {

                GlDetail glDetail = (GlDetail) listGlDetail.get(i);
                Coa c = new Coa();
                try {
                    c = DbCoa.fetchExc(glDetail.getCoaId());
                    if (i == 0) {
                        ct = c.getAccountClass();
                    } else {
                        if (!diffCoaClass && ct != c.getAccountClass()) {
                            if (ct == 2) {
                                if (c.getAccountClass() != 2) {
                                    diffCoaClass = true;
                                }
                            } else {
                                if (c.getAccountClass() == 2) {
                                    diffCoaClass = true;
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                debet = debet + glDetail.getDebet();
                credit = credit + glDetail.getCredit();

                nama = c.getCode() + " - " + c.getName();

                if (glDetail.getMemo().length() > 0) {
                    penjelasan = glDetail.getMemo();
                }

                try {
                    // proses pengecekan data lebih dengan max carakter
                    loop = 0;
                    loopNama = 0;
                    loopPenjelasan = 0;
                    sisa = 0;
                    startN = 0;
                    startP = 0;
                    startD = 0;

                    loopNama = nama.length() / 20;
                    loopPenjelasan = penjelasan.length() / 38;

                    if (loopNama >= loopPenjelasan) {
                        loop = loopNama; // nama.length() / 20;
                        sisa = nama.length() % 20;
                    } else {
                        loop = loopPenjelasan; // penjelasan.length() / 38;
                        sisa = penjelasan.length() % 38;
                    }

                    loop = loop + 1;

                    strName = "";
                    strPenjelasan = "";
                    strDepartment = "";

                    for (int j = 0; j < loop; j++) {
                        rowItem++;

                        if (j == (loop - 1)) {
                            try {
                                if (startN < nama.length()) {
                                    if (nama.length() > 0) {
                                        strName = nama.substring(startN, nama.length());
                                    } else {
                                        strName = "";
                                    }
                                } else {
                                    //strName = nama.substring(startN-13,nama.length());
                                    strName = "";
                                }
                            } catch (Exception e) {
                                strName = "";
                            }

                            try {
                                if (startP < penjelasan.length()) {
                                    if (penjelasan.length() > 0) {
                                        strPenjelasan = penjelasan.substring(startP, penjelasan.length());
                                    } else {
                                        strPenjelasan = "";
                                    }
                                } else {
                                    //strPenjelasan = penjelasan.substring(startP-13,penjelasan.length());
                                    strPenjelasan = "";
                                }

                            } catch (Exception eb) {
                                strPenjelasan = "";
                            }
                        } else {
                            try {
                                if (startN < nama.length()) {
                                    if (nama.length() > (startN + 20)) {
                                        strName = nama.substring(startN, startN + 20);
                                    } else {
                                        strName = nama.substring(startN, nama.length());
                                    }
                                } else {
                                    strName = "";
                                }
                            } catch (Exception exx) {
                                strName = "";
                            }

                            try {
                                if (startP < penjelasan.length()) {
                                    if (penjelasan.length() > (startP + 38)) {
                                        strPenjelasan = penjelasan.substring(startP, startP + 38);
                                    } else {
                                        strPenjelasan = penjelasan.substring(startP, penjelasan.length());
                                    }
                                } else {
                                    strPenjelasan = "";
                                }
                            } catch (Exception exc) {
                                strPenjelasan = "";
                            }
                        }

                        startN = startN + 20;
                        startP = startP + 38;

                        obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
                        obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_CENTER);
                        obj.setColumnValue(2, rowx, "" + strName, OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_CENTER);
                        if (j == 0) {
                            obj.setColumnValue(4, rowx, "" + JSPFormater.formatNumber(glDetail.getDebet(), "#,###.##"), OXY_PrintObj.TEXT_RIGHT);
                        } else {
                            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_RIGHT);
                        }
                        obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(6, rowx, "" + JSPFormater.formatNumber(glDetail.getCredit(), "#,###.##"), OXY_PrintObj.TEXT_RIGHT);
                        } else {
                            obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_RIGHT);
                        }
                        obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(8, rowx, "" + strPenjelasan, OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                        rowx++;
                        rowLoop++;
                        checkNewPaperOrNot(obj,false);
                    }
                } catch (Exception xx) { 
                    System.out.println("XX " + xx.toString());
                }
            }

            // terakhir cetak footer
            lastPrintItem(obj);

            int minLoop = rowItem % maxLoopItem;

            if (minLoop < 0) {
                minLoop = minLoop * -1;
            }

            if (rowItem < maxLoopItem);
            minLoop = maxLoopItem - rowItem;

            /*if (minLoop > 0) {
                for (int a = 0; a < minLoop; a++) {
                    obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                    obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                    obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                    obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                    obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    rowx++;
                    rowLoop++; 
                }
            } else {
                if (minLoop == 0) {
                    int leftPage = (rowx - 1) % obj.getPageLength();
                    leftPage = obj.getPageLength() - leftPage;
                    for (int a = 0; a < leftPage; a++) {
                        obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                        obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                        obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                        obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                        obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        rowx++;
                        rowLoop++;
                    }
                }
            }*/

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "====================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "======================================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "" + JSPFormater.formatNumber(debet, "#,###.##"), OXY_PrintObj.TEXT_RIGHT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "" + JSPFormater.formatNumber(credit, "#,###.##"), OXY_PrintObj.TEXT_RIGHT);
            obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "====================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "==================", OXY_PrintObj.TEXT_LEFT); // 15
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "======================================", OXY_PrintObj.TEXT_LEFT); // 13
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

        } catch (Exception exc) {
        }

        return obj;
    }

    // footer dari list
    public OXY_PrintObj footerQuickGL(OXY_PrintObj obj, long GlOID) {
        try {
            int[] colb = {2, 49, 49};   // 5 coloum 54 + 38
            obj.newColumn(3, "", colb); 

            //untuk cek terakhir
            checkNewPaperOrNot(obj, true); 

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "Direktur Keuangan", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "Kabag Akuntansi", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

        } catch (Exception e) {
        }

        return obj;
    }

    // footer dari list
    public OXY_PrintObj footerGL(OXY_PrintObj obj) {
        try {

            int[] colb = {1, 49, 49, 1};
            obj.newColumn(4, "", colb); 

            //untuk cek terakhir
            checkNewPaperOrNot(obj, true);

            Approval approval_0 = new Approval();
            Employee employee_0 = new Employee();
            try {
                approval_0 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_JOURNAL, DbApproval.URUTAN_1);
                if (approval_0.getEmployeeId() != 0) {
                    employee_0 = DbEmployee.fetchExc(approval_0.getEmployeeId());
                }
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            Approval approval_1 = new Approval();
            Employee employee_1 = new Employee();
            try {
                approval_1 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_JOURNAL, DbApproval.URUTAN_2);
                if (approval_1.getEmployeeId() != 0) {
                    employee_1 = DbEmployee.fetchExc(approval_1.getEmployeeId());
                }
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + employee_0.getName(), OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "" + employee_1.getName(), OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-------------------------", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "-------------------------", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " " + approval_0.getKeterangan(), OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, " " + approval_1.getKeterangan(), OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, " ", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++; 

            // proses last print
            prosesLastPrintAndNewPage(obj);

            /*obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "Dicetak Tanggal: "+JSPFormater.formatDate(new Date(), "dd/MM/yy"), OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);

            //obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            //obj.setColumnValue(5, rowx, "", OXY_PrintObj.TEXT_LEFT);

            obj.setFooter(rowx);
            rowx++;*/

        } catch (Exception e) { 
        }

        return obj;
    }

    // solusi untuk anti sipasi error pindah page
    public static int checkNewPaperOrNot(OXY_PrintObj obj, boolean stsTotalItemCheck){
        if(stsTotalItemCheck==false){
            if(rowLoop==obj.getPageLength()){
                // proses untuk footer per page
                rowLoop = 0;
                Vector footer = obj.getFooter();
                for(int j=0;j<footer.size();j++){
                    String str = (String) footer.get(j);
                    obj.addLine(str);
                    rowx++;
                }

                // proses skip line pape 1 dan paper 2
                int rowSkip = obj.getSkipLineIsPaperFix();
                rowSkip = rowSkip - footer.size();

                for(int i=0;i<rowSkip; i++){
                    obj.addLine("");
                    rowx++;
                }

                // header untuk new page
                Vector header = obj.getHeader();
                for(int k=0;k<header.size();k++){
                    String str = (String) header.get(k);
                    obj.addLine(str);
                    rowx++;
                    rowLoop++;
                }
            }
        }else{
            if(rowLoop==obj.getPageLength()){
                int rowSkip = obj.getSkipLineIsPaperFix();
                for(int i=0;i<rowSkip; i++){
                    obj.addLine("");
                    rowx++;
                }
                rowLoop = 0;
            }
        }
        return rowx;
    }

    public static void lastPrintItem(OXY_PrintObj obj){
        int totalRow = (obj.getPageLength() - 3) - rowLoop;
        if((totalRow) < 11){
            // cetakan kosong
            for(int i=0;i < totalRow; i++){
                //obj.addLine("");
                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT); // 15
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT); // 13
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;
            }
        }
    }

    public static void prosesLastPrintAndNewPage(OXY_PrintObj obj){
        if (obj.getUseSpaceRowBlankForNewPaper() == true) {
            int totalRowSpace = 0;

            if (obj.getPageLength() == rowLoop) {
                totalRowSpace = obj.getSpaceRowBlankForNewPaper();
            } else {
                totalRowSpace = ((obj.getPageLength() - rowLoop) + obj.getSkipLineIsPaperFix()); //obj.getSpaceRowBlankForNewPaper() +
            }

            for (int j = 0; j < totalRowSpace; j++) {
                obj.addLine("");
                rowx++;
            }
        }
    }


    public static void main(String[] args) {
        try {
            PrintGL printGL = new PrintGL();
            printGL.PrintFormGL(0, 0, 0);

        } catch (Exception e) {
        }
    }


}
