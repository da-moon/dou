package com.company;

import java.util.ArrayList;
import java.util.List;

public class Student implements Comparable<Student>{

  String name;
  double grade;
  List<Course> courses = new ArrayList<>();

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public double getGrade() {
    return grade;
  }

  public void setGrade(double grade) {
    this.grade = grade;
  }

  public List<Course> getCourses() {
    return courses;
  }

  public void setCourses(List<Course> courses) {
    this.courses = courses;
  }

  @Override
  public String toString(){
    return name + "," + grade + ",courses(" + courses.size() +")";
  }

  @Override
  public int compareTo(Student o) {
    if (getName() == null || o.getName() == null) {
      return 0;
    }
    return getName().compareTo(o.getName());
  }
}