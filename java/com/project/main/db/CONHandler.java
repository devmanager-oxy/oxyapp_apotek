package com.project.main.db;

import java.io.*;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Vector;
import java.lang.reflect.*;
import java.util.*;
import com.project.system.*;
import com.project.util.JSPFormater;

public class CONHandler implements I_CONType {

    public static String CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "project" +
            System.getProperty("file.separator") + "oxyapp_general.xml";
    
    public static String SYSTEM_DATE_LIMIT = "2999-12-31";
    private static final int DELETE_RESTRICTED = 0;  // RESTRICTED,
    private static final int DELETE_CASCADE = 1;  // CASCADE, 
    private static final boolean ACTIVATE_LOG = true;//(Integer.parseInt(DbSystemProperty.getValueByName("APP_LOG_ACTIVATED"))==1) ? true : false; //activate logging session    
    private static final boolean ACTIVATE_SYNC_LOG = false;
    public static String DATE_FORMAT = "dd.MM.yyyy";
    public static char STR_DELIMITER = '\'';
    public static char DECIMAL_POINT = '.';
    public static final int CONSVR_MYSQL = 0;    
    public static final int CONSVR_POSTGRESQL = 1;
    public static final int CONSVR_SYBASE = 2;
    public static final int CONSVR_ORACLE = 3;
    public static final int CONSVR_MSSQL = 4;
    
    public static int CONSVR_TYPE = CONSVR_MYSQL;  // this is a CON Handler for MySQL    
    
    protected static String connLog = "tmsconn.log";
    protected static String CONDriver = "com.microsoft.jCONc.sqlserver.SQLServerDriver";
    protected static String CONUrl = "jCONc:microsoft:sqlserver://192.168.0.5:1433;databasename=ZIPREALTY;";
    protected static String CONUser = "sa";
    protected static String CONPwd = "aa";    
    protected static String dateFormat = "dd.MM.yyyy";
    protected static String decimalFormat = "#,##0.##";
    protected static String currencyFormat = "#,##0.00 '\u20AC'";
    protected static String CONSQLDecimalFormat = "#.##";
    protected static String CONSQLFloat3Format = "#.###";
    protected static String CONSQLQuoteString = "'";
    protected static String CONSQLIntegerFormat = "#";
    protected static int CONMinConn = 2;
    protected static int CONMaxConn = 15;
    public static boolean configLoaded = false;
    public static CONConfigReader cnfReader;
    private String tableName;
    private String pstName;
    private String[] fieldNames;
    private int[] fieldTypes;
    protected Vector fieldValues;
    protected boolean hasData;
    protected boolean recordModified;
    protected int[] keyIndex;
    protected int[] keyValues;
    protected int keyCount;
    protected int idIndex;
    protected int timestampIndex;
    //private static CONLogger CONLog = new CONLogger();
    protected static CONConnectionBroker connPool = null;
    private static OIDGenerator oidGenerator = new OIDGenerator();

    public CONHandler() {
    }

    public CONHandler(I_CONInterface iCON) throws CONException {
        tableName = iCON.getTableName();
        fieldNames = iCON.getFieldNames();
        fieldTypes = iCON.getFieldTypes();
        pstName = iCON.getPersistentName();

        hasData = false;
        recordModified = false;
        keyCount = 0;
        idIndex = -1;
        timestampIndex = -1;
        fieldValues = new Vector();

        //getLog();
        loadConfig();

        fieldValues.setSize(iCON.getFieldSize());

        int numbOfFields = iCON.getFieldSize();
        for (int j = 0; j < numbOfFields; j++) {
            if (isPrimaryKey(j)) {
                keyCount++;
            }
            if (getFieldType(j) == 4) {
                timestampIndex = j;
            }
        }


        keyValues = new int[keyCount];
        keyIndex = new int[keyCount];

        int k = 0;
        int l = 0;

        for (; k < numbOfFields; k++) {
            if (isPrimaryKey(k)) {
                keyIndex[l++] = k;
            }
        }


        int i1 = 0;
        for (int j1 = 0; j1 < numbOfFields; j1++) {
            if (isIdentity(j1)) {
                i1++;
                idIndex = j1;
            }
        }

        if (i1 > 1) {
            throw new CONException(this, CONException.MULTIPLE_ID);
        } else {
            return;
        }

    } // end of Constructor CONHandler

    protected static void getLog() {
    }

    //production
    protected static void loadConfig_()
            throws CONException {
        if (!configLoaded) {
            try {
                CONDriver = "com.mysql.jdbc.Driver";                                   
                CONUrl = "jdbc:mysql://localhost:3306/oxysystem_baliasri";    
                
                CONUser = "oxysystem";    
                CONPwd = "oxyqwerty";
                
                configLoaded = true;
            } catch (Exception exception) {
                exception.printStackTrace(System.err);
                throw new CONException(null, CONException.CONFIG_ERROR);
            }
        }
    }

    protected static void loadConfig_dev_on()
            throws CONException {
        if (!configLoaded) {
            getLog();
            try {
                CONDriver = "org.gjt.mm.mysql.Driver";
                CONUrl = "jCONc:mysql://mysql5x.webappcabaret.net/obisinc_6";
                CONUser = "obisinc_6";
                CONPwd = "ssp123";
                configLoaded = true;
            } catch (Exception exception) {
                exception.printStackTrace(System.err);
                throw new CONException(null, CONException.CONFIG_ERROR);
            }
        }
    }

    protected static void loadConfig()
            throws CONException {
        if (!configLoaded) {
            try {
                CONConfigReader configReader = new CONConfigReader(CONFIG_FILE);

                CONDriver = configReader.getConfigValue("dbdriver");
                CONUrl = configReader.getConfigValue("dburl");
                CONUser = configReader.getConfigValue("dbuser");
                CONPwd = configReader.getConfigValue("dbpasswd");

                // Set the minimum and maximum connection
                String configValue = configReader.getConfigValue("dbminconn");
                if (configValue != null && !configValue.equals("")) {
                    CONMinConn = (new Integer(configValue)).intValue();
                }

                configValue = configReader.getConfigValue("dbmaxconn");
                if (configValue != null && !configValue.equals("")) {
                    CONMaxConn = (new Integer(configValue)).intValue();
                }

                // Set log file for connection
                configValue = configReader.getConfigValue("logconn");
                if (configValue != null && !configValue.equals("")) {
                    connLog = configValue;
                }

                // Set format for: date, decimal and currency
                configValue = configReader.getConfigValue("fordate");
                if (configValue != null && !configValue.equals("")) {
                    dateFormat = configValue;
                }

                configValue = configReader.getConfigValue("fordecimal");
                if (configValue != null && !configValue.equals("")) {
                    decimalFormat = configValue;
                }

                configValue = configReader.getConfigValue("forcurrency");
                if (configValue != null && !configValue.equals("")) {
                    currencyFormat = configValue;
                }

                configLoaded = true;
            } catch (Exception exception) {
                exception.printStackTrace(System.err);
                throw new CONException(null, CONException.CONFIG_ERROR);
            }
        }
    }

    protected boolean checkConcurrency(Connection connection)
            throws CONException {
        if (timestampIndex < 0) {
            return true;
        }

        boolean flag = false;
        Connection connection1 = connection;
        Statement statement = null;
        try {
            if (connection1 == null) {
                connection1 = getConnection();
            }
            statement = getStatement(connection1);
            String s = "";
            ResultSet resultset = statement.executeQuery(getTimestampSQL());
            if (hasData = resultset.next()) {
                String s1 = resultset.getString(1);
                flag = s1.equals(getString(timestampIndex));
            }
            resultset.close();
            if (!flag) {
                throw new CONException(this, CONException.CONCURRENCY_VIOLATION);
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            if (connection == null) {
                closeConnection(connection1);
            }
        }
        return flag;
    }

    protected int checkFieldIndex(int i)
            throws CONException {
        if (i < 0 || i >= fieldNames.length) {
            throw new CONException(this, CONException.INDEX_OUT_OF_RANGE);
        } else {
            return i;
        }
    }

    protected static void closeConnection(Connection connection)
            throws CONException {
        try {
            if (connection != null) {
                int i = connPool.idOfConnection(connection);
                connPool.freeConnection(connection);
            }
        } catch (Exception exception) {
            exception.printStackTrace(System.err);
            throw new CONException(null, CONException.UNKNOWN);
        }
    }

    protected static void closeStatement(Statement statement)
            throws CONException {
        getLog();
        try {
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        }
    }

    public void delete()
            throws CONException {
        if (!hasData) {
            throw new CONException(this, CONException.NOT_OPEN);
        }

        Connection connection = null;
        Statement statement = null;
        try {
            connection = getConnection();
            checkConcurrency(connection);
            statement = getStatement(connection);
            String queryDelete = getDeleteSQL();            
            statement.executeUpdate(queryDelete);                        
            if (ACTIVATE_LOG) {
                try{
                    CONLogger.insertLogs(queryDelete, tableName);
                }catch(Exception e){}                
            }
            
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }

    protected void deleteRecords(int i, String s)
            throws CONException {
        if (s == "") {
            return;
        }
        Connection connection = null;
        Statement statement = null;
        try {
            connection = getConnection();
            statement = getStatement(connection);
            String s1 = "DELETE FROM " + tableName + " WHERE " + s;
            statement.executeUpdate(s1);
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }

    public static void destroy() {
        if (connPool != null) {
            connPool.destroy();
        }
    }

    public static String formatCurrency(double d) {
        getLog();
        try {
            loadConfig();
            DecimalFormat decimalformat = new DecimalFormat(currencyFormat);
            return decimalformat.format(d);
        } catch (Exception _ex) {
        //CONLog.warning("Floating point conversion error");
        }
        return "0";
    }

    protected Vector getAllRecords(int i)
            throws CONException {
        loadConfig();
        return getDetailsInt("", fieldNames[i]);
    }

    public Boolean getBoolean(int i)
            throws CONException {
        return new Boolean(getInt(i) != 0);
    }

    public boolean getboolean(int i)
            throws CONException {
        Boolean bVal = new Boolean(getInt(i) != 0);
        return bVal.booleanValue();
    }

    protected static Connection getConnection()
            throws CONException {
        getLog();
        getConnectionPool();
        //CONLog.trace("Intializing connect sequence...");
        try {
            //CONLog.trace("Trying to get a connection...");
            Connection connection = connPool.getConnection();
            //CONLog.info("Connected to database: " + CONUrl + " using connection no. " + connPool.idOfConnection(connection));
            return connection;
        } catch (Exception exception) {
            exception.printStackTrace(System.err);
        }
        throw new CONException(null, CONException.NO_CONNECTION);
    }

    protected static void getConnectionPool()
            throws CONException {
        loadConfig();
        if (connPool == null) {
            try {
                connPool = new CONConnectionBroker(CONDriver, CONUrl, CONUser, CONPwd, CONMinConn, CONMaxConn + 1, connLog, 0.01D);
            } catch (Exception _ex) {
                throw new CONException(null, CONException.DRIVER_NOT_FOUND);
            }
        }
    }

    protected void getData(ResultSet resultset)
            throws CONException {
        try {
            for (int i = 0; i < fieldValues.size(); i++) {
                if (getFieldType(i) == 4) {
                    fieldValues.set(i, resultset.getString(fieldNames[i]));
                } else {
                    fieldValues.set(i, resultset.getObject(fieldNames[i]));
                }
            }

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        }
    }

    public java.util.Date getDate(int i)
            throws CONException {
        if (getFieldType(checkFieldIndex(i)) != 3 && getFieldType(checkFieldIndex(i)) != 4) {
            throw new CONException(this, CONException.INVALID_DATE);
        } else {
            return (java.util.Date) fieldValues.get(i);
        }
    }

    protected String getDeleteSQL() {
        return "DELETE FROM " + tableName + " WHERE " + getKeyCondition();
    }

    protected Vector getDetailRecords(int j, int k)
            throws CONException {
        return getDetailsInt(fieldNames[k] + " = " + getSQLValue(j), "");
    }

    protected Vector getDetailsInt(String s, String s1)
            throws CONException {
        String sql = "SELECT * FROM " + tableName + (s != "" ? " WHERE " + s : "") + (s1 != "" ? " ORDER BY " + s1 : "");
        return execQuery(sql, pstName);
    }

    protected String getFieldList(boolean flag) {
        String s = "";
        for (int i = 0; i < fieldNames.length; i++) {
            if (flag || !isIdentity(i)) {
                s = s + fieldNames[i] + ", ";
            }
        }

        s = s.substring(0, s.length() - 2);
        return s;
    }

    protected String getFieldSetList() {
        String s = "";
        for (int i = 0; i < fieldNames.length; i++) {
            if (!isIdentity(i) && getFieldType(i) != 4) {
                s = s + fieldNames[i] + " = " + getSQLValue(i) + ", ";
            }
        }
        s = s.substring(0, s.length() - 2);
        return s;
    }

    protected int getFieldType(int i) {
        return fieldTypes[i] & 0xff;
    }

    public double getdouble(int i)
            throws CONException {
        try {
            NumberFormat numberformat = NumberFormat.getNumberInstance();
            Number number = numberformat.parse(getObject(i).toString());
            return (double) number.doubleValue();
        } catch (ParseException parseexception) {
            parseexception.printStackTrace(System.err);
        }
        throw new CONException(this, CONException.CONVERSION_ERROR);
    }

    public float getfloat(int i)
            throws CONException {
        try {           
            Float number = (Float) getObject(i);
            return (float) number.floatValue();
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
        throw new CONException(this, CONException.INVALID_NUMBER);
    }

    protected Long getIDValue()
            throws CONException {
        try {
            return new Long(oidGenerator.generateOID());
        } catch (Exception e) {
            return new Long(0);
        }
    }

    protected String getInsertSQL() {
        return "INSERT INTO " + tableName + "(" + getFieldList(true) + ") VALUES (" + getValueList(true) + ")";
    }

    public long getlong(int i)
            throws CONException {
        try {
            NumberFormat numberformat = NumberFormat.getNumberInstance();
            Object obj = getObject(i);
            if (obj != null) {
                Number number = numberformat.parse(obj.toString());
                return number.longValue();
            } else {
                return 0;
            }
        } catch (Exception exception) {
            exception.printStackTrace(System.err);
        }
        throw new CONException(this, CONException.CONVERSION_ERROR);
    }

    public int getInt(int i)
            throws CONException {
        try {
            NumberFormat numberformat = NumberFormat.getNumberInstance();
            Object obj = getObject(i);
            if (obj != null) {
                Number number = numberformat.parse(obj.toString());
                return number.intValue();
            } else {
                return 0;
            }
        } catch (Exception exception) {
            exception.printStackTrace(System.err);
        }
        throw new CONException(this, CONException.CONVERSION_ERROR);
    }

    public Long getLong(int i)
            throws CONException {
        switch (getFieldType(i)) {
            case 0: // '\0'
            case 2: // '\002'
                return new Long(getlong(i));

            case 1: // '\001'
            default:
                return null;
        }
    }

    public Integer getInteger(int i)
            throws CONException {
        switch (getFieldType(i)) {
            case 0: // '\0'
            case 2: // '\002'
                return new Integer(getInt(i));

            case 1: // '\001'
            default:
                return null;
        }
    }

    protected String getKeyCondition() {
        String s = "(";
        for (int i = 0; i < fieldNames.length; i++) {
            if (isPrimaryKey(i)) {
                s = s + fieldNames[i] + " = " + getSQLValue(i) + " AND ";
            }
        }

        s = s.substring(0, s.length() - 4) + ")";
        return s;
    }

    protected Object getObject(int i)
            throws CONException {
        if (!hasData) {
            throw new CONException(this, CONException.NOT_OPEN);
        } else {
            return fieldValues.get(checkFieldIndex(i));
        }
    }

    protected String getSQLValue(int i) {
        if (fieldValues.elementAt(i) != null) {
            String s = fieldValues.elementAt(i).toString();

            switch (getFieldType(i)) {
                case I_CONType.TYPE_INT: // '\0'
                    if ((isForeignKey(i)) && (Integer.parseInt(s) == 0)) {
                        switch (CONSVR_TYPE) {
                            case CONSVR_ORACLE:
                                s = "NULL";
                                break;
                            case CONSVR_MYSQL:
                                s = "0";
                                break;
                            case CONSVR_POSTGRESQL:
                                s = "NULL";
                                break;
                            case CONSVR_MSSQL:
                                s = "0";
                                break;
                            case CONSVR_SYBASE:
                                break;
                            default:
                                s = "0";
                                break;
                        }

                    }
                default:
                    break;

                case I_CONType.TYPE_LONG: // '\0'
                    if ((isForeignKey(i)) && (Long.parseLong(s) == 0)) {
                        switch (CONSVR_TYPE) {
                            case CONSVR_ORACLE:
                                s = "NULL";
                                break;
                            case CONSVR_MYSQL:
                                s = "0";
                                break;
                            case CONSVR_POSTGRESQL:
                                s = "NULL";
                                break;
                            case CONSVR_MSSQL:
                                s = "0";
                                break;
                            case CONSVR_SYBASE:
                                break;
                            default:
                                s = "0";
                                break;
                        }
                    }

                    break;

                case I_CONType.TYPE_DATE: // '\003'
                    if (s.toUpperCase().equals("CURRENT_TIME")) {
                        s = "SYSDATE";
                    } else {
                        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        switch (CONSVR_TYPE) {
                            case CONSVR_ORACLE:
                                s = "TO_DATE('" + simpledateformat.format(fieldValues.elementAt(i)) + "', 'YYYY-MM-DD HH24:MI:SS')";
                                break;
                            case CONSVR_MYSQL:
                                // MySQL date format
                                s = "DATE_FORMAT('" + simpledateformat.format(fieldValues.elementAt(i)) + "', '%Y-%m-%d %T')";
                                break;
                            case CONSVR_POSTGRESQL:
                                // Postgres
                                s = "TO_TIMESTAMP('" + simpledateformat.format(fieldValues.elementAt(i)) + "', 'YYYY-MM-DD HH24:MI:SS')";
                                break;
                            case CONSVR_MSSQL:
                                s = "'" + simpledateformat.format(fieldValues.elementAt(i)) + "'";
                                break;
                            case CONSVR_SYBASE:
                                break;
                            default:
                                s = "DATE_FORMAT('" + simpledateformat.format(fieldValues.elementAt(i)) + "', '%Y-%m-%d %T')";
                                break;
                        }
                    }
                    break;

                case I_CONType.TYPE_STRING: // '\001'
                    s = quoteString(s, CONSQLQuoteString);
                    if ((isForeignKey(i)) && (s.length() == 2)) {
                        switch (CONSVR_TYPE) {
                            case CONSVR_ORACLE:
                                s = "NULL";
                                break;
                            case CONSVR_MYSQL:
                                s = "";
                                break;
                            case CONSVR_POSTGRESQL:
                                s = "NULL";
                                break;
                            case CONSVR_MSSQL:
                                s = "";
                                break;
                            case CONSVR_SYBASE:
                                break;
                            default:
                                s = "";
                                break;
                        }
                    }

                    break;

                case I_CONType.TYPE_FLOAT: // '\002'
                    if (!fieldValues.elementAt(i).getClass().getName().equals("java.lang.String")) {
                        DecimalFormat decimalformat = new DecimalFormat(CONSQLDecimalFormat);
                        s = decimalformat.format(((Number) fieldValues.elementAt(i)).doubleValue());
                    }
                    break;
                case I_CONType.TYPE_FLOAT3: //8
                    if (!fieldValues.elementAt(i).getClass().getName().equals("java.lang.String")) {
                        DecimalFormat decimalformat = new DecimalFormat(CONSQLFloat3Format);
                        s = decimalformat.format(((Number) fieldValues.elementAt(i)).doubleValue());
                    }
                    break;

            }
            return s;
        } else {
            return "NULL";
        }
    }

    protected String getSelectSQL() {
        return "SELECT " + getFieldList(true) + " FROM " + tableName + " WHERE " + getKeyCondition();
    }

    protected static Statement getStatement(Connection connection)
            throws CONException {
        getLog();
        try {
            if (connection != null) {
                Statement statement = connection.createStatement();
                //CONLog.info("Opened a statement: " + statement.toString());
                return statement;
            } else {
                throw new CONException(null, CONException.NO_CONNECTION);
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        }
    }

    public String getString(int i)
            throws CONException {
        Object obj = getObject(i);
        if (obj == null) {
            return null;
        }
        String s = "";
        switch (getFieldType(i)) {
            default:
                break;

            case 3: // '\003'
                SimpleDateFormat simpledateformat = new SimpleDateFormat(dateFormat);
                s = simpledateformat.format((java.util.Date) obj);
                break;

            case 2: // '\002'
                if (!isPrimaryKey(i)) {
                    DecimalFormat decimalformat = new DecimalFormat(decimalFormat);
                    s = decimalformat.format(((Number) obj).floatValue());
                } else {
                    s = (new Integer(((Number) obj).intValue())).toString();
                }
                break;

            case 0: // '\0'
            case 1: // '\001'
            case 4: // '\004'
                s = obj.toString().trim();
                if (s.equals("<NULL>")) {
                    s = null;
                }
                break;
        }
        return s;
    }

    protected String getTimestampSQL() {
        return "SELECT " + fieldNames[timestampIndex] + " FROM " + tableName + " WHERE " + getKeyCondition();
    }

    protected String getUpdateSQL() {
        return "UPDATE " + tableName + " SET " + getFieldSetList() + " WHERE " + getKeyCondition();
    }

    protected String getValueList(boolean flag) {
        String s = "";
        for (int i = 0; i < fieldNames.length; i++) {
            if (!isIdentity(i)) {
                s = s + getSQLValue(i) + ", ";
            } else {
                if (flag) {
                    s = s + getSQLValue(i) + ", ";
                }
            }
        }

        s = s.substring(0, s.length() - 2);
        return s;
    }

    protected CONHandler initialize(ResultSet resultset)
            throws CONException {
        getData(resultset);
        hasData = true;
        return this;
    }

    public int insert()
            throws CONException {

        Connection connection = null;
        Statement statement = null;
        byte byte0 = -1;
        try {
            connection = getConnection();
            statement = getStatement(connection);
            if (idIndex != -1) {
                fieldValues.set(idIndex, getIDValue());
            }
            String queryInsert = getInsertSQL();                                  
            statement.executeUpdate(queryInsert); 
            
            if (ACTIVATE_LOG) {
                try{
                    CONLogger.insertLogs(queryInsert, tableName);
                }catch(Exception e){}                
            }

            hasData = true;
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }

        return byte0;
    }

    protected boolean isIdentity(int i) {
        return (fieldTypes[i] & TYPE_ID) != 0;
    }

    protected boolean isNull(int i)
            throws CONException {
        return getObject(i) == null;
    }

    protected boolean isPrimaryKey(int i) {
        return (fieldTypes[i] & TYPE_PK) != 0;
    }

    protected boolean isForeignKey(int i) {
        return (fieldTypes[i] & TYPE_FK) != 0;
    }

    protected void loadKey()
            throws CONException {
        for (int i = 0; i < keyCount; i++) {
            keyValues[i] = getInt(keyIndex[i]);
        }

    }

    public boolean locate(String sOid)
            throws CONException {
        long ai[] = {(new Long(sOid)).longValue()};
        return locate(ai);
    }

    public boolean locate(long lOid)
            throws CONException {
        long ai[] = {lOid};
        return locate(ai);
    }

    public boolean locate(long lOid0, long lOid1)
            throws CONException {
        long ai[] = {lOid0, lOid1};
        return locate(ai);
    }

    public boolean locate(long lOid0, long lOid1, long lOid2)
            throws CONException {
        long ai[] = {lOid0, lOid1, lOid2};
        return locate(ai);
    }

    public boolean locate(long[] ai)
            throws CONException {
        Object aobj[] = new Object[ai.length];
        for (int i = 0; i < ai.length; i++) {
            aobj[i] = new Long(ai[i]);
        }

        return locate(aobj);
    }

    public boolean locate(Object[] aobj)
            throws CONException {
        if (keyCount != aobj.length) {
            throw new CONException(this, CONException.INVALID_KEY);
        }
        hasData = false;
        Connection connection = null;
        Statement statement = null;
        reset();
        int i = 0;
        for (int j = 0; j < fieldNames.length; j++) {
            if (isPrimaryKey(j)) {
                fieldValues.set(j, aobj[i++]);
            }
        }

        try {
            connection = getConnection();
            statement = getStatement(connection);
            //CONLog.info("Execute SQL: " + getSelectSQL());
            ResultSet resultset = statement.executeQuery(getSelectSQL());
            if (hasData = resultset.next()) {
                getData(resultset);
            }
            resultset.close();
        //CONLog.info("Closed ResultSet.");
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
        return hasData;
    }

    protected String quoteString(String s, String s1) {
        String s2 = s;
        if (s1.length() > 0) {
            for (int i = -1; (i = s2.indexOf(s1, i + 1)) != -1;) {
                s2 = s2.substring(0, i) + s1 + s1 + s2.substring(++i);
            }

            s2 = s1 + s2 + s1;
        }
        return s2;
    }

    public void reset() {
        for (int i = 0; i < fieldValues.size(); i++) {
            fieldValues.set(i, null);
        }

        hasData = false;
    }

    public void setBoolean(int i, Boolean boolean1)
            throws CONException {
        if (boolean1 != null) {
            setInt(i, boolean1.booleanValue() ? 1 : 0);
        }
    }

    public void setboolean(int i, boolean boolean1)
            throws CONException {
        setInt(i, boolean1 ? 1 : 0);
    }

    public void setDate(int i, java.util.Date date)
            throws CONException {
        if (date != null) {
            setObject(i, new Date(date.getTime()));
        } else {
            setObject(i, null);
        }
    }

    public void setFloat(int i, double d)
            throws CONException {
        setObject(i, new Float(d));
    }

    public void setFloat(int i, float f)
            throws CONException {
        setObject(i, new Float(f));
    }

    public void setInt(int i, int j)
            throws CONException {
        setObject(i, new Integer(j));
    }

    public void setInteger(int i, Integer integer)
            throws CONException {
        setObject(i, integer);
    }

    public void setLong(int i, long longVal)
            throws CONException {
        setObject(i, new Long(longVal));
    }

    public void setLong(int i, Long longVal)
            throws CONException {
        setObject(i, longVal);
    }

    public void setDouble(int i, double doubleVal)
            throws CONException {
        setObject(i, new Double(doubleVal));
    }

    public void setDouble(int i, Double doubleVal)
            throws CONException {
        setObject(i, doubleVal);
    }

    protected void setObject(int i, Object obj)
            throws CONException {
        if (isIdentity(checkFieldIndex(i))) { //  || getFieldType(i) == 4
            throw new CONException(this, CONException.FIXED_COLUMN);
        } else {
            fieldValues.set(i, obj);
            recordModified = true;
            return;
        }
    }

    public void setString(int i, String s)
            throws CONException {
        setObject(i, s);
    }

    protected static String toSQL(Object obj, int i) {
        if (obj != null) {
            String s = obj.toString();
            switch (i) {
                case 3: // '\003'
                    s = (new Date(((java.util.Date) obj).getTime())).toString();
                    if (s.toUpperCase().equals("CURRENT_TIME")) {
                        s = "SYSDATE";
                    } else {
                        s = "TO_DATE('" + s + "', 'YYYY-MM-DD')";
                    }
                    break;

                case 1: // '\001'
                    s = "'" + s + "'";
                    break;
            }
            return s;
        } else {
            return "NULL";
        }
    }

    public void update()
            throws CONException {
        if (!hasData) {
            throw new CONException(this, CONException.NOT_OPEN);
        }
        if (!recordModified) {
            return;
        }
        Connection connection = null;
        Statement statement = null;
        try {
            connection = getConnection();
            checkConcurrency(connection);
            statement = getStatement(connection);
            String queryUpdate = getUpdateSQL();            
            statement.executeUpdate(queryUpdate);            

            if (ACTIVATE_LOG) {
                try{
                    CONLogger.insertLogs(queryUpdate, tableName);
                }catch(Exception e){}                
            }

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }

    public String getCONTableName() {
        return tableName;
    }

    protected Vector execQuery(String sql, String classNm)
            throws CONException {
        getLog();
        Connection connection = null;
        Statement statement = null;
        Vector vector = null;
        Object obj = null;
        try {
            connection = getConnection();
            statement = getStatement(connection);
            ResultSet resultset = statement.executeQuery(sql);
            vector = new Vector();
            CONHandler CONhandler;
            fieldValues = new Vector();
            fieldValues.setSize(fieldNames.length);
            for (; resultset.next(); vector.add(CONhandler.initialize(resultset))) {
                try {
                    CONhandler = (CONHandler) Class.forName(pstName).newInstance();
                } catch (Exception exception1) {
                    exception1.printStackTrace(System.err);
                    resultset.close();
                    throw new CONException(null, CONException.INVALID_CLASS);
                }
            }
            resultset.close();
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
        return vector;
    }

    /**
     *      DENGEROUS....!!!
     *      Delete this fuction in next dev
     */
    public static ResultSet execQuery(String sql)
            throws CONException {
        getLog();
        Connection connection = null;
        Statement statement = null;

        try {
            connection = getConnection();
            statement = getStatement(connection);
            ResultSet resultset = statement.executeQuery(sql);
            return resultset;

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            throw new CONException(null, e);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }

    public static CONResultSet execQueryResult(String sql)
            throws CONException {
        getLog();
        Connection connection = null;
        Statement statement = null;

        try {
            connection = getConnection();
            statement = getStatement(connection);
            ResultSet resultset = statement.executeQuery(sql);
            return new CONResultSet(connPool, connection, statement, resultset);

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            throw new CONException(null, e);
        } finally {
            closeConnection(connection);
        }
    }

    public static int execSqlInsert(String sqlString)
            throws CONException {
        Connection connection = null;
        Statement statement = null;

        try {
            connection = getConnection();
            statement = getStatement(connection);

            int result = statement.executeUpdate(sqlString);
            CONHandler CONhandler = null;

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }

        return 0;
    }

    public static int execUpdate(String sql)
            throws CONException {
        Connection connection = null;
        Statement statement = null;
        int result = 0;
        try {
            connection = getConnection();
            statement = getStatement(connection);            
            result = statement.executeUpdate(sql);                                    
            
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }

        return result;
    }
    
     public static int execUpdateSQL(String sql)
            throws CONException {
        Connection connection = null;
        Statement statement = null;
        int result = 0;
        try {
            connection = getConnection();
            statement = getStatement(connection);            
            result = statement.executeUpdate(sql);                        
            CONHandler CONhandler = null;
            
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }

        return result;
    }       
    
    public static int execUpdateLogOnly(String sql)
            throws CONException {
        Connection connection = null;
        Statement statement = null;
        int result = 0;
        try {
            connection = getConnection();
            statement = getStatement(connection);            
            result = statement.executeUpdate(sql);                        
            CONHandler CONhandler = null;
            
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }

        return result;
    }

    public static int execUpdatePreparedStatement(PreparedStatement pstmt)
            throws CONException {

        try {
            int iRowCount = pstmt.executeUpdate();
            pstmt.close();
            return iRowCount;
        } catch (SQLException sqle) {
            sqle.printStackTrace(System.err);
            throw new CONException(null, sqle);
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
        return 0;
    }

    /**
     *      DENGEROUS....!!!
     *      Delete this fuction in next dev
     */
    public static PreparedStatement getPreparedStatement(String sql, Connection connection)
            throws CONException {
        try {
            PreparedStatement pstmt = null;
            pstmt = connection.prepareStatement(sql);
            return pstmt;
        } catch (SQLException sqle) {
            sqle.printStackTrace(System.err);
            throw new CONException(null, sqle);
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }

        return null;
    }

    /**
     *      DENGEROUS....!!!
     *      Delete this fuction in next dev
     */
    public static Connection getCONConnection() {
        try {
            return getConnection();
        } catch (Exception e) {
        }
        return null;
    }

    public static CONResultSet getPSTMTConnection(String sql)
            throws CONException {
        try {
            Connection connection = getConnection();
            PreparedStatement pstmt = null;
            pstmt = connection.prepareStatement(sql);
            return new CONResultSet(connPool, connection, pstmt, null);

        } catch (SQLException sqle) {
            sqle.printStackTrace(System.err);
            throw new CONException(null, sqle);
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
        return null;
    }

    // convert java.sql.Date to java.util.Date
    public static java.util.Date convertDate(java.sql.Date date, java.sql.Time time) {
        java.util.Date dt = new java.util.Date();
        if (date != null && time != null) {
            dt = new java.util.Date(date.getYear(), date.getMonth(), date.getDate(),
                    time.getHours(), time.getMinutes(), time.getSeconds());
        }
        return dt;
    }
    /**
     * modified by gedhy
     */
    public static final int SORT_TYPE_ASCENDING = 0;
    public static final int SORT_TYPE_DESCENDING = 1;

    public static String getOrderByType(int orderType) {
        String result = "";
        switch (CONSVR_TYPE) {
            case CONSVR_MYSQL:
                result = orderType == SORT_TYPE_ASCENDING ? " ASC" : " DESC";
                break;
            case CONSVR_POSTGRESQL:
                result = orderType == SORT_TYPE_ASCENDING ? " ASC" : " DESC";
                break;
            case CONSVR_SYBASE:
                result = orderType == SORT_TYPE_ASCENDING ? " ASC" : " DESC";
                break;
            case CONSVR_ORACLE:
                result = orderType == SORT_TYPE_ASCENDING ? " ASC" : " DESC";
                break;
            case CONSVR_MSSQL:
                result = orderType == SORT_TYPE_ASCENDING ? " ASC" : " DESC";
                break;
        }
        return result;
    }

    public static boolean isSystemLicenseActive() {
        java.util.Date dt = JSPFormater.formatDate(SYSTEM_DATE_LIMIT, "yyyy-MM-dd");
        java.util.Date currDate = new java.util.Date();
        currDate.setHours(0);
        currDate.setMinutes(0);
        currDate.setSeconds(0);
        if (currDate.before(dt)) {
            return true;
        }

        return false;
    }
} // end of CONHandler

