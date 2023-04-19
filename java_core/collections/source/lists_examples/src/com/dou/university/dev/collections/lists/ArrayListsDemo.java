package com.dou.university.dev.collections.lists;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

//import com.sun.javafx.collections.ImmutableObservableList;

public class ArrayListsDemo {

	public static void main(String[] args) {
		createAListExample();
		listExpandsCurrentSizeExample();
//		inmmutableListExample();
		createAListFromOtherCollectionExample();
	}

	private static void createAListExample() {
		System.out.println("\t==== Create a List Example ====");

		List<Integer> list = new ArrayList<>();
		list.add(1);
		list.add(2);
		list.add(3);
		System.out.println(list);
		System.out.println("The element at index two = " + list.get(1));
		System.out.println("The size of the List = " + list.size());
	}

	private static void listExpandsCurrentSizeExample() {
		System.out.println("\t==== List expands current Size Example ====");

		List<Integer> list = new ArrayList<>(3);
		list.add(1);
		list.add(2);
		list.add(3);
		System.out.println(list);
		System.out.println("The size of the List = " + list.size());

		list.add(4);
		System.out.println(list);
		System.out.println("The size of the List = " + list.size());
	}

//	private static void inmmutableListExample() {
//		System.out.println("\t==== Immutable List Example ====");
//
//		List<Integer> list = new ImmutableObservableList<>(1, 2);
//
//		System.out.println(list);
//		System.out.println("The size of the List is " + list);
//
//		try {
//			list.add(4); // <--- throws error
//		} catch (UnsupportedOperationException ex) {
//			System.out.println(ex);
//		}
//	}

	private static void createAListFromOtherCollectionExample() {
		System.out.println("\t==== Create a List from other Collection Example ====");

		Set<Integer> set = new HashSet<>();
		set.add(1);
		set.add(2);
		set.add(3);

		List<Integer> list = new ArrayList<>(set);

		System.out.println(list);
		System.out.println("The size of the List is " + list.size());

		set.add(4);
		System.out.println(set);
		System.out.println("The size of the Set is " + set.size());
	}
}
