package com.dou.university.dev.generics.domain.animals.aquatic;

public class Tuna extends AquaticAnimal {
	
	@Override
	public void eat() {
		System.out.println("Tuna eating");
	}

	@Override
	void swing() {
		System.out.println("Tuna swimming");
	}

	@Override
	public void live() {
		System.out.println("Tuna living");
	}
	
	@Override
	public void die() {
		System.out.println("Tuna dying");	
	}
	
}
