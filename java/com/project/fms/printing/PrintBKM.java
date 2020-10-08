package com.project.fms.printing;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.fms.transaction.CashReceive;
import com.project.fms.transaction.CashReceiveDetail;
import com.project.fms.transaction.DbCashReceive;
import com.project.fms.transaction.DbCashReceiveDetail;
import com.project.printman.OXY_PrintObj;
import com.project.printman.OXY_PrinterService;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.NumberSpeller;
import java.util.Date;
import java.util.Vector;

public class PrintBKM {

    static int rowx = 0;
    static int rowLoop = 0;
    static boolean rowSpellMoreThanOne = false;

    public OXY_PrintObj PrintSummaryFormBKM(int typeDoc, long cashReceiveId, int maxLoopItem, boolean footLengkap) {
        OXY_PrintObj obj = new OXY_PrintObj();
        try {
            rowx = 0; //set Row di index 0
            rowLoop = 0;
			/*if (obj == null) {
            obj = new OXY_PrintObj();
            }*/

            OXY_PrinterService prnSvc = OXY_PrinterService.getInstance();
            obj.setObjDescription(" ******** PRINT BKM ******** ");
            obj.setTopMargin(1);
            obj.setLeftMargin(0);
            obj.setRightMargin(0);

            if (typeDoc == 2) {
                obj.setPageLength(61);
                obj.setSkipLineIsPaperFix(5); // 5
                obj.setUseSpaceRowBlankForNewPaper(true);
                obj.setSpaceRowBlankForNewPaper(3);
            } else {
                if (footLengkap) {
                    obj.setPageLength(30);
                    obj.setSkipLineIsPaperFix(0);  
                } else { 
                    obj.setPageLength(61);
                    obj.setSkipLineIsPaperFix(5); // 2
                }
                obj.setUseSpaceRowBlankForNewPaper(true); 
                obj.setSpaceRowBlankForNewPaper(3);
            }

            obj.setCpiIndex(obj.PRINTER_12_CPI); // 12 CPI = 96 char /line, 12 CPI = 163 char /line

            // header
            obj = headerBKM(obj);
            obj = mainBKM(obj, cashReceiveId);

            if (typeDoc == 2) {
                obj = (OXY_PrintObj) detailBKM(obj, cashReceiveId, maxLoopItem);

                /*int spellRow = 17;
                if (rowSpellMoreThanOne) {
                    spellRow = 18;
                }

                for (int k = 0; k < spellRow; k++) {
                    obj.setHeader(k);
                }*/
            }
            obj = (OXY_PrintObj) footerBKM(obj, footLengkap);


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
     * proses pembuatan header untuk BKM
     *
     */
    public OXY_PrintObj headerBKM(OXY_PrintObj obj) {
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
                header = DbSystemProperty.getValueByName("HEADER_BKM");
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }


            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + company, obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "B U K T I    K A S / B A N K", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-------------------------------------------", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "----------------------------", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + header, obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "     P E N E R I M A A N", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "" + address, obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;
        } catch (Exception exc) {
        }

        return obj;
    }

    public OXY_PrintObj mainBKM(OXY_PrintObj obj, long cashReceiveId) {
        try {
            int[] cola = {50, 10, 4, 30};   // 4 coloum
            obj.newColumn(4, "", cola);

            //proses pencarian data
            CashReceive cashReceive = new CashReceive();
            try {
                cashReceive = DbCashReceive.fetchExc(cashReceiveId);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            int val_periode = cashReceive.getTransDate().getMonth() + 1;
            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "No. BKM", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + cashReceive.getJournalNumber(), obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Tanggal", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + JSPFormater.formatDate(cashReceive.getTransDate(), "dd/MM/yy"), obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Periode", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + val_periode, obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            int[] colb = {8, 22, 3, 67};   // 4 coloum
            obj.newColumn(4, "", colb);

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Diterima dari", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "" + cashReceive.getReceiveFromName(), obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Jumlah dgn. angka", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, idr + " " + JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##"), obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;
 
            /**
             * proses format huruf
             */
            NumberSpeller numberSpeller = new NumberSpeller();
            String amount = JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##");
            String strSpell = numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", "")));

            if (strSpell.length() < 67) {
                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "dgn huruf", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + strSpell.trim() + " Rupiah", obj.TEXT_LEFT);
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

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "dgn huruf", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + spell1.trim(), obj.TEXT_LEFT);
                obj.setHeader(rowx);
                rowLoop++;
                rowx++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "" + spell2.trim() + " Rupiah", obj.TEXT_LEFT);
                obj.setHeader(rowx);
            }
            
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "Terima berupa", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, ":", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "No Cek", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "Cash", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            // setting for header if page not fix
            // obj.setHeader(0, rowx - 1);

        } catch (Exception exc) {
            System.out.println("Err>> mainBKM : " + exc.toString());
        }

        return obj;
    }

    public OXY_PrintObj detailBKM(OXY_PrintObj obj, long cashReceiveId, int maxLoopItem) {
        try {
            int[] cola = {8, 1, 5, 1, 21, 1, 20, 1, 20, 1, 20, 1};
            obj.newColumn(12, "", cola);

            String whereClause = DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceiveId;
            Vector vCashReceiveDetail = DbCashReceiveDetail.list(0, 0, whereClause, null);

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "=====================", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "=", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_CENTER);
            obj.setColumnValue(2, rowx, "No.", obj.TEXT_CENTER);
            obj.setColumnValue(3, rowx, "|", obj.TEXT_CENTER);
            obj.setColumnValue(4, rowx, "PERINCIAN", obj.TEXT_CENTER);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_CENTER);
            obj.setColumnValue(6, rowx, "No. Rekening", obj.TEXT_CENTER);
            obj.setColumnValue(7, rowx, "|", obj.TEXT_CENTER);
            obj.setColumnValue(8, rowx, "J U M L A H", obj.TEXT_CENTER);
            obj.setColumnValue(9, rowx, "|", obj.TEXT_CENTER);
            obj.setColumnValue(10, rowx, "PENJELASAN", obj.TEXT_CENTER);
            obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "=====================", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "=", obj.TEXT_LEFT);
            obj.setHeader(rowx);
            rowLoop++;
            rowx++;

            // proses pencarian data detail dari bkm
            int noUrut = 0;
            int listGajiCount = 0;
            boolean checkHal = false;
            boolean checkGol = false;
            boolean checkSatker = false;
            double payment = 0;

            int loop = 0;
            int sisa = 0;
            int startN = 0;
            int startP = 0;

            String strName = "";
            String strPenjelasan = "";

            String noRek = "-";
            String name = "-";
            Vector result = new Vector();
            String penjelasan = "";
            int rowItem = 0;

            for (int k = 0; k < vCashReceiveDetail.size(); k++) {
                CashReceiveDetail cashReceiveDetail = (CashReceiveDetail) vCashReceiveDetail.get(k);

                noRek = "-";
                name = "-";
                result = new Vector();
                penjelasan = "";

                if (cashReceiveDetail.getMemo().length() > 0) {
                    penjelasan = cashReceiveDetail.getMemo();
                }

                try {
                    if (cashReceiveDetail.getCoaId() != 0) {
                        result = DbCashReceiveDetail.getCodeCoa(cashReceiveDetail.getCoaId());
                        noRek = "" + result.get(0);
                        name = "" + result.get(1);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                String strAmount = "";

                if (cashReceiveDetail.getAmount() == 0) {
                    strAmount = "(" + JSPFormater.formatNumber(cashReceiveDetail.getCreditAmount(), "#,###.##") + ")";
                    payment = payment - cashReceiveDetail.getCreditAmount();
                } else {
                    strAmount = JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##");
                    payment = payment + cashReceiveDetail.getAmount();
                }

                try {
                    // proses pengecekan data lebih dengan max carakter
                    loop = 0;
                    sisa = 0;
                    startN = 0;
                    startP = 0;
                    if (name.length() > penjelasan.length()) {
                        loop = name.length() / 21;
                        sisa = name.length() % 21;
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
                                if (startN < name.length()) {
                                    if (name.length() > 0) {
                                        strName = name.substring(startN, name.length());
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
                                if (startN < name.length()) {
                                    if (name.length() > (startN + 21)) {
                                        strName = name.substring(startN, startN + 21);
                                    } else {
                                        strName = name.substring(startN, name.length());
                                    }
                                } else {
                                    strName = "";
                                }
                            } catch (Exception exx) {
                                strName = "";
                            }

                            try {
                                if (startP < penjelasan.length()) {
                                    if (penjelasan.length() > (startP + 20)) {
                                        strPenjelasan = penjelasan.substring(startP, startP + 20);
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

                        startN = startN + 21;
                        startP = startP + 20;

                        // proses pengisian ke table print out
                        obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(2, rowx, "" + (k + 1), obj.TEXT_LEFT);
                        } else {
                            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                        }
                        obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(4, rowx, "" + strName, obj.TEXT_LEFT);
                        obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(6, rowx, "" + noRek, obj.TEXT_LEFT);
                        } else {
                            obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                        }
                        obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                        if (j == 0) {
                            obj.setColumnValue(8, rowx, "" + strAmount, obj.TEXT_RIGHT);
                        } else {
                            obj.setColumnValue(8, rowx, "", obj.TEXT_LEFT);
                        }
                        obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(10, rowx, "" + strPenjelasan, obj.TEXT_LEFT);
                        obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);

                        rowx++;
                        rowLoop++;
                        checkNewPaperOrNot(obj);

                    }
                } catch (Exception ee) {
                    System.out.println("E>> : " + ee.toString());
                }
            }

            // last item
            lastPrintItem(obj);

            //50
            //60-50 = 10

            // int minLoop = vCashReceiveDetail.size() % maxLoopItem;
            int minLoop = rowItem % maxLoopItem;

            if (minLoop < 0) {
                minLoop = minLoop * -1;
            }

            if (rowItem < maxLoopItem) {
                minLoop = maxLoopItem - rowItem;
            }

            /*if (minLoop > 0) {
                for (int a = 0; a < minLoop; a++) {
                    obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                    obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                    obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                    obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                    obj.setColumnValue(8, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                    obj.setColumnValue(10, rowx, "", obj.TEXT_LEFT);
                    obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);

                    rowx++;
                }
            } else {
                if (minLoop == 0) {
                    int leftPage = (rowx - 1) % obj.getPageLength();
                    leftPage = obj.getPageLength() - leftPage;
                    for (int a = 0; a < leftPage; a++) {
                        obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(8, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                        obj.setColumnValue(10, rowx, "", obj.TEXT_LEFT);
                        obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);

                        rowx++;
                    }
                }
            }*/

            // last footer
            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "=====", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "=====================", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "=", obj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "====================", obj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);


            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "T O T A L", obj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "" + JSPFormater.formatNumber(payment, "#,###.##"), obj.TEXT_RIGHT);
            obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

            // last footer
	    obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "-----", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "---------------------", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(6, rowx, "--------------------", obj.TEXT_LEFT);
            obj.setColumnValue(7, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(8, rowx, "--------------------", obj.TEXT_LEFT);
            obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(10, rowx, "--------------------", obj.TEXT_LEFT);
            obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);

            rowx++;
            rowLoop++;
            checkNewPaperOrNot(obj, false);

        } catch (Exception exc) {
        }

        return obj;
    }

    // footer dari list
    public OXY_PrintObj footerBKM(OXY_PrintObj obj, boolean footLengkap) {
        try {

            checkNewPaperOrNot(obj, true);

            if (footLengkap) {
                // TAMBAHAN SESUAI DESIGN LAMA
                int[] cola = {8, 1, 19, 1, 33, 1, 15, 1, 20, 1};   // 10 coloum
                obj.newColumn(10, "", cola);

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "---------------------------------", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "---------------", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "-", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;


                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "SETUJU DITERIMA", obj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "DIPERIKSA OLEH", obj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "DITERIMA", obj.TEXT_CENTER); //DIBAYAR
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "TELAH DIBUKUKAN", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "---------------------------------", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "---------------", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "-", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                int[] colc = {8, 1, 19, 1, 18, 1, 14, 1, 15, 1, 9, 1, 10, 1};   // 12 coloum
                obj.newColumn(14, "", colc);

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "Paraf", obj.TEXT_CENTER);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "Tanggal", obj.TEXT_CENTER);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);

                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", obj.TEXT_CENTER);
                obj.setColumnValue(11, rowx, "-", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", obj.TEXT_CENTER);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);

                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "1", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "2", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "------------------", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "--------------", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "---------------", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "Kadiv Keu.", obj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "Akuntansi", obj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "Keuangan", obj.TEXT_CENTER);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "Kasir", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "3", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "--------------------", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "------------------", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "--------------", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "---------------", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "---------", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "----------", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;

                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "Tgl  /  /20", obj.TEXT_CENTER);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "Tgl  /  /20", obj.TEXT_CENTER);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "Tgl  /  /20", obj.TEXT_CENTER);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "Tgl  /  /20", obj.TEXT_CENTER);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(12, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(13, rowx, "|", obj.TEXT_LEFT);
                rowx++;
                rowLoop++;
            }

            // START SESUAI DESIGN LAMA

            int[] colb = {8, 1, 38, 1, 51, 1};   // 5 coloum
            obj.newColumn(6, "", colb);

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "--------------------------------------", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "---------------------------------------------------", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            if (footLengkap) {
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            } else {
                obj.setColumnValue(2, rowx, "Diterima oleh, Tgl   /   /20", obj.TEXT_LEFT);
            }
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "Yang menyerahkan pembayaran, Tgl   /   /20", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
            if (footLengkap) {
                obj.setColumnValue(2, rowx, "Direktur Keuangan", obj.TEXT_LEFT);
            } else {
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
            }
            obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "Nama jelas :                         a/n.", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "--------------------------------------", obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "---------------------------------------------------", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(2, rowx, "Dicetak Tanggal: " + JSPFormater.formatDate(new Date(), "dd/MM/yy"), obj.TEXT_LEFT);
            obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
            obj.setColumnValue(5, rowx, "", obj.TEXT_LEFT);
            rowx++;
            rowLoop++;

            // proses last print
            prosesLastPrintAndNewPage(obj);

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
                obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(3, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(5, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(6, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(7, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(8, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
                obj.setColumnValue(10, rowx, "", obj.TEXT_LEFT);
                obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
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
