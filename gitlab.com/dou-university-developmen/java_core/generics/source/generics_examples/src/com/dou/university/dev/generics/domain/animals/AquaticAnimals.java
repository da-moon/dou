package com.dou.university.dev.generics.domain.animals;

import java.util.List;

import com.dou.university.dev.generics.domain.animals.aquatic.AquaticAnimal;

public class AquaticAnimals <A extends AquaticAnimal> {
	
	private A animal;
	private List<A> animals;
	
	public A getAnimal() {
		return animal;
	}
	
	public void setAnimal(A animal) {
		this.animal = animal;
	}
	
	public List<A> getAnimals() {
		return animals;
	}
	
	public void setAnimals(List<A> animals) {
		this.animals = animals;
	}
	
	
}
