package com.dou.university.dev.generics.collections;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.dou.university.dev.generics.domain.Food;
import com.dou.university.dev.generics.domain.fruits.Apple;
import com.dou.university.dev.generics.domain.fruits.Banana;
import com.dou.university.dev.generics.domain.fruits.Fruit;
import com.dou.university.dev.generics.domain.vegs.Carrot;
import com.dou.university.dev.generics.domain.vegs.Onion;
import com.dou.university.dev.generics.domain.vegs.Tomato;
import com.dou.university.dev.generics.domain.vegs.Vegatable;

public class GenericCollectionsDemo {
	
	public static void main(String[] args) {
		genericListsExample();
		genericSetsExample();
		genericFruitsListExample();
		genericFruitsSetExample();
		genericFruitsMapExample();
	}
	
	
	private static void genericListsExample() {
		System.out.println("\t==== Generic Lists Example ====");

		List<Integer> list = new ArrayList<>();
		list.add(1);
		list.add(2);
		list.add(3);
		
		System.out.println(list);
		
		list = new LinkedList<>();
		System.out.println(list);
	}
	
	private static void genericSetsExample() {
		System.out.println("\t==== Generic Sets Example ====");
		
		Set<Integer> set = new HashSet<>();
		set.add(1);
		set.add(2);
		set.add(3);
		
		System.out.println(set);
		
		set = new LinkedHashSet<>();
		System.out.println(set);
	}
	
	private static void genericFruitsListExample() {
		System.out.println("\t==== Generic Fruits List Example ====");
		
		List<Fruit> frutas = new ArrayList<>(); // upper bound
		frutas.add(new Apple());
		frutas.add(new Banana());
		System.out.println(frutas);
		
		List<Vegatable> vegetales = new ArrayList<>();
		vegetales.add(new Onion());
		vegetales.add(new Carrot());
		System.out.println(vegetales);
		
		List<? super Food> comidas = new ArrayList<>(); // lower bound
		comidas.addAll(frutas);
		comidas.addAll(vegetales);
		System.out.println(comidas);
		
		comidas.add(new Tomato());
		System.out.println(comidas);
	}
	
	private static void genericFruitsSetExample() {
		System.out.println("\t==== Generic Fruits Set Example ====");
		
		Set<Fruit> frutas = new HashSet<>(); // upper bound
		frutas.add(new Apple());
		frutas.add(new Banana());
		System.out.println(frutas);
		
		Set<Vegatable> vegetales = new HashSet<>();
		vegetales.add(new Onion());
		vegetales.add(new Carrot());
		System.out.println(vegetales);
		
		Set<? super Food> comidas = new HashSet<>(); // lower bound
		comidas.addAll(frutas);
		comidas.addAll(vegetales);
		System.out.println(comidas);
		
		comidas.add(new Tomato());
		System.out.println(comidas);
	}
	
	private static void genericFruitsMapExample() {
		System.out.println("\t==== Generic Fruits Map Example ====");
		
		Map<Integer, Fruit> frutas = new HashMap<>(); // upper bound
		frutas.put(1, new Apple());
		frutas.put(2, new Banana());
		System.out.println(frutas);
		
		Map<Integer, Vegatable> vegetales = new HashMap<>();
		vegetales.put(3, new Onion());
		vegetales.put(4, new Carrot());
		System.out.println(vegetales);
		
		Map<Integer, ? super Food> comidas = new HashMap<>(); // lower bound
		comidas.putAll(frutas);
		comidas.putAll(vegetales);
		System.out.println(comidas);
		
		comidas.put(5, new Tomato());
		System.out.println(comidas);
	}
	
	
}
