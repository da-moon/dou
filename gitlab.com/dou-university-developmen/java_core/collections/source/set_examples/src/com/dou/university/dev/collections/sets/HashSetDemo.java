package com.dou.university.dev.collections.sets;

import java.util.HashSet;
import java.util.Set;

import com.dou.university.dev.collections.domain.StudentInMap;

public class HashSetDemo {

	public static void main(String[] args) {
		hashSetExample();
		hashSetWithDuplicateExample();
	}

	private static void hashSetExample() {
		System.out.println("\t==== HashSet Example ====");

		StudentInMap a1 = new StudentInMap();
		StudentInMap a2 = new StudentInMap();
		StudentInMap a3 = new StudentInMap();
		
		Set<StudentInMap> set = new HashSet<>();

		System.out.println("Inserting Student: " + a1 + " in the HashSet: " + set.add(a1));
		System.out.println(set);

		System.out.println("Inserting Student " + a2 + " in the HashSet: " + set.add(a2));
		System.out.println(set);
		
		System.out.println("Inserting Student " + a3 + " in the HashSet: " + set.add(a3));
		System.out.println(set);
	}

	private static void hashSetWithDuplicateExample() {
		System.out.println("\t==== HashSet with duplicate Example ====");

		StudentInMap a1 = new StudentInMap();
		StudentInMap a2 = a1;
		StudentInMap a3 = new StudentInMap();
		
		Set<StudentInMap> set = new HashSet<>();

		System.out.println("Inserting Student " + a1 + " in the HashSet: " + set.add(a1));
		System.out.println(set);

		System.out.println("Inserting Student " + a2 + "in the HashSet: " + set.add(a2));
		System.out.println(set);
		
		System.out.println("Inserting Student " + a3 + " in the HashSet: " + set.add(a3));
		System.out.println(set);
	}
}
