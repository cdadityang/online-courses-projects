export const createProject = (project) => {
  // In thunk we can return fn and not object
  return (dispatch, getState, { getFirebase, getFirestore }) => {
    // make async call to DB
    
    // We need reference to our Firestore DB
    const firestore = getFirestore();
    const profile = getState().firebase.profile;
    const authorId = getState().firebase.auth.uid;
    
    firestore.collection('projects').add({
      ...project,
      authorFirstName: profile.firstName,
      authorLastName: profile.lastName,
      authorId: authorId,
      createdAt: new Date()
    }).then(() => {
      dispatch({
        type: 'CREATE_PROJECT',
        project
      });
    }).catch((err) => {
      dispatch({
        type: 'CREATE_PROJECT_ERROR',
        err
      });
    });
  };
};