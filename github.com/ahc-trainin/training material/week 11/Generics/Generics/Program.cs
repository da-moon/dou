using System;
using System.Collections.Generic;
using Generics.DataStores;
using Generics.Entities;

namespace Generics
{
    class Program
    {
        static void Main(string[] args)
        {

            var studentsDatabase = new StudentDataStore();

            studentsDatabase.Add(new Student(1, "Marcos"));
            studentsDatabase.Add(new Student(2, "Cris"));

            var teachersDatabase = new TeacherDataStore();
            teachersDatabase.Add(new Teacher(1, "Rodolfo"));

            var rodolfo = teachersDatabase.Get(1);
            var cris = studentsDatabase.Get(2);

        }
    }
}
