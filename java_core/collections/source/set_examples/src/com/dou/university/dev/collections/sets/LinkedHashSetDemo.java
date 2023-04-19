package com.dou.university.dev.collections.sets;

import java.util.LinkedHashSet;
import java.util.Set;

import com.dou.university.dev.collections.domain.StudentInMap;

public class LinkedHashSetDemo {

	public static void main(String[] args) {
		linkedHashSetExample();
		linkedHashSetWithDuplicateExample();
	}
	
	private static void linkedHashSetExample() {
		System.out.println("\t==== LinkedHashSet Example ====");

		StudentInMap a1 = new StudentInMap();
		StudentInMap a2 = new StudentInMap();
		StudentInMap a3 = new StudentInMap();
		
		Set<StudentInMap> set = new LinkedHashSet<>();

		System.out.println("Inserting Student: " + a1 + " in the HashSet: " + set.add(a1));
		System.out.println(set);

		System.out.println("Inserting Student " + a2 + " in the HashSet: " + set.add(a2));
		System.out.println(set);
		
		System.out.println("Inserting Student " + a3 + " in the HashSet: " + set.add(a3));
		System.out.println(set);
	}

	private static void linkedHashSetWithDuplicateExample() {
		System.out.println("\t==== LinkedHashSet with duplicate Example ====");

		StudentInMap a1 = new StudentInMap();
		StudentInMap a2 = a1;
		StudentInMap a3 = new StudentInMap();
		
		Set<StudentInMap> set = new LinkedHashSet<>();

		System.out.println("Inserting Student " + a1 + " in the HashSet: " + set.add(a1));
		System.out.println(set);

		System.out.println("Inserting Student " + a2 + "in the HashSet: " + set.add(a2));
		System.out.println(set);
		
		System.out.println("Inserting Student " + a3 + " in the HashSet: " + set.add(a3));
		System.out.println(set);
	}
}
