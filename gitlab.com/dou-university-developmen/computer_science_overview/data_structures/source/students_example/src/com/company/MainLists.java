package com.company;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class MainLists {

  static List<Student> students = new ArrayList<>();

  public static void main(String[] args) {
    initialize();

    sort();
    
    filter();
  }

  private static void filter() {
    students.stream()
      .filter(student -> student.getGrade() > 8)
      .map(student -> student.getName())
      .forEach(System.out::println);

    students
      .stream()
      .filter(StudentPredicate.goodStudent(8))
      .map(student -> student.getName())
      .forEach(System.out::println);

    students
      .stream()
      .filter(StudentPredicate::goodStudentMathematics)
      .map(student -> student.getName())
      .forEach(System.out::println);
  }

  private static void sort() {
    //show students
    students.stream().forEach(System.out::println);

    //sort with Comparable interface
    Collections.sort(students);
    students.stream().forEach(System.out::println);

    //sort students with Collections sort and new Comparator
    Collections.sort(students, new Comparator<Student>() {
      @Override
      public int compare(Student s1, Student s2) {
        return s1.name.compareTo(s2.name);
      }
    });
    students.stream().forEach(System.out::println);

    //sort students with instance sort and Comparator comparing
    students.sort(Comparator.comparing(Student::getName).reversed());
    students.stream().forEach(System.out::println);

    //sort with stream to another collection
    List<Student> sortedStudents = students.stream()
      .sorted(Comparator.comparing(Student::getName))
      .collect(Collectors.toList());
    sortedStudents.stream().forEach(System.out::println);
  }

  private static void initialize() {
    Course courseSpanish = new Course();
    Course courseEnglish = new Course();
    Course courseMathematics = new Course();

    courseSpanish.name = "spanish";
    courseEnglish.name = "english";
    courseMathematics.name = "mathematics";

    courseSpanish.professor = "raul";
    courseEnglish.professor = "john";
    courseMathematics.professor = "albert";

    Student student1 = new Student();
    Student student2 = new Student();
    Student student3 = new Student();
    Student student4 = new Student();
    Student student5 = new Student();
    Student student6 = new Student();
    Student student7 = new Student();
    Student student8 = new Student();
    Student student9 = new Student();
    Student student10 = new Student();

    student1.name = "hugo";
    student2.name = "paco";
    student3.name = "luis";
    student4.name = "mcquack";
    student5.name = "sgrooge";
    student6.name = "badmom";
    student7.name = "pedro";
    student8.name = "rosita";
    student9.name = "linda";
    student10.name = "adrian";

    student1.grade = 5.0;
    student2.grade = 5.5;
    student3.grade = 6.0;
    student4.grade = 6.5;
    student5.grade = 7.0;
    student6.grade = 7.5;
    student7.grade = 8.0;
    student8.grade = 9.0;
    student9.grade = 9.5;
    student10.grade = 10.0;

    student1.courses.add(courseSpanish);
    student2.courses.addAll(Arrays.asList(courseSpanish, courseEnglish));
    student3.courses.addAll(Arrays.asList(courseSpanish, courseEnglish, courseMathematics));
    student4.courses.add(courseSpanish);
    student5.courses.addAll(Arrays.asList(courseSpanish, courseEnglish));
    student6.courses.addAll(Arrays.asList(courseSpanish, courseEnglish, courseMathematics));
    student7.courses.add(courseSpanish);
    student8.courses.addAll(Arrays.asList(courseSpanish, courseEnglish));
    student9.courses.addAll(Arrays.asList(courseSpanish, courseEnglish, courseMathematics));
    student10.courses.add(courseMathematics);

    students.addAll(Arrays.asList(student1, student2, student3, student4, student5));
    students.addAll(Arrays.asList(student6, student7, student8, student9, student10));
  }
}
