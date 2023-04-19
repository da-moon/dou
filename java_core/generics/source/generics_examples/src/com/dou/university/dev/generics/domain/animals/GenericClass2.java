package com.dou.university.dev.generics.domain.animals;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.dou.university.dev.generics.domain.LivingBeing;

public class GenericClass2 <LB extends LivingBeing> {
	
	private LB livingBeing;
	private List<LB> livingBeingList = new ArrayList<>();
	private Set<LB> personasSet = new HashSet<>();
	
	public GenericClass2() {
	}
	
	public GenericClass2(LB lb) {
		this.livingBeing = lb;
		this.livingBeingList.add(lb);
		this.personasSet.add(lb);
	}
	
	public LB getLivingBeing() {
		return livingBeing;
	}
	
	public void setLivingBeing(LB persona) {
		this.livingBeing = persona;
	}
	
	public List<LB> getLivingBeingList() {
		return livingBeingList;
	}
	
	public void setLivingBeingList(List<LB> animals) {
		this.livingBeingList = animals;
	}
	
	public void newAnimal(LB persona) {
		this.livingBeingList.add(persona);
		this.personasSet.add(persona);
	}
	
	public void printList() {
		for(LB lb : this.livingBeingList) {
			lb.live();
		}
	}
	
	@Override
	public String toString() {
		return "GenericClass [livingBeing=" + livingBeing + ", livingBeingList=" + livingBeingList + ", personasSet=" + personasSet + "]";
	}
	
}
