package com.song.archives.model;

import org.hibernate.annotations.LazyToOne;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by souyouyou on 2018/2/3.
 */
@Entity
public class OperationLog implements Serializable{

    @Id
    @GeneratedValue
    private Long id;
    private String operationType;
    private String operationName;
    private Long operationUserId;
    private String operationUserName;
    private String operationStartTime;
    private String operationEndTime;
    @Lob
    private String operationInput;
    @Lob
    private String operationOutPut;
    @Lob
    private String operationDescrib;
    private String operationIp;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getOperationName() {
        return operationName;
    }

    public void setOperationName(String operationName) {
        this.operationName = operationName;
    }

    public Long getOperationUserId() {
        return operationUserId;
    }

    public void setOperationUserId(Long operationUserId) {
        this.operationUserId = operationUserId;
    }

    public String getOperationUserName() {
        return operationUserName;
    }

    public void setOperationUserName(String operationUserName) {
        this.operationUserName = operationUserName;
    }

    public String getOperationStartTime() {
        return operationStartTime;
    }

    public void setOperationStartTime(String operationStartTime) {
        this.operationStartTime = operationStartTime;
    }

    public String getOperationEndTime() {
        return operationEndTime;
    }

    public void setOperationEndTime(String operationEndTime) {
        this.operationEndTime = operationEndTime;
    }

    public String getOperationInput() {
        return operationInput;
    }

    public void setOperationInput(String operationInput) {
        this.operationInput = operationInput;
    }

    public String getOperationOutPut() {
        return operationOutPut;
    }

    public void setOperationOutPut(String operationOutPut) {
        this.operationOutPut = operationOutPut;
    }

    public String getOperationIp() {
        return operationIp;
    }

    public void setOperationIp(String operationIp) {
        this.operationIp = operationIp;
    }

    public String getOperationDescrib() {
        return operationDescrib;
    }

    public void setOperationDescrib(String operationDescrib) {
        this.operationDescrib = operationDescrib;
    }
}
