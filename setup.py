import os

folders = [
    "backend/app/api/v1",
    "backend/app/core",
    "backend/app/db/models",
    "backend/app/db/migrations",
    "backend/app/schemas",
    "backend/app/services",
    "backend/app/intelligence",
    "backend/app/rag",
    "backend/app/prompts",
    "backend/app/workers",
    "backend/tests",
    "lib/app/theme",
    "lib/app/constants",
    "lib/core/network",
    "lib/core/storage",
    "lib/core/errors",
    "lib/core/utils",
    "lib/core/permissions",
    "lib/features/auth",
    "lib/features/onboarding",
    "lib/features/home",
    "lib/features/chat",
    "lib/features/legal_search",
    "lib/features/rights",
    "lib/features/drafts",
    "lib/features/documents",
    "lib/features/voice",
    "lib/features/updates",
    "lib/features/profile",
    "lib/models",
    "lib/services",
    "lib/providers",
    "lib/widgets",
    "lib/l10n"
]

for folder in folders:
    os.makedirs(folder, exist_ok=True)
