import * as ActionTypes from './ActionTypes';

export const Dishes = (state = {
    isLoading: true,
    errMess: null,
    dishes: []
  }, action) => {
  switch(action.type){
    case ActionTypes.ADD_DISHES:
      return { ...state,  isLoading: false, errMess: null, dishes: action.payload};
    case ActionTypes.DISHES_LOADING:
      // We do this becasue maybe we're refereshing content from server.
      return { ...state,  isLoading: true, errMess: null, dishes: []}; // take the same state, then whatever we pass, it will modify that, and then return modified state
    case ActionTypes.DISHES_FAILED:
      return { ...state,  isLoading: false, errMess: action.payload, dishes: []};
    default:
      return state;
  }
};