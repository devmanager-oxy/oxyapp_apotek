package com.project.admin;

import java.util.*;
import com.project.main.db.*;
import java.sql.*;
import java.util.Date;

public class QrUserSession {

    public final static String HTTP_SESSION_NAME = "USER_SESSION";
    public final static int DO_LOGIN_OK = 0;
    public final static int DO_LOGIN_ALREADY_LOGIN = 1;
    public final static int DO_LOGIN_NOT_VALID = 2;
    public final static int DO_LOGIN_SYSTEM_FAIL = 3;
    public final static int DO_LOGIN_GET_PRIV_ERROR = 4;
    public final static int DO_LOGIN_NO_PRIV_ASIGNED = 5;
    public final static String[] soLoginTxt = {"Login succeed", "User is already logged in",
        "Login ID or Password are invalid", "System cannot login you", "Can't get privilege",
        "No access asigned, please contact your system administrator"
    };
    private Vector privObj = new Vector();
    private User appUser = new User();

    public User getUser() {
        return appUser;
    }

    /** Creates new QrUserSession */
    public QrUserSession() {
        appUser.setUserStatus(User.STATUS_LOGOUT);
    }

    public QrUserSession(String hostIP) {
        appUser.setUserStatus(User.STATUS_LOGOUT);
        appUser.setLastLoginIp(hostIP);
    }

    public String getUserName() {
        return appUser.getFullName();
    }

    public long getUserOID() {
        return appUser.getOID();
    }

    public long getCompanyOID() {
        return 0;
    }

    public String getLoginId() {
        return appUser.getLoginId();
    }

    public int getUserLevel() {
        return appUser.getUserLevel();
    }

    public String getEmployeeNum() {
        return appUser.getEmployeeNum();
    }
    
    public boolean isResetPassword() {
        return appUser.isResetPassword();
    }

    public boolean isLoggedIn() {
        if ((this.appUser.getUserStatus() == User.STATUS_LOGIN)) {
            return true;
        } else {
            return false;
        }
    }

    public boolean checkPrivilege(int objCode) {
        if (!isLoggedIn()) {
            return false;
        }
        return QrPrivilegeObj.existCode(this.privObj, objCode);
    }
    public final String[] injectString = {"=", "<", ">", "?", "&", "|", "!", "/", "%", " ", "#", "@", "*", "(", ")", "+"};

    public String removeInjection(String str) {

        boolean injection = false;
        String s = "";
        String result = "";
        for (int i = 0; i < str.length(); i++) {

            injection = false;
            s = "" + str.charAt(i);

            for (int x = 0; x < injectString.length; x++) {
                if (injectString[x].equals(s)) {
                    injection = true;
                    break;
                }
            }

            if (!injection) {
                result = result + s;
            }
        }

        return result;

    }

    public int doLogin(String loginID, String password, String user_key) {

        loginID = removeInjection(loginID);
        password = removeInjection(password);
        user_key = removeInjection(user_key);

        User user = DbUser.getByLoginIDAndPassword(loginID, password, user_key);

        appUser = user;

        if (user == null) {
            return DO_LOGIN_SYSTEM_FAIL;
        }

        if (user.getOID() == 0) {
            return DO_LOGIN_NOT_VALID;
        }

        if (user.getOID() != 0) {
            try {
                user = DbUser.fetch(user.getOID());
                appUser = user;
            } catch (Exception e) {
            }
        }

        /* un comment this to enable checking of user host IP */
        /*         
        if( (user.getUserStatus()==User.STATUS_LOGIN) &&
        !(this.appUser.getLastLoginIp().equals(user.getLastLoginIp())))
        return DO_LOGIN_ALREADY_LOGIN;
         **/

        user.setLastLoginIp(this.appUser.getLastLoginIp());
        user.setUserStatus(User.STATUS_LOGIN);
        user.setLastLoginDate(new Date());

        if (DbUser.update(user) == 0) {
            return DO_LOGIN_SYSTEM_FAIL;
        }

        this.appUser = user;
        privObj = getAllPrivileges(user.getOID());

        if (privObj == null) {
            privObj = new Vector(1, 1);
            return DO_LOGIN_GET_PRIV_ERROR;
        }

        return DO_LOGIN_OK;
    }

    public int doLogin(String loginID, String password) {
        loginID = removeInjection(loginID);
        password = removeInjection(password);
        User user = DbUser.getByLoginIDAndPassword(loginID, password);
        appUser = user;

        if (user == null) {
            return DO_LOGIN_SYSTEM_FAIL;
        }

        if (user.getOID() == 0) {
            return DO_LOGIN_NOT_VALID;
        }

        if (user.getOID() != 0) {
            try {
                user = DbUser.fetch(user.getOID());
                appUser = user;
            } catch (Exception e) {
            }
        }

        user.setLastLoginIp(this.appUser.getLastLoginIp());
        user.setUserStatus(User.STATUS_LOGIN);
        user.setLastLoginDate(new Date());

        if (DbUser.update(user) == 0) {
            return DO_LOGIN_SYSTEM_FAIL;
        }
        
        this.appUser = user;

        privObj = getAllPrivileges(user.getOID());

        if (privObj == null) {
            privObj = new Vector(1, 1);
            return DO_LOGIN_GET_PRIV_ERROR;
        }

        return DO_LOGIN_OK;
    }

    public void doLogout() {
        if ((appUser == null) || (appUser.getUserStatus() != User.STATUS_LOGIN)) {
            return;
        }

        DbUser.updateUserStatus(appUser.getOID(), User.STATUS_LOGOUT);

    }

    public static boolean isHavePriviledge(long oidUser, int menu) {
        CONResultSet crs = null;
        boolean result = false;
        try {
            String sql = "select count(s." + DbUser.colNames[DbUser.COL_USER_ID] + ") from " + DbUser.DB_APP_USER + " s " +
                    " inner join " + DbUserGroup.DB_USER_GROUP + " ug on ug." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + " = s." + DbUser.colNames[DbUser.COL_USER_ID] +
                    " inner join " + DbUserPriv.DB_USER_PRIV + " up on up." + DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + " = ug." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    " and s." + DbUser.colNames[DbUser.COL_USER_ID] + "=" + oidUser;

            if (menu != AppMenu.M1_MENU_HOMEPAGE) {
                sql = sql + " and up." + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + menu;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            if (count > 0) {
                result = true;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static boolean isHavePriviledge(long oidUser, int menu1, int menu2) {
        CONResultSet crs = null;
        boolean result = false;
        try {
            String sql = "select count(s." + DbUser.colNames[DbUser.COL_USER_ID] + ") from " + DbUser.DB_APP_USER + " s " +
                    " inner join " + DbUserGroup.DB_USER_GROUP + " ug on ug." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + " = s." + DbUser.colNames[DbUser.COL_USER_ID] +
                    " inner join " + DbUserPriv.DB_USER_PRIV + " up on up." + DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + " = ug." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    " and s." + DbUser.colNames[DbUser.COL_USER_ID] + "=" + oidUser;

            if (menu1 != AppMenu.M1_MENU_HOMEPAGE) {
                sql = sql + " and (up." + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + menu1 +
                        " and up." + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + menu2 + ")";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            if (count > 0) {
                result = true;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static boolean isHavePriviledge(long oidUser, int menu1, int menu2, int type) {
        CONResultSet crs = null;
        boolean result = false;
        try {
            String sql = "select count(s." + DbUser.colNames[DbUser.COL_USER_ID] + ") from " + DbUser.DB_APP_USER + " s " +
                    " inner join " + DbUserGroup.DB_USER_GROUP + " ug on ug." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + " = s." + DbUser.colNames[DbUser.COL_USER_ID] +
                    " inner join " + DbUserPriv.DB_USER_PRIV + " up on up." + DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + " = ug." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    " and s." + DbUser.colNames[DbUser.COL_USER_ID] + "=" + oidUser;

            if (menu1 != AppMenu.M1_MENU_HOMEPAGE) {
                sql = sql + " and (up." + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + menu1 +
                        " and up." + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + menu2 + ")";
            }

            switch (type) {
                //view
                case 0:
                    sql = sql + " and up." + DbUserPriv.colNames[DbUserPriv.COL_CMD_VIEW] + "=1)";
                    break;
                //add    
                case 1:
                    sql = sql + " and up." + DbUserPriv.colNames[DbUserPriv.COL_CMD_ADD] + "=1)";
                    break;
                //update
                case 2:
                    sql = sql + " and up." + DbUserPriv.colNames[DbUserPriv.COL_CMD_EDIT] + "=1)";
                    break;
                //delete
                case 3:
                    sql = sql + " and up." + DbUserPriv.colNames[DbUserPriv.COL_CMD_DELETE] + "=1)";
                    break;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            if (count > 0) {
                result = true;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    private Vector getAllPrivileges(long oidUser) {
        CONResultSet crs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = " select distinct su." + DbUser.colNames[DbUser.COL_USER_ID] + ", uv." + DbUserPriv.colNames[DbUserPriv.COL_MN_1] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_MN_2] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_CMD_ADD] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_CMD_EDIT] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_CMD_VIEW] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_CMD_DELETE] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_CMD_PRINT] +
                    " from " + DbUser.DB_APP_USER + " su " +
                    " inner join " + DbUserGroup.DB_USER_GROUP + " ug on su." + DbUser.colNames[DbUser.COL_USER_ID] +
                    " = ug." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] +
                    " inner join " + DbUserPriv.DB_USER_PRIV + " uv on uv." + DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] +
                    " = ug." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    " where su." + DbUser.colNames[DbUser.COL_USER_ID] + "=" + oidUser +
                    " order by uv." + DbUserPriv.colNames[DbUserPriv.COL_MN_1] +
                    " , uv." + DbUserPriv.colNames[DbUserPriv.COL_MN_2];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                UserPriv uv = new UserPriv();
                long oid = rs.getLong(1);
                int mn1 = rs.getInt(2);
                int mn2 = rs.getInt(3);
                int cmdAdd = rs.getInt(4);
                int cmdEdit = rs.getInt(5);
                int cmdView = rs.getInt(6);
                int cmdDelete = rs.getInt(7);                
                int cmdPrint = rs.getInt(8);  
                uv.setUserId(oid);
                uv.setMn1(mn1);
                uv.setMn2(mn2);
                uv.setCmdAdd(cmdAdd);
                uv.setCmdEdit(cmdEdit);
                uv.setCmdView(cmdView);
                uv.setCmdDelete(cmdDelete);
                uv.setCmdPrint(cmdPrint);
                result.add(uv);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public boolean isPriviledged(long oidUser, int menu1, int menu2) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == menu1 && uv.getMn2() == menu2) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isPriviledged(long oidUser, int menu1, int menu2, int type) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == menu1 && uv.getMn2() == menu2) {
                    boolean found = false;
                    switch (type) {
                        //view
                        case 0:
                            if (uv.getCmdView() == 1) {
                                found = true;
                            }
                            break;
                        //add    
                        case 1:
                            if (uv.getCmdAdd() == 1) {
                                found = true;
                            }
                            break;
                        //update
                        case 2:
                            if (uv.getCmdEdit() == 1) {
                                found = true;
                            }
                            break;
                        //delete
                        case 3:
                            if (uv.getCmdDelete() == 1) {
                                found = true;
                            }
                            break;
                        //print
                        case 4:
                            if (uv.getCmdPrint() == 1) {
                                found = true;
                            }
                            break;
                        //posting    
                        case 5:
                            if (uv.getCmdPosting() == 1) {
                                found = true;
                            }
                            break;
                    }

                    if (found) {
                        return true;
                    }

                }
            }
        }
        return false;

    }

    //=== UNTUK TRANSAKSI BANK ======
    //Cash Receive Detail    
    public boolean isCsRd(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CR) {
                    return true;
                }
            }
        }
        return false;

    }

    //Cash Receive Advance    
    public boolean isCsRa(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CRA) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_PETTYCASH_PAYMENT
    public boolean isCsPP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CPP) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_PAYMENT//Pembayaran Tunai
    public boolean isCsP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CP) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_PETTYCASH_PAYMENT_ADVANCE//Kasbon
    public boolean isCPPA(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CPPA) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_PETTYCASH_REPLENISHMENT
    public boolean isCPR(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CPR) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_RECEIVE_POST
    public boolean isCRP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CRP) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_ARCHIVES
    public boolean isCAR(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CAR) {
                    return true;
                }
            }
        }
        return false;

    }

    //CASH_ACCLINK
    public boolean isCA(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CA) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_DEPOSIT
    public boolean isBDEP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BD) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MN_BPO
    public boolean isBPO(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BPO) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_PAYMENT_NON_PO    
    public boolean isBPNP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BPN) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_CASH_PAYMENT
    public boolean isBCP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BC) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_POST
    public boolean isBPOS(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BP) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_ARCHIVES
    public boolean isBAR(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BA) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_BANK_ACCLINK
    public boolean isBLINK(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_B && uv.getMn2() == AppMenu.M2_MN_BL) {
                    return true;
                }
            }
        }
        return false;

    }

    //M1_MENU_ACCRECEIVABLE
    public boolean isArA(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_AP && uv.getMn2() == AppMenu.M2_MENU_AA) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_ACCRECEIVABLE_AGING
    public boolean isArAg(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_AP && uv.getMn2() == AppMenu.M2_MENU_AA) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_ACCRECEIVABLE_ACCOUNT_LIST
    public boolean isArL(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_AP && uv.getMn2() == AppMenu.M2_MENU_ARL) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_INCOMING_GOOD_LIST
    public boolean isIGL(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_APAY && uv.getMn2() == AppMenu.M2_MENU_IGL) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_INVOICE_LIST
    public boolean isILI(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_APAY && uv.getMn2() == AppMenu.M2_MENU_ILI) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_AGING_ANALYSIS
    public boolean isAAN(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_APAY && uv.getMn2() == AppMenu.M2_MENU_AAN) {
                    return true;
                }
            }
        }
        return false;

    }

    //M2_MENU_PURCHASE_ACC_LIST
    public boolean isPAL(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_APAY && uv.getMn2() == AppMenu.M2_MENU_PAL) {
                    return true;
                }
            }
        }
        return false;

    }

    /************************ FINANCIAL REPORT ***********************************/
    // SETUP REPORT
    public boolean isSetRep(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_SETUP_REPORT) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isRep(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_REPORT) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isRepGl(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_REP_GL) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isRepNer(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_REP_NERACA) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isGlDet(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_GL_DETAIL) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isRepProfit(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_FIN_REP && uv.getMn2() == AppMenu.M2_MN_PROFIT_LOSS) {
                    return true;
                }
            }
        }
        return false;
    }

    /* Khusus untuk Cash Register */
    public boolean isRepCR(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_REPORT_CASH_REGISTER) {
                    return true;
                }
            }
        }
        return false;
    }

    /* Khusus untuk Cash Opname */
    public boolean isRepCOp(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                UserPriv uv = (UserPriv) temp.get(i);
                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MN_CASH && uv.getMn2() == AppMenu.M2_MN_CASH_OPNAME) {
                    return true;
                }
            }
        }
        return false;
    }
    
    //********************** END REPORT *******************************//
    public boolean isMstSysConf(long oidUser) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_CONFIGURATION) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isMstAcc(long oidUser) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_ACCOUNTING) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isMstSegment(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_SEGMENT) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isMstWP(long oidUser) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_WORKPLAN) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isMstComp(long oidUser) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_COMPANY) {
                    return true;
                }
            }
        }
        return false;

    }

    public boolean isMstGen(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_GENERAL) {
                    return true;
                }
            }
        }
        return false;

    }

    //Master Coa Budget
    public boolean isMstBudPriv(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_MASTER && uv.getMn2() == AppMenu.M2_MENU_BUDGET) {
                    return true;
                }
            }
        }
        return false;

    }   
   

    //Admin Administrator
    public boolean isAdm(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_ADMINISTRATOR && uv.getMn2() == AppMenu.M2_MENU_ADMINISTRATOR) {
                    return true;
                }
            }
        }
        return false;

    }
    
    public boolean isCP(long oidUser) {

        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                UserPriv uv = (UserPriv) temp.get(i);

                if (uv.getUserId() == oidUser && uv.getMn1() == AppMenu.M1_MENU_CLOSING && uv.getMn2() == AppMenu.M2_MENU_CLOSING_PERIOD) {
                    return true;
                }
            }
        }
        return false;

    }   
}
