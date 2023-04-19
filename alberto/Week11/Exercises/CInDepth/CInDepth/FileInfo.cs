using System;
namespace CInDepth
{
    public class FileInfo : IFile, IFile2
    {
        public FileInfo()
        {
        }

        void IFile.ReadFile()
        {
            Console.WriteLine("Reading file");
        }
        public void WriteFile(string file)
        {
            Console.WriteLine($"Writing file {file}");
        }
        public void CompressFile()
        {
            Console.WriteLine("Compressing file");
        }
    }
}
