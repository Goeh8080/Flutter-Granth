/// App-wide constants that the owner may need to change. Nothing secret lives here: the AI
/// Worker URL is public by design (the Worker holds the provider keys, the app never does).
library;

/// The AI Worker (Cloudflare Workers). `POST {kAiEndpoint}/ask`, `GET {kAiEndpoint}/health`.
/// Override at build time: `flutter build apk --dart-define=AI_ENDPOINT=https://…`.
const String kAiEndpoint = String.fromEnvironment('AI_ENDPOINT', defaultValue: 'https://granth-ai.vedpuran8090.workers.dev');

/// Sent as `X-Granth-Client` on every AI request (the Worker rejects requests without it).
const String kAiClientHeader = 'granth-app-1';

/// The address for complaints, takedown requests and data requests (शिकायत और संपर्क page).
/// TODO(owner): put the real contact e-mail here. It is empty on purpose — the app does NOT
/// invent an address; while it is empty the legal pages say "संपर्क ईमेल जल्द जोड़ा जाएगा".
/// Can also be set at build time: `--dart-define=CONTACT_EMAIL=name@example.com`.
const String kContactEmail = String.fromEnvironment('CONTACT_EMAIL', defaultValue: '');

/// The date every legal page was last updated (shown on each page).
const String kLegalUpdated = '25 अक्टूबर 2026';

/// App version shown on the About page (keep equal to pubspec.yaml; the About page also shows the
/// version read from the installed package when it is available).
const String kAppVersion = '1.0.0';
