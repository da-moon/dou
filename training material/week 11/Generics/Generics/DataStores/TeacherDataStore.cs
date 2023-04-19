using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Generics.Entities;

namespace Generics.DataStores
{
    class TeacherDataStore
    {
        private List<Teacher> teachers = new List<Teacher>() { };

        public void Add(Teacher item)
        {
            teachers.Add(item);
        }

        public Teacher Get(int id)
        {
            return teachers.FirstOrDefault(teacher => teacher.Id == id);
        }

        public void Remove(Teacher item)
        {
            teachers.Remove(item);
        }
    }
}
