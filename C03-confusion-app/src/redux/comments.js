
import * as ActionTypes from './ActionTypes'; // Only comments state must be changed rather than whole app state

export const Comments = (state = {
  errMess: null,
  comments: []
}, action) => {
  switch(action.type){
    case ActionTypes.ADD_COMMENTS:
      return { ...state,  errMess: null, comments: action.payload};
    case ActionTypes.COMMENTS_FAILED:
      return { ...state, errMess: action.payload};
    case ActionTypes.ADD_COMMENT:
      var comment = action.payload;
      // comment.id = state.comments.length; // here state is shared/comments.js
      // comment.date = new Date().toISOString();
      return { ...state, comments: state.comments.concat(comment) }; // This is temp, if we restart app, it will go away
    default:
      return state;
  }
};