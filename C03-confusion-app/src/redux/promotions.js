import * as ActionTypes from './ActionTypes'; // Only comments state must be changed rather than whole app state

export const Promotions = (state = {
  isLoading: true,
  errMess: null,
  promotions: []
}, action) => {
  switch(action.type){
    case ActionTypes.ADD_PROMOS:
      return { ...state,  isLoading: false, errMess: null, promotions: action.payload};
    case ActionTypes.PROMOS_LOADING:
      // We do this becasue maybe we're refereshing content from server.
      return { ...state,  isLoading: true, errMess: null, promotions: []}; // take the same state, then whatever we pass, it will modify that, and then return modified state
    case ActionTypes.PROMOS_FAILED:
      return { ...state,  isLoading: false, errMess: action.payload, promotions: []};
    default:
      return state;
  }
};