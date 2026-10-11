import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../app/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': query});
      _isTyping = true;
    });
    
    _textController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Intelligent contextual response delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      String aiResponse = "";
      final qLower = query.toLowerCase();

      if (qLower.contains('jxb-') || qLower.contains('complaint') || qLower.contains('status') || qLower.contains('track') || qLower.contains('case')) {
        aiResponse = "To check the status of your complaint:\n\n"
            "1. Tap 'My Complaints' in your Profile (or tap the Drafts tab below).\n"
            "2. Select your Case ID (e.g. JXB-2026-A1B2C) to view the Interactive Case Map, assigned government office contact info, and the 11-step Case Journey Timeline!";
      } else if (qLower.contains('police') || qLower.contains('fir')) {
        aiResponse = "Under CrPC Section 154 and BNSS Section 173, police officers are legally obligated to register an FIR for cognizable offences. You can also file a formal grievance using JuriXBot's Complaint Registration tool.";
      } else if (qLower.contains('landlord') || qLower.contains('rent') || qLower.contains('deposit')) {
        aiResponse = "Under the Tamil Nadu Regulation of Rights and Responsibilities of Landlords and Tenants Act, a landlord cannot withhold your security deposit without valid justification or evict you without notice.";
      } else {
        aiResponse = "Thank you for asking JuriXBot! Under Indian law, citizens have specific legal protections and official grievance redressal mechanisms. Describe your issue in detail or use our Location-Based Complaint Registration tool on the Home screen.";
      }

      setState(() {
        _isTyping = false;
        _messages.add({'role': 'assistant', 'content': aiResponse});
      });
      
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.askJurixbot),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gavel, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      l10n.howCanIHelpQueries,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.jurixbotIsTyping, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
              ),
            ),
          _buildInputArea(l10n),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    final theme = Theme.of(context);
    final content = msg['content'] ?? '';
    final isTrackingAdvice = content.contains('My Complaints') || content.contains('Case ID');

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.isEmpty && !isUser ? '...' : content,
              style: TextStyle(
                color: isUser ? Colors.white : theme.colorScheme.onSurface,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            if (isTrackingAdvice) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => context.push('/complaints'),
                icon: const Icon(Icons.track_changes, size: 16),
                label: const Text('Open Tracking Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: l10n.askLegalQuestionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                maxLines: null,
                enabled: !_isTyping,
                onSubmitted: (text) => _sendMessage(text),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: _isTyping ? Colors.grey : Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _isTyping ? null : () => _sendMessage(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
