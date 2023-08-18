package com.fit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.EmpInfo;

@Mapper
public interface DraftMapper {

    List<EmpInfo> getAllEmp();
    
    // 그 외 필요한 쿼리 메소드들
}
