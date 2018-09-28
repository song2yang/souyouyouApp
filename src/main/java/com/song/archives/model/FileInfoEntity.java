package com.song.archives.model;

import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "file_info", schema = "", catalog = "")

public class FileInfoEntity implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;
    private String fileCode;
    private String fileName;
    private String originalFileName;
    private String filePath;
    private Long fileSize;
    private String fileType;
    private Integer status;
    private String creator;
    @CreatedDate
    private String createTime;
    private String remark;
    private String zrr;
    private Integer classificlevelId;
    /**
     * 1 项目文件
     * 2 案例库文件
     * 3 资料库文件
     * 4 专家库文件
     */
    private Integer fileClassify;
    private Integer audit;


    public Integer getAudit() {
        return audit;
    }

    public void setAudit(Integer audit) {
        this.audit = audit;
    }

    public Integer getFileClassify() {
        return fileClassify;
    }

    public void setFileClassify(Integer fileClassify) {
        this.fileClassify = fileClassify;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFileCode() {
        return fileCode;
    }

    public void setFileCode(String fileCode) {
        this.fileCode = fileCode;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOriginalFileName() {
        return originalFileName;
    }

    public void setOriginalFileName(String originalFileName) {
        this.originalFileName = originalFileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getZrr() {
        return zrr;
    }

    public void setZrr(String zrr) {
        this.zrr = zrr;
    }

    public Integer getClassificlevelId() {
        return classificlevelId;
    }

    public void setClassificlevelId(Integer classificlevelId) {
        this.classificlevelId = classificlevelId;
    }
}
