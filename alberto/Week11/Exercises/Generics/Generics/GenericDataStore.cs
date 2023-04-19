using System;
using System.Collections.Generic;

namespace Generics
{
    public class GenericDataStore<T> where T : Entity
    {
        private List<T> genericList = new List<T>();

        public void Add(T items)
        {
            genericList.Add(items);
        }

        public void Get(int id)
        {
            genericList.Find(generic => generic.id == id);
        }

        public void Remove(T item)
        {
            genericList.Remove(item);
        }
    }
}
