package com.song.archives.dao;

import com.song.archives.model.FileInfoEntity;
import com.song.archives.model.ModuleFileEntity;
import com.song.archives.model.ProjectInfoEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;

/**
 * Created by ghl on 2018/3/1.
 */
public interface FileInfoRepository extends CrudRepository<FileInfoEntity, Long> {
    List<FileInfoEntity> findByIdIsInAndClassificlevelIdLessThanEqual(Specification specification, Pageable pageable);

    List<FileInfoEntity> findAll(Specification specification, Pageable pageable);

    @Query(value = "select * from file_info where file_code in (select file_code from module_file where t_id =:tId and type =:type) and classificlevel_id <=:permissionLevel", nativeQuery = true)
    List<FileInfoEntity> findByTidAndType(@Param(value = "tId")Long tId ,@Param(value = "type") String type,@Param(value = "permissionLevel") Integer permissionLevel);


    @Query(value = "select t_id from module_file where file_code = (select file_code from file_info where id =:fileId)", nativeQuery = true)
    Long findTidByFileId(@Param(value = "fileId")Long fileId);

    List<FileInfoEntity> findAll(Pageable pageable);

    List<FileInfoEntity> findByIdIsIn(Long[] fids);

    FileInfoEntity findByFileCode(String fileCode);

    FileInfoEntity findByFileCodeAndFileType(String fileCode,String fileType);

    void deleteByIdIsIn(String[] fids);

}
