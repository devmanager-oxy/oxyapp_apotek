<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.main.db.SendHistory" %>
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


public long getStockItemId(String sql){
    
    long oid = 0 ;
    
    if(sql!=null && sql.length()>0){
    
        //apakah ini insert stock item
        int idx = sql.indexOf("pos_stock");
        if(idx>-1){
            //it is sales item
            Vector temp = new Vector();
            StringTokenizer strTok = new StringTokenizer(sql, "(");
            while(strTok.hasMoreElements()){
                temp.add((String)strTok.nextToken());
            }

            System.out.println(temp);        
            if(temp.size()==3){
                sql = (String)temp.get(2);
                temp = new Vector();
                strTok = new StringTokenizer(sql, ",");
                while(strTok.hasMoreElements()){
                    temp.add((String)strTok.nextToken());
                }

                System.out.println("--- "+temp);        
                try{
                    oid = Long.parseLong((String)temp.get(0));
                }
                catch(Exception e){
                    oid = 0;
                }

                System.out.println("--- oid : "+oid);        
            }

        }
    }
    
    return oid;
    
}

public void updateStockDate(long stockId){
    if(stockId!=0){            
        try{
            Stock s = DbStock.fetchExc(stockId);
            s.setDate(new Date());
            DbStock.updateExc(s);
        }
        catch(Exception e){
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
                System.out.println("--> in 2 - status ");	
		  
		  sql = sql.replace("logs", "logs2");
		  
		  //System.out.println("--> pos update status after : "+sql);	
		  CustomerHistory cHis = SendHistory.splitStringHistory(sql);
                val = SQLGeneral.executeSQL(sql);
		  if (val == 1) {
                    if(cHis.getNote() !=null && cHis.getNote().length() > 0){
                        SendHistory.insertHistory(cHis);
                    }
                }	
                
		  /*
		  //di download master ini ga boleh ada	
		  if (val == 1) {

                    //jika yg diatas sukses lakukan pengecekan komisi
                    //dan proses jika sales ite didapat
                    long oidSDetail = getSalesItemId(sql);
                    if (oidSDetail != 0) {
                        processKomisi(oidSDetail);
                    }
                    //proses autoref
                    if (Integer.parseInt(isStock) == 1) {
			   //lakukan update tanggal stok apabila sql stok
			   long oidStock = getStockItemId(sql);	
			   updateStockDate(oidStock);	
                        DbStock.checkRequestTransfer(Long.parseLong(itemOID), Long.parseLong(locOID));
                    }
                }
		  */
            } catch (Exception e) {}
%>
<%=val%>