import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// variables.dart
// Add eventKey to the pageData structure
Map<String, dynamic> pageData = {
  'eventKey': '', // Add this line to store the event key
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

// Add eventKey to the pitScoutingData structure
Map<String, dynamic> pitScoutingData = {
  'eventKey': '', // Add this line to store the event key
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

// Modify the submit functions to use the eventKey
Future<void> submitMatchData() async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null) {
    throw Exception('No user signed in');
  }

  // Add the current user's email to the pageData
  pageData['submittedBy'] = currentUser.email ?? 'Unknown';

  // Use the eventKey from pageData instead of hardcoded 'RCR2025'
  final String matchPath = '${pageData['eventKey']}/matches/${pageData['matchNum']}/${pageData['robotNum']}';
  
  try {
    await dbRef.child(matchPath).set(pageData);
    // Reset the data after successful submission
    pageData = {
      'eventKey': pageData['eventKey'], // Preserve the event key
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

Future<void> submitPitScoutingData() async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null) {
    throw Exception('No user signed in');
  }

  // Add the current user's email to the pitScoutingData
  pitScoutingData['submittedBy'] = currentUser.email ?? 'Unknown';

  // Use the eventKey from pitScoutingData instead of hardcoded 'RCR2025'
  final String pitScoutingPath = '${pitScoutingData['eventKey']}/pitScouting/${pitScoutingData['robotNum']}';
  
  try {
    await dbRef.child(pitScoutingPath).set(pitScoutingData);
    
    // Reset pit scouting data after successful submission
    pitScoutingData = {
      'eventKey': pitScoutingData['eventKey'], // Preserve the event key
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