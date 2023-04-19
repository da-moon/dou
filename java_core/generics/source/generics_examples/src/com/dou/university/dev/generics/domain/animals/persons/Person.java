package com.dou.university.dev.generics.domain.animals.persons;

import java.util.Objects;

import com.dou.university.dev.generics.domain.animals.Animal;

public abstract class Person implements Animal {
	
	protected String name;
	
	public String getName() {
		return name;
	}
	
	public abstract String work();

	@Override
	public int hashCode() {
		return Objects.hash(name);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Person other = (Person) obj;
		return Objects.equals(name, other.name);
	}
	
	
}
