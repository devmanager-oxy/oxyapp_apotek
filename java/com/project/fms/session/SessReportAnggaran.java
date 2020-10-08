/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.fms.activity.ActivityPeriod;
import com.project.fms.activity.DbActivityPeriod;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.general.DbVendor;
import com.project.general.DbVendorGroup;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author gadnyana
 */
public class SessReportAnggaran {

    public static void main(String[] args) {
        try {
            reportAnggaran(504404360375165817L, new Date());
        } catch (Exception e) {
        }
    }

    public static Vector reportAnggaran(long periodActivityId, Date nowDate) {

        Vector listVector = new Vector();
        Vector listVectorAll = new Vector();
        CONResultSet crs = null;
        String strDateSearch = JSPFormater.formatDate(nowDate, "yyyy-MM-dd");
        try {

            ActivityPeriod activityPeriod = DbActivityPeriod.fetchExc(periodActivityId);

            int monthStart = activityPeriod.getStartDate().getMonth();
            int yearStart = activityPeriod.getStartDate().getYear() + 1900;

            int monthEnd = activityPeriod.getEndDate().getMonth();
            int yearEnd = activityPeriod.getEndDate().getYear() + 1900;
            int loopMonth = 1;

            if ((nowDate.getYear() + 1900) != yearEnd) {
                strDateSearch = JSPFormater.formatDate(activityPeriod.getEndDate(), "yyyy-MM-dd");
            }

            if ((yearEnd - yearStart) == 0) {
                loopMonth = loopMonth + (monthEnd - monthStart);
            } else {
                int selisih = yearEnd - yearStart;
                loopMonth = ((12 * selisih) + monthEnd) - monthStart;
            }

            String sqlAll = "";

            String str = "";
            String strSum = "";

            for (int k = 0; k < loopMonth; k++) {
                str = str + ",0 as bul_" + (k + 1);
                strSum = strSum + ",sum(bul_" + (k + 1) + ") as bul_" + (k + 1);
            }

            String sqlGlobal = "select module_id, module_budget_id, coa_id, code, mdesc, description, pcode, name , sum(btotal) as totbudget, sum(xx) as total" + strSum + " from ";

            String sql = "SELECT mb.module_id, mb.module_budget_id, mb.coa_id, m.code, m.description as mdesc, mb.description, " +
                    " c.code as pcode, c.name, sum(amount) as btotal, 0 as xx " + str + " FROM `module_budget` as mb " +
                    " inner join module as m on mb.module_id=m.module_id " +
                    " inner join coa as c on mb.coa_id=c.coa_id where m.activity_period_id=" + periodActivityId + " group by mb.coa_id";

            String sql2 = "SELECT 0, 0 , gd.coa_id,'','','','','',0,sum(if(gd.debet=0, gd.credit, gd.debet)) as total" + str +
                    " FROM `gl_detail` as gd " +
                    "inner join gl as g on gd.gl_id=g.gl_id " +
                    " where g.posted_status=1 and g.trans_date between '" + JSPFormater.formatDate(activityPeriod.getStartDate(), "yyyy-MM-dd") + "' and '" + strDateSearch + "' " +
                    " and gd.coa_id in (SELECT mb.coa_id FROM `module_budget` as mb " +
                    " inner join module as m on mb.module_id=m.module_id " +
                    " inner join coa as c on mb.coa_id=c.coa_id where m.activity_period_id=" + periodActivityId +
                    " order by mb.module_id, mb.module_budget_id) group by gd.coa_id";

            String sql3 = "";
            String strFields = "";
            String strSQLDetail = "";
            for (int k = 0; k < loopMonth; k++) {
                str = "";
                strFields = "SELECT 0, 0 , gd.coa_id,'','','','','',0,0";
                for (int j = 0; j < loopMonth; j++) {
                    if (j == k) {
                        str = str + ",sum(if(gd.debet=0, gd.credit, gd.debet)) as total";
                    } else {
                        str = str + ",0";
                    }
                }
                strFields = strFields + str;

                sql3 = " union ";
                sql3 = sql3 + strFields + " FROM `gl_detail` as gd " +
                        " inner join gl as g on gd.gl_id=g.gl_id " +
                        " where g.posted_status=1 and month(g.trans_date)=" + (k + 1) + " and year(g.trans_date)=" + yearEnd + " " +
                        " and gd.coa_id in (SELECT mb.coa_id FROM `module_budget` as mb " +
                        " inner join module as m on mb.module_id=m.module_id " +
                        " inner join coa as c on mb.coa_id=c.coa_id where m.activity_period_id=" + periodActivityId +
                        " order by mb.module_id, mb.module_budget_id) group by gd.coa_id";

                strSQLDetail = strSQLDetail + sql3;
            }

            sqlAll = sqlGlobal + "(" + sql + " union " + sql2 + strSQLDetail + ") as tbl group by coa_id order by module_id,module_budget_id";

            crs = CONHandler.execQueryResult(sqlAll);
            ResultSet rs = crs.getResultSet();
            Vector vDetail = new Vector();
            while (rs.next()) {
                vDetail = new Vector();

                vDetail.add(String.valueOf(rs.getString("code")));
                vDetail.add(String.valueOf(rs.getString("mdesc")));
                vDetail.add(String.valueOf(rs.getString("description")));
                vDetail.add(String.valueOf(rs.getString("pcode") + " - " + rs.getString("name")));
                vDetail.add(String.valueOf(rs.getDouble("totbudget")));

                for (int i = 0; i < loopMonth; i++) {
                    vDetail.add(String.valueOf(rs.getDouble("bul_" + (i + 1))));
                }

                listVector.add(vDetail);
            }

            listVectorAll.add("" + loopMonth);
            listVectorAll.add(listVector);

        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }

        return listVectorAll;
    }

    public static Vector reportAnggaran(long periodActivityId, Date nowDate, String segment) {

        Vector listVector = new Vector();
        Vector listVectorAll = new Vector();
        CONResultSet crs = null;

        try {

            ActivityPeriod activityPeriod = DbActivityPeriod.fetchExc(periodActivityId);
            int monthStart = activityPeriod.getStartDate().getMonth();
            int yearStart = activityPeriod.getStartDate().getYear() + 1900;
            int monthEnd = activityPeriod.getEndDate().getMonth();
            int yearEnd = activityPeriod.getEndDate().getYear() + 1900;
            int loopMonth = 1;

            if ((yearEnd - yearStart) == 0) {
                loopMonth = loopMonth + (monthEnd - monthStart);
            } else {
                int selisih = yearEnd - yearStart;
                loopMonth = ((12 * selisih) + monthEnd) - monthStart;
            }

            String whereSegment = "";
            if (segment != null && segment.length() > 0) {
                whereSegment = " and " + segment;
            }

            String sqlGlobal = " select m.module_id as module_id,c.name as name,c.code as pcode,mb.coa_id as coa_id,m.code as code,m.description as mdesc,mb.description as description,sum(mb.amount) as anggaran,0 as jum from module m inner join module_budget mb on m.module_id = mb.module_id inner join coa c on mb.coa_id = c.coa_id  where mb.coa_id != 0 and activity_period_id = " + periodActivityId + " and doc_status=1 " + whereSegment + " group by m.module_id,mb.coa_id ";

            crs = CONHandler.execQueryResult(sqlGlobal);
            ResultSet rs = crs.getResultSet();
            Vector vDetail = new Vector();

            while (rs.next()) {
                vDetail = new Vector();

                vDetail.add(String.valueOf(rs.getString("code")));
                vDetail.add(String.valueOf(rs.getString("mdesc")));
                vDetail.add(String.valueOf(rs.getString("description")));
                vDetail.add(String.valueOf(rs.getString("pcode") + " - " + rs.getString("name")));
                vDetail.add(String.valueOf(rs.getDouble("anggaran")));
                vDetail.add(String.valueOf(rs.getDouble("jum")));
                long moduleId = rs.getLong("module_id");
                long coaId = rs.getLong("coa_id");

                vDetail.add(String.valueOf(moduleId));
                vDetail.add(String.valueOf(coaId));

                Vector r = new Vector();

                double tot = 0;
                for (int i = 0; i < loopMonth; i++) {
                    double month = 0;
                    try {
                        month = Double.parseDouble(String.valueOf(r.get(i)));
                    } catch (Exception e) {
                        month = 0;
                    }
                    vDetail.add(String.valueOf(month));
                    tot = tot + month;
                }
                vDetail.add(String.valueOf(tot));
                listVector.add(vDetail);
            }

            listVectorAll.add("" + loopMonth);
            listVectorAll.add(listVector);

        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return listVectorAll;
    }

    public static Vector reportAnggaranDetail(long moduleId, long coaId, int loopMonth, int yearEnd) {

        CONResultSet crs = null;
        try {

            String str = "";
            String strSum = "";

            for (int k = 0; k < loopMonth; k++) {
                str = str + ",0 as bul_" + (k + 1);
                strSum = strSum + ",sum(bul_" + (k + 1) + ") as bul_" + (k + 1);
            }

            String sqlGlobal = "select module_id,coa_id " + strSum + " from (";

            String strFields = "";

            for (int k = 0; k < loopMonth; k++) {
                str = "";
                if (strFields != null && strFields.length() > 0) {
                    strFields = strFields + " union ";
                }
                strFields = strFields + " select gd.module_id as module_id,gd.coa_id as coa_id  ";
                for (int j = 0; j < loopMonth; j++) {
                    if (j == k) {
                        str = str + ",sum(gd.debet)-sum(gd.credit) as bul_" + (j + 1) + "";
                    } else {
                        str = str + ",0 as bul_" + (j + 1) + "";
                    }
                }

                strFields = strFields + str + " from gl_detail gd inner join gl g on gd.gl_id = g.gl_id inner join module m on gd.module_id = m.module_id  where g.posted_status =1 and month(g.trans_date)=" + (k + 1) + " and year(g.trans_date)=" + yearEnd + " and gd.module_id = " + moduleId + " and gd.coa_id = " + coaId + " group by gd.module_id,gd.coa_id ";
            }

            sqlGlobal = sqlGlobal + strFields + " ) as tbx group by module_id,coa_id ";

            crs = CONHandler.execQueryResult(sqlGlobal);
            ResultSet rs = crs.getResultSet();
            Vector vDetail = new Vector();

            while (rs.next()) {
                vDetail = new Vector();
                for (int i = 0; i < loopMonth; i++) {
                    vDetail.add(String.valueOf(rs.getDouble("bul_" + (i + 1))));
                }
                return vDetail;
            }

        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return new Vector();
    }

    public static Vector getBudgetSuplier(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if (pkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                }
                if (nonPkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                }
            }
            

            String sql =" select vendor_id,vendor_name,journal_number,journal_number,trans_date,amount from ( "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+") v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
    
    public static Vector getBudgetSuplier(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if (pkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                }
                if (nonPkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                }
            }            

            String sql =" select bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,amount from ( "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+                        
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
    
     public static Vector getBudgetSuplier(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type, int non,int konsinyasi,int komisi) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (pkp == 0 && nonPkp == 0){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = -1 ";
            }else{            
                if (!(pkp == 1 && nonPkp == 1)) {
                    if (pkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                    }
                    if (nonPkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                    }
                }
            }
            
            String wherex = "";
            if(non == 0 && konsinyasi == 0 && komisi ==0){
                where = where + " and ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = -1 )";
                
            }else{
            
                if(!(non == 1 && konsinyasi == 1 && komisi ==1)){
                    if(non == 1 || konsinyasi == 1 || komisi ==1){
                        if(konsinyasi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = " + 1;
                            }
                        if(komisi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = " + 1;
                        }
                
                        if(non ==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 0 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = 0 )";
                        }
                        where = where +" and ( "+wherex+" ) ";
                    }
                }
            }

            String sql =" select bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,amount from ( "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,"+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" as is_komisi,"+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" as is_konsinyasi,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+                        
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,"+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" as is_komisi,"+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" as is_konsinyasi,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
     
     
      //add by roy andika
    public static Vector getBudgetSuplierGroup(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type,int paymentType) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if(pkp==0 && nonPkp==0){
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = -1 ";
                }else{                
                    if (pkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                    }
                    if (nonPkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                    }
                }
            }
            
            if(paymentType != -1){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
            }
            
            String sql =" select bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,amount from ( "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+                        
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
     
    
    //add by roy andika
    public static Vector getBudgetSuplier(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type,int paymentType) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if (pkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                }
                if (nonPkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                }
            }
            
            if(paymentType != -1){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
            }
            
            String sql =" select bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,amount from ( "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x order by trans_date ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
    
    public static Vector getBudgetSuplierSummary(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type,int paymentType) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            String wherePayment = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if (pkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                }
                if (nonPkp == 1) {
                    where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                }
            }
            
             if(paymentType != -1){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
                wherePayment = " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
            }
            

            String sql =" select no_rek,bank_id,contact,bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,sum(amount) as xamount from ( "+
                    
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " v.no_rek as no_rek," +
                        " v.bank_id as bank_id," +
                        " v.contact as contact," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_NO_REK]+" as no_rek,v."+DbVendor.colNames[DbVendor.COL_BANK_ID]+" as bank_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,v."+DbVendor.colNames[DbVendor.COL_CONTACT]+" as contact,v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+""+wherePayment+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " v.no_rek as no_rek," +
                        " v.bank_id as bank_id," +
                        " v.contact as contact," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_NO_REK]+" as no_rek,v."+DbVendor.colNames[DbVendor.COL_BANK_ID]+" as bank_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,v."+DbVendor.colNames[DbVendor.COL_CONTACT]+" as contact,v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" "+wherePayment+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x group by vendor_name order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));                
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("xamount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setNoRek(rs.getString("no_rek"));
                bgt.setBankId(rs.getLong("bank_id"));
                bgt.setContact(rs.getString("contact"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
    
     public static Vector getBudgetSuplierSummary(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp,int type,int paymentType,int non,int konsinyasi,int komisi) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            
            String where = "";
            String wherePayment = "";
            
            if (suplierId != 0) {
                where = where + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                where = where + " and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + ") <=  to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "')";
            }

            if (pkp == 0 && nonPkp == 0){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = -1 ";
            }else{            
                if (!(pkp == 1 && nonPkp == 1)) {
                    if (pkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                    }
                    if (nonPkp == 1) {
                        where = where + " and v." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                    }
                }
            }
            
            String wherex = "";
            if(non == 0 && konsinyasi == 0 && komisi ==0){
                where = where + " and ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = -1 )";
                
            }else{
            
                if(!(non == 1 && konsinyasi == 1 && komisi ==1)){
                    if(non == 1 || konsinyasi == 1 || komisi ==1){
                        if(konsinyasi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = " + 1;
                            }
                        if(komisi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = " + 1;
                        }
                
                        if(non ==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 0 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = 0 )";
                        }
                        where = where +" and ( "+wherex+" ) ";
                    }
                }
            }
            
            if(paymentType != -1){
                where = where + " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
                wherePayment = " and v." + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE] + " = " + paymentType;
            }
            

            String sql =" select no_rek,bank_id,contact,bank_po_id,vendor_id,vendor_name,journal_number,journal_number,trans_date,sum(amount) as xamount from ( "+
                    
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " v.no_rek as no_rek," +
                        " v.bank_id as bank_id," +
                        " v.contact as contact," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" as is_komisi,v."+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" as is_konsinyasi,v."+DbVendor.colNames[DbVendor.COL_NO_REK]+" as no_rek,v."+DbVendor.colNames[DbVendor.COL_BANK_ID]+" as bank_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,v."+DbVendor.colNames[DbVendor.COL_CONTACT]+" as contact,v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,vg."+DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]+" as name from "+DbVendor.DB_VENDOR+" v inner join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+""+wherePayment+" ) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                        " union "+
                        " select v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bank_po_id," +
                        " v."+DbVendor.colNames[DbVendor.COL_NAME]+" as vendor_name," +
                        " v.no_rek as no_rek," +
                        " v.bank_id as bank_id," +
                        " v.contact as contact," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number," +
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date," +
                        " sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") as amount " +
                        " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+
                        " inner join (select v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" as is_komisi,v."+DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]+" as is_konsinyasi,v."+DbVendor.colNames[DbVendor.COL_NO_REK]+" as no_rek,v."+DbVendor.colNames[DbVendor.COL_BANK_ID]+" as bank_id,"+DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+" as payment_type,v."+DbVendor.colNames[DbVendor.COL_CONTACT]+" as contact,v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" as vendor_id,"+DbVendor.colNames[DbVendor.COL_IS_PKP]+" as is_pkp,v."+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" v left join "+DbVendorGroup.DB_VENDOR_GROUP+" vg on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" where v." + DbVendor.colNames[DbVendor.COL_TYPE] + " = " + type+" "+wherePayment+" and vg."+DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]+" is null) v on bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                        " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 1 "+where+
                        " group by bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+") as x group by vendor_name order by vendor_name,journal_number ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setBankpoPaymentId(rs.getLong("bank_po_id"));                
                bgt.setVendorId(rs.getLong("vendor_id"));
                bgt.setSuplier(rs.getString("vendor_name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("journal_number"));
                bgt.setValue(rs.getDouble("xamount"));
                bgt.setTransDate(rs.getDate("trans_date"));
                bgt.setNoRek(rs.getString("no_rek"));
                bgt.setBankId(rs.getLong("bank_id"));
                bgt.setContact(rs.getString("contact"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }
    
}
