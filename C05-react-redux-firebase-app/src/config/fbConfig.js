import firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';

// Initialize Firebase
var config = {
  apiKey: "AIzaSyDR6HPKvxHYa6CeE0o-V11I2kLf02c5WxI",
  authDomain: "tnn-mario-plan.firebaseapp.com",
  databaseURL: "https://tnn-mario-plan.firebaseio.com",
  projectId: "tnn-mario-plan",
  storageBucket: "tnn-mario-plan.appspot.com",
  messagingSenderId: "795621057345"
};
firebase.initializeApp(config);

firebase.firestore().settings({
  //timestampsInSnapshots: true
});

export default firebase;