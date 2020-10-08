/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.I_Project;
import com.project.fms.master.Coa;
import com.project.fms.master.DbAccLink;
import com.project.fms.master.DbCoa;
import com.project.fms.transaction.DbCashReceive;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.DbPettycashPayment;
import com.project.fms.transaction.DbPettycashReplenishment;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class SessCashTransaction {

    public static String getCondition(String type, String whereClause) {

        if (type.equals("cashreceive")) {

            whereClause = (whereClause.length() > 0) ? whereClause +
                    " AND " + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME : "" + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME;

        } else if (type.equals("paymentpettycash")) {

            whereClause = (whereClause.length() > 0) ? whereClause +
                    " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA + " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS] + " = " + DbPettycashPayment.STATUS_TYPE_APPROVED : "" + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA + " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS] + " = " + DbPettycashPayment.STATUS_TYPE_APPROVED;

        } else if (type.equals("advancereceive")) {

            whereClause = (whereClause.length() > 0) ? whereClause +
                    " AND " + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME_KASBON : "" + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME_KASBON;

        } else if (type.equals("advance")) {

            whereClause = (whereClause.length() > 0) ? whereClause +
                    " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_KASBON + " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS] + " = " + DbPettycashPayment.STATUS_TYPE_APPROVED : "" + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_KASBON + " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS] + " = " + DbPettycashPayment.STATUS_TYPE_APPROVED;
        }

        return whereClause;

    }

    public static int getVectorSize(String type, String whereClause) {

        int vectSize = 0;

        if (type.equals("cashreceive")) {

            vectSize = DbCashReceive.getCount(whereClause);

        } else if (type.equals("paymentpettycash")) {

            vectSize = DbPettycashPayment.getCount(whereClause);

        } else if (type.equals("paymentreplenishmentcash")) {

            vectSize = DbPettycashReplenishment.getCount(whereClause);

        } else if (type.equals("advancereceive")) {

            vectSize = DbCashReceive.getCount(whereClause);

        } else if (type.equals("advance")) {

            vectSize = DbPettycashPayment.getCount(whereClause);

        }

        return vectSize;

    }

    public static Vector getListCashArchive(String type, int start, int recordToGet, String whereClause, String orderClause) {

        Vector listCashArchive = new Vector();

        try {

            if (type.equals("cashreceive")) {
                listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);
            } else if (type.equals("paymentpettycash")) {
                listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            } else if (type.equals("paymentreplenishmentcash")) {
                listCashArchive = DbPettycashReplenishment.list(start, recordToGet, whereClause, orderClause);
            } else if (type.equals("advancereceive")) {
                listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);
            } else if (type.equals("advance")) {
                listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            }

            return listCashArchive;

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }


        return null;

    }

    public static String getWhereArchive(String type, String whereClause) {

        try {

            if (type.equals("cashreceive")) {

                whereClause = (whereClause.length() > 0) ? whereClause +
                        " AND " + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME : "" + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME;

            } else if (type.equals("paymentpettycash")) {

                whereClause = (whereClause.length() > 0) ? whereClause +
                        " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA : "" + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA;

            } else if (type.equals("advancereceive")) {

                whereClause = (whereClause.length() > 0) ? whereClause +
                        " AND " + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME_KASBON : "" + DbCashReceive.colNames[DbCashReceive.COL_TYPE] + " = " + DbCashReceive.TYPE_CASH_INCOME_KASBON;

            } else if (type.equals("advance")) {

                whereClause = (whereClause.length() > 0) ? whereClause +
                        " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_KASBON : "" + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_KASBON;

            }else if (type.equals("payment")) {

                whereClause = (whereClause.length() > 0) ? whereClause +
                        " AND " + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PELUNASAN_TUNAI : "" + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + " = " + DbPettycashPayment.STATUS_TYPE_PELUNASAN_TUNAI;

            }

            return whereClause;

        } catch (Exception E) {
            System.out.println("[exception ] " + E.toString());
        }

        return null;

    }

    public static int getVectorArchive(String type, String whereClause) {

        try {

            int vectSize = 0;

            if (type.equals("cashreceive")) {

                vectSize = DbCashReceive.getCount(whereClause);

            } else if (type.equals("paymentpettycash")) {

                vectSize = DbPettycashPayment.getCount(whereClause);

            } else if (type.equals("paymentreplenishmentcash")) {

                vectSize = DbPettycashReplenishment.getCount(whereClause);

            } else if (type.equals("advancereceive")) {

                vectSize = DbCashReceive.getCount(whereClause);

            } else if (type.equals("advance")) {

                vectSize = DbPettycashPayment.getCount(whereClause);

            }else if (type.equals("payment")) {

                vectSize = DbPettycashPayment.getCount(whereClause);

            }

            return vectSize;

        } catch (Exception E) {
            System.out.println("Exception " + E.toString());
        }

        return 0;

    }

    public static double getTotalCashRegister(Date dtTransaction, long sysLocId) {

        try {

            Vector listAcc = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH, sysLocId);

            if (listAcc != null && listAcc.size() > 0) {
                
                double totalCredit = 0;
                double totalDebet = 0;
                double totOpening = 0;
                Vector accLinks = new Vector();

                for (int i = 0; i < listAcc.size(); i++) {

                    Coa coax = (Coa) listAcc.get(i);

                    String whereAccLink = DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + coax.getOID();

                    accLinks = DbCoa.list(0, 0, whereAccLink, null);

                    if (accLinks != null && accLinks.size() > 0) {

                        for (int j = 0; j < accLinks.size(); j++) {

                            Coa coa = (Coa) accLinks.get(j);

                            boolean isDebetPosition = false;

                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                isDebetPosition = true;
                            }

                            Vector temp = DbGlDetail.getGeneralLedger(dtTransaction, coa.getOID());
                            double openingBalance = 0;
                            //jika bukan expense dan revenue
                            if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
                                    coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {

                                openingBalance = DbGlDetail.getGLOpeningBalance(dtTransaction, coa);

                            }

                            if (temp != null && temp.size() > 0) {

                                for (int x = 0; x < temp.size(); x++) {

                                    Vector gld = (Vector) temp.get(x);
                                    Gl gl = (Gl) gld.get(0);
                                    GlDetail gd = (GlDetail) gld.get(1);

                                    try {
                                        gd = DbGlDetail.fetchExc(gd.getOID());
                                    } catch (Exception e) {}

                                    if (isDebetPosition) {
                                        openingBalance = openingBalance + (gd.getDebet() - gd.getCredit());
                                    } else {
                                        openingBalance = openingBalance + (gd.getCredit() - gd.getDebet());
                                    }

                                    totalDebet = totalDebet + gd.getDebet();
                                    totalCredit = totalCredit + gd.getCredit();

                                }
                            }
                            
                            totOpening = totOpening + openingBalance;
                        }
                    }
                }
                
                return totOpening;

            } else {
                return 0;
            }

        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        }
        
        return 0;

    }
}
