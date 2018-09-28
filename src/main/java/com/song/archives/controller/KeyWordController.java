package com.song.archives.controller;

import com.song.archives.dao.KeyWordRepository;
import com.song.archives.model.KeywordInfoEntity;
import com.song.archives.model.User;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.criteria.*;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;


/**
 * Created by ghl on 2018/4/20.
 */
@Controller
@RequestMapping("/")
public class KeyWordController {

    Logger logger = Logger.getLogger(UserController.class);

    @Autowired
    private KeyWordRepository keyWordRepository;

    private String msg = "error";
    private String operationLogInfo = "";

    private JSONObject result = new JSONObject();

    @RequestMapping(value = "KeywordList")
    public String KeywordList(){

        return "keyword/KeywordList";
    }
    @RequestMapping(value = "SaveKeyWord")
    @ResponseBody
    public String SaveKeyWord(@RequestParam(value = "tid") Integer tid,
                              @RequestParam(value = "mid") Integer mid,
                              @RequestParam(value = "keywords") String keywords,
                              @RequestParam(value = "isprivate") Integer isprivate) {

        result = new JSONObject();
        HashMap<Integer, String> map = new HashMap<>();
        map.put(1, "项目");
        map.put(2, "资料");
        map.put(3, "案例");
        map.put(4, "专家");
        map.put(5, "公告");
        KeywordInfoEntity keywordInfoEntity = new KeywordInfoEntity();
        keywordInfoEntity.setCreateTime(new Timestamp(new Date().getTime()));
        keywordInfoEntity.setEntityId(tid);
        keywordInfoEntity.setKeywordValue(keywords);
        keywordInfoEntity.setUserId(Integer.parseInt(getUser().getId().toString()));
        keywordInfoEntity.setUserName(getUser().getUsername());
        keywordInfoEntity.setIsPrivate(isprivate);

        //1:项目，2：资料，3：案例，4：专家，5：公告
        keywordInfoEntity.setModules(mid);
        //JSONObject resutObj = new JSONObject();
        try {
            keyWordRepository.save(keywordInfoEntity);
            result.put("msg", "ok");
            operationLogInfo = "用户【" + getUser().getUsername() + "】对" + map.get(mid) + "进行添加标签[" + keywords + "]成功";

        } catch (Exception ex) {
            logger.error(ex.getMessage());
            result.put("msg", "failed");
            operationLogInfo = "用户【" + getUser().getUsername() + "】对" + map.get(mid) + "进行添加标签[" + keywords + "]失败";
        }

        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "LoadKeyWord")
    @ResponseBody
    public String LoadKeyWord(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                              @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                              @RequestParam(value = "isprivate") Integer isprivate) {
        result = new JSONObject();

        Sort sort = new Sort(Sort.Direction.ASC, "id");
        currentpage = currentpage - 1;
        Pageable pageable = new PageRequest(currentpage, size, sort);
        Page keywordInfoEntityPage = null;
        try {
            if (isprivate != 1) {
                keywordInfoEntityPage = keyWordRepository.findAll(pageable);
            } else {

                Specification<KeywordInfoEntity> specification = new Specification<KeywordInfoEntity>() {
                    @Override
                    public Predicate toPredicate(Root<KeywordInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {

                        Path<Integer> isPrivate = root.get("isPrivate");

                        return criteriaBuilder.equal(isPrivate, 1);
                    }
                };

                keywordInfoEntityPage = keyWordRepository.findAll(specification, pageable);
            }

            JsonConfig jsonConfig = new JsonConfig();

            jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

            JSONArray keywordJson = JSONArray.fromObject(keywordInfoEntityPage, jsonConfig);

            result.put("msg", "ok");
            result.put("result", keywordJson);

        } catch (Exception ex) {
            logger.error(ex.getMessage());
            result.put("msg", "failed");
        }
        return result.toString();
    }

    @RequestMapping(value = "DeleteKeyWordByIds")
    @ResponseBody
    public String DeleteKeyWordByIds(@RequestParam(value="kids") Long[] kids) {
        result = new JSONObject();

        try {

            for (int i = 0; i < kids.length; i++) {
                keyWordRepository.delete(kids[i]);
            }
            result.put("msg", "ok");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            result.put("msg", "failed");
        }

        return result.toString();
    }
    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}
