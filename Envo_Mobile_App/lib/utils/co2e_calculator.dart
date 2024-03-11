import 'dart:math';

class CarbonFootprintCalculator {
  // Constants for carbon emissions (in kilograms) per mode of transportation
  static const double busEmission = 0.082;
  static const double carEmission = 0.2;
  static const double motorbikeEmission = 0.115;
  static const double airplaneEmission = 0.11;

  // Constants for carbon emissions (in kilograms) per food type
  static const double vegetarianEmission = 2.89;
  static const double nonVegetarianEmission = 3.81;
  
  // Constants for carbon emissions (in kilograms) per electronic device type
  static const double phoneEmission = 55.0;
  static const double laptopEmission = 194.0;
  static const double tabletEmission = 102.0;

  // Calculate the carbon footprint for transportation
  double calculateTransportationFootprint(double busDistance, double carDistance, double motorbikeDistance, double airplaneDistance) {
    double busEmissions = busEmission * busDistance;
    double carEmissions = carEmission * carDistance;
    double motorbikeEmissions = motorbikeEmission * motorbikeDistance;
    double airplaneEmissions = airplaneEmission * airplaneDistance;

    return busEmissions + carEmissions + motorbikeEmissions + airplaneEmissions;
  }

  // Calculate the carbon footprint for food consumption
  double calculateFoodFootprint(int vegetarianMeals, int nonVegetarianMeals) {
    double vegetarianEmissions = vegetarianEmission * vegetarianMeals;
    double nonVegetarianEmissions = nonVegetarianEmission * nonVegetarianMeals;

    return vegetarianEmissions + nonVegetarianEmissions;
  }

  // Calculate the carbon footprint for electronic devices
  double calculateElectronicFootprint(int numPhones, int numLaptops, int numTablets) {
    double phoneEmissions = phoneEmission * numPhones;
    double laptopEmissions = laptopEmission * numLaptops;
    double tabletEmissions = tabletEmission * numTablets;

    return phoneEmissions + laptopEmissions + tabletEmissions;
  }

  // Calculate the total carbon footprint
  double calculateTotalFootprint(double transportationFootprint, double foodFootprint, double electronicFootprint) {
    return transportationFootprint + foodFootprint + electronicFootprint;
  }
}

// Usage Example:
void main() {
  CarbonFootprintCalculator calculator = CarbonFootprintCalculator();
  
  // Sample data
  double busDistance = 100.0; // in kilometers
  double carDistance = 200.0; // in kilometers
  double motorbikeDistance = 50.0; // in kilometers
  double airplaneDistance = 500.0; // in kilometers
  
  int vegetarianMeals = 10;
  int nonVegetarianMeals = 5;
  
  int numPhones = 2;
  int numLaptops = 1;
  int numTablets = 3;
  
  double transportationFootprint = calculator.calculateTransportationFootprint(
    busDistance, carDistance, motorbikeDistance, airplaneDistance);
  
  double foodFootprint = calculator.calculateFoodFootprint(
    vegetarianMeals, nonVegetarianMeals);
  
  double electronicFootprint = calculator.calculateElectronicFootprint(
    numPhones, numLaptops, numTablets);
  
  double totalFootprint = calculator.calculateTotalFootprint(
    transportationFootprint, foodFootprint, electronicFootprint);
  
  print('Transportation Footprint: $transportationFootprint kg CO2');
  print('Food Footprint: $foodFootprint kg CO2');
  print('Electronic Footprint: $electronicFootprint kg CO2');
  print('Total Footprint: $totalFootprint kg CO2');
}