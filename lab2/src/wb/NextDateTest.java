package wb;

import static org.junit.Assert.*;

import org.junit.Test;

public class NextDateTest {
	
	@Test
	public void testIsThirtyDayMonth4() {
		assertEquals(NextDate.isThirtyDayMonth(4),true);
	}
	
	@Test
	public void testIsThirtyDayMonth6() {
		assertEquals(NextDate.isThirtyDayMonth(6),true);
	}
	
	@Test
	public void testIsThirtyDayMonth9() {
		assertEquals(NextDate.isThirtyDayMonth(9),true);
	}
	
	@Test
	public void testIsThirtyDayMonth11() {
		assertEquals(NextDate.isThirtyDayMonth(11),true);
	}
	
	@Test
	public void testIsThirtyDayMonthFalse() {
		assertEquals(NextDate.isThirtyDayMonth(12),false);
	}
	
	
}
