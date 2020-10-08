package com.project.main.db;

public interface I_CONType {

    public static final int TYPE_INT        = 0;
    public static final int TYPE_STRING     = 1;
    public static final int TYPE_FLOAT      = 2;
    public static final int TYPE_DATE       = 3;
    public static final int TYPE_TIMESTAMP  = 4;
    public static final int TYPE_BOOL       = 5;
    public static final int TYPE_BLOB       = 6;
    public static final int TYPE_LONG       = 7;
    public static final int TYPE_FLOAT3     = 8;
    
    public static final int TYPE_ID         = 256;
    public static final int TYPE_PK         = 512;
    public static final int TYPE_FK         = 1024;
    public static final int TYPE_AI         = 2048; // auto increment

}