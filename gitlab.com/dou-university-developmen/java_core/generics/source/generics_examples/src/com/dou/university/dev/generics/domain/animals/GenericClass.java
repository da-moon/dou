package com.dou.university.dev.generics.domain.animals;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.dou.university.dev.generics.domain.animals.persons.Person;

public class GenericClass <P extends Person> {
	
	private P persona;
	private List<P> personasList = new ArrayList<>();
	private Set<P> personasSet = new HashSet<>();
	
	public GenericClass() {
	}
	
	public GenericClass(P persona) {
		this.persona = persona;
		this.personasList.add(persona);
		this.personasSet.add(persona);
	}
	
	public P getPersona() {
		return persona;
	}
	
	public void setPersona(P persona) {
		this.persona = persona;
	}
	
	public List<P> getPersonasList() {
		return personasList;
	}
	
	public void setPersonasList(List<P> animals) {
		this.personasList = animals;
	}
	
	public void addPersona(P persona) {
		this.personasList.add(persona);
		this.personasSet.add(persona);
	}
	
	public void startWorking() {
		for(P p : this.personasList) {
			System.out.println(p.getName() + " is doing " + p.work());
		}
	}
	
	@Override
	public String toString() {
		return "GenericClass [persona=" + persona + ", personasList=" + personasList + ", personasSet=" + personasSet + "]";
	}
	
}
