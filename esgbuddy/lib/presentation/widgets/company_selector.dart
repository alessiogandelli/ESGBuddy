import 'package:flutter/material.dart';
import '../../models/company_esg_data.dart';

/// Shared company selector widget used across dashboard and stakeholder screens
class CompanySelector extends StatelessWidget {
  final CompanyESGData selectedCompany;
  final List<CompanyESGData> companies;
  final Function(CompanyESGData) onCompanyChanged;

  const CompanySelector({
    super.key,
    required this.selectedCompany,
    required this.companies,
    required this.onCompanyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(Icons.business, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedCompany.companyId,
                icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                items: companies.map((company) {
                  return DropdownMenuItem<String>(
                    value: company.companyId,
                    child: Text(
                      company.basicInfo.tradeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newCompanyId) {
                  if (newCompanyId != null) {
                    final newCompany = companies.firstWhere(
                      (c) => c.companyId == newCompanyId,
                    );
                    onCompanyChanged(newCompany);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
