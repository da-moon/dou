using System;

namespace Generics
{
    class Program
    {
        static void Main(string[] args)
        {
            var studentsDataBase = new StudentDataStore();
            var teachersDataBase = new TeachersDataStore();

            var studentsDataStore = new GenericDataStore<Student>();
            var teachersDataStore = new GenericDataStore<Teacher>();

            studentsDataBase.Add(new Student(1, "Alberto"));
            studentsDataBase.Add(new Student(2, "Cesar"));

            teachersDataBase.Add(new Teacher(1, "Gaby"));

            studentsDataStore.Add(new Student(1, "Lorena"));
            teachersDataStore.Add(new Teacher(1, "Marcos"));

            
        }
    }
}
