package com.project.fms.printing;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.fms.master.DbCoa;
import com.project.fms.transaction.DbPettycashPayment;
import com.project.fms.transaction.DbPettycashPaymentDetail;
import com.project.fms.transaction.PettycashPayment;
import com.project.fms.transaction.PettycashPaymentDetail;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
import com.project.printman.OXY_PrintObj;
import com.project.printman.OXY_PrinterService;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.NumberSpeller;
import java.util.Date;
import java.util.Vector;

public class PrintBKKKasbon {

    static int rowx = 0;
    static int rowLoop = 0;
    static int startHeaderRowx = 0;
    static int endHeaderRowx = 0;
    static boolean rowSpellMoreThanOne = false;

    public OXY_PrintObj PrintSummaryFormBKK(int typeDoc, long pettyCashOID, int maxLoopItem, boolean footLengkap) {

        OXY_PrintObj obj = new OXY_PrintObj();
        try {
            rowx = 0; //set Row di index 0
            rowLoop = 0;
            if (obj == null) {
                obj = new OXY_PrintObj();
            }

            OXY_PrinterService prnSvc = OXY_PrinterService.getInstance();
            obj.setObjDescription(" ******** PRINT SUMMARY BKK KASBON ******** ");

            if (typeDoc == 2) {
                obj.setPageLength(61);
                obj.setSkipLineIsPaperFix(5); // 2
                obj.setUseSpaceRowBlankForNewPaper(true);
                obj.setSpaceRowBlankForNewPaper(3);
            } else {
                if (footLengkap) {
                    obj.setPageLength(61);
                    obj.setSkipLineIsPaperFix(5); // 2
                } else {
                    obj.setPageLength(30);
                    obj.setSkipLineIsPaperFix(0);
                }
                obj.setUseSpaceRowBlankForNewPaper(true);
                obj.setSpaceRowBlankForNewPaper(3);
            }

            obj.setTopMargin(1);
            obj.setLeftMargin(0);
            obj.setRightMargin(0);
            obj.setCpiIndex(OXY_PrintObj.PRINTER_12_CPI); // 12 CPI = 96 char /line, 12 CPI = 163 char /line

            // header
            obj = (OXY_PrintObj) headerBKK(obj);
            obj = (OXY_PrintObj) mainBKK(obj, pettyCashOID);
            if (typeDoc == 2) {
                obj = (OXY_PrintObj) detailBKK(obj, pettyCashOID, maxLoopItem);

                /*int spellRow = 19;
                if (rowSpellMoreThanOne) {
                    spellRow = 20;
                }

                for (int k = 0; k < spellRow; k++) {
                    obj.setHeader(k);
                }*/
            }
            obj = (OXY_PrintObj) footerBKK(obj, pettyCashOID, footLengkap);

            // setting header
            //System.out.println("startHeaderRowx : "+startHeaderRowx);
            //System.out.println("endHeaderRowx : "+endHeaderRowx);
            //obj.setHeader(startHeaderRowx,endHeaderRowx);

            // start untuk printing
		/*	System.out.println("Start Printing");
            prnSvc.print(obj);
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
    public OXY_PrintObj headerBKK(OXY_PrintObj obj) {
        try {

            int[] cola = {8, 54, 38};   // 2 coloum
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
            obj.setColumnValue(2, rowx, "B U K T I    K A S / B A N K", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-------------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "----------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + header, OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "     P E M B A Y A R A N", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + address, OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            rowx++;

        } catch (Exception exc) {
        }

        return obj;
    }

    public OXY_PrintObj mainBKK(OXY_PrintObj obj, long pettyCashOID) {
        try {
            int[] cola = {50, 10, 4, 30};   // 4 coloum
            obj.newColumn(4, "", cola);

            // proses pencarian data petty cash berdasarkan data oid
            PettycashPayment pettycashPayment = new PettycashPayment();
            try {
                pettycashPayment = DbPettycashPayment.fetchExc(pettyCashOID);
            } catch (Exception ex) {
                System.out.println("ERR >>> : " + ex.toString());
            }
            String cst = "-";
            //if (pettycashPayment.getPaymentTo() != null && pettycashPayment.getPaymentTo().length() > 0) {
            //    cst = pettycashPayment.getPaymentTo();
            if (pettycashPayment.getEmployeeId() != 0) {
                try {
                    Employee employe = DbEmployee.fetchExc(pettycashPayment.getEmployeeId());
                    cst = employe.getName();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } else if (pettycashPayment.getCustomerId() != 0) {
                try {
                    Customer cust = DbCustomer.fetchExc(pettycashPayment.getCustomerId());
                    cst = cust.getName();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } else {
                cst = "-";
            }

            int val_periode = pettycashPayment.getTransDate().getMonth() + 1;
            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

            startHeaderRowx = rowx;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "No. BKK", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + pettycashPayment.getJournalNumber(), OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Tanggal", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "dd/MM/yy"), OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Periode", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + val_periode, OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            int[] colb = {8, 22, 3, 67};   // 4 coloum
            obj.newColumn(4, "", colb);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Dibayarkan kepada", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + pettycashPayment.getPaymentTo(), OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Pegawai", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + cst, OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Jumlah dgn. angka", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, idr + " " + JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##"), OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            /**
             * proses format huruf
             */
            NumberSpeller numberSpeller = new NumberSpeller();
            String amount = JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##");
            String strSpell = numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", "")));

            if (strSpell.length() < 67) {
                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "dgn huruf", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + strSpell.trim() + " Rupiah", OXY_PrintObj.TEXT_LEFT);
                obj.setHeader(rowx);
            } else {
                String spell1 = strSpell.substring(0, 65);
                rowSpellMoreThanOne = true;

                //System.out.println("spell1 :"+spell1);
                for (int k = spell1.length(); k > 0; k--) {
                    System.out.println(spell1.charAt(k - 1));
                    if (spell1.charAt(k - 1) == ' ') {
                        int idxl = spell1.length() - (spell1.length() - k);
                        spell1 = spell1.substring(0, idxl);
                        //System.out.println("spell1 :"+spell1);
                        break;
                    }
                }
                String spell2 = strSpell.substring(spell1.length(), strSpell.length());

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "dgn huruf", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + spell1.trim(), OXY_PrintObj.TEXT_LEFT);
                obj.setHeader(rowx);
                rowLoop++; 
                rowx++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + spell2.trim() + " Rupiah", OXY_PrintObj.TEXT_LEFT);
                obj.setHeader(rowx);
            }
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Dibayarkan dengan", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "No Cek", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "Cash", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowx++;
            rowLoop++;

            // setting for header if page not fix
            // obj.setHeader(0,rowx--);

        } catch (Exception exc) {
            System.out.println("Err>> mainBKK : " + exc.toString());
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

    public OXY_PrintObj detailBKK(OXY_PrintObj obj, long pettyCashOID, int maxLoopItem) {
        try {
            int[] cola = {8, 1, 5, 1, 21, 1, 20, 1, 20, 1, 20, 1};   // 9 coloum
            obj.newColumn(12, "", cola);


            String whereClause = DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettyCashOID;
            Vector vPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, whereClause, null);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "=====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "No.", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(4, rowx, "P E R I N C I A N", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(6, rowx, "No. Rekening", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(8, rowx, "J U M L A H", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(10, rowx, "PENJELASAN", OXY_PrintObj.TEXT_CENTER);
            obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "=====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "====================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            // end header
            //endHeaderRowx = rowx;

            rowx++;

            double payment = 0;
            int loop = 0;
            int sisa = 0;
            int startN = 0;
            int startP = 0;
            String strName = "";
            String strPenjelasan = "";

            String noRek = "-";
            String nama = "-";
            String penjelasan = "";
            String strAmount = "";
            int rowItem = 0;

            for (int k = 0; k < vPettycashPaymentDetail.size(); k++) {

                PettycashPaymentDetail pettycashPaymentDetail = (PettycashPaymentDetail) vPettycashPaymentDetail.get(k);

                noRek = "-";
                nama = "-";
                penjelasan = "";
                strAmount = "";

                if (pettycashPaymentDetail.getAmount() == 0) {
                    strAmount = "(" + JSPFormater.formatNumber(pettycashPaymentDetail.getCreditAmount(), "#,###.##") + ")";
                    payment = payment - pettycashPaymentDetail.getCreditAmount();
                } else {
                    strAmount = JSPFormater.formatNumber(pettycashPaymentDetail.getAmount(), "#,###.##");
                    payment = payment + pettycashPaymentDetail.getAmount();
                }

                if (pettycashPaymentDetail.getMemo().length() > 0) {
                    penjelasan = pettycashPaymentDetail.getMemo();
                }

                Vector result = new Vector();

                try {
                    if (pettycashPaymentDetail.getCoaId() != 0) {
                        result = DbCoa.getCodeCoa(pettycashPaymentDetail.getCoaId());
                        noRek = "" + result.get(0);
                        nama = "" + result.get(1);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                try {
                    // proses pengecekan data lebih dengan max carakter
                    loop = 0;
                    sisa = 0;
                    startN = 0;
                    startP = 0;
                    if (nama.length() > penjelasan.length()) {
                        loop = nama.length() / 21;
                        sisa = nama.length() % 21;
                    } else {
                        loop = penjelasan.length() / 20;
                        sisa = penjelasan.length() % 20;
                    }

                    loop = loop + 1;

                    strName = "";
                    strPenjelasan = "";

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
                                    strPenjelasan = "";
                                }

                            } catch (Exception eb) {
                                strPenjelasan = "";
                            }
                        } else {
                            try {
                                if (nama.length() > 0) {
                                    if (nama.length() < 21) {
                                        strName = nama.substring(startN, nama.length());
                                    } else {
                                        strName = nama.substring(startN, startN + 21);
                                    }
                                } else {
                                    strName = "";
                                }
                            } catch (Exception exx) {
                                strName = "";
                            }

                            try {
                                if (penjelasan.length() > 0) {
                                    if (penjelasan.length() < 20) {
                                        strPenjelasan = penjelasan.substring(startP, penjelasan.length());
                                    } else {
                                        strPenjelasan = penjelasan.substring(startP, startP + 20);
                                    }
                                } else {
                                    strPenjelasan = "";
                                }
                            } catch (Exception exc) {
                                strPenjelasan = penjelasan.substring(startP, penjelasan.length());
                            }
                        }

                        startN = startN + 21;
                        startP = startP + 20;


                        obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(2, rowx, "" + (k + 1), OXY_PrintObj.TEXT_LEFT);
                        } else {
                            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        }
                        obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(4, rowx, "" + strName, OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(6, rowx, "" + noRek, OXY_PrintObj.TEXT_LEFT);
                        } else {
                            obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        }
                        obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(8, rowx, "" + strAmount, OXY_PrintObj.TEXT_RIGHT);
                        } else {
                            obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_RIGHT);
                        }
                        obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(10, rowx, "" + strPenjelasan, OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                        rowx++;
                        rowLoop++;
                        checkNewPaperOrNot(obj);
                    }
                } catch (Exception xx) {
                    System.out.println("XX " + xx.toString());
                }
            }

            // last item
            lastPrintItem(obj);

            //50
            //60-50 = 10

            //int minLoop = vPettycashPaymentDetail.size() % maxLoopItem;
            //System.out.println("minLoop : "+minLoop);

            int minLoop = rowItem % maxLoopItem;
            if (minLoop < 0) {
                minLoop = minLoop * -1;
            }

            if (rowItem < maxLoopItem) {
                minLoop = maxLoopItem - rowItem;
            }

            /*if (minLoop > 0) {
                for (int a = 0; a < minLoop; a++) {
                    obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_RIGHT);
                    obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(10, rowx, "", OXY_PrintObj.TEXT_LEFT);
                    obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                    rowx++;
                }
            } else {
                if (minLoop == 0) {
                    int leftPage = (rowx - 1) % obj.getPageLength();
                    leftPage = obj.getPageLength() - leftPage;
                    for (int a = 0; a < leftPage; a++) {
                        obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(10, rowx, "", OXY_PrintObj.TEXT_LEFT);
                        obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                        rowx++;
                    }
                }
            }*/

            // last footer
            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "============================================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "=====================================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "=====================================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "=====================================", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "T O T A L", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "" + JSPFormater.formatNumber(payment, "#,###.##"), OXY_PrintObj.TEXT_RIGHT);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

            // last footer
	    obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "-----", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "----------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "----------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "----------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "----------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);

            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

        } catch (Exception exc) {
        }

        return obj;
    }

    // footer dari list
    public OXY_PrintObj footerBKK(OXY_PrintObj obj, long pettyCashOID, boolean footLengkap) {
        try {

            checkNewPaperOrNot(obj, true);

            if (footLengkap) {
                // TAMBAHAN SESUAI DESIGN LAMA
                int[] cola = {8, 1, 19, 1, 33, 1, 15, 1, 20, 1};   // 10 coloum
                obj.newColumn(10, "", cola);

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "---------------------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "---------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "SETUJU DIBAYAR", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "DIPERIKSA OLEH", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "DIBAYAR", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "TELAH DIBUKUKAN", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "---------------------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "---------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                int[] colc = {8, 1, 19, 1, 18, 1, 14, 1, 15, 1, 9, 1, 10, 1};   // 12 coloum
                obj.newColumn(14, "", colc);

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "Paraf", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "Tanggal", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(11, rowx, "-", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);

                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "1", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "2", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "--------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "---------------", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "Kadiv Keu.", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT); 
                obj.setColumnValue(4, rowx, "Akuntansi", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "Keuangan", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "Kasir", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "3", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "------------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "--------------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "---------------", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "Tgl  /  /20", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "Tgl  /  /20", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "Tgl  /  /20", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "Tgl  /  /20", OXY_PrintObj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;
            }

            // START SESUAI DESIGN LAMA

            int[] colb = {8, 1, 38, 1, 51, 1};   // 5 coloum
            obj.newColumn(6, "", colb);

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "--------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "---------------------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            if (footLengkap) {
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            } else {
                obj.setColumnValue(2, rowx, "Dibayarkan oleh, Tgl   /   /20", OXY_PrintObj.TEXT_LEFT);
            }
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "Yang menerima pembayaran, Tgl   /   /20", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            if (footLengkap) {
                obj.setColumnValue(2, rowx, "Direktur Keuangan", OXY_PrintObj.TEXT_LEFT);
            } else {
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
            }
            obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "Nama jelas :                         a/n.", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "--------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "---------------------------------------------------", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", OXY_PrintObj.TEXT_LEFT);

            //obj.setFooter(rowx);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "Dicetak Tanggal: " + JSPFormater.formatDate(new Date(), "dd/MM/yy"), OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "", OXY_PrintObj.TEXT_LEFT);

            //obj.setFooter(rowx);
            rowx++;
            rowLoop++;

            // proses last print
            prosesLastPrintAndNewPage(obj);

            // for new paper
            /*for (int k = 0; k < obj.getSkipLineIsPaperFix(); k++) {
                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "", OXY_PrintObj.TEXT_LEFT);
            }*/


        } catch (Exception e) {
        }

        return obj;
    }

    public static int checkNewPaperOrNot(OXY_PrintObj obj){
        return checkNewPaperOrNot(obj,false);
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
        if((totalRow) < 22){
            // cetakan kosong
            for(int i=0;i < totalRow; i++){
                //obj.addLine("");
                obj.setColumnValue(0, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "", OXY_PrintObj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", OXY_PrintObj.TEXT_LEFT);
                rowx++;
                rowLoop++;
            }
        }
    }

    public static void prosesLastPrintAndNewPage(OXY_PrintObj obj){
        if (obj.getUseSpaceRowBlankForNewPaper() == true) {
            int totalRowSpace = 0;

            if (obj.getPageLength() == rowLoop) {
                totalRowSpace = obj.getSkipLineIsPaperFix(); // obj.getSpaceRowBlankForNewPaper();
            } else {
                totalRowSpace = ((obj.getPageLength() - rowLoop) + obj.getSkipLineIsPaperFix()); //obj.getSpaceRowBlankForNewPaper() +
            }

            for (int j = 0; j < totalRowSpace; j++) {
                obj.addLine("");
                rowx++;
            }
        }
    }
}
