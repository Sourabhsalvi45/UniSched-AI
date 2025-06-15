import 'dart:math';

// -------------------------
// Data Definitions & Models
// -------------------------

// Courses data: each semester maps to sections, each with a list of courses and labs.
final Map<String, dynamic> COURSES = {
  "Odd Semester": {
    "SE": {
      "course": ["EM 3", "DSGT", "DS", "DLCOA", "CG", "JAVA", "MINI PROJECT 1A", "EMT"],
      "lab": ["DS LAB", "DLCOA LAB", "CG LAB", "JAVA LAB"]
    },
    "TE": {
      "course": ["CN", "WC", "AI", "DWHM", "DLOC 1", "BCE 2", "MINI PROJECT 2A"],
      "lab": ["WCN LAB", "AI LAB", "DWHM LAB", "BCE 2 LAB"]
    },
    "BE": {
      "course": ["DL", "BDA", "DLOC 3", "DLOC 4", "ILOC 1", "MAJOR PROJECT 1"],
      "lab": ["DL LAB", "BDA LAB", "DLOC 3 LAB", "DLOC 4 LAB"]
    }
  },
  "Even Semester": {
    "SE": {
      "course": ["EM 4", "AOA", "DBMS", "OS", "MP", "PYTHON", "MINI PROJECT 1B", "EMT"],
      "lab": ["AOA LAB", "DBMS LAB", "OS LAB", "MP LAB", "PYTHON LAB"]
    },
    "TE": {
      "course": ["DAV", "CSS", "SEPM", "ML", "DLOC 2", "MINI PROJECT 2B"],
      "lab": ["DAV LAB", "CSS LAB", "SEPM LAB", "ML LAB", "CC LAB"]
    },
    "BE": {
      "course": ["AAI", "DLOC 5", "DLOC 6", "ILOC 2", "MAJOR PROJECT 2"],
      "lab": ["AAI LAB", "DLOC 5 LAB", "DLOC 6 LAB"]
    }
  }
};

// Instructors and the subjects they teach.
final Map<String, dynamic> INSTRUCTORS = {
  "H.N.KELKAR": {"course": ["EM 3", "EM 4"], "lab": ["EMT", "EM4T"]},
  "P.S.SOMAN": {"course": ["DSGT"], "lab": []},
  "S.R.TELI": {"course": ["DS", "RL", "DLOC 5"], "lab": ["AI", "CSS", "RL", "DLOC 5"]},
  "V.V.NIMBALKAR": {"course": ["DLCOA", "MP"], "lab": ["DLCOA", "MP"]},
  "A.N.SHETYE": {"course": ["CG", "PYTHON", "DAV", "DLOC 4"], "lab": ["CG", "PYTHON", "DAV", "DLOC 4"]},
  "S.S.AATHLYE": {"course": ["JAVA", "DLOC 3", "DLOC 6"], "lab": ["JAVA", "CSS", "DLOC 3", "DLOC 6"]},
  "G.N.SAWANT": {"course": ["DWHM", "ML"], "lab": ["DWHM", "ML"]},
  "M.A.JADHAV": {"course": ["OS", "CN", "CSS"], "lab": ["OS", "WCN"]},
  "M.G.GORE": {"course": ["DBMS", "SEPM"], "lab": ["DBMS", "SEPM"]},
  "R.P.TIVAREKAR": {"course": ["AI", "DL", "AAI"], "lab": ["DL", "AAI"]},
  "M.M.HATISKAR": {"course": ["AOA", "DLOC 2", "BDA"], "lab": ["AOA", "BDA"]},
  "M.K.ZAGADE": {"course": ["WC"], "lab": ["CC"]},
  "S.B.KULKARNI": {"course": ["DLOC 1"], "lab": []},
  "A.K.BANSODE": {"course": ["ILOC 2"], "lab": []},
  "A.P.PRABHUDESAI": {"course": ["BCE 2"], "lab": ["BCE 2"]},
  "S.V.CHOUGALE": {"course": ["ILOC 1"], "lab": []}
};

// Days and time slots.
final List<String> DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
final List<String> TIME_SLOTS = [
  "9:15-10:15",
  "10:15-11:15",
  "11:15-11:30 (Break)",
  "11:30-12:30",
  "12:30-1:30",
  "1:30-2:15 (Break)",
  "2:15-3:15",
  "3:15-4:15",
  "4:15-5:15"
];

// Genetic algorithm parameters.
const int POPULATION_SIZE = 50;
const int GENERATIONS = 1000;
const double MUTATION_RATE = 0.1;

// A simple model to represent a subject or lab.
class ClassItem {
  String name;
  String type; // "course" or "lab"
  ClassItem({required this.name, required this.type});
}

// Sessions required per course (default is 3 if not mentioned here).
final Map<String, int> requiredSessions = {
  "EMT": 4,
  "MINI PROJECT 1A": 5,
  "MINI PROJECT 1B": 5,
  "MINI PROJECT 2A": 4,
  "MINI PROJECT 2B": 4,
  "MAJOR PROJECT 1": 4,
  "MAJOR PROJECT 2": 4,
};

// -------------------------
// Timetable Generator Class
// -------------------------

class TimetableGenerator {
  // Creates an empty timetable (map from day to list of time slot entries)
  static Map<String, List<String>> createEmptyTimetable() {
    Map<String, List<String>> timetable = {};
    for (var day in DAYS) {
      timetable[day] = List.filled(TIME_SLOTS.length, "");
    }
    return timetable;
  }

  // Convert selected course data into a list of ClassItems.
  static List<ClassItem> setupClasses(Map<String, dynamic> selectedCourses) {
    List<ClassItem> list = [];
    for (var course in selectedCourses["course"]) {
      list.add(ClassItem(name: course, type: "course"));
    }
    for (var lab in selectedCourses["lab"]) {
      list.add(ClassItem(name: lab, type: "lab"));
    }
    return list;
  }

  // Fitness function: returns 1 if the timetable meets all criteria; otherwise 0.
  static int fitness(Map<String, List<String>> timetable, List<ClassItem> classes) {
    // Check that break slots are correctly assigned.
    for (var day in DAYS) {
      if (timetable[day]![2] != "Break" || timetable[day]![5] != "Break") {
        return 0;
      }
    }
    // Check labs.
    Map<String, int> labCounter = {};
    for (var cls in classes) {
      if (cls.type == "lab") {
        labCounter[cls.name] = 0;
      }
    }
    for (var day in DAYS) {
      List<int> labSlots = [];
      for (int i = 0; i < TIME_SLOTS.length; i++) {
        if (timetable[day]![i].contains("LAB")) {
          labSlots.add(i);
        }
      }
      if (labSlots.length > 2 || (labSlots.length == 2 && (labSlots[1] - labSlots[0] != 1))) {
        return 0;
      }
      for (var slot in labSlots) {
        String labName = timetable[day]![slot];
        labCounter[labName] = (labCounter[labName] ?? 0) + 1;
      }
    }
    for (var count in labCounter.values) {
      if (count != 2) return 0;
    }
    // Count course frequencies.
    Map<String, int> courseCounter = {};
    for (var cls in classes) {
      if (cls.type == "course") {
        courseCounter[cls.name] = 0;
      }
    }
    for (var day in DAYS) {
      Set<String> scheduled = {};
      for (var slot in timetable[day]!) {
        if (slot == "" || slot == "Break") continue;
        // Find course by exact name match.
        ClassItem? found = classes.firstWhere(
                (c) => c.name == slot,
            orElse: () => ClassItem(name: "", type: ""));
        if (found.name != "" && found.type == "course") {
          courseCounter[found.name] = (courseCounter[found.name] ?? 0) + 1;
          if (scheduled.contains(found.name)) return 0;
          scheduled.add(found.name);
        }
      }
    }
    for (var course in courseCounter.keys) {
      int req = requiredSessions[course] ?? 3;
      if (courseCounter[course] != req) return 0;
    }
    return 1;
  }

  // Generate a random timetable for the given section type.
  static Map<String, List<String>> generateRandomTimetable(
      List<ClassItem> classes, String sectionType) {
    Map<String, List<String>> timetable = createEmptyTimetable();
    List<ClassItem> courseItems = classes.where((c) => c.type == "course").toList();
    List<ClassItem> labItems = classes.where((c) => c.type == "lab").toList();
    Random random = Random();

    // Schedule labs.
    for (var lab in labItems) {
      bool placed = false;
      int attempts = 0;
      while (!placed && attempts < 100) {
        String day = DAYS[random.nextInt(DAYS.length)];
        if (timetable[day]!.any((slot) => slot.contains("LAB"))) {
          attempts++;
          continue;
        }
        List<int> possibleSlots;
        if (sectionType == "SE") {
          possibleSlots = [0, 1];
        } else if (sectionType == "TE") {
          possibleSlots = [3, 4];
        } else {
          // BE
          possibleSlots = [6, 7];
        }
        if (timetable[day]![possibleSlots[0]] == "" &&
            timetable[day]![possibleSlots[1]] == "") {
          timetable[day]![possibleSlots[0]] = lab.name;
          timetable[day]![possibleSlots[1]] = lab.name;
          placed = true;
        }
        attempts++;
      }
    }

    // Schedule courses.
    for (var course in courseItems) {
      int required;
      if (["EMT", "MINI PROJECT 2A", "MINI PROJECT 2B"].contains(course.name)) {
        required = 4;
      } else if (["MINI PROJECT 1A", "MINI PROJECT 1B"].contains(course.name)) {
        required = 5;
      } else {
        required = 3;
      }
      int timesScheduled = 0;
      int attempts = 0;
      while (timesScheduled < required && attempts < 100) {
        String day = DAYS[random.nextInt(DAYS.length)];
        if (timetable[day]!.contains(course.name)) {
          attempts++;
          continue;
        }
        List<int> possibleSlots = [];
        for (int i = 0; i < TIME_SLOTS.length; i++) {
          if (i == 2 || i == 5) continue;
          possibleSlots.add(i);
        }
        possibleSlots.shuffle(random);
        for (var slot in possibleSlots) {
          if (timetable[day]![slot] == "") {
            timetable[day]![slot] = course.name;
            timesScheduled++;
            break;
          }
        }
        attempts++;
      }
    }

    // Add break times.
    for (var day in DAYS) {
      timetable[day]![2] = "Break";
      timetable[day]![5] = "Break";
    }
    return timetable;
  }

  // Crossover: mix two timetables by replacing one random day.
  static Map<String, List<String>> crossover(Map<String, List<String>> t1,
      Map<String, List<String>> t2) {
    Map<String, List<String>> child = {};
    t1.forEach((key, value) {
      child[key] = List.from(value);
    });
    Random random = Random();
    String crossoverDay = DAYS[random.nextInt(DAYS.length)];
    child[crossoverDay] = List.from(t2[crossoverDay]!);
    return child;
  }

  // Mutation: change a random slot in the timetable.
  static Map<String, List<String>> mutate(
      Map<String, List<String>> timetable, List<ClassItem> classes) {
    Map<String, List<String>> mutated = {};
    timetable.forEach((key, value) {
      mutated[key] = List.from(value);
    });
    Random random = Random();
    String day = DAYS[random.nextInt(DAYS.length)];
    List<int> possibleSlots = List.generate(TIME_SLOTS.length, (i) => i)
        .where((i) => i != 2 && i != 5)
        .toList();
    int slot = possibleSlots[random.nextInt(possibleSlots.length)];
    String currentClass = mutated[day]![slot];
    if (currentClass == "" || currentClass == "Break") return mutated;
    ClassItem? cls = classes.firstWhere(
            (c) => c.name == currentClass,
        orElse: () => ClassItem(name: "", type: ""));
    if (cls.name == "") return mutated;
    if (cls.type == "course") {
      List<ClassItem> options =
      classes.where((c) => c.type == "course" && c.name != cls.name).toList();
      if (options.isNotEmpty) {
        ClassItem newCls = options[random.nextInt(options.length)];
        mutated[day]![slot] = newCls.name;
      }
    } else if (cls.type == "lab") {
      if (slot < TIME_SLOTS.length - 1 &&
          mutated[day]![slot + 1] == currentClass) {
        List<ClassItem> options =
        classes.where((c) => c.type == "lab" && c.name != cls.name).toList();
        if (options.isNotEmpty) {
          ClassItem newLab = options[random.nextInt(options.length)];
          mutated[day]![slot] = newLab.name;
          mutated[day]![slot + 1] = newLab.name;
        }
      }
    }
    return mutated;
  }

  // Run the genetic algorithm to generate a valid timetable.
  static Map<String, List<String>> runGeneticAlgorithm(
      List<ClassItem> classes, String sectionType) {
    List<Map<String, List<String>>> population = [];
    for (int i = 0; i < POPULATION_SIZE; i++) {
      population.add(generateRandomTimetable(classes, sectionType));
    }
    Random random = Random();
    for (int gen = 0; gen < GENERATIONS; gen++) {
      population.sort((a, b) =>
          fitness(b, classes).compareTo(fitness(a, classes)));
      if (fitness(population[0], classes) == 1) {
        return population[0];
      }
      List<Map<String, List<String>>> survivors =
      population.sublist(0, POPULATION_SIZE ~/ 2);
      List<Map<String, List<String>>> children = [];
      while (children.length < POPULATION_SIZE - survivors.length) {
        Map<String, List<String>> parent1 =
        survivors[random.nextInt(survivors.length)];
        Map<String, List<String>> parent2 =
        survivors[random.nextInt(survivors.length)];
        Map<String, List<String>> child = crossover(parent1, parent2);
        if (random.nextDouble() < MUTATION_RATE) {
          child = mutate(child, classes);
        }
        children.add(child);
      }
      population = [...survivors, ...children];
    }
    return population[0];
  }

  // Given a subject name, find its instructor.
  static String getInstructor(String subject) {
    String normalizedSubject = subject.replaceAll(" LAB", "");
    for (var instructor in INSTRUCTORS.keys) {
      List<dynamic> courses = INSTRUCTORS[instructor]["course"];
      List<dynamic> labs = INSTRUCTORS[instructor]["lab"];
      if (courses.contains(normalizedSubject) || labs.contains(normalizedSubject)) {
        return instructor;
      }
    }
    return "Unknown";
  }

  // Main method to generate timetables for all sections.
  // Returns a map with keys "SE", "TE", and "BE".
  static Map<String, Map<String, List<String>>> generateTimetables(String semester) {
    Map<String, Map<String, List<String>>> timetables = {};
    List<String> sections = ["SE", "TE", "BE"];
    for (var section in sections) {
      Map<String, dynamic> selectedCourses = COURSES[semester][section];
      List<ClassItem> classes = setupClasses(selectedCourses);
      Map<String, List<String>> tt = runGeneticAlgorithm(classes, section);
      // Append instructor information.
      for (var day in DAYS) {
        for (int i = 0; i < TIME_SLOTS.length; i++) {
          String subject = tt[day]![i];
          if (subject != "" && subject != "Break") {
            String instr = getInstructor(subject);
            tt[day]![i] = "$subject ($instr)";
          }
        }
      }
      timetables[section] = tt;
    }
    return timetables;
  }
}
