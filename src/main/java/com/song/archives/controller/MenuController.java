package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.*;
import com.song.archives.model.MenuTypeEntity;
import com.song.archives.model.NotifyEntity;
import com.song.archives.model.User;
import com.song.archives.utils.ImageUploadUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
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

import javax.persistence.criteria.Predicate;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by souyouyou on 2018/2/28.
 */

@Controller
@RequestMapping("/")
public class MenuController {

    Logger logger = Logger.getLogger(MenuController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result = new JSONObject();


    @Autowired
    private MenuRepository menuRepository;

    @ArchivesLog(operationType = "findMenuById",operationName = "获取菜单")
    @RequestMapping(value = "/findMenuById")
    @ResponseBody
    String findMenuById(@RequestParam(value = "mid") Long mid){

        MenuTypeEntity menu = menuRepository.findOne(mid);

        return JSONObject.fromObject(menu).toString();
    }

    @ArchivesLog(operationType = "findMenuByTypeAndParentId",operationName = "获取菜单")
    @RequestMapping(value = "/findMenuByTypeAndParentId")
    @ResponseBody
    String findMenuByTypeAndParentId(@RequestParam(value = "type") Integer type,
                                     @RequestParam(value = "parentId") Integer parentId){

        List<MenuTypeEntity> menus = null;

        try{
            menus = menuRepository.findAllByTypeAndParentTypeid(type, parentId);
            msg = SUCCESS;
        }catch (Exception e){
            logger.error("查询菜单:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行获取菜单操作";
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        result.put("result", JSONArray.fromObject(menus));
        return result.toString();
    }

    /**
     * 菜单列表
     * @return
     */
    @ArchivesLog(operationType = "menuList",operationName = "菜单列表")
    @RequestMapping(value = "/menuList/{menuType}")
    ModelAndView menuList(@PathVariable Integer menuType){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("menu/menuList");
        String menuName = "菜单";
        switch (menuType){
            case 1:
                menuName = "案例菜单";
                break;
            case 2:
                menuName = "资料菜单";
                break;
            case 3:
                menuName = "专家菜单";
                break;
            case 4:
                menuName = "公告菜单";
                break;
        }

        modelAndView.addObject("menuName",menuName);
        modelAndView.addObject("menuType",menuType);

        return modelAndView;
    }

    /**
     * 查询菜单
     * @param page
     * @param size
     * @return
     */
    @ArchivesLog(operationType = "menus",operationName = "查询菜单")
    @RequestMapping(value = "/menus")
    @ResponseBody
    String menus(@RequestParam(value = "pageIndex", defaultValue = "1") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                 @RequestParam(value = "menuType", defaultValue = "1") Integer menuType
                 ){
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);
        Page<MenuTypeEntity> menus = null;
        try{

            Specification<MenuTypeEntity> specification = (root, criteriaQuery, criteriaBuilder) -> {

                List<Predicate> predicates = new ArrayList<>();

                predicates.add(criteriaBuilder.equal(root.get("type"),menuType));

                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            };

            menus = menuRepository.findAll(specification,pageable);
            msg = SUCCESS;
        }catch (Exception e){
            logger.error("查询菜单:"+e.getMessage());
            msg = "Exception";
        }


        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询菜单操作";
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        result.put("result", JSONArray.fromObject(menus));
        return result.toString();
    }

    /**
     * 查询菜单无分页
     * @return
     */
    @ArchivesLog(operationType = "menusNoPage",operationName = "查询菜单")
    @RequestMapping(value = "/menusNoPage")
    @ResponseBody
    String menusNoPage(@RequestParam(value = "menuType")Integer menuType){

        List<MenuTypeEntity> menus =
                menuRepository.findAllByType(menuType);

        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        result.put("result", JSONArray.fromObject(menus));
        return result.toString();
    }

    /**
     * 保存菜单
     * @param entity
     * @return
     */
    @ArchivesLog(operationType = "saveMenu",operationName = "保存菜单")
    @RequestMapping(value = "/saveMenu")
    @ResponseBody
    String saveMenu(MenuTypeEntity entity){

        try{
            menuRepository.save(entity);
            msg = SUCCESS;
        }catch (Exception e){
            msg = "save AnliTypeMenu failed";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】新建:"+entity.toString();
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }

    /**
     * 删除菜单
     * @param id
     * @return
     */
    @ArchivesLog(operationType = "deleteMenu",operationName = "删除菜单")
    @RequestMapping(value = "/deleteMenu")
    @ResponseBody
    String deleteMenu(Long id){
        MenuTypeEntity menu = menuRepository.findOne(id);
        try {

            List<MenuTypeEntity> childrenMenu = menuRepository.findAllByParentTypeid(id.intValue());

            for (MenuTypeEntity child:childrenMenu){
                menuRepository.delete(child);
            }
            menuRepository.delete(menu);
            msg = SUCCESS;
        }catch (Exception e){
            logger.error("删除菜单:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】删除菜单:"+menu.getTypeName()+",操作结果【"+msg+"】";
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }

    /**
     * 查询当前菜单子菜单列表
     * @param id
     * @return
     */
    @ArchivesLog(operationType = "findChildMenu",operationName = "查询子菜单")
    @RequestMapping(value = "/findChildMenu")
    @ResponseBody
    String findChildMenu(Integer id){

        String childrenNames = "";

        try {
            List<MenuTypeEntity> children = menuRepository.findAllByParentTypeid(id);

            if (null != children && children.size() >= 1){
                for (MenuTypeEntity entity:children) {
                    childrenNames += entity.getTypeName()+",";
                }

                childrenNames = childrenNames.substring(0,childrenNames.length()-1);
            }

            msg = SUCCESS;

        }catch (Exception e){
            logger.error("查询子菜单异常:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询子菜单操作"+",操作结果【"+msg+"】";

        result.put("childrenNames",childrenNames);
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }


    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private AnliRepository anliRepository;

    @Autowired
    private DataRepository dataRepository;

    @Autowired
    private AnnounceRepository announceRepository;

    @Autowired
    private NotifyRepository notifyRepository;


    @ArchivesLog(operationType = "getNotify", operationName = "获取用户通知信息")
    @RequestMapping(value = "/getNotify")
    @ResponseBody
    public String getNotify() {
        result = new JSONObject();
        List<NotifyEntity> notifyEntities = null;
        try {

            notifyEntities = notifyRepository.findByPersonal(getUser().getUsername());
            msg = SUCCESS;

        } catch (Exception e) {
            logger.error("上传编辑图片:" + e.getMessage());
            msg = "Exception";
        }
        operationLogInfo = "用户【"+getUser().getUsername()+"】执行上传编辑图片操作";
        result.put("operationLog",operationLogInfo);
        result.put("msg", msg);
        result.put("result", JSONArray.fromObject(notifyEntities));
        return result.toString();
    }


    @ArchivesLog(operationType = "main", operationName = "视图跳转")
    @RequestMapping(value = "main")
    public ModelAndView main() {
        ModelAndView mav = new ModelAndView();


        long projectCount = projectRepository.count();
        long anliCount = anliRepository.count();
        long dataCount = dataRepository.count();
        long announceCount = announceRepository.count();


        mav.addObject("projectCount",projectCount);
        mav.addObject("anliCount",anliCount);
        mav.addObject("dataCount",dataCount);
        mav.addObject("announceCount",announceCount);
        mav.setViewName("main");

        return mav;
    }




    protected User getUser(){
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }



}
