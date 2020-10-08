<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.main.db.SendHistory" %>
<%@ page import = "com.project.main.db.CONHandler" %>
<%@ page import = "com.project.main.db.CONResultSet" %>
<%@ page import = "com.project.general.*" %>
<%!
    public long getSalesItemId(String sql) {
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

                System.out.println(temp);
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

     public static ItemMaster getItemMaster(long itemId) {
        CONResultSet dbrs = null;
        ItemMaster im = new ItemMaster();
        try {
            String sql = "select item_master_id,cogs,type_item,default_vendor_id from pos_item_master where item_master_id = " + itemId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                im.setOID(rs.getLong("item_master_id"));
                im.setCogs(rs.getDouble("cogs"));
                im.setTypeItem(rs.getInt("type_item"));
                im.setDefaultVendorId(rs.getLong("default_vendor_id"));
            }
            rs.close();

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return im;
    }

    public static Vendor getVendor(long vendorId) {
        CONResultSet dbrs = null;
        Vendor v = new Vendor();
        try {
            String sql = "select vendor_id,is_komisi,komisi_margin from vendor where vendor_id = " + vendorId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                v.setOID(rs.getLong("vendor_id"));
                v.setIsKomisi(rs.getInt("is_komisi"));
                v.setKomisiMargin(rs.getDouble("komisi_margin"));
            }
            rs.close();

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return v;
    }

    public static void updateSalesCogs(long salesDetailId, double cogs) {
        CONResultSet dbrs = null;
        try {
            String sql = "update pos_sales_detail set cogs ='" + cogs + "' where sales_detail_id='" + salesDetailId + "'";
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
    }


    public void processKomisi(long oidSalesItem) {
        try {
            SalesDetail si = DbSalesDetail.fetchExc(oidSalesItem);
            ItemMaster im = DbItemMaster.fetchExc(si.getProductMasterId());
            boolean isKomisi = false; 
            //jika barang komisi
            if (im.getTypeItem() == 2) {
                if (im.getDefaultVendorId() != 0) {
                    Vendor vnd = DbVendor.fetchExc(im.getDefaultVendorId());
                    //vendor adalah komisi
                    if (vnd.getIsKomisi() == 1) {
                        double cogs = (((100 - vnd.getKomisiMargin()) / 100) * ((si.getQty() * si.getSellingPrice()) - si.getDiscountAmount())) / si.getQty();
                        updateSalesCogs(si.getOID(),cogs);
                        isKomisi = true;
                    }
                }
            }

            if(isKomisi == false){
                if(im.getOID() != 0){
                    if(si.getOID() != 0){
                        updateSalesCogs(si.getOID(),im.getCogs());
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
                CustomerHistory cHis = SendHistory.splitStringHistory(sql);
                val = SQLGeneral.executeSQL(sql);
                if (val == 1) {
                    if (cHis.getNote() != null && cHis.getNote().length() > 0) {
                        SendHistory.insertHistory(cHis);
                    }
                    //jika yg diatas sukses lakukan pengecekan komisi
                    //dan proses jika sales ite didapat
                    long oidSDetail = getSalesItemId(sql);
                    if (oidSDetail != 0) {
                        processKomisi(oidSDetail);
                    }
                }
            } catch (Exception e) {
            }
            System.out.println("val " + val);
%>
<%=val%>