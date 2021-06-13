const IShow = {
  type: String,
  payload: Object,
  show: Boolean,
  key: Number,
  players: Object,
};

const initialState = {
  show: false,
  move: '',
};

const scoreboardData = (
  state = initialState,
  data = IShow,
) => {
  switch (data.type) {
    case 'scoreboardShow':
      return { ...state, show: data.payload.show, players: data.payload.players };
    case 'scoreboardUpdate':
      return { ...state, move: data.payload.move };
    default:
      return state;
  }
};

export default scoreboardData;
