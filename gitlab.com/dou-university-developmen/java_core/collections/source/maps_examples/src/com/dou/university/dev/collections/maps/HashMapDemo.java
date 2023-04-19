package com.dou.university.dev.collections.maps;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import com.dou.university.dev.collections.domain.StudentInMap;

public class HashMapDemo {

	public static void main(String[] args) {
		hashMapExample();
		hashMapWithDuplicatesExample();
	}

	private static void hashMapExample() {
		System.out.println("\t==== HashMap Example ====");
		
		StudentInMap s1 = new StudentInMap();
		StudentInMap s2 = new StudentInMap();
		
		// Key = studentId, Value = student
		Map<String, StudentInMap> map = new HashMap<>();
		
		map.put(s1.getId(), s1);
		System.out.println("Inserted Student: " + s1 + " in the Map: " + map.containsKey(s1.getId()));
		System.out.println("Map: " + map);
		
		map.put(s2.getId(), s2);
		System.out.println("Inserted Student: " + s2 + " in the Map: " + map.containsKey(s2.getId()));
		System.out.println("Map: " + map);
		
		Set<String> keys = map.keySet(); // fetch the current keys in the map
		System.out.println("Keys = " + keys);

		Collection<StudentInMap> values = map.values(); // fetch the current values in the map
		System.out.println("Values = " + values);
	}

	private static void hashMapWithDuplicatesExample() {
		System.out.println("\t==== HashMap with duplicates Example ====");
		
		StudentInMap s1 = new StudentInMap();
		StudentInMap s2 = new StudentInMap();
		StudentInMap s3 = new StudentInMap("New Name", "New Lastname");
		s3.setId(s1.getId()); // duplicate id
		
		// Key = studentId, Value = student
		Map<String, StudentInMap> map = new HashMap<>();
		
		map.put(s1.getId(), s1);
		System.out.println("Inserted Student: " + s1 + " in the Map: " + map.containsKey(s1.getId()));
		System.out.println("Map: " + map);
		
		map.put(s2.getId(), s2);
		System.out.println("Inserted Student: " + s2 + " in the Map: " + map.containsKey(s2.getId()));
		System.out.println("Map: " + map);
		
		System.out.println("Student " + s3 + " already exists in the Map? (Key): " + map.containsKey(s3.getId()));
		map.put(s3.getId(), s3);
		System.out.println("Inserted Student: " + s3 + " in the Map: " + map.containsKey(s3.getId()));
		System.out.println("Map: " + map);
		
		Set<String> keys = map.keySet();
		System.out.println("Keys = " + keys);

		Collection<StudentInMap> values = map.values();
		System.out.println("Values = " + values);
		
		System.out.println("Student " + s2 + " already exists in the Map? (Value): " + map.containsValue(s2));
		map.remove(s2.getId());
		System.out.println("Removed Student: " + s2 + " in the Map: " + !map.containsKey(s2.getId()));
		System.out.println("Map: " + map);
		
		keys = map.keySet(); // the map was modified so we have to fetch the current keys again
		System.out.println("Keys = " + keys);

		values = map.values();// the map was modified so we have to fetch the current values again
		System.out.println("Values = " + values);
	}
}
