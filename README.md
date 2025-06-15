📅 UniSched AI Timetable Generator :- 

UniSched is an intelligent timetable generation system designed specifically for colleges. It automates the creation of class, lab, and instructor schedules while efficiently managing multiple complex constraints.

The system leverages a Genetic Algorithm (GA) approach to optimize timetable generation by considering: 
Multiple departments
Allocation of laboratories and lecture halls
Assignment of qualified instructors
Prevention of conflicts such as lab overlaps or instructor schedule clashes 

By simulating and evaluating numerous possible solutions, UniSched identifies the most optimal timetable configuration without the need for manual planning.


🛠️ Technologies Used
Frontend: Flutter (Dart)
Backend / Algorithm Core: Genetic Algorithm (Implemented in Dart)
Database: Firebase (Firestore, Firebase Auth)

🎯 Features
✅ Fully automated timetable generation using Genetic Algorithms.
✅ Handles multi-department scheduling.
✅ Lab, Lecture, Instructor, and Course constraints are intelligently resolved.
✅ Optimized to avoid clashes (instructors, course overlaps, labs).
✅ Firebase integration for user authentication and timetable storage.

🧬 Genetic Algorithm Overview – UniSched
A Genetic Algorithm (GA) is used to automatically generate optimized college timetables by simulating natural evolution.

🔧 Key Components
generate_random_timetable()
Creates random but valid starting timetables.

fitness(timetable)
Scores timetables based on rules:
Labs: once a week, 2 consecutive slots
Courses: 3–5 times per week, no repeats in a day
Breaks at fixed times
Perfect = 1, Invalid = 0

crossover(parent1, parent2)
Mixes two timetables to create a new one (inherits a day from each).

mutate(timetable)
Randomly changes one part of a timetable (e.g., replace a course/lab).

run_genetic_algorithm()
Runs the full process:
Create a population
Score them
Keep the best ones
Create new ones via crossover & mutation
Repeat until an optimal timetable is found

🔍 Why Use Genetic Algorithm (GA)?
Handles Complex Constraints:
GA can easily manage multiple conflicting constraints (labs, instructors, rooms, departments).

Searches Large Solution Space:
Timetable generation has millions of possible combinations — GA efficiently searches for the best one.

Avoids Manual Trial & Error:
No need to manually adjust — GA automatically improves solutions over generations.

Flexible & Scalable:
Can handle small or large colleges, multiple departments, and future changes with ease.

Good for NP-Hard Problems:
Timetable generation is an NP-Hard problem — GA is well-suited for such complex optimization tasks.

🔍 Problem Solved
❌ No more manual timetable design.
❌ Avoid human error in handling multiple constraints.
✅ Timetable generation within seconds/minutes.
✅ Supports scaling to multiple departments and faculties.

/UNISCHED
│
├── /lib
│   ├── main.dart                # Application entry point
│   ├── /page                     # Informational pages
│   │     └── team.dart           # Displays team members and their contributions
│   ├── /admin                    # Admin management screens
│   │     ├── add_instructor.dart
│   │     ├── add_subject.dart
│   │     ├── add_lab.dart
│   │     ├── assign_teacher.dart
│   │     ├── admin_page.dart
│   │     └── list.dart           # Displays lists of instructors, subjects, labs
│   ├── /home                     # Core functionality (Timetable generation and views)
│   │     ├── create_time.dart    # Genetic Algorithm implementation for timetable creation
│   │     ├── homepage.dart
│   │     ├── instructor.dart
│   │     └── view.dart           # Timetable viewer
│   └── /landing                  # Authentication and welcome screens
│         ├── login.dart
│         ├── register.dart
│         └── welcome.dart
│
├── /assets                # Fonts, Images
├── pubspec.yaml           # Dart Dependencies
└── README.md              # Project Info (This File)


How to Run
git clone https://github.com/Sourabhsalvi45/UniSched-AI.git
cd unisched-ai-timetable
flutter pub get
flutter run

🤝 Contributions
Aryman Sawant
Aniruddha Pednekar
Vedant Naik





