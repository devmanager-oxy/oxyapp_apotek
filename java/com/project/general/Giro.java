/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.entity.Entity;

/**
 *
 * @author Roy Andika
 */
public class Giro extends Entity {

    private String name = "";
    private long coaId = 0;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }
    
}
