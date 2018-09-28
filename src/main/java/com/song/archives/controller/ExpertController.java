package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.AnliRepository;
import com.song.archives.dao.ExpertRepository;
import com.song.archives.dao.ModuleFileRespository;
import com.song.archives.model.*;
import com.song.archives.utils.ExcelUtil;
import com.song.archives.utils.WebUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import sun.misc.BASE64Encoder;

import javax.persistence.criteria.Predicate;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Created by souyouyou on 2018/3/12.
 */

@Controller
@RequestMapping("/")
public class ExpertController {

    Logger logger = Logger.getLogger(AnliController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result;

    @Autowired
    private ExpertRepository expertRepository;

    @Autowired
    private ModuleFileRespository moduleFileRespository;

    /**
     * 删除专家
     *
     * @param ids
     * @return
     */
    @ArchivesLog(operationType = "delExpert", operationName = "删除专家")
    @RequestMapping(value = "/delExpert")
    @ResponseBody
    String delExpert(Long[] ids) {
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除专家【";

        try {

            if (null != ids && ids.length > 0) {
                for (Long id : ids) {
                    ExpertInfoEntity entity = expertRepository.findOne(id);
                    operationLogInfo += entity.getName() + ",";
                    expertRepository.delete(entity);

                }
            }
            msg = SUCCESS;

        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "delete expert failed";

        }


        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }


    @ArchivesLog(operationType = "createExpert", operationName = "创建专家信息")
    @RequestMapping(value = "/createExpert")
    @ResponseBody
    public String createExpert(@RequestParam(value = "pic", required = false) MultipartFile file,
                               @RequestParam(value = "id", required = false) Long id,
                               HttpServletRequest request) {
        ExpertInfoEntity infoEntity = new ExpertInfoEntity();

        result = new JSONObject();


        try {
            ExpertInfoEntity expertInfoEntity;
            expertInfoEntity = WebUtils.request2Bean(request, infoEntity.getClass());

            if (null == id) {
                expertInfoEntity.setCreateTime(new Timestamp(System.currentTimeMillis()));

            } else {
                infoEntity = expertRepository.findOne(id);
                expertInfoEntity.setPic(infoEntity.getPic());
                expertInfoEntity.setId(id);
            }


            if (null != file && !file.isEmpty()) {
                String encode = new BASE64Encoder().encode(file.getBytes());
                expertInfoEntity.setPic("data:image/jpeg;base64," + encode);
            }

            expertRepository.save(expertInfoEntity);

            msg = SUCCESS;
        } catch (IOException e) {
            e.printStackTrace();
            logger.error("创建专家信息:" + e.getMessage());
            msg = "IOException";
        }

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行创建专家信息操作";
        result.put("operationLog", operationLogInfo);
        result.put("msg", msg);


        return result.toString();

    }

    @ArchivesLog(operationType = "importExpert", operationName = "新建专家页面")
    @RequestMapping(value = "/importExpert")
    @ResponseBody
    public String importExpert(@RequestParam(value = "dataFile") MultipartFile file) throws IOException, InvalidFormatException {

        result = new JSONObject();

        try {
            List<String[]> experts = ExcelUtil.excel2List(file);

            if (null == experts || experts.isEmpty()){
                msg = "文件不能为空";
                result.put("msg",msg);
                return result.toString();
            }

            for (String[] expertData:experts){
                ExpertInfoEntity expert = new ExpertInfoEntity();
                expert.setName(expertData[1]);
                expert.setGender(expertData[2]);
                expert.setBirth(expertData[3]);
                expert.setAddress(expertData[4]);
                expert.setZhicheng(expertData[5]);
                expert.setSxzhuanye(expertData[6]);
                expert.setMobile(expertData[7]);
                expert.setPhone(expertData[8]);
                expert.setFaxcode(expertData[9]);
                expert.setRemark(expertData[10]);

                expertRepository.save(expert);
            }

            msg = SUCCESS;

        } catch (Exception e) {
            msg = "Exception";
            e.printStackTrace();
        }
        result.put("msg", msg);

        return result.toString();
    }




    /**
     * 新建专家页面
     *
     * @return
     */
    @ArchivesLog(operationType = "expert", operationName = "新建专家页面")
    @RequestMapping(value = "/expert")
    public ModelAndView expert(@RequestParam(value = "eid", required = false) Long eid) {

        ExpertInfoEntity expertInfoEntity;

        if (null == eid) {
            expertInfoEntity = new ExpertInfoEntity();
        } else {
            expertInfoEntity = expertRepository.findOne(eid);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("expert/createExpert");
        modelAndView.addObject("expert", expertInfoEntity);
        modelAndView.addObject("proentity", expertInfoEntity);
        modelAndView.addObject("mid", 4);
        return modelAndView;
    }

    /**
     * 查询专家列表
     *
     * @param page
     * @param size
     * @param typeId
     * @return
     */
    @ArchivesLog(operationType = "experts", operationName = "查询专家列表")
    @RequestMapping(value = "/experts")
    @ResponseBody
    String experts(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                   @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                   @RequestParam(value = "searchValue", required = false) String searchValue,
                   @RequestParam(value = "typeId", required = false) Long typeId,
                   @RequestParam(value = "sortOrder", required = false, defaultValue = "asc") String sortOrder,
                   @RequestParam(value = "sortName", required = false, defaultValue = "id") String sortName) {


        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(sortOrder.equals("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortName);
        Pageable pageable = new PageRequest(page, size, sort);


        Specification<ExpertInfoEntity> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            if (null == typeId && StringUtils.isEmpty(searchValue)) {
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }

            List<Predicate> predicatesWhereArr = new ArrayList<>();

            if (null != typeId) {
                predicatesWhereArr.add(criteriaBuilder.equal(root.get("typeId"), typeId));
            }

            Predicate whereEquals = criteriaBuilder.or(predicatesWhereArr.toArray(new Predicate[predicatesWhereArr.size()]));


            if (StringUtils.isNotEmpty(searchValue)) {
                predicates.add(criteriaBuilder.like(root.get("name"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("sxzhuanye"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("cszhuanye"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("zhiwu"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("profile"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("szdanwei"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("szbumen"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("sslingyu"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("address"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("faxcode"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("email"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("zjpingjia"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("phone"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("mobile"), "%" + searchValue + "%"));
            }

            Predicate whereLike = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));

            List<Predicate> predicateArr = new ArrayList<>();
            if (predicatesWhereArr.size() > 0) {
                predicateArr.add(whereEquals);
            }
            if (predicates.size() > 0) {
                predicateArr.add(whereLike);
            }


            return criteriaQuery.where(predicateArr.toArray(new Predicate[predicateArr.size()])).getRestriction();
        };

        Page<ExpertInfoEntity> datas = null;
        try {
            datas = expertRepository.findAll(specification, pageable);
            msg = SUCCESS;
        } catch (Exception e) {
            logger.error("专家列表数据:" + e.getMessage());
            msg = "Exception";
        }


        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询专家列表操作";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(datas));
        return result.toString();
    }

    /**
     * 专家列表
     *
     * @return
     */
    @ArchivesLog(operationType = "expertList", operationName = "专家列表")
    @RequestMapping(value = "/expertList")
    ModelAndView expertList(@RequestParam(value = "typeId", required = false) Integer typeId) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("expert/list");
        ZiliaoInfoEntity ziliaoInfoEntity = new ZiliaoInfoEntity();
        ziliaoInfoEntity.setTypeId(typeId);
        modelAndView.addObject(ziliaoInfoEntity);

        return modelAndView;
    }

    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}
