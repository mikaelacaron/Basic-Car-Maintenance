import unittest
from maintenance_utils import calculate_next_service

class TestCalculateNextService(unittest.TestCase):

    def test_exact_service_due(self):
        """Should return 0 when service is exactly due"""
        self.assertEqual(calculate_next_service(10000, 5000, 5000), 0)

    def test_overdue_service(self):
        """Should return 0 when service is overdue"""
        self.assertEqual(calculate_next_service(11000, 5000, 5000), 0)

    def test_service_not_due_yet(self):
        """Should return correct miles left when service not due"""
        self.assertEqual(calculate_next_service(8000, 5000, 5000), 2000)

    def test_custom_interval(self):
        """Should handle custom service interval correctly"""
        self.assertEqual(calculate_next_service(12000, 5000, 10000), 3000)

if __name__ == "__main__":
    unittest.main()
