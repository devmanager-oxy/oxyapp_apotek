/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.interfaces;

/**
 *
 * @author Roy
 */
public class CONHandlerInterface {

    /*private static String dbUrl = "jdbc:mysql://192.168.1.227:3306/";
    private static String dbName = "oxycocomart_sales";
    private static String dbUser = "root";
    private static String dbPassword = "oxycoco";*/
    
    /*private static String dbUrl = "jdbc:mysql://127.0.0.1:3307/";    
    private static String dbName = "oxysystem_masgrosir_sales";
    private static String dbUser = "root";
    private static String dbPassword = "oxyfortuna";*/
    
    private static String dbUrl = "jdbc:mysql://127.0.0.1:3307/";    
    private static String dbName = "oxysystem_sarjanase_sales";
    private static String dbUser = "root";
    private static String dbPassword = "oxyse";

    public static String getDbUrl() {
        return dbUrl;
    }

    public static void setDbUrl(String aDbUrl) {
        dbUrl = aDbUrl;
    }

    public static String getDbName() {
        return dbName;
    }

    public static void setDbName(String aDbName) {
        dbName = aDbName;
    }

    public static String getDbUser() {
        return dbUser;
    }

    public static void setDbUser(String aDbUser) {
        dbUser = aDbUser;
    }

    public static String getDbPassword() {
        return dbPassword;
    }

    public static void setDbPassword(String aDbPassword) {
        dbPassword = aDbPassword;
    }
}
