import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/api_service.dart';
import '../../../config/app_config.dart';

class SubmitDataScreen extends StatefulWidget {
  const SubmitDataScreen({super.key});

  @override
  State<SubmitDataScreen> createState() => _SubmitDataScreenState();
}

class _SubmitDataScreenState extends State<SubmitDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService(baseUrl: AppConfig.baseUrl);
  
  bool _isSubmitting = false;
  
  // Form Controllers - Company Profile
  final _legalNameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _sectorController = TextEditingController();
  final _subsectorController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _regionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _yearFoundedController = TextEditingController();
  
  // Financial Metrics
  final _annualRevenueController = TextEditingController();
  final _ebitdaController = TextEditingController();
  final _totalAssetsController = TextEditingController();
  final _rdInvestmentController = TextEditingController();
  final _capexController = TextEditingController();
  final _sustainabilityInvestmentController = TextEditingController();
  
  // Environmental - Energy & Climate
  final _electricityConsumedController = TextEditingController();
  final _renewableEnergyController = TextEditingController();
  final _renewableEnergyPctController = TextEditingController();
  final _naturalGasController = TextEditingController();
  final _dieselController = TextEditingController();
  final _scope1Controller = TextEditingController();
  final _scope2MarketController = TextEditingController();
  final _scope2LocationController = TextEditingController();
  final _scope3Controller = TextEditingController();
  
  // Environmental - Water
  final _waterWithdrawalController = TextEditingController();
  final _waterDischargeController = TextEditingController();
  final _waterConsumptionController = TextEditingController();
  final _waterRecycledController = TextEditingController();
  
  // Environmental - Waste
  final _wasteGeneratedController = TextEditingController();
  final _wasteDivertedController = TextEditingController();
  final _wasteDisposedController = TextEditingController();
  final _hazardousWasteController = TextEditingController();
  
  // Social - Workforce
  final _totalHeadcountController = TextEditingController();
  final _newHiresController = TextEditingController();
  final _departuresController = TextEditingController();
  final _femaleEmployeesController = TextEditingController();
  final _maleEmployeesController = TextEditingController();
  final _womenInManagementController = TextEditingController();
  final _womenOnBoardController = TextEditingController();
  
  // Social - Health & Safety
  final _totalHoursWorkedController = TextEditingController();
  final _recordableInjuriesController = TextEditingController();
  final _lostTimeInjuriesController = TextEditingController();
  
  // Social - Training
  final _totalTrainingHoursController = TextEditingController();
  final _trainingInvestmentController = TextEditingController();
  
  // Governance - Supply Chain
  final _totalSuppliersController = TextEditingController();
  final _suppliersSignedCocController = TextEditingController();
  final _suppliersAuditedController = TextEditingController();

  int _currentStep = 0;

  @override
  void dispose() {
    // Dispose all controllers
    _legalNameController.dispose();
    _tradeNameController.dispose();
    _sectorController.dispose();
    _subsectorController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _websiteController.dispose();
    _yearFoundedController.dispose();
    _annualRevenueController.dispose();
    _ebitdaController.dispose();
    _totalAssetsController.dispose();
    _rdInvestmentController.dispose();
    _capexController.dispose();
    _sustainabilityInvestmentController.dispose();
    _electricityConsumedController.dispose();
    _renewableEnergyController.dispose();
    _renewableEnergyPctController.dispose();
    _naturalGasController.dispose();
    _dieselController.dispose();
    _scope1Controller.dispose();
    _scope2MarketController.dispose();
    _scope2LocationController.dispose();
    _scope3Controller.dispose();
    _waterWithdrawalController.dispose();
    _waterDischargeController.dispose();
    _waterConsumptionController.dispose();
    _waterRecycledController.dispose();
    _wasteGeneratedController.dispose();
    _wasteDivertedController.dispose();
    _wasteDisposedController.dispose();
    _hazardousWasteController.dispose();
    _totalHeadcountController.dispose();
    _newHiresController.dispose();
    _departuresController.dispose();
    _femaleEmployeesController.dispose();
    _maleEmployeesController.dispose();
    _womenInManagementController.dispose();
    _womenOnBoardController.dispose();
    _totalHoursWorkedController.dispose();
    _recordableInjuriesController.dispose();
    _lostTimeInjuriesController.dispose();
    _totalTrainingHoursController.dispose();
    _trainingInvestmentController.dispose();
    _totalSuppliersController.dispose();
    _suppliersSignedCocController.dispose();
    _suppliersAuditedController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final data = _buildJsonPayload();
      await _apiService.post('/companies', data);
      
      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, dynamic> _buildJsonPayload() {
    return {
      "report_metadata": {
        "report_id": "ESG-${DateTime.now().year}-${_tradeNameController.text.toUpperCase()}-001",
        "company_id": "${_countryController.text.substring(0, 2).toUpperCase()}-${_tradeNameController.text.toUpperCase()}-${DateTime.now().year}",
        "report_date": DateTime.now().toIso8601String(),
        "reporting_period": {
          "start_date": "${DateTime.now().year - 1}-01-01",
          "end_date": "${DateTime.now().year - 1}-12-31",
          "fiscal_year": DateTime.now().year - 1,
          "currency": "EUR"
        },
        "statement_of_use": {
          "framework": "GRI Standards",
          "claim": "in accordance",
          "topic_standards_used": ["GRI 302", "GRI 305", "GRI 303", "GRI 306", "GRI 403", "GRI 404", "GRI 405"]
        }
      },
      "company_profile": {
        "basic_information": {
          "legal_name": _legalNameController.text,
          "trade_name": _tradeNameController.text,
          "headquarters": {
            "address": _addressController.text,
            "country": _countryController.text,
            "region": _regionController.text
          },
          "industry": {
            "sector": _sectorController.text,
            "subsector": _subsectorController.text
          },
          "company_type": "Private Limited Company",
          "year_founded": int.tryParse(_yearFoundedController.text) ?? DateTime.now().year,
          "website": _websiteController.text
        },
        "financial_metrics": {
          "currency": "EUR",
          "annual_revenue": double.tryParse(_annualRevenueController.text) ?? 0,
          "ebitda": double.tryParse(_ebitdaController.text) ?? 0,
          "total_assets": double.tryParse(_totalAssetsController.text) ?? 0,
          "rd_investment": double.tryParse(_rdInvestmentController.text) ?? 0,
          "capex": double.tryParse(_capexController.text) ?? 0,
          "sustainability_investment": double.tryParse(_sustainabilityInvestmentController.text) ?? 0
        }
      },
      "topics": {
        "environmental": {
          "energy_climate": {
            "metrics": {
              "electricity_consumed_kwh": double.tryParse(_electricityConsumedController.text) ?? 0,
              "renewable_energy_purchased_kwh": double.tryParse(_renewableEnergyController.text) ?? 0,
              "renewable_energy_pct": double.tryParse(_renewableEnergyPctController.text) ?? 0,
              "natural_gas_m3": double.tryParse(_naturalGasController.text) ?? 0,
              "diesel_liters": double.tryParse(_dieselController.text) ?? 0,
              "scope1_tco2e": double.tryParse(_scope1Controller.text) ?? 0,
              "scope2_market_tco2e": double.tryParse(_scope2MarketController.text) ?? 0,
              "scope2_location_tco2e": double.tryParse(_scope2LocationController.text) ?? 0,
              "scope3_selected_tco2e": double.tryParse(_scope3Controller.text) ?? 0
            }
          },
          "water": {
            "metrics": {
              "water_withdrawal_m3": double.tryParse(_waterWithdrawalController.text) ?? 0,
              "water_discharge_m3": double.tryParse(_waterDischargeController.text) ?? 0,
              "water_consumption_m3": double.tryParse(_waterConsumptionController.text) ?? 0,
              "water_recycled_m3": double.tryParse(_waterRecycledController.text) ?? 0
            }
          },
          "waste": {
            "metrics": {
              "waste_generated_t": double.tryParse(_wasteGeneratedController.text) ?? 0,
              "waste_diverted_t": double.tryParse(_wasteDivertedController.text) ?? 0,
              "waste_disposed_t": double.tryParse(_wasteDisposedController.text) ?? 0,
              "hazardous_waste_t": double.tryParse(_hazardousWasteController.text) ?? 0
            }
          }
        },
        "social": {
          "workforce": {
            "metrics": {
              "total_headcount": int.tryParse(_totalHeadcountController.text) ?? 0,
              "new_hires": int.tryParse(_newHiresController.text) ?? 0,
              "departures": int.tryParse(_departuresController.text) ?? 0,
              "employees_by_gender": {
                "female": int.tryParse(_femaleEmployeesController.text) ?? 0,
                "male": int.tryParse(_maleEmployeesController.text) ?? 0
              },
              "women_in_management": int.tryParse(_womenInManagementController.text) ?? 0,
              "women_on_board": int.tryParse(_womenOnBoardController.text) ?? 0
            }
          },
          "health_safety": {
            "metrics": {
              "total_hours_worked": double.tryParse(_totalHoursWorkedController.text) ?? 0,
              "recordable_injuries": int.tryParse(_recordableInjuriesController.text) ?? 0,
              "lost_time_injuries": int.tryParse(_lostTimeInjuriesController.text) ?? 0,
              "fatalities": 0
            }
          },
          "training": {
            "metrics": {
              "total_training_hours": double.tryParse(_totalTrainingHoursController.text) ?? 0,
              "training_investment_eur": double.tryParse(_trainingInvestmentController.text) ?? 0
            }
          }
        },
        "governance": {
          "supply_chain": {
            "metrics": {
              "total_suppliers": int.tryParse(_totalSuppliersController.text) ?? 0,
              "suppliers_signed_coc_pct": double.tryParse(_suppliersSignedCocController.text) ?? 0,
              "suppliers_audited_esg_pct": double.tryParse(_suppliersAuditedController.text) ?? 0
            }
          }
        }
      }
    };
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Success!'),
          ],
        ),
        content: const Text(
          'Your ESG data has been submitted successfully. Our system is now processing your report and will generate comprehensive scores and insights.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to main screen
            },
            child: const Text('View Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Custom App Bar matching app style
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.add_business, color: Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                const Text(
                  'Submit ESG Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Step ${_currentStep + 1} of 5',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
                      child: Form(
                        key: _formKey,
                        child: Stepper(
                          currentStep: _currentStep,
                          onStepContinue: () {
                            if (_currentStep < 4) {
                              setState(() => _currentStep++);
                            } else {
                              _submitData();
                            }
                          },
                          onStepCancel: () {
                            if (_currentStep > 0) {
                              setState(() => _currentStep--);
                            }
                          },
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(_currentStep == 4 ? 'Submit Data' : 'Continue'),
                                  ),
                                  const SizedBox(width: 12),
                                  if (_currentStep > 0)
                                    OutlinedButton(
                                      onPressed: details.onStepCancel,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Back'),
                                    ),
                                ],
                              ),
                            );
                          },
                          steps: [
                            Step(
                              title: const Text('Company Information'),
                              isActive: _currentStep >= 0,
                              content: _buildCompanyInfoStep(),
                            ),
                            Step(
                              title: const Text('Financial Metrics'),
                              isActive: _currentStep >= 1,
                              content: _buildFinancialMetricsStep(),
                            ),
                            Step(
                              title: const Text('Environmental Data'),
                              isActive: _currentStep >= 2,
                              content: _buildEnvironmentalStep(),
                            ),
                            Step(
                              title: const Text('Social Data'),
                              isActive: _currentStep >= 3,
                              content: _buildSocialStep(),
                            ),
                            Step(
                              title: const Text('Governance Data'),
                              isActive: _currentStep >= 4,
                              content: _buildGovernanceStep(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoStep() {
    return Column(
      children: [
        _buildTextField(_legalNameController, 'Legal Name*', 'e.g., GreenTech Solutions S.p.A.'),
        _buildTextField(_tradeNameController, 'Trade Name*', 'e.g., GreenTech'),
        _buildTextField(_sectorController, 'Sector*', 'e.g., Technology'),
        _buildTextField(_subsectorController, 'Subsector', 'e.g., Software & IT Services'),
        _buildTextField(_countryController, 'Country*', 'e.g., Italy'),
        _buildTextField(_addressController, 'Address', 'e.g., Via Roma 12, 20100 Milano'),
        _buildTextField(_regionController, 'Region', 'e.g., Lombardy'),
        _buildTextField(_websiteController, 'Website', 'e.g., https://www.company.com'),
        _buildTextField(_yearFoundedController, 'Year Founded', 'e.g., 2014', isNumber: true),
      ],
    );
  }

  Widget _buildFinancialMetricsStep() {
    return Column(
      children: [
        const Text(
          'All amounts in EUR',
          style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),
        _buildTextField(_annualRevenueController, 'Annual Revenue*', 'e.g., 58000000', isNumber: true),
        _buildTextField(_ebitdaController, 'EBITDA', 'e.g., 6900000', isNumber: true),
        _buildTextField(_totalAssetsController, 'Total Assets', 'e.g., 35000000', isNumber: true),
        _buildTextField(_rdInvestmentController, 'R&D Investment', 'e.g., 5000000', isNumber: true),
        _buildTextField(_capexController, 'CAPEX', 'e.g., 3200000', isNumber: true),
        _buildTextField(_sustainabilityInvestmentController, 'Sustainability Investment', 'e.g., 800000', isNumber: true),
      ],
    );
  }

  Widget _buildEnvironmentalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Energy & Climate'),
        _buildTextField(_electricityConsumedController, 'Electricity Consumed (kWh)', 'e.g., 2700000', isNumber: true),
        _buildTextField(_renewableEnergyController, 'Renewable Energy Purchased (kWh)', 'e.g., 2300000', isNumber: true),
        _buildTextField(_renewableEnergyPctController, 'Renewable Energy %', 'e.g., 93', isNumber: true),
        _buildTextField(_naturalGasController, 'Natural Gas (m³)', 'e.g., 38000', isNumber: true),
        _buildTextField(_dieselController, 'Diesel (liters)', 'e.g., 2500', isNumber: true),
        _buildTextField(_scope1Controller, 'Scope 1 Emissions (tCO2e)', 'e.g., 450', isNumber: true),
        _buildTextField(_scope2MarketController, 'Scope 2 Market (tCO2e)', 'e.g., 200', isNumber: true),
        _buildTextField(_scope2LocationController, 'Scope 2 Location (tCO2e)', 'e.g., 1000', isNumber: true),
        _buildTextField(_scope3Controller, 'Scope 3 Selected (tCO2e)', 'e.g., 7600', isNumber: true),
        
        const SizedBox(height: 24),
        _buildSectionTitle('Water'),
        _buildTextField(_waterWithdrawalController, 'Water Withdrawal (m³)', 'e.g., 8400', isNumber: true),
        _buildTextField(_waterDischargeController, 'Water Discharge (m³)', 'e.g., 7500', isNumber: true),
        _buildTextField(_waterConsumptionController, 'Water Consumption (m³)', 'e.g., 7800', isNumber: true),
        _buildTextField(_waterRecycledController, 'Water Recycled (m³)', 'e.g., 1100', isNumber: true),
        
        const SizedBox(height: 24),
        _buildSectionTitle('Waste'),
        _buildTextField(_wasteGeneratedController, 'Waste Generated (tonnes)', 'e.g., 42', isNumber: true),
        _buildTextField(_wasteDivertedController, 'Waste Diverted (tonnes)', 'e.g., 30', isNumber: true),
        _buildTextField(_wasteDisposedController, 'Waste Disposed (tonnes)', 'e.g., 12', isNumber: true),
        _buildTextField(_hazardousWasteController, 'Hazardous Waste (tonnes)', 'e.g., 1', isNumber: true),
      ],
    );
  }

  Widget _buildSocialStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Workforce'),
        _buildTextField(_totalHeadcountController, 'Total Headcount', 'e.g., 430', isNumber: true),
        _buildTextField(_newHiresController, 'New Hires', 'e.g., 90', isNumber: true),
        _buildTextField(_departuresController, 'Departures', 'e.g., 50', isNumber: true),
        _buildTextField(_femaleEmployeesController, 'Female Employees', 'e.g., 180', isNumber: true),
        _buildTextField(_maleEmployeesController, 'Male Employees', 'e.g., 250', isNumber: true),
        _buildTextField(_womenInManagementController, 'Women in Management', 'e.g., 30', isNumber: true),
        _buildTextField(_womenOnBoardController, 'Women on Board', 'e.g., 2', isNumber: true),
        
        const SizedBox(height: 24),
        _buildSectionTitle('Health & Safety'),
        _buildTextField(_totalHoursWorkedController, 'Total Hours Worked', 'e.g., 880000', isNumber: true),
        _buildTextField(_recordableInjuriesController, 'Recordable Injuries', 'e.g., 4', isNumber: true),
        _buildTextField(_lostTimeInjuriesController, 'Lost Time Injuries', 'e.g., 2', isNumber: true),
        
        const SizedBox(height: 24),
        _buildSectionTitle('Training'),
        _buildTextField(_totalTrainingHoursController, 'Total Training Hours', 'e.g., 11000', isNumber: true),
        _buildTextField(_trainingInvestmentController, 'Training Investment (EUR)', 'e.g., 420000', isNumber: true),
      ],
    );
  }

  Widget _buildGovernanceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Supply Chain'),
        _buildTextField(_totalSuppliersController, 'Total Suppliers', 'e.g., 140', isNumber: true),
        _buildTextField(_suppliersSignedCocController, 'Suppliers Signed Code of Conduct (%)', 'e.g., 90', isNumber: true),
        _buildTextField(_suppliersAuditedController, 'Suppliers Audited ESG (%)', 'e.g., 55', isNumber: true),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Ready to Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Click Submit to send your ESG data. Our system will:\n'
                '• Validate your data\n'
                '• Compute GRI & SDG scores\n'
                '• Generate AI insights\n'
                '• Create your ESG dashboard',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : null,
        validator: (value) {
          if (label.contains('*') && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
