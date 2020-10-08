package com.project.admin;

import com.project.system.DbSystemProperty;
import com.project.util.blob.ImageLoader;
import com.project.util.jsp.JSPMessage;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

public class QrPictureSave {

    public static final String IMG_EXTENSIONS = ".jpg";
    public static final String JSP_IMAGE = "JSP_IMAGE";
    public static final String IMG_SUB_PATH = "users";
    private static String IMG_PATH = DbSystemProperty.getValueByName("IMG_PATH");
    private static String IMG_PATH_USER = DbSystemProperty.getValueByName("IMG_PATH_USER");
    private static final String FILE_SEPARATOR = System.getProperty("file.separator");

    public QrPictureSave() {
    }

    public static int updateImage(Object obj, long oid, int idx) {
        try {
            if (obj == null) {
                return -1;
            }
            byte b[] = null;
            b = (byte[]) obj;

            ByteArrayInputStream ins;
            ins = new ByteArrayInputStream(b);

            int i = ImageLoader.writeCache((InputStream) ins, IMG_PATH + oid + "_" + idx, true);

        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return 0;
    }

    public static int updateImage(Object obj, String imageName) {
        try {
            if (obj == null) {
                return -1;
            }
            byte b[] = null;
            b = (byte[]) obj;

            ByteArrayInputStream ins;
            ins = new ByteArrayInputStream(b);

            int i = deleteImage(imageName);
            i = ImageLoader.writeCache((InputStream) ins, IMG_PATH + IMG_SUB_PATH + FILE_SEPARATOR + imageName + IMG_EXTENSIONS, true);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return 0;
    }
    
    public static int updateImageUser(Object obj, String imageName) {
        try {
            if (obj == null) {
                return -1;
            }
            byte b[] = null;
            b = (byte[]) obj;

            ByteArrayInputStream ins;
            ins = new ByteArrayInputStream(b);

            int i = deleteImageUser(imageName);
            i = ImageLoader.writeCache((InputStream) ins, IMG_PATH_USER + FILE_SEPARATOR + imageName + IMG_EXTENSIONS, true);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return 0;
    }
    
    
    public static int deleteImageUser(long oid, int idx) {
        try {
            ImageLoader.deleteChace(IMG_PATH_USER + oid + "_" + idx);

            return JSPMessage.MSG_DELETED;

        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;

    }

    public static int deleteImage(long oid, int idx) {
        try {
            ImageLoader.deleteChace(IMG_PATH + oid + "_" + idx);

            return JSPMessage.MSG_DELETED;

        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;

    }

    public static int deleteImage(String imageName) {
        try {
            ImageLoader.deleteChace(IMG_PATH + IMG_SUB_PATH + FILE_SEPARATOR + imageName + IMG_EXTENSIONS);
            return JSPMessage.MSG_DELETED;
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }
    
    public static int deleteImageUser(String imageName) {
        try {
            ImageLoader.deleteChace(IMG_PATH_USER + IMG_SUB_PATH + FILE_SEPARATOR + imageName + IMG_EXTENSIONS);
            return JSPMessage.MSG_DELETED;
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }
}
