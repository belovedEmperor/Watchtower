# Schedule Generation Flow

## Purpose
Describe the end-to-end flow for generating student schedules.

## Flow Diagram
```mermaid
flowchart TD
    A[Student uploads Degree Works audit PDF] --> B[Parse PDF into structured data]
    B --> C[Student reviews parsed data for accuracy]
    C --> D{Any corrections needed?}
    D -->|Yes| E[Student manually fixes/enters corrections<br/>ex: fulfilled requirements, missing completed courses]
    E --> F[Save corrected academic profile]
    D -->|No| F

    F --> G[Ask student for desired classes]
    G --> H[Student selects departments and/or specific courses]
    H --> I[Construct class domain<br/>eligible courses based on requirements, completed classes, and selected interests]

    I --> J[Ask for hard availability constraints<br/>days/times absolutely unavailable]
    J --> K[Ask for credit range constraint]

    K --> L[Ask for schedule preferences - checkboxes]
    L --> L1[Back-to-back classes]
    L --> L2[Morning classes <7:00-10:50 AM>]
    L --> L3[Mid-day classes <11:00 AM-3:50 PM>]
    L --> L4[Evening classes <4:00-9:50 PM>]
    L --> L5[Minimize days on campus]
    L --> L6[Prefer in-person]
    L --> L7[Prefer remote]

    L1 --> M[Build MaxSAT model<br/>hard constraints + soft preferences]
    L2 --> M
    L3 --> M
    L4 --> M
    L5 --> M
    L6 --> M
    L7 --> M

    M --> N[Run MaxSAT solver for selected semester]
    N --> O[Generate top 3 satisfiable schedule options]
    O --> P[Present 3 schedule options to student]
```

## Step Details
1. Student uploads Degree Works PDF
2. Parse and review
3. Collect constraints/preferences
4. Run MaxSAT
5. Return top 3 schedules

## Inputs
- Degree audit PDF
- Student corrections
- Desired classes/departments
- Unavailable times
- Credit range
- Preferences

## Outputs
- 3 satisfiable schedule options for selected semester

## Open Questions
