package com.dou.university.dev.generics.domain.animals.aquatic;

public class Shark extends AquaticAnimal {

	@Override
	public void eat() {
		System.out.println("Shark eating");
	}

	@Override
	void swing() {
		System.out.println("Shark swimming");
	}

	@Override
	public void live() {
		System.out.println("Sharking living");
	}

	@Override
	public void die() {
		System.out.println("Sharking dying");
	}
	
	@Override
	public String toString() {
		return "Shark";
	}
}
