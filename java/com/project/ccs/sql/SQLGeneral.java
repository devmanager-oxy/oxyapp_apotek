package com.project.ccs.sql;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.JSPFormater;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.datasync.*;
import com.project.general.Vendor;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.general.Location;
import com.project.ccs.posmaster.Shift;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;

public class SQLGeneral {

    public static int UPLOAD_SUCCESS = 1;
    public static int UPLOAD_FAILED = 0;
    
    public static int executeSQL(String SQL) {
        int val = UPLOAD_FAILED;
        try {
                CONHandler.execUpdate(SQL); 
                val = UPLOAD_SUCCESS;
            
        } catch (CONException dbexc) {
            int excCode = dbexc.getErrorCode();

            switch (excCode) {
                case I_CONExceptionInfo.MULTIPLE_ID:
                    val = UPLOAD_SUCCESS;
                    break;

                case I_CONExceptionInfo.SQL_ERROR:
                    val = UPLOAD_FAILED;
                    break;

                case I_CONExceptionInfo.CONCURRENCY_VIOLATION:
                    val = UPLOAD_FAILED;
                    break;

                default:
                    val = UPLOAD_FAILED;
                    break;
            }
        } catch (Exception exc) {
            val = UPLOAD_FAILED;
        }

        return val;

    }
    
    public static int executeSQL(String SQL, int type, String dbName, String fieldName, long dataOID) {
        int val = UPLOAD_FAILED;
        try {
            if(type==0){
                val = executeCheckDATA(dbName,fieldName,dataOID);
                if(val==UPLOAD_FAILED){
                    CONHandler.execUpdate(SQL);
                    val = UPLOAD_SUCCESS;
                }
            }else{
                CONHandler.execUpdate(SQL);
                val = UPLOAD_SUCCESS;
            }
            
        } catch (CONException dbexc) {
            int excCode = dbexc.getErrorCode();

            switch (excCode) {
                case I_CONExceptionInfo.MULTIPLE_ID:
                    val = UPLOAD_SUCCESS;
                    break;

                case I_CONExceptionInfo.SQL_ERROR:
                    val = UPLOAD_FAILED;
                    break;

                case I_CONExceptionInfo.CONCURRENCY_VIOLATION:
                    val = UPLOAD_FAILED;
                    break;

                default:
                    val = UPLOAD_FAILED;
                    break;
            }
        } catch (Exception exc) {
            val = UPLOAD_FAILED;
        }

        return val;

    }

    /**
     * method untuk mencari status log balance kasir
     * ini di dapat dari kiriman tiap kasir
     **/
    public static Vector listStatusBalanceCashier(long locationOid, Date tglBalance) {
        CONResultSet crs = null;
        Vector list = new Vector(); 
        try {
            String sql = "select * from pos_status_balance where b_date between '" + JSPFormater.formatDate(tglBalance, "yyyy-MM-dd") + "' "
                    + " and '" + JSPFormater.formatDate(tglBalance, "yyyy-MM-dd") + "' ";
            if (locationOid != 0) {
                sql = sql + " and location_id=" + locationOid;
            }
            sql = sql + " order by location_name, shift_name";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                SalesClosing sales = new SalesClosing();
                sales.setTglJam(rs.getDate("b_date"));
                sales.setLocationOid(rs.getLong("location_id"));
                sales.setMember(rs.getString("location_name"));
                sales.setShiftOid(rs.getLong("shift_id"));
                sales.setName1(rs.getString("shift_name"));
                sales.setName2(rs.getString("status_balance"));
                sales.setName3(rs.getString("description"));
                sales.setName4(rs.getString("status_update"));
                sales.setName5(rs.getString("update_description"));
                list.add(sales);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector listTotalSalesYear(long locationOid, long groupOid, long suppOid, int typeReport, int year, long customerId, int sort) {
        CONResultSet crs = null;
        Vector list = new Vector();
        String fieldNames = "qty";
        if (typeReport == 1) {
            fieldNames = "total";
        }
        String sorted = "name";
        if (sort == 1) {
            sorted = "tot";
        }

        try {
            String sql = "select pm.code, pm.barcode, pm.name, sum(pd." + fieldNames + ") as jan, 0 as feb, "
                    + " 0 as mar, 0 as apr, 0 as mei, 0 as jun, 0 as jul, 0 as aug, 0 as sep, "
                    + " 0 as okt, 0 as nop, 0 as des, sum(pd." + fieldNames + ") as qty_tot from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=1 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, sum(pd." + fieldNames + "),0,0,0,0,0,0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=2 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=3 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=4 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=5 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=6 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=7 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=8 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=9 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=10 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),0,sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=11 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            sql = sql + "union select pm.code, pm.barcode, pm.name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sum(pd." + fieldNames + "),sum(pd." + fieldNames + ") from pos_sales_detail as pd "
                    + " inner join pos_sales as ps on pd.sales_id=ps.sales_id "
                    + " inner join pos_item_master as pm on pd.product_master_id=pm.item_master_id "
                    + " where (month(ps.date)=12 and year(ps.date)=" + year + ")";
            if (locationOid != 0) {
                sql = sql + " and ps.location_id=" + locationOid;
            }
            if (groupOid != 0) {
                sql = sql + " and pm.item_group_id=" + groupOid;
            }
            if (suppOid != 0) {
                sql = sql + " and pm.default_vendor_id=" + suppOid;
            }
            if (customerId != 0) {
                sql = sql + " and ps.customer_id=" + customerId;
            }
            sql = sql + " group by pd.product_master_id ";

            String sqlGabung = "select code,barcode,name,sum(jan), sum(feb), sum(mar),sum(apr), sum(mei), sum(jun), "
                    + " sum(jul), sum(aug), sum(sep), sum(okt), sum(nop), sum(des), sum(qty_tot) as tot "
                    + " from (" + sql + ") as tabel group by code order by " + sorted;//limit 1000,1000";


            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            Vector listdt = new Vector();
            while (rs.next()) {
                listdt = new Vector();
                listdt.add(rs.getString("code"));
                listdt.add(rs.getString("barcode"));
                listdt.add(rs.getString("name"));
                if (rs.getDouble("sum(jan)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(jan)"), "##,###")));
                }

                if (rs.getDouble("sum(feb)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(feb)"), "##,###")));
                }

                if (rs.getDouble("sum(mar)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(mar)"), "##,###")));
                }

                if (rs.getDouble("sum(apr)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(apr)"), "##,###")));
                }

                if (rs.getDouble("sum(mei)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(mei)"), "##,###")));
                }

                if (rs.getDouble("sum(jun)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(jun)"), "##,###")));
                }

                if (rs.getDouble("sum(jul)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(jul)"), "##,###")));
                }

                if (rs.getDouble("sum(aug)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(aug)"), "##,###")));
                }

                if (rs.getDouble("sum(sep)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(sep)"), "##,###")));
                }

                if (rs.getDouble("sum(okt)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(okt)"), "##,###")));
                }

                if (rs.getDouble("sum(nop)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(nop)"), "##,###")));
                }

                if (rs.getDouble("sum(des)") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("sum(des)"), "##,###")));
                }

                if (rs.getDouble("tot") == 0) {
                    listdt.add(String.valueOf(""));
                } else {
                    listdt.add(String.valueOf(JSPFormater.formatNumber(rs.getDouble("tot"), "##,###")));
                }

                list.add(listdt);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static int executeCheckDATA(String dbName, String fieldName, long dataOID) {
        int val = UPLOAD_FAILED;
        CONResultSet crs = null;

        try {
            String SQL = "select " + fieldName + " from " + dbName + " where " + fieldName + "=" + dataOID;
            crs = CONHandler.execQueryResult(SQL);
            ResultSet rs = crs.getResultSet();

            while (rs.next()){
                val = UPLOAD_SUCCESS;
            }

        } catch (CONException dbexc) {
            val = UPLOAD_FAILED;

        } catch (Exception exc) {  

            val = UPLOAD_FAILED;
        }
        return val;
    }

    public static int getStatusData(String tableName, String strWhere) {
        CONResultSet crs = null;
        int statusOK = 0;
        try {
            String sql = "select * from " + tableName + " where " + strWhere;            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                statusOK = 1;
            }
            rs.close();
            crs.closeResultSet();

        } catch (Exception e) {
            System.out.println("ERR >>> getStatusData : " + e.toString());
        }

        return statusOK;
    }

    public static String createExportFile(String fileName, String sql) {
        boolean result = true;
        PrintStream MyOutput = null;
        try {
            MyOutput = new PrintStream(new FileOutputStream(fileName));
        } catch (IOException e) {
            System.out.println(e.toString());            
        }

        CONResultSet crs = null;
        Vector temp = new Vector();
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                String str = rs.getString("query_string");
                temp.add(str);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                String query = (String) temp.get(i);
                if (query == null || query.length() == 0) {
                    MyOutput.print(" ");
                } else {
                    MyOutput.print(query + "|#");
                }

                MyOutput.println("");
                MyOutput.flush();
            }
            MyOutput.close();
        }
        try {
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            bh.setStartDate(new Date());
            bh.setEndDate(new Date());
            bh.setNote("Backup data customer");
            bh.setType(DbBackupHistory.TYPE_BACKUP);

            DbBackupHistory.insertExc(bh);
        } catch (Exception e) {
        }
        return fileName;
    }

    /**
     * proses pengambilan data yg di update
     */
    public static String createMasterUpdate(String sql) {
        CONResultSet crs = null;
        String strQuery = "";
        try {            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                String str = rs.getString("query_string") + "###" + rs.getString("log_id") + "|#";
                strQuery = strQuery + str;
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return strQuery;
    }

    public static double getTotalCreditPayment(long oisSales) {
        CONResultSet crs = null;
        double totPay = 0;
        try {
            String sql = "select sum(amount) as amount from pos_credit_payment where sales_id=" + oisSales;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                totPay = rs.getDouble("amount");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return totPay;
    }

    /**
     * di pakai untuk mencari data penjualan yang tercancel
     */
    public static Vector listSalesCancel(String where) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select * from pos_sales_cancel";
            if (where.length() > 0) {
                sql = sql + " where " + where;
            }
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Sales sales = new Sales();
                sales.setOID(rs.getLong("sales_id"));
                sales.setNumber(rs.getString("number"));
                sales.setDate(rs.getDate("date"));
                sales.setName(rs.getString("name"));
                sales.setUserId(rs.getLong("user_id"));
                sales.setAmount(rs.getDouble("amount"));
                sales.setCurrencyId(rs.getLong("location_id"));
                list.add(sales);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getDataSummarySalesItem(Date tanggal, Date tanggalTo,
            long locationOID, long categoryOid, long suppOid) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select itm.code, itm.name, sum(pi.cogs) as cogs, sum(pi.qty * pi.cogs) as totalcogs, "
                    + " sum(pi.selling_price) as sellprice, sum(pi.discount_amount) as disc, sum(pi.amount) as totsell, pi.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id"
                    + " inner join pos_sales_item as pi on p.sales_id=pi.sales_id"
                    + " inner join pos_item_master as itm on pi.item_master_id=itm.item_master_id"
                    + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' ";

            if (locationOID != 0) {
                sql = sql + " and p.location_id=" + locationOID;
            }

            if (categoryOid != 0) {
                sql = sql + " and itm.group_id=" + categoryOid;
            }

            if (suppOid != 0) {
                sql = sql + " and itm.vendor_id=" + suppOid;
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setAmount(rs.getDouble("tot"));
                salesClosing.setAmount(rs.getDouble("tot"));
                salesClosing.setAmount(rs.getDouble("tot"));
                salesClosing.setAmount(rs.getDouble("tot"));
                salesClosing.setAmount(rs.getDouble("tot"));
                salesClosing.setAmount(rs.getDouble("tot"));

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataSummarySales : " + e.toString());
        }

        return list;
    }

    public static Vector getDataSummarySales(Date tanggal, Date tanggalTo) {
        CONResultSet crs = null;
        Vector list = new Vector();  
        try {
            String sql = "select sum(tot) as tot, name from "+                    
                    "(select sum((sd.qty * sd.selling_price)- sd.discount_amount "+
                    //add by Eka === cover disc global, service & ppn
                    "- ((sd.qty * sd.selling_price)*p.discount_percent/100) + "+
                    "(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100))*p.service_percent/100)+ "+
                    "(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100)+(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100))*p.service_percent/100))*p.vat_percent/100) "+
                    //============================
                    ") as tot, pl.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id"
                    + " inner join pos_sales_detail as sd on p.sales_id=sd.sales_id"
                    + " where p.type in (0,1) and p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' "
                    + " group by p.location_id union "
                    +"  select sum((sd.qty * sd.selling_price)- sd.discount_amount)*-1 as tot, pl.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id"
                    + " inner join pos_sales_detail as sd on p.sales_id=sd.sales_id"
                    + " where p.type in (2,3) and p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' "
                    + " group by p.location_id) as sumtab group by name ";
                    /*+ " select sum(sdx.total * -1) as tot, pl.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id "
                    + " inner join pos_sales as pr on pr.sales_retur_id=p.sales_id " 
                    + " inner join pos_sales_detail as sdx on pr.sales_id=sdx.sales_id"
                    + " where pr.type in (2,3) and p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' "
                    + " group by p.location_id) as sumtab group by name";*/
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setAmount(rs.getDouble("tot"));

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataSummarySales : " + e.toString());
        }

        return list;
    }
    
    public static Vector getDataSummarySales(Date tanggal, Date tanggalTo,Vector locations) {
        CONResultSet crs = null;
        Vector list = new Vector();  
        
        if(locations == null || locations.size() <= 0){
            return list;
        }
        
        String strLocation = "";
        if(locations != null && locations.size()>0){
            for(int i = 0 ; i < locations.size(); i++){
                Location l = (Location)locations.get(i);
                if(strLocation != null && strLocation.length() > 0){
                    strLocation = strLocation + ",";
                }
                strLocation = strLocation + l.getOID();
            }
        }
        try {
            String sql = "select sum(tot) as tot, name from "+                    
                    "(select sum((sd.qty * sd.selling_price)- sd.discount_amount "+
                    //add by Eka === cover disc global, service & ppn
                    "- ((sd.qty * sd.selling_price)*p.discount_percent/100) + "+
                    "(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100))*p.service_percent/100)+ "+
                    "(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100)+(((sd.qty * sd.selling_price)- sd.discount_amount - ((sd.qty * sd.selling_price)*p.discount_percent/100))*p.service_percent/100))*p.vat_percent/100) "+
                    //============================
                    ") as tot, pl.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id"
                    + " inner join pos_sales_detail as sd on p.sales_id=sd.sales_id"
                    + " where p.type in (0,1) and p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' and pl.location_id in ("+strLocation+") "
                    + " group by p.location_id union "
                    +"  select sum((sd.qty * sd.selling_price)- sd.discount_amount)*-1 as tot, pl.name from pos_sales as p "
                    + " inner join pos_location as pl on pl.location_id=p.location_id"
                    + " inner join pos_sales_detail as sd on p.sales_id=sd.sales_id"
                    + " where p.type in (2,3) and p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' "
                    + " and '" + JSPFormater.formatDate(tanggalTo, "yyyy-MM-dd 23:59:59") + "' and pl.location_id in ("+strLocation+") "
                    + " group by p.location_id) as sumtab group by name ";                   
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setAmount(rs.getDouble("tot"));

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataSummarySales : " + e.toString());
        }

        return list;
    }
    
    public static Vector getDataCustomerCredit(String invnumber, long customerId) {
        CONResultSet crs = null;
        Vector list = new Vector(); 
        String where = "";
        try {
            String sql = "select s.sales_id, s.customer_id ,s.number, s.name, sum(dt.total) as total from "+DbSales.DB_SALES+" as s "+
                    " inner join "+DbSalesDetail.DB_SALES_DETAIL+" as dt on s.sales_id=dt.sales_id "+
                    " where s.type=1";

            if(invnumber.length()>0){
                where = where + " and s.number='"+invnumber+"'";
            }

            if(customerId!=0){
                where = where + " and s.customer_id="+customerId;
            }

            if(where.length() > 0){
                sql = sql + where;
            }

            if((invnumber.length()==0) && (customerId!=0)){
                sql = sql + " group by s.customer_id";
            }else{
                sql = sql + " group by s.sales_id, s.customer_id";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Sales sales = new Sales();
            while (rs.next()) {
                sales = new Sales();
                sales.setOID(rs.getLong("sales_id"));
                sales.setNumber(rs.getString("number"));
                sales.setName(rs.getString("name"));
                sales.setAmount(rs.getDouble("total"));
                sales.setCustomerId(rs.getLong("customer_id"));

                list.add(sales);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataCustomerCredit : " + e.toString());
        }

        return list;
    }

    public static double getDataCustomerCreditOnline(long customerId) {
        CONResultSet crs = null;
        try {
            String sql = "select sum(s.amount) - sum(p.amount) as totalb from pos_sales as s left join pos_credit_payment as p on s.sales_id=p.sales_id where s.type = 1 and s.payment_status = 1 and s.customer_id = " + customerId;
  
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                return rs.getDouble("totalb");
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataCustomerCredit : " + e.toString());
        }
        return 0;
        
    }
    
    public static Vector getDataTopSales(Date tanggal, Date tanggalEnd, long locationOid, int groupByLoc,
            long groupOid, int groupByGroup, long vendorOid, int groupByVendor, int groupByItem, int maxLimit) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select sum(d.qty) as cnt, "
                    + " m.name, m.code ";

            if (groupByGroup == 1) {
                sql = sql + ", ig.name as namegroup";
            }
            if (groupByVendor == 1) {
                sql = sql + ", vd.name as namevd";
            }
            if (groupByLoc == 1) {
                sql = sql + ", loc.name as nameloc";
            }

            sql = sql + " from pos_sales_detail as d "
                    + " inner join pos_item_master as m on d.product_master_id=m.item_master_id"
                    + " inner join pos_sales as s on d.sales_id=s.sales_id";

            if (groupByGroup == 1) {
                sql = sql + " inner join pos_item_group as ig on m.item_group_id=ig.item_group_id";
            }

            if (groupByVendor == 1) {
                sql = sql + " inner join vendor as vd on m.default_vendor_id=vd.vendor_id";
            }

            if (groupByLoc == 1) {
                sql = sql + " inner join pos_location as loc on s.location_id=loc.location_id";
            }

            sql = sql + " where s.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd 23:59:59") + "'";

            if (groupOid != 0) {
                sql = sql + " and m.item_group_id=" + groupOid;
            }

            if (vendorOid != 0) {
                sql = sql + " and m.default_vendor_id=" + vendorOid;
            }

            if (locationOid != 0) {
                sql = sql + " and s.location_id=" + locationOid;
            }

            String groupSQL = "";

            // create default
            if (groupByGroup == 0 && groupByVendor == 0 && groupByLoc == 0) {
                groupByItem = 1;
            }

            if (groupByItem == 1) {
                groupSQL = groupSQL + " d.product_master_id";
            }

            if (groupByLoc == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", s.location_id ";
                } else {
                    groupSQL = groupSQL + " s.location_id ";
                }
            }

            if (groupByGroup == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.item_group_id ";
                } else {
                    groupSQL = groupSQL + " m.item_group_id ";
                }
            }

            if (groupByVendor == 1) { // group by department/group
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.default_vendor_id ";
                } else {
                    groupSQL = groupSQL + " m.default_vendor_id ";
                }
            }

            if (groupSQL.length() > 0) {
                sql = sql + " group by " + groupSQL;
            }

            sql = sql + " order by cnt desc limit 0," + maxLimit;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                if (groupByItem == 1) {
                    salesClosing.setMember(rs.getString("name"));
                    salesClosing.setInvoiceNumber(rs.getString("code"));
                }
                if (groupByGroup == 1) {
                    salesClosing.setName1(rs.getString("namegroup"));
                }
                if (groupByVendor == 1) {
                    salesClosing.setName2(rs.getString("namevd"));
                }
                if (groupByLoc == 1) {
                    salesClosing.setName3(rs.getString("nameloc"));
                }

                salesClosing.setJmlQty(rs.getDouble("cnt"));
                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataTopSales : " + e.toString());
        }

        return list;
    }
    
    public static Vector getDataTopSales(Date tanggal, Date tanggalEnd, long locationOid, int groupByLoc,
            long groupOid, int groupByGroup, long vendorOid, int groupByVendor, int groupByItem, int maxLimit, int all) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select sum(d.qty) as cnt, "
                    + " m.name, m.code ,d."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+" as price ";

            if (groupByGroup == 1) {
                sql = sql + ", ig.name as namegroup";
            }
            if (groupByVendor == 1) {
                sql = sql + ", vd.name as namevd";
            }
            if (groupByLoc == 1) {
                sql = sql + ", loc.name as nameloc";
            }

            sql = sql + ", sum(d.qty * d.selling_price) as totPrice from pos_sales_detail as d "
                    + " inner join pos_item_master as m on d.product_master_id=m.item_master_id"
                    + " inner join pos_sales as s on d.sales_id=s.sales_id";

            if (groupByGroup == 1) {
                sql = sql + " inner join pos_item_group as ig on m.item_group_id=ig.item_group_id";
            }

            if (groupByVendor == 1) {
                sql = sql + " inner join vendor as vd on m.default_vendor_id=vd.vendor_id";
            }

            if (groupByLoc == 1) {
                sql = sql + " inner join pos_location as loc on s.location_id=loc.location_id";
            }

            sql = sql + " where s.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd 23:59:59") + "'";

            if (groupOid != 0) {
                sql = sql + " and m.item_group_id=" + groupOid;
            }

            if (vendorOid != 0) {
                sql = sql + " and m.default_vendor_id=" + vendorOid;
            }

            if (locationOid != 0) {
                sql = sql + " and s.location_id=" + locationOid;
            }

            String groupSQL = "";

            // create default
            if (groupByGroup == 0 && groupByVendor == 0 && groupByLoc == 0) {
                groupByItem = 1;
            }

            if (groupByItem == 1) {
                groupSQL = groupSQL + " d.product_master_id";
            }

            if (groupByLoc == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", s.location_id ";
                } else {
                    groupSQL = groupSQL + " s.location_id ";
                }
            }

            if (groupByGroup == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.item_group_id ";
                } else {
                    groupSQL = groupSQL + " m.item_group_id ";
                }
            }

            if (groupByVendor == 1) { // group by department/group
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.default_vendor_id ";
                } else {
                    groupSQL = groupSQL + " m.default_vendor_id ";
                }
            }

            if (groupSQL.length() > 0) {
                sql = sql + " group by " + groupSQL;
            }

            if(all == 1){
                sql = sql + " order by cnt desc";
            }else{
                sql = sql + " order by cnt desc limit 0," + maxLimit;
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                if (groupByItem == 1) {
                    salesClosing.setMember(rs.getString("name"));
                    salesClosing.setInvoiceNumber(rs.getString("code"));
                }
                if (groupByGroup == 1) {
                    salesClosing.setName1(rs.getString("namegroup"));
                }
                if (groupByVendor == 1) {
                    salesClosing.setName2(rs.getString("namevd"));
                }
                if (groupByLoc == 1) {
                    salesClosing.setName3(rs.getString("nameloc"));
                }

                salesClosing.setJmlQty(rs.getDouble("cnt"));
                salesClosing.setCash(rs.getDouble("price"));
                salesClosing.setTotPrice(rs.getDouble("totPrice"));
                
                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataTopSales : " + e.toString());
        }

        return list;
    }
    public static Vector getDataTopSalesOrderBy(Date tanggal, Date tanggalEnd, long locationOid, int groupByLoc,
            long groupOid, int groupByGroup, long vendorOid, int groupByVendor, int groupByItem, int maxLimit, int all, int orderBy) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select sum(d.qty) as cnt, "
                    + " m.name, m.code ,d."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+" as price ";

            if (groupByGroup == 1) {
                sql = sql + ", ig.name as namegroup";
            }
            if (groupByVendor == 1) {
                sql = sql + ", vd.name as namevd";
            }
            if (groupByLoc == 1) {
                sql = sql + ", loc.name as nameloc";
            }

            sql = sql + ", sum(d.qty * d.selling_price) as totPrice from pos_sales_detail as d "
                    + " inner join pos_item_master as m on d.product_master_id=m.item_master_id"
                    + " inner join pos_sales as s on d.sales_id=s.sales_id";

            if (groupByGroup == 1) {
                sql = sql + " inner join pos_item_group as ig on m.item_group_id=ig.item_group_id";
            }

            if (groupByVendor == 1) {
                sql = sql + " inner join vendor as vd on m.default_vendor_id=vd.vendor_id";
            }

            if (groupByLoc == 1) {
                sql = sql + " inner join pos_location as loc on s.location_id=loc.location_id";
            }

            sql = sql + " where s.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd 23:59:59") + "'";

            if (groupOid != 0) {
                sql = sql + " and m.item_group_id=" + groupOid;
            }

            if (vendorOid != 0) {
                sql = sql + " and m.default_vendor_id=" + vendorOid;
            }

            if (locationOid != 0) {
                sql = sql + " and s.location_id=" + locationOid;
            }

            String groupSQL = "";

            // create default
            if (groupByGroup == 0 && groupByVendor == 0 && groupByLoc == 0) {
                groupByItem = 1;
            }

            if (groupByItem == 1) {
                groupSQL = groupSQL + " d.product_master_id";
            }

            if (groupByLoc == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", s.location_id ";
                } else {
                    groupSQL = groupSQL + " s.location_id ";
                }
            }

            if (groupByGroup == 1) { // group by item
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.item_group_id ";
                } else {
                    groupSQL = groupSQL + " m.item_group_id ";
                }
            }

            if (groupByVendor == 1) { // group by department/group
                if (groupSQL.length() > 0) {
                    groupSQL = groupSQL + ", m.default_vendor_id ";
                } else {
                    groupSQL = groupSQL + " m.default_vendor_id ";
                }
            }

            if (groupSQL.length() > 0) {
                sql = sql + " group by " + groupSQL;
            }

            if(all == 1){
                if(orderBy==0){
                    sql = sql + " order by cnt desc";
                }else{
                    sql = sql + " order by totPrice desc";
                }
                
            }else{
                if(orderBy==0){
                    sql = sql + " order by cnt desc limit 0," + maxLimit;
                }else{
                    sql = sql + " order by totPrice desc limit 0," + maxLimit;
                }
                
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                salesClosing = new SalesClosing();
                if (groupByItem == 1) {
                    salesClosing.setMember(rs.getString("name"));
                    salesClosing.setInvoiceNumber(rs.getString("code"));
                }
                if (groupByGroup == 1) {
                    salesClosing.setName1(rs.getString("namegroup"));
                }
                if (groupByVendor == 1) {
                    salesClosing.setName2(rs.getString("namevd"));
                }
                if (groupByLoc == 1) {
                    salesClosing.setName3(rs.getString("nameloc"));
                }

                salesClosing.setJmlQty(rs.getDouble("cnt"));
                salesClosing.setCash(rs.getDouble("price"));
                salesClosing.setTotPrice(rs.getDouble("totPrice"));
                
                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println("ERR >>> getDataTopSales : " + e.toString());
        }

        return list;
    }

    public static Vector getDataSummaryClosing(Date tanggal, String ipHost) {
        CONResultSet crs = null;
        Vector list = new Vector();
        SalesClosing salesClosing = new SalesClosing();
        try {
            // proses delete table
            String sql = "delete from summary_report_closing where iphost='" + ipHost + "'";
            CONHandler.execUpdate(sql);

            // proses insert data closing
            Vector vloc = getLocation();
            String cashierName = "";
            for (int k = 0; k < vloc.size(); k++) {
                Location loc = (Location) vloc.get(k);

                Vector vshift = getShift(loc.getOID(), tanggal);
                for (int j = 0; j < vshift.size(); j++) {
                    Shift shift = (Shift) vshift.get(j);
                    salesClosing = getDataSummaryClosing(tanggal, loc.getOID(), shift.getOID());
                    // proses pencarian nama user
                    cashierName = "";
                    try{
                        cashierName = getCashierName(shift.getOID());
                    }catch(Exception xx){
                        System.out.println("ERR >>> : "+xx.toString());
                    }
                    sql = "insert into summary_report_closing(iphost,loc_name,shift_name,d_cash,d_card,d_credit,d_discount,d_return,d_amount)"
                            + " values('" + ipHost + "','" + loc.getName() + "','" + shift.getName() + "'," + salesClosing.getCash() + "," + salesClosing.getCCard() + "," + salesClosing.getBon()
                            + "," + salesClosing.getDiscount() + "," + salesClosing.getRetur() + "," + salesClosing.getAmount() + ")";
                    CONHandler.execUpdate(sql);
                }
            }

            // proses select table closing
            sql = "select * from summary_report_closing where iphost='" + ipHost + "' order by loc_name, shift_name asc";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            //SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {

                salesClosing = new SalesClosing();
                salesClosing.setInvoiceNumber(rs.getString("loc_name"));
                salesClosing.setTglJam(new Date());
                salesClosing.setMember(rs.getString("shift_name"));
                salesClosing.setCash(rs.getDouble("d_cash"));
                salesClosing.setCCard(rs.getDouble("d_card"));
                salesClosing.setBon(rs.getDouble("d_credit"));
                salesClosing.setDiscount(rs.getDouble("d_discount"));
                salesClosing.setRetur(rs.getDouble("d_return"));
                salesClosing.setAmount(rs.getDouble("d_amount"));

                list.add(salesClosing);
            }

        } catch (Exception exc) {
        }
        return list;
    }

    
    public static Vector getDataSummaryClosing(Date tanggal, String ipHost,Vector locations) {
        CONResultSet crs = null;
        Vector list = new Vector();
        SalesClosing salesClosing = new SalesClosing();
        try {
            // proses delete table
            String sql = "delete from summary_report_closing where iphost='" + ipHost + "'";
            CONHandler.execUpdate(sql);

            // proses insert data closing
            for (int k = 0; k < locations.size(); k++) {
                Location loc = (Location) locations.get(k);

                Vector vshift = getShift(loc.getOID(), tanggal);
                for (int j = 0; j < vshift.size(); j++) {
                    Shift shift = (Shift) vshift.get(j);
                    salesClosing = getDataSummaryClosing(tanggal, loc.getOID(), shift.getOID());
                    // proses pencarian nama user                    
                    sql = "insert into summary_report_closing(iphost,loc_name,shift_name,d_cash,d_card,d_credit,d_discount,d_return,d_amount)"
                            + " values('" + ipHost + "','" + loc.getName() + "','" + shift.getName() + "'," + salesClosing.getCash() + "," + salesClosing.getCCard() + "," + salesClosing.getBon()
                            + "," + salesClosing.getDiscount() + "," + salesClosing.getRetur() + "," + salesClosing.getAmount() + ")";
                    CONHandler.execUpdate(sql);
                }
            }

            // proses select table closing
            sql = "select * from summary_report_closing where iphost='" + ipHost + "' order by loc_name, shift_name asc";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            //SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {

                salesClosing = new SalesClosing();
                salesClosing.setInvoiceNumber(rs.getString("loc_name"));
                salesClosing.setTglJam(new Date());
                salesClosing.setMember(rs.getString("shift_name"));
                salesClosing.setCash(rs.getDouble("d_cash"));
                salesClosing.setCCard(rs.getDouble("d_card"));
                salesClosing.setBon(rs.getDouble("d_credit"));
                salesClosing.setDiscount(rs.getDouble("d_discount"));
                salesClosing.setRetur(rs.getDouble("d_return"));
                salesClosing.setAmount(rs.getDouble("d_amount"));

                list.add(salesClosing);
            }

        } catch (Exception exc) {
        }
        return list;
    }
     /**
     * proses get nama kasir
     * @return
     */
    public static String getCashierName(long cashCashierId){
        CONResultSet crs = null;
        String cashierName = "";
        try{
            String sql = "select su.login_id from pos_cash_cashier as pc "+
                    " inner join sysuser as su on pc.user_id=su.user_id"+
                    " where pc.cash_cashier_id="+cashCashierId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                cashierName = rs.getString("login_id");
            }
        }catch(Exception e){}

        return cashierName;
    }
    
    public static SalesClosing getDataSummaryClosing(Date tanggal, long locationId, long cashCashierId) {
        CONResultSet crs = null;
        Vector list = new Vector();
        SalesClosing salesClosing = new SalesClosing();
        try {
            String sql = "select p.*, sum(pd.total) as tot , sum(pd.discount_amount) as discount_dt "
                    + ", p.discount_percent as disc_percent, p.service_percent as service_percent, p.vat_percent as ppn_percent "
                    + " from pos_sales as p "
                    + " inner join pos_sales_detail as pd on p.sales_id=pd.sales_id"
                    + " inner join pos_item_master as it on pd.product_master_id=it.item_master_id "
                    + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' "
                    + " and p.location_id=" + locationId;

            if (cashCashierId != 0) {
                sql = sql + " and p.cash_cashier_id=" + cashCashierId;
            }
            sql = sql + " group by p.sales_id order by p.number";
            
            System.out.println("----- in me !! -- summary closing - getDataSummaryClosing : "+sql);
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double totCash = 0;
            double totCard = 0;
            double totBon = 0;
            double totDiscount = 0;
            double totRetur = 0;
            double totAmount = 0;

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double discTotal = 0;
            double svcTotal = 0;
            double ppnTotal = 0;
            
            while (rs.next()) {
                cash = rs.getDouble("tot");
                
                double discPercent = rs.getDouble("disc_percent");
                double svcPercent = rs.getDouble("service_percent");
                double ppnPercent = rs.getDouble("ppn_percent");
                
                discTotal = cash * discPercent/100;
                cash = cash - discTotal;
                
                svcTotal = cash * svcPercent/100;
                cash = cash + svcTotal;
                
                ppnTotal = cash * ppnPercent/100;
                cash = cash + ppnTotal;
                
                card = getPaymentCash(rs.getLong("sales_id"), 1);
                card = card + getPaymentCash(rs.getLong("sales_id"), 2);
                if (card > 0) {
                    //card = cash;
                    cash = 0;
                } else {
                    card = 0;
                }
                discount = rs.getDouble("discount_dt");

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }

                totCash = totCash + cash;
                totCard = totCard + card;
                totBon = totBon + bon;
                totDiscount = totDiscount + discount;
                totRetur = totRetur + retur;
                totAmount = totAmount + amount;
            }

            // setting for object
            salesClosing.setInvoiceNumber("");
            salesClosing.setTglJam(new Date());
            salesClosing.setMember("");
            salesClosing.setCash(totCash);
            salesClosing.setCCard(totCard);
            salesClosing.setBon(totBon);
            salesClosing.setDiscount(totDiscount);
            salesClosing.setRetur(totRetur);
            salesClosing.setAmount(totAmount);

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return salesClosing;
    }

    public static int movingDataForReport(Date tanggal, long locationId, String ipHost) {
        int intHasil = 0;
        try { 
            String sql = "";

            try{
                sql = "START TRANSACTION";
                intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e5){}

            try{
                sql = "delete from pos_sales_detail_"+ipHost;
                intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e1){
                sql = "create table pos_sales_detail_"+ipHost+" like pos_sales_detail";
                intHasil = CONHandler.execSqlInsert(sql);
            }

            try{
            sql = "delete from pos_payment_"+ipHost;
            intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e2){
                sql = "create table pos_payment_"+ipHost+" like pos_payment";
                intHasil = CONHandler.execSqlInsert(sql);
            }

            try{
            sql = "delete from pos_return_payment_"+ipHost;
            intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e3){
                sql = "create table pos_return_payment_"+ipHost+" like pos_return_payment";
                intHasil = CONHandler.execSqlInsert(sql);
            }

            try{
            sql = "delete from pos_sales_"+ipHost;
            intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e4){
                sql = "create table pos_sales_"+ipHost+" like pos_sales";
                intHasil = CONHandler.execSqlInsert(sql);
            }
            try{
                sql = "COMMIT";
                intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e5){}
            try{
                sql = "START TRANSACTION";   
                intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e5){}

            // proses insert pos_sales
            sql = "insert into pos_sales_"+ipHost+" select * from pos_sales"
                    + " where date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' "
                    + " and location_id=" + locationId;
            intHasil = CONHandler.execSqlInsert(sql); 

            // proses pos_sales_detail
            sql = "insert into pos_sales_detail_"+ipHost+" select * from pos_sales_detail where sales_id in (select sales_id from pos_sales_"+ipHost+")";
            intHasil = CONHandler.execSqlInsert(sql);

            // proses pos_payment
            sql = "insert into pos_payment_"+ipHost+" select * from pos_payment where sales_id in (select sales_id from pos_sales_"+ipHost+")";
            intHasil = CONHandler.execSqlInsert(sql);

            // proses pos_return_payment
            sql = "insert into pos_return_payment_"+ipHost+" select * from pos_return_payment where sales_id in (select sales_id from pos_sales_"+ipHost+")";
            intHasil = CONHandler.execSqlInsert(sql);
            try{
                sql = "COMMIT";
                intHasil = CONHandler.execSqlInsert(sql);
            }catch(Exception e5){}

            return intHasil;

        }catch(Exception e){
        }

        return intHasil;
    }
    
    
    public static Vector getDataClosing(Date tanggal, long locationId,
            long cashCashierId, int isProductService, String ipHost) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            // proses moving data
            movingDataForReport(tanggal,locationId,ipHost);


            // start ambil data
            String sql = "select p.*, sum(pd.total) as tot , sum(pd.discount_amount) as discount_dt from pos_sales_"+ipHost+" as p "
                    + " inner join pos_sales_detail_"+ipHost+" as pd on p.sales_id=pd.sales_id"
                    + " inner join pos_item_master as it on pd.product_master_id=it.item_master_id "
                    + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' "
                    + " and p.location_id=" + locationId + " and it.is_service=" + isProductService;

            if (cashCashierId != 0) {
                sql = sql + " and p.cash_cashier_id=" + cashCashierId;
            }
            sql = sql + " group by p.sales_id order by p.number";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;

            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                cash = rs.getDouble("tot");
                card = getPaymentCash(rs.getLong("sales_id"), 1, ipHost);
                if (card > 0) {
                    card = cash; 
                    cash = 0;
                } else {
                    card = 0;  
                }
                discount = rs.getDouble("discount_dt");

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }

                salesClosing = new SalesClosing();
                salesClosing.setInvoiceNumber(rs.getString("number"));
                salesClosing.setTglJam(rs.getDate("date"));
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setCash(cash);
                salesClosing.setCCard(card);
                salesClosing.setBon(bon);
                salesClosing.setDiscount(discount);
                salesClosing.setRetur(retur);
                salesClosing.setAmount(amount);

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getDataClosing(Date tanggal, long locationId, long cashCashierId, int isProductService) {
        CONResultSet crs = null;
        Vector list = new Vector(); 
        try {
            String sql = "select p.*, sum(pd.total) as tot , sum(pd.discount_amount) as discount_dt "+
                    ", p.discount_percent as disc_percent, p.service_percent as service_percent, p.vat_percent as ppn_percent "+
                    " from pos_sales as p "
                    + " inner join pos_sales_detail as pd on p.sales_id=pd.sales_id"
                    + " inner join pos_item_master as it on pd.product_master_id=it.item_master_id "
                    + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' "
                    + " and p.location_id=" + locationId + " and it.is_service=" + isProductService;

            if (cashCashierId != 0) {
                sql = sql + " and p.cash_cashier_id=" + cashCashierId;
            }
            sql = sql + " group by p.sales_id order by p.number";
            
            System.out.println("!!!!!!! in mee ---- "+sql);
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double discTotal = 0;
            double svcTotal = 0;
            double ppnTotal = 0;

            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                cash = rs.getDouble("tot");
                double discPercent = rs.getDouble("disc_percent");
                double svcPercent = rs.getDouble("service_percent");
                double ppnPercent = rs.getDouble("ppn_percent");
                
                discTotal = cash * discPercent/100;
                cash = cash - discTotal;
                
                svcTotal = cash * svcPercent/100;
                cash = cash + svcTotal;
                
                ppnTotal = cash * ppnPercent/100;
                cash = cash + ppnTotal;
                
                //cash = cash - discTotal + svcTotal + ppnTotal;
                
                card = getPaymentCash(rs.getLong("sales_id"), 1);
                card = card + getPaymentCash(rs.getLong("sales_id"), 2);
                if (card > 0) {
                    //card = cash;
                    cash = 0;
                } else {
                    card = 0;
                }
                discount = rs.getDouble("discount_dt");

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        bon = cash;
                        cash = 0;
                        card = 0;
                        //bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        //cash = rs.getDouble("tot") * -1;
                        cash = cash * -1;
                        card = 0;
                        //retur = rs.getDouble("tot");
                        retur = cash;
                        amount = 0;
                        break;
                }

                salesClosing = new SalesClosing();
                salesClosing.setInvoiceNumber(rs.getString("number"));
                salesClosing.setTglJam(rs.getDate("date"));
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setCash(cash);
                salesClosing.setCCard(card);
                salesClosing.setBon(bon);
                salesClosing.setDiscount(discount);
                salesClosing.setRetur(retur);
                salesClosing.setAmount(amount);

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
     public static Vector getDataClosing(Date tanggal, long locationId,
            long cashCashierId, long cashierId, int isProductService) {

        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select p.*, sum(pd.total) as tot , sum(pd.discount_amount) as discount_dt from pos_sales as p "
                    + " inner join pos_sales_detail as pd on p.sales_id=pd.sales_id"
                    + " inner join pos_item_master as it on pd.product_master_id=it.item_master_id "
                    + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' "
                    + " and p.location_id=" + locationId + " and it.is_service=" + isProductService;

            if (cashCashierId != 0) {
                sql = sql + " and p.cash_cashier_id=" + cashCashierId;
            }

            if(cashierId!=0){
                sql = sql + " and p.user_id=" + cashierId; 
            }

            sql = sql + " group by p.sales_id order by p.number";

            crs = CONHandler.execQueryResult(sql); 
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;

            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                cash = rs.getDouble("tot");
                card = getPaymentCash(rs.getLong("sales_id"), 1);
                card = card + getPaymentCash(rs.getLong("sales_id"), 2);
                if (card > 0) {
                    card = cash;
                    cash = 0;
                } else {
                    card = 0;
                }
                discount = rs.getDouble("discount_dt");

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        bon = rs.getDouble("tot"); 
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }

                salesClosing = new SalesClosing(); 
                salesClosing.setInvoiceNumber(rs.getString("number"));
                
                Timestamp dtTr = rs.getTimestamp("date"); 
                salesClosing.setTglJam(dtTr);   
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setCash(cash);
                salesClosing.setCCard(card);
                salesClosing.setBon(bon);
                salesClosing.setDiscount(discount);
                salesClosing.setRetur(retur);
                salesClosing.setAmount(amount);

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getDataClosingCreditPayment(long locationId, Date tanggal, long cashCashierId) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select p.number, p.name , cp.pay_datetime, cp.amount from pos_credit_payment as cp "
                    + " inner join pos_sales as p on cp.sales_id=p.sales_id"
                    + " inner join pos_cash_cashier as cc on cp.cash_cashier_id=cc.cash_cashier_id"
                    + " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id"
                    + " where p.type=1 and cp.pay_datetime between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01")
                    + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "'"
                    + " and p.location_id=" + locationId;

            if (cashCashierId != 0) {
                sql = sql + " and cp.cash_cashier_id=" + cashCashierId;
            }
            sql = sql + " order by cp.pay_datetime asc";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;

            SalesClosing salesClosing = new SalesClosing();
            while (rs.next()) {
                cash = 0;
                card = 0;
                switch(rs.getInt("type")){
                    case 0: // cash
                        cash = rs.getDouble("amount");
                        break;
                    case 1: // credit card
                        card = rs.getDouble("amount");
                        break;

                    case 2: // debit card
                        card = rs.getDouble("amount");
                        break;

                    default:
                        cash = rs.getDouble("amount");
                        break;
                }
                if (card > 0) {
                    //card = cash;
                    cash = 0;
                } else {
                    card = 0;
                }
                discount = 0;

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;

                salesClosing = new SalesClosing();
                salesClosing.setInvoiceNumber(rs.getString("number"));
                salesClosing.setTglJam(rs.getDate("pay_datetime"));
                salesClosing.setMember(rs.getString("name"));
                salesClosing.setCash(cash);
                salesClosing.setCCard(card);
                salesClosing.setBon(bon);
                salesClosing.setDiscount(discount);
                salesClosing.setRetur(retur);
                salesClosing.setAmount(amount);

                list.add(salesClosing);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    /**
     * for get payment sales to table pos_payment
     * by oid_sales and type payment: cash or credit card or other
     **/
    public static double getPaymentCash(long salesOid, int typeP, String ipHost) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(amount) as pay from pos_payment_"+ipHost+" where pay_type=" + typeP + " and sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("pay");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return total;
    }

    /**
     * for get payment sales to table pos_payment
     * by oid_sales and type payment: cash or credit card or other
     **/
    public static double getPaymentCash(long salesOid, int typeP) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(amount) as pay from pos_payment where pay_type=" + typeP + " and sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("pay");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return total;
    }

     /**
     * for get retur payment sales to table pos_return_payment
     * by oid_sales
     **/
    public static double getReturnPaymentCash(long salesOid, String ipHost) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(amount) as pay from pos_return_payment_"+ipHost+" where sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql); 
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("pay");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return total;
    }
    
    /**
     * for get retur payment sales to table pos_return_payment
     * by oid_sales
     **/
    public static double getReturnPaymentCash(long salesOid) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(amount) as pay from pos_return_payment where sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("pay");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return total;
    }

    public static Vector getLocation() {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT pl.* FROM pos_cash_master as cm "
                    + "inner join pos_location as pl on cm.location_id=pl.location_id group by location_id";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Location location = new Location();
                location.setOID(rs.getLong("location_id"));
                location.setName(rs.getString("name"));

                list.add(location);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getGroup() {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT item_group_id, name FROM pos_item_group order by name";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                ItemGroup itemGroup = new ItemGroup();
                itemGroup.setOID(rs.getLong("item_group_id"));
                itemGroup.setName(rs.getString("name"));

                list.add(itemGroup);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getVendor() {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT vendor_id, name FROM vendor order by name";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Vendor vendor = new Vendor();
                vendor.setOID(rs.getLong("vendor_id"));
                vendor.setName(rs.getString("name"));

                list.add(vendor);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getShift(long locationOid, Date tanggal) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT s.*,cc.* FROM `pos_cash_cashier` as cc "
                    + " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id "
                    + " inner join pos_shift as s on cc.shift_id=s.shift_id "
                    + " where location_id=" + locationOid + " and "
                    + " date_open between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' group by cc.cash_cashier_id";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setOID(rs.getLong("cash_cashier_id"));
                shift.setName(rs.getString("name"));

                list.add(shift);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getCashier(long locationOid, Date tanggal) {
        CONResultSet crs = null;
        Vector list = new Vector(); 
        try {
            String sql = "SELECT su.* FROM `pos_cash_cashier` as cc "
                    + " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id "
                    + " inner join sysuser as su on cc.user_id=su.user_id "
                    + " where location_id=" + locationOid + " and "
                    + " date_open between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' "
                    + " and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' group by cc.cash_cashier_id";

            crs = CONHandler.execQueryResult(sql);  
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setOID(rs.getLong("user_id"));
                shift.setName(rs.getString("login_id"));

                list.add(shift);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    /**
     * untuk mencari object penjualan dan detailnya
     *
     **/
    public static Vector getSalesAndDetail(long salesOid) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select * from pos_sales_cancel where sales_id=" + salesOid;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Sales sales = new Sales();
            while (rs.next()) {
                // get object sales
                sales = new Sales();
                sales.setOID(rs.getLong("sales_id"));
                sales.setNumber(rs.getString("number"));
                sales.setDate(rs.getDate("date"));
                sales.setName(rs.getString("name"));
                sales.setUserId(rs.getLong("user_id"));
                sales.setAmount(rs.getDouble("amount"));
                sales.setCurrencyId(rs.getLong("location_id"));
                sales.setCategoryId(rs.getLong("shift_id"));
            }
            rs.close();

            // simpan object sales
            list.add(sales);

            sql = "select * from pos_sales_detail_cancel where sales_id=" + salesOid;
            crs = CONHandler.execQueryResult(sql);
            rs = crs.getResultSet();

            Vector item = new Vector();
            Vector listItem = new Vector();
            ItemMaster itemMaster = new ItemMaster();
            while (rs.next()) {
                item = new Vector();
                itemMaster = new ItemMaster();
                try {
                    itemMaster = DbItemMaster.fetchExc(rs.getLong("product_master_id"));
                } catch (Exception e) {
                }

                item.add(String.valueOf(itemMaster.getCode() + "/" + itemMaster.getBarcode()));
                item.add(String.valueOf(itemMaster.getName()));
                item.add(String.valueOf(rs.getDouble("selling_price")));
                item.add(String.valueOf(rs.getDouble("discount_amount")));
                item.add(String.valueOf(rs.getDouble("qty")));
                item.add(String.valueOf(rs.getDouble("total")));

                listItem.add(item);
            }

            // simpan data faktur detail 
            list.add(listItem);
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    /**
     ** untuk melihat jumlah opening dan closing berdasarkan cash_cashierId
     */
    public static Vector getTotalOpenClosing(long cashCashierId) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select * from pos_cash_cashier where cash_cashier_id=" + cashCashierId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                list.add(rs.getDouble("amount_open"));
                list.add(rs.getDouble("amount_closing"));
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    /**
     * update customer
     **/
    public static void updateMemberPending(int discount, long customerOid) {
        try {
            String sql = "UPDATE customer SET status = 'APPROVED', personal_discount = " + discount + " WHERE customer_id =" + customerOid;
            CONHandler.execUpdate(sql);

            sql = sql.replace("'", "\\'");
            String sqlLogs = "insert into logs(log_id,date,query_string,table_name) values(" + OIDGenerator.generateOID() + ",'" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd 23:59:59") + "','" + sql + "','customer')";            
            CONHandler.execUpdate(sqlLogs);

        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void checkAndUpdateSalesPosted() {
        CONResultSet crs = null;
        CONResultSet crsx = null;
        try {
            String sql = "select * from pos_sales where status=0";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                sql = "select journal_number from gl where journal_number='" + rs.getString("number") + "'";
                crsx = CONHandler.execQueryResult(sql);
                ResultSet rsx = crsx.getResultSet();
                while (rsx.next()) {                    
                    sql = "update pos_sales set posted_status=1 , status=1 , posted_by_id=504404497137933095, posted_date='" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' where sales_id=" + rs.getLong("sales_id");
                    CONHandler.execUpdate(sql);
                }
            }
        } catch (Exception e) {
            System.out.println("SQL >> : " + e.toString());
        }
    }

    public static void checkAndDeleteItemSalesNotPosted() {
        CONResultSet crs = null;
        CONResultSet crsx = null;
        try {
            String sql = "select * from pos_sales where status=0 and date > '2012-05-01 00:00:01'";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            long oidPrev = 0;
            while (rs.next()) {
                sql = "select sales_detail_id, product_master_id from pos_sales_detail where sales_id='" + rs.getString("sales_id") + "' order by product_master_id";
                crsx = CONHandler.execQueryResult(sql);
                ResultSet rsx = crsx.getResultSet();                
                while (rsx.next()) {
                    if (oidPrev != rsx.getLong("product_master_id")) {                        
                        oidPrev = rsx.getLong("product_master_id");
                    } else {
                        // delete item
                        try {                            
                            sql = "delete from pos_sales_detail where sales_detail_id=" + rsx.getLong("sales_detail_id");
                            CONHandler.execUpdate(sql);
                        } catch (Exception e) {
                        }
                    }
                }
                rsx.close();

            }
            rs.close();

        } catch (Exception e) {
            System.out.println("SQL >> : " + e.toString());
        }
    }

    public static void updateReturSalesId() {
        CONResultSet crs = null;
        CONResultSet crsx = null;
        try {
            String sql = "select number as inv_number, sales_id from pos_sales where (type=2 or type=3) and sales_retur_id=0";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                String invNumber = rs.getString("inv_number");

                if (invNumber.substring(invNumber.length() - 1, invNumber.length()).equals("R")) {
                    invNumber = invNumber.substring(0, invNumber.length() - 1);
                }

                sql = "select sales_id from pos_sales where number='" + invNumber + "'";
                crsx = CONHandler.execQueryResult(sql);
                ResultSet rsx = crsx.getResultSet();
                while (rsx.next()) {
                    sql = "update pos_sales set sales_retur_id=" + rsx.getLong("sales_id") + " where sales_id=" + rs.getLong("sales_id");
                    CONHandler.execUpdate(sql);
                }
                rsx.close();
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("SQL >> : " + e.toString());
        }
    }

    public static void deleteStockSalesInDouble(int start, int recordToGet) {
        CONResultSet crs = null;
        CONResultSet crsx = null;
        try {
            String sql = "select tb.total, tb.opname_id, tb.sales_detail_id, tb.type from "
                    + " (select count(sales_detail_id) as total , opname_id, sales_detail_id, type "
                    + " from pos_stock  group by sales_detail_id, opname_id, item_master_id ) as tb "
                    + " where total > 1 and type =7 limit " + start + " , " + recordToGet;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            int loop = 0;
            while (rs.next()) {
                sql = "select * from pos_stock where opname_id=" + rs.getLong("opname_id")
                        + " and sales_detail_id=" + rs.getLong("sales_detail_id") + " and type=7";

                crsx = CONHandler.execQueryResult(sql);
                ResultSet rsx = crsx.getResultSet();

                loop = 0;
                while (rsx.next()) {
                    if (loop > 0) {
                        sql = "delete from pos_stock where stock_id=" + rsx.getLong("stock_id");
                        CONHandler.execUpdate(sql);
                    }
                    loop++;
                }
                rsx.close(); 
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("SQL >> : " + e.toString());
        }
    }

    public static Vector getSummaryByItem(long locationOid, String startDate, String endDate, long groupId, String code, String name) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT ig.name as category, im.code, im.barcode, im.name, sum(sd.qty) as total, v.name as sup, sd.selling_price as harga  FROM pos_sales s  "
                    + " inner join pos_sales_detail sd on s.sales_id=sd.sales_id "
                    + " inner join pos_item_master im on sd.product_master_id=im.item_master_id "
                    + " inner join pos_item_group ig on im.item_group_id=ig.item_group_id "
                    + " inner join vendor v on im.default_vendor_id=v.vendor_id "
                    + " where to_days(s.date) between to_days('"+ startDate +"') and to_days('" + endDate + "') ";


            if(locationOid!=0){
                sql = sql + " and s.location_id=" + locationOid ;
            }
            if(groupId!=0){
                sql = sql + " and im.item_group_id=" + groupId ;
            }
            if(code.length()>0 && code!=null){
                sql = sql + " and (im.code like '%" + code + "%' or im.barcode like '%" + code + "%' or im.barcode_2 like '%" + code + "%' or im.barcode_3 like '%" + code + "%')" ;
            }
            if(name.length()>0 && name!=null){
                sql = sql + " and im.name like '%" + name + "%'";
            }
            sql=sql + " group by sd.product_master_id order by total desc";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                Vector vdt = new Vector();
                vdt.add(rs.getString("category"));
                vdt.add(rs.getString("code"));
                vdt.add(rs.getString("barcode"));
                vdt.add(rs.getString("name"));
                vdt.add(rs.getDouble("total"));
                vdt.add(rs.getString("sup"));
                vdt.add(rs.getString("harga"));
                list.add(vdt);
            }
        } catch (Exception e){
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
}
