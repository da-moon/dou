package com.dou.university.dev.generics.domain.animals.persons;

public class Employee extends Person {
	
	public Employee(String name) {
		super.name = name;
	}
	
	@Override
	public void eat() {
		System.out.println("Employee eating");
	}

	@Override
	public void live() {
		System.out.println("Employee doesn't have a life");
	}

	@Override
	public void die() {
		System.out.println("Employee dying (everyday)");
	}

	@Override
	public String work() {
		return "work";
	}
	
	@Override
	public String toString() {
		return super.getName();
	}
	
}
