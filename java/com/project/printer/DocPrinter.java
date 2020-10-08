/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.printer;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gadnyana
 */
public class DocPrinter extends Entity {

    private long docId = 0;
    private String docCode = "";
    private String hostPrinter = "";
    private Date timePrinter = new Date();   
    private long userId = 0;

    public Date getTimePrinter() {
        return timePrinter;
    }

    public void setTimePrinter(Date timePrinter) {
        this.timePrinter = timePrinter;
    }

    public String getHostPrinter() {
        return hostPrinter;
    }

    public void setHostPrinter(String hostPrinter) {
        this.hostPrinter = hostPrinter;
    }

    public String getDocCode() {
        return docCode;
    }

    public void setDocCode(String docCode) {
        this.docCode = docCode;
    }

    public long getDocId() {
        return docId;
    }

    public void setDocId(long docId) {
        this.docId = docId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
