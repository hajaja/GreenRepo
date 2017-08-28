import ilog.concert.IloException;

import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

public class ClassMain {
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException, IloException {
		PARAMS.set();
		ClassFrontier frontier = new ClassFrontier();
	}
}
