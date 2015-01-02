package model;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import com.opencsv.CSVReader;

public class FileDao {

	String csvFile;
	String line;
	char seperator;
	CSVReader reader;

	List<String[]> table;

	public FileDao(String csvFile, char seperator) {
		super();
		this.csvFile = csvFile;
		this.seperator = seperator;
		this.table = readFile(this.csvFile, this.seperator);
	}

	public FileDao(String csvFile) {
		super();
		this.csvFile = csvFile;
		this.seperator = ';';
		this.table = readFile(this.csvFile, this.seperator);
	}

	public List<String[]> readFile(String csv, char sep) {
		try {
			reader = new CSVReader(new FileReader(csv), sep);
			List<String[]> table = reader.readAll();
			return table;
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public int getRowNumber() {
		return this.table.size();
	}

	public int getColumnNumber() {
		return this.table.get(0).length;
	}

	public List<Integer> findValue(int value) {
		List<Integer> coordinates = new ArrayList<Integer>();

		Integer tableRow = 0;
		boolean success = false;
		for (String[] row : this.table) {
			for (int i = 0; i < row.length; i++) {
				if (Integer.valueOf(row[i]) == value) {
					coordinates.add(0,tableRow+1);
					coordinates.add(1, new Integer(i+1));
					success = true;
				}
			}
			tableRow++;
		}
		if (!success) {
			coordinates.add(0);
			coordinates.add(0);
		}

		return coordinates;
	}

	public String printRow(int row) {
		String result = "";
		String[] rowArray = this.table.get((row-1));
		for (int i = 0; i < rowArray.length; i++) {
			result = result + " | " + rowArray[i] + " | ";
		}
		return result;
	}

}