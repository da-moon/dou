package com.dou.university.dev.collections.domain;

import java.util.Objects;
import java.util.UUID;

public class Student {

	private String id;
	private String firstName;
	private String lastName;

	public Student() {
		this.id = UUID.randomUUID().toString().substring(0,	4);
		this.firstName = "Student";
		this.lastName = "Demo";
	}

	public Student(String firstName, String lastName) {
		this.id = UUID.randomUUID().toString().substring(0,	4);
		this.firstName = firstName;
		this.lastName = lastName;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	@Override
	public String toString() {
		return "Student [id=" + id + ", firstName=" + firstName + ", lastName=" + lastName + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StudentInMap other = (StudentInMap) obj;
		return Objects.equals(id, other.id);
	}
}
