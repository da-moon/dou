package com.dou.university.dev.generics.domain.animals.persons;

public class Student extends Person {
	
	public Student(String name) {
		super.name = name;
	}
	
	@Override
	public void eat() {
		System.out.println("Student eating");
	}

	@Override
	public void live() {
		System.out.println("Student living");
	}

	@Override
	public void die() {
		System.out.println("Student dying");
	}

	@Override
	public String work() {
		return "nothing cuz a student doesn't work";
	}

	@Override
	public String toString() {
		return super.getName();
	}
}
