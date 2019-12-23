const initState = {
  posts: [
    { id: '1', title: 'sunt aut facere repellat', body: 'quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto' },
    { id: '2', title: 'two aut facere repellat', body: 'two et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto' },
    { id: '3', title: 'three aut facere repellat', body: 'three et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto' },
  ]
};

const rootReducer = (state = initState, action) => {
  // console.log(action);
  if(action.type === 'DELETE_POST'){
    let newPosts = state.posts.filter((post) => post.id !== action.id);
    return {
      ...state,
      posts: newPosts
    };
  }
  return state;
};

export default rootReducer;