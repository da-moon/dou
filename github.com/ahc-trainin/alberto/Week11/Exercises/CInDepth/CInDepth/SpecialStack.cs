using System;
namespace CInDepth
{
    public class SpecialStack<T>
    {
        public T[] array;
        public int top = -1;

        public SpecialStack(int size)
        {
            array = new T[size];
        }

        public void Push(T value)
        {
            if (!IsFull())
            {
                array[top] = value;
                top++;
            } else Console.WriteLine("The stack is full");
        }

        public void Pop()
        {
            if (!IsEmpty())
            {
                array[top] = default;
                top--;
            }
            else Console.WriteLine("The stack is empty");
            
        }

        public Boolean IsFull()
        {
            if(top == array.Length-1)
            {   
                return true;
            } else
            {
                return false;
            }
            
        }

        public Boolean IsEmpty()
        {
            if (top == -1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public void PrintStack()
        {
               foreach(T i in array)
            {
                Console.WriteLine(i);
            }
        }

        //public void MinValue()
        //{
        //    var min = array[0];

        //    foreach(T i in array)
        //    {
        //        if(min > i)
        //        {

        //        }
        //    }
            
        //}


    }
}
