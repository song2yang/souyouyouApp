package com.song.archives.dao;

import com.song.archives.model.MenuTypeEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/2/28.
 */
public interface MenuRepository extends CrudRepository<MenuTypeEntity,Long> {


    List<MenuTypeEntity> findAllByType(Integer menuType);
    Page<MenuTypeEntity> findAll(Specification<MenuTypeEntity> specification, Pageable pageable);
    List<MenuTypeEntity> findAllByParentTypeid(Integer parentId);
    List<MenuTypeEntity> findAllByTypeAndParentTypeid(Integer menuType,Integer parentId);
}
