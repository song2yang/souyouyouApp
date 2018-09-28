package com.song.archives.dao;

import com.song.archives.model.KeywordInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


/**
 * Created by ghl on 2018/4/20.
 */
public interface KeyWordRepository extends CrudRepository<KeywordInfoEntity,Long> {

    Page<KeywordInfoEntity> findAll(Specification<KeywordInfoEntity> specification, Pageable pageable);

    Page<KeywordInfoEntity> findAll(Pageable pageable);

    List<KeywordInfoEntity> findAll(Specification<KeywordInfoEntity> specification);

}
