const IShow = {
  type: String,
  payload: Object,
  show: Boolean,
  key: Number,
  players: Object,
};

const initialState = {
  text: '',
  type: 'info',
  style: 'alert',
  header: '',
  duration: 5000,
};

const notification = (
  state = initialState,
  data = IShow,
) => {
  console.log('Payload: ', JSON.stringify(data.payload));
  switch (data.type) {
    case 'Notify':
      return {
        ...state,
        text: data.payload.text,
        type: data.payload.type,
        style: data.payload.style,
        header: data.payload.header,
        duration: data.payload.duration,
      };
    default:
      return state;
  }
};

export default notification;
