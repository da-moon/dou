package com.company;

import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class StudentPredicate {

  public static Predicate<Student> goodStudent(double grade) {
    return (Student s) -> {
      return s.getGrade() > grade;
    };
  }

  public static boolean goodStudentMathematics(Student student) {
    Predicate <Student> s1 = (Student s) -> {
      List<Course> course = s.getCourses()
        .stream()
        .filter(c -> c.name.equals("mathematics"))
        .collect(Collectors.toList());
      return course.size() > 0;
    };
    Predicate <Student> s2 = (Student s) -> s.getGrade() > 8;
    Predicate <Student> finalPredicate = s1.and(s2); //"or" is another option here
    return finalPredicate.test(student);
  }
}
