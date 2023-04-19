import unittest
from app import sum

class TestSum(unittest.TestCase):
    
    def test_sum_string(self):
        with self.assertRaises(TypeError):
            sum(10, "b")

    def test_sum(self):
        self.assertEqual(30, sum(10, 20))


unittest.main()
