package com.song.archives.dao;

import com.song.archives.model.ModuleFileEntity;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Created by souyouyou on 2018/3/8.
 */
public interface ModuleFileRespository extends CrudRepository<ModuleFileEntity,Long> {

    ModuleFileEntity findByFileCode(String fileCode);

    @Query(value = "update module_file set t_id = NULL  where t_id =:id and type =:type",nativeQuery = true)
    @Modifying
    void updateTidByIdAndType(@Param(value = "id")Long id,@Param(value = "type")String type);

    @Query(value = "select * from module_file where t_id =:tId and type =:type",nativeQuery = true)
    List<ModuleFileEntity> findByT_idAndType(@Param(value = "tId") Long tId, @Param(value = "type") String type);

}
