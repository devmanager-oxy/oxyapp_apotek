/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.ar;

/**
 *
 * @author Roy Andika
 */
public class AgingCustomer {
    
    private long customerId = 0;
    private String code = "";
    private String name = "";

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
