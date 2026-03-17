# Schedule Generation Flow

## Purpose
Describe the end-to-end flow for generating student schedules.

## Flow Diagram
```mermaid
graph TD
    A[Student uploads Degree Works audit PDF] --> B[Parse PDF into structured data]
    B --> C[Student reviews parsed data for accuracy]
    C --> D{Any corrections needed?}
    D -->|Yes| E[Student manually fixes/enters corrections<br/>ex: fulfilled requirements, missing completed courses]
    E --> F[Save corrected academic profile]
    D -->|No| F 

    F --> H[Ask student for class prefrences: can be from dept or specific courses]
    H --> I[Construct class domain<br/>eligible courses based on requirements, completed classes, offered classes, and selected interests]

    I --> K[Ask student for times unavailable and credit range : hard constraints]

    K --> PREFS[Collect schedue prefrences via selecting multiple check box's]
    
    subgraph PREFS[prefrence options - user may select as many as they'd like]
        L1[Prefers back-to-back classes]
        L2[Likes morning classes 7:00-10:50 AM]
        L3[Likes mid-day classes 11:00 AM-3:50 PM]
        L4[Likes evening classes 4:00-9:50 PM]
        L5[Minimize days on campus]
        L6[Prefer in-person]
        L7[Prefer remote]
    end

    PREFS --> M[Build MaxSAT model<br/>hard constraints + soft preferences]


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
