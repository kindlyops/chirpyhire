export const allIds = (table) => {
  return (state = [], action) => {
    if (action.payload && action.payload.entities && action.payload.entities[table]) {
      return [
        ...state,
        ...action.payload.result
      ]
    }

    return state;
  }
}
