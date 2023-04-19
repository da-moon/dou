using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Generics.Entities;

namespace Generics.DataStores
{
    class StudentDataStore
    {
        private List<Student> students = new List<Student>() { };

        public void Add(Student item)
        {
            students.Add(item);
        }

        public Student Get(int id)
        {
            return students.FirstOrDefault(student => student.Id == id);
        }

        public void Remove(Student item)
        {
            students.Remove(item);
        }
    }
}
