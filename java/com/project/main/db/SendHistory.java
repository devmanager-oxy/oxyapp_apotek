/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.main.db;

import com.project.ccs.postransaction.memberpoint.DbMemberPoint;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.Sales;
import com.project.general.Customer;
import com.project.general.CustomerHistory;
import com.project.general.DbCustomer;
import com.project.general.DbCustomerHistory;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class SendHistory {

    public static CustomerHistory splitStringHistory(String sql) {

        CustomerHistory cHis = new CustomerHistory();
        sql = sql.toLowerCase();

        int idInsert = sql.lastIndexOf("insert into customer(");
        int idUpdate = sql.lastIndexOf("update customer set");
        int idDelete = sql.lastIndexOf("delete from customer where");
        
        int idInsertPoint = sql.lastIndexOf("insert into pos_member_point (");
        
        String memo = "";

        try {

            if (idInsert == 0) { // jika kondisi insert
                String tmpSql = sql.trim();
                tmpSql = tmpSql.replace("insert into customer", "");
                tmpSql = tmpSql.trim();

                String temp[] = tmpSql.split("values");

                if (temp.length == 2) {

                    String col = temp[0].trim();
                    col = col.replace("(", "");
                    col = col.replace(")", "");
                    col = col.replace("'", "");

                    String val = temp[1].trim();
                    val = val.replace("(", "");
                    val = val.replace(")", "");
                    val = val.replace(";", "");
                    val = val.replace("'", "");

                    long customerId = 0;
                    String name = "";
                    String address = "";
                    String code = "";
                    String phone = "";
                    String email = "";
                    long regId = 0;
                    int type = 0;

                    String arrayCol[] = col.split(",");
                    String arrayVal[] = val.split(",");

                    int historyType = 0;
                    if (DbCustomer.colNames.length == arrayCol.length) {
                        historyType = DbCustomerHistory.TYPE_HISTORY_BACKOFFICE;
                    } else {
                        historyType = DbCustomerHistory.TYPE_HISTORY_POS;
                    }

                    for (int i = 0; i < arrayCol.length; i++) {
                        if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID])) {
                            customerId = Long.parseLong((String) arrayVal[i]);
                        } else if (String.valueOf(arrayCol[i]).trim().equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_CODE])) {
                            code = String.valueOf((String) arrayVal[i]);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "barcode :" + code.trim();
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_NAME])) {
                            name = String.valueOf((String) arrayVal[i]);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "nama :" + name.trim();
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_ADDRESS_1])) {
                            address = String.valueOf((String) arrayVal[i]);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "alamat :" + address.trim();
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_PHONE])) {
                            phone = String.valueOf((String) arrayVal[i]);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "phone :" + phone.trim();
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_EMAIL])) {
                            email = String.valueOf((String) arrayVal[i]);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "email :" + email.trim();
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID])) {
                            try {
                                regId = Long.parseLong(String.valueOf(arrayVal[i]));
                                Location loc = new Location();
                                try {
                                    if (regId != 0) {
                                        loc = DbLocation.fetchExc(regId);
                                    }
                                } catch (Exception e) {
                                }
                                if (memo.length() > 0) {
                                    memo = memo + ", ";
                                }
                                memo = memo + "lokasi registrasi :" + loc.getName().trim();
                            } catch (Exception e) {
                            }
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_TYPE])) {
                            try {
                                type = Integer.parseInt(String.valueOf(arrayVal[i]));
                            } catch (Exception e) {
                            }
                        }
                    }

                    if (type == DbCustomer.CUSTOMER_TYPE_REGULAR || type == DbCustomer.CUSTOMER_TYPE_COMMON_AREA) {
                        cHis.setCustomerId(customerId);
                        cHis.setNote("Pendaftaran member baru :" + memo.trim());
                        cHis.setBarcode(code.trim());
                        cHis.setDate(new Date());
                        cHis.setName(name.trim());
                        cHis.setTypeHistory(historyType);
                        cHis.setType(DbCustomerHistory.TYPE_INSERT);
                    }
                }

            } else if (idUpdate == 0) {
                String tmpSql = sql.trim();
                tmpSql = tmpSql.replace("update customer set", "");
                tmpSql = tmpSql.trim();

                String tempWhere[] = tmpSql.split("where");

                String temp[] = tempWhere[0].split(",");
                String tempOid[] = tempWhere[1].split("=");

                int historyType = 0;
                if (DbCustomer.colNames.length == temp.length) {
                    historyType = DbCustomerHistory.TYPE_HISTORY_BACKOFFICE;
                } else {
                    historyType = DbCustomerHistory.TYPE_HISTORY_POS;
                }

                long customerId = 0;
                String name = "";
                String address = "";
                String code = "";
                String phone = "";
                String email = "";
                long regId = 0;
                int type = 0;
                String id = "";

                try {
                    String strOid = tempOid[1].trim().replace(";", "");
                    strOid = strOid.replace(")", "");
                    strOid = strOid.replace("'", "");
                    
                    String strCol = tempOid[0].trim().replace(";", "");
                    strCol = strCol.replace(")", "");
                    strCol = strCol.replace("'", "");
                    
                    if (strCol.trim().equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID])) {
                        try{
                            customerId = Long.parseLong(String.valueOf(""+strOid.trim()));
                        }catch(Exception e){}
                    }else if(strCol.trim().equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_CODE])){
                        String where = DbCustomer.colNames[DbCustomer.COL_CODE]+" = '"+strOid.trim()+"'";
                        Vector listCst = DbCustomer.list(0, 1, where, null);
                        if(listCst != null && listCst.size() > 0){
                            Customer c = (Customer)listCst.get(0);
                            customerId = c.getOID();
                        }
                    }else{
                        customerId = Long.parseLong((String) strOid.trim());
                    }
                } catch (Exception e) {
                    System.out.println("exception "+e.toString());
                }

                String strmemo = "";
                
                Customer c = new Customer();
                try {
                    c = DbCustomer.fetchExc(customerId);
                } catch (Exception e) {
                }
                code = c.getCode();
                name = c.getName();

                for (int i = 0; i < temp.length; i++) {

                    String str = temp[i].trim();
                    String str2[] = str.split("=");
                    if (str2.length == 2) {
                        String col = str2[0].trim();
                        String val = str2[1].replace("'", "").trim();
                        if (col.trim().equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_CODE])) {
                            code = String.valueOf(val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "barcode :" + code.trim();
                            if(c.getOID() != 0 && c.getCode().trim().compareTo(code.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " barcode :" + c.getCode() + "->" + code.trim();
                            }
                        }else if (col.trim().equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_ID_NUMBER])) {
                            id = String.valueOf(val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "id number :" + id.trim();
                            if(c.getOID() != 0 && c.getIdNumber().trim().compareTo(id.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " id number :" + c.getCode() + "->" + id.trim();
                            }
                           
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_NAME])) {
                            name = String.valueOf((String) val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "nama :" + name.trim();
                            if(c.getOID() != 0 && c.getName().trim().compareTo(name.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " nama :" + c.getName() + "->" + name.trim();
                            }
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_ADDRESS_1])) {
                            address = String.valueOf((String) val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "alamat :" + address.trim();
                            if(c.getOID() != 0 && c.getAddress1().trim().compareTo(address.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " alamat :" + c.getAddress1().trim() + "->" + address.trim();
                            }
                            
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_PHONE])) {
                            phone = String.valueOf((String) val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "phone :" + phone.trim();
                            if(c.getOID() != 0 && c.getPhone().trim().compareTo(phone.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " phone :" + c.getPhone().trim() + "->" + phone.trim();
                            }
                            
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_EMAIL])) {
                            email = String.valueOf((String) val);
                            if (memo.length() > 0) {
                                memo = memo + ", ";
                            }
                            memo = memo + "email :" + email.trim();
                            if(c.getOID() != 0 && c.getEmail().trim().compareTo(email.trim()) != 0){
                                if (strmemo.length() > 0) {
                                    strmemo = strmemo + ", ";
                                }
                                strmemo = strmemo + " email :" + c.getEmail().trim() + "->" + email.trim();
                            }
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID])) {
                            try {
                                regId = Long.parseLong(String.valueOf(val));
                                Location loc = new Location();
                                try {
                                    if (regId != 0) {
                                        loc = DbLocation.fetchExc(regId);
                                    }
                                } catch (Exception e) {
                                }
                                if (memo.length() > 0) {
                                    memo = memo + ", ";
                                }
                                memo = memo + "lokasi registrasi :" + loc.getName().trim();
                            } catch (Exception e) {
                            }
                        } else if (String.valueOf(col.trim()).equalsIgnoreCase(DbCustomer.colNames[DbCustomer.COL_TYPE])) {
                            try {
                                type = Integer.parseInt(String.valueOf(val));
                            } catch (Exception e) {
                            }
                        }

                    }
                }

                if (type == DbCustomer.CUSTOMER_TYPE_REGULAR || type == DbCustomer.CUSTOMER_TYPE_COMMON_AREA) {

                    if (strmemo != null && strmemo.length() > 0) {
                        strmemo = "Perubahan data member -> " + strmemo;
                    } else {
                        strmemo = "Perubahan data member -> " + memo;
                    }
                    
                    if(strmemo != null && strmemo.length() > 0){
                        cHis.setCustomerId(customerId);
                        cHis.setNote(strmemo);
                        cHis.setBarcode(code.trim());
                        cHis.setDate(new Date());
                        cHis.setName(name.trim());
                        cHis.setTypeHistory(historyType);
                        cHis.setType(DbCustomerHistory.TYPE_UPDATE);
                    }
                }
            }else if(idDelete == 0){
                String tmpSql = sql.trim();
                tmpSql = tmpSql.replace("delete from customer where", "");
                tmpSql = tmpSql.trim();
                
                String temp[] = tmpSql.split("=");
                String oid = temp[1].replace(";", "");
                oid = oid.replace(")", "");
                oid = oid.trim();
                
                Customer c = new Customer();
                try {
                    c = DbCustomer.fetchExc(Long.parseLong(String.valueOf(oid)));
                    if(c.getOID() != 0){
                        cHis.setCustomerId(c.getOID());
                        cHis.setNote("Penghapusan data member :"+c.getName()+",barcode:"+c.getCode());
                        cHis.setBarcode(c.getCode());
                        cHis.setDate(new Date());
                        cHis.setName(c.getName().trim());
                        cHis.setTypeHistory(DbCustomerHistory.TYPE_HISTORY_BACKOFFICE);
                        cHis.setType(DbCustomerHistory.TYPE_DELETE);
                    }
                } catch (Exception e) {
                }
            }else if(idInsertPoint==0){
                String tmpSql = sql.trim();
                tmpSql = tmpSql.replace("insert into pos_member_point", "");
                tmpSql = tmpSql.trim();

                String temp[] = tmpSql.split("values");
                if (temp.length == 2) {

                    String col = temp[0].trim();
                    col = col.replace("(", "");
                    col = col.replace(")", "");
                    col = col.replace("'", "");

                    String val = temp[1].trim();
                    val = val.replace("(", "");
                    val = val.replace(")", "");
                    val = val.replace(";", "");
                    val = val.replace("'", "");
                    
                    long customerId = 0;
                    int inOut = 0;
                    long salesId = 0;
                    double point = 0;
                    
                    String arrayCol[] = col.split(",");
                    String arrayVal[] = val.split(",");
                    
                    for (int i = 0; i < arrayCol.length; i++) {
                        if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbMemberPoint.colNames[DbMemberPoint.COL_CUSTOMER_ID])) {
                            customerId = Long.parseLong((String) arrayVal[i]);
                        } else if (String.valueOf(arrayCol[i]).trim().equalsIgnoreCase(DbMemberPoint.colNames[DbMemberPoint.COL_IN_OUT])) {
                            inOut = Integer.parseInt(String.valueOf((String) arrayVal[i]));                            
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbMemberPoint.colNames[DbMemberPoint.COL_SALES_ID])) {
                            salesId = Long.parseLong(String.valueOf((String) arrayVal[i]));                            
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbMemberPoint.colNames[DbMemberPoint.COL_POINT])) {
                            point = Double.parseDouble(String.valueOf((String) arrayVal[i]));                            
                        } else if (String.valueOf(arrayCol[i].trim()).equalsIgnoreCase(DbMemberPoint.colNames[DbMemberPoint.COL_SALES_ID])) {
                            salesId = Long.parseLong(String.valueOf((String) arrayVal[i]));                            
                        }
                    }
                    
                    if(inOut == -1){
                        Customer c = new Customer();
                        try {
                            c = DbCustomer.fetchExc(customerId);
                        } catch (Exception e) {}
                        
                        Sales s = new Sales();
                        String ket = "";
                        try{
                            if(salesId != 0){
                                s = DbSales.fetchExc(salesId);
                                ket = " dengan transaksi nomor :"+s.getNumber()+", tanggal "+JSPFormater.formatDate(s.getDate());
                                Location l = new Location();
                                try{
                                    l = DbLocation.fetchExc(s.getLocation_id());
                                    ket = ket +" lokasi "+l.getName();
                                }catch(Exception e){}
                            }        
                        }catch(Exception e){}
                        
                        cHis.setCustomerId(c.getOID());
                        cHis.setNote("Pengambilan poin oleh member"+ket+" dengan nilai:" + JSPFormater.formatNumber(point,"###,###.##"));
                        cHis.setBarcode(c.getCode());
                        cHis.setDate(new Date());
                        cHis.setName(c.getName());
                        cHis.setTypeHistory(DbCustomerHistory.TYPE_HISTORY_POS);
                        cHis.setType(DbCustomerHistory.TYPE_POINT_KELUAR);
                        cHis.setSalesId(salesId);
                    }
                }
                
                //insert into pos_member_point (member_point_id,customer_id,date,point,in_out,type,point_unit_value,sales_id,group_type,item_group_id,last_point) values(49150220115408845,61150108130316434,'2015-02-20 11:54:08',49,1,0,0,49150220115320157,0,0,3543)
                
            }
        } catch (Exception e) {}
        
        return cHis;
    }

    public static int insertHistory(CustomerHistory cHis) {
        String where = "";
        int count = 0;
        
        if(cHis.getType() == DbCustomerHistory.TYPE_INSERT){
            where = DbCustomerHistory.colNames[DbCustomerHistory.COL_TYPE]+" = "+DbCustomerHistory.TYPE_INSERT+" and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_CUSTOMER_ID]+" = "+cHis.getCustomerId();        
        }else if(cHis.getType() == DbCustomerHistory.TYPE_DELETE){
            where = DbCustomerHistory.colNames[DbCustomerHistory.COL_TYPE]+" = "+DbCustomerHistory.TYPE_DELETE+" and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_CUSTOMER_ID]+" = "+cHis.getCustomerId();
        }else if(cHis.getType() == DbCustomerHistory.TYPE_UPDATE){
            where = DbCustomerHistory.colNames[DbCustomerHistory.COL_TYPE]+" = "+DbCustomerHistory.TYPE_UPDATE+" and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_CUSTOMER_ID]+" = "+cHis.getCustomerId()+" and "+
                    DbCustomerHistory.colNames[DbCustomerHistory.COL_TYPE_HISTORY]+" = "+cHis.getTypeHistory()+" and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_NOTE]+" = '"+cHis.getNote()+"' and "+
                    DbCustomerHistory.colNames[DbCustomerHistory.COL_BARCODE]+" = '"+cHis.getBarcode()+"' and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_NAME]+" = '"+cHis.getName()+"'";
        }else if(cHis.getType() == DbCustomerHistory.TYPE_POINT_KELUAR){
            where = DbCustomerHistory.colNames[DbCustomerHistory.COL_TYPE]+" = "+DbCustomerHistory.TYPE_INSERT+" and "+DbCustomerHistory.colNames[DbCustomerHistory.COL_SALES_ID]+" = "+cHis.getSalesId();        
        }
        
        count = DbCustomerHistory.getCount(where);
        try {
            if(count==0){
                DbCustomerHistory.insertExc(cHis);
            }
        } catch (Exception e) {
        }
        return 0;
    }
}
