export const byId = (table) => {
  return (state = {}, action) => {
    if (action.payload && action.payload.entities) {
      return {
        ...state,
        ...action.payload.entities[table]
      }
    }

    return state;
  }
}
