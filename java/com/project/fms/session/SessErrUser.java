/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

/**
 *
 * @author Roy Andika
 */
public class SessErrUser {

    private boolean userId = true;
    private boolean employee = true;
    private boolean group = true;

    public boolean isUserId() {
        return userId;
    }

    public void setUserId(boolean userId) {
        this.userId = userId;
    }

    public boolean isEmployee() {
        return employee;
    }

    public void setEmployee(boolean employee) {
        this.employee = employee;
    }

    public boolean isGroup() {
        return group;
    }

    public void setGroup(boolean group) {
        this.group = group;
    }
}
