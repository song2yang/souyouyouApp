package com.song.archives.dao;

import com.song.archives.model.AnliInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/3/12.
 */
public interface AnliRepository extends CrudRepository<AnliInfoEntity,Long>{

    Page<AnliInfoEntity> findAll(Specification<AnliInfoEntity> specification, Pageable pageable);

    List<AnliInfoEntity> findAll(Specification<AnliInfoEntity> specification);
    long count();

}
