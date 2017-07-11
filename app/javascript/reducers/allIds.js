export const allIds = (table) => {
  return (state = [], action) => {
    if (action.payload && action.payload.entities && action.payload.entities[table]) {
      return Object.keys(action.payload.entities[table]).map(i => parseInt(i));
    }

    return state;
  }
}
