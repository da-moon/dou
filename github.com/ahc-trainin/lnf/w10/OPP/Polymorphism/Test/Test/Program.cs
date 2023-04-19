using System;

namespace Test
{
    class Program
    {
        static void Main(string[] args)

        {
           Test test = new Test();

           Console.WriteLine("The result of the first result is:" + test.Add(234, 574));
           Console.WriteLine("The result of the second result is:" + test.Add(123, 987, 456));
        }

        }
    }
