package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.AnliRepository;
import com.song.archives.dao.FileInfoRepository;
import com.song.archives.dao.ModuleFileRespository;
import com.song.archives.dao.NotifyRepository;
import com.song.archives.model.*;
import com.song.archives.utils.DateUtil;
import com.song.archives.utils.ImageUploadUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.*;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;
import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/")
public class ReviewController {

    Logger logger = Logger.getLogger(ReviewController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result;

    @Autowired
    private FileInfoRepository fileInfoRepository;

    @Autowired
    private NotifyRepository notifyRepository;



    @ArchivesLog(operationType = "auditFileById", operationName = "审核文件")
    @RequestMapping(value = "/auditFileById")
    @ResponseBody
    String auditFile(@RequestParam(value = "fileId") Long fileId,
                     @RequestParam(value = "result") Integer auditResult,
                     @RequestParam(value = "fileClassify") Integer fileClassify,
                     @RequestParam(value = "content",required = false) String content) {

        result = new JSONObject();
        operationLogInfo = "用户【" + getUser().getUsername() + "】审核文件【";

        try{
            FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(fileId);
            fileInfoEntity.setAudit(auditResult);

            if (null == content || content.equals("")){
                content = "审核通过";
            }

            NotifyEntity notify = new NotifyEntity();
            notify.setContent(content);
            notify.setOperateTime(DateUtil.parseDateToStr(new Date(),DateUtil.DATE_TIME_FORMAT_YYYYMMDD_HH_MI));
            notify.setApprover(getUser().getRealName());
            notify.setPersonal(fileInfoEntity.getCreator());
            notify.setFileClassify(fileClassify);
            notify.setFileId(fileId);
            notifyRepository.save(notify);

            fileInfoRepository.save(fileInfoEntity);
            msg = SUCCESS;

        }catch (Exception e){
            logger.error(e.getMessage());
            msg = "delete anli failed";

        }


        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }



    @ArchivesLog(operationType = "deleteById", operationName = "删除文件")
    @RequestMapping(value = "/deleteById")
    @ResponseBody
    String deleteById(@RequestParam(value = "fileId") Long fileId) {

        result = new JSONObject();
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除文件【";
        FileInfoEntity fileInfoEntity = null;
        try{
            fileInfoEntity = fileInfoRepository.findOne(fileId);

            fileInfoRepository.delete(fileInfoEntity);
            msg = SUCCESS;

        }catch (Exception e){
            logger.error(e.getMessage());
            msg = "delete anli failed";

        }


        operationLogInfo = fileInfoEntity.getFileName() + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }


    /**
     * 文件列表
     *
     * @return
     */
    @ArchivesLog(operationType = "reviewList", operationName = "文件列表")
    @RequestMapping(value = "/reviewList/{fileClassify}")
    ModelAndView reviewList(@PathVariable Integer fileClassify) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("file/list");
        FileInfoEntity fileInfoEntity = new FileInfoEntity();
        fileInfoEntity.setFileClassify(fileClassify);
        modelAndView.addObject(fileInfoEntity);


        return modelAndView;
    }



    /**
     * 查询资料列表数据
     *
     * @param page
     * @param size
     * @param searchValue
     * @return
     */
    @ArchivesLog(operationType = "files", operationName = "查询文件列表")
    @RequestMapping(value = "/files")
    @ResponseBody
    String files(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                 @RequestParam(value = "searchValue", required = false) String searchValue,
                 @RequestParam(value = "fileClassify", required = false) Long fileClassify,
                 @RequestParam(value = "sortOrder", required = false, defaultValue = "asc") String sortOrder,
                 @RequestParam(value = "sortName", required = false, defaultValue = "id") String sortName) {


        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(sortOrder.equals("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortName);
        Pageable pageable = new PageRequest(page, size, sort);


        Specification<FileInfoEntity> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            predicates.add(criteriaBuilder.equal(root.get("fileClassify"),fileClassify));
            predicates.add(criteriaBuilder.notEqual(root.get("audit"),1));
            predicates.add(criteriaBuilder.like(root.get("fileName"),"%"+searchValue+"%"));

            return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
        };

        List<FileInfoEntity> datas = null;
        try {
            datas = fileInfoRepository.findAll(specification, pageable);
            msg = SUCCESS;
        } catch (Exception e) {
            logger.error("案例列表数据:" + e.getMessage());
            msg = "Exception";
        }


        JsonConfig jsonConfig = new JsonConfig();

        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

        JSONArray json = JSONArray.fromObject(datas, jsonConfig);

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询文件列表操作";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        result.put("result", json);
        return result.toString();
    }



    @ArchivesLog(operationType = "downLoadFile", operationName = "下载文件")
    @RequestMapping(value = "/downLoadFile")
    public void getFile(@RequestParam(value = "fileId") Long fileId,
                        HttpServletResponse response) {

        FileInfoEntity infoEntity = fileInfoRepository.findOne(fileId);

        String fileType = infoEntity.getFileName().substring(infoEntity.getFileName().lastIndexOf(".") + 1).toLowerCase();

        try {
            FileInputStream inputStream = new FileInputStream(new File(infoEntity.getFilePath()));
            int length = inputStream.available();
            byte data[] = new byte[length];
            response.setContentLength(length);
            response.setContentType(ImageUploadUtil.imageContentType.get(fileType));
            inputStream.read(data);
            OutputStream out = response.getOutputStream();
            out.write(data);
            out.flush();
        } catch (FileNotFoundException e) {
            logger.error("获取文件:" + e.getMessage());
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }



    }

    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}
