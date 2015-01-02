package test;

import model.FileDao;

public class TestFileReading {

	private static String testFile = "/Users/eiterig/Documents/Privat/Dropbox/Cthulhu/UnderPressureGui/TestValues.csv";

	
	public static void main(String[] args) {
		FileDao testValues = new FileDao(testFile);
		System.out.println(testValues.printRow(5));
	}

}
