using System;
using System.Collections.Generic;

namespace CInDepth
{
    public class SpecialQueue
    {
        string[] array;
        List<string> popElements = new List<string>();
        int top = 0;
        int current = 0;

        public void Input()
        {
            Console.WriteLine("Type the size of the queue");
            array = new string[int.Parse(Console.ReadLine())];
            Console.WriteLine("Type the input");
            string inputQueue = Console.ReadLine();

            for (int i=0; i< inputQueue.Length; i++)
            {
                if (inputQueue[i] == '1')
                {
                    i++;
                    Push(inputQueue[i].ToString());

                } else if (inputQueue[i] == '2')
                {
                    Pop();
                }
            }

            foreach(string s in popElements)
            {
                Console.Write(s + " ");
            }
        }

        private void Push(string value)
        {
            if (current < array.Length - 1)
            {
                array[current] = value;
                current++;
            } else if ( current == array.Length -1)
            {
                array[current] = value;
                current=0;
            }
            
        }

        private void Pop()
        {
            popElements.Add(array[top]);
            array[top] = "";
            top++;
        }
    }
}
