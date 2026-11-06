# Student privacy and security beta review

Reviewed against `origin/main` at `f5cb2f1` on 2026-11-06. The review used only
synthetic upload bytes and repository fixtures. It did not access production,
secrets, live student records, or real DegreeWorks audits.

## Data flow and current trust boundaries

The beta's primary planner is intentionally public and says "No account needed."
Catalog search, schedule generation, and `POST /AuditParse` therefore do not have
per-student authorization. A DegreeWorks PDF travels over the same-origin
CloudFront/API Gateway path to the parser Lambda. Spring writes the multipart
body to a randomly named temporary file, parses it, returns structured degree
data, and attempts deletion in a `finally` block. There is no code path that
stores the raw PDF or parsed audit in PostgreSQL.

After confirmation, the browser holds parsed audit data. This change moves that
data from persistent `localStorage` to tab-scoped `sessionStorage`, removes any
legacy `watchtower_audit_data` keys on access, and no longer retains the uploaded
filename. Selected manual-planner sections and smart-builder preferences still
use `localStorage`; those records can reveal planning intent but do not contain
the raw audit.

The dormant account API stores EMPLID, name, CUNY email, a bcrypt password hash,
and optional Microsoft identity linkage. Its PostgreSQL session contains EMPLID
and, briefly, OAuth state/nonce. The cookie lasts seven days. Profile and demo
audit routes require a server-side session; catalog routes remain public.

## Implemented defenses

- Audit data is now session-only in the browser. Legacy persistent audit keys
  are deleted rather than migrated, avoiding disclosure of an old student's
  audit on a shared device.
- The browser and server agree on a 5 MB upload maximum. The parser also requires
  a `.pdf` name and `%PDF-` signature before invoking PDFBox.
- The runtime upload endpoint no longer exposes the filename-triggered
  `ADMIN4082.txt` test path. Text fixtures remain available to parser unit tests
  without being remotely uploadable.
- Parser response bodies carry `Cache-Control: no-store`; malformed-PDF errors
  no longer return PDFBox exception details or the client filename.
- Temporary audit files are randomly named and deleted after success or failure.
  Synthetic tests assert deletion after the parser is called.
- Spring's error response and request-detail settings explicitly exclude
  exception messages, stack traces, binding details, and request bodies.
- Parser CORS defaults to `http://localhost:5173`, accepts a comma-separated
  allowlist, and applies only to `POST /AuditParse` rather than every method and
  path.
- Account login, registration, and Microsoft callback rotate the session ID
  before authentication. User-route responses are non-cacheable.
- Production backend CORS now accepts only configured origins (falling back to
  the exact `PUBLIC_APP_ORIGIN`), not every `*.cloudfront.net` distribution.
  The session cookie is `HttpOnly`, `Secure` in production, and `SameSite=Lax`
  for the deployed same-origin CloudFront topology.
- Locked dependency updates clear all npm advisories: Vite 6.4.5,
  source-map-js 1.2.2, body-parser 1.20.9, proxy-addr 2.0.8, and qs 6.16.2.
  Nodemon is pinned to the non-advisory 3.1.11 release.

## Reproduction and verification

Synthetic controller tests cover a renamed non-PDF, the former plaintext test
filename, parser-error redaction, `no-store`, and deletion of the temporary file.
No test fixture includes a student name, EMPLID, or real audit content.

- `npm run build`: passed with Vite 6.4.5.
- Root `npm audit` and `npm audit --omit=dev`: zero advisories.
- Backend `node --check src/index.js` and `node --check src/routes/users.js`:
  passed.
- Backend `npm audit` and `npm audit --omit=dev`: zero advisories.
- Backend `npm test`: 3/4 existing catalog tests passed. The remaining test is a
  pre-existing assertion mismatch: the route now supplies a sixth empty
  attribute-filter parameter, while the test expects five. No privacy-owned file
  changes that query or test.
- Parser tests could not run in this workspace because Java 17 is unavailable.
  Maven and dependencies downloaded successfully, then the wrapper stopped on
  missing `JAVA_HOME`. CI must run `./mvnw test` before approval.

## Review-required risks and decisions

1. **Identity proofing is not beta-ready if accounts are exposed.** Local
   registration accepts any eight-digit EMPLID plus a syntactically valid
   `@login.cuny.edu` address without proving control of either. Microsoft sign-in
   only links an already-created local account by matching email. Decide whether
   to remove local registration, require verified Microsoft identity before
   account creation, or keep the account API inaccessible in the public beta.
2. **There is no documented student-record deletion or retention policy.** User
   profile and Microsoft-link records are indefinite; sessions last seven days.
   Choose retention periods and a deletion/support process before collecting
   real account data.
3. **The parser and solver are public by product design.** API Gateway supplies a
   global burst limit of 10 and rate limit of 5 requests/second, but there is no
   per-user abuse control, malware scanning, or PDF complexity/page limit beyond
   5 MB and the Lambda timeout. Decide whether anonymous beta use is acceptable
   and monitor timeout/error/cost rates.
4. **Production parser CORS remains broad in infrastructure configuration.**
   `CORS_ALLOWED_ORIGINS=https://*.cloudfront.net` overrides the safer application
   default. Replace it with the exact distribution origin in a separately
   reviewed infrastructure change. CORS is not authorization; the endpoint is
   public regardless.
5. **The API Gateway execute endpoint is enabled.** It bypasses CloudFront's
   response-header policy, though it remains HTTPS and throttled. Decide whether
   operational access requires it; disabling it is an infrastructure change.
6. **Planning state outlives a browser session.** Selected sections, preferences,
   setup markers, and an opaque scheduling ID remain in `localStorage`. Align the
   UI promise and retention behavior, provide a visible "clear all planning
   data" action, and avoid using an EMPLID in any future storage key.
7. **Application logs need production confirmation.** API Gateway access logs do
   not include request bodies and CloudWatch retention is configured for 14
   days. Backend error objects may still contain database/internal diagnostics,
   though request bodies and audits are not explicitly logged. Confirm actual
   Lambda/Spring log output with a synthetic upload and synthetic failed login;
   do not paste logs containing tokens or student data into an issue or PR.
8. **No dedicated login rate limiter exists.** The global API Gateway throttle
   provides coarse protection only. Add per-IP/account backoff before enabling
   password login broadly, with a product decision on lockouts and support.

## Manual checks before beta approval

- In a non-production environment, upload a synthetic PDF and verify the response
  is `Cache-Control: no-store`, the file is rejected above 5 MB, renamed text is
  rejected, and no filename or PDF content appears in logs.
- Close the upload tab, reopen the app, and confirm audit requirements are gone;
  also confirm legacy `watchtower_audit_data*` local-storage keys are removed.
- Verify password and Microsoft login issue a new `sid`, logout invalidates it,
  cross-site POSTs do not carry it, and only the exact configured production
  origin receives credentialed CORS headers.
- Run the full parser suite with Java 17 and inspect the PR's GitHub Actions
  verification result. Do not deploy this branch or merge it without owner
  review because it changes authentication and student-data handling.
