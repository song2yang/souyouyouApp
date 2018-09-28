package com.song.archives.controller;


import com.song.archives.dao.*;
import com.song.archives.model.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.criteria.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.*;


@Controller
@RequestMapping("/")
public class SearchCenterController {


    Logger logger = Logger.getLogger(SearchCenterController.class);

    @Autowired
    private AnliRepository anliRepository;
    @Autowired
    private DataRepository dataRepository;
    @Autowired
    private ProjectRepository projectRepository;
    @Autowired
    private ExpertRepository expertRepository;
    @Autowired
    private AnnounceRepository announceRepository;
    @Autowired
    private KeyWordRepository keyWordRepository;

    @Value("${project.search.fields}")
    private String projectSearchFields;
    @Value("${anli.search.fields}")
    private String anliSearchFields;
    @Value("${ziliao.search.fields}")
    private String ziliaoSearchFields;
    @Value("${expert.search.fields}")
    private String expertSearchFields;
    @Value("${announce.search.fields}")
    private String announceSearchFields;
    @Value("${keyword.search.fields}")
    private String keywordSearchFields;

    //项目
    class ProjectResultCallable implements Callable<List<SearchResultEntity>> {

        private String targetWord;

        ProjectResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {

            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = projectSearchFields.split(",");
            User user = getUser();
            Specification<ProjectInfoEntity> specification = new Specification<ProjectInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));

                    if (user.getType() == 1) {

                        return predicateOne;

                    } else {

                        List<Predicate> predicates1 = new ArrayList<Predicate>();

                        Path<String> proLeaders = root.get("proLeaders");

                        Predicate predicate = criteriaBuilder.equal(proLeaders, user.getRealName());

                        predicates1.add(predicate);

                        Predicate predicate0 = criteriaBuilder.equal(root.get("creater"), user.getId().toString());

                        predicates1.add(predicate0);

                        Path<String> proJoiners = root.get("proJoiners");

                        Predicate predicate1 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName() + ",%");

                        predicates1.add(predicate1);

                        Predicate predicate2 = criteriaBuilder.like(proJoiners.as(String.class), user.getRealName() + ",%");
                        predicates1.add(predicate2);
                        Predicate predicate3 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName());
                        predicates1.add(predicate3);
                        Predicate predicateTwo = criteriaBuilder.or(predicates1.toArray(new Predicate[predicates1.size()]));

                        List<Predicate> predicatesFinall = new ArrayList<>();

                        predicatesFinall.add(predicateOne);
                        predicatesFinall.add(predicateTwo);

                        return criteriaBuilder.and(predicatesFinall.toArray(new Predicate[predicatesFinall.size()]));
                    }
                }
            };

            List<ProjectInfoEntity> projectInfoEntityList = projectRepository.findAll(specification);

            for (ProjectInfoEntity projectInfoEntity : projectInfoEntityList) {
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(projectInfoEntity.getId().toString());
                searchResultEntity.setResultName(projectInfoEntity.getProName());
                searchResultEntity.setResultType("project");
                searchResultEntityList.add(searchResultEntity);
            }
            return searchResultEntityList;
        }
    }

    //案例
    class AnliResultCallable implements Callable<List<SearchResultEntity>> {

        private String targetWord;

        AnliResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {
            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = anliSearchFields.split(",");
            Specification<AnliInfoEntity> specification = new Specification<AnliInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<AnliInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                    return predicateOne;
                }
            };

            List<AnliInfoEntity> anliInfoEntityList = anliRepository.findAll(specification);

            for (AnliInfoEntity anliInfoEntity : anliInfoEntityList) {
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(anliInfoEntity.getId().toString());
                searchResultEntity.setResultName(anliInfoEntity.getTitle());
                searchResultEntity.setResultType("anli");
                searchResultEntityList.add(searchResultEntity);
            }
            return searchResultEntityList;
        }
    }

    //资料
    class ZiliaoResultCallable implements Callable<List<SearchResultEntity>> {

        private String targetWord;

        ZiliaoResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {

            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = ziliaoSearchFields.split(",");
            Specification<ZiliaoInfoEntity> specification = new Specification<ZiliaoInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ZiliaoInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                    return predicateOne;
                }
            };

            List<ZiliaoInfoEntity> ziliaoInfoEntityList = dataRepository.findAll(specification);

            for (ZiliaoInfoEntity ziliaoInfoEntity : ziliaoInfoEntityList) {
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(ziliaoInfoEntity.getId().toString());
                searchResultEntity.setResultName(ziliaoInfoEntity.getTitle());
                searchResultEntity.setResultType("ziliao");
                searchResultEntityList.add(searchResultEntity);
            }
            return searchResultEntityList;
        }
    }

    //专家
    class ExpertResultCallable implements Callable<List<SearchResultEntity>>{

        private String targetWord;

        ExpertResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {

            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = expertSearchFields.split(",");
            Specification<ExpertInfoEntity> specification = new Specification<ExpertInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ExpertInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                    return predicateOne;
                }
            };

            List<ExpertInfoEntity> expertInfoEntityList = expertRepository.findAll(specification);

            for (ExpertInfoEntity expertInfoEntity : expertInfoEntityList) {
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(expertInfoEntity.getId().toString());
                searchResultEntity.setResultName(expertInfoEntity.getName());
                searchResultEntity.setResultType("expert");
                searchResultEntityList.add(searchResultEntity);
            }
            return searchResultEntityList;
        }
    }

    //公告
    class AnnounceResultCallable implements Callable<List<SearchResultEntity>>{
        private String targetWord;

        AnnounceResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {
            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = announceSearchFields.split(",");
            Specification<AnnounceInfoEntity> specification = new Specification<AnnounceInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<AnnounceInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                    return predicateOne;
                }
            };

            List<AnnounceInfoEntity> announceInfoEntityList = announceRepository.findAll(specification);

            for (AnnounceInfoEntity announceInfoEntity : announceInfoEntityList) {
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(announceInfoEntity.getId().toString());
                searchResultEntity.setResultName(announceInfoEntity.getTitle());
                searchResultEntity.setResultType("announce");
                searchResultEntityList.add(searchResultEntity);
            }
            return searchResultEntityList;
        }
    }

    //标签
    class KeyWordResultCallable implements Callable<List<SearchResultEntity>> {

        private String targetWord;

        KeyWordResultCallable(String tword) {
            this.targetWord = tword;
        }

        @Override
        public List<SearchResultEntity> call() throws Exception {

            HashMap<Integer, String> map = new HashMap<>();
            map.put(1, "project");
            map.put(2, "ziliao");
            map.put(3, "anli");
            map.put(4, "expert");
            map.put(5, "announce");

            List<SearchResultEntity> searchResultEntityList = new ArrayList<>();
            String[] fields = keywordSearchFields.split(",");
            Specification<KeywordInfoEntity> specification = new Specification<KeywordInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<KeywordInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();

                    for (int i = 0; i < fields.length; i++) {

                        Path<String> path = root.get(fields[i]);

                        Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + targetWord + "%");

                        predicates.add(predicateInner);
                    }

                    Predicate predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                    return predicateOne;
                }
            };

            List<KeywordInfoEntity> keywordInfoEntityList = keyWordRepository.findAll(specification);

            for (KeywordInfoEntity keywordInfoEntity : keywordInfoEntityList) {
                if (keywordInfoEntity.getModules() == 1) {

                    ProjectInfoEntity projectInfoEntity = projectRepository.findOne((long) keywordInfoEntity.getEntityId());
                    if ((long) projectInfoEntity.getCreater() == getUser().getId() || projectInfoEntity.getProLeaders().equals(getUser().getRealName()) || projectInfoEntity.getProJoiners().contains(getUser().getRealName())||getUser().getType()==1) {

                    } else {
                        continue;
                    }
                }
                SearchResultEntity searchResultEntity = new SearchResultEntity();
                searchResultEntity.setResultKey(keywordInfoEntity.getEntityId().toString());
                searchResultEntity.setResultName(keywordInfoEntity.getKeywordValue());
                searchResultEntity.setResultType("keyword");
                searchResultEntity.setMiniResultType(map.get(keywordInfoEntity.getModules()));
                searchResultEntityList.add(searchResultEntity);

            }
            return searchResultEntityList;
        }
    }


    private JSONObject result = new JSONObject();

    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }

    @RequestMapping(value = "StartSearch")
    @ResponseBody
    public String StartSearch(@RequestParam(value = "target") String target) throws ExecutionException, InterruptedException {

        result = new JSONObject();
        if(target.equals("")){
            return result.toString();
        }
        List<SearchResultEntity> finalEntityList = new ArrayList<>();

        ExecutorService executorService = Executors.newFixedThreadPool(6);

        List<Future<List<SearchResultEntity>>> futureList = new ArrayList<>();

        Callable<List<SearchResultEntity>> projectThread = new ProjectResultCallable(target);

        Callable<List<SearchResultEntity>> anliThread = new AnliResultCallable(target);

        Callable<List<SearchResultEntity>> ziliaoThread = new ZiliaoResultCallable(target);

        Callable<List<SearchResultEntity>> expertThread=new ExpertResultCallable(target);

        Callable<List<SearchResultEntity>> announceThread=new AnnounceResultCallable(target);

        Callable<List<SearchResultEntity>> keywordThread=new KeyWordResultCallable(target);

        futureList.add(executorService.submit(projectThread));
        futureList.add(executorService.submit(anliThread));
        futureList.add(executorService.submit(ziliaoThread));
        futureList.add(executorService.submit(expertThread));
        futureList.add(executorService.submit(announceThread));
        futureList.add(executorService.submit(keywordThread));

        executorService.shutdown();

        int counter=0;
        for(Future f:futureList){

            List<SearchResultEntity> list=(List<SearchResultEntity>)f.get();

            for(SearchResultEntity searchResultEntity:list){

                searchResultEntity.setId(++counter);

                finalEntityList.add(searchResultEntity);

            }

        }


        JSONArray jsonArray=new JSONArray();

        JSONObject jsonObject=new JSONObject();

        jsonObject.put("number",0);
        jsonObject.put("last","true");
        jsonObject.put("numberOfElements",finalEntityList.size());
        jsonObject.put("size",finalEntityList.size());
        jsonObject.put("totalPages",1);
        jsonObject.put("sort","{}");
        jsonObject.put("content",finalEntityList);
        jsonObject.put("first","true");
        jsonObject.put("totalElements",finalEntityList.size());
        jsonArray.add(jsonObject);

        result.put("result",jsonArray);
        result.put("msg","ok");

        return result.toString();
    }


}
