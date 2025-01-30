import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// variables.dart
Map<String, dynamic> pageData = {
  'robotNum': '',
  'matchNum': '',
  'startPosition': '',
  'submittedBy': '', 
  'auto': {
    'coral': {
      'L4': {'score': 0, 'miss': 0},
      'L3': {'score': 0, 'miss': 0},
      'L2': {'score': 0, 'miss': 0},
      'L1': {'score': 0, 'miss': 0},
    },
    'algae': {
      'score': 0,
      'miss': 0,
    },
    'floorStation': {
      'floor': 0,
      'station': 0,
      'miss': 0,
    },
  },
  'teleop': {
    'coral': {
      'L4': {'score': 0, 'miss': 0},
      'L3': {'score': 0, 'miss': 0},
      'L2': {'score': 0, 'miss': 0},
      'L1': {'score': 0, 'miss': 0},
    },
    'algae': {
      'score': 0,
      'miss': 0,
    },
    'floorStation': {
      'floor': 0,
      'station': 0,
      'miss': 0,
    },
  },
  'endgame': {
    'cageParkStatus': 'None',
    'failed': false,
    'disabled': false,
    'playingDefense': false,
    'comments': '',
  }
};

// Add this function to submit data to Firebase
Future<void> submitMatchData() async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null) {
    throw Exception('No user signed in');
  }

  // Add the current user's email to the pageData
  pageData['submittedBy'] = currentUser.email ?? 'Unknown';

  final String matchPath = 'RCR2025/matches/${pageData['matchNum']}/${pageData['robotNum']}';
  
  try {
    await dbRef.child(matchPath).set(pageData);
    // Clear the data after successful submission
    pageData = {
      'robotNum': '',
      'matchNum': '',
      'startPosition': '',
      'submittedBy': '', 
      'auto': {
        'coral': {
          'L4': {'score': 0, 'miss': 0},
          'L3': {'score': 0, 'miss': 0},
          'L2': {'score': 0, 'miss': 0},
          'L1': {'score': 0, 'miss': 0},
        },
        'algae': {
          'score': 0,
          'miss': 0,
        },
        'floorStation': {
          'floor': 0,
          'station': 0,
          'miss': 0,
        },
      },
      'teleop': {
        'coral': {
          'L4': {'score': 0, 'miss': 0},
          'L3': {'score': 0, 'miss': 0},
          'L2': {'score': 0, 'miss': 0},
          'L1': {'score': 0, 'miss': 0},
        },
        'algae': {
          'score': 0,
          'miss': 0,
        },
        'floorStation': {
          'floor': 0,
          'station': 0,
          'miss': 0,
        },
      },
      'endgame': {
        'cageParkStatus': 'None',
        'failed': false,
        'disabled': false,
        'playingDefense': false,
        'comments': '',
      }
    };
  } catch (e) {
    print('Error submitting data: $e');
    rethrow;
  }
}

// variables.dart for Pit Scouting
Map<String, dynamic> pitScoutingData = {
  'robotNum': '',
  'submittedBy': '', 
  'weight': '',
  'size': '',
  'scoringLevels': {
    'L4': false,
    'L3': false, 
    'L2': false,
    'L1': false,
  },
  'bargeScoring': false,
  'climbing': {
    'ability': 'no',
    'cageType': null, // 'Shallow' or 'Deep' if climbing is 'yes'
  },
  'additionalNotes': '',
};

// Function to submit pit scouting data to Firebase
Future<void> submitPitScoutingData() async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null) {
    throw Exception('No user signed in');
  }

  // Add the current user's email to the pitScoutingData
  pitScoutingData['submittedBy'] = currentUser.email ?? 'Unknown';

  final String pitScoutingPath = 'RCR2025/pitScouting/${pitScoutingData['robotNum']}';
  
  try {
    await dbRef.child(pitScoutingPath).set(pitScoutingData);
    
    // Reset pit scouting data after successful submission
    pitScoutingData = {
      'robotNum': '',
      'submittedBy': '', 
      'weight': '',
      'size': '',
      'scoringLevels': {
        'L4': false,
        'L3': false, 
        'L2': false,
        'L1': false,
      },
      'bargeScoring': false,
      'climbing': {
        'ability': 'no',
        'cageType': null,
      },
      'additionalNotes': '',
    };
  } catch (e) {
    print('Error submitting pit scouting data: $e');
    rethrow;
  }
}