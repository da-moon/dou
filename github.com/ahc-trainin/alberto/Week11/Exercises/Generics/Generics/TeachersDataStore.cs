using System;
using System.Collections.Generic;

namespace Generics
{
    public class TeachersDataStore
    {
        private List<Teacher> teachers = new List<Teacher>() { };

        public void Add(Teacher items)
        {
            teachers.Add(items);
        }

        public Teacher Get(int id)
        {
            return teachers.Find(teacher => teacher.id == id);
        }

        public void Remove(Teacher item)
        {
            teachers.Remove(item);
        }
    }
}
