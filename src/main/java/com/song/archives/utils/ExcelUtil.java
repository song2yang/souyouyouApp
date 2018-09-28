package com.song.archives.utils;


import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class ExcelUtil {


    public static List<String[]> excel2List(MultipartFile file) throws Exception {
        String fileName = file.getOriginalFilename();

        if (!fileName.matches("^.+\\.(?i)(xls)$") && !fileName.matches("^.+\\.(?i)(xlsx)$")) {
            throw new Exception("上传文件格式不正确");
        }
        boolean isExcel2003 = true;
        if (fileName.matches("^.+\\.(?i)(xlsx)$")) {
            isExcel2003 = false;
        }
        InputStream is = file.getInputStream();
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
        Workbook wb;
        if (isExcel2003) {
            wb = new HSSFWorkbook(is);
        } else {
            wb = new XSSFWorkbook(is);
        }

        List<String[]> dataList = new ArrayList<>();

        Sheet sheet = wb.getSheetAt(0);

        if (null == sheet) {
            return dataList;
        }

        for (int r = 1; r <= sheet.getLastRowNum(); r++) {

            Row row = sheet.getRow(r);
            if (row == null) {
                continue;
            }

            String[] dataRow = new String[row.getLastCellNum()];
            for (Cell cell:row){
                int cellType = cell.getCellType();
                String cellValue;
                switch (cellType) {
                    case Cell.CELL_TYPE_STRING:     // 文本
                        cellValue = cell.getRichStringCellValue().getString();
                        break;
                    case Cell.CELL_TYPE_NUMERIC:    // 数字、日期
                        if (DateUtil.isCellDateFormatted(cell)) {
                            cellValue = fmt.format(cell.getDateCellValue());
                        } else {
                            cell.setCellType(Cell.CELL_TYPE_STRING);
                            cellValue = String.valueOf(cell.getRichStringCellValue().getString());
                        }
                        break;
                    case Cell.CELL_TYPE_BOOLEAN:    // 布尔型
                        cellValue = String.valueOf(cell.getBooleanCellValue());
                        break;
                    case Cell.CELL_TYPE_BLANK: // 空白
                        cellValue = cell.getStringCellValue();
                        break;
                    case Cell.CELL_TYPE_ERROR: // 错误
                        cellValue = "错误";
                        break;
                    case Cell.CELL_TYPE_FORMULA:    // 公式
                        // 得到对应单元格的公式
                        //cellValue = cell.getCellFormula();
                        // 得到对应单元格的字符串
                        cell.setCellType(Cell.CELL_TYPE_STRING);
                        cellValue = String.valueOf(cell.getRichStringCellValue().getString());
                        break;
                    default:
                        cellValue = "#";
                }
                dataRow[cell.getColumnIndex()]=cellValue;
            }

            dataList.add(dataRow);
        }

        return dataList;
    }
}