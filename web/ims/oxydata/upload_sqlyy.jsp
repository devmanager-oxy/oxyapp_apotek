
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.uploader.*" %>
<%@ page import = "com.project.main.db.SendHistory" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.main.db.*" %>
<%!
    public long getOid(String sql) {
        long oid = 0;
        if (sql != null && sql.length() > 0) {

            Vector temp = new Vector();
            StringTokenizer strTok = new StringTokenizer(sql, "(");
            while (strTok.hasMoreElements()) {
                temp.add((String) strTok.nextToken());
            }

            if (temp.size() == 3) {
                sql = (String) temp.get(2);
                temp = new Vector();
                strTok = new StringTokenizer(sql, ",");
                while (strTok.hasMoreElements()) {
                    temp.add((String) strTok.nextToken());
                }

                try {
                    String strOid = (String) temp.get(0);                    
                    oid = Long.parseLong(strOid.trim());
                } catch (Exception e) {
                    oid = 0;
                }
            }

        }

        return oid;

    }

    public long getSalesId(String sql) {
        long oid = 0;
        if (sql != null && sql.length() > 0) {

            //apakah ini insert sales item
            int idx = sql.indexOf("pos_sales");
            if (idx > -1) {
                //it is sales item
                Vector temp = new Vector();
                StringTokenizer strTok = new StringTokenizer(sql, "(");
                while (strTok.hasMoreElements()) {
                    temp.add((String) strTok.nextToken());
                }

                if (temp.size() == 3) {
                    sql = (String) temp.get(2);
                    temp = new Vector();
                    strTok = new StringTokenizer(sql, ",");
                    while (strTok.hasMoreElements()) {
                        temp.add((String) strTok.nextToken());
                    }

                    try {
                        oid = Long.parseLong((String) temp.get(0));
                    } catch (Exception e) {
                        oid = 0;
                    }
                }
            }
        }

        return oid;

    }

    public long getSalesDetailId(String sql) {
        long oid = 0;
        if (sql != null && sql.length() > 0) {

            //apakah ini insert sales item
            int idx = sql.indexOf("pos_sales_detail");
            if (idx > -1) {
                //it is sales item
                Vector temp = new Vector();
                StringTokenizer strTok = new StringTokenizer(sql, "(");
                while (strTok.hasMoreElements()) {
                    temp.add((String) strTok.nextToken());
                }

                if (temp.size() == 3) {
                    sql = (String) temp.get(2);
                    temp = new Vector();
                    strTok = new StringTokenizer(sql, ",");
                    while (strTok.hasMoreElements()) {
                        temp.add((String) strTok.nextToken());
                    }

                    try {
                        oid = Long.parseLong((String) temp.get(0));
                    } catch (Exception e) {
                        oid = 0;
                    }
                }
            }
        }

        return oid;

    }

    public long getStockItemId(String sql) {
        long oid = 0;
        if (sql != null && sql.length() > 0) {

            //apakah ini insert stock item
            int idx = sql.indexOf("pos_stock");
            if (idx > -1) {
                //it is sales item
                Vector temp = new Vector();
                StringTokenizer strTok = new StringTokenizer(sql, "(");
                while (strTok.hasMoreElements()) {
                    temp.add((String) strTok.nextToken());
                }

                if (temp.size() == 3) {
                    sql = (String) temp.get(2);
                    temp = new Vector();
                    strTok = new StringTokenizer(sql, ",");
                    while (strTok.hasMoreElements()) {
                        temp.add((String) strTok.nextToken());
                    }

                    System.out.println("--- " + temp);
                    try {
                        oid = Long.parseLong((String) temp.get(0));
                    } catch (Exception e) {
                        oid = 0;
                    }

                    System.out.println("--- oid : " + oid);
                }

            }
        }

        return oid;

    }

    public void updateStockDate(long stockId) {
        if (stockId != 0) {
            try {
                Stock s = DbStock.fetchExc(stockId);
                s.setDate(new Date());
                DbStock.updateExc(s);
            } catch (Exception e) {
            }
        }
    }

    public void processKomisi(long oidSalesItem) {
        try {
            SalesDetail si = DbSalesDetail.fetchExc(oidSalesItem);
            ItemMaster im = DbItemMaster.fetchExc(si.getProductMasterId());
            //jika barang komisi
            if (im.getTypeItem() == 2) {
                if (im.getDefaultVendorId() != 0) {
                    Vendor vnd = DbVendor.fetchExc(im.getDefaultVendorId());
                    //vendor adalah komisi
                    if (vnd.getIsKomisi() == 1) {
                        double cogs = (((100 - vnd.getKomisiMargin()) / 100) * ((si.getQty() * si.getSellingPrice()) - si.getDiscountAmount())) / si.getQty();
                        si.setCogs(cogs);
                        DbSalesDetail.updateExc(si);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

%>

<%
            String sql = request.getParameter("sqlval");
            String itemOID = request.getParameter("itemid");
            String locOID = request.getParameter("locid");
            String isStock = request.getParameter("isstock");

            int val = 0;
            try {
                String sqlIns = "";
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_MYSQL:
                        sqlIns = sql.replace("'", "\\'");
                        break;

                    case CONHandler.CONSVR_POSTGRESQL:
                        sqlIns = sql.replace("'", "\"");
                        break;

                    case CONHandler.CONSVR_SYBASE:
                        sqlIns = sql.replace("'", "\\'");
                        break;

                    case CONHandler.CONSVR_ORACLE:
                        sqlIns = sql.replace("'", "\\'");
                        break;

                    case CONHandler.CONSVR_MSSQL:
                        sqlIns = sql.replace("'", "\\'");
                        break;

                    default:
                        sqlIns = sql.replace("'", "\\'");
                        break;
                }


                String strSql = "";
                long oid = 0;
                if (sql.indexOf("pos_member_point") > -1) { //jika termasuk pos_member_point
                     oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_member_point (member_point_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                }else if (sql.indexOf("pos_sales_detail") > -1) { //jika termasuk pos_sales_detail
                    oid = getSalesDetailId(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_sales_detail (sales_detail_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                } else if (sql.indexOf("pos_sales") > -1) { //jika termasuk pos_sales
                    oid = getSalesId(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_sales (sales_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                } else if (sql.indexOf("pos_payment") > -1) { //jika termasuk pos_payment
                    oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_payment (payment_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                }else if (sql.indexOf("pos_return_payment") > -1) { //jika termasuk pos_return_payment
                    oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_return_payment (return_payment_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                }else if (sql.indexOf("pos_credit_payment") > -1) { //jika termasuk pos_credit_payment
                    oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_credit_payment (credit_payment_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    } 
                }else if (sql.indexOf("pos_cash_cashier") > -1) { //jika termasuk pos_cash_cashier
                    oid = getOid(sql);
                    long logId = OIDGenerator.generateOID();
                    strSql = "insert into pos_cash_cashier_upload (cash_cashier_upload_id,cash_cashier_id,date,QUERY_STRING,STS_UPLOAD) values ('"+logId+"','" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";                                                            
                }else if (sql.indexOf("pos_stock_code") > -1) { //jika termasuk pos_stock_code
                    oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_stock_code (stock_code_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                }else if (sql.indexOf("pos_stock") > -1) { //jika termasuk pos_stock
                    oid = getOid(sql);
                    if (oid != 0) {
                        strSql = "insert into pos_stock (stock_id,date,QUERY_STRING,STS_UPLOAD) values ('" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";
                    }
                }else if (sql.indexOf("customer") > -1) { //jika termasuk customer
                    oid = getOid(sql);
                    long logId = OIDGenerator.generateOID();
                    strSql = "insert into pos_customer_upload (customer_upload_id,customer_id,date,QUERY_STRING,STS_UPLOAD) values ('"+logId+"','" + oid + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','" + sqlIns + "',0)";                                                            
                }                
                if (strSql != null && strSql.length() > 0) {
                    val = SQLGeneral.executeSQL(strSql);
                }
            } catch (Exception e) {
            }
%>
<%=val%>