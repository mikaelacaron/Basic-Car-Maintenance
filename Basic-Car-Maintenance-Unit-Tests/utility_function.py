def calculate_next_service(current_mileage: int, last_service_mileage: int, service_interval: int = 5000):
    """
    Calculates mileage remaining until next service.
    Returns 0 if the service is overdue.
    """
    miles_left = (last_service_mileage + service_interval) - current_mileage
    return miles_left if miles_left > 0 else 0
