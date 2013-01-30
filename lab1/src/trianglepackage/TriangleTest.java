package trianglepackage;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * TriangleTest for testing the Triangle class.
 * This template is used in the exercise phase 1.
 * Students should add relevant unit test cases related to the Triangle 
 * class to this class.
 */
public class TriangleTest extends TestCase {
	private Triangle rightAngledTriangle;

	/**
	 * Constructs a test case with the given name.
	 */
	public TriangleTest(String name) {
		super(name);
	}

	/** 
	 * Initializes common objects. The JUnit framework automatically invokes 
	 * this method before each test is run.
	 */
	protected void setUp() {
		rightAngledTriangle = new Triangle(3, 4, 5);
	}

	/**
	 * Cleanup method. The JUnit framework automatically invokes
	 * this method after each test is run.
	 */
	protected void tearDown() {
		rightAngledTriangle = null;
	}
	
	public void testEquilateral() {
		Triangle equilateral = rightAngledTriangle;
		equilateral.setSideLengths(1, 1, 1);
		
		assertTrue("Should return true for a equilateral triangle",
					equilateral.isEquilateral());
		assertEquals("Should return 'equilateral'", "equilateral", equilateral.classify());
	}
	
	/**
	 * Test whether the triangle specified in the fixture (setUp) 
	 * is right-angled. 	
	 */
	public void testRightAngled() {
		assertTrue("Should return true for a right-angled triangle",
		            rightAngledTriangle.isRightAngled());
		assertEquals("Should return 'right-angled'", "right-angled", rightAngledTriangle.classify());			
	}	

	/**
	 * Creates a test suite. You can use this if you have a hierarchy of 
	 * suites where a suite higher in the hierarchy can have 
	 * suite.addTest(TriangleTest.suite())
	 * @return a test suite 
	 */
	public static Test suite() {
		TestSuite suite = new TestSuite(TriangleTest.class);
		return suite;
	}

	/**
	 * Main function for starting the TestRunner.
	 * @param args no parameters required.
	 */
	public static void main(String args[]) {
		String[] testCaseName = { TriangleTest.class.getName()};

		// chooses the userinterface

		// junit.textui.TestRunner.main(testCaseName);
		// junit.awtui.TestRunner.main(testCaseName);
		junit.swingui.TestRunner.main(testCaseName);
	}
}
