import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.gavel, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'JuriXBot',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryText),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.primaryText),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hello,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.howCanWeHelpToday,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 24),
              
              // HERO AI ASSISTANT SECTION
              _buildHeroAssistant(context, l10n),
              
              const SizedBox(height: 32),
              
              // QUICK ACTIONS
              Text(
                l10n.quickHelp,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                childAspectRatio: 2.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQuickAction(context, l10n.askJurixbotAction, Icons.chat, '/chat'),
                  _buildQuickAction(context, l10n.analyzeDocument, Icons.document_scanner, '/analyze'),
                  _buildQuickAction(context, l10n.makeComplaint, Icons.edit_document, '/draft'),
                  _buildQuickAction(context, l10n.knowRights, Icons.shield, '/rights'),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // EXPLORE CATEGORIES SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.exploreLegalHelp,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.go('/explore'),
                    child: Text(l10n.seeAll, style: const TextStyle(color: AppColors.accent)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              _buildExploreCategory(context, l10n.legalHelpTitle, '/explore'),
              _buildExploreCategory(context, l10n.rightsAndProtectionTitle, '/explore'),
              _buildExploreCategory(context, l10n.govAndWelfareTitle, '/explore'),
              _buildExploreCategory(context, l10n.documentsAndComplaintsTitle, '/explore'),
              
              const SizedBox(height: 32),
              
              // LEGAL UPDATE (Just One)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.latestLegalUpdate,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.go('/updates'),
                    child: Text(l10n.viewAll, style: const TextStyle(color: AppColors.accent)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              _buildLatestUpdateCard(context, l10n),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroAssistant(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.balance, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.howCanWeHelpHero,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.describeLegalProblem,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.go('/chat'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.tellUsWhatHappened,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.mic, color: AppColors.primaryDark, size: 20),
                  const SizedBox(width: 12),
                  const Icon(Icons.attach_file, color: AppColors.primaryDark, size: 20),
                  const SizedBox(width: 12),
                  const Icon(Icons.send, color: AppColors.accent, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreCategory(BuildContext context, String title, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primaryDark),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.divider),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestUpdateCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              l10n.newLawBadge,
              style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.bnsTakesEffect,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryText),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bnsDescription,
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
