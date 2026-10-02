import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exploreLegalHelp),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.whatAreYouLookingFor,
                  prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                  filled: true,
                  fillColor: AppColors.primaryLight.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildCategorySection(
                context,
                title: l10n.legalHelpTitle,
                description: l10n.legalHelpDesc,
                items: [
                  _CategoryItem(l10n.askJurixbotAction, Icons.chat, '/chat'),
                  _CategoryItem('Legal Pathway Generator', Icons.alt_route, '/pathway'), // Will translate properly if added to .arb
                  _CategoryItem('Risk Analyzer', Icons.balance, '/risk'),
                  _CategoryItem(l10n.searchLaws, Icons.search, '/legal'),
                  _CategoryItem(l10n.whatShouldIDo, Icons.help_outline, '/chat'),
                  _CategoryItem(l10n.legalDictionary, Icons.book, '/glossary'),
                ],
              ),
              _buildCategorySection(
                context,
                title: l10n.rightsAndProtectionTitle,
                description: l10n.rightsAndProtectionDesc,
                items: [
                  _CategoryItem(l10n.knowRights, Icons.shield, '/rights'),
                  _CategoryItem(l10n.womensRights, Icons.female, '/rights/women'),
                  _CategoryItem(l10n.consumerRights, Icons.shopping_bag, '/rights/consumer'),
                  _CategoryItem(l10n.propertyRights, Icons.home, '/rights/property'),
                ],
              ),
              _buildCategorySection(
                context,
                title: l10n.govAndWelfareTitle,
                description: l10n.govAndWelfareDesc,
                items: [
                  _CategoryItem(l10n.schemeFinder, Icons.account_balance, '/schemes'),
                  _CategoryItem(l10n.farmerSchemes, Icons.agriculture, '/schemes/farmer'),
                  _CategoryItem(l10n.publicServices, Icons.public, '/schemes/services'),
                ],
              ),
              _buildCategorySection(
                context,
                title: l10n.documentsAndComplaintsTitle,
                description: l10n.documentsAndComplaintsDesc,
                items: [
                  _CategoryItem(l10n.analyzeDocument, Icons.document_scanner, '/analyze'),
                  _CategoryItem(l10n.draftComplaint, Icons.edit_document, '/draft'),
                  _CategoryItem(l10n.explainNotice, Icons.receipt_long, '/analyze'),
                ],
              ),
              _buildCategorySection(
                context,
                title: l10n.findLegalHelpTitle,
                description: l10n.findLegalHelpDesc,
                items: [
                  _CategoryItem(l10n.findLegalAid, Icons.gavel, '/legal-aid'),
                  _CategoryItem(l10n.emergencyHelp, Icons.emergency, '/sos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, {required String title, required String description, required List<_CategoryItem> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Icon(item.icon, color: AppColors.primary),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.divider),
                onTap: () {
                  // Navigate contextually if route exists, else ignore for now
                  try {
                    context.push(item.route);
                  } catch (e) {
                    // Safe fallback if route isn't defined yet
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final String route;

  _CategoryItem(this.title, this.icon, this.route);
}
