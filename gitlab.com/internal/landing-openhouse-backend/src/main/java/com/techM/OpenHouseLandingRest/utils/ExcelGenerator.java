package com.techM.OpenHouseLandingRest.utils;

import com.techM.OpenHouseLandingRest.model.Candidate;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelGenerator {

	private final List<Candidate> candidateList;
	private final XSSFWorkbook workbook;
	private XSSFSheet sheet;

	public ExcelGenerator(List<Candidate> candidateList) {
		this.candidateList = candidateList;
		workbook = new XSSFWorkbook();
	}

	private void writeHeader() {
		sheet = workbook.createSheet("Candidates");

		Row row = sheet.createRow(0);

		CellStyle style = workbook.createCellStyle();
		XSSFFont font = workbook.createFont();
		((XSSFFont) font).setBold(true);
		font.setFontHeight(16);
		style.setFont(font);

		createCell(row, 0, "ID", style);
		createCell(row, 1, "Name", style);
		createCell(row, 2, "Email", style);
		createCell(row, 3, "Contact Number", style);
		createCell(row, 4, "Programming Language", style);
		createCell(row, 5, "LinkedIn", style);

	}

	private void createCell(Row row, int columnCount, Object value, CellStyle style) {
		sheet.autoSizeColumn(columnCount);
		Cell cell = row.createCell(columnCount);
		if (value instanceof Integer) {
			cell.setCellValue((Integer) value);
		} 
        else if (value instanceof Long) {
			cell.setCellValue((Long) value);
		} else if (value instanceof Boolean) {
			cell.setCellValue((Boolean) value);
		} else {
			cell.setCellValue((String) value);
		}
		cell.setCellStyle(style);
	}

	private void write() {
		int rowCount = 1;

		CellStyle style = workbook.createCellStyle();
		XSSFFont font = workbook.createFont();
		font.setFontHeight(14);
		style.setFont(font);

		for (Candidate candidate : candidateList) {
			Row row = sheet.createRow(rowCount++);
			int columnCount = 0;

			createCell(row, columnCount++, candidate.getId(), style);
			createCell(row, columnCount++, candidate.getName(), style);
			createCell(row, columnCount++, candidate.getEmail(), style);
			createCell(row, columnCount++, candidate.getContactNumber(), style);
			createCell(row, columnCount++, candidate.getProgrammingLanguage(), style);
			createCell(row, columnCount, candidate.getLinkedIn(), style);

		}
	}

	public void generate(HttpServletResponse response) throws IOException {
		writeHeader();
		write();
		ServletOutputStream outputStream = response.getOutputStream();
		workbook.write(outputStream);
		workbook.close();

		outputStream.close();

	}
}