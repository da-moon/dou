package com.dou.university.dev.generics.classes;

import com.dou.university.dev.generics.domain.animals.Animal;
import com.dou.university.dev.generics.domain.animals.GenericClass;
import com.dou.university.dev.generics.domain.animals.GenericClass2;
import com.dou.university.dev.generics.domain.animals.aquatic.Shark;
import com.dou.university.dev.generics.domain.animals.persons.Employee;
import com.dou.university.dev.generics.domain.animals.persons.Person;
import com.dou.university.dev.generics.domain.animals.persons.Student;

public class GenericClassesDemo {
	
	public static void main(String[] args) {
		genericClassUpperBoundExample1();
		genericClassUpperBoundExample2();
	}
	
	public static void genericClassUpperBoundExample1() {
		Student s1 = new Student("Estudiante 1");
		
		GenericClass<Person> personas = new GenericClass<>(s1);
		System.out.println(personas);
		
		personas.addPersona(new Student("Estudiante 1"));
		System.out.println(personas);
		
		personas.addPersona(new Employee("Empleado 1"));
		System.out.println(personas);
		
		//Example of generic method
		personas.startWorking();
	}
	
	public static void genericClassUpperBoundExample2() {
		Shark s1 = new Shark();
		
		GenericClass2<Animal> animals = new GenericClass2<>(s1);
		System.out.println(animals);
		
		animals.newAnimal(new Student("Estudiante 1"));
		System.out.println(animals);
		
		animals.newAnimal(new Employee("Empleado 1"));
		System.out.println(animals);
		
		//Example of generic method
		animals.printList();
	}
	
	
}
