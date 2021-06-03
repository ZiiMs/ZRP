const IShow = {
  type: String,
  payload: Object,
  show: Boolean,
  key: Number,
  players: Object,
};

const initialState = {
  show: false,
};

const scoreboardData = (
  state = initialState,
  data = IShow,
) => {
  switch (data.type) {
    case 'Textbox':
      return { ...state, show: data.payload.show };
    default:
      return state;
  }
};

export default scoreboardData;
