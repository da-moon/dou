using System;
using System.Collections.Generic;

namespace Generics
{
    public class StudentDataStore
    {
        private List<Student> students = new List<Student>() { };

        public void Add(Student items)
        {
            students.Add(items);
        }

        public Student Get(int id)
        {
            return students.Find(student => student.id == id);
        }

        public void Remove(Student item)
        {
            students.Remove(item);
        }
    }
}
